const fs = require('fs');
const fsPromises = require('fs').promises;
const path = require('path');
const csv = require('csv-parser');

/**
 * Servicio para procesar y gestionar datos históricos (baseline)
 * US055 - Comparativo antes/después
 */
class HistoricalDataService {
  constructor() {
    this.baselineDir = path.join(__dirname, '../data/historical/baseline');
    this.historicDataDir = path.join(__dirname, '../data/historical/historic-data');
    this.processedDir = path.join(__dirname, '../data/historical/processed');
    this.ensureDirectories();
  }

  async ensureDirectories() {
    try {
      await fsPromises.mkdir(this.baselineDir, { recursive: true });
      await fsPromises.mkdir(this.historicDataDir, { recursive: true });
      await fsPromises.mkdir(this.processedDir, { recursive: true });
    } catch (err) {
      console.error('Error creando directorios:', err);
    }
  }

  /**
   * Buscar archivo CSV en historic-data o baseline
   */
  async findCSVFile(filename) {
    // Buscar primero en historic-data
    const historicPath = path.join(this.historicDataDir, filename);
    try {
      await fsPromises.access(historicPath);
      return historicPath;
    } catch {
      // Si no está, buscar en baseline
      const baselinePath = path.join(this.baselineDir, filename);
      try {
        await fsPromises.access(baselinePath);
        return baselinePath;
      } catch {
        return null;
      }
    }
  }

  /**
   * Procesar archivo CSV específico del dataset histórico
   */
  async processHistoricalDataset(filename = 'dataset_universidad_10000.csv') {
    const filePath = await this.findCSVFile(filename);
    
    if (!filePath) {
      throw new Error(`Archivo ${filename} no encontrado en historic-data o baseline`);
    }

    return await this.processCSV(filePath, 'asistencias');
  }

  /**
   * Procesar archivo CSV de datos históricos
   * @param {string} filePath - Ruta al archivo CSV
   * @param {string} type - Tipo de datos: 'asistencias' o 'metricas'
   */
  async processCSV(filePath, type = 'asistencias') {
    return new Promise((resolve, reject) => {
      const results = [];
      const stream = fs.createReadStream(filePath)
        .pipe(csv())
        .on('data', (data) => {
          // Validar y limpiar datos
          const cleaned = this.cleanData(data, type);
          if (cleaned) {
            results.push(cleaned);
          }
        })
        .on('end', async () => {
          try {
            // Calcular métricas agregadas
            const processed = this.aggregateMetrics(results, type);
            
            // Guardar datos procesados
            const outputPath = path.join(
              this.processedDir,
              `${type}_baseline_processed.json`
            );
            await fsPromises.writeFile(outputPath, JSON.stringify(processed, null, 2));
            
            resolve({
              success: true,
              totalRecords: results.length,
              processed: processed,
              savedTo: outputPath
            });
          } catch (err) {
            reject(err);
          }
        })
        .on('error', reject);
    });
  }

  /**
   * Limpiar y validar datos del CSV
   */
  cleanData(data, type) {
    if (type === 'asistencias') {
      // Formato 1: Formato estándar con fecha y hora separadas
      if (data.fecha && data.hora && data.tipo_movimiento) {
        return {
          fecha: data.fecha,
          hora: data.hora,
          tipo_movimiento: data.tipo_movimiento,
          cantidad_promedio: parseFloat(data.cantidad_promedio) || 0,
          tiempo_promedio_seg: parseFloat(data.tiempo_promedio_seg) || 0,
          errores_porcentaje: parseFloat(data.errores_porcentaje) || 0,
          puerta: data.puerta || 'N/A'
        };
      }
      
      // Formato 2: Formato dataset_universidad (timestamp completo)
      if (data.timestamp && data.tipo_movimiento) {
        try {
          // Parsear timestamp (formato: "2025-10-15 09:22:00")
          const timestamp = new Date(data.timestamp);
          if (isNaN(timestamp.getTime())) {
            return null;
          }
          
          // Extraer fecha y hora
          const fecha = timestamp.toISOString().split('T')[0]; // YYYY-MM-DD
          const hora = timestamp.toTimeString().split(' ')[0].substring(0, 5); // HH:MM
          
          // Calcular tiempo promedio estimado basado en sistema anterior (manual)
          // Sistema anterior: 2-3 minutos promedio (120-180 segundos)
          // Estimamos tiempo basado en horario pico (más tiempo en pico)
          const esHorarioPico = parseInt(data.es_horario_pico) === 1;
          const tiempoPromedio = esHorarioPico ? 180 : 150; // Más tiempo en horas pico
          
          // Estimación de errores: 15% base, más en horas pico
          const erroresBase = esHorarioPico ? 18 : 12;
          
          return {
            fecha: fecha,
            hora: hora,
            tipo_movimiento: data.tipo_movimiento,
            cantidad_promedio: 1, // Cada registro es 1 acceso
            tiempo_promedio_seg: tiempoPromedio,
            errores_porcentaje: erroresBase,
            puerta: data.punto_control || 'N/A'
          };
        } catch (err) {
          console.error('Error parseando timestamp:', err);
          return null;
        }
      }
      
      return null;
    } else if (type === 'metricas') {
      if (!data.fecha) {
        return null;
      }

      return {
        fecha: data.fecha,
        tiempo_registro_promedio: parseFloat(data.tiempo_registro_promedio) || 0,
        precision: parseFloat(data.precision) || 0,
        errores_porcentaje: parseFloat(data.errores_porcentaje) || 0,
        satisfaccion_promedio: parseFloat(data.satisfaccion_promedio) || 0,
        recursos_humanos: parseInt(data.recursos_humanos) || 0
      };
    }

    return null;
  }

  /**
   * Calcular métricas agregadas
   */
  aggregateMetrics(data, type) {
    if (data.length === 0) {
      return {
        summary: {},
        daily: [],
        hourly: []
      };
    }

    if (type === 'asistencias') {
      // Calcular promedios generales
      const totalCantidad = data.reduce((sum, d) => sum + d.cantidad_promedio, 0);
      const totalTiempo = data.reduce((sum, d) => sum + d.tiempo_promedio_seg, 0);
      const totalErrores = data.reduce((sum, d) => sum + d.errores_porcentaje, 0);

      // Agrupar por día
      const byDay = {};
      data.forEach(d => {
        const day = d.fecha;
        if (!byDay[day]) {
          byDay[day] = {
            fecha: day,
            total_cantidad: 0,
            total_tiempo: 0,
            total_errores: 0,
            count: 0
          };
        }
        byDay[day].total_cantidad += d.cantidad_promedio;
        byDay[day].total_tiempo += d.tiempo_promedio_seg;
        byDay[day].total_errores += d.errores_porcentaje;
        byDay[day].count++;
      });

      // Agrupar por hora
      const byHour = {};
      data.forEach(d => {
        const hour = d.hora.split(':')[0];
        const key = `${hour}:00`;
        if (!byHour[key]) {
          byHour[key] = {
            hora: key,
            total_cantidad: 0,
            promedio_tiempo: 0,
            promedio_errores: 0,
            count: 0
          };
        }
        byHour[key].total_cantidad += d.cantidad_promedio;
        byHour[key].promedio_tiempo += d.tiempo_promedio_seg;
        byHour[key].promedio_errores += d.errores_porcentaje;
        byHour[key].count++;
      });

      // Calcular promedios
      Object.keys(byHour).forEach(key => {
        byHour[key].promedio_tiempo = byHour[key].promedio_tiempo / byHour[key].count;
        byHour[key].promedio_errores = byHour[key].promedio_errores / byHour[key].count;
      });

      return {
        summary: {
          total_records: data.length,
          promedio_cantidad_diaria: totalCantidad / data.length,
          tiempo_promedio_segundos: totalTiempo / data.length,
          errores_promedio_porcentaje: totalErrores / data.length,
          periodo_dias: Object.keys(byDay).length
        },
        daily: Object.values(byDay),
        hourly: Object.values(byHour)
      };
    } else if (type === 'metricas') {
      const totalTiempo = data.reduce((sum, d) => sum + d.tiempo_registro_promedio, 0);
      const totalPrecision = data.reduce((sum, d) => sum + d.precision, 0);
      const totalErrores = data.reduce((sum, d) => sum + d.errores_porcentaje, 0);
      const totalSatisfaccion = data.reduce((sum, d) => sum + d.satisfaccion_promedio, 0);
      const totalRecursos = data.reduce((sum, d) => sum + d.recursos_humanos, 0);

      return {
        summary: {
          total_records: data.length,
          tiempo_registro_promedio: totalTiempo / data.length,
          precision_promedio: totalPrecision / data.length,
          errores_promedio_porcentaje: totalErrores / data.length,
          satisfaccion_promedio: totalSatisfaccion / data.length,
          recursos_humanos_promedio: totalRecursos / data.length
        },
        daily: data.map(d => ({
          fecha: d.fecha,
          tiempo_registro_promedio: d.tiempo_registro_promedio,
          precision: d.precision,
          errores_porcentaje: d.errores_porcentaje,
          satisfaccion_promedio: d.satisfaccion_promedio,
          recursos_humanos: d.recursos_humanos
        }))
      };
    }

    return { summary: {}, daily: [], hourly: [] };
  }

  /**
   * Obtener datos procesados del baseline
   */
  async getBaselineData(type = 'asistencias') {
    try {
      const filePath = path.join(
        this.processedDir,
        `${type}_baseline_processed.json`
      );
      
      const data = await fsPromises.readFile(filePath, 'utf8');
      return JSON.parse(data);
    } catch (err) {
      if (err.code === 'ENOENT') {
        return null; // Archivo no existe
      }
      throw err;
    }
  }

  /**
   * Obtener comparativo antes/después
   */
  async getComparison(baselineType = 'asistencias', currentMetrics = null) {
    const baseline = await this.getBaselineData(baselineType);
    
    if (!baseline) {
      return {
        error: 'No hay datos históricos disponibles. Por favor, carga primero el archivo CSV.'
      };
    }

    if (!currentMetrics) {
      // Si no se proporcionan métricas actuales, retornar solo baseline
      return {
        baseline: baseline.summary,
        message: 'Solo datos históricos disponibles. Proporciona métricas actuales para comparar.'
      };
    }

    // Calcular comparativo
    const comparison = {
      baseline: baseline.summary,
      current: currentMetrics,
      improvement: {}
    };

    // Calcular mejoras
    if (baseline.summary.tiempo_promedio_segundos && currentMetrics.tiempo_promedio_segundos) {
      const tiempoReduccion = baseline.summary.tiempo_promedio_segundos - currentMetrics.tiempo_promedio_segundos;
      comparison.improvement.tiempo_reduccion_porcentaje = 
        (tiempoReduccion / baseline.summary.tiempo_promedio_segundos) * 100;
      comparison.improvement.tiempo_reduccion_segundos = tiempoReduccion;
    }

    if (baseline.summary.precision_promedio && currentMetrics.precision) {
      comparison.improvement.precision_aumento = 
        currentMetrics.precision - baseline.summary.precision_promedio;
    }

    if (baseline.summary.errores_promedio_porcentaje && currentMetrics.errores_porcentaje) {
      const erroresReduccion = baseline.summary.errores_promedio_porcentaje - currentMetrics.errores_porcentaje;
      comparison.improvement.errores_reduccion_porcentaje = 
        (erroresReduccion / baseline.summary.errores_promedio_porcentaje) * 100;
    }

    return comparison;
  }

  /**
   * Calcular ROI (Return on Investment) y análisis costo-beneficio
   * US055 - Comparativo antes/después
   */
  calculateROI(comparison, investmentCost = 50000, monthlyOperationalCost = 2000) {
    if (!comparison || !comparison.baseline || !comparison.current) {
      return null;
    }

    const baseline = comparison.baseline;
    const current = comparison.current;
    const improvement = comparison.improvement || {};

    // Calcular ahorros mensuales
    // Ahorro por tiempo reducido (asumiendo costo de tiempo de personal)
    const tiempoReduccionSegundos = improvement.tiempo_reduccion_segundos || 0;
    const registrosDiarios = baseline.total_records || 100;
    const diasLaborables = 22; // Promedio mensual
    const costoHoraPersonal = 25; // S/. 25 por hora
    const ahorroTiempoMensual = (tiempoReduccionSegundos * registrosDiarios * diasLaborables / 3600) * costoHoraPersonal;

    // Ahorro por reducción de errores (costo de corregir errores)
    const erroresReduccionPorcentaje = improvement.errores_reduccion_porcentaje || 0;
    const costoError = 10; // S/. 10 por error corregido
    const erroresAntes = (baseline.errores_promedio_porcentaje || 0) / 100 * registrosDiarios * diasLaborables;
    const erroresDespues = (current.errores_porcentaje || 0) / 100 * registrosDiarios * diasLaborables;
    const ahorroErroresMensual = (erroresAntes - erroresDespues) * costoError;

    // Ahorro por reducción de recursos humanos
    const recursosAntes = baseline.recursos_humanos_promedio || 8;
    const recursosDespues = current.recursos_humanos || 5;
    const ahorroRecursosMensual = (recursosAntes - recursosDespues) * 2000; // S/. 2000 por persona/mes

    const ahorroMensualTotal = ahorroTiempoMensual + ahorroErroresMensual + ahorroRecursosMensual;
    const ahorroAnual = ahorroMensualTotal * 12;

    // Calcular ROI
    const roi6Meses = ((ahorroMensualTotal * 6 - investmentCost) / investmentCost) * 100;
    const roi12Meses = ((ahorroAnual - investmentCost) / investmentCost) * 100;
    const paybackPeriod = investmentCost / ahorroMensualTotal; // En meses

    return {
      investment: {
        initial: investmentCost,
        monthlyOperational: monthlyOperationalCost,
        totalFirstYear: investmentCost + (monthlyOperationalCost * 12),
      },
      savings: {
        time: Math.round(ahorroTiempoMensual),
        errors: Math.round(ahorroErroresMensual),
        resources: Math.round(ahorroRecursosMensual),
        monthlyTotal: Math.round(ahorroMensualTotal),
        annual: Math.round(ahorroAnual),
      },
      roi: {
        sixMonths: Math.round(roi6Meses * 100) / 100,
        twelveMonths: Math.round(roi12Meses * 100) / 100,
        paybackPeriod: Math.round(paybackPeriod * 10) / 10, // En meses
      },
      netBenefit: {
        sixMonths: Math.round(ahorroMensualTotal * 6 - investmentCost),
        twelveMonths: Math.round(ahorroAnual - investmentCost - (monthlyOperationalCost * 12)),
      },
      kpis: {
        tiempoReduccion: improvement.tiempo_reduccion_porcentaje || 0,
        precisionAumento: improvement.precision_aumento || 0,
        erroresReduccion: improvement.errores_reduccion_porcentaje || 0,
        recursosReduccion: recursosAntes - recursosDespues,
      },
    };
  }

  /**
   * Listar archivos CSV disponibles
   */
  async listCSVFiles() {
    try {
      const files = await fsPromises.readdir(this.baselineDir);
      return files.filter(f => f.endsWith('.csv'));
    } catch (err) {
      return [];
    }
  }
}

module.exports = HistoricalDataService;

