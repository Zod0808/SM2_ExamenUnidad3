import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/student_reports_service.dart';
import '../../widgets/status_widgets.dart';

/// US051 - Estudiantes más activos
class ActiveStudentsReportView extends StatefulWidget {
  @override
  _ActiveStudentsReportViewState createState() => _ActiveStudentsReportViewState();
}

class _ActiveStudentsReportViewState extends State<ActiveStudentsReportView> {
  final StudentReportsService _service = StudentReportsService();
  
  bool _isLoading = false;
  String? _errorMessage;
  List<Map<String, dynamic>> _ranking = [];
  Map<String, dynamic>? _statistics;
  
  DateTime _startDate = DateTime.now().subtract(Duration(days: 30));
  DateTime _endDate = DateTime.now();
  int _limit = 50;
  String? _selectedFacultad;
  String? _selectedEscuela;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final ranking = await _service.getMostActiveStudents(
        startDate: _startDate,
        endDate: _endDate,
        limit: _limit,
        facultad: _selectedFacultad,
        escuela: _selectedEscuela,
      );
      
      final statistics = _service.getStatistics(ranking);
      
      setState(() {
        _ranking = ranking;
        _statistics = statistics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estudiantes Más Activos'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? LoadingWidget(message: 'Cargando estudiantes más activos...')
          : _errorMessage != null
              ? _buildErrorView()
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFilters(),
                        SizedBox(height: 16),
                        if (_statistics != null) _buildStatistics(_statistics!),
                        SizedBox(height: 16),
                        _buildRankingChart(),
                        SizedBox(height: 16),
                        _buildRankingList(),
                      ],
                    ),
                  ),
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

  Widget _buildFilters() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Filtros', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            InkWell(
              onTap: _selectDateRange,
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.date_range),
                    SizedBox(width: 8),
                    Text(
                      '${_startDate.day}/${_startDate.month}/${_startDate.year} - ${_endDate.day}/${_endDate.month}/${_endDate.year}',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _limit,
                    decoration: InputDecoration(labelText: 'Top N'),
                    items: [25, 50, 100, 200].map((n) => DropdownMenuItem(
                      value: n,
                      child: Text('Top $n'),
                    )).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _limit = value);
                        _loadData();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics(Map<String, dynamic> stats) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estadísticas', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Total', '${stats['total']}', Colors.blue),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard('Promedio', '${(stats['promedioAccesos'] as double).toStringAsFixed(1)}', Colors.green),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildStatCard('Máximo', '${stats['maxAccesos']}', Colors.orange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildRankingChart() {
    if (_ranking.isEmpty) return SizedBox.shrink();
    
    final top10 = _ranking.take(10).toList();
    final maxValue = top10.isNotEmpty
        ? (top10.map((s) => s['totalAccesos'] as int).reduce((a, b) => a > b ? a : b) * 1.2).toDouble()
        : 100.0;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Top 10 Estudiantes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Container(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxValue,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => Colors.blue,
                      tooltipRoundedRadius: 8,
                      tooltipPadding: EdgeInsets.all(8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final student = top10[group.x.toInt()];
                        return BarTooltipItem(
                          '${student['nombre']} ${student['apellido']}\n${rod.toY.toInt()} accesos',
                          TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < top10.length) {
                            final student = top10[value.toInt()];
                            return Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                '${value.toInt() + 1}',
                                style: TextStyle(fontSize: 10),
                              ),
                            );
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
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey[300]!, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(top10.length, (index) {
                    final student = top10[index];
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: (student['totalAccesos'] as int).toDouble(),
                          color: _getRankingColor(index),
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

  Widget _buildRankingList() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text('Ranking Completo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _ranking.length,
            itemBuilder: (context, index) {
              final student = _ranking[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getRankingColor(index),
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text('${student['nombre']} ${student['apellido']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${student['codigoUniversitario']} - ${student['siglasFacultad']}'),
                    Text('${student['diasActivos']} días activos'),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${student['totalAccesos']}',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _getRankingColor(index)),
                    ),
                    Text('accesos', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _getRankingColor(int index) {
    if (index == 0) return Colors.amber[700]!;
    if (index == 1) return Colors.grey[400]!;
    if (index == 2) return Colors.brown[400]!;
    return Colors.blue[400]!;
  }
}

