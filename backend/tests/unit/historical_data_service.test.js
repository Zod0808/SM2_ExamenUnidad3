/**
 * Tests unitarios para HistoricalDataService
 * US055 - Comparativo antes/después
 */

const HistoricalDataService = require('../../services/historical_data_service');
const fs = require('fs').promises;
const path = require('path');

// Mock de csv-parser
jest.mock('csv-parser', () => {
  return jest.fn(() => ({
    on: jest.fn(function(event, callback) {
      if (event === 'data') {
        // Simular datos CSV
        callback({
          timestamp: '2025-10-15 09:22:00',
          tipo_movimiento: 'entrada',
          estudiante_id: '12345',
          punto_control: 'PC-01',
          es_horario_pico: '1'
        });
        callback({
          timestamp: '2025-10-15 10:30:00',
          tipo_movimiento: 'salida',
          estudiante_id: '12345',
          punto_control: 'PC-01',
          es_horario_pico: '0'
        });
      } else if (event === 'end') {
        callback();
      }
      return this;
    }),
    pipe: jest.fn(function() {
      return this;
    })
  }));
});

describe('HistoricalDataService', () => {
  let service;
  const testDataDir = path.join(__dirname, '../../data/historical/test');

  beforeEach(() => {
    service = new HistoricalDataService();
  });

  afterEach(async () => {
    // Limpiar archivos de prueba
    try {
      const testFiles = await fs.readdir(testDataDir).catch(() => []);
      for (const file of testFiles) {
        await fs.unlink(path.join(testDataDir, file)).catch(() => {});
      }
    } catch (err) {
      // Ignorar errores
    }
  });

  describe('findCSVFile', () => {
    it('debe encontrar archivo en historic-data', async () => {
      // Crear archivo de prueba
      const testFile = path.join(service.historicDataDir, 'test.csv');
      await fs.writeFile(testFile, 'test data');

      const result = await service.findCSVFile('test.csv');

      expect(result).toBe(testFile);

      // Limpiar
      await fs.unlink(testFile).catch(() => {});
    });

    it('debe buscar en baseline si no está en historic-data', async () => {
      // Crear archivo en baseline
      const testFile = path.join(service.baselineDir, 'test.csv');
      await fs.writeFile(testFile, 'test data');

      const result = await service.findCSVFile('test.csv');

      expect(result).toBe(testFile);

      // Limpiar
      await fs.unlink(testFile).catch(() => {});
    });

    it('debe retornar null si el archivo no existe', async () => {
      const result = await service.findCSVFile('archivo-inexistente.csv');
      expect(result).toBeNull();
    });
  });

  describe('cleanData', () => {
    it('debe limpiar datos con formato estándar', () => {
      const data = {
        fecha: '2025-01-15',
        hora: '10:30',
        tipo_movimiento: 'entrada',
        cantidad_promedio: '100',
        tiempo_promedio_seg: '150',
        errores_porcentaje: '10',
        puerta: 'PC-01'
      };

      const result = service.cleanData(data, 'asistencias');

      expect(result).toBeDefined();
      expect(result.fecha).toBe('2025-01-15');
      expect(result.hora).toBe('10:30');
      expect(result.tipo_movimiento).toBe('entrada');
      expect(result.cantidad_promedio).toBe(100);
      expect(result.tiempo_promedio_seg).toBe(150);
    });

    it('debe limpiar datos con formato timestamp', () => {
      const data = {
        timestamp: '2025-10-15 09:22:00',
        tipo_movimiento: 'entrada',
        punto_control: 'PC-01',
        es_horario_pico: '1'
      };

      const result = service.cleanData(data, 'asistencias');

      expect(result).toBeDefined();
      expect(result.fecha).toBeDefined();
      expect(result.hora).toBeDefined();
      expect(result.tipo_movimiento).toBe('entrada');
      expect(result.tiempo_promedio_seg).toBeGreaterThan(0);
    });

    it('debe retornar null si faltan campos requeridos', () => {
      const data = {
        fecha: '2025-01-15'
        // Faltan hora y tipo_movimiento
      };

      const result = service.cleanData(data, 'asistencias');
      expect(result).toBeNull();
    });
  });

  describe('aggregateMetrics', () => {
    it('debe agregar métricas para asistencias', () => {
      const data = [
        {
          fecha: '2025-01-15',
          hora: '10:00',
          cantidad_promedio: 50,
          tiempo_promedio_seg: 120,
          errores_porcentaje: 5
        },
        {
          fecha: '2025-01-15',
          hora: '11:00',
          cantidad_promedio: 75,
          tiempo_promedio_seg: 150,
          errores_porcentaje: 8
        }
      ];

      const result = service.aggregateMetrics(data, 'asistencias');

      expect(result.summary).toBeDefined();
      expect(result.summary.total_records).toBe(2);
      expect(result.daily).toBeDefined();
      expect(Array.isArray(result.daily)).toBe(true);
      expect(result.hourly).toBeDefined();
    });

    it('debe retornar estructura vacía si no hay datos', () => {
      const result = service.aggregateMetrics([], 'asistencias');

      expect(result.summary).toEqual({});
      expect(result.daily).toEqual([]);
      expect(result.hourly).toEqual([]);
    });
  });

  describe('getBaselineData', () => {
    it('debe retornar null si no hay datos procesados', async () => {
      const result = await service.getBaselineData('asistencias');
      // Puede ser null o lanzar error dependiendo de la implementación
      expect(result === null || result === undefined).toBe(true);
    });
  });

  describe('listCSVFiles', () => {
    it('debe listar archivos CSV disponibles', async () => {
      // Crear archivos de prueba
      const testFile1 = path.join(service.baselineDir, 'test1.csv');
      const testFile2 = path.join(service.historicDataDir, 'test2.csv');
      await fs.writeFile(testFile1, 'test').catch(() => {});
      await fs.writeFile(testFile2, 'test').catch(() => {});

      const files = await service.listCSVFiles();

      expect(Array.isArray(files)).toBe(true);

      // Limpiar
      await fs.unlink(testFile1).catch(() => {});
      await fs.unlink(testFile2).catch(() => {});
    });
  });
});

