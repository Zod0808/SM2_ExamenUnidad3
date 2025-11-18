/**
 * Tests unitarios para ConnectivityStatusWidget
 * US057 - Funcionalidad offline
 */

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:moviles2/widgets/connectivity_status_widget.dart';
// Nota: Estos servicios necesitarían ser mockeados en una implementación completa
// import 'package:moviles2/services/connectivity_service.dart';
// import 'package:moviles2/services/offline_sync_service.dart';

void main() {
  group('ConnectivityStatusWidget', () {
    testWidgets('debe renderizar sin errores', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConnectivityStatusWidget(),
          ),
        ),
      );

      // Verificar que el widget se renderiza
      // Nota: En una implementación completa, necesitaríamos providers mockeados
      expect(find.byType(ConnectivityStatusWidget), findsOneWidget);
    });

    testWidgets('debe aceptar parámetros opcionales', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ConnectivityStatusWidget(
              showDetails: true,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(ConnectivityStatusWidget), findsOneWidget);
    });
  });
}

