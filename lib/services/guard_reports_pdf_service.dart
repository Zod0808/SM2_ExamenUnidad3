import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../models/guard_report_model.dart';
import 'package:intl/intl.dart';

/// Servicio para generar reportes PDF de actividad de guardias (US010)
class GuardReportsPdfService {
  /// Generar PDF completo de reporte de guardias
  Future<File> generateGuardReportPDF({
    required GuardActivitySummaryModel resumen,
    required List<GuardReportModel> ranking,
    required Map<int, int> actividadSemanal,
    required Map<String, int> topPuertas,
    required Map<String, int> topFacultades,
    required DateTime fechaInicio,
    required DateTime fechaFin,
  }) async {
    final pdf = pw.Document();

    // Formatear fechas
    final dateFormat = DateFormat('dd/MM/yyyy');
    final fechaInicioStr = dateFormat.format(fechaInicio);
    final fechaFinStr = dateFormat.format(fechaFin);

    // Construir PDF
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Encabezado
            _buildHeader(fechaInicioStr, fechaFinStr),
            pw.SizedBox(height: 20),

            // Resumen General
            _buildResumenSection(resumen),
            pw.SizedBox(height: 20),

            // Ranking de Guardias
            _buildRankingSection(ranking),
            pw.SizedBox(height: 20),

            // Actividad Semanal
            _buildActividadSemanalSection(actividadSemanal),
            pw.SizedBox(height: 20),

            // Top Puertas
            _buildTopPuertasSection(topPuertas),
            pw.SizedBox(height: 20),

            // Top Facultades
            _buildTopFacultadesSection(topFacultades),
            pw.SizedBox(height: 20),

            // Pie de página
            _buildFooter(),
          ];
        },
      ),
    );

    // Guardar PDF
    final output = await getTemporaryDirectory();
    final file = File(
      path.join(
        output.path,
        'reporte_guardias_${DateTime.now().millisecondsSinceEpoch}.pdf',
      ),
    );
    await file.writeAsBytes(await pdf.save());

    return file;
  }

  /// Construir encabezado del PDF
  pw.Widget _buildHeader(String fechaInicio, String fechaFin) {
    return pw.Container(
      padding: pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.blueGrey700,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'REPORTE DE ACTIVIDAD DE GUARDIAS',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Período: $fechaInicio - $fechaFin',
            style: pw.TextStyle(
              fontSize: 14,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Generado: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.white300,
            ),
          ),
        ],
      ),
    );
  }

  /// Construir sección de resumen general
  pw.Widget _buildResumenSection(GuardActivitySummaryModel resumen) {
    return pw.Container(
      padding: pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'RESUMEN GENERAL',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blueGrey900,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricCard(
                'Total Asistencias',
                resumen.totalAsistencias.toString(),
              ),
              _buildMetricCard(
                'Guardias Activos',
                resumen.guardiasActivos.toString(),
              ),
              _buildMetricCard(
                'Autorizaciones Manuales',
                resumen.totalAutorizacionesManuales.toString(),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricCard(
                'Puerta Más Utilizada',
                resumen.puertaMasUsada ?? 'N/A',
              ),
              _buildMetricCard(
                'Facultad Más Atendida',
                resumen.facultadMasAtendida ?? 'N/A',
              ),
              _buildMetricCard(
                'Promedio Diario',
                resumen.promedioDiario.toStringAsFixed(1),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Construir tarjeta de métrica
  pw.Widget _buildMetricCard(String label, String value) {
    return pw.Expanded(
      child: pw.Container(
        margin: pw.EdgeInsets.symmetric(horizontal: 4),
        padding: pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey100,
          borderRadius: pw.BorderRadius.circular(6),
        ),
        child: pw.Column(
          children: [
            pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blueGrey900,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey700,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Construir sección de ranking
  pw.Widget _buildRankingSection(List<GuardReportModel> ranking) {
    if (ranking.isEmpty) {
      return pw.Container(
        padding: pw.EdgeInsets.all(16),
        child: pw.Text(
          'No hay datos de ranking disponibles',
          style: pw.TextStyle(color: PdfColors.grey600),
        ),
      );
    }

    return pw.Container(
      padding: pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'RANKING DE GUARDIAS',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blueGrey900,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              // Encabezado de tabla
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildTableCell('Pos', isHeader: true),
                  _buildTableCell('Guardia', isHeader: true),
                  _buildTableCell('Asistencias', isHeader: true),
                  _buildTableCell('Entradas', isHeader: true),
                  _buildTableCell('Salidas', isHeader: true),
                  _buildTableCell('Autorizaciones', isHeader: true),
                ],
              ),
              // Filas de datos
              ...ranking.take(20).asMap().entries.map((entry) {
                final index = entry.key;
                final guardia = entry.value;
                return pw.TableRow(
                  children: [
                    _buildTableCell('${index + 1}'),
                    _buildTableCell(guardia.guardiaNombre),
                    _buildTableCell(guardia.totalAsistencias.toString()),
                    _buildTableCell(guardia.entradas.toString()),
                    _buildTableCell(guardia.salidas.toString()),
                    _buildTableCell(guardia.autorizacionesManuales.toString()),
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  /// Construir celda de tabla
  pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 10 : 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.blueGrey900 : PdfColors.grey800,
        ),
      ),
    );
  }

  /// Construir sección de actividad semanal
  pw.Widget _buildActividadSemanalSection(Map<int, int> actividadSemanal) {
    final diasSemana = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    
    return pw.Container(
      padding: pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'ACTIVIDAD SEMANAL',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blueGrey900,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildTableCell('Día', isHeader: true),
                  _buildTableCell('Asistencias', isHeader: true),
                ],
              ),
              ...actividadSemanal.entries.map((entry) {
                return pw.TableRow(
                  children: [
                    _buildTableCell(diasSemana[entry.key]),
                    _buildTableCell(entry.value.toString()),
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  /// Construir sección de top puertas
  pw.Widget _buildTopPuertasSection(Map<String, int> topPuertas) {
    if (topPuertas.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'TOP PUERTAS MÁS UTILIZADAS',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blueGrey900,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildTableCell('Puerta', isHeader: true),
                  _buildTableCell('Cantidad', isHeader: true),
                ],
              ),
              ...topPuertas.entries.take(10).map((entry) {
                return pw.TableRow(
                  children: [
                    _buildTableCell(entry.key),
                    _buildTableCell(entry.value.toString()),
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  /// Construir sección de top facultades
  pw.Widget _buildTopFacultadesSection(Map<String, int> topFacultades) {
    if (topFacultades.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'TOP FACULTADES MÁS ATENDIDAS',
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blueGrey900,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300),
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  _buildTableCell('Facultad', isHeader: true),
                  _buildTableCell('Cantidad', isHeader: true),
                ],
              ),
              ...topFacultades.entries.take(10).map((entry) {
                return pw.TableRow(
                  children: [
                    _buildTableCell(entry.key),
                    _buildTableCell(entry.value.toString()),
                  ],
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }

  /// Construir pie de página
  pw.Widget _buildFooter() {
    return pw.Container(
      padding: pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Text(
        'Sistema de Control de Acceso - Universidad\n'
        'Este reporte fue generado automáticamente por el sistema.',
        style: pw.TextStyle(
          fontSize: 10,
          color: PdfColors.grey600,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }
}

