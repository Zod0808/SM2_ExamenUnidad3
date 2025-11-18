import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/api_service.dart';
import '../../services/session_guard_service.dart';

class SessionManagementView extends StatefulWidget {
  final String adminId;
  final String adminName;

  const SessionManagementView({
    Key? key,
    required this.adminId,
    required this.adminName,
  }) : super(key: key);

  @override
  State<SessionManagementView> createState() => _SessionManagementViewState();
}

class _SessionManagementViewState extends State<SessionManagementView> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _sesionesActivas = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _cargarSesionesActivas();
  }

  Future<void> _cargarSesionesActivas() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final sesiones = await _apiService.getSesionesActivas();
      setState(() {
        _sesionesActivas = sesiones;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _forzarFinalizacion(
    String guardiaId,
    String guardiaNombre,
  ) async {
    final confirmacion = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar Finalización', style: GoogleFonts.lato()),
        content: Text(
          '¿Está seguro de que desea finalizar la sesión de $guardiaNombre?\n\n'
          'Esta acción cerrará todas las sesiones activas del guardia.',
          style: GoogleFonts.lato(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar', style: GoogleFonts.lato()),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Finalizar'),
          ),
        ],
      ),
    );

    if (confirmacion == true) {
      try {
        final success = await _apiService.forzarFinalizacionSesion(
          guardiaId: guardiaId,
          adminId: widget.adminId,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Sesión finalizada exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
          _cargarSesionesActivas();
        } else {
          _mostrarError('Error al finalizar la sesión');
        }
      } catch (e) {
        _mostrarError('Error: ${e.toString()}');
      }
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Sesiones', style: GoogleFonts.lato()),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _cargarSesionesActivas,
            icon: Icon(Icons.refresh),
            tooltip: 'Actualizar',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _cargarSesionesActivas,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Cargando sesiones activas...',
              style: GoogleFonts.lato(fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              'Error al cargar sesiones',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: GoogleFonts.lato(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _cargarSesionesActivas,
              child: Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (_sesionesActivas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.security, size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'No hay sesiones activas',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Todos los guardias están desconectados',
              style: GoogleFonts.lato(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildResumenGeneral(),
        SizedBox(height: 24),
        Text(
          'Sesiones Activas (${_sesionesActivas.length})',
          style: GoogleFonts.lato(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16),
        ..._sesionesActivas.map((sesion) => _buildSesionCard(sesion)),
      ],
    );
  }

  Widget _buildResumenGeneral() {
    final totalSesiones = _sesionesActivas.length;
    final puntoMap = <String, int>{};

    for (final sesion in _sesionesActivas) {
      final punto = sesion['punto_control'] ?? 'Desconocido';
      puntoMap[punto] = (puntoMap[punto] ?? 0) + 1;
    }

    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resumen General',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total Guardias',
                    totalSesiones.toString(),
                    Icons.security,
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard(
                    'Puntos Activos',
                    puntoMap.length.toString(),
                    Icons.location_on,
                    Colors.green,
                  ),
                ),
              ],
            ),
            if (puntoMap.isNotEmpty) ...[
              SizedBox(height: 16),
              Text(
                'Distribución por Punto de Control:',
                style: GoogleFonts.lato(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8),
              ...puntoMap.entries.map(
                (entry) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(entry.key, style: GoogleFonts.lato()),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${entry.value} guardia${entry.value > 1 ? 's' : ''}',
                          style: GoogleFonts.lato(
                            fontSize: 12,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
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

  Widget _buildSesionCard(Map<String, dynamic> sesion) {
    final sessionStart = sesion['session_start'] != null
        ? DateTime.tryParse(sesion['session_start'])
        : null;
    final tiempoSesion = sessionStart != null
        ? DateTime.now().difference(sessionStart)
        : null;

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green,
          child: Icon(Icons.security, color: Colors.white),
        ),
        title: Text(
          sesion['guardia_nombre'] ?? 'Desconocido',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${sesion['guardia_id'] ?? 'N/A'}'),
            Text('Punto: ${sesion['punto_control'] ?? 'N/A'}'),
            if (sessionStart != null)
              Text('Inicio: ${_formatDateTime(sessionStart)}'),
            if (tiempoSesion != null)
              Text('Duración: ${_formatDuration(tiempoSesion)}'),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.close, color: Colors.red),
          onPressed: () => _forzarFinalizacion(
            sesion['guardia_id'] ?? '',
            sesion['guardia_nombre'] ?? 'Guardia',
          ),
          tooltip: 'Finalizar sesión',
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration duration) {
    final horas = duration.inHours;
    final minutos = duration.inMinutes % 60;

    if (horas > 0) {
      return '${horas}h ${minutos}m';
    } else {
      return '${minutos}m';
    }
  }
}

