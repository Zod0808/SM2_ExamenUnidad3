import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../widgets/status_widgets.dart';
import '../../services/historical_data_service.dart';
import '../../config/api_config.dart';

/// US055 - Comparativo Antes/Después
/// Dashboard ROI Ejecutivo
class ComparativeROIView extends StatefulWidget {
  @override
  _ComparativeROIViewState createState() => _ComparativeROIViewState();
}

class _ComparativeROIViewState extends State<ComparativeROIView> {
  final HistoricalDataService _historicalService = HistoricalDataService();
  bool _isLoading = false;
  bool _hasHistoricalData = false;
  Map<String, dynamic>? _baselineData;
  Map<String, dynamic>? _comparison;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Intentar procesar el dataset automáticamente si no hay datos
    _checkAndProcessDataset();
  }

  Future<void> _checkAndProcessDataset() async {
    // Primero verificar si ya hay datos procesados
    await _checkHistoricalData();
    
    // Si no hay datos, intentar procesar el dataset automáticamente
    if (!_hasHistoricalData) {
      try {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
        
        // Llamar al endpoint para procesar el dataset automáticamente
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/api/historical/process-dataset'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({ 'filename': 'dataset_universidad_10000.csv' }),
        );
        
        if (response.statusCode == 200) {
          // Recargar datos después de procesar
          await _checkHistoricalData();
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Dataset histórico procesado automáticamente'),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      } catch (e) {
        // Si falla, no mostrar error, solo dejar que el usuario suba manualmente
        print('No se pudo procesar dataset automáticamente: $e');
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<void> _checkHistoricalData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final baseline = await _historicalService.getBaselineData(type: 'asistencias');
      
      if (baseline != null) {
        setState(() {
          _baselineData = baseline;
          _hasHistoricalData = true;
        });
        await _loadComparison();
      } else {
        setState(() {
          _hasHistoricalData = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadComparison() async {
    try {
      final data = await _historicalService.getComparison(type: 'asistencias');
      setState(() {
        _comparison = data; // Ahora incluye 'comparison' y 'roi'
      });
    } catch (e) {
      print('Error cargando comparativo: $e');
    }
  }

  Map<String, dynamic>? get roiData {
    // El ROI viene en la respuesta del endpoint
    return _comparison?['roi'];
  }
  
  Map<String, dynamic>? get comparisonData {
    // Los datos de comparación
    return _comparison?['comparison'];
  }

  Future<void> _uploadCSVFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });

        try {
          await _historicalService.uploadCSV(file, type: 'asistencias');
          
          // Recargar datos después de subir
          await _checkHistoricalData();
          
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Archivo CSV procesado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } catch (e) {
          setState(() {
            _errorMessage = 'Error al procesar archivo: $e';
          });
        } finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al seleccionar archivo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comparativo Antes/Después'),
        actions: [
          IconButton(
            icon: Icon(Icons.upload_file),
            onPressed: _uploadCSVFile,
            tooltip: 'Subir datos históricos CSV',
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _checkHistoricalData,
          ),
        ],
      ),
      body: _isLoading
          ? LoadingWidget(message: 'Cargando datos comparativos...')
          : _errorMessage != null
              ? _buildErrorView()
              : !_hasHistoricalData
                  ? _buildNoDataView()
                  : RefreshIndicator(
                      onRefresh: _checkHistoricalData,
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            SizedBox(height: 16),
                            _buildKPICards(),
                            SizedBox(height: 16),
                            _buildComparisonChart(),
                            SizedBox(height: 16),
                            _buildCostBenefitAnalysis(),
                            SizedBox(height: 16),
                            _buildROIDashboard(),
                          ],
                        ),
                      ),
                    ),
    );
  }

  Widget _buildNoDataView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No hay datos históricos disponibles',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'Para generar el comparativo antes/después, necesitas subir un archivo CSV con datos históricos del sistema anterior.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _uploadCSVFile,
              icon: Icon(Icons.upload_file),
              label: Text('Subir Archivo CSV'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Instrucciones:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('1. Prepara tu archivo CSV con datos históricos'),
                    Text('2. Formato: fecha, hora, tipo_movimiento, cantidad_promedio, tiempo_promedio_seg, errores_porcentaje, puerta'),
                    Text('3. Haz clic en "Subir Archivo CSV"'),
                    Text('4. El sistema procesará y almacenará los datos'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            SizedBox(height: 16),
            Text(
              'Error',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              _errorMessage ?? 'Error desconocido',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _checkHistoricalData,
              child: Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Análisis ROI - Comparativo Antes/Después',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Comparación de métricas antes y después de la implementación del sistema',
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Nota: Los datos "antes" requieren baseline histórico previo a la implementación',
                      style: TextStyle(fontSize: 12, color: Colors.orange[900]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKPICards() {
    // Usar datos reales si están disponibles
    final baseline = _baselineData?['summary'];
    final comparison = comparisonData;
    
    String tiempoAntes = '2-3 min';
    String tiempoDespues = '10-15 seg';
    String precisionAntes = '85%';
    String precisionDespues = '98%';
    String erroresAntes = '15%';
    String erroresDespues = '<2%';
    
    if (baseline != null) {
      final tiempoPromedio = baseline['tiempo_promedio_segundos'] ?? 0;
      tiempoAntes = '${(tiempoPromedio / 60).toStringAsFixed(1)} min';
      
      final precision = baseline['precision_promedio'] ?? 0;
      precisionAntes = '${precision.toStringAsFixed(0)}%';
      
      final errores = baseline['errores_promedio_porcentaje'] ?? 0;
      erroresAntes = '${errores.toStringAsFixed(1)}%';
    }
    
    if (comparison != null && comparison['current'] != null) {
      final current = comparison['current'];
      final tiempoActual = current['tiempo_promedio_segundos'] ?? 15;
      tiempoDespues = '${tiempoActual.toStringAsFixed(0)} seg';
      
      final precisionActual = current['precision'] ?? 98;
      precisionDespues = '${precisionActual.toStringAsFixed(0)}%';
      
      final erroresActual = current['errores_porcentaje'] ?? 2;
      erroresDespues = '${erroresActual.toStringAsFixed(1)}%';
    }
    
    return Row(
      children: [
        Expanded(
          child: _buildKPICard(
            'Tiempo de Registro',
            'Antes: $tiempoAntes',
            'Después: $tiempoDespues',
            Colors.blue,
            Icons.access_time,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildKPICard(
            'Precisión',
            'Antes: $precisionAntes',
            'Después: $precisionDespues',
            Colors.green,
            Icons.check_circle,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildKPICard(
            'Errores Humanos',
            'Antes: $erroresAntes',
            'Después: $erroresDespues',
            Colors.red,
            Icons.error_outline,
          ),
        ),
      ],
    );
  }

  Widget _buildKPICard(String title, String before, String after, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(before, style: TextStyle(fontSize: 10, color: Colors.grey[600])),
            Text(after, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonChart() {
    // Usar datos reales si están disponibles
    List<double> antes = [85, 75, 90, 80, 88, 82, 87];
    List<double> despues = [98, 95, 99, 97, 98, 96, 99];
    final labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    
    // Si hay datos históricos, usar los primeros 7 días
    if (_baselineData != null && _baselineData!['daily'] != null) {
      final daily = _baselineData!['daily'] as List;
      if (daily.isNotEmpty) {
        antes = daily.take(7).map((d) {
          final cantidad = d['total_cantidad'] ?? 0;
          return (cantidad is int ? cantidad.toDouble() : (cantidad as num).toDouble());
        }).toList();
        // Rellenar si hay menos de 7 días
        while (antes.length < 7) {
          antes.add(0.0);
        }
      }
    }
    
    // Si hay datos de comparación, usar métricas actuales
    if (comparisonData != null && comparisonData!['current'] != null) {
      final current = comparisonData!['current'];
      final precision = current['precision'] != null 
          ? (current['precision'] is int ? current['precision'].toDouble() : (current['precision'] as num).toDouble())
          : 98.0;
      despues = List.filled(7, precision);
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Evolución de Eficiencia',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < labels.length) {
                            return Text(labels[value.toInt()], style: TextStyle(fontSize: 10));
                          }
                          return Text('');
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: antes.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList(),
                      isCurved: true,
                      color: Colors.red,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                    LineChartBarData(
                      spots: despues.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.toDouble())).toList(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.red, 'Antes'),
                SizedBox(width: 16),
                _buildLegendItem(Colors.green, 'Después'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostBenefitAnalysis() {
    final roi = roiData;
    
    // Valores por defecto si no hay ROI calculado
    String inversionInicial = 'S/. 50,000';
    String ahorroTiempo = 'S/. 8,000';
    String ahorroErrores = 'S/. 2,000';
    String ahorroRecursos = 'S/. 6,000';
    String ahorroTotal = 'S/. 10,000';
    String roi6Meses = '20%';
    String roi12Meses = '140%';
    String paybackPeriod = '5 meses';
    String netBenefit6Meses = 'S/. 10,000';
    String netBenefit12Meses = 'S/. 70,000';
    
    // Usar datos reales si están disponibles
    if (roi != null) {
      final investment = roi['investment'];
      final savings = roi['savings'];
      final roiMetrics = roi['roi'];
      final netBenefit = roi['netBenefit'];
      
      if (investment != null) {
        inversionInicial = 'S/. ${investment['initial']?.toStringAsFixed(0) ?? '50,000'}';
      }
      if (savings != null) {
        ahorroTiempo = 'S/. ${savings['time']?.toStringAsFixed(0) ?? '8,000'}';
        ahorroErrores = 'S/. ${savings['errors']?.toStringAsFixed(0) ?? '2,000'}';
        ahorroRecursos = 'S/. ${savings['resources']?.toStringAsFixed(0) ?? '6,000'}';
        ahorroTotal = 'S/. ${savings['monthlyTotal']?.toStringAsFixed(0) ?? '10,000'}';
      }
      if (roiMetrics != null) {
        roi6Meses = '${roiMetrics['sixMonths']?.toStringAsFixed(1) ?? '20'}%';
        roi12Meses = '${roiMetrics['twelveMonths']?.toStringAsFixed(1) ?? '140'}%';
        paybackPeriod = '${roiMetrics['paybackPeriod']?.toStringAsFixed(1) ?? '5'} meses';
      }
      if (netBenefit != null) {
        netBenefit6Meses = 'S/. ${netBenefit['sixMonths']?.toStringAsFixed(0) ?? '10,000'}';
        netBenefit12Meses = 'S/. ${netBenefit['twelveMonths']?.toStringAsFixed(0) ?? '70,000'}';
      }
    }
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.account_balance_wallet, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Análisis Costo-Beneficio (US055)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Inversión
            Text('Inversión', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            _buildCostRow('Inversión Inicial', inversionInicial),
            if (roi != null && roi['investment'] != null)
              _buildCostRow('Costo Operacional Mensual', 'S/. ${roi['investment']['monthlyOperational']?.toStringAsFixed(0) ?? '2,000'}'),
            Divider(),
            // Ahorros
            Text('Ahorros Mensuales', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            _buildCostRow('Ahorro por Tiempo', ahorroTiempo),
            _buildCostRow('Ahorro por Errores', ahorroErrores),
            _buildCostRow('Ahorro por Recursos', ahorroRecursos),
            _buildCostRow('Ahorro Mensual Total', ahorroTotal, isTotal: true),
            Divider(),
            // ROI
            Text('Retorno de Inversión (ROI)', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            _buildCostRow('ROI (6 meses)', roi6Meses, color: Colors.green),
            _buildCostRow('ROI (12 meses)', roi12Meses, color: Colors.green),
            _buildCostRow('Payback Period', paybackPeriod, color: Colors.blue),
            Divider(),
            // Beneficio Neto
            Text('Beneficio Neto', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            SizedBox(height: 8),
            _buildCostRow('Beneficio Neto (6 meses)', netBenefit6Meses, color: Colors.green),
            _buildCostRow('Beneficio Neto (12 meses)', netBenefit12Meses, color: Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, String value, {bool isTotal = false, Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color ?? (isTotal ? Colors.green : Colors.black),
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildROIDashboard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'KPIs de Impacto',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildKPIItem('Reducción de tiempo de registro', '85%', Colors.green),
            _buildKPIItem('Aumento de precisión', '15%', Colors.blue),
            _buildKPIItem('Reducción de errores', '87%', Colors.orange),
            _buildKPIItem('Mejora en satisfacción', '40%', Colors.purple),
            _buildKPIItem('Ahorro de recursos humanos', '30%', Colors.teal),
          ],
        ),
      ),
    );
  }

  Widget _buildKPIItem(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            color: color,
          ),
          SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}

