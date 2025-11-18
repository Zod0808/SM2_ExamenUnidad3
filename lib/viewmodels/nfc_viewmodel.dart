import 'package:flutter/foundation.dart';
import 'dart:async';
import 'dart:collection';
import '../models/alumno_model.dart';
import '../models/asistencia_model.dart';
import '../models/decision_manual_model.dart';
import '../models/realtime_detection_model.dart';
import '../services/hybrid_api_service.dart';
import '../services/nfc_service.dart';
import '../services/autorizacion_service.dart';
import '../services/realtime_websocket_service.dart';
import '../config/api_config.dart';

class NfcViewModel extends ChangeNotifier {
  final HybridApiService _apiService = HybridApiService();
  final NfcService _nfcService = NfcService();
  final AutorizacionService _autorizacionService = AutorizacionService();
  final RealtimeWebSocketService? _websocketService;

  bool _isScanning = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  AlumnoModel? _scannedAlumno;

  // Información del guardia actual
  String? _guardiaId;
  String? _guardiaNombre;
  String? _puntoControl;

  // Cola para manejar múltiples detecciones
  final Queue<String> _detectionQueue = Queue<String>();
  bool _processingQueue = false;
  List<AlumnoModel> _recentDetections = [];
  Timer? _queueTimer;
  
  // WebSocket para actualizaciones en tiempo real (US060, US019)
  StreamSubscription<Map<String, dynamic>>? _newAccessSubscription;
  bool _isWebSocketConnected = false;
  
  // Lista de detecciones en tiempo real (US019)
  final List<RealtimeDetectionModel> _realtimeDetections = [];

  // Constructor
  NfcViewModel({RealtimeWebSocketService? websocketService})
      : _websocketService = websocketService {
    _initializeWebSocket();
  }

  // Getters
  bool get isScanning => _isScanning;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  AlumnoModel? get scannedAlumno => _scannedAlumno;
  bool get isNfcReady => !_isScanning && !_isLoading;
  List<AlumnoModel> get recentDetections =>
      List.unmodifiable(_recentDetections);
  List<RealtimeDetectionModel> get realtimeDetections =>
      List.unmodifiable(_realtimeDetections);
  int get queueSize => _detectionQueue.length;
  bool get isProcessingQueue => _processingQueue;
  bool get isWebSocketConnected => _isWebSocketConnected;

  // Inicializar WebSocket para actualizaciones en tiempo real (US060)
      Future<void> _initializeWebSocket() async {
        if (_websocketService == null) return;
        
        try {
          await _websocketService!.initialize(
            baseUrl: ApiConfig.baseUrl,
            enableNotifications: true, // Habilitar notificaciones push
          );
      
      // Suscribirse a nuevos accesos en tiempo real (US019)
      _newAccessSubscription = _websocketService!.newAccessStream.listen((data) {
        // Actualizar lista de detecciones en tiempo real cuando hay un nuevo acceso
        debugPrint('📡 Nuevo acceso recibido via WebSocket: $data');
        
        // Si el acceso es del mismo punto de control, agregar a la lista
        if (data['puerta'] == _puntoControl || _puntoControl == null) {
          try {
            final detection = RealtimeDetectionModel.fromJson(data);
            _addRealtimeDetection(detection);
          } catch (e) {
            debugPrint('⚠️ Error procesando detección WebSocket: $e');
          }
        }
      });
      
      // Suscribirse a estado de conexión
      _websocketService!.connectionStatus.listen((connected) {
        _isWebSocketConnected = connected;
        notifyListeners();
      });
      
      _isWebSocketConnected = _websocketService!.isConnected;
      debugPrint('✅ WebSocket inicializado para actualizaciones en tiempo real');
    } catch (e) {
      debugPrint('⚠️ Error inicializando WebSocket: $e');
      _isWebSocketConnected = false;
    }
  }

  // Verificar disponibilidad NFC
  Future<bool> checkNfcAvailability() async {
    try {
      return await _nfcService.isNfcAvailable();
    } catch (e) {
      _setError('Error al verificar NFC: $e');
      return false;
    }
  }

  // Iniciar escaneo NFC con manejo de múltiples detecciones
  Future<void> startNfcScan() async {
    if (_isScanning || _isLoading) return;

    _setScanning(true);
    _clearMessages();
    _scannedAlumno = null;

    try {
      // Verificar NFC disponible
      bool available = await _nfcService.isNfcAvailable();
      if (!available) {
        throw Exception('NFC no está disponible en este dispositivo');
      }

      // Iniciar procesamiento continuo de detecciones NFC
      await _startContinuousNfcDetection();
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setScanning(false);
    }
  }

  // Iniciar detección continua de NFC
  Future<void> _startContinuousNfcDetection() async {
    _startQueueProcessor();

    // Simular detecciones múltiples (en implementación real sería el NFC real)
    _queueTimer = Timer.periodic(Duration(seconds: 2), (timer) async {
      if (!_isScanning) {
        timer.cancel();
        return;
      }

      // Simular detección de múltiples tags
      await _simulateMultipleDetections();
    });
  }

  // Simular múltiples detecciones NFC para demostración
  Future<void> _simulateMultipleDetections() async {
    // En implementación real, esto vendría del NFC hardware
    List<String> simulatedTags = ['EST001', 'EST002', 'EST003'];

    for (String tagCode in simulatedTags) {
      if (DateTime.now().millisecond % 3 == 0) {
        // Simulación aleatoria
        _addToDetectionQueue(tagCode);
      }
    }
  }

  // Añadir detección a la cola de procesamiento
  void _addToDetectionQueue(String codigoUniversitario) {
    if (!_detectionQueue.contains(codigoUniversitario)) {
      _detectionQueue.addLast(codigoUniversitario);
      notifyListeners();
    }
  }

  // Iniciar procesador de cola
  void _startQueueProcessor() {
    if (_processingQueue) return;

    _processingQueue = true;
    _processDetectionQueue();
  }

  // Procesar cola de detecciones secuencialmente
  Future<void> _processDetectionQueue() async {
    while (_detectionQueue.isNotEmpty && _isScanning) {
      final codigoUniversitario = _detectionQueue.removeFirst();
      await _processingleDetection(codigoUniversitario);
      notifyListeners();

      // Pequeña pausa entre procesamiento de detecciones
      await Future.delayed(Duration(milliseconds: 500));
    }

    _processingQueue = false;
  }

  // Procesar una detección individual con verificación avanzada (US022-US030)
  Future<void> _processingleDetection(String codigoUniversitario) async {
    try {
      _setLoading(true);

      // Validar alumno en el servidor
      AlumnoModel alumno = await _apiService.getAlumnoByCodigo(
        codigoUniversitario,
      );

      // Realizar verificación completa del estudiante (US022)
      final verificacion = await verificarEstudianteCompleto(alumno);

      if (verificacion['puede_acceder'] == true) {
        // Determinar tipo de acceso inteligente (US028)
        final tipoAcceso = await determinarTipoAccesoInteligente(alumno.dni);

        // Registrar asistencia completa automáticamente
        await registrarAsistenciaCompleta(alumno, tipoAcceso);

        // Añadir a detecciones recientes
        _recentDetections.insert(0, alumno);
        if (_recentDetections.length > 10) {
          _recentDetections = _recentDetections.take(10).toList();
        }

        // Agregar a detecciones en tiempo real (US019)
        final detection = RealtimeDetectionModel.fromAlumno(
          alumno,
          tipoAcceso,
          _puntoControl ?? 'Principal',
          _guardiaId,
          _guardiaNombre,
        );
        _addRealtimeDetection(detection);

        _setSuccess(
          '✅ Acceso $tipoAcceso autorizado: ${alumno.nombreCompleto}',
        );
        _scannedAlumno = alumno;
      } else {
        // El estudiante requiere autorización manual (US023-US024)
        _setError('⚠️ Requiere autorización manual: ${verificacion['razon']}');
        _scannedAlumno = alumno; // Mantener para mostrar en UI de verificación

        // El UI deberá mostrar StudentVerificationView para decisión manual
      }
    } catch (e) {
      _setError('Error procesando ${codigoUniversitario}: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Detener escaneo NFC
  Future<void> stopNfcScan() async {
    if (!_isScanning) return;

    try {
      await _nfcService.stopNfcSession();
    } catch (e) {
      // Ignorar errores al detener
    }

    // Limpiar timers y cola
    _queueTimer?.cancel();
    _queueTimer = null;
    _detectionQueue.clear();
    _processingQueue = false;

    _setScanning(false);
    _clearMessages();
  }

  // Limpiar detecciones recientes
  void clearRecentDetections() {
    _recentDetections.clear();
    notifyListeners();
  }

  // Agregar detección en tiempo real (US019)
  void _addRealtimeDetection(RealtimeDetectionModel detection) {
    _realtimeDetections.insert(0, detection);
    // Mantener solo últimas 50 detecciones
    if (_realtimeDetections.length > 50) {
      _realtimeDetections.removeRange(50, _realtimeDetections.length);
    }
    notifyListeners();
  }

  // Limpiar detecciones en tiempo real
  void clearRealtimeDetections() {
    _realtimeDetections.clear();
    notifyListeners();
  }

  // Limpiar datos
  void clearScan() {
    _scannedAlumno = null;
    _clearMessages();
    notifyListeners();
  }

  // Métodos privados
  void _setScanning(bool scanning) {
    _isScanning = scanning;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _successMessage = null;
    notifyListeners();
  }

  void _setSuccess(String success) {
    _successMessage = success;
    _errorMessage = null;
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  // ==================== NUEVOS MÉTODOS PARA US022-US030 ====================

  // Configurar información del guardia
  void configurarGuardia(
    String guardiaId,
    String guardiaNombre,
    String puntoControl,
  ) {
    _guardiaId = guardiaId;
    _guardiaNombre = guardiaNombre;
    _puntoControl = puntoControl;
  }

  // Verificación avanzada del estudiante (US022)
  Future<Map<String, dynamic>> verificarEstudianteCompleto(
    AlumnoModel estudiante,
  ) async {
    try {
      // Usar el servicio de autorización para verificación completa
      return await _autorizacionService.verificarEstadoEstudiante(estudiante);
    } catch (e) {
      return {
        'puede_acceder': false,
        'razon': 'Error en verificación: $e',
        'requiere_autorizacion_manual': true,
      };
    }
  }

  // Determinar tipo de acceso inteligente (US028)
  Future<String> determinarTipoAccesoInteligente(String estudianteDni) async {
    try {
      return await _autorizacionService.determinarTipoAcceso(estudianteDni);
    } catch (e) {
      debugPrint('Error determinando tipo acceso: $e');
      return 'entrada';
    }
  }

  // Registrar asistencia mejorada con toda la información (US025-US030)
  Future<void> registrarAsistenciaCompleta(
    AlumnoModel estudiante,
    String tipoAcceso, {
    DecisionManualModel? decisionManual,
  }) async {
    try {
      final now = DateTime.now();

      final asistencia = AsistenciaModel(
        id: now.millisecondsSinceEpoch.toString(),
        nombre: estudiante.nombre,
        apellido: estudiante.apellido,
        dni: estudiante.dni,
        codigoUniversitario: estudiante.codigoUniversitario,
        siglasFacultad: estudiante.siglasFacultad,
        siglasEscuela: estudiante.siglasEscuela,
        tipo: TipoMovimiento.fromString(tipoAcceso) ?? TipoMovimiento.entrada,
        fechaHora: now,
        entradaTipo: 'nfc',
        puerta: _puntoControl ?? 'Desconocida',
        // Nuevos campos US025
        guardiaId: _guardiaId,
        guardiaNombre: _guardiaNombre,
        autorizacionManual: decisionManual != null,
        razonDecision: decisionManual?.razon,
        timestampDecision: decisionManual?.timestamp,
        // US029 - Ubicación
        descripcionUbicacion:
            'Punto de control: ${_puntoControl ?? "No especificado"}',
      );

      // Registrar asistencia completa
      await _apiService.registrarAsistenciaCompleta(asistencia);

      // Actualizar control de presencia (US026-US030)
      await _apiService.actualizarPresencia(
        estudiante.dni,
        tipoAcceso,
        _puntoControl ?? 'Desconocido',
        _guardiaId ?? '',
      );

      _setSuccess('Acceso ${tipoAcceso} registrado correctamente');
    } catch (e) {
      _setError('Error al registrar asistencia: $e');
      rethrow;
    }
  }

  // Callback para cuando se toma una decisión manual
  Future<void> onDecisionManualTomada(DecisionManualModel decision) async {
    try {
      if (decision.autorizado && _scannedAlumno != null) {
        // Si se autorizó, registrar la asistencia
        await registrarAsistenciaCompleta(
          _scannedAlumno!,
          decision.tipoAcceso,
          decisionManual: decision,
        );
      }

      // Limpiar el estudiante escaneado
      _scannedAlumno = null;
      notifyListeners();
    } catch (e) {
      _setError('Error procesando decisión manual: $e');
    }
  }

  // Getters para información del guardia
  String? get guardiaId => _guardiaId;
  String? get guardiaNombre => _guardiaNombre;
  String? get puntoControl => _puntoControl;

  @override
  void dispose() {
    _queueTimer?.cancel();
    _newAccessSubscription?.cancel();
    _websocketService?.dispose();
    _realtimeDetections.clear();
    super.dispose();
  }
}
