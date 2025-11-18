import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/ml_reports_service.dart';
import '../../widgets/status_widgets.dart';

/// US048 - Predicciones Modelo ML
/// US052 - Horarios Pico ML
/// US053 - Precisión Modelo ML
class MLPredictionsView extends StatefulWidget {
  @override
  _MLPredictionsViewState createState() => _MLPredictionsViewState();
}

class _MLPredictionsViewState extends State<MLPredictionsView> with TickerProviderStateMixin {
  final MLReportsService _service = MLReportsService();
  late TabController _tabController;
  
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _predictions;
  Map<String, dynamic>? _peakHours;
  Map<String, dynamic>? _accuracyMetrics;
  Map<String, dynamic>? _visualization;
  
  int _days = 7;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() => _selectedTab = _tabController.index);
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final futures = await Future.wait([
        _service.getMLPredictions(days: _days),
        _service.getPeakHoursPrediction(days: _days),
        _service.getModelAccuracyMetrics(),
        _service.getPredictionVisualization(days: _days),
      ]);

      setState(() {
        _predictions = futures[0] as Map<String, dynamic>;
        _peakHours = futures[1] as Map<String, dynamic>;
        _accuracyMetrics = futures[2] as Map<String, dynamic>;
        _visualization = futures[3] as Map<String, dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? LoadingWidget(message: 'Cargando predicciones ML...')
          : _errorMessage != null
              ? _buildErrorView()
              : Column(
                  children: [
                    _buildHeader(),
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(text: 'Predicciones', icon: Icon(Icons.trending_up)),
                        Tab(text: 'Horarios Pico', icon: Icon(Icons.schedule)),
                        Tab(text: 'Precisión', icon: Icon(Icons.analytics)),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildPredictionsTab(),
                          _buildPeakHoursTab(),
                          _buildAccuracyTab(),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          SizedBox(height: 16),
          Text(_errorMessage ?? 'Error desconocido', textAlign: TextAlign.center),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            child: Text('Reintentar'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Reportes Machine Learning',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          DropdownButton<int>(
            value: _days,
            items: [7, 14, 30, 90].map((d) => DropdownMenuItem(
              value: d,
              child: Text('$d días'),
            )).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() => _days = value);
                _loadData();
              }
            },
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionsTab() {
    if (_predictions == null || _visualization == null) {
      return Center(child: Text('No hay datos disponibles'));
    }

    final chartData = _visualization!['chartData'] as List? ?? [];
    
    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPredictionVsRealChart(chartData),
            SizedBox(height: 16),
            _buildConfidenceIntervals(chartData),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionVsRealChart(List chartData) {
    if (chartData.isEmpty) return SizedBox.shrink();

    final maxValue = chartData.map((d) {
      final pred = d['predicted'] ?? 0.0;
      final real = d['real'] ?? 0.0;
      return [pred, real].reduce((a, b) => a > b ? a : b);
    }).reduce((a, b) => a > b ? a : b).toDouble() * 1.2;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Predicción vs Real',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < chartData.length) {
                            final date = DateTime.parse(chartData[value.toInt()]['timestamp']);
                            return Text('${date.day}/${date.month}', style: TextStyle(fontSize: 10));
                          }
                          return Text('');
                        },
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
                  minX: 0,
                  maxX: (chartData.length - 1).toDouble(),
                  minY: 0,
                  maxY: maxValue,
                  lineBarsData: [
                    // Predicción
                    LineChartBarData(
                      spots: chartData.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), (entry.value['predicted'] ?? 0.0).toDouble());
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                    // Real
                    LineChartBarData(
                      spots: chartData.asMap().entries.map((entry) {
                        final real = entry.value['real'];
                        if (real != null) {
                          return FlSpot(entry.key.toDouble(), real.toDouble());
                        }
                        return FlSpot(entry.key.toDouble(), 0);
                      }).where((spot) => spot.y > 0).toList(),
                      isCurved: true,
                      color: Colors.green,
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  lineTouchData: LineTouchData(enabled: true),
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.blue, 'Predicción'),
                SizedBox(width: 16),
                _buildLegendItem(Colors.green, 'Real'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfidenceIntervals(List chartData) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Intervalos de Confianza',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: chartData.asMap().entries.map((entry) {
                        final ci = entry.value['confidenceInterval'];
                        return FlSpot(entry.key.toDouble(), (ci?['upper'] ?? 0.0).toDouble());
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue.withOpacity(0.3),
                      barWidth: 1,
                      dotData: FlDotData(show: false),
                      belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.1)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeakHoursTab() {
    if (_peakHours == null) {
      return Center(child: Text('No hay datos disponibles'));
    }

    final peakHours = _peakHours!['peakHours'] as List? ?? [];
    final peakDays = _peakHours!['peakDays'] as List? ?? [];

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPeakHoursChart(peakHours),
            SizedBox(height: 16),
            _buildPeakDaysChart(peakDays),
          ],
        ),
      ),
    );
  }

  Widget _buildPeakHoursChart(List peakHours) {
    if (peakHours.isEmpty) return SizedBox.shrink();

    final maxValue = peakHours.map((h) => h['predicted'] as double).reduce((a, b) => a > b ? a : b) * 1.2;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Top Horarios Pico', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Container(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxValue,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < peakHours.length) {
                            return Text('${peakHours[value.toInt()]['hour']}:00');
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
                  gridData: FlGridData(show: true, drawVerticalLine: false),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(peakHours.length, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: (peakHours[index]['predicted'] as double),
                          color: Colors.orange,
                          width: 30,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeakDaysChart(List peakDays) {
    if (peakDays.isEmpty) return SizedBox.shrink();

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Top Días Pico', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ...peakDays.asMap().entries.map((entry) {
              final day = entry.value;
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Text('${entry.key + 1}'),
                ),
                title: Text(day['date']),
                trailing: Text(
                  '${(day['predicted'] as double).toStringAsFixed(0)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAccuracyTab() {
    if (_accuracyMetrics == null) {
      return Center(child: Text('No hay datos disponibles'));
    }

    final metrics = _accuracyMetrics!;
    final accuracy = metrics['accuracy'] ?? 0.0;
    final precision = metrics['precision'] ?? 0.0;
    final recall = metrics['recall'] ?? 0.0;
    final f1Score = metrics['f1Score'] ?? 0.0;

    return RefreshIndicator(
      onRefresh: _loadData,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetricsCards(accuracy, precision, recall, f1Score),
            SizedBox(height: 16),
            _buildMetricsEvolution(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsCards(double accuracy, double precision, double recall, double f1Score) {
    return Row(
      children: [
        Expanded(child: _buildMetricCard('Precisión', precision, Colors.blue)),
        SizedBox(width: 8),
        Expanded(child: _buildMetricCard('Recall', recall, Colors.green)),
        SizedBox(width: 8),
        Expanded(child: _buildMetricCard('F1-Score', f1Score, Colors.orange)),
      ],
    );
  }

  Widget _buildMetricCard(String label, double value, Color color) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '${(value * 100).toStringAsFixed(1)}%',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
            SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsEvolution() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Evolución Temporal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Gráfico de evolución de métricas en el tiempo (próximamente)'),
          ],
        ),
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

