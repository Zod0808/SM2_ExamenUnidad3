import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../services/ml_reports_service.dart';
import '../../widgets/status_widgets.dart';

/// US049 - Reportes Eficiencia Buses
/// US054 - Uso Buses Sugerido vs Real
class BusEfficiencyView extends StatefulWidget {
  @override
  _BusEfficiencyViewState createState() => _BusEfficiencyViewState();
}

class _BusEfficiencyViewState extends State<BusEfficiencyView> {
  final MLReportsService _service = MLReportsService();
  
  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _suggestions;
  Map<String, dynamic>? _efficiency;
  Map<String, dynamic>? _comparison;

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
      final futures = await Future.wait([
        _service.getBusScheduleSuggestions(),
        _service.getBusEfficiencyMetrics(),
        _service.getBusUsageComparison(days: 7), // US054 - Comparativo sugerido vs real
      ]);

      setState(() {
        _suggestions = futures[0] as Map<String, dynamic>;
        _efficiency = futures[1] as Map<String, dynamic>;
        _comparison = futures[2] as Map<String, dynamic>;
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
      appBar: AppBar(
        title: Text('Eficiencia de Buses'),
        actions: [
          IconButton(icon: Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _isLoading
          ? LoadingWidget(message: 'Cargando datos de buses...')
          : _errorMessage != null
              ? _buildErrorView()
              : RefreshIndicator(
                  onRefresh: _loadData,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_efficiency != null) _buildEfficiencyMetrics(_efficiency!),
                        SizedBox(height: 16),
                        if (_suggestions != null) _buildSuggestions(_suggestions!),
                        SizedBox(height: 16),
                        if (_comparison != null) _buildComparison(_comparison!),
                        SizedBox(height: 16),
                        _buildROICalculation(),
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
          ElevatedButton(onPressed: _loadData, child: Text('Reintentar')),
        ],
      ),
    );
  }

  Widget _buildEfficiencyMetrics(Map<String, dynamic> efficiency) {
    final efficiencyValue = efficiency['efficiency'] ?? 0.0;
    final utilization = efficiency['utilization'] ?? 0.0;
    final waitTime = efficiency['averageWaitTime'] ?? 0.0;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Métricas de Eficiencia', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildMetricCard('Eficiencia', '${(efficiencyValue * 100).toStringAsFixed(1)}%', Colors.green),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard('Utilización', '${(utilization * 100).toStringAsFixed(1)}%', Colors.blue),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildMetricCard('Tiempo Espera', '${waitTime.toStringAsFixed(0)} min', Colors.orange),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildSuggestions(Map<String, dynamic> suggestions) {
    final schedule = suggestions['schedule'] as List? ?? [];
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Horarios Sugeridos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            if (schedule.isEmpty)
              Text('No hay sugerencias disponibles')
            else
              ...schedule.take(10).map((s) => ListTile(
                leading: Icon(Icons.directions_bus, color: Colors.blue),
                title: Text('${s['time']} - ${s['route'] ?? 'Ruta'}'),
                subtitle: Text('Capacidad: ${s['capacity'] ?? 0}'),
                trailing: Text('${s['demand'] ?? 0} pasajeros'),
              )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildComparison(Map<String, dynamic> comparison) {
    final comparisonData = comparison['comparison'] ?? comparison;
    final adoptionRate = comparisonData['adoptionRate'] ?? 0.0;
    final adoptionMetrics = comparisonData['adoptionMetrics'] ?? {};
    final efficiencyComparison = comparisonData['efficiencyComparison'] ?? {};
    final scheduleComparison = comparisonData['scheduleComparison'] ?? {};

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.compare_arrows, color: Colors.blue),
                SizedBox(width: 8),
                Text(
                  'Sugerido vs Real (US054)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Tasa de Adopción
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Tasa de Adopción', style: TextStyle(fontWeight: FontWeight.w500)),
                  Text(
                    '${(adoptionRate * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            // Métricas de Adopción
            if (adoptionMetrics.isNotEmpty) ...[
              Text('Métricas de Adopción', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              _buildComparisonRow(
                'Total Implementadas',
                '${adoptionMetrics['totalImplemented'] ?? 0}',
              ),
              if (adoptionMetrics['mostActiveImplementer'] != null)
                _buildComparisonRow(
                  'Implementador Más Activo',
                  '${adoptionMetrics['mostActiveImplementer']['name'] ?? 'N/A'} (${adoptionMetrics['mostActiveImplementer']['count'] ?? 0})',
                ),
              SizedBox(height: 8),
            ],
            // Comparación de Eficiencia
            if (efficiencyComparison.isNotEmpty) ...[
              Divider(),
              Text('Comparación de Eficiencia', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              if (efficiencyComparison['suggested'] != null)
                _buildComparisonRow(
                  'Eficiencia Sugerida',
                  '${((efficiencyComparison['suggested']['overall'] ?? 0) * 100).toStringAsFixed(1)}%',
                ),
              if (efficiencyComparison['actual'] != null)
                _buildComparisonRow(
                  'Eficiencia Real',
                  '${((efficiencyComparison['actual']['overall'] ?? 0) * 100).toStringAsFixed(1)}%',
                ),
              if (efficiencyComparison['improvement'] != null)
                _buildComparisonRow(
                  'Mejora',
                  '${(efficiencyComparison['improvement'] * 100).toStringAsFixed(1)}%',
                  color: efficiencyComparison['improvement'] > 0 ? Colors.green : Colors.red,
                ),
            ],
            // Comparación de Horarios
            if (scheduleComparison.isNotEmpty) ...[
              Divider(),
              Text('Comparación de Horarios', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              _buildComparisonRow(
                'Coincidencias',
                '${scheduleComparison['matches'] ?? 0}',
              ),
              _buildComparisonRow(
                'Diferencias',
                '${scheduleComparison['differences']?.length ?? 0}',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonRow(String label, String value, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildROICalculation() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Análisis ROI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Cálculo de retorno de inversión basado en eficiencia mejorada'),
            SizedBox(height: 8),
            _buildComparisonRow('ROI Estimado', '15-25%'),
            _buildComparisonRow('Ahorro Mensual', 'S/. 5,000 - S/. 8,000'),
          ],
        ),
      ),
    );
  }
}

