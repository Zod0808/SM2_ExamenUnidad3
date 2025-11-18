import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/asistencia_model.dart';

/// Servicio para reportes de estudiantes
/// US051 - Estudiantes más activos
class StudentReportsService {
  static final StudentReportsService _instance = StudentReportsService._internal();
  factory StudentReportsService() => _instance;
  StudentReportsService._internal();

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  /// Obtener ranking de estudiantes más activos
  Future<List<Map<String, dynamic>>> getMostActiveStudents({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
    String? facultad,
    String? escuela,
  }) async {
    try {
      final queryParams = <String, String>{
        'limit': limit.toString(),
      };
      
      if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();
      if (facultad != null) queryParams['facultad'] = facultad;
      if (escuela != null) queryParams['escuela'] = escuela;

      final uri = Uri.parse('${ApiConfig.baseUrl}/reportes/estudiantes-activos')
          .replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['ranking'] ?? []);
      } else {
        // Si el endpoint no existe, calcular localmente
        return await _calculateMostActiveStudents(
          startDate: startDate,
          endDate: endDate,
          limit: limit,
          facultad: facultad,
          escuela: escuela,
        );
      }
    } catch (e) {
      // Fallback a cálculo local
      return await _calculateMostActiveStudents(
        startDate: startDate,
        endDate: endDate,
        limit: limit,
        facultad: facultad,
        escuela: escuela,
      );
    }
  }

  /// Calcular estudiantes más activos localmente
  Future<List<Map<String, dynamic>>> _calculateMostActiveStudents({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 50,
    String? facultad,
    String? escuela,
  }) async {
    try {
      // Obtener todas las asistencias
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/asistencias'),
        headers: _headers,
      );

      if (response.statusCode != 200) {
        throw Exception('Error al obtener asistencias');
      }

      final List<dynamic> data = json.decode(response.body);
      List<AsistenciaModel> asistencias = data
          .map((json) => AsistenciaModel.fromJson(json))
          .toList();

      // Filtrar por fecha
      if (startDate != null || endDate != null) {
        asistencias = asistencias.where((a) {
          if (startDate != null && a.fechaHora.isBefore(startDate)) return false;
          if (endDate != null && a.fechaHora.isAfter(endDate)) return false;
          return true;
        }).toList();
      }

      // Filtrar por facultad/escuela
      if (facultad != null || escuela != null) {
        asistencias = asistencias.where((a) {
          if (facultad != null && a.siglasFacultad != facultad) return false;
          if (escuela != null && a.siglasEscuela != escuela) return false;
          return true;
        }).toList();
      }

      // Agrupar por estudiante (DNI)
      Map<String, Map<String, dynamic>> studentStats = {};

      for (var asistencia in asistencias) {
        final dni = asistencia.dni;
        if (studentStats[dni] == null) {
          studentStats[dni] = {
            'dni': dni,
            'nombre': asistencia.nombre,
            'apellido': asistencia.apellido,
            'codigoUniversitario': asistencia.codigoUniversitario,
            'siglasFacultad': asistencia.siglasFacultad,
            'siglasEscuela': asistencia.siglasEscuela,
            'totalAccesos': 0,
            'entradas': 0,
            'salidas': 0,
            'primeraAsistencia': asistencia.fechaHora,
            'ultimaAsistencia': asistencia.fechaHora,
            'diasActivos': <String>{},
          };
        }

        final stats = studentStats[dni]!;
        stats['totalAccesos'] = (stats['totalAccesos'] as int) + 1;
        
        if (asistencia.tipo == TipoMovimiento.entrada) {
          stats['entradas'] = (stats['entradas'] as int) + 1;
        } else {
          stats['salidas'] = (stats['salidas'] as int) + 1;
        }

        if (asistencia.fechaHora.isBefore(stats['primeraAsistencia'] as DateTime)) {
          stats['primeraAsistencia'] = asistencia.fechaHora;
        }
        if (asistencia.fechaHora.isAfter(stats['ultimaAsistencia'] as DateTime)) {
          stats['ultimaAsistencia'] = asistencia.fechaHora;
        }

        final dayKey = asistencia.fechaHora.toString().split(' ')[0];
        (stats['diasActivos'] as Set<String>).add(dayKey);
      }

      // Convertir a lista y calcular estadísticas adicionales
      List<Map<String, dynamic>> ranking = studentStats.values.map((stats) {
        final diasActivos = (stats['diasActivos'] as Set<String>).length;
        final totalAccesos = stats['totalAccesos'] as int;
        final promedioDiario = diasActivos > 0 ? totalAccesos / diasActivos : 0.0;

        return {
          ...stats,
          'diasActivos': diasActivos,
          'promedioDiario': promedioDiario,
          'diasActivosSet': null, // Remover Set para JSON
        };
      }).toList();

      // Ordenar por total de accesos
      ranking.sort((a, b) => (b['totalAccesos'] as int).compareTo(a['totalAccesos'] as int));

      // Limitar resultados
      return ranking.take(limit).toList();
    } catch (e) {
      throw Exception('Error calculando estudiantes activos: $e');
    }
  }

  /// Obtener estadísticas descriptivas del ranking
  Map<String, dynamic> getStatistics(List<Map<String, dynamic>> ranking) {
    if (ranking.isEmpty) {
      return {
        'total': 0,
        'promedioAccesos': 0.0,
        'medianaAccesos': 0,
        'maxAccesos': 0,
        'minAccesos': 0,
      };
    }

    final accesos = ranking.map((s) => s['totalAccesos'] as int).toList();
    accesos.sort();

    final promedio = accesos.reduce((a, b) => a + b) / accesos.length;
    final mediana = accesos.length % 2 == 0
        ? (accesos[accesos.length ~/ 2 - 1] + accesos[accesos.length ~/ 2]) / 2
        : accesos[accesos.length ~/ 2].toDouble();

    return {
      'total': ranking.length,
      'promedioAccesos': promedio,
      'medianaAccesos': mediana,
      'maxAccesos': accesos.last,
      'minAccesos': accesos.first,
      'desviacionEstandar': _calculateStandardDeviation(accesos, promedio),
    };
  }

  double _calculateStandardDeviation(List<int> values, double mean) {
    if (values.isEmpty) return 0.0;
    final variance = values.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) / values.length;
    return variance > 0 ? variance : 0.0;
  }
}

