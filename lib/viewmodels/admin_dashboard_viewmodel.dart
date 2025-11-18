import 'dart:async';
import '../services/metrics_service.dart';
import '../services/realtime_websocket_service.dart';

class AdminDashboardViewModel {
  final MetricsService metricsService;
  final RealtimeWebSocketService? websocketService;

  int totalAccesses = 0;
  int activeUsers = 0;
  int currentInside = 0;
  int lastHourEntrances = 0;
  int lastHourExits = 0;
  List<int> accessesHistory = [];
  Map<String, dynamic>? hourlyData;
  
  bool _isUsingWebSocket = false;
  Timer? _pollingTimer;
  StreamSubscription? _metricsSubscription;
  StreamSubscription? _newAccessSubscription;
  StreamSubscription? _connectionSubscription;
  StreamSubscription? _errorSubscription;

  final StreamController<void> _metricsUpdated = StreamController.broadcast();
  Stream<void> get metricsUpdated => _metricsUpdated.stream;
  
  bool get isConnected => websocketService?.isConnected ?? false;
  bool get isUsingWebSocket => _isUsingWebSocket;

  AdminDashboardViewModel(this.metricsService, {this.websocketService});

  Future<void> fetchMetrics() async {
    try {
      final metrics = await metricsService.getMetrics();
      totalAccesses = metrics['totalAccesses'] ?? 0;
      activeUsers = metrics['activeUsers'] ?? 0;
      accessesHistory = List<int>.from(metrics['accessesHistory'] ?? []);
      
      // Si hay datos horarios, actualizarlos
      if (metrics.containsKey('hourlyData')) {
        hourlyData = Map<String, dynamic>.from(metrics['hourlyData']);
      }
      
      _metricsUpdated.add(null);
    } catch (e) {
      print('Error obteniendo métricas: $e');
    }
  }

  /// Inicia actualizaciones en tiempo real usando WebSocket o polling como fallback
  void startRealtimeUpdates({Duration interval = const Duration(seconds: 30), String? baseUrl}) {
    // Intentar usar WebSocket si está disponible
    if (websocketService != null) {
      _initializeWebSocket(baseUrl: baseUrl);
    } else {
      // Fallback a polling
      _startPolling(interval);
    }
  }
  
  /// Inicializa WebSocket para actualizaciones en tiempo real
  Future<void> _initializeWebSocket({String? baseUrl}) async {
    if (websocketService == null) return;
    
    try {
      await websocketService!.initialize(baseUrl: baseUrl);
      _isUsingWebSocket = true;
      
      // Suscribirse a eventos de métricas
      _metricsSubscription = websocketService!.metricsStream.listen((data) {
        _updateMetricsFromWebSocket(data);
      });
      
      // Suscribirse a nuevos accesos
      _newAccessSubscription = websocketService!.newAccessStream.listen((data) {
        // Actualizar métricas cuando hay un nuevo acceso
        totalAccesses++;
        if (data['tipo'] == 'entrada') {
          currentInside++;
          lastHourEntrances++;
        } else {
          currentInside = currentInside > 0 ? currentInside - 1 : 0;
          lastHourExits++;
        }
        _metricsUpdated.add(null);
      });
      
      // Suscribirse a datos horarios
      websocketService!.hourlyDataStream.listen((data) {
        hourlyData = data;
        _metricsUpdated.add(null);
      });
      
      // Suscribirse a estado de conexión
      _connectionSubscription = websocketService!.connectionStatus.listen((connected) {
        if (!connected && _isUsingWebSocket) {
          // Si se pierde la conexión WebSocket, usar polling como fallback
          print('⚠️ WebSocket desconectado, usando polling como fallback');
          _startPolling(interval: const Duration(seconds: 30));
        }
      });
      
      // Suscribirse a errores
      _errorSubscription = websocketService!.errorStream.listen((error) {
        print('Error WebSocket: $error');
      });
      
      print('✅ WebSocket inicializado para actualizaciones en tiempo real');
    } catch (e) {
      print('Error inicializando WebSocket: $e');
      // Fallback a polling
      _startPolling(interval: interval);
    }
  }
  
  /// Actualiza métricas desde datos WebSocket
  void _updateMetricsFromWebSocket(Map<String, dynamic> data) {
    totalAccesses = data['todayAccess'] ?? totalAccesses;
    currentInside = data['currentInside'] ?? currentInside;
    lastHourEntrances = data['lastHourEntrances'] ?? lastHourEntrances;
    lastHourExits = data['lastHourExits'] ?? lastHourExits;
    
    if (data.containsKey('hourlyData')) {
      hourlyData = Map<String, dynamic>.from(data['hourlyData']);
    }
    
    _metricsUpdated.add(null);
  }
  
  /// Inicia polling como fallback
  void _startPolling({Duration interval = const Duration(seconds: 30)}) {
    _isUsingWebSocket = false;
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(interval, (_) => fetchMetrics());
    // Cargar métricas inmediatamente
    fetchMetrics();
  }

  /// Detiene todas las actualizaciones en tiempo real
  void stopRealtimeUpdates() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    _metricsSubscription?.cancel();
    _newAccessSubscription?.cancel();
    _connectionSubscription?.cancel();
    _errorSubscription?.cancel();
    _isUsingWebSocket = false;
  }

  void dispose() {
    stopRealtimeUpdates();
    _metricsUpdated.close();
  }
}
