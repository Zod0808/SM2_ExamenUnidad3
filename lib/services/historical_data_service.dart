import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';
import '../config/api_config.dart';

/// Servicio para gestionar datos históricos (baseline)
/// US055 - Comparativo antes/después
class HistoricalDataService {
  static final HistoricalDataService _instance = HistoricalDataService._internal();
  factory HistoricalDataService() => _instance;
  HistoricalDataService._internal();

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  /// Subir archivo CSV de datos históricos
  Future<Map<String, dynamic>> uploadCSV(File csvFile, {String type = 'asistencias'}) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ApiConfig.baseUrl}/api/historical/upload'),
      );

      request.fields['type'] = type;
      request.files.add(
        await http.MultipartFile.fromPath(
          'csvFile',
          csvFile.path,
          filename: csvFile.path.split('/').last,
          contentType: MediaType('text', 'csv'),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al subir archivo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Obtener datos procesados del baseline
  Future<Map<String, dynamic>?> getBaselineData({String type = 'asistencias'}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/historical/baseline?type=$type'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'] as Map<String, dynamic>?;
      } else if (response.statusCode == 404) {
        return null; // No hay datos históricos
      } else {
        throw Exception('Error al obtener datos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Obtener comparativo antes/después (incluye ROI)
  Future<Map<String, dynamic>> getComparison({String type = 'asistencias'}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/historical/comparison?type=$type'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Retornar tanto la comparación como el ROI
        return {
          'comparison': data['comparison'] as Map<String, dynamic>,
          'roi': data['roi'] as Map<String, dynamic>?, // US055 - ROI calculado
        };
      } else {
        throw Exception('Error al obtener comparativo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Listar archivos CSV disponibles
  Future<List<String>> listCSVFiles() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/api/historical/files'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<String>.from(data['files'] ?? []);
      } else {
        throw Exception('Error al listar archivos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Procesar datos históricos manualmente
  Future<Map<String, dynamic>> processHistoricalData(String filename, {String type = 'asistencias'}) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/api/historical/process'),
        headers: _headers,
        body: json.encode({
          'filename': filename,
          'type': type,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al procesar datos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}

