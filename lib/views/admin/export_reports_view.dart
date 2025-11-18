import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/reports_viewmodel.dart';
import '../../viewmodels/guard_reports_viewmodel.dart';
import '../../services/generic_reports_export_service.dart';
import '../../widgets/status_widgets.dart';

/// US050 - Exportar reportes PDF/Excel
class ExportReportsView extends StatefulWidget {
  final ReportsViewModel reportsViewModel;

  const ExportReportsView({Key? key, required this.reportsViewModel}) : super(key: key);

  @override
  _ExportReportsViewState createState() => _ExportReportsViewState();
}

class _ExportReportsViewState extends State<ExportReportsView> {
  bool _isExporting = false;
  final GenericReportsExportService _exportService = GenericReportsExportService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exportar Reportes'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Exportar Reportes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildExportCard(
              'Exportar a PDF',
              'Genera un reporte PDF con gráficos y estadísticas',
              Icons.picture_as_pdf,
              Colors.red,
              _exportToPDF,
            ),
            SizedBox(height: 12),
            _buildExportCard(
              'Exportar a Excel',
              'Exporta datos con múltiples hojas en formato Excel (.xlsx)',
              Icons.table_chart,
              Colors.green,
              _exportToExcel,
            ),
            SizedBox(height: 12),
            _buildExportCard(
              'Exportar Reporte Completo',
              'PDF completo con todos los reportes y gráficos',
              Icons.description,
              Colors.blue,
              _exportFullReport,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExportCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: _isExporting ? null : onTap,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(description, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                  ],
                ),
              ),
              if (_isExporting)
                Padding(
                  padding: EdgeInsets.all(8),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              else
                Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _exportToPDF() async {
    setState(() => _isExporting = true);
    
    try {
      final asistencias = widget.reportsViewModel.asistenciasFiltradas;
      
      if (asistencias.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No hay datos para exportar'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

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

      final pdfFile = await _exportService.exportAsistenciasToPDF(
        asistencias: asistencias,
        fechaInicio: widget.reportsViewModel.fechaInicioFilter,
        fechaFin: widget.reportsViewModel.fechaFinFilter,
        titulo: 'Reporte de Asistencias',
      );
      
      if (mounted) {
        Navigator.pop(context); // Cerrar diálogo de carga
        
        // Compartir el PDF
        await Share.shareXFiles(
          [XFile(pdfFile.path)],
          subject: 'Reporte de Asistencias',
          text: 'Reporte de asistencias generado el ${DateTime.now().toString().split(' ')[0]}',
        );
        
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
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Cerrar diálogo si está abierto
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _exportToExcel() async {
    setState(() => _isExporting = true);
    
    try {
      final asistencias = widget.reportsViewModel.asistenciasFiltradas;
      
      if (asistencias.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No hay datos para exportar'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Mostrar diálogo de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Generando Excel (.xlsx)...'),
            ],
          ),
        ),
      );

      final excelFile = await _exportService.exportAsistenciasToExcel(
        asistencias: asistencias,
        fechaInicio: widget.reportsViewModel.fechaInicioFilter,
        fechaFin: widget.reportsViewModel.fechaFinFilter,
        useExcelFormat: true, // US050 - Usar formato Excel nativo con múltiples hojas
      );
      
      if (mounted) {
        Navigator.pop(context); // Cerrar diálogo de carga
        
        // Compartir el archivo Excel
        await Share.shareXFiles(
          [XFile(excelFile.path)],
          subject: 'Reporte de Asistencias (Excel)',
          text: 'Reporte de asistencias en formato Excel (.xlsx) con múltiples hojas generado el ${DateTime.now().toString().split(' ')[0]}',
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Excel (.xlsx) generado y compartido exitosamente'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Cerrar diálogo si está abierto
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al exportar Excel: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _exportFullReport() async {
    setState(() => _isExporting = true);
    
    try {
      final asistencias = widget.reportsViewModel.asistenciasFiltradas;
      
      // Obtener datos de guardias si están disponibles
      GuardActivitySummaryModel? resumenGuardias;
      List<GuardReportModel>? rankingGuardias;
      Map<int, int>? actividadSemanal;
      Map<String, int>? topPuertas;
      Map<String, int>? topFacultades;
      
      try {
        final guardReportsViewModel = Provider.of<GuardReportsViewModel>(
          context,
          listen: false,
        );
        resumenGuardias = guardReportsViewModel.resumenActividad;
        rankingGuardias = guardReportsViewModel.rankingGuardias;
        actividadSemanal = guardReportsViewModel.actividadSemanal;
        topPuertas = guardReportsViewModel.topPuertas;
        topFacultades = guardReportsViewModel.topFacultades;
      } catch (e) {
        // Si no hay datos de guardias, continuar sin ellos
        print('No se pudieron obtener datos de guardias: $e');
      }

      if (asistencias.isEmpty && resumenGuardias == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No hay datos para exportar'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Mostrar diálogo de carga
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text('Generando reporte completo...'),
            ],
          ),
        ),
      );

      final pdfFile = await _exportService.exportFullReportToPDF(
        asistencias: asistencias.isNotEmpty ? asistencias : null,
        resumenGuardias: resumenGuardias,
        rankingGuardias: rankingGuardias,
        actividadSemanal: actividadSemanal,
        topPuertas: topPuertas,
        topFacultades: topFacultades,
        fechaInicio: widget.reportsViewModel.fechaInicioFilter,
        fechaFin: widget.reportsViewModel.fechaFinFilter,
      );
      
      if (mounted) {
        Navigator.pop(context); // Cerrar diálogo de carga
        
        // Compartir el PDF
        await Share.shareXFiles(
          [XFile(pdfFile.path)],
          subject: 'Reporte Completo del Sistema',
          text: 'Reporte completo generado el ${DateTime.now().toString().split(' ')[0]}',
        );
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Reporte completo generado y compartido exitosamente'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Cerrar diálogo si está abierto
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al generar reporte completo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isExporting = false);
    }
  }

}

