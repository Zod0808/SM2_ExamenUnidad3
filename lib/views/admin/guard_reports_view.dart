import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import '../../viewmodels/guard_reports_viewmodel.dart';
import '../../widgets/status_widgets.dart';

class GuardReportsView extends StatefulWidget {
  @override
  _GuardReportsViewState createState() => _GuardReportsViewState();
}

class _GuardReportsViewState extends State<GuardReportsView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  DateTime _fechaInicio = DateTime.now().subtract(Duration(days: 7));
  DateTime _fechaFin = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReportsData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadReportsData() async {
    final guardReportsViewModel = Provider.of<GuardReportsViewModel>(
      context,
      listen: false,
    );
    await guardReportsViewModel.loadAllGuardReports();
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(
        start: _fechaInicio,
        end: _fechaFin,
      ),
    );

    if (picked != null) {
      setState(() {
        _fechaInicio = picked.start;
        _fechaFin = picked.end;
      });
      
      // Actualizar el ViewModel con las nuevas fechas
      final guardReportsViewModel = Provider.of<GuardReportsViewModel>(
        context,
        listen: false,
      );
      guardReportsViewModel.updateDateRange(_fechaInicio, _fechaFin);
      await guardReportsViewModel.loadAllGuardReports();
    }
  }

  Future<void> _exportToPDF() async {
    final guardReportsViewModel = Provider.of<GuardReportsViewModel>(
      context,
      listen: false,
    );

    // Mostrar diálogo de carga
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Generando PDF...'),
          ],
        ),
      ),
    );

    try {
      final pdfFile = await guardReportsViewModel.exportToPDF();
      
      if (mounted) {
        Navigator.pop(context); // Cerrar diálogo de carga
        
        if (pdfFile != null) {
          // Compartir el PDF
          await Share.shareXFiles(
            [XFile(pdfFile.path)],
            subject: 'Reporte de Actividad de Guardias',
            text: 'Reporte de actividad de guardias generado el ${DateTime.now().toString().split(' ')[0]}',
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white),
                    SizedBox(width: 8),
                    Text('PDF generado y compartido exitosamente'),
                  ],
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    Icon(Icons.error, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        guardReportsViewModel.errorMessage ?? 'Error al generar PDF',
                      ),
                    ),
                  ],
                ),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Cerrar diálogo de carga
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GuardReportsViewModel>(
      builder: (context, guardReportsViewModel, child) {
        if (guardReportsViewModel.isLoading) {
          return LoadingWidget(message: 'Cargando reportes de guardias...');
        }

        if (guardReportsViewModel.errorMessage != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              SizedBox(height: 16),
              Text(guardReportsViewModel.errorMessage!, textAlign: TextAlign.center),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadReportsData,
                child: Text('Reintentar'),
              ),
            ],
          );
        }

        return Column(
          children: [
            // Header con filtros de fecha
            Container(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reportes de Actividad de Guardias',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: _exportToPDF,
                            icon: Icon(Icons.picture_as_pdf),
                            tooltip: 'Exportar a PDF',
                            color: Colors.red[700],
                          ),
                          IconButton(
                            onPressed: _loadReportsData,
                            icon: Icon(Icons.refresh),
                            tooltip: 'Actualizar datos',
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateFilter(),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryCards(guardReportsViewModel),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tabs
            TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: [
                Tab(text: 'Resumen General', icon: Icon(Icons.dashboard)),
                Tab(text: 'Ranking Guardias', icon: Icon(Icons.leaderboard)),
                Tab(text: 'Actividad Diaria', icon: Icon(Icons.calendar_today)),
                Tab(text: 'Autorizaciones', icon: Icon(Icons.verified_user)),
              ],
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildGeneralSummaryTab(guardReportsViewModel),
                  _buildRankingTab(guardReportsViewModel),
                  _buildDailyActivityTab(guardReportsViewModel),
                  _buildAuthorizationsTab(guardReportsViewModel),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateFilter() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rango de Fechas',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            InkWell(
              onTap: _selectDateRange,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.date_range, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${_fechaInicio.day}/${_fechaInicio.month}/${_fechaInicio.year} - ${_fechaFin.day}/${_fechaFin.month}/${_fechaFin.year}',
                        style: TextStyle(fontSize: 12),
                      ),
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

  Widget _buildSummaryCards(GuardReportsViewModel guardReportsViewModel) {
    final resumen = guardReportsViewModel.resumenActividad;
    
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Asistencias',
            resumen != null ? '${resumen.totalAsistencias}' : '0',
            Colors.blue,
            Icons.people,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildSummaryCard(
            'Guardias Activos',
            resumen != null ? '${resumen.guardiasActivos}' : '0',
            Colors.green,
            Icons.security,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _buildSummaryCard(
            'Autorizaciones',
            resumen != null ? '${resumen.autorizacionesManuales}' : '0',
            Colors.orange,
            Icons.verified_user,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 16),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 10, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralSummaryTab(GuardReportsViewModel guardReportsViewModel) {
    final resumen = guardReportsViewModel.resumenActividad;
    
    return RefreshIndicator(
      onRefresh: _loadReportsData,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen general
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen General del Período',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    if (resumen != null) ...[
                      _buildSummaryRow('Total Asistencias', '${resumen.totalAsistencias}'),
                      _buildSummaryRow('Guardias Activos', '${resumen.guardiasActivos}'),
                      _buildSummaryRow('Autorizaciones Manuales', '${resumen.autorizacionesManuales}'),
                      _buildSummaryRow('Puerta Más Usada', resumen.puertaMasUsada),
                      _buildSummaryRow('Facultad Más Atendida', resumen.facultadMasAtendida),
                      _buildSummaryRow('Promedio Diario', '${resumen.promedioDiario.toStringAsFixed(1)}'),
                    ] else ...[
                      Text('No hay datos disponibles', style: TextStyle(color: Colors.grey)),
                    ],
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Actividad por día de la semana (Gráfico avanzado)
            _buildAdvancedWeeklyChart(guardReportsViewModel),
            SizedBox(height: 16),

            // Top puertas (Gráfico circular)
            _buildTopPuertasChart(guardReportsViewModel),
            SizedBox(height: 16),

            // Top facultades (Gráfico circular)
            _buildTopFacultadesChart(guardReportsViewModel),
            SizedBox(height: 16),

            // Comparación de rendimiento entre guardias (Gráfico de barras avanzado)
            _buildGuardPerformanceComparisonChart(guardReportsViewModel),
            SizedBox(height: 16),

            // Evolución temporal de actividad (Gráfico de líneas)
            _buildActivityTrendChart(guardReportsViewModel),
            SizedBox(height: 16),

            // Top puertas (lista)
            _buildTopPuertas(guardReportsViewModel),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingTab(GuardReportsViewModel guardReportsViewModel) {
    final ranking = guardReportsViewModel.rankingGuardias;
    
    return RefreshIndicator(
      onRefresh: _loadReportsData,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: ranking.length,
        itemBuilder: (context, index) {
          final guardia = ranking[index];
          
          return Card(
            margin: EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getRankingColor(index),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                'Guardia ${guardia.guardiaId.substring(0, 8)}...',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total: ${guardia.totalAsistencias} asistencias'),
                  Text('Entradas: ${guardia.entradas} | Salidas: ${guardia.salidas}'),
                  Text('Autorizaciones: ${guardia.autorizacionesManuales}'),
                  Text('Promedio diario: ${guardia.promedioDiario.toStringAsFixed(1)}'),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${guardia.totalAsistencias}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _getRankingColor(index),
                    ),
                  ),
                  Text(
                    'asistencias',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailyActivityTab(GuardReportsViewModel guardReportsViewModel) {
    final actividadPorDia = guardReportsViewModel.actividadSemanal;
    final diasSemana = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    
    return RefreshIndicator(
      onRefresh: _loadReportsData,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Actividad por Día de la Semana',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Container(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          final dia = index + 1;
                          final actividad = actividadPorDia[dia] ?? 0;
                          final maxActividad = actividadPorDia.values.isNotEmpty
                              ? actividadPorDia.values.reduce((a, b) => a > b ? a : b)
                              : 1;
                          final altura = actividad == 0
                              ? 0.0
                              : (actividad / maxActividad) * 150;

                          return Container(
                            width: 60,
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (actividad > 0)
                                  Text('$actividad', style: TextStyle(fontSize: 10)),
                                Container(
                                  width: 40,
                                  height: altura,
                                  decoration: BoxDecoration(
                                    color: Colors.blue[400],
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(4),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  diasSemana[index],
                                  style: TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),

            // Lista detallada por día
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detalle por Día',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 12),
                    ...diasSemana.asMap().entries.map((entry) {
                      final index = entry.key;
                      final dia = index + 1;
                      final actividad = actividadPorDia[dia] ?? 0;
                      
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(entry.value),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue[100],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '$actividad',
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthorizationsTab(GuardReportsViewModel guardReportsViewModel) {
    final guardiasConAutorizaciones = guardReportsViewModel.getGuardiasConMasAutorizaciones(limit: 50);
    
    return RefreshIndicator(
      onRefresh: _loadReportsData,
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: guardiasConAutorizaciones.length,
        itemBuilder: (context, index) {
          final guardia = guardiasConAutorizaciones[index];
          final autorizaciones = guardia.autorizacionesManuales;
          
          return Card(
            margin: EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: autorizaciones > 10 
                    ? Colors.red[100] 
                    : autorizaciones > 5 
                        ? Colors.orange[100] 
                        : Colors.green[100],
                child: Icon(
                  Icons.verified_user,
                  color: autorizaciones > 10 
                      ? Colors.red 
                      : autorizaciones > 5 
                          ? Colors.orange 
                          : Colors.green,
                ),
              ),
              title: Text(
                'Guardia ${guardia.guardiaId.substring(0, 8)}...',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total asistencias: ${guardia.totalAsistencias}'),
                  Text('Puerta más usada: ${guardia.puertaMasUsada}'),
                  Text('Facultad más atendida: ${guardia.facultadMasAtendida}'),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$autorizaciones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: autorizaciones > 10 
                          ? Colors.red 
                          : autorizaciones > 5 
                              ? Colors.orange 
                              : Colors.green,
                    ),
                  ),
                  Text(
                    'autorizaciones',
                    style: TextStyle(fontSize: 10, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Gráfico avanzado de actividad semanal con fl_chart
  Widget _buildAdvancedWeeklyChart(GuardReportsViewModel guardReportsViewModel) {
    final actividadPorDia = guardReportsViewModel.actividadSemanal;
    final diasSemana = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    
    final maxValue = actividadPorDia.values.isNotEmpty
        ? actividadPorDia.values.reduce((a, b) => a > b ? a : b)
        : 1;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Actividad por Día de la Semana',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.fullscreen),
                  onPressed: () {
                    _showFullScreenChart(
                      context,
                      'Actividad Semanal',
                      _buildWeeklyBarChart(actividadPorDia, diasSemana, maxValue),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxValue.toDouble() * 1.2,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => Colors.blue,
                      tooltipRoundedRadius: 8,
                      tooltipPadding: EdgeInsets.all(8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final dia = diasSemana[group.x.toInt()];
                        return BarTooltipItem(
                          '$dia\n${rod.toY.toInt()}',
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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
                          if (value.toInt() >= 0 && value.toInt() < diasSemana.length) {
                            return Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                diasSemana[value.toInt()],
                                style: TextStyle(fontSize: 12),
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
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[300]!,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(7, (index) {
                    final dia = index + 1;
                    final actividad = actividadPorDia[dia] ?? 0;
                    
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: actividad.toDouble(),
                          color: _getDayColor(index),
                          width: 30,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(4),
                          ),
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

  Widget _buildWeeklyBarChart(
    Map<int, int> actividadPorDia,
    List<String> diasSemana,
    int maxValue,
  ) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue.toDouble() * 1.2,
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (group) => Colors.blue,
            tooltipRoundedRadius: 8,
            tooltipPadding: EdgeInsets.all(8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final dia = diasSemana[group.x.toInt()];
              return BarTooltipItem(
                '$dia\n${rod.toY.toInt()}',
                TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
                if (value.toInt() >= 0 && value.toInt() < diasSemana.length) {
                  return Text(diasSemana[value.toInt()]);
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
              getTitlesWidget: (value, meta) {
                return Text(value.toInt().toString());
              },
            ),
          ),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey[300]!, strokeWidth: 1);
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(7, (index) {
          final dia = index + 1;
          final actividad = actividadPorDia[dia] ?? 0;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: actividad.toDouble(),
                color: _getDayColor(index),
                width: 40,
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Gráfico circular para top puertas
  Widget _buildTopPuertasChart(GuardReportsViewModel guardReportsViewModel) {
    final topPuertas = guardReportsViewModel.topPuertas.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    if (topPuertas.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text('No hay datos de puertas disponibles'),
          ),
        ),
      );
    }

    final top5 = topPuertas.take(5).toList();
    final total = top5.fold(0, (sum, entry) => sum + entry.value);
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Distribución por Puertas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.fullscreen),
                  onPressed: () {
                    _showFullScreenChart(
                      context,
                      'Top Puertas',
                      _buildPuertasPieChart(top5, total),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 250,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: List.generate(top5.length, (index) {
                          final entry = top5[index];
                          final percentage = (entry.value / total) * 100;
                          return PieChartSectionData(
                            value: entry.value.toDouble(),
                            title: '${percentage.toStringAsFixed(1)}%',
                            color: _getChartColor(index),
                            radius: 80,
                            titleStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }),
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              return;
                            }
                            final touchedSection = pieTouchResponse.touchedSection!;
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(top5[touchedSection.touchedSectionIndex].key),
                                content: Text(
                                  'Actividad: ${top5[touchedSection.touchedSectionIndex].value}\n'
                                  'Porcentaje: ${((top5[touchedSection.touchedSectionIndex].value / total) * 100).toStringAsFixed(1)}%',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(top5.length, (index) {
                        final entry = top5[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: _getChartColor(index),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${entry.value}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
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

  Widget _buildPuertasPieChart(List<MapEntry<String, int>> top5, int total) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 60,
        sections: List.generate(top5.length, (index) {
          final entry = top5[index];
          final percentage = (entry.value / total) * 100;
          return PieChartSectionData(
            value: entry.value.toDouble(),
            title: '${entry.key}\n${percentage.toStringAsFixed(1)}%',
            color: _getChartColor(index),
            radius: 120,
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }),
        pieTouchData: PieTouchData(enabled: true),
      ),
    );
  }

  // Gráfico circular para top facultades
  Widget _buildTopFacultadesChart(GuardReportsViewModel guardReportsViewModel) {
    final topFacultades = guardReportsViewModel.topFacultades.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    if (topFacultades.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text('No hay datos de facultades disponibles'),
          ),
        ),
      );
    }

    final top5 = topFacultades.take(5).toList();
    final total = top5.fold(0, (sum, entry) => sum + entry.value);
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Distribución por Facultades',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.fullscreen),
                  onPressed: () {
                    _showFullScreenChart(
                      context,
                      'Top Facultades',
                      _buildFacultadesPieChart(top5, total),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 250,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: List.generate(top5.length, (index) {
                          final entry = top5[index];
                          final percentage = (entry.value / total) * 100;
                          return PieChartSectionData(
                            value: entry.value.toDouble(),
                            title: '${percentage.toStringAsFixed(1)}%',
                            color: _getChartColor(index + 5),
                            radius: 80,
                            titleStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          );
                        }),
                        pieTouchData: PieTouchData(
                          touchCallback: (FlTouchEvent event, pieTouchResponse) {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              return;
                            }
                            final touchedSection = pieTouchResponse.touchedSection!;
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(top5[touchedSection.touchedSectionIndex].key),
                                content: Text(
                                  'Actividad: ${top5[touchedSection.touchedSectionIndex].value}\n'
                                  'Porcentaje: ${((top5[touchedSection.touchedSectionIndex].value / total) * 100).toStringAsFixed(1)}%',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(top5.length, (index) {
                        final entry = top5[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: _getChartColor(index + 5),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${entry.value}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
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

  Widget _buildFacultadesPieChart(List<MapEntry<String, int>> top5, int total) {
    return PieChart(
      PieChartData(
        sectionsSpace: 2,
        centerSpaceRadius: 60,
        sections: List.generate(top5.length, (index) {
          final entry = top5[index];
          final percentage = (entry.value / total) * 100;
          return PieChartSectionData(
            value: entry.value.toDouble(),
            title: '${entry.key}\n${percentage.toStringAsFixed(1)}%',
            color: _getChartColor(index + 5),
            radius: 120,
            titleStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }),
        pieTouchData: PieTouchData(enabled: true),
      ),
    );
  }

  // Gráfico de comparación de rendimiento entre guardias
  Widget _buildGuardPerformanceComparisonChart(GuardReportsViewModel guardReportsViewModel) {
    final ranking = guardReportsViewModel.rankingGuardias.take(10).toList();
    
    if (ranking.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Text('No hay datos de guardias disponibles'),
          ),
        ),
      );
    }

    final maxValue = ranking.isNotEmpty
        ? ranking.map((g) => g.totalAsistencias).reduce((a, b) => a > b ? a : b)
        : 1;
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Comparación de Rendimiento - Top 10 Guardias',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.fullscreen),
                  onPressed: () {
                    _showFullScreenChart(
                      context,
                      'Comparación de Guardias',
                      _buildGuardComparisonBarChart(ranking, maxValue),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 300,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxValue.toDouble() * 1.2,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => Colors.blue,
                      tooltipRoundedRadius: 8,
                      tooltipPadding: EdgeInsets.all(8),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final guardia = ranking[group.x.toInt()];
                        return BarTooltipItem(
                          'Guardia ${guardia.guardiaId.substring(0, 8)}...\n'
                          'Total: ${guardia.totalAsistencias}\n'
                          'Entradas: ${guardia.entradas}\n'
                          'Salidas: ${guardia.salidas}',
                          TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
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
                          if (value.toInt() >= 0 && value.toInt() < ranking.length) {
                            return Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                'G${value.toInt() + 1}',
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
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(color: Colors.grey[300]!, strokeWidth: 1);
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(ranking.length, (index) {
                    final guardia = ranking[index];
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: guardia.entradas.toDouble(),
                          color: Colors.green[400],
                          width: 20,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                        ),
                        BarChartRodData(
                          toY: guardia.salidas.toDouble(),
                          color: Colors.red[400],
                          width: 20,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(Colors.green[400]!, 'Entradas'),
                SizedBox(width: 16),
                _buildLegendItem(Colors.red[400]!, 'Salidas'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuardComparisonBarChart(List guardias, int maxValue) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxValue.toDouble() * 1.2,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < guardias.length) {
                  return Text('G${value.toInt() + 1}');
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
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey[300]!, strokeWidth: 1);
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(guardias.length, (index) {
          final guardia = guardias[index];
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: guardia.entradas.toDouble(),
                color: Colors.green[400],
                width: 30,
                borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
              ),
              BarChartRodData(
                toY: guardia.salidas.toDouble(),
                color: Colors.red[400],
                width: 30,
                borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Gráfico de evolución temporal de actividad
  Widget _buildActivityTrendChart(GuardReportsViewModel guardReportsViewModel) {
    // Simulamos datos de evolución temporal (últimos 7 días)
    final ahora = DateTime.now();
    final datos = List.generate(7, (index) {
      final fecha = ahora.subtract(Duration(days: 6 - index));
      // En una implementación real, esto vendría del ViewModel
      return {
        'fecha': fecha,
        'actividad': (100 + (index * 10) + (index % 3) * 5).toDouble(),
      };
    });
    
    final maxValue = datos.map((d) => d['actividad'] as double).reduce((a, b) => a > b ? a : b);
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Evolución Temporal de Actividad',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.fullscreen),
                  onPressed: () {
                    _showFullScreenChart(
                      context,
                      'Evolución Temporal',
                      _buildTrendLineChart(datos, maxValue),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(color: Colors.grey[300]!, strokeWidth: 1);
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < datos.length) {
                            final fecha = datos[value.toInt()]['fecha'] as DateTime;
                            return Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                '${fecha.day}/${fecha.month}',
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
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(fontSize: 10),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (datos.length - 1).toDouble(),
                  minY: 0,
                  maxY: maxValue * 1.2,
                  lineBarsData: [
                    LineChartBarData(
                      spots: datos.asMap().entries.map((entry) {
                        return FlSpot(entry.key.toDouble(), entry.value['actividad'] as double);
                      }).toList(),
                      isCurved: true,
                      color: Colors.blue[400],
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: Colors.blue[600]!,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Colors.blue[100]!.withOpacity(0.3),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    enabled: true,
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => Colors.blue,
                      tooltipRoundedRadius: 8,
                      tooltipPadding: EdgeInsets.all(8),
                      getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                        return touchedBarSpots.map((barSpot) {
                          final index = barSpot.x.toInt();
                          final fecha = datos[index]['fecha'] as DateTime;
                          return LineTooltipItem(
                            '${fecha.day}/${fecha.month}/${fecha.year}\n'
                            'Actividad: ${barSpot.y.toInt()}',
                            TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendLineChart(List<Map<String, dynamic>> datos, double maxValue) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: Colors.grey[300]!, strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() >= 0 && value.toInt() < datos.length) {
                  final fecha = datos[value.toInt()]['fecha'] as DateTime;
                  return Text('${fecha.day}/${fecha.month}');
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
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (datos.length - 1).toDouble(),
        minY: 0,
        maxY: maxValue * 1.2,
        lineBarsData: [
          LineChartBarData(
            spots: datos.asMap().entries.map((entry) {
              return FlSpot(entry.key.toDouble(), entry.value['actividad'] as double);
            }).toList(),
            isCurved: true,
            color: Colors.blue[400],
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 5,
                  color: Colors.blue[600]!,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.blue[100]!.withOpacity(0.3),
            ),
          ),
        ],
        lineTouchData: LineTouchData(enabled: true),
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.rectangle),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  void _showFullScreenChart(BuildContext context, String title, Widget chart) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              Expanded(child: chart),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDayColor(int index) {
    final colors = [
      Colors.blue[400]!,
      Colors.green[400]!,
      Colors.orange[400]!,
      Colors.purple[400]!,
      Colors.red[400]!,
      Colors.teal[400]!,
      Colors.indigo[400]!,
    ];
    return colors[index % colors.length];
  }

  Color _getChartColor(int index) {
    final colors = [
      Colors.blue[400]!,
      Colors.green[400]!,
      Colors.orange[400]!,
      Colors.purple[400]!,
      Colors.red[400]!,
      Colors.teal[400]!,
      Colors.indigo[400]!,
      Colors.pink[400]!,
      Colors.amber[400]!,
      Colors.cyan[400]!,
    ];
    return colors[index % colors.length];
  }

  Widget _buildTopPuertas(GuardReportsViewModel guardReportsViewModel) {
    final topPuertas = guardReportsViewModel.topPuertas.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Puertas por Actividad',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ...topPuertas.take(5).map((entry) => Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(entry.key)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${entry.value}',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
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
