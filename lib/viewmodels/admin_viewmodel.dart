import 'package:flutter/foundation.dart';
import '../models/usuario_model.dart';
import '../models/historial_modificacion_model.dart';
import '../services/api_service.dart';

class AdminViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<UsuarioModel> _usuarios = [];
  List<HistorialModificacionModel> _historial = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Getters
  List<UsuarioModel> get usuarios => _usuarios;
  List<HistorialModificacionModel> get historial => _historial;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // Cargar usuarios
  Future<void> loadUsuarios() async {
    _setLoading(true);
    _clearMessages();

    try {
      _usuarios = await _apiService.getUsuarios();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Crear usuario
  Future<bool> createUsuario(UsuarioModel usuario) async {
    _setLoading(true);
    _clearMessages();

    try {
      final nuevoUsuario = await _apiService.createUsuario(usuario);
      _usuarios.add(nuevoUsuario);
      _setSuccess('Usuario creado exitosamente');
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Cambiar contraseña de usuario
  Future<bool> changeUserPassword(String userId, String newPassword) async {
    _setLoading(true);
    _clearMessages();

    try {
      await _apiService.changePassword(userId, newPassword);
      _setSuccess('Contraseña actualizada exitosamente');
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
      return false;
    }
  }

  // Filtrar usuarios por tipo
  List<UsuarioModel> getUsuariosByRango(String rango) {
    return _usuarios.where((user) => user.rango == rango).toList();
  }

  // Obtener usuarios activos
  List<UsuarioModel> getActiveUsuarios() {
    return _usuarios.where((user) => user.isActive).toList();
  }

  // Actualizar usuario completo (US009)
  Future<bool> updateUsuario(UsuarioModel usuario) async {
    _setLoading(true);
    _clearMessages();

    try {
      // Obtener usuario actual para comparar cambios
      final usuarioActual = _usuarios.firstWhere(
        (u) => u.id == usuario.id,
        orElse: () => usuario,
      );

      // Calcular cambios realizados
      final cambios = <String, dynamic>{};
      if (usuarioActual.nombre != usuario.nombre) {
        cambios['nombre'] = usuario.nombre;
      }
      if (usuarioActual.apellido != usuario.apellido) {
        cambios['apellido'] = usuario.apellido;
      }
      if (usuarioActual.dni != usuario.dni) {
        cambios['dni'] = usuario.dni;
      }
      if (usuarioActual.email != usuario.email) {
        cambios['email'] = usuario.email;
      }
      if (usuarioActual.rango != usuario.rango) {
        cambios['rango'] = usuario.rango;
      }
      if (usuarioActual.telefono != usuario.telefono) {
        cambios['telefono'] = usuario.telefono;
      }
      if (usuarioActual.puertaACargo != usuario.puertaACargo) {
        cambios['puerta_acargo'] = usuario.puertaACargo;
      }

      // Actualizar usuario en el servidor
      final usuarioActualizado = await _apiService.updateUsuario(usuario);

      // Actualizar en la lista local
      final index = _usuarios.indexWhere((u) => u.id == usuario.id);
      if (index != -1) {
        _usuarios[index] = usuarioActualizado;
      }

      // Recargar historial para mostrar el cambio registrado
      await loadHistorial(usuario.id);

      _setSuccess('Usuario actualizado exitosamente');
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error al actualizar usuario: $e');
      _setLoading(false);
      return false;
    }
  }

  // Cambiar estado de usuario (activar/desactivar)
  Future<bool> toggleUserStatus(String userId, bool activate) async {
    _setLoading(true);
    _clearMessages();

    try {
      final newStatus = activate ? 'activo' : 'inactivo';
      await _apiService.updateUserStatus(userId, newStatus);

      // Actualizar el usuario en la lista local
      final index = _usuarios.indexWhere((u) => u.id == userId);
      if (index != -1) {
        final user = _usuarios[index];
        final updatedUser = UsuarioModel(
          id: user.id,
          nombre: user.nombre,
          apellido: user.apellido,
          dni: user.dni,
          email: user.email,
          password: user.password,
          rango: user.rango,
          estado: newStatus,
          puertaACargo: user.puertaACargo,
          telefono: user.telefono,
          fechaCreacion: user.fechaCreacion,
          fechaActualizacion: DateTime.now(),
        );
        _usuarios[index] = updatedUser;
      }

      _setSuccess(
        activate
            ? 'Usuario activado exitosamente. El usuario podrá iniciar sesión.'
            : 'Usuario desactivado exitosamente. El usuario no podrá iniciar sesión.',
      );
      _setLoading(false);
      notifyListeners(); // Notificar cambios para actualizar UI
      return true;
    } catch (e) {
      _setError('Error al cambiar estado: $e');
      _setLoading(false);
      return false;
    }
  }

  // Obtener historial de modificaciones (US009)
  Future<void> loadHistorial([String? entidadId]) async {
    _setLoading(true);
    _clearMessages();

    try {
      final logs = await _apiService.getHistorialModificaciones(
        entityType: 'usuarios',
        entityId: entidadId,
        limit: 100,
      );

      _historial = logs.map((log) {
        // Convertir formato de audit log a HistorialModificacionModel
        final changes = <String, dynamic>{};
        if (log['changes'] != null) {
          final changesMap = Map<String, dynamic>.from(log['changes']);
          changesMap.forEach((key, value) {
            if (value is Map && value['to'] != null) {
              changes[key] = value['to'];
            } else {
              changes[key] = value;
            }
          });
        }

        return HistorialModificacionModel(
          id: log['_id']?.toString() ?? log['id']?.toString() ?? '',
          entidadId: log['entity_id']?.toString() ?? '',
          tipoEntidad: log['entity_type'] ?? 'usuario',
          accion: _mapActionToSpanish(log['action'] ?? 'update'),
          adminId: log['user_id']?.toString() ?? '',
          adminNombre: log['user_name'] ?? 'Sistema',
          cambiosRealizados: changes,
          descripcion: log['metadata']?['description'] ?? null,
          fechaModificacion: log['timestamp'] != null
              ? DateTime.parse(log['timestamp'])
              : DateTime.now(),
        );
      }).toList();

      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  // Mapear acción en inglés a español
  String _mapActionToSpanish(String action) {
    switch (action.toLowerCase()) {
      case 'create':
        return 'crear';
      case 'update':
        return 'modificar';
      case 'delete':
        return 'eliminar';
      case 'activate':
        return 'activar';
      case 'deactivate':
        return 'desactivar';
      default:
        return action;
    }
  }

  // Crear historial simulado para demostración
  List<HistorialModificacionModel> _crearHistorialSimulado() {
    return [
      HistorialModificacionModel(
        id: '1',
        entidadId: 'user1',
        tipoEntidad: 'usuario',
        accion: 'crear',
        adminId: 'admin1',
        adminNombre: 'Admin Principal',
        cambiosRealizados: {'nombre': 'Juan Pérez', 'rango': 'guardia'},
        descripcion: 'Nuevo guardia registrado',
        fechaModificacion: DateTime.now().subtract(Duration(days: 2)),
      ),
      HistorialModificacionModel(
        id: '2',
        entidadId: 'user1',
        tipoEntidad: 'usuario',
        accion: 'modificar',
        adminId: 'admin1',
        adminNombre: 'Admin Principal',
        cambiosRealizados: {'telefono': '+51987654321'},
        descripcion: 'Actualización de teléfono',
        fechaModificacion: DateTime.now().subtract(Duration(days: 1)),
      ),
      HistorialModificacionModel(
        id: '3',
        entidadId: 'user2',
        tipoEntidad: 'usuario',
        accion: 'desactivar',
        adminId: 'admin1',
        adminNombre: 'Admin Principal',
        cambiosRealizados: {'estado': 'inactivo'},
        descripcion: 'Usuario desactivado por inactividad',
        fechaModificacion: DateTime.now().subtract(Duration(hours: 3)),
      ),
    ];
  }

  // Registrar cambio en historial (método para implementación futura)
  Future<void> _registrarCambio({
    required String entidadId,
    required String tipoEntidad,
    required String accion,
    required Map<String, dynamic> cambios,
    String? descripcion,
  }) async {
    // En implementación real, esto haría un POST al servidor
    // Por ahora, solo añadimos al historial local
    final nuevoRegistro = HistorialModificacionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      entidadId: entidadId,
      tipoEntidad: tipoEntidad,
      accion: accion,
      adminId: 'current_admin', // Vendría del usuario actual
      adminNombre: 'Admin Actual',
      cambiosRealizados: cambios,
      descripcion: descripcion,
      fechaModificacion: DateTime.now(),
    );

    _historial.insert(0, nuevoRegistro); // Añadir al inicio
    notifyListeners();
  }

  // Limpiar mensajes
  void clearMessages() {
    _clearMessages();
  }

  // Métodos privados
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
}
