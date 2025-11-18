import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../viewmodels/admin_dashboard_viewmodel.dart';

class DashboardView extends StatefulWidget {
  final AdminDashboardViewModel viewModel;

  const DashboardView({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.fetchMetrics();
    // Iniciar actualizaciones en tiempo real con WebSocket
    widget.viewModel.startRealtimeUpdates();
    widget.viewModel.metricsUpdated.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard General de Accesos'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _buildWideLayout(context);
          } else {
            return _buildNarrowLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildMetrics(context)),
        Expanded(child: _buildCharts(context)),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return ListView(
      children: [
        _buildMetrics(context),
        _buildCharts(context),
      ],
    );
  }

  Widget _buildMetrics(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Métricas en tiempo real', style: Theme.of(context).textTheme.headline6),
                // Indicador de conexión WebSocket
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.viewModel.isConnected 
                            ? Colors.green 
                            : Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.viewModel.isUsingWebSocket 
                          ? 'WebSocket' 
                          : 'Polling',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Accesos totales: ${widget.viewModel.totalAccesses}'),
            Text('Usuarios activos: ${widget.viewModel.activeUsers}'),
            if (widget.viewModel.currentInside > 0)
              Text('Dentro del campus: ${widget.viewModel.currentInside}'),
            if (widget.viewModel.lastHourEntrances > 0 || widget.viewModel.lastHourExits > 0) ...[
              const SizedBox(height: 4),
              Text(
                'Última hora: ${widget.viewModel.lastHourEntrances} entradas, ${widget.viewModel.lastHourExits} salidas',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCharts(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Gráficos de Accesos', style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 8),
            SizedBox(
              height: 220,
              child: widget.viewModel.accessesHistory.isNotEmpty
                  ? BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: (widget.viewModel.accessesHistory.reduce((a, b) => a > b ? a : b) + 20).toDouble(),
                        barTouchData: BarTouchData(enabled: true),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                return Text('M${value.toInt() + 1}');
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: List.generate(
                          widget.viewModel.accessesHistory.length,
                          (i) => BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: widget.viewModel.accessesHistory[i].toDouble(),
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
