import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../services/offline_sync_service.dart';
import '../../services/connectivity_service.dart';
import '../../widgets/connectivity_status_widget.dart';

class OfflineManagementView extends StatefulWidget {
  const OfflineManagementView({Key? key}) : super(key: key);

  @override
  State<OfflineManagementView> createState() => _OfflineManagementViewState();
}

class _OfflineManagementViewState extends State<OfflineManagementView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gestión Offline',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: ConnectivityStatusWidget(
        child: Consumer<OfflineSyncService>(
          builder: (context, offlineService, _) {
            return RefreshIndicator(
              onRefresh: () => _refreshData(offlineService),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildConnectionStatusCard(),
                    const SizedBox(height: 16),
                    _buildStatisticsCard(offlineService),
                    const SizedBox(height: 16),
                    _buildSyncStatusCard(offlineService),
                    const SizedBox(height: 16),
                    _buildActionsCard(offlineService),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _refreshData(OfflineSyncService offlineService) async {
    // Simular refresh de datos
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  Widget _buildConnectionStatusCard() {
    return Consumer<ConnectivityService>(
      builder: (context, connectivityService, child) {
        Color statusColor;
        IconData statusIcon;
        String statusText;

        if (connectivityService.isOnline) {
          statusColor = Colors.green;
          statusIcon = Icons.cloud_done;
          statusText = 'En línea';
        } else {
          statusColor = Colors.red;
          statusIcon = Icons.cloud_off;
          statusText = 'Sin conexión';
        }

        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(statusIcon, color: statusColor, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estado de Conexión',
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            statusText,
                            style: GoogleFonts.lato(
                              fontSize: 16,
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!connectivityService.isOnline) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.red.shade600,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'La aplicación está funcionando en modo offline. Los datos se sincronizarán automáticamente al restaurar la conexión.',
                            style: GoogleFonts.lato(
                              color: Colors.red.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                if (connectivityService.lastOnlineTime != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Última conexión: ${_formatDateTime(connectivityService.lastOnlineTime!)}',
                    style: GoogleFonts.lato(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatisticsCard(OfflineSyncService offlineService) {
    final stats = offlineService.getSyncStats();
    final pendingCount = offlineService.pendingSyncCount;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estadísticas de Sincronización',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Pendientes',
                    pendingCount.toString(),
                    Colors.orange,
                    Icons.pending_actions,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Sincronizando',
                    offlineService.isSyncing ? '1' : '0',
                    Colors.blue,
                    Icons.sync,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Estado',
                    offlineService.autoSyncEnabled ? 'Activo' : 'Inactivo',
                    offlineService.autoSyncEnabled ? Colors.green : Colors.grey,
                    Icons.sync_alt,
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Intervalo',
                    '${offlineService.syncIntervalMinutes} min',
                    Colors.blue,
                    Icons.timer,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatusCard(OfflineSyncService offlineService) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado de Sincronización',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatusRow(
              'Última sincronización',
              offlineService.getLastSyncStatus(),
              Colors.grey[700]!,
            ),
            if (offlineService.lastSyncError != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[600], size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Error: ${offlineService.lastSyncError}',
                        style: GoogleFonts.lato(
                          color: Colors.red[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionsCard(OfflineSyncService offlineService) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acciones',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: offlineService.isSyncing
                    ? null
                    : () async {
                        await offlineService.performSync(forceSync: true);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Sincronización iniciada'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      },
                icon: offlineService.isSyncing
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
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      offlineService.toggleAutoSync(
                        !offlineService.autoSyncEnabled,
                      );
                    },
                    icon: Icon(
                      offlineService.autoSyncEnabled
                          ? Icons.sync_disabled
                          : Icons.sync,
                    ),
                    label: Text(
                      offlineService.autoSyncEnabled
                          ? 'Desactivar Auto-Sync'
                          : 'Activar Auto-Sync',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.lato(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
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

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }
}

