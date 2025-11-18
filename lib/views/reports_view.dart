import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/reports_viewmodel.dart';
import '../../widgets/status_widgets.dart';
import '../../widgets/report_filters_widget.dart';
import 'guard_reports_view.dart';
import 'active_students_report_view.dart';
import 'ml_predictions_view.dart';
import 'bus_efficiency_view.dart';
import 'export_reports_view.dart';

class ReportsView extends StatefulWidget {
  @override
  _ReportsViewState createState() => _ReportsViewState();
}

class _ReportsViewState extends State<ReportsView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ReportFilters _filters = ReportFilters();

  @override
  void initState() {
    super.initState();
    // Actualizar a 8 pestañas: Estadísticas, Asistencias, Estudiantes, Más Activos, Guardias, ML, Buses, Exportar
    _tabController = TabController(length: 8, vsync: this);
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
    final reportsViewModel = Provider.of<ReportsViewModel>(
      context,
      listen: false,
    );
    await reportsViewModel.loadAllData();
  }

  void _onFiltersChanged(ReportFilters filters) {
    final reportsViewModel = Provider.of<ReportsViewModel>(
      context,
      listen: false,
    );
    reportsViewModel.updateFilters(
      fechaInicio: filters.fechaInicio,
      fechaFin: filters.fechaFin,
      carrera: filters.carreraSeleccionada,
      facultad: filters.facultadSeleccionada,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReportsViewModel>(
      builder: (context, reportsViewModel, child) {
        if (reportsViewModel.isLoading) {
          return LoadingWidget(message: 'Cargando reportes...');
        }

        if (reportsViewModel.errorMessage != null) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              SizedBox(height: 16),
              Text(reportsViewModel.errorMessage!, textAlign: TextAlign.center),
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
            // Header con resumen
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
                  Text(
                    'Reportes y Análisis',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          'Asistencias Hoy',
                          '${reportsViewModel.getTotalAsistenciasHoy()}',
                          Colors.blue,
                          Icons.today,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: _buildSummaryCard(
                          'Esta Semana',
                          '${reportsViewModel.getTotalAsistenciasEstaSemana()}',
                          Colors.green,
                          Icons.date_range,
                        ),
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
                Tab(text: 'Estadísticas', icon: Icon(Icons.bar_chart)),
                Tab(text: 'Asistencias', icon: Icon(Icons.list)),
                Tab(text: 'Estudiantes', icon: Icon(Icons.school)),
                Tab(text: 'Más Activos', icon: Icon(Icons.emoji_events)),
                Tab(text: 'Guardias', icon: Icon(Icons.security)),
                Tab(text: 'ML', icon: Icon(Icons.psychology)),
                Tab(text: 'Buses', icon: Icon(Icons.directions_bus)),
                Tab(text: 'Exportar', icon: Icon(Icons.download)),
              ],
            ),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildStatisticsTab(reportsViewModel),
                  _buildAttendanceTab(reportsViewModel),
                  _buildStudentsTab(reportsViewModel),
                  ActiveStudentsReportView(),
                  GuardReportsView(),
                  _buildMLReportsTab(),
                  _buildBusReportsTab(),
                  _buildExportTab(reportsViewModel),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFiltersSection(ReportsViewModel reportsViewModel) {
    return ReportFiltersWidget(
      filters: _filters,
      carreras: reportsViewModel.listaCarreras,
      facultades: reportsViewModel.listaFacultades,
      onFiltersChanged: _onFiltersChanged,
      mostrarFacultades: true,
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsTab(ReportsViewModel reportsViewModel) {
    return RefreshIndicator(
      onRefresh: _loadReportsData,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filtros
            _buildFiltersSection(reportsViewModel),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top facultades
                  _buildTopFacultades(reportsViewModel),
            SizedBox(height: 24),

                  // Distribución por hora (simplificada)
                  _buildHourDistribution(reportsViewModel),
                  SizedBox(height: 24),

                  // Resumen general
                  _buildGeneralSummary(reportsViewModel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopFacultades(ReportsViewModel reportsViewModel) {
    final asistenciasFiltradas = reportsViewModel.asistenciasFiltradas;
    final topFacultades = _getTopFacultadesFromList(asistenciasFiltradas);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Facultades por Asistencias',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            ...topFacultades
                .map(
                  (entry) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(entry.key)),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${entry.value}',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHourDistribution(ReportsViewModel reportsViewModel) {
    final asistenciasFiltradas = reportsViewModel.asistenciasFiltradas;
    final asistenciasPorHora = _getAsistenciasPorHoraFromList(asistenciasFiltradas);
    final asistenciasPorDia = _getAsistenciasPorDiaFromList(asistenciasFiltradas);

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
                  'Flujo por Horarios y Días (US047)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.fullscreen),
                  onPressed: () => _showHourlyFlowDialog(context, asistenciasPorHora, asistenciasPorDia),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Gráfico de barras mejorado con fl_chart
            Container(
              height: 250,
              child: _buildAdvancedHourlyChart(asistenciasPorHora, asistenciasFiltradas),
            ),
            SizedBox(height: 12),
            // Filtros temporales
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Día de la semana',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: ['Todos', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo']
                        .map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                    onChanged: (value) {
                      // Filtrar por día de la semana
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Período',
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: ['Última semana', 'Último mes', 'Últimos 3 meses', 'Personalizado']
                        .map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                    onChanged: (value) {
                      // Filtrar por período
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

  // Métodos auxiliares para gráficos avanzados

  Widget _buildGeneralSummary(ReportsViewModel reportsViewModel) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen General',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            _buildSummaryRow(
              'Total Estudiantes',
              '${reportsViewModel.alumnos.length}',
            ),
            _buildSummaryRow(
              'Total Asistencias',
              '${reportsViewModel.asistencias.length}',
            ),
            _buildSummaryRow(
              'Total Facultades',
              '${reportsViewModel.facultades.length}',
            ),
            _buildSummaryRow(
              'Total Escuelas',
              '${reportsViewModel.escuelas.length}',
            ),
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

  Widget _buildAttendanceTab(ReportsViewModel reportsViewModel) {
    final asistenciasFiltradas = reportsViewModel.asistenciasFiltradas;
    
    return Column(
      children: [
        // Filtros
        _buildFiltersSection(reportsViewModel),
        // Lista de asistencias
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadReportsData,
            child: asistenciasFiltradas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        SizedBox(height: 16),
                        Text(
                          reportsViewModel.tieneFiltrosActivos
                              ? 'No hay resultados con los filtros aplicados'
                              : 'No hay asistencias registradas',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: asistenciasFiltradas.length,
                    itemBuilder: (context, index) {
                      final asistencia = asistenciasFiltradas[index];
          return Card(
            margin: EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green[100],
                child: Icon(Icons.check, color: Colors.green),
              ),
              title: Text(asistencia.nombreCompleto),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Código: ${asistencia.codigoUniversitario}'),
                  Text('Facultad: ${asistencia.siglasFacultad}'),
                  Text('Fecha: ${asistencia.fechaFormateada}'),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    asistencia.tipo.descripcion,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: asistencia.tipo == TipoMovimiento.entrada ? Colors.green : Colors.red,
                    ),
                  ),
                  Text(
                    asistencia.puerta,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStudentsTab(ReportsViewModel reportsViewModel) {
    final alumnosFiltrados = reportsViewModel.alumnosFiltrados;
    
    return Column(
      children: [
        // Filtros
        _buildFiltersSection(reportsViewModel),
        // Lista de estudiantes
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadReportsData,
            child: alumnosFiltrados.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                        SizedBox(height: 16),
                        Text(
                          reportsViewModel.tieneFiltrosActivos
                              ? 'No hay estudiantes con los filtros aplicados'
                              : 'No hay estudiantes registrados',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: alumnosFiltrados.length,
                    itemBuilder: (context, index) {
                      final alumno = alumnosFiltrados[index];
          return Card(
            margin: EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    alumno.isActive ? Colors.green[100] : Colors.red[100],
                child: Icon(
                  Icons.school,
                  color: alumno.isActive ? Colors.green : Colors.red,
                ),
              ),
              title: Text(alumno.nombreCompleto),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Código: ${alumno.codigoUniversitario}'),
                  Text('Facultad: ${alumno.siglasFacultad}'),
                  Text('Escuela: ${alumno.siglasEscuela}'),
                ],
              ),
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: alumno.isActive ? Colors.green[100] : Colors.red[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  alumno.isActive ? 'Activo' : 'Inactivo',
                  style: TextStyle(
                    color:
                        alumno.isActive ? Colors.green[700] : Colors.red[700],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
                      ),
                    );
                  },
                ),
          ),
        ),
      ],
    );
  }

  // Métodos auxiliares para estadísticas filtradas
  List<MapEntry<String, int>> _getTopFacultadesFromList(List asistencias, {int limit = 5}) {
    Map<String, int> asistenciasPorFacultad = {};

    for (var asistencia in asistencias) {
      final siglas = asistencia.siglasFacultad ?? 'N/A';
      asistenciasPorFacultad[siglas] = (asistenciasPorFacultad[siglas] ?? 0) + 1;
    }

    var sorted = asistenciasPorFacultad.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(limit).toList();
  }

  Map<int, int> _getAsistenciasPorHoraFromList(List asistencias) {
    Map<int, int> asistenciasPorHora = {};

    for (var asistencia in asistencias) {
      int hora = asistencia.fechaHora.hour;
      asistenciasPorHora[hora] = (asistenciasPorHora[hora] ?? 0) + 1;
    }

    return asistenciasPorHora;
  }

  Map<String, int> _getAsistenciasPorDiaFromList(List asistencias) {
    Map<String, int> asistenciasPorDia = {};

    for (var asistencia in asistencias) {
      String dia = asistencia.fechaHora.toString().split(' ')[0];
      asistenciasPorDia[dia] = (asistenciasPorDia[dia] ?? 0) + 1;
    }

    return asistenciasPorDia;
  }

  // Gráfico avanzado de flujo horario con fl_chart
  Widget _buildAdvancedHourlyChart(Map<int, int> asistenciasPorHora, List asistencias) {
    final maxValue = asistenciasPorHora.values.isNotEmpty
        ? asistenciasPorHora.values.reduce((a, b) => a > b ? a : b)
        : 1;

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
              final hora = group.x.toInt();
              final asistencias = asistenciasPorHora[hora] ?? 0;
              return BarTooltipItem(
                '${hora}:00\n$asistencias asistencias',
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
                if (value.toInt() >= 0 && value.toInt() < 24 && value.toInt() % 2 == 0) {
                  return Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      '${value.toInt()}',
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
        barGroups: List.generate(24, (index) {
          final asistencias = asistenciasPorHora[index] ?? 0;
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: asistencias.toDouble(),
                color: _getHourColor(index),
                width: 20,
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }),
      ),
    );
  }

  Color _getHourColor(int hour) {
    // Colores diferentes para horas pico (mañana y tarde)
    if (hour >= 7 && hour <= 9) return Colors.orange; // Mañana
    if (hour >= 17 && hour <= 19) return Colors.red; // Tarde
    if (hour >= 10 && hour <= 16) return Colors.blue; // Día
    return Colors.grey; // Noche/madrugada
  }

  // Diálogo para vista completa de flujo horario con drill-down
  void _showHourlyFlowDialog(BuildContext context, Map<int, int> asistenciasPorHora, Map<String, int> asistenciasPorDia) {
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
                  Text('Flujo Horario Detallado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(icon: Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Container(
                        height: 300,
                        child: _buildAdvancedHourlyChart(asistenciasPorHora, []),
                      ),
                      SizedBox(height: 24),
                      Text('Distribución por Día', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      ...asistenciasPorDia.entries.toList()
                        ..sort((a, b) => b.value.compareTo(a.value))
                        ..take(10)
                        ..map((entry) => ListTile(
                          title: Text(entry.key),
                          trailing: Text('${entry.value}', style: TextStyle(fontWeight: FontWeight.bold)),
                        )).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Pestaña de reportes ML
  Widget _buildMLReportsTab() {
    return MLPredictionsView();
  }

  // Pestaña de reportes de buses
  Widget _buildBusReportsTab() {
    return BusEfficiencyView();
  }

  // Pestaña de exportación
  Widget _buildExportTab(ReportsViewModel reportsViewModel) {
    return ExportReportsView(reportsViewModel: reportsViewModel);
  }
}
