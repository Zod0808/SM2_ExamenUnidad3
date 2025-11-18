import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'push_notification_service.dart';

/// Servicio WebSocket para actualizaciones en tiempo real
/// US060 - Actualizaciones tiempo real
class RealtimeWebSocketService {
  IO.Socket? _socket;
  String? _baseUrl;
  bool _isConnected = false;
  
  // Medición de latencia
  final List<Duration> _latencyMeasurements = [];
  static const int maxLatencyMeasurements = 100;
  
  // Streams para eventos
  final _connectionStatusController = StreamController<bool>.broadcast();
  final _metricsController = StreamController<Map<String, dynamic>>.broadcast();
  final _newAccessController = StreamController<Map<String, dynamic>>.broadcast();
  final _hourlyDataController = StreamController<Map<String, dynamic>>.broadcast();
  final _errorController = StreamController<String>.broadcast();
  final _latencyController = StreamController<Duration>.broadcast();
  
  // Servicio de notificaciones
  final PushNotificationService _notificationService = PushNotificationService();
  
  // Getters de streams
  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  Stream<Map<String, dynamic>> get metricsStream => _metricsController.stream;
  Stream<Map<String, dynamic>> get newAccessStream => _newAccessController.stream;
  Stream<Map<String, dynamic>> get hourlyDataStream => _hourlyDataController.stream;
  Stream<String> get errorStream => _errorController.stream;
  Stream<Duration> get latencyStream => _latencyController.stream;
  
  bool get isConnected => _isConnected;
  
  // Métricas de latencia
  Duration get averageLatency {
    if (_latencyMeasurements.isEmpty) return Duration.zero;
    final total = _latencyMeasurements.fold<int>(
      0,
      (sum, duration) => sum + duration.inMilliseconds,
    );
    return Duration(milliseconds: total ~/ _latencyMeasurements.length);
  }
  
  Duration get maxLatency {
    if (_latencyMeasurements.isEmpty) return Duration.zero;
    return _latencyMeasurements.reduce((a, b) => a > b ? a : b);
  }
  
  Duration get minLatency {
    if (_latencyMeasurements.isEmpty) return Duration.zero;
    return _latencyMeasurements.reduce((a, b) => a < b ? a : b);
  }
  
  /// Porcentaje de mensajes con latencia <2s
  double get latencyUnder2sPercentage {
    if (_latencyMeasurements.isEmpty) return 0.0;
    final under2s = _latencyMeasurements.where((d) => d.inMilliseconds < 2000).length;
    return (under2s / _latencyMeasurements.length) * 100;
  }
  
  /// Verifica si la latencia cumple con el requisito <2s
  bool get meetsLatencyRequirement => latencyUnder2sPercentage >= 95.0;
  
  /// Inicializa y conecta el servicio WebSocket
  Future<void> initialize({String? baseUrl, bool enableNotifications = true}) async {
    try {
      // Inicializar servicio de notificaciones
      if (enableNotifications) {
        await _notificationService.initialize();
      }
      
      // Obtener URL base desde SharedPreferences o usar la proporcionada
      if (baseUrl == null) {
        final prefs = await SharedPreferences.getInstance();
        _baseUrl = prefs.getString('api_base_url') ?? 'http://localhost:3000';
      } else {
        _baseUrl = baseUrl;
      }
      
      // Conectar Socket.IO con timeout optimizado para latencia <2s
      _socket = IO.io(
        _baseUrl,
        IO.OptionBuilder()
          .setTransports(['websocket', 'polling'])
          .enableAutoConnect()
          .enableReconnection()
          .setReconnectionDelay(1000)
          .setReconnectionDelayMax(5000)
          .setReconnectionAttempts(5)
          .setTimeout(2000) // Timeout reducido para mejor latencia
          .build(),
      );
      
      // Eventos de conexión
      _socket!.onConnect((_) {
        debugPrint('✅ WebSocket conectado');
        _isConnected = true;
        _connectionStatusController.add(true);
        
        // Unirse a salas
        _socket!.emit('join-dashboard');
        _socket!.emit('join-metrics');
        
        // Solicitar métricas iniciales
        _socket!.emit('request-metrics');
      });
      
      _socket!.onDisconnect((_) {
        debugPrint('❌ WebSocket desconectado');
        _isConnected = false;
        _connectionStatusController.add(false);
      });
      
      _socket!.onConnectError((error) {
        debugPrint('❌ Error de conexión WebSocket: $error');
        _isConnected = false;
        _connectionStatusController.add(false);
        _errorController.add('Error de conexión: $error');
      });
      
      // Eventos de datos
      _socket!.on('connection-status', (data) {
        debugPrint('Estado de conexión: $data');
        if (data['status'] == 'connected') {
          _isConnected = true;
          _connectionStatusController.add(true);
        }
      });
      
      _socket!.on('real-time-metrics', (data) {
        final receivedTime = DateTime.now();
        final dataMap = Map<String, dynamic>.from(data);
        
        // Medir latencia si el mensaje incluye timestamp
        if (dataMap.containsKey('timestamp')) {
          try {
            final serverTime = DateTime.parse(dataMap['timestamp']);
            final latency = receivedTime.difference(serverTime);
            _recordLatency(latency);
          } catch (e) {
            debugPrint('⚠️ Error parseando timestamp para latencia: $e');
          }
        }
        
        _metricsController.add(dataMap);
      });
      
      _socket!.on('new-access', (data) {
        final receivedTime = DateTime.now();
        final dataMap = Map<String, dynamic>.from(data);
        
        // Medir latencia si el mensaje incluye timestamp
        if (dataMap.containsKey('timestamp')) {
          try {
            final serverTime = DateTime.parse(dataMap['timestamp']);
            final latency = receivedTime.difference(serverTime);
            _recordLatency(latency);
          } catch (e) {
            debugPrint('⚠️ Error parseando timestamp para latencia: $e');
          }
        }
        
        // Mostrar notificación push
        if (enableNotifications && _notificationService.isInitialized) {
          _notificationService.showNewAccessNotification(
            estudianteNombre: '${dataMap['nombre'] ?? ''} ${dataMap['apellido'] ?? ''}'.trim(),
            tipoAcceso: dataMap['tipo'] ?? 'entrada',
            puerta: dataMap['puerta'] ?? 'Desconocida',
          );
        }
        
        _newAccessController.add(dataMap);
      });
      
      _socket!.on('hourly-data', (data) {
        final receivedTime = DateTime.now();
        final dataMap = Map<String, dynamic>.from(data);
        
        // Medir latencia si el mensaje incluye timestamp
        if (dataMap.containsKey('timestamp')) {
          try {
            final serverTime = DateTime.parse(dataMap['timestamp']);
            final latency = receivedTime.difference(serverTime);
            _recordLatency(latency);
          } catch (e) {
            debugPrint('⚠️ Error parseando timestamp para latencia: $e');
          }
        }
        
        _hourlyDataController.add(dataMap);
      });
      
      _socket!.on('error', (data) {
        final errorMsg = data['message'] ?? 'Error desconocido';
        _errorController.add(errorMsg);
      });
      
    } catch (e) {
      debugPrint('Error inicializando WebSocket: $e');
      _errorController.add('Error inicializando: $e');
      _isConnected = false;
      _connectionStatusController.add(false);
    }
  }
  
  /// Solicita actualización de métricas al servidor
  void requestMetrics() {
    if (_socket != null && _isConnected) {
      _socket!.emit('request-metrics');
    }
  }
  
  /// Se une a la sala de dashboard
  void joinDashboard() {
    if (_socket != null && _isConnected) {
      _socket!.emit('join-dashboard');
    }
  }
  
  /// Se une a la sala de métricas
  void joinMetrics() {
    if (_socket != null && _isConnected) {
      _socket!.emit('join-metrics');
    }
  }
  
  /// Desconecta el servicio WebSocket
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _isConnected = false;
    _connectionStatusController.add(false);
  }
  
  /// Registra una medición de latencia
  void _recordLatency(Duration latency) {
    _latencyMeasurements.add(latency);
    _latencyController.add(latency);
    
    // Mantener solo las últimas N mediciones
    if (_latencyMeasurements.length > maxLatencyMeasurements) {
      _latencyMeasurements.removeAt(0);
    }
    
    // Log si la latencia es alta
    if (latency.inMilliseconds > 2000) {
      debugPrint('⚠️ Latencia alta detectada: ${latency.inMilliseconds}ms');
    }
  }
  
  /// Obtiene estadísticas de latencia
  Map<String, dynamic> getLatencyStats() {
    return {
      'average': averageLatency.inMilliseconds,
      'min': minLatency.inMilliseconds,
      'max': maxLatency.inMilliseconds,
      'under2sPercentage': latencyUnder2sPercentage,
      'meetsRequirement': meetsLatencyRequirement,
      'totalMeasurements': _latencyMeasurements.length,
    };
  }
  
  /// Limpia las mediciones de latencia
  void clearLatencyMeasurements() {
    _latencyMeasurements.clear();
  }
  
  /// Cierra todos los streams y recursos
  void dispose() {
    disconnect();
    _connectionStatusController.close();
    _metricsController.close();
    _newAccessController.close();
    _hourlyDataController.close();
    _errorController.close();
    _latencyController.close();
    _latencyMeasurements.clear();
  }
}

