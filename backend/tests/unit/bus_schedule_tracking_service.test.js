/**
 * Tests unitarios para BusScheduleTrackingService
 * US054 - Uso buses sugerido vs real
 */

const BusScheduleTrackingService = require('../../services/bus_schedule_tracking_service');

// Mock de modelo Mongoose
const createMockBusScheduleModel = () => {
  const records = [];
  
  return {
    create: jest.fn().mockImplementation((data) => {
      records.push(data);
      return Promise.resolve(data);
    }),
    find: jest.fn().mockReturnValue({
      sort: jest.fn().mockResolvedValue(records)
    })
  };
};

describe('BusScheduleTrackingService', () => {
  let trackingService;
  let mockBusScheduleModel;

  beforeEach(() => {
    mockBusScheduleModel = createMockBusScheduleModel();
    trackingService = new BusScheduleTrackingService(mockBusScheduleModel);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('recordImplementedSuggestion', () => {
    it('debe registrar sugerencia implementada correctamente', async () => {
      const suggestion = {
        route: 'Ruta A',
        time: '08:00',
        date: '2024-01-15'
      };

      const result = await trackingService.recordImplementedSuggestion(
        suggestion,
        'admin123',
        new Date('2024-01-15')
      );

      expect(result.suggestionId).toBeDefined();
      expect(result.suggestion).toEqual(suggestion);
      expect(result.implementedBy).toBe('admin123');
      expect(result.status).toBe('implemented');
      expect(mockBusScheduleModel.create).toHaveBeenCalled();
    });

    it('debe usar cache en memoria si no hay modelo', async () => {
      const serviceWithoutModel = new BusScheduleTrackingService(null);
      
      const suggestion = {
        route: 'Ruta B',
        time: '09:00'
      };

      const result = await serviceWithoutModel.recordImplementedSuggestion(
        suggestion,
        'admin123'
      );

      expect(result.suggestionId).toBeDefined();
      expect(serviceWithoutModel.implementedSuggestions.has(result.suggestionId)).toBe(true);
    });

    it('debe manejar errores al registrar sugerencia', async () => {
      mockBusScheduleModel.create.mockRejectedValue(new Error('DB Error'));

      await expect(
        trackingService.recordImplementedSuggestion(
          { route: 'Ruta C', time: '10:00' },
          'admin123'
        )
      ).rejects.toThrow('DB Error');
    });
  });

  describe('getImplementedSuggestions', () => {
    it('debe obtener sugerencias implementadas sin filtro de fecha', async () => {
      mockBusScheduleModel.find().sort.mockResolvedValue([
        { suggestionId: '1', suggestion: { route: 'Ruta A' } },
        { suggestionId: '2', suggestion: { route: 'Ruta B' } }
      ]);

      const result = await trackingService.getImplementedSuggestions({});

      expect(result.length).toBe(2);
      expect(mockBusScheduleModel.find).toHaveBeenCalled();
    });

    it('debe filtrar por rango de fechas', async () => {
      const dateRange = {
        startDate: '2024-01-01',
        endDate: '2024-01-31'
      };

      mockBusScheduleModel.find().sort.mockResolvedValue([
        {
          suggestionId: '1',
          suggestion: { route: 'Ruta A' },
          implementationDate: new Date('2024-01-15')
        }
      ]);

      const result = await trackingService.getImplementedSuggestions(dateRange);

      expect(result.length).toBe(1);
      expect(mockBusScheduleModel.find).toHaveBeenCalledWith(
        expect.objectContaining({
          implementationDate: expect.any(Object)
        })
      );
    });

    it('debe usar cache en memoria si no hay modelo', async () => {
      const serviceWithoutModel = new BusScheduleTrackingService(null);
      
      // Agregar sugerencias al cache
      await serviceWithoutModel.recordImplementedSuggestion(
        { route: 'Ruta A', time: '08:00' },
        'admin123',
        new Date('2024-01-15')
      );

      const result = await serviceWithoutModel.getImplementedSuggestions({
        startDate: '2024-01-01',
        endDate: '2024-01-31'
      });

      expect(result.length).toBe(1);
    });
  });

  describe('compareSuggestedVsReal', () => {
    it('debe comparar sugerencias con datos reales correctamente', async () => {
      const suggestions = [
        { route: 'Ruta A', time: '08:00', efficiencyMetrics: { overall: 0.8 } },
        { route: 'Ruta B', time: '09:00', efficiencyMetrics: { overall: 0.7 } }
      ];

      const actualData = {
        efficiency: { overall: 0.85 },
        schedules: [
          { route: 'Ruta A', time: '08:00' },
          { route: 'Ruta B', time: '09:00' }
        ]
      };

      // Mock de sugerencias implementadas
      jest.spyOn(trackingService, 'getImplementedSuggestions').mockResolvedValue([
        { suggestionId: trackingService._generateSuggestionId(suggestions[0]) },
        { suggestionId: trackingService._generateSuggestionId(suggestions[1]) }
      ]);

      const comparison = await trackingService.compareSuggestedVsReal(
        suggestions,
        actualData,
        { startDate: '2024-01-01', endDate: '2024-01-31' }
      );

      expect(comparison.totalSuggestions).toBe(2);
      expect(comparison.adoptionRate).toBe(1.0);
      expect(comparison.scheduleComparison.matches).toBe(2);
      expect(comparison.efficiencyComparison.improvement).toBeCloseTo(0.05);
    });

    it('debe calcular tasa de adopción correctamente', async () => {
      const suggestions = [
        { route: 'Ruta A', time: '08:00' },
        { route: 'Ruta B', time: '09:00' },
        { route: 'Ruta C', time: '10:00' }
      ];

      jest.spyOn(trackingService, 'getImplementedSuggestions').mockResolvedValue([
        { suggestionId: trackingService._generateSuggestionId(suggestions[0]) }
      ]);

      const comparison = await trackingService.compareSuggestedVsReal(
        suggestions,
        { schedules: [] },
        {}
      );

      expect(comparison.adoptionRate).toBeCloseTo(1/3, 2);
    });
  });

  describe('getAdoptionMetrics', () => {
    it('debe calcular métricas de adopción correctamente', async () => {
      const implemented = [
        {
          suggestionId: '1',
          suggestion: { createdAt: new Date('2024-01-01') },
          implementationDate: new Date('2024-01-02'),
          implementedBy: 'admin1'
        },
        {
          suggestionId: '2',
          suggestion: { createdAt: new Date('2024-01-01') },
          implementationDate: new Date('2024-01-03'),
          implementedBy: 'admin1'
        }
      ];

      jest.spyOn(trackingService, 'getImplementedSuggestions').mockResolvedValue(implemented);

      const metrics = await trackingService.getAdoptionMetrics({});

      expect(metrics.totalImplemented).toBe(2);
      expect(metrics.mostActiveImplementer).toEqual({ name: 'admin1', count: 2 });
      expect(metrics.averageImplementationTime).toBeGreaterThan(0);
    });

    it('debe retornar métricas vacías si no hay sugerencias implementadas', async () => {
      jest.spyOn(trackingService, 'getImplementedSuggestions').mockResolvedValue([]);

      const metrics = await trackingService.getAdoptionMetrics({});

      expect(metrics.totalImplemented).toBe(0);
      expect(metrics.adoptionRate).toBe(0.0);
      expect(metrics.mostActiveImplementer).toBeNull();
    });
  });

  describe('_generateSuggestionId', () => {
    it('debe generar ID único basado en ruta y tiempo', () => {
      const suggestion = {
        route: 'Ruta A',
        time: '08:00',
        date: '2024-01-15'
      };

      const id1 = trackingService._generateSuggestionId(suggestion);
      const id2 = trackingService._generateSuggestionId(suggestion);

      expect(id1).toBe(id2);
      expect(id1).toContain('Ruta A');
      expect(id1).toContain('08:00');
    });

    it('debe generar ID único si no hay ruta y tiempo', () => {
      const suggestion = { other: 'data' };

      const id1 = trackingService._generateSuggestionId(suggestion);
      const id2 = trackingService._generateSuggestionId(suggestion);

      // Deben ser diferentes porque incluyen timestamp
      expect(id1).not.toBe(id2);
    });
  });

  describe('_findMatchingActualData', () => {
    it('debe encontrar datos reales que coinciden con sugerencia', () => {
      const suggestion = {
        route: 'Ruta A',
        time: '08:00'
      };

      const actualData = {
        schedules: [
          { route: 'Ruta A', time: '08:00', passengers: 50 },
          { route: 'Ruta B', time: '09:00', passengers: 30 }
        ]
      };

      const match = trackingService._findMatchingActualData(suggestion, actualData);

      expect(match).toEqual({ route: 'Ruta A', time: '08:00', passengers: 50 });
    });

    it('debe retornar null si no hay coincidencia', () => {
      const suggestion = {
        route: 'Ruta C',
        time: '10:00'
      };

      const actualData = {
        schedules: [
          { route: 'Ruta A', time: '08:00' }
        ]
      };

      const match = trackingService._findMatchingActualData(suggestion, actualData);

      expect(match).toBeNull();
    });
  });
});

