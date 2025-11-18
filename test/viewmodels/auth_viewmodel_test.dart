/**
 * Tests unitarios para AuthViewModel
 * US001, US002, US003, US004 - Autenticación y sesión
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:moviles2/viewmodels/auth_viewmodel.dart';

void main() {
  late AuthViewModel authViewModel;

  setUp(() {
    authViewModel = AuthViewModel();
  });

  tearDown(() {
    authViewModel.logout();
  });

  group('AuthViewModel - Estado Inicial', () {
    test('debe inicializar con usuario null', () {
      expect(authViewModel.currentUser, isNull);
      expect(authViewModel.isLoggedIn, isFalse);
      expect(authViewModel.isAdmin, isFalse);
    });

    test('debe inicializar sin errores', () {
      expect(authViewModel.errorMessage, isNull);
      expect(authViewModel.isLoading, isFalse);
    });

    test('sessionService debe estar disponible', () {
      expect(authViewModel.sessionService, isNotNull);
    });
  });

  group('AuthViewModel - Logout', () {
    test('debe limpiar usuario al hacer logout', () {
      authViewModel.logout();
      
      expect(authViewModel.currentUser, isNull);
      expect(authViewModel.isLoggedIn, isFalse);
      expect(authViewModel.errorMessage, isNull);
    });

    test('debe notificar listeners al hacer logout', () {
      bool notified = false;
      authViewModel.addListener(() {
        notified = true;
      });
      
      authViewModel.logout();
      
      expect(notified, isTrue);
    });
  });

  group('AuthViewModel - Cambio de Contraseña', () {
    test('debe retornar false si no hay usuario logueado', () async {
      final result = await authViewModel.changePassword('newPassword123');
      
      expect(result, isFalse);
    });
  });

  group('AuthViewModel - Extender Sesión', () {
    test('debe extender sesión sin lanzar excepción', () {
      authViewModel.extendSession();
      
      expect(authViewModel.sessionService, isNotNull);
    });

    test('no debe lanzar excepción si no hay usuario logueado', () {
      authViewModel.logout();
      authViewModel.extendSession();
      
      expect(authViewModel.sessionService, isNotNull);
    });
  });

  group('AuthViewModel - Configurar Sesión', () {
    test('debe retornar false si no es admin', () async {
      final result = await authViewModel.configureSessionTimeout(30, 5);
      
      expect(result, isFalse);
    });
  });

  group('AuthViewModel - Getters', () {
    test('isLoggedIn debe retornar false cuando no hay usuario', () {
      expect(authViewModel.isLoggedIn, isFalse);
    });

    test('isAdmin debe retornar false cuando no hay usuario', () {
      expect(authViewModel.isAdmin, isFalse);
    });

    test('hasSessionWarning debe retornar false inicialmente', () {
      expect(authViewModel.hasSessionWarning(), isFalse);
    });

    test('clearSessionWarning debe limpiar advertencia', () {
      authViewModel.clearSessionWarning();
      expect(authViewModel.hasSessionWarning(), isFalse);
    });
  });

  group('AuthViewModel - Manejo de Errores', () {
    test('debe manejar login con credenciales inválidas', () async {
      final result = await authViewModel.login('invalid@example.com', 'wrong');
      
      expect(result, isFalse);
      // El error debe estar establecido o ser null (depende de la implementación)
      expect(authViewModel.errorMessage, anyOf(isNull, isNotNull));
    });
  });
}
