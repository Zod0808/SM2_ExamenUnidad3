import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';

/// Servicio de notificaciones push locales (US060)
/// Usa notificaciones locales en lugar de Firebase para evitar configuración compleja
class PushNotificationService {
  static final PushNotificationService _instance = PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Inicializa el servicio de notificaciones
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Configuración para Android
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      
      // Configuración para iOS
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _notifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Solicitar permisos en Android 13+
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _notifications
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }

      _initialized = true;
      debugPrint('✅ Servicio de notificaciones push inicializado');
    } catch (e) {
      debugPrint('⚠️ Error inicializando notificaciones: $e');
    }
  }

  /// Maneja cuando se toca una notificación
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notificación tocada: ${response.payload}');
    // Aquí se puede navegar a una pantalla específica si es necesario
  }

  /// Muestra una notificación de nuevo acceso
  Future<void> showNewAccessNotification({
    required String estudianteNombre,
    required String tipoAcceso,
    required String puerta,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    try {
      const androidDetails = AndroidNotificationDetails(
        'accesos_channel',
        'Accesos en Tiempo Real',
        channelDescription: 'Notificaciones de accesos de estudiantes en tiempo real',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        enableVibration: true,
        playSound: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      final title = tipoAcceso == 'entrada' ? 'Nueva Entrada' : 'Nueva Salida';
      final body = '$estudianteNombre - Puerta: $puerta';

      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch % 100000,
        title,
        body,
        notificationDetails,
        payload: 'access_$tipoAcceso',
      );

      debugPrint('📱 Notificación enviada: $title - $body');
    } catch (e) {
      debugPrint('⚠️ Error mostrando notificación: $e');
    }
  }

  /// Muestra una notificación de métricas actualizadas
  Future<void> showMetricsNotification({
    required String titulo,
    required String mensaje,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    try {
      const androidDetails = AndroidNotificationDetails(
        'metrics_channel',
        'Métricas del Sistema',
        channelDescription: 'Notificaciones de actualizaciones de métricas',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        showWhen: true,
      );

      const iosDetails = DarwinNotificationDetails(
        presentAlert: false,
        presentBadge: true,
        presentSound: false,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await _notifications.show(
        DateTime.now().millisecondsSinceEpoch % 100000,
        titulo,
        mensaje,
        notificationDetails,
      );
    } catch (e) {
      debugPrint('⚠️ Error mostrando notificación de métricas: $e');
    }
  }

  /// Cancela todas las notificaciones
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// Verifica si el servicio está inicializado
  bool get isInitialized => _initialized;
}

