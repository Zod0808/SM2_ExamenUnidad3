import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/presencia_model.dart';
import '../../models/decision_manual_model.dart';
import '../../services/autorizacion_service.dart';

class PresenciaDashboardView extends StatefulWidget {
  final String guardiaId;
  final String guardiaNombre;

  const PresenciaDashboardView({
    Key? key,
    required this.guardiaId,
    required this.guardiaNombre,
  }) : super(key: key);

  @override
  State<PresenciaDashboardView> createState() => _PresenciaDashboardViewState();
}

class _PresenciaDashboardViewState extends State<PresenciaDashboardView>
    with TickerProviderStateMixin {
  final AutorizacionService _autorizacionService = AutorizacionService();

  late TabController _tabController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _cargarDatos();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);

    try {
      await Future.wait([
        _autorizacionService.cargarPresenciaActual(),
        _autorizacionService.cargarHistorialDecisiones(widget.guardiaId),
      ]);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Control de Presencia',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[700],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _cargarDatos),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(icon: Icon(Icons.people), text: 'Presencia'),
            Tab(icon: Icon(Icons.history), text: 'Decisiones'),
            Tab(icon: Icon(Icons.analytics), text: 'Estadísticas'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildPresenciaTab(),
                _buildDecisionesTab(),
                _buildEstadisticasTab(),
              ],
            ),
    );
  }

  Widget _buildPresenciaTab() {
    return AnimatedBuilder(
      animation: _autorizacionService,
      builder: (context, child) {
        final presencias = _autorizacionService.presenciaActual;
        final personasEnCampus = _autorizacionService.personasEnCampus;
        final personasLargoTiempo = _autorizacionService.personasLargoTiempo;

        return RefreshIndicator(
          onRefresh: _cargarDatos,
          child: CustomScrollView(
            slivers: [
              // Header con estadísticas rápidas
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'En Campus',
                          personasEnCampus.toString(),
                          Icons.people,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Largo Tiempo',
                          personasLargoTiempo.length.toString(),
                          Icons.access_time,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Lista de personas en campus
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Personas en Campus',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),

              presencias.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay personas en el campus',
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final presencia = presencias[index];
                          return _buildPresenciaCard(presencia);
                        },
                        childCount: presencias.length,
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDecisionesTab() {
    return AnimatedBuilder(
      animation: _autorizacionService,
      builder: (context, child) {
        final decisiones = _autorizacionService.decisionesRecientes;

        return RefreshIndicator(
          onRefresh: _cargarDatos,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Decisiones Recientes (24h)',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              decisiones.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No hay decisiones recientes',
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final decision = decisiones[index];
                          return _buildDecisionCard(decision);
                        },
                        childCount: decisiones.length,
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEstadisticasTab() {
    return AnimatedBuilder(
      animation: _autorizacionService,
      builder: (context, child) {
        final stats = _autorizacionService.estadisticasDecisiones;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Estadísticas del Guardia',
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total Decisiones',
                      stats['total'].toString(),
                      Icons.fact_check,
                      Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Autorizadas',
                      stats['autorizadas'].toString(),
                      Icons.check_circle,
                      Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildStatCard(
                'Denegadas',
                stats['denegadas'].toString(),
                Icons.cancel,
                Colors.red,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresenciaCard(PresenciaModel presencia) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: presencia.estaDentro ? Colors.green : Colors.grey,
          child: Icon(
            presencia.estaDentro ? Icons.check : Icons.close,
            color: Colors.white,
          ),
        ),
        title: Text(
          presencia.estudianteNombre,
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DNI: ${presencia.estudianteDni}'),
            Text('${presencia.facultad} - ${presencia.escuela}'),
            Text('Tiempo: ${presencia.tiempoFormateado}'),
          ],
        ),
        trailing: Text(
          presencia.statusPresencia,
          style: GoogleFonts.lato(
            fontSize: 12,
            color: presencia.llevaVariasHoras ? Colors.orange : Colors.grey,
            fontWeight: presencia.llevaVariasHoras ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildDecisionCard(DecisionManualModel decision) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: decision.autorizado ? Colors.green : Colors.red,
          child: Icon(
            decision.autorizado ? Icons.check : Icons.close,
            color: Colors.white,
          ),
        ),
        title: Text(
          decision.estudianteNombre,
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Razón: ${decision.razon}'),
            Text('Tipo: ${decision.tipoAcceso}'),
            Text(decision.tiempoTranscurrido),
          ],
        ),
        trailing: Text(
          decision.statusText,
          style: GoogleFonts.lato(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: decision.autorizado ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}

