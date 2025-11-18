import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';  // US050 - Excel con múltiples hojas
import 'package:intl/intl.dart';
import '../models/asistencia_model.dart';
import '../models/guard_report_model.dart';

/// Servicio genérico para exportar reportes a PDF y Excel (US050)
class GenericReportsExportService {
  /// Exportar reporte de asistencias a PDF
  Future<File> exportAsistenciasToPDF({
    required List<AsistenciaModel> asistencias,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    String? titulo,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy');
    final fechaInicioStr = fechaInicio != null ? dateFormat.format(fechaInicio) : 'N/A';
    final fechaFinStr = fechaFin != null ? dateFormat.format(fechaFin) : 'N/A';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            _buildHeaderPDF(titulo ?? 'Reporte de Asistencias', fechaInicioStr, fechaFinStr),
            pw.SizedBox(height: 20),
            _buildAsistenciasTablePDF(asistencias),
            pw.SizedBox(height: 20),
            _buildStatisticsPDF(asistencias), // Incluye gráfico simple
            pw.SizedBox(height: 20),
            // US050 - Gráfico de distribución por hora
            _buildHourlyDistributionChartPDF(asistencias),
            pw.SizedBox(height: 20),
            _buildFooterPDF(),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(path.join(
      output.path,
      'reporte_asistencias_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf',
    ));
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Exportar reporte de asistencias a Excel (con múltiples hojas)
  Future<File> exportAsistenciasToExcel({
    required List<AsistenciaModel> asistencias,
    DateTime? fechaInicio,
    DateTime? fechaFin,
    bool useExcelFormat = true, // US050 - Usar formato Excel nativo
  }) async {
    if (useExcelFormat) {
      // US050 - Exportación Excel con múltiples hojas
      final excel = Excel.createExcel();
      excel.delete('Sheet1'); // Eliminar hoja por defecto

      // Hoja 1: Asistencias completas
      final sheet1 = excel['Asistencias'];
      sheet1.appendRow([
        'Nombre',
        'Apellido',
        'DNI',
        'Código Universitario',
        'Tipo',
        'Fecha/Hora',
        'Puerta',
        'Facultad',
        'Escuela',
        'Guardia ID',
      ]);

      for (var asistencia in asistencias) {
        sheet1.appendRow([
          asistencia.nombre ?? '',
          asistencia.apellido ?? '',
          asistencia.dni ?? '',
          asistencia.codigoUniversitario ?? '',
          asistencia.tipo.toString().split('.').last,
          DateFormat('yyyy-MM-dd HH:mm:ss').format(asistencia.fechaHora),
          asistencia.puerta ?? '',
          asistencia.siglasFacultad ?? '',
          asistencia.siglasEscuela ?? '',
          asistencia.guardiaId ?? '',
        ]);
      }

      // Hoja 2: Resumen por tipo
      final sheet2 = excel['Resumen por Tipo'];
      final entradas = asistencias.where((a) => a.tipo == TipoMovimiento.entrada).length;
      final salidas = asistencias.where((a) => a.tipo == TipoMovimiento.salida).length;
      
      sheet2.appendRow(['Tipo', 'Cantidad']);
      sheet2.appendRow(['Entradas', entradas]);
      sheet2.appendRow(['Salidas', salidas]);
      sheet2.appendRow(['Total', asistencias.length]);

      // Hoja 3: Resumen por facultad
      final sheet3 = excel['Resumen por Facultad'];
      final Map<String, int> porFacultad = {};
      for (var asistencia in asistencias) {
        final facultad = asistencia.siglasFacultad ?? 'Sin Facultad';
        porFacultad[facultad] = (porFacultad[facultad] ?? 0) + 1;
      }
      
      sheet3.appendRow(['Facultad', 'Cantidad']);
      porFacultad.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value))
        ..forEach((entry) {
          sheet3.appendRow([entry.key, entry.value]);
        });

      // Guardar archivo Excel
      final output = await getTemporaryDirectory();
      final file = File(path.join(
        output.path,
        'reporte_asistencias_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.xlsx',
      ));
      await file.writeAsBytes(excel.encode()!);
      return file;
    } else {
      // Fallback a CSV (compatible con Excel)
      final List<List<dynamic>> rows = [
        [
          'Nombre',
          'Apellido',
          'DNI',
          'Código Universitario',
          'Tipo',
          'Fecha/Hora',
          'Puerta',
          'Facultad',
          'Escuela',
          'Guardia ID',
        ],
      ];

      for (var asistencia in asistencias) {
        rows.add([
          asistencia.nombre ?? '',
          asistencia.apellido ?? '',
          asistencia.dni ?? '',
          asistencia.codigoUniversitario ?? '',
          asistencia.tipo.toString().split('.').last,
          DateFormat('yyyy-MM-dd HH:mm:ss').format(asistencia.fechaHora),
          asistencia.puerta ?? '',
          asistencia.siglasFacultad ?? '',
          asistencia.siglasEscuela ?? '',
          asistencia.guardiaId ?? '',
        ]);
      }

      final csv = const ListToCsvConverter().convert(rows);

      final output = await getTemporaryDirectory();
      final file = File(path.join(
        output.path,
        'reporte_asistencias_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.csv',
      ));
      await file.writeAsString(csv);
      return file;
    }
  }

  /// Exportar reporte completo (múltiples tipos) a PDF
  Future<File> exportFullReportToPDF({
    List<AsistenciaModel>? asistencias,
    GuardActivitySummaryModel? resumenGuardias,
    List<GuardReportModel>? rankingGuardias,
    Map<int, int>? actividadSemanal,
    Map<String, int>? topPuertas,
    Map<String, int>? topFacultades,
    DateTime? fechaInicio,
    DateTime? fechaFin,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy');
    final fechaInicioStr = fechaInicio != null ? dateFormat.format(fechaInicio) : 'N/A';
    final fechaFinStr = fechaFin != null ? dateFormat.format(fechaFin) : 'N/A';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          final widgets = <pw.Widget>[
            _buildHeaderPDF('Reporte Completo del Sistema', fechaInicioStr, fechaFinStr),
            pw.SizedBox(height: 20),
          ];

          // Sección de Asistencias
          if (asistencias != null && asistencias.isNotEmpty) {
            widgets.addAll([
              pw.Text(
                'Asistencias',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Divider(),
              pw.SizedBox(height: 10),
              _buildAsistenciasTablePDF(asistencias.take(100).toList()),
              pw.SizedBox(height: 20),
            ]);
          }

          // Sección de Guardias
          if (resumenGuardias != null) {
            widgets.addAll([
              pw.Text(
                'Resumen de Actividad de Guardias',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Divider(),
              pw.SizedBox(height: 10),
              _buildGuardSummaryPDF(resumenGuardias),
              pw.SizedBox(height: 20),
            ]);
          }

          if (rankingGuardias != null && rankingGuardias.isNotEmpty) {
            widgets.addAll([
              pw.Text(
                'Ranking de Guardias',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Divider(),
              pw.SizedBox(height: 10),
              _buildRankingTablePDF(rankingGuardias),
              pw.SizedBox(height: 20),
            ]);
          }

          // Actividad Semanal
          if (actividadSemanal != null && actividadSemanal.isNotEmpty) {
            widgets.addAll([
              pw.Text(
                'Actividad Semanal',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Divider(),
              pw.SizedBox(height: 10),
              _buildWeeklyActivityTablePDF(actividadSemanal),
              pw.SizedBox(height: 20),
            ]);
          }

          // Top Puertas y Facultades
          if (topPuertas != null && topPuertas.isNotEmpty) {
            widgets.addAll([
              pw.Text(
                'Top Puertas',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Divider(),
              pw.SizedBox(height: 10),
              _buildTopListTablePDF(topPuertas, 'Puerta', 'Usos'),
              pw.SizedBox(height: 20),
            ]);
          }

          if (topFacultades != null && topFacultades.isNotEmpty) {
            widgets.addAll([
              pw.Text(
                'Top Facultades',
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
              ),
              pw.Divider(),
              pw.SizedBox(height: 10),
              _buildTopListTablePDF(topFacultades, 'Facultad', 'Atenciones'),
              pw.SizedBox(height: 20),
            ]);
          }

          widgets.add(_buildFooterPDF());
          return widgets;
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(path.join(
      output.path,
      'reporte_completo_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf',
    ));
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  // Métodos privados para construir secciones del PDF

  // US050 - Header profesional mejorado
  pw.Widget _buildHeaderPDF(String titulo, String fechaInicio, String fechaFin) {
    return pw.Container(
      padding: pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          colors: [PdfColors.blueGrey900, PdfColors.blueGrey700],
          begin: pw.Alignment.topLeft,
          end: pw.Alignment.bottomRight,
        ),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  titulo.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 26,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                pw.SizedBox(height: 12),
                pw.Container(
                  padding: pw.EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white.withOpacity(0.2),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    'Período: $fechaInicio - $fechaFin',
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: PdfColors.white,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Text(
                  'Generado: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
                  style: pw.TextStyle(
                    fontSize: 11,
                    color: PdfColors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          pw.Container(
            padding: pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColors.white.withOpacity(0.15),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Text(
              'SISTEMA\nCONTROL\nACCESO',
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
              textAlign: pw.TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // US050 - Tabla mejorada con mejor formato
  pw.Widget _buildAsistenciasTablePDF(List<AsistenciaModel> asistencias) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400, width: 1),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Table(
        border: pw.TableBorder(
          verticalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
          horizontalInside: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
          left: pw.BorderSide(color: PdfColors.grey400, width: 1),
          right: pw.BorderSide(color: PdfColors.grey400, width: 1),
          top: pw.BorderSide(color: PdfColors.grey400, width: 1),
          bottom: pw.BorderSide(color: PdfColors.grey400, width: 1),
        ),
        columnWidths: {
          0: pw.FlexColumnWidth(2),
          1: pw.FlexColumnWidth(2),
          2: pw.FlexColumnWidth(1.5),
          3: pw.FlexColumnWidth(1),
          4: pw.FlexColumnWidth(2),
          5: pw.FlexColumnWidth(1.5),
        },
        children: [
          // Header
          pw.TableRow(
            decoration: pw.BoxDecoration(
              color: PdfColors.blueGrey100,
            ),
            children: [
              _buildTableCellPDF('Nombre', isHeader: true),
              _buildTableCellPDF('Apellido', isHeader: true),
              _buildTableCellPDF('DNI', isHeader: true),
              _buildTableCellPDF('Tipo', isHeader: true),
              _buildTableCellPDF('Fecha/Hora', isHeader: true),
              _buildTableCellPDF('Puerta', isHeader: true),
            ],
          ),
          // Data rows
          ...asistencias.map((a) {
            return pw.TableRow(
              children: [
                _buildTableCellPDF(a.nombre ?? ''),
                _buildTableCellPDF(a.apellido ?? ''),
                _buildTableCellPDF(a.dni ?? ''),
                _buildTableCellPDF(a.tipo.toString().split('.').last),
                _buildTableCellPDF(DateFormat('dd/MM/yyyy HH:mm').format(a.fechaHora)),
                _buildTableCellPDF(a.puerta ?? ''),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  // US050 - Helper para celdas de tabla con mejor formato
  pw.Widget _buildTableCellPDF(String text, {bool isHeader = false}) {
    return pw.Container(
      padding: pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 11 : 9,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.blueGrey900 : PdfColors.black,
        ),
      ),
    );
  }

  pw.Widget _buildStatisticsPDF(List<AsistenciaModel> asistencias) {
    final total = asistencias.length;
    final entradas = asistencias.where((a) => a.tipo == TipoMovimiento.entrada).length;
    final salidas = asistencias.where((a) => a.tipo == TipoMovimiento.salida).length;

    return pw.Container(
      padding: pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Estadísticas',
            style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCardPDF('Total', total.toString()),
              _buildStatCardPDF('Entradas', entradas.toString()),
              _buildStatCardPDF('Salidas', salidas.toString()),
            ],
          ),
          pw.SizedBox(height: 20),
          // US050 - Gráfico simple de barras usando formas
          _buildSimpleBarChartPDF(entradas, salidas),
        ],
      ),
    );
  }

  // US050 - Gráfico simple de barras para PDF
  pw.Widget _buildSimpleBarChartPDF(int entradas, int salidas) {
    final maxValue = [entradas, salidas].reduce((a, b) => a > b ? a : b);
    final maxHeight = 100.0;
    final entradaHeight = maxValue > 0 ? (entradas / maxValue) * maxHeight : 0.0;
    final salidaHeight = maxValue > 0 ? (salidas / maxValue) * maxHeight : 0.0;

    return pw.Container(
      height: 150,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Distribución por Tipo',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            children: [
              pw.Column(
                children: [
                  pw.Container(
                    width: 60,
                    height: entradaHeight,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.green,
                      borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(4)),
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text('Entradas', style: pw.TextStyle(fontSize: 10)),
                  pw.Text(entradas.toString(), style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.Column(
                children: [
                  pw.Container(
                    width: 60,
                    height: salidaHeight,
                    decoration: pw.BoxDecoration(
                      color: PdfColors.orange,
                      borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(4)),
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text('Salidas', style: pw.TextStyle(fontSize: 10)),
                  pw.Text(salidas.toString(), style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // US050 - Tarjeta de estadística mejorada
  pw.Widget _buildStatCardPDF(String label, String value) {
    return pw.Container(
      width: 150,
      padding: pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          colors: [PdfColors.blueGrey50, PdfColors.white],
          begin: pw.Alignment.topLeft,
          end: pw.Alignment.bottomRight,
        ),
        border: pw.Border.all(color: PdfColors.blueGrey300, width: 1),
        borderRadius: pw.BorderRadius.circular(6),
        boxShadow: [
          pw.BoxShadow(
            color: PdfColors.grey400,
            blurRadius: 2,
            offset: pw.Offset(1, 1),
          ),
        ],
      ),
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 11,
              color: PdfColors.blueGrey700,
              fontWeight: pw.FontWeight.w600,
            ),
          ),
          pw.SizedBox(height: 6),
          pw.Container(
            padding: pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: pw.BoxDecoration(
              color: PdfColors.blueGrey800,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildGuardSummaryPDF(GuardActivitySummaryModel resumen) {
    return pw.Container(
      padding: pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _buildStatCardPDF('Total Asistencias', resumen.totalAsistencias.toString()),
              _buildStatCardPDF('Guardias Activos', resumen.guardiasActivos.toString()),
              _buildStatCardPDF('Autorizaciones', resumen.autorizacionesManuales.toString()),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildRankingTablePDF(List<GuardReportModel> ranking) {
    return pw.Table.fromTextArray(
      headers: [
        '#',
        'Guardia',
        'Total Asistencias',
        'Entradas',
        'Salidas',
        'Autorizaciones',
      ],
      data: ranking.asMap().entries.map((entry) {
        final index = entry.key;
        final guardia = entry.value;
        return [
          '${index + 1}',
          guardia.guardiaNombre,
          guardia.totalAsistencias.toString(),
          guardia.entradas.toString(),
          guardia.salidas.toString(),
          guardia.autorizacionesManuales.toString(),
        ];
      }).toList(),
      border: pw.TableBorder.all(color: PdfColors.grey300),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      cellAlignment: pw.Alignment.centerLeft,
      cellPadding: pw.EdgeInsets.all(5),
    );
  }

  pw.Widget _buildWeeklyActivityTablePDF(Map<int, int> actividadSemanal) {
    final List<String> weekdays = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo'
    ];
    final List<List<String>> data = weekdays.asMap().entries.map((entry) {
      final dayIndex = entry.key + 1;
      final count = actividadSemanal[dayIndex] ?? 0;
      return [entry.value, count.toString()];
    }).toList();

    return pw.Table.fromTextArray(
      headers: ['Día de la Semana', 'Asistencias'],
      data: data,
      border: pw.TableBorder.all(color: PdfColors.grey300),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      cellAlignment: pw.Alignment.centerLeft,
      cellPadding: pw.EdgeInsets.all(5),
    );
  }

  pw.Widget _buildTopListTablePDF(Map<String, int> data, String label1, String label2) {
    return pw.Table.fromTextArray(
      headers: [label1, label2],
      data: data.entries.map((e) => [e.key, e.value.toString()]).toList(),
      border: pw.TableBorder.all(color: PdfColors.grey300),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      cellAlignment: pw.Alignment.centerLeft,
      cellPadding: pw.EdgeInsets.all(5),
    );
  }

  // US050 - Gráfico de distribución por hora del día
  pw.Widget _buildHourlyDistributionChartPDF(List<AsistenciaModel> asistencias) {
    // Agrupar por hora
    final Map<int, int> porHora = {};
    for (var asistencia in asistencias) {
      final hora = asistencia.fechaHora.hour;
      porHora[hora] = (porHora[hora] ?? 0) + 1;
    }

    if (porHora.isEmpty) {
      return pw.SizedBox.shrink();
    }

    final maxValue = porHora.values.reduce((a, b) => a > b ? a : b);
    final maxHeight = 80.0;

    return pw.Container(
      padding: pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Distribución por Hora del Día',
            style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: List.generate(24, (hora) {
              final cantidad = porHora[hora] ?? 0;
              final altura = maxValue > 0 ? (cantidad / maxValue) * maxHeight : 0.0;
              
              return pw.Container(
                width: 8,
                margin: pw.EdgeInsets.symmetric(horizontal: 1),
                child: pw.Column(
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Container(
                      width: 8,
                      height: altura,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.blue,
                        borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(2)),
                      ),
                    ),
                    if (hora % 4 == 0) // Mostrar etiqueta cada 4 horas
                      pw.Text(
                        '$hora',
                        style: pw.TextStyle(fontSize: 6),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  // US050 - Footer mejorado
  pw.Widget _buildFooterPDF() {
    return pw.Container(
      margin: pw.EdgeInsets.only(top: 20),
      padding: pw.EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: pw.BoxDecoration(
        color: PdfColors.blueGrey50,
        border: pw.Border(
          top: pw.BorderSide(color: PdfColors.grey300, width: 1),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Sistema de Control de Acceso - MovilesII',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.blueGrey700,
              fontWeight: pw.FontWeight.w500,
            ),
          ),
          pw.Text(
            'Página ${pw.Context().pageNumber}',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.blueGrey600,
            ),
          ),
        ],
      ),
    );
  }
}

