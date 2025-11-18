import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../viewmodels/nfc_viewmodel.dart';
import '../../models/realtime_detection_model.dart';

/// Vista para mostrar detecciones en tiempo real (US019)
class RealtimeDetectionsView extends StatefulWidget {
  const RealtimeDetectionsView({Key? key}) : super(key: key);

  @override
  _RealtimeDetectionsViewState createState() => _RealtimeDetectionsViewState();
}

class _RealtimeDetectionsViewState extends State<RealtimeDetectionsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.radar, size: 24),
            SizedBox(width: 8),
            Text('Detecciones en Tiempo Real'),
          ],
        ),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          Consumer<NfcViewModel>(
            builder: (context, nfcViewModel, child) {
              return Row(
                children: [
                  // Indicador de estado de conexión WebSocket
                  Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: nfcViewModel.isWebSocketConnected
                          ? Colors.green
                          : Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          nfcViewModel.isWebSocketConnected
                              ? Icons.wifi
                              : Icons.wifi_off,
                          size: 16,
                          color: Colors.white,
                        ),
                        SizedBox(width: 4),
                        Text(
                          nfcViewModel.isWebSocketConnected
                              ? 'Conectado'
                              : 'Desconectado',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Botón para limpiar
                  IconButton(
                    icon: Icon(Icons.clear_all),
                    tooltip: 'Limpiar detecciones',
                    onPressed: nfcViewModel.realtimeDetections.isEmpty
                        ? null
                        : () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Limpiar Detecciones'),
                                content: Text(
                                  '¿Está seguro de que desea limpiar todas las detecciones?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      nfcViewModel.clearRealtimeDetections();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Detecciones limpiadas'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Limpiar',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<NfcViewModel>(
        builder: (context, nfcViewModel, child) {
          final detections = nfcViewModel.realtimeDetections;

          if (detections.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.radar_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No hay detecciones',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Las detecciones aparecerán aquí en tiempo real',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  if (!nfcViewModel.isWebSocketConnected)
                    Container(
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(horizontal: 32),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange[200]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.orange[700]),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'WebSocket desconectado. Las actualizaciones en tiempo real no están disponibles.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange[900],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Contador de detecciones
              Container(
                padding: EdgeInsets.all(16),
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: ${detections.length} detecciones',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Text(
                      'Actualizado: ${DateFormat('HH:mm:ss').format(DateTime.now())}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              // Lista de detecciones
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    // La lista se actualiza automáticamente vía WebSocket
                    await Future.delayed(Duration(milliseconds: 500));
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.all(8),
                    itemCount: detections.length,
                    itemBuilder: (context, index) {
                      final detection = detections[index];
                      return _buildDetectionCard(detection, index);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetectionCard(RealtimeDetectionModel detection, int index) {
    final isEntrada = detection.isEntrada;
    final color = isEntrada ? Colors.green : Colors.orange;
    final icon = isEntrada ? Icons.login : Icons.logout;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                detection.nombreCompleto,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            // Indicador de detección local
            if (detection.isLocal)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'LOCAL',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  isEntrada ? Icons.arrow_forward : Icons.arrow_back,
                  size: 14,
                  color: color,
                ),
                SizedBox(width: 4),
                Text(
                  detection.tipoDisplay,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  '•',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(width: 8),
                Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  detection.puerta,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
                SizedBox(width: 4),
                Text(
                  '${detection.fechaHoraFormateada} - ${detection.fechaFormateada}',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
                if (detection.guardiaNombre != null) ...[
                  SizedBox(width: 8),
                  Text(
                    '•',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.person, size: 12, color: Colors.grey[500]),
                  SizedBox(width: 4),
                  Text(
                    detection.guardiaNombre!,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '#${index + 1}',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

