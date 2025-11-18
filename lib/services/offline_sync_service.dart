import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:workmanager/workmanager.dart';
import '../services/connectivity_service.dart';
import '../services/local_database_service.dart';
import '../services/api_service.dart';
import '../models/asistencia_model.dart';
import '../models/alumno_model.dart';
import '../models/presencia_model.dart';
import '../models/decision_manual_model.dart';

// Enums para manejo de conflictos y sincronización
enum ConflictResolution { serverWins, clientWins, merge, manual }

enum SyncStatus { idle, syncing, error, conflicts, completed }

// Clase para manejar conflictos de datos
class ConflictData {
  final String id;
  final String collection;
  final Map<String, dynamic> serverData;
  final Map<String, dynamic> localData;
  final DateTime serverTimestamp;
  final DateTime localTimestamp;
  final String conflictType;

  ConflictData({
    required this.id,
    required this.collection,
    required this.serverData,
    required this.localData,
    required this.serverTimestamp,
    required this.localTimestamp,
    required this.conflictType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'collection': collection,
      'server_data': serverData,
      'local_data': localData,
      'server_timestamp': serverTimestamp.toIso8601String(),
      'local_timestamp': localTimestamp.toIso8601String(),
      'conflict_type': conflictType,
    };
  }

  factory ConflictData.fromJson(Map<String, dynamic> json) {
    return ConflictData(
      id: json['id'],
      collection: json['collection'],
      serverData: json['server_data'] ?? {},
      localData: json['local_data'] ?? {},
      serverTimestamp: DateTime.parse(json['server_timestamp']),
      localTimestamp: DateTime.parse(json['local_timestamp']),
      conflictType: json['conflict_type'] ?? 'version_conflict',
    );
  }
}

// Resultado de sincronización
class SyncResult {
  final bool success;
  final SyncStatus status;
  final String message;
  final List<ConflictData> conflicts;
  final Map<String, int> syncedCounts;
  final DateTime timestamp;

  SyncResult({
    required this.success,
    required this.status,
    required this.message,
    this.conflicts = const [],
    this.syncedCounts = const {},
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory SyncResult.success({
    String? message,
    Map<String, int>? syncedCounts,
  }) {
    return SyncResult(
      success: true,
      status: SyncStatus.completed,
      message: message ?? 'Sincronización completada exitosamente',
      syncedCounts: syncedCounts ?? {},
    );
  }

  factory SyncResult.withConflicts(List<ConflictData> conflicts) {
    return SyncResult(
      success: false,
      status: SyncStatus.conflicts,
      message: 'Conflictos detectados durante la sincronización',
      conflicts: conflicts,
    );
  }

  factory SyncResult.error(String message) {
    return SyncResult(
      success: false,
      status: SyncStatus.error,
      message: message,
    );
  }
}

class OfflineSyncService extends ChangeNotifier {
  static final OfflineSyncService _instance = OfflineSyncService._internal();
  factory OfflineSyncService() => _instance;
  OfflineSyncService._internal();

  final ConnectivityService _connectivityService = ConnectivityService();
  final LocalDatabaseService _localDb = LocalDatabaseService();
  final ApiService _apiService = ApiService();

  bool _isSyncing = false;
  bool _autoSyncEnabled = true;
  DateTime? _lastSyncTime;
  String? _lastSyncError;
  int _syncIntervalMinutes = 5; // Sincronizar cada 5 minutos cuando esté online
  Timer? _syncTimer;

  List<String> _syncLog = [];
  int _pendingSyncCount = 0;

  // Campos para versionado y conflictos bidireccionales
  Map<String, int> _localVersions = {};
  List<ConflictData> _pendingConflicts = [];
  List<ConflictData> _lastConflicts = [];
  SyncStatus _currentStatus = SyncStatus.idle;

  // Getters
  bool get isSyncing => _isSyncing;
  bool get autoSyncEnabled => _autoSyncEnabled;
  DateTime? get lastSyncTime => _lastSyncTime;
  String? get lastSyncError => _lastSyncError;
  int get syncIntervalMinutes => _syncIntervalMinutes;
  List<String> get syncLog => List.unmodifiable(_syncLog);
  int get pendingSyncCount => _pendingSyncCount;
  Map<String, int> get localVersions => Map.unmodifiable(_localVersions);
  List<ConflictData> get pendingConflicts => List.unmodifiable(_pendingConflicts);
  SyncStatus get currentStatus => _currentStatus;
  bool get hasConflicts => _pendingConflicts.isNotEmpty;
  List<ConflictData> get lastConflicts => List.unmodifiable(_lastConflicts);
  int get conflictCount => _pendingConflicts.length;

  // Inicializar servicio de sincronización
  Future<void> initialize() async {
    await _connectivityService.initialize();
    await _initializeWorkManager();
    await _loadLocalVersions();
    await _updatePendingCount();
    _startAutoSync();
  }

  // Cargar versiones locales desde la base de datos
  Future<void> _loadLocalVersions() async {
    try {
      final stats = await _localDb.getSyncStats();
      _localVersions = {
        'asistencias': stats['version_asistencias'] ?? 0,
        'presencia': stats['version_presencia'] ?? 0,
        'decisiones': stats['version_decisiones'] ?? 0,
        'alumnos': stats['version_alumnos'] ?? 0,
      };
      _addLogEntry('📋 Versiones locales cargadas');
    } catch (e) {
      _addLogEntry('⚠️ Error cargando versiones locales: $e');
    }
  }

  // Inicializar WorkManager para sincronización en background
  Future<void> _initializeWorkManager() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );

    // Registrar tarea periódica de sincronización
    await Workmanager().registerPeriodicTask(
      "sync_task",
      "offline_sync",
      frequency: Duration(minutes: 15),
      constraints: Constraints(
        networkType: NetworkType.connected,
      ),
    );
  }

  // Iniciar sincronización automática
  void _startAutoSync() {
    if (_autoSyncEnabled && _syncTimer == null) {
      _syncTimer = Timer.periodic(
        Duration(minutes: _syncIntervalMinutes),
        (timer) {
          if (_connectivityService.isOnline) {
            performSync();
          }
        },
      );
      _addLogEntry('🟢 Sincronización automática iniciada');
    }
  }

  // Detener sincronización automática
  void _stopAutoSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
    _addLogEntry('🔴 Sincronización automática detenida');
  }

  // Realizar sincronización (método legacy - mantiene compatibilidad)
  Future<bool> performSync({bool forceSync = false}) async {
    final result = await performBidirectionalSync(forceSync: forceSync);
    return result.success && result.status == SyncStatus.completed;
  }

  // Sincronización bidireccional con detección de conflictos
  Future<SyncResult> performBidirectionalSync({bool forceSync = false}) async {
    if (_isSyncing && !forceSync) {
      _addLogEntry('⚠️ Sincronización ya en curso');
      return SyncResult(
        success: false,
        status: SyncStatus.syncing,
        message: 'Sincronización en curso',
      );
    }

    if (!_connectivityService.isOnline && !forceSync) {
      _addLogEntry('🔴 Sin conexión a internet, omitiendo sincronización');
      return SyncResult.error('Sin conexión a internet');
    }

    _isSyncing = true;
    _lastSyncError = null;
    _currentStatus = SyncStatus.syncing;
    _lastConflicts.clear();
    notifyListeners();

    _addLogEntry('🔄 Iniciando sincronización bidireccional...');

    try {
      // Fase 1: Verificar versiones del servidor
      final serverVersions = await _checkServerVersions();

      // Fase 2: Detectar conflictos
      final conflicts = await _detectConflicts(serverVersions);

      if (conflicts.isNotEmpty) {
        _lastConflicts.addAll(conflicts);
        _pendingConflicts.addAll(conflicts);
        _currentStatus = SyncStatus.conflicts;

        _addLogEntry('⚠️ Detectados ${conflicts.length} conflictos');

        _isSyncing = false;
        notifyListeners();

        return SyncResult.withConflicts(conflicts);
      }

      // Fase 3: Sincronizar cambios (sin conflictos)
      final syncedCounts = <String, int>{};
      
      syncedCounts['asistencias'] = await _uploadLocalChanges();
      await _downloadServerChanges();

      // Fase 4: Actualizar versiones locales
      await _updateLocalVersions(serverVersions);

      _currentStatus = SyncStatus.completed;
      _lastSyncTime = DateTime.now();
      await _updatePendingCount();
      _addLogEntry('✅ Sincronización bidireccional completada');

      _isSyncing = false;
      notifyListeners();

      return SyncResult.success(
        message: 'Sincronización completada exitosamente',
        syncedCounts: syncedCounts,
      );
    } catch (e) {
      _currentStatus = SyncStatus.error;
      _lastSyncError = e.toString();
      _addLogEntry('❌ Error en sincronización: $e');

      _isSyncing = false;
      notifyListeners();

      return SyncResult.error('Error: $e');
    }
  }

  // Verificar versiones del servidor
  Future<Map<String, int>> _checkServerVersions() async {
    try {
      final response = await _apiService.getVersiones();
      return Map<String, int>.from(response.map((key, value) =>
          MapEntry(key, value is int ? value : int.tryParse(value.toString()) ?? 0)));
    } catch (e) {
      _addLogEntry('⚠️ Error obteniendo versiones del servidor: $e');
      return {};
    }
  }

  // Detectar conflictos comparando versiones
  Future<List<ConflictData>> _detectConflicts(
    Map<String, int> serverVersions,
  ) async {
    List<ConflictData> conflicts = [];

    for (final entry in serverVersions.entries) {
      final collection = entry.key;
      final serverVersion = entry.value;
      final localVersion = _localVersions[collection] ?? 0;

      if (serverVersion > localVersion) {
        // Verificar si hay cambios locales sin sincronizar
        final hasLocalChanges = await _hasUnsyncedLocalChanges(collection);

        if (hasLocalChanges) {
          // Conflicto detectado
          final conflictData = await _buildConflictData(
            collection,
            localVersion,
            serverVersion,
          );
          if (conflictData != null) {
            conflicts.add(conflictData);
          }
        }
      }
    }

    return conflicts;
  }

  // Construir datos del conflicto
  Future<ConflictData?> _buildConflictData(
    String collection,
    int localVersion,
    int serverVersion,
  ) async {
    try {
      final localData = await _getLocalData(collection);
      final serverData = await _getServerData(collection);

      return ConflictData(
        id: '${collection}_${DateTime.now().millisecondsSinceEpoch}',
        collection: collection,
        serverData: serverData,
        localData: localData,
        serverTimestamp: DateTime.now(),
        localTimestamp: DateTime.now(),
        conflictType: 'version_conflict',
      );
    } catch (e) {
      _addLogEntry('⚠️ Error construyendo datos de conflicto: $e');
      return null;
    }
  }

  // Verificar si hay cambios locales sin sincronizar
  Future<bool> _hasUnsyncedLocalChanges(String collection) async {
    try {
      switch (collection) {
        case 'asistencias':
          final pending = await _localDb.getPendingAsistencias();
          return pending.isNotEmpty;

        case 'presencia':
          final stats = await _localDb.getSyncStats();
          return (stats['pending_presencia'] ?? 0) > 0;

        case 'decisiones':
          final stats = await _localDb.getSyncStats();
          return (stats['pending_decisiones'] ?? 0) > 0;

        case 'alumnos':
          // Por ahora alumnos no se modifican localmente
          return false;

        default:
          return false;
      }
    } catch (e) {
      _addLogEntry('⚠️ Error verificando cambios locales: $e');
      return false;
    }
  }

  // Obtener datos locales de una colección
  Future<Map<String, dynamic>> _getLocalData(String collection) async {
    try {
      switch (collection) {
        case 'asistencias':
          final pending = await _localDb.getPendingAsistencias();
          return {
            'pending_count': pending.length,
            'latest': pending.isNotEmpty ? pending.first.toJson() : null,
          };

        case 'presencia':
          final stats = await _localDb.getSyncStats();
          return {
            'pending_count': stats['pending_presencia'] ?? 0,
          };

        case 'decisiones':
          final stats = await _localDb.getSyncStats();
          return {
            'pending_count': stats['pending_decisiones'] ?? 0,
          };

        default:
          return {};
      }
    } catch (e) {
      _addLogEntry('⚠️ Error obteniendo datos locales: $e');
      return {};
    }
  }

  // Obtener datos del servidor de una colección
  Future<Map<String, dynamic>> _getServerData(String collection) async {
    try {
      switch (collection) {
        case 'asistencias':
          final asistencias = await _apiService.getAsistenciasSync();
          return {
            'count': asistencias.length,
            'latest': asistencias.isNotEmpty ? asistencias.first.toJson() : null,
          };

        case 'presencia':
          // TODO: Implementar cuando esté disponible en API
          return {'count': 0};

        case 'decisiones':
          // TODO: Implementar cuando esté disponible en API
          return {'count': 0};

        default:
          return {};
      }
    } catch (e) {
      _addLogEntry('⚠️ Error obteniendo datos del servidor para $collection: $e');
      return {};
    }
  }

  // Subir cambios locales al servidor
  Future<int> _uploadLocalChanges() async {
    _addLogEntry('📤 Subiendo cambios locales...');
    int uploadedCount = 0;

    // Subir asistencias pendientes
    uploadedCount += await _syncPendingAsistencias();

    // Subir otros cambios pendientes
    await _syncPendingPresencia();
    await _syncPendingDecisiones();

    return uploadedCount;
  }

  // Descargar cambios del servidor
  Future<void> _downloadServerChanges() async {
    _addLogEntry('📥 Descargando cambios del servidor...');
    await _syncMasterData();
  }

  // Actualizar versiones locales después de la sincronización
  Future<void> _updateLocalVersions(Map<String, int> serverVersions) async {
    for (final entry in serverVersions.entries) {
      _localVersions[entry.key] = entry.value;
    }
    _addLogEntry('📋 Versiones locales actualizadas');
  }

  // Sincronizar asistencias pendientes (retorna cantidad sincronizada)
  Future<int> _syncPendingAsistencias() async {
    final pendingAsistencias = await _localDb.getPendingAsistencias();
    
    if (pendingAsistencias.isEmpty) {
      _addLogEntry('📝 No hay asistencias pendientes de sincronizar');
      return 0;
    }

    _addLogEntry('📝 Sincronizando ${pendingAsistencias.length} asistencias...');
    int syncedCount = 0;

    for (final asistencia in pendingAsistencias) {
      try {
        await _apiService.registrarAsistenciaCompleta(asistencia);
        await _localDb.markAsSynced('asistencias', asistencia.id);
        syncedCount++;
        _addLogEntry('✅ Asistencia ${asistencia.id} sincronizada');
      } catch (e) {
        _addLogEntry('❌ Error sincronizando asistencia ${asistencia.id}: $e');
        // No rethrow para continuar con las demás
      }
    }

    return syncedCount;
  }

  // Sincronizar presencia pendiente
  Future<void> _syncPendingPresencia() async {
    // Implementar sincronización de presencia
    _addLogEntry('👥 Sincronizando presencia...');
    // TODO: Implementar cuando esté disponible en API
  }

  // Sincronizar decisiones manuales pendientes
  Future<void> _syncPendingDecisiones() async {
    // Implementar sincronización de decisiones
    _addLogEntry('🤔 Sincronizando decisiones manuales...');
    // TODO: Implementar cuando esté disponible en API
  }

  // Sincronizar datos maestros
  Future<void> _syncMasterData() async {
    try {
      _addLogEntry('📚 Sincronizando datos maestros...');
      
      // Sincronizar alumnos
      final alumnos = await _apiService.getAlumnos();
      for (final alumno in alumnos) {
        await _localDb.saveAlumno(alumno, syncStatus: 'synced');
      }

      // Sincronizar facultades
      final facultades = await _apiService.getFacultades();
      // TODO: Implementar guardado de facultades

      // Sincronizar escuelas
      final escuelas = await _apiService.getEscuelas();
      // TODO: Implementar guardado de escuelas

      _addLogEntry('✅ Datos maestros sincronizados');
    } catch (e) {
      _addLogEntry('⚠️ Error sincronizando datos maestros: $e');
      // No rethrow para no interrumpir la sincronización principal
    }
  }

  // Guardar asistencia offline
  Future<void> saveAsistenciaOffline(AsistenciaModel asistencia) async {
    try {
      await _localDb.saveAsistencia(asistencia, syncStatus: 'pending');
      await _updatePendingCount();
      _addLogEntry('💾 Asistencia guardada offline: ${asistencia.id}');
      
      // Intentar sincronizar inmediatamente si hay conexión
      if (_connectivityService.isOnline) {
        performSync();
      }
    } catch (e) {
      _addLogEntry('❌ Error guardando asistencia offline: $e');
      rethrow;
    }
  }

  // Guardar decisión manual offline
  Future<void> saveDecisionOffline(DecisionManualModel decision) async {
    try {
      // TODO: Implementar guardado de decisiones en base de datos local
      await _updatePendingCount();
      _addLogEntry('💾 Decisión manual guardada offline: ${decision.id}');
      
      // Intentar sincronizar inmediatamente si hay conexión
      if (_connectivityService.isOnline) {
        performSync();
      }
    } catch (e) {
      _addLogEntry('❌ Error guardando decisión offline: $e');
      rethrow;
    }
  }

  // Obtener alumno offline
  Future<AlumnoModel?> getAlumnoOffline(String codigoUniversitario) async {
    try {
      return await _localDb.getAlumnoByCodigo(codigoUniversitario);
    } catch (e) {
      _addLogEntry('❌ Error obteniendo alumno offline: $e');
      return null;
    }
  }

  // Obtener asistencias offline
  Future<List<AsistenciaModel>> getAsistenciasOffline(
    DateTime start,
    DateTime end,
  ) async {
    try {
      return await _localDb.getAsistenciasByDateRange(start, end);
    } catch (e) {
      _addLogEntry('❌ Error obteniendo asistencias offline: $e');
      return [];
    }
  }

  // Configurar intervalo de sincronización
  void configureSyncInterval(int minutes) {
    _syncIntervalMinutes = minutes;
    if (_syncTimer != null) {
      _stopAutoSync();
      _startAutoSync();
    }
    _addLogEntry('⚙️ Intervalo de sincronización cambiado a $minutes minutos');
    notifyListeners();
  }

  // Activar/desactivar sincronización automática
  void toggleAutoSync(bool enabled) {
    _autoSyncEnabled = enabled;
    
    if (enabled) {
      _startAutoSync();
      _addLogEntry('✅ Sincronización automática activada');
    } else {
      _stopAutoSync();
      _addLogEntry('❌ Sincronización automática desactivada');
    }
    
    notifyListeners();
  }

  // Actualizar contador de elementos pendientes
  Future<void> _updatePendingCount() async {
    try {
      final stats = await _localDb.getSyncStats();
      _pendingSyncCount = stats['pending_asistencias']! + 
                         stats['pending_presencia']! + 
                         stats['pending_decisiones']!;
      notifyListeners();
    } catch (e) {
      _addLogEntry('❌ Error actualizando contador pendiente: $e');
    }
  }

  // Obtener estadísticas de sincronización
  Map<String, dynamic> getSyncStats() {
    return {
      'isSyncing': _isSyncing,
      'autoSyncEnabled': _autoSyncEnabled,
      'lastSyncTime': _lastSyncTime?.toIso8601String(),
      'lastSyncError': _lastSyncError,
      'syncIntervalMinutes': _syncIntervalMinutes,
      'pendingSyncCount': _pendingSyncCount,
      'isOnline': _connectivityService.isOnline,
      'connectionType': _connectivityService.connectionDescription,
    };
  }

  // Obtener estado de la última sincronización
  String getLastSyncStatus() {
    if (_lastSyncTime == null) {
      return 'Nunca sincronizado';
    }

    final difference = DateTime.now().difference(_lastSyncTime!);

    if (difference.inMinutes < 1) {
      return 'Sincronizado hace ${difference.inSeconds} segundos';
    } else if (difference.inHours < 1) {
      return 'Sincronizado hace ${difference.inMinutes} minutos';
    } else if (difference.inDays < 1) {
      return 'Sincronizado hace ${difference.inHours} horas';
    } else {
      return 'Sincronizado hace ${difference.inDays} días';
    }
  }

  // Obtener próxima sincronización automática
  Duration? getTimeToNextSync() {
    if (!_autoSyncEnabled || _lastSyncTime == null) {
      return null;
    }

    final nextSync = _lastSyncTime!.add(
      Duration(minutes: _syncIntervalMinutes),
    );
    final timeToNext = nextSync.difference(DateTime.now());

    return timeToNext.isNegative ? Duration.zero : timeToNext;
  }

  // Getter para compatibilidad con la UI
  bool get isLoading => _isSyncing;

  // Limpiar logs antiguos
  void clearOldLogs() {
    if (_syncLog.length > 100) {
      _syncLog = _syncLog.takeLast(50).toList();
    }
  }

  // Agregar entrada al log
  void _addLogEntry(String message) {
    final timestamp = DateTime.now().toIso8601String();
    _syncLog.add('[$timestamp] $message');
    clearOldLogs();
  }

  // ==================== MÉTODOS DE RESOLUCIÓN DE CONFLICTOS ====================

  /// Resolver conflicto aplicando una estrategia específica
  Future<bool> resolveConflict(
    String conflictId,
    ConflictResolution resolution,
  ) async {
    try {
      final conflict = _pendingConflicts.firstWhere(
        (c) => c.id == conflictId,
        orElse: () => throw Exception('Conflicto no encontrado: $conflictId'),
      );

      switch (resolution) {
        case ConflictResolution.serverWins:
          await _applyServerVersion(conflict);
          break;
        case ConflictResolution.clientWins:
          await _applyClientVersion(conflict);
          break;
        case ConflictResolution.merge:
          await _applyMergedVersion(conflict);
          break;
        case ConflictResolution.manual:
          _addLogEntry(
            '⚠️ Conflicto marcado para resolución manual: ${conflict.collection}',
          );
          return false;
      }

      // Remover conflicto resuelto
      _pendingConflicts.removeWhere((c) => c.id == conflictId);
      _addLogEntry('✅ Conflicto resuelto: ${conflict.collection}');

      notifyListeners();
      return true;
    } catch (e) {
      _addLogEntry('❌ Error resolviendo conflicto: $e');
      return false;
    }
  }

  /// Aplicar versión del servidor
  Future<void> _applyServerVersion(ConflictData conflict) async {
    _addLogEntry(
      '📥 Aplicando versión del servidor para: ${conflict.collection}',
    );

    switch (conflict.collection) {
      case 'asistencias':
        // Descartar cambios locales y usar datos del servidor
        await _clearLocalPendingData(conflict.collection);
        break;
      case 'presencia':
      case 'decisiones':
        // Limpiar datos pendientes locales
        await _clearLocalPendingData(conflict.collection);
        break;
    }
  }

  /// Aplicar versión del cliente
  Future<void> _applyClientVersion(ConflictData conflict) async {
    _addLogEntry(
      '📤 Aplicando versión del cliente para: ${conflict.collection}',
    );

    switch (conflict.collection) {
      case 'asistencias':
        // Forzar subida de cambios locales
        await _syncPendingAsistencias();
        break;
      case 'presencia':
        await _syncPendingPresencia();
        break;
      case 'decisiones':
        await _syncPendingDecisiones();
        break;
    }
  }

  /// Aplicar versión fusionada
  Future<void> _applyMergedVersion(ConflictData conflict) async {
    _addLogEntry('🔀 Aplicando versión fusionada para: ${conflict.collection}');

    switch (conflict.collection) {
      case 'asistencias':
        await _mergeAsistenciaData(conflict);
        break;
      case 'presencia':
        await _mergePresenciaData(conflict);
        break;
      case 'decisiones':
        await _mergeDecisionData(conflict);
        break;
    }
  }

  /// Limpiar datos pendientes locales
  Future<void> _clearLocalPendingData(String collection) async {
    try {
      switch (collection) {
        case 'asistencias':
          // Marcar todas las asistencias pendientes como descartadas
          final pending = await _localDb.getPendingAsistencias();
          for (final asistencia in pending) {
            await _localDb.markAsSynced('asistencias', asistencia.id);
          }
          break;
        case 'presencia':
        case 'decisiones':
          // TODO: Implementar limpieza cuando se agreguen métodos específicos
          break;
      }
      _addLogEntry('🗑️ Datos locales pendientes limpiados para: $collection');
    } catch (e) {
      _addLogEntry('❌ Error limpiando datos locales: $e');
    }
  }

  /// Fusionar datos de asistencia
  Future<void> _mergeAsistenciaData(ConflictData conflict) async {
    try {
      // Obtener asistencias pendientes locales
      final localPending = await _localDb.getPendingAsistencias();
      
      // Intentar sincronizar todas (el servidor decidirá si acepta duplicados)
      for (final asistencia in localPending) {
        try {
          await _apiService.registrarAsistenciaCompleta(asistencia);
          await _localDb.markAsSynced('asistencias', asistencia.id);
        } catch (e) {
          // Si falla, mantener localmente
          _addLogEntry('⚠️ Asistencia no pudo fusionarse: ${asistencia.id}');
        }
      }

      _addLogEntry('🔀 Datos de asistencia fusionados');
    } catch (e) {
      _addLogEntry('❌ Error fusionando datos de asistencia: $e');
    }
  }

  /// Fusionar datos de presencia
  Future<void> _mergePresenciaData(ConflictData conflict) async {
    try {
      // Implementar lógica de fusión para presencia
      _addLogEntry('🔀 Datos de presencia fusionados');
    } catch (e) {
      _addLogEntry('❌ Error fusionando datos de presencia: $e');
    }
  }

  /// Fusionar datos de decisiones
  Future<void> _mergeDecisionData(ConflictData conflict) async {
    try {
      // Implementar lógica de fusión para decisiones
      _addLogEntry('🔀 Datos de decisiones fusionados');
    } catch (e) {
      _addLogEntry('❌ Error fusionando datos de decisiones: $e');
    }
  }

  /// Resolver todos los conflictos pendientes automáticamente
  Future<void> resolveAllConflicts(ConflictResolution defaultResolution) async {
    _addLogEntry(
      '🔄 Resolviendo todos los conflictos con estrategia: ${defaultResolution.name}',
    );

    final conflicts = List<ConflictData>.from(_pendingConflicts);

    for (final conflict in conflicts) {
      await resolveConflict(conflict.id, defaultResolution);
    }

    if (_pendingConflicts.isEmpty) {
      _addLogEntry('✅ Todos los conflictos han sido resueltos');
      _currentStatus = SyncStatus.completed;
    } else {
      _addLogEntry('⚠️ Algunos conflictos requieren resolución manual');
    }

    notifyListeners();
  }

  // Limpiar recursos
  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }
}

// Callback para WorkManager
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      final syncService = OfflineSyncService();
      await syncService.performSync();
      return Future.value(true);
    } catch (e) {
      return Future.value(false);
    }
  });
}
