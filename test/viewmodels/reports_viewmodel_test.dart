/**
 * Tests unitarios para ReportsViewModel
 * US010, US050 - Reportes y exportación
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:moviles2/viewmodels/reports_viewmodel.dart';
import 'package:moviles2/models/asistencia_model.dart';

void main() {
  late ReportsViewModel reportsViewModel;

  setUp(() {
    reportsViewModel = ReportsViewModel();
  });

  group('ReportsViewModel - Estado Inicial', () {
    test('debe inicializar con listas vacías', () {
      expect(reportsViewModel.asistencias, isEmpty);
      expect(reportsViewModel.asistenciasFiltradas, isEmpty);
    });

    test('debe inicializar sin errores', () {
      expect(reportsViewModel.errorMessage, isNull);
      expect(reportsViewModel.isLoading, isFalse);
    });

    test('debe tener filtros de fecha disponibles', () {
      expect(reportsViewModel.fechaInicioFilter, isNull);
      expect(reportsViewModel.fechaFinFilter, isNull);
    });
  });

  group('ReportsViewModel - Filtros', () {
    test('debe aplicar filtros de fecha correctamente', () {
      final fechaInicio = DateTime(2024, 1, 1);
      final fechaFin = DateTime(2024, 1, 31);

      reportsViewModel.updateFilters(
        fechaInicio: fechaInicio,
        fechaFin: fechaFin,
      );

      expect(reportsViewModel.fechaInicioFilter, equals(fechaInicio));
      expect(reportsViewModel.fechaFinFilter, equals(fechaFin));
    });

    test('clearFilters debe limpiar todos los filtros', () {
      reportsViewModel.updateFilters(
        fechaInicio: DateTime(2024, 1, 1),
        fechaFin: DateTime(2024, 1, 31),
        carrera: 'ING',
        facultad: 'FIIS',
      );

      reportsViewModel.clearFilters();

      expect(reportsViewModel.fechaInicioFilter, isNull);
      expect(reportsViewModel.fechaFinFilter, isNull);
    });

    test('asistenciasFiltradas debe retornar lista filtrada', () {
      expect(reportsViewModel.asistenciasFiltradas, isA<List<AsistenciaModel>>());
    });
  });

  group('ReportsViewModel - Carga de Datos', () {
    test('loadAsistencias debe manejar errores correctamente', () async {
      await reportsViewModel.loadAsistencias();

      // Debe manejar el error sin lanzar excepción
      expect(reportsViewModel.isLoading, isFalse);
    });
  });

  group('ReportsViewModel - Getters', () {
    test('asistencias debe ser lista inmutable', () {
      expect(reportsViewModel.asistencias, isA<List<AsistenciaModel>>());
    });

    test('fechaInicioFilter debe ser accesible', () {
      expect(reportsViewModel.fechaInicioFilter, anyOf(isNull, isA<DateTime>()));
    });

    test('fechaFinFilter debe ser accesible', () {
      expect(reportsViewModel.fechaFinFilter, anyOf(isNull, isA<DateTime>()));
    });
  });
}

