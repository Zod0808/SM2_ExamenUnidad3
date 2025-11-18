import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/offline_sync_service.dart';

class SyncConfigView extends StatefulWidget {
  @override
  _SyncConfigViewState createState() => _SyncConfigViewState();
}

class _SyncConfigViewState extends State<SyncConfigView> {
  @override
  void initState() {
    super.initState();
    // Inicializar sincronización automática
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final syncService = OfflineSyncService();
      if (syncService.autoSyncEnabled) {
        syncService.initialize();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sincronización de Datos', style: GoogleFonts.lato()),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () async {
              final syncService = OfflineSyncService();
              await syncService.performSync(forceSync: true);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sincronización manual iniciada'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: ChangeNotifierProvider.value(
        value: OfflineSyncService(),
        child: Consumer<OfflineSyncService>(
          builder: (context, syncService, child) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Estado actual
                  _buildStatusCard(syncService),
                  SizedBox(height: 16),

                  // Configuración
                  _buildConfigCard(syncService),
                  SizedBox(height: 16),

                  // Acciones rápidas
                  _buildQuickActions(syncService),
                  SizedBox(height: 16),

                  // Log de sincronización
                  _buildSyncLog(syncService),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatusCard(OfflineSyncService syncService) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  syncService.isSyncing
                      ? Icons.sync
                      : syncService.autoSyncEnabled
                          ? Icons.sync_alt
                          : Icons.sync_disabled,
                  color: syncService.isSyncing
                      ? Colors.blue
                      : syncService.autoSyncEnabled
                          ? Colors.green
                          : Colors.red,
                ),
                SizedBox(width: 8),
                Text(
                  'Estado de Sincronización',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),

            _buildStatusRow(
              'Estado actual',
              syncService.isSyncing ? 'Sincronizando...' : 'En reposo',
              syncService.isSyncing ? Colors.blue : Colors.green,
            ),

            _buildStatusRow(
              'Sincronización automática',
              syncService.autoSyncEnabled ? 'Activada' : 'Desactivada',
              syncService.autoSyncEnabled ? Colors.green : Colors.red,
            ),

            _buildStatusRow(
              'Última sincronización',
              syncService.getLastSyncStatus(),
              Colors.grey[700]!,
            ),

            if (syncService.autoSyncEnabled &&
                syncService.getTimeToNextSync() != null)
              _buildStatusRow(
                'Próxima sincronización',
                _formatDuration(syncService.getTimeToNextSync()!),
                Colors.blue,
              ),

            if (syncService.lastSyncError != null)
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  border: Border.all(color: Colors.red[200]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[600], size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Error: ${syncService.lastSyncError}',
                        style: GoogleFonts.lato(
                          color: Colors.red[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            if (syncService.pendingSyncCount > 0)
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 8),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  border: Border.all(color: Colors.orange[200]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(Icons.pending_actions,
                        color: Colors.orange[600], size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${syncService.pendingSyncCount} elementos pendientes de sincronizar',
                        style: GoogleFonts.lato(
                          color: Colors.orange[700],
                          fontSize: 12,
                        ),
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

  Widget _buildConfigCard(OfflineSyncService syncService) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuración',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),

            // Toggle sincronización automática
            SwitchListTile(
              title: Text('Sincronización automática',
                  style: GoogleFonts.lato()),
              subtitle: Text('Sincronizar datos automáticamente',
                  style: GoogleFonts.lato()),
              value: syncService.autoSyncEnabled,
              onChanged: (value) {
                syncService.toggleAutoSync(value);
              },
            ),

            Divider(),

            // Intervalo de sincronización
            ListTile(
              title: Text('Intervalo de sincronización',
                  style: GoogleFonts.lato()),
              subtitle: Text('${syncService.syncIntervalMinutes} minutos',
                  style: GoogleFonts.lato()),
              trailing: PopupMenuButton<int>(
                onSelected: (minutes) {
                  syncService.configureSyncInterval(minutes);
                },
                itemBuilder: (context) => [
                  PopupMenuItem(value: 5, child: Text('5 minutos')),
                  PopupMenuItem(value: 15, child: Text('15 minutos')),
                  PopupMenuItem(value: 30, child: Text('30 minutos')),
                  PopupMenuItem(value: 60, child: Text('1 hora')),
                  PopupMenuItem(value: 120, child: Text('2 horas')),
                  PopupMenuItem(value: 240, child: Text('4 horas')),
                ],
                child: Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(OfflineSyncService syncService) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acciones Rápidas',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: syncService.isSyncing
                    ? null
                    : () async {
                        bool success = await syncService.performSync(
                          forceSync: true,
                        );
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                success
                                    ? '✅ Sincronización completada'
                                    : '❌ Error en la sincronización',
                              ),
                              backgroundColor:
                                  success ? Colors.green : Colors.red,
                            ),
                          );
                        }
                      },
                icon: syncService.isSyncing
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(Icons.sync),
                label: Text('Sincronizar Ahora'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncLog(OfflineSyncService syncService) {
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
                  'Log de Sincronización',
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    // Limpiar log (si hay método disponible)
                  },
                  icon: Icon(Icons.delete_outline, size: 18),
                  label: Text('Limpiar'),
                ),
              ],
            ),
            SizedBox(height: 12),

            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: syncService.syncLog.isEmpty
                  ? Center(
                      child: Text(
                        'No hay entradas en el log',
                        style: GoogleFonts.lato(color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(8),
                      itemCount: syncService.syncLog.length,
                      itemBuilder: (context, index) {
                        final entry = syncService.syncLog[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 2),
                          child: Text(
                            entry,
                            style: GoogleFonts.lato(
                              fontSize: 12,
                              fontFamily: 'monospace',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$label:',
              style: GoogleFonts.lato(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.lato(color: color),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} días';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} horas';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minutos';
    } else {
      return '${duration.inSeconds} segundos';
    }
  }
}

