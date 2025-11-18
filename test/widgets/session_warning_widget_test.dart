/**
 * Tests unitarios para SessionWarningWidget
 * US004 - Sesión configurable
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:moviles2/widgets/session_warning_widget.dart';
import 'package:moviles2/viewmodels/auth_viewmodel.dart';

void main() {
  group('SessionWarningWidget', () {
    testWidgets('debe renderizar sin errores', (WidgetTester tester) async {
      final authViewModel = AuthViewModel();
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthViewModel>.value(
            value: authViewModel,
            child: Scaffold(
              body: SessionWarningWidget(),
            ),
          ),
        ),
      );

      // Verificar que el widget se renderiza
      expect(find.byType(SessionWarningWidget), findsOneWidget);
    });

    testWidgets('no debe mostrar diálogo si usuario no está logueado', (WidgetTester tester) async {
      final authViewModel = AuthViewModel();
      authViewModel.logout(); // Asegurar que no está logueado
      
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<AuthViewModel>.value(
            value: authViewModel,
            child: Scaffold(
              body: SessionWarningWidget(),
            ),
          ),
        ),
      );

      await tester.pump();

      // No debe mostrar diálogo si no está logueado
      expect(find.text('Sesión por Expirar'), findsNothing);
    });
  });
}

