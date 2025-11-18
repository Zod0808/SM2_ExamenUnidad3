import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/offline_sync_service.dart';

class ConflictResolutionView extends StatefulWidget {
  final List<ConflictData> conflicts;
  final Function(List<ConflictData>)? onConflictsResolved;

  const ConflictResolutionView({
    Key? key,
    required this.conflicts,
    this.onConflictsResolved,
  }) : super(key: key);

  @override
  State<ConflictResolutionView> createState() => _ConflictResolutionViewState();
}

class _ConflictResolutionViewState extends State<ConflictResolutionView> {
  final Map<String, ConflictResolution> _resolutions = {};
  final OfflineSyncService _syncService = OfflineSyncService();
  final ApiService _apiService = ApiService();
  bool _isResolving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resolver Conflictos de Sincronización',
          style: GoogleFonts.lato(),
        ),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: Consumer<OfflineSyncService>(
        builder: (context, syncService, child) {
          if (widget.conflicts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, size: 80, color: Colors.green),
                  SizedBox(height: 16),
                  Text(
                    'No hay conflictos pendientes',
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Header con información de conflictos
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.orange[50],
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange[700]),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Conflictos de Sincronización Detectados',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[700],
                            ),
                          ),
                          Text(
                            '${widget.conflicts.length} elementos necesitan resolución manual',
                            style: GoogleFonts.lato(color: Colors.orange[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Lista de conflictos
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: widget.conflicts.length,
                  itemBuilder: (context, index) {
                    final conflict = widget.conflicts[index];
                    return _buildConflictCard(conflict, index);
                  },
                ),
              ),

              // Botones de acción
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _resolveAllWithServer,
                            child: Text('Usar Datos del Servidor'),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _resolveAllWithLocal,
                            child: Text('Usar Datos Locales'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _resolutions.length == widget.conflicts.length
                            ? _applyResolutions
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: _isResolving
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text('Aplicar Resoluciones'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildConflictCard(ConflictData conflict, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Conflicto ${index + 1}',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  conflict.collection,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            // Información de timestamps
            Row(
              children: [
                Expanded(
                  child: _buildTimestampInfo(
                    'Servidor',
                    conflict.serverTimestamp,
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildTimestampInfo(
                    'Local',
                    conflict.localTimestamp,
                    Colors.orange,
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Comparación de datos
            _buildDataComparison(conflict),

            SizedBox(height: 16),

            // Opciones de resolución
            Text(
              'Seleccionar resolución:',
              style: GoogleFonts.lato(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _buildResolutionOptions(conflict),
          ],
        ),
      ),
    );
  }

  Widget _buildTimestampInfo(String label, DateTime timestamp, Color color) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 4),
          Text(
            '${timestamp.day}/${timestamp.month} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
            style: GoogleFonts.lato(fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildDataComparison(ConflictData conflict) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cambios detectados:',
            style: GoogleFonts.lato(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          SizedBox(height: 8),
          ...conflict.serverData.keys
              .where(
                (key) => conflict.serverData[key] != conflict.localData[key],
              )
              .take(3)
              .map((key) => _buildFieldComparison(key, conflict)),
        ],
      ),
    );
  }

  Widget _buildFieldComparison(String field, ConflictData conflict) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$field:',
              style: GoogleFonts.lato(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Servidor: ${conflict.serverData[field]} | Local: ${conflict.localData[field]}',
              style: GoogleFonts.lato(fontSize: 10),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResolutionOptions(ConflictData conflict) {
    return Column(
      children: [
        RadioListTile<ConflictResolution>(
          title: Text(
            'Usar datos del servidor',
            style: GoogleFonts.lato(fontSize: 14),
          ),
          subtitle: Text(
            'Los datos remotos sobrescribirán los locales',
            style: GoogleFonts.lato(fontSize: 12),
          ),
          value: ConflictResolution.serverWins,
          groupValue: _resolutions[conflict.id],
          onChanged: (value) =>
              setState(() => _resolutions[conflict.id] = value!),
          dense: true,
        ),
        RadioListTile<ConflictResolution>(
          title: Text(
            'Usar datos locales',
            style: GoogleFonts.lato(fontSize: 14),
          ),
          subtitle: Text(
            'Los datos locales sobrescribirán los remotos',
            style: GoogleFonts.lato(fontSize: 12),
          ),
          value: ConflictResolution.clientWins,
          groupValue: _resolutions[conflict.id],
          onChanged: (value) =>
              setState(() => _resolutions[conflict.id] = value!),
          dense: true,
        ),
        RadioListTile<ConflictResolution>(
          title: Text(
            'Fusionar datos',
            style: GoogleFonts.lato(fontSize: 14),
          ),
          subtitle: Text(
            'Combinar ambos conjuntos de datos automáticamente',
            style: GoogleFonts.lato(fontSize: 12),
          ),
          value: ConflictResolution.merge,
          groupValue: _resolutions[conflict.id],
          onChanged: (value) =>
              setState(() => _resolutions[conflict.id] = value!),
          dense: true,
        ),
      ],
    );
  }

  void _resolveAllWithServer() {
    setState(() {
      for (var conflict in widget.conflicts) {
        _resolutions[conflict.id] = ConflictResolution.serverWins;
      }
    });
  }

  void _resolveAllWithLocal() {
    setState(() {
      for (var conflict in widget.conflicts) {
        _resolutions[conflict.id] = ConflictResolution.clientWins;
      }
    });
  }

  Future<void> _applyResolutions() async {
    setState(() => _isResolving = true);

    try {
      for (var conflict in widget.conflicts) {
        final resolution = _resolutions[conflict.id];
        if (resolution == null) continue;

        // Aquí implementar la lógica de resolución según el tipo
        switch (resolution) {
          case ConflictResolution.serverWins:
            // Descartar cambios locales
            await _applyServerVersion(conflict);
            break;
          case ConflictResolution.clientWins:
            // Forzar subida de cambios locales
            await _applyClientVersion(conflict);
            break;
          case ConflictResolution.merge:
            // Fusionar datos
            await _applyMergedVersion(conflict);
            break;
          case ConflictResolution.manual:
            // No hacer nada, requiere acción manual
            break;
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Conflictos resueltos exitosamente'),
            backgroundColor: Colors.green,
          ),
        );

        if (widget.onConflictsResolved != null) {
          widget.onConflictsResolved!(widget.conflicts);
        }

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al resolver conflictos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isResolving = false);
      }
    }
  }

  Future<void> _applyServerVersion(ConflictData conflict) async {
    // Implementar lógica para aplicar versión del servidor
    // Por ahora, solo registrar en log
    debugPrint('Aplicando versión del servidor para: ${conflict.collection}');
  }

  Future<void> _applyClientVersion(ConflictData conflict) async {
    // Implementar lógica para aplicar versión del cliente
    debugPrint('Aplicando versión del cliente para: ${conflict.collection}');
  }

  Future<void> _applyMergedVersion(ConflictData conflict) async {
    // Implementar lógica para fusionar datos
    debugPrint('Fusionando datos para: ${conflict.collection}');
  }
}

