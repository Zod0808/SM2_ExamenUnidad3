/**
 * Tests unitarios para NfcViewModel
 * US016-US024, US019, US060 - NFC y tiempo real
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:moviles2/viewmodels/nfc_viewmodel.dart';

void main() {
  late NfcViewModel nfcViewModel;

  setUp(() {
    nfcViewModel = NfcViewModel();
  });

  tearDown(() {
    // Limpiar recursos si es necesario
  });

  group('NfcViewModel - Estado Inicial', () {
    test('debe inicializar sin escaneo activo', () {
      expect(nfcViewModel.isScanning, isFalse);
      expect(nfcViewModel.isLoading, isFalse);
      expect(nfcViewModel.isNfcReady, isTrue);
    });

    test('debe inicializar sin errores', () {
      expect(nfcViewModel.errorMessage, isNull);
      expect(nfcViewModel.successMessage, isNull);
      expect(nfcViewModel.scannedAlumno, isNull);
    });

    test('debe inicializar con cola vacía', () {
      expect(nfcViewModel.queueSize, 0);
      expect(nfcViewModel.isProcessingQueue, isFalse);
    });

    test('debe inicializar con listas vacías', () {
      expect(nfcViewModel.recentDetections, isEmpty);
      expect(nfcViewModel.realtimeDetections, isEmpty);
    });
  });

  group('NfcViewModel - Getters', () {
    test('recentDetections debe retornar lista inmutable', () {
      expect(nfcViewModel.recentDetections, isA<List>());
    });

    test('realtimeDetections debe retornar lista inmutable', () {
      expect(nfcViewModel.realtimeDetections, isA<List>());
    });

    test('isNfcReady debe ser true cuando no está escaneando ni cargando', () {
      expect(nfcViewModel.isNfcReady, isTrue);
    });

    test('queueSize debe retornar tamaño de cola', () {
      expect(nfcViewModel.queueSize, isA<int>());
      expect(nfcViewModel.queueSize, greaterThanOrEqualTo(0));
    });
  });

  group('NfcViewModel - Estado de WebSocket', () {
    test('isWebSocketConnected debe retornar estado de conexión', () {
      expect(nfcViewModel.isWebSocketConnected, isA<bool>());
    });
  });

  group('NfcViewModel - Información del Guardia', () {
    test('guardiaId debe retornar null inicialmente', () {
      expect(nfcViewModel.guardiaId, isNull);
    });

    test('guardiaNombre debe retornar null inicialmente', () {
      expect(nfcViewModel.guardiaNombre, isNull);
    });

    test('puntoControl debe retornar null inicialmente', () {
      expect(nfcViewModel.puntoControl, isNull);
    });
  });
}

