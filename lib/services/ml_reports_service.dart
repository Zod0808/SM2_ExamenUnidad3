import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Servicio para obtener reportes y datos de Machine Learning
class MLReportsService {
  static final MLReportsService _instance = MLReportsService._internal();
  factory MLReportsService() => _instance;
  MLReportsService._internal();

  Map<String, String> get _headers => {'Content-Type': 'application/json'};

  // ==================== US048 - Predicciones Modelo ML ====================
  
  /// Obtener predicciones del modelo ML
  Future<Map<String, dynamic>> getMLPredictions({int days = 7}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/ml/prediction/predict?days=$days'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener predicciones: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Obtener datos de visualización de predicciones
  Future<Map<String, dynamic>> getPredictionVisualization({int days = 7}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/ml/visualization/line-chart?days=$days'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener visualización: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ==================== US052 - Horarios Pico ML ====================
  
  /// Obtener predicciones de horarios pico
  Future<Map<String, dynamic>> getPeakHoursPrediction({int days = 7}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/ml/prediction/predict?days=$days'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Procesar para obtener horarios pico
        return _processPeakHours(data);
      } else {
        throw Exception('Error al obtener horarios pico: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Comparar predicciones ML vs reales
  Future<Map<String, dynamic>> compareMLvsReal({int days = 7}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/ml/prediction/predict?days=$days'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al comparar: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ==================== US053 - Precisión Modelo ML ====================
  
  /// Obtener métricas de precisión del modelo
  Future<Map<String, dynamic>> getModelAccuracyMetrics() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/ml/metrics'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener métricas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Obtener evolución temporal de métricas
  Future<List<Map<String, dynamic>>> getMetricsEvolution({int weeks = 4}) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/ml/monitoring/temporal-evolution?weeks=$weeks'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data['evolution'] ?? []);
      } else {
        throw Exception('Error al obtener evolución: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ==================== US049 - Reportes Eficiencia Buses ====================
  
  /// Obtener sugerencias de horarios de buses
  Future<Map<String, dynamic>> getBusScheduleSuggestions({
    int days = 7,
    int busCapacity = 50,
    int minInterval = 15,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/ml/bus-schedule/suggestions'),
        headers: _headers,
        body: json.encode({
          'days': days,
          'busCapacity': busCapacity,
          'minInterval': minInterval,
          'includeReturn': true,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener sugerencias: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Obtener métricas de eficiencia de buses
  Future<Map<String, dynamic>> getBusEfficiencyMetrics() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/ml/bus-schedule/efficiency'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener eficiencia: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ==================== US054 - Uso Buses Sugerido vs Real ====================
  
  /// Obtener comparativo de uso sugerido vs real
  Future<Map<String, dynamic>> getBusUsageComparison({
    int days = 7,
  }) async {
    try {
      final queryParams = <String, String>{
        'days': days.toString(),
      };
      
      final uri = Uri.parse('${ApiConfig.baseUrl}/ml/bus-schedule/comparison')
          .replace(queryParameters: queryParams);
      
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener comparativo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Registrar que una sugerencia fue implementada
  Future<Map<String, dynamic>> recordImplementedSuggestion({
    required Map<String, dynamic> suggestion,
    String? implementedBy,
    DateTime? implementationDate,
  }) async {
    try {
      final body = {
        'suggestion': suggestion,
      };
      if (implementedBy != null) body['implementedBy'] = implementedBy;
      if (implementationDate != null) {
        body['implementationDate'] = implementationDate.toIso8601String();
      }

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/ml/bus-schedule/implement'),
        headers: _headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al registrar sugerencia: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// Obtener métricas de adopción
  Future<Map<String, dynamic>> getBusAdoptionMetrics({
    int days = 30,
  }) async {
    try {
      final queryParams = <String, String>{
        'days': days.toString(),
      };
      
      final uri = Uri.parse('${ApiConfig.baseUrl}/ml/bus-schedule/adoption-metrics')
          .replace(queryParameters: queryParams);
      
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener métricas de adopción: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ==================== US047 - Gráficos Flujo Horarios ====================
  
  /// Obtener datos de flujo por horarios y días
  Future<Map<String, dynamic>> getHourlyFlowData({
    DateTime? startDate,
    DateTime? endDate,
    String? dayOfWeek,
  }) async {
    try {
      final queryParams = <String, String>{};
      if (startDate != null) queryParams['startDate'] = startDate.toIso8601String();
      if (endDate != null) queryParams['endDate'] = endDate.toIso8601String();
      if (dayOfWeek != null) queryParams['dayOfWeek'] = dayOfWeek;
      
      final uri = Uri.parse('${ApiConfig.baseUrl}/ml/flow-patterns/analysis')
          .replace(queryParameters: queryParams);
      
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al obtener flujo: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  // ==================== Helper Methods ====================
  
  Map<String, dynamic> _processPeakHours(Map<String, dynamic> data) {
    // Procesar predicciones para identificar horarios pico
    final predictions = data['predictions'] ?? [];
    if (predictions.isEmpty) {
      return {'peakHours': [], 'peakDays': []};
    }

    // Agrupar por hora y día
    Map<int, double> hourlyTotals = {};
    Map<String, double> dailyTotals = {};

    for (var pred in predictions) {
      final hour = DateTime.parse(pred['timestamp']).hour;
      final day = DateTime.parse(pred['timestamp']).toString().split(' ')[0];
      
      hourlyTotals[hour] = (hourlyTotals[hour] ?? 0.0) + (pred['predicted'] ?? 0.0);
      dailyTotals[day] = (dailyTotals[day] ?? 0.0) + (pred['predicted'] ?? 0.0);
    }

    // Identificar top 3 horarios pico
    final sortedHours = hourlyTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final peakHours = sortedHours.take(3).map((e) => {
      'hour': e.key,
      'predicted': e.value,
    }).toList();

    // Identificar top 3 días pico
    final sortedDays = dailyTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final peakDays = sortedDays.take(3).map((e) => {
      'date': e.key,
      'predicted': e.value,
    }).toList();

    return {
      'peakHours': peakHours,
      'peakDays': peakDays,
      'hourlyTotals': hourlyTotals,
      'dailyTotals': dailyTotals,
    };
  }
}

