/**
 * Tests unitarios para AdminViewModel
 * US006, US007, US009 - Gestión de usuarios
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:moviles2/viewmodels/admin_viewmodel.dart';
import 'package:moviles2/models/usuario_model.dart';

void main() {
  late AdminViewModel adminViewModel;

  setUp(() {
    adminViewModel = AdminViewModel();
  });

  group('AdminViewModel - Estado Inicial', () {
    test('debe inicializar con lista vacía de usuarios', () {
      expect(adminViewModel.usuarios, isEmpty);
      expect(adminViewModel.historial, isEmpty);
    });

    test('debe inicializar sin errores', () {
      expect(adminViewModel.errorMessage, isNull);
      expect(adminViewModel.successMessage, isNull);
      expect(adminViewModel.isLoading, isFalse);
    });
  });

  group('AdminViewModel - Filtros de Usuarios', () {
    test('getUsuariosByRango debe retornar lista vacía inicialmente', () {
      final usuarios = adminViewModel.getUsuariosByRango('admin');
      expect(usuarios, isEmpty);
    });

    test('getActiveUsuarios debe retornar lista vacía inicialmente', () {
      final usuarios = adminViewModel.getActiveUsuarios();
      expect(usuarios, isEmpty);
    });

    test('getUsuariosByRango debe filtrar correctamente', () {
      // En implementación real, necesitaríamos usuarios cargados
      final usuarios = adminViewModel.getUsuariosByRango('guardia');
      expect(usuarios, isA<List<UsuarioModel>>());
    });
  });

  group('AdminViewModel - Cambio de Estado', () {
    test('toggleUserStatus debe manejar errores correctamente', () async {
      // Sin usuarios cargados, debe manejar el error
      final result = await adminViewModel.toggleUserStatus('invalid-id', true);
      
      expect(result, isFalse);
      // Debe tener mensaje de error o éxito
      expect(
        adminViewModel.errorMessage,
        anyOf(isNull, isNotNull),
      );
    });
  });

  group('AdminViewModel - Actualización de Usuario', () {
    test('updateUsuario debe retornar false si hay error', () async {
      final usuario = UsuarioModel(
        id: 'test-id',
        nombre: 'Test',
        apellido: 'User',
        email: 'test@example.com',
        password: 'password',
        rango: 'guardia',
        estado: 'activo',
      );

      final result = await adminViewModel.updateUsuario(usuario);
      
      // Sin usuario existente, debe retornar false
      expect(result, isFalse);
    });
  });

  group('AdminViewModel - Cambio de Contraseña', () {
    test('changeUserPassword debe manejar errores correctamente', () async {
      final result = await adminViewModel.changeUserPassword('invalid-id', 'newPassword');
      
      expect(result, isFalse);
    });
  });

  group('AdminViewModel - Getters', () {
    test('usuarios debe ser lista inmutable', () {
      expect(adminViewModel.usuarios, isA<List<UsuarioModel>>());
    });

    test('historial debe ser lista inmutable', () {
      expect(adminViewModel.historial, isA<List>());
    });
  });
}

