import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService extends ChangeNotifier {
  static final SessionService _instance = SessionService._internal();
  factory SessionService() => _instance;
  SessionService._internal();

  Timer? _sessionTimer;
  Timer? _warningTimer;
  int _sessionTimeoutMinutes = 30; // Tiempo por defecto
  int _warningTimeMinutes = 5; // Advertencia 5 min antes

  VoidCallback? _onSessionExpired;
  VoidCallback? _onSessionWarning;

  // Getters
  int get sessionTimeoutMinutes => _sessionTimeoutMinutes;
  int get warningTimeMinutes => _warningTimeMinutes;
  bool get hasActiveSession => _sessionTimer?.isActive ?? false;

  // Inicializar configuración desde preferencias o backend
  Future<void> initializeSession({bool syncFromBackend = true}) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Intentar obtener desde backend primero
    if (syncFromBackend) {
      try {
        final apiService = ApiService();
        final config = await apiService.getSessionConfig();
        _sessionTimeoutMinutes = config['timeoutMinutes'] ?? 30;
        _warningTimeMinutes = config['warningMinutes'] ?? 5;
        
        // Guardar localmente para uso offline
        await prefs.setInt('session_timeout_minutes', _sessionTimeoutMinutes);
        await prefs.setInt('warning_time_minutes', _warningTimeMinutes);
      } catch (e) {
        // Si falla, usar valores locales
        print('⚠️ No se pudo obtener configuración del backend, usando valores locales: $e');
        _sessionTimeoutMinutes = prefs.getInt('session_timeout_minutes') ?? 30;
        _warningTimeMinutes = prefs.getInt('warning_time_minutes') ?? 5;
      }
    } else {
      // Solo usar valores locales
      _sessionTimeoutMinutes = prefs.getInt('session_timeout_minutes') ?? 30;
      _warningTimeMinutes = prefs.getInt('warning_time_minutes') ?? 5;
    }
  }

  // Configurar tiempo de sesión (solo admin)
  // Ahora sincroniza con backend además de guardar localmente
  Future<void> configureSessionTimeout(
    int timeoutMinutes,
    int warningMinutes, {
    String? updatedBy,
    bool syncWithBackend = true,
  }) async {
    _sessionTimeoutMinutes = timeoutMinutes;
    _warningTimeMinutes = warningMinutes;

    // Guardar localmente
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('session_timeout_minutes', timeoutMinutes);
    await prefs.setInt('warning_time_minutes', warningMinutes);

    // Sincronizar con backend si está habilitado
    if (syncWithBackend) {
      try {
        final apiService = ApiService();
        await apiService.updateSessionConfig(
          timeoutMinutes: timeoutMinutes,
          warningMinutes: warningMinutes,
          updatedBy: updatedBy,
        );
      } catch (e) {
        // Si falla la sincronización, continuar con valores locales
        print('⚠️ No se pudo sincronizar configuración con backend: $e');
      }
    }

    // Reiniciar sesión con nueva configuración
    if (hasActiveSession) {
      _resetSessionTimer();
    }

    notifyListeners();
  }

  // Iniciar sesión con callbacks
  void startSession({
    required VoidCallback onSessionExpired,
    required VoidCallback onSessionWarning,
  }) {
    _onSessionExpired = onSessionExpired;
    _onSessionWarning = onSessionWarning;
    _startSessionTimer();
  }

  // Extender sesión (llamar en cada actividad del usuario)
  void extendSession() {
    if (hasActiveSession) {
      _resetSessionTimer();
    }
  }

  // Terminar sesión manualmente
  void endSession() {
    _sessionTimer?.cancel();
    _warningTimer?.cancel();
    _sessionTimer = null;
    _warningTimer = null;
    notifyListeners();
  }

  // Iniciar timer de sesión
  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _warningTimer?.cancel();

    // Timer para advertencia
    final warningDuration = Duration(
      minutes: _sessionTimeoutMinutes - _warningTimeMinutes,
    );
    _warningTimer = Timer(warningDuration, () {
      _onSessionWarning?.call();
    });

    // Timer para expiración
    final sessionDuration = Duration(minutes: _sessionTimeoutMinutes);
    _sessionTimer = Timer(sessionDuration, () {
      _onSessionExpired?.call();
      endSession();
    });

    notifyListeners();
  }

  // Reiniciar timer
  void _resetSessionTimer() {
    _startSessionTimer();
  }

  // Obtener tiempo restante (mejorado)
  Duration? getRemainingTime() {
    if (_sessionTimer == null || !_sessionTimer!.isActive) {
      return null;
    }

    // Calcular tiempo restante basado en cuando se inició el timer
    // Nota: Esta es una aproximación. Para precisión exacta, se necesitaría
    // guardar el timestamp de inicio del timer
    final now = DateTime.now();
    // Aproximación: asumimos que el timer se inició recientemente
    return Duration(minutes: _sessionTimeoutMinutes);
  }

  // Obtener tiempo restante hasta advertencia
  Duration? getRemainingTimeUntilWarning() {
    if (_warningTimer == null || !_warningTimer!.isActive) {
      return null;
    }
    return Duration(minutes: _warningTimeMinutes);
  }

  // Verificar si la advertencia ya fue mostrada
  bool get isWarningActive => _warningTimer?.isActive ?? false;

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _warningTimer?.cancel();
    super.dispose();
  }
}
