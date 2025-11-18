/**
 * Tests unitarios principales para el examen
 * Pruebas relacionadas con el proyecto de Control de Acceso Universitario NFC
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:moviles2/models/alumno_model.dart';
import 'package:moviles2/models/asistencia_model.dart';

void main() {
  group('Pruebas Unitarias Principales - Modelos del Proyecto', () {
    test('Test 1: Crear AlumnoModel y validar propiedades', () {
      // Arrange
      final alumno = AlumnoModel(
        id: '123',
        identificacion: 'NFC123',
        nombre: 'Juan',
        apellido: 'Pérez',
        dni: '12345678',
        codigoUniversitario: '20240001',
        escuelaProfesional: 'Ingeniería de Sistemas',
        facultad: 'Facultad de Ingeniería',
        siglasEscuela: 'IS',
        siglasFacultad: 'FI',
        estado: true,
      );

      // Assert
      expect(alumno.nombreCompleto, equals('Juan Pérez'));
      expect(alumno.isActive, isTrue);
      expect(alumno.codigoUniversitario, equals('20240001'));
      expect(alumno.dni, equals('12345678'));
    });

    test('Test 2: Convertir AlumnoModel desde JSON', () {
      // Arrange
      final json = {
        '_id': '123',
        '_identificacion': 'NFC123',
        'nombre': 'María',
        'apellido': 'González',
        'dni': '87654321',
        'codigo_universitario': '20240002',
        'escuela_profesional': 'Medicina',
        'facultad': 'Facultad de Medicina',
        'siglas_escuela': 'MED',
        'siglas_facultad': 'FM',
        'estado': true,
      };

      // Act
      final alumno = AlumnoModel.fromJson(json);

      // Assert
      expect(alumno.nombre, equals('María'));
      expect(alumno.apellido, equals('González'));
      expect(alumno.nombreCompleto, equals('María González'));
      expect(alumno.codigoUniversitario, equals('20240002'));
      expect(alumno.isActive, isTrue);
    });

    test('Test 3: Convertir AlumnoModel a JSON', () {
      // Arrange
      final alumno = AlumnoModel(
        id: '456',
        identificacion: 'NFC456',
        nombre: 'Carlos',
        apellido: 'López',
        dni: '11223344',
        codigoUniversitario: '20240003',
        escuelaProfesional: 'Derecho',
        facultad: 'Facultad de Derecho',
        siglasEscuela: 'DER',
        siglasFacultad: 'FD',
        estado: false,
      );

      // Act
      final json = alumno.toJson();

      // Assert
      expect(json['_id'], equals('456'));
      expect(json['nombre'], equals('Carlos'));
      expect(json['apellido'], equals('López'));
      expect(json['codigo_universitario'], equals('20240003'));
      expect(json['estado'], isFalse);
    });
  });

  group('Pruebas Unitarias - TipoMovimiento Enum', () {
    test('Test 4: Convertir string a TipoMovimiento entrada', () {
      // Act
      final tipo = TipoMovimiento.fromString('entrada');

      // Assert
      expect(tipo, equals(TipoMovimiento.entrada));
      expect(tipo?.descripcion, equals('Entrada'));
      expect(tipo?.icono, equals('login'));
    });

    test('Test 5: Convertir string a TipoMovimiento salida', () {
      // Act
      final tipo = TipoMovimiento.fromString('salida');

      // Assert
      expect(tipo, equals(TipoMovimiento.salida));
      expect(tipo?.descripcion, equals('Salida'));
      expect(tipo?.icono, equals('logout'));
    });

    test('Test 6: Validar conversión TipoMovimiento a string', () {
      // Arrange
      final entrada = TipoMovimiento.entrada;
      final salida = TipoMovimiento.salida;

      // Assert
      expect(entrada.toValue(), equals('entrada'));
      expect(salida.toValue(), equals('salida'));
    });
  });

  group('Pruebas Unitarias - AsistenciaModel', () {
    test('Test 7: Crear AsistenciaModel de entrada', () {
      // Arrange
      final fechaHora = DateTime(2025, 11, 18, 8, 30);
      final asistencia = AsistenciaModel(
        id: 'asist001',
        nombre: 'Ana',
        apellido: 'Martínez',
        dni: '99887766',
        codigoUniversitario: '20240004',
        siglasFacultad: 'FI',
        siglasEscuela: 'IS',
        tipo: TipoMovimiento.entrada,
        fechaHora: fechaHora,
        entradaTipo: 'nfc',
        puerta: 'Puerta Principal',
      );

      // Assert
      expect(asistencia.nombreCompleto, equals('Ana Martínez'));
      expect(asistencia.esEntrada, isTrue);
      expect(asistencia.esSalida, isFalse);
      expect(asistencia.entradaTipo, equals('nfc'));
      expect(asistencia.puerta, equals('Puerta Principal'));
    });

    test('Test 8: Crear AsistenciaModel de salida', () {
      // Arrange
      final fechaHora = DateTime(2025, 11, 18, 18, 45);
      final asistencia = AsistenciaModel(
        id: 'asist002',
        nombre: 'Pedro',
        apellido: 'Sánchez',
        dni: '55443322',
        codigoUniversitario: '20240005',
        siglasFacultad: 'FM',
        siglasEscuela: 'MED',
        tipo: TipoMovimiento.salida,
        fechaHora: fechaHora,
        entradaTipo: 'manual',
        puerta: 'Puerta Secundaria',
        autorizacionManual: true,
        guardiaNombre: 'Guardia Juan',
      );

      // Assert
      expect(asistencia.esSalida, isTrue);
      expect(asistencia.esEntrada, isFalse);
      expect(asistencia.autorizacionManual, isTrue);
      expect(asistencia.guardiaNombre, equals('Guardia Juan'));
    });
  });
}
