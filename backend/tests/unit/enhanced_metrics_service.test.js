/**
 * Tests unitarios para EnhancedMetricsService
 * Tests mejorados con casos edge y validación completa
 */

const EnhancedMetricsService = require('../../ml/enhanced_metrics_service');

describe('EnhancedMetricsService', () => {
  let metricsService;

  beforeEach(() => {
    metricsService = new EnhancedMetricsService();
  });

  describe('calculateEnhancedMetrics', () => {
    it('debe calcular métricas de clasificación correctamente', () => {
      const predicted = [1, 1, 0, 0, 1, 0, 1, 0];
      const actual = [1, 0, 0, 1, 1, 0, 1, 0];
      
      const result = metricsService.calculateEnhancedMetrics(predicted, actual, {
        includeClassificationMetrics: true,
        includeRegressionMetrics: false
      });

      expect(result.classification).toBeDefined();
      expect(result.classification.accuracy).toBeGreaterThanOrEqual(0);
      expect(result.classification.accuracy).toBeLessThanOrEqual(1);
      expect(result.classification.precision).toBeDefined();
      expect(result.classification.recall).toBeDefined();
      expect(result.classification.f1Score).toBeDefined();
    });

    it('debe calcular métricas de regresión correctamente', () => {
      const predicted = [10.5, 20.3, 15.7, 30.1, 25.8];
      const actual = [10.0, 20.0, 16.0, 30.0, 26.0];
      
      const result = metricsService.calculateEnhancedMetrics(predicted, actual, {
        includeClassificationMetrics: false,
        includeRegressionMetrics: true
      });

      expect(result.regression).toBeDefined();
      expect(result.regression.mse).toBeGreaterThanOrEqual(0);
      expect(result.regression.rmse).toBeGreaterThanOrEqual(0);
      expect(result.regression.mae).toBeGreaterThanOrEqual(0);
      expect(result.regression.r2).toBeDefined();
    });

    it('debe manejar arrays vacíos', () => {
      const result = metricsService.calculateEnhancedMetrics([], []);
      expect(result.sampleSize).toBe(0);
    });

    it('debe manejar arrays con un solo elemento', () => {
      const result = metricsService.calculateEnhancedMetrics([1], [1]);
      expect(result.sampleSize).toBe(1);
    });

    it('debe manejar arrays con todos los valores iguales', () => {
      const predicted = [1, 1, 1, 1, 1];
      const actual = [1, 1, 1, 1, 1];
      
      const result = metricsService.calculateEnhancedMetrics(predicted, actual);
      expect(result.classification.accuracy).toBe(1);
    });

    it('debe manejar arrays con valores completamente diferentes', () => {
      const predicted = [1, 1, 1, 0, 0];
      const actual = [0, 0, 0, 1, 1];
      
      const result = metricsService.calculateEnhancedMetrics(predicted, actual);
      expect(result.classification.accuracy).toBe(0);
    });

    it('debe calcular métricas adicionales (ROC-AUC, PR-AUC, calibración)', () => {
      const predicted = [0.9, 0.8, 0.3, 0.2, 0.7, 0.1, 0.6, 0.4];
      const actual = [1, 1, 0, 0, 1, 0, 1, 0];
      
      const result = metricsService.calculateEnhancedMetrics(predicted, actual);
      
      expect(result.additional).toBeDefined();
      expect(result.additional.rocAuc).toBeDefined();
      expect(result.additional.prAuc).toBeDefined();
      expect(result.additional.calibration).toBeDefined();
      expect(result.additional.confidenceIntervals).toBeDefined();
    });
  });

  describe('calculateClassificationMetrics', () => {
    it('debe calcular todas las métricas de clasificación', () => {
      const predicted = [1, 1, 0, 0, 1];
      const actual = [1, 0, 0, 1, 1];
      
      const metrics = metricsService.calculateClassificationMetrics(predicted, actual);
      
      expect(metrics.accuracy).toBeDefined();
      expect(metrics.precision).toBeDefined();
      expect(metrics.recall).toBeDefined();
      expect(metrics.specificity).toBeDefined();
      expect(metrics.f1Score).toBeDefined();
      expect(metrics.f2Score).toBeDefined();
      expect(metrics.f0_5Score).toBeDefined();
      expect(metrics.balancedAccuracy).toBeDefined();
      expect(metrics.mcc).toBeDefined();
      expect(metrics.cohenKappa).toBeDefined();
      expect(metrics.confusionMatrix).toBeDefined();
      expect(metrics.support).toBeDefined();
      expect(metrics.interpretation).toBeDefined();
    });

    it('debe manejar división por cero en precision', () => {
      const predicted = [0, 0, 0, 0, 0];
      const actual = [0, 0, 0, 0, 0];
      
      const metrics = metricsService.calculateClassificationMetrics(predicted, actual);
      expect(metrics.precision).toBe(0);
    });

    it('debe manejar división por cero en recall', () => {
      const predicted = [0, 0, 0, 0, 0];
      const actual = [1, 1, 1, 1, 1];
      
      const metrics = metricsService.calculateClassificationMetrics(predicted, actual);
      expect(metrics.recall).toBe(0);
    });
  });

  describe('calculateRegressionMetrics', () => {
    it('debe calcular todas las métricas de regresión', () => {
      const predicted = [10.5, 20.3, 15.7, 30.1];
      const actual = [10.0, 20.0, 16.0, 30.0];
      
      const metrics = metricsService.calculateRegressionMetrics(predicted, actual);
      
      expect(metrics.mse).toBeGreaterThanOrEqual(0);
      expect(metrics.rmse).toBeGreaterThanOrEqual(0);
      expect(metrics.mae).toBeGreaterThanOrEqual(0);
      expect(metrics.r2).toBeDefined();
      expect(metrics.adjustedR2).toBeDefined();
      expect(metrics.mape).toBeGreaterThanOrEqual(0);
      expect(metrics.medianError).toBeGreaterThanOrEqual(0);
    });

    it('debe manejar valores cero en MAPE', () => {
      const predicted = [10, 20, 0, 30];
      const actual = [10, 20, 0, 30];
      
      const metrics = metricsService.calculateRegressionMetrics(predicted, actual);
      expect(metrics.mape).toBeGreaterThanOrEqual(0);
    });

    it('debe calcular R² correctamente', () => {
      const predicted = [10, 20, 30, 40];
      const actual = [10, 20, 30, 40];
      
      const metrics = metricsService.calculateRegressionMetrics(predicted, actual);
      expect(metrics.r2).toBeCloseTo(1, 2);
    });
  });

  describe('calculateConfusionMatrix', () => {
    it('debe calcular matriz de confusión correctamente', () => {
      const predicted = [1, 1, 0, 0, 1];
      const actual = [1, 0, 0, 1, 1];
      
      const matrix = metricsService.calculateConfusionMatrix(predicted, actual);
      
      expect(matrix.truePositives).toBeGreaterThanOrEqual(0);
      expect(matrix.trueNegatives).toBeGreaterThanOrEqual(0);
      expect(matrix.falsePositives).toBeGreaterThanOrEqual(0);
      expect(matrix.falseNegatives).toBeGreaterThanOrEqual(0);
    });
  });

  describe('calculateMCC', () => {
    it('debe calcular MCC correctamente', () => {
      const matrix = {
        truePositives: 2,
        trueNegatives: 1,
        falsePositives: 1,
        falseNegatives: 1
      };
      
      const mcc = metricsService.calculateMCC(matrix);
      expect(mcc).toBeGreaterThanOrEqual(-1);
      expect(mcc).toBeLessThanOrEqual(1);
    });

    it('debe retornar 0 si el denominador es cero', () => {
      const matrix = {
        truePositives: 0,
        trueNegatives: 0,
        falsePositives: 0,
        falseNegatives: 0
      };
      
      const mcc = metricsService.calculateMCC(matrix);
      expect(mcc).toBe(0);
    });
  });

  describe('calculateCalibration', () => {
    it('debe calcular calibración correctamente', () => {
      const predicted = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0];
      const actual = [0, 0, 0, 1, 0, 1, 1, 1, 1, 1];
      
      const calibration = metricsService.calculateCalibration(predicted, actual);
      
      expect(calibration.bins).toBeDefined();
      expect(calibration.meanCalibrationError).toBeGreaterThanOrEqual(0);
      expect(calibration.isWellCalibrated).toBeDefined();
    });
  });

  describe('calculateConfidenceIntervals', () => {
    it('debe calcular intervalos de confianza', () => {
      const predicted = [10, 20, 30, 40, 50];
      const actual = [10, 20, 30, 40, 50];
      
      const intervals = metricsService.calculateConfidenceIntervals(predicted, actual);
      
      expect(intervals.mean).toBeGreaterThanOrEqual(0);
      expect(intervals.std).toBeGreaterThanOrEqual(0);
      expect(intervals.lowerBound).toBeDefined();
      expect(intervals.upperBound).toBeDefined();
      expect(intervals.upperBound).toBeGreaterThanOrEqual(intervals.lowerBound);
    });
  });

  describe('generateComprehensiveReport', () => {
    it('debe generar reporte completo', () => {
      const predicted = [1, 1, 0, 0, 1];
      const actual = [1, 0, 0, 1, 1];
      
      const report = metricsService.generateComprehensiveReport(predicted, actual);
      
      expect(report.summary).toBeDefined();
      expect(report.metrics).toBeDefined();
      expect(report.recommendations).toBeDefined();
      expect(report.summary.overallPerformance).toBeDefined();
    });
  });

  describe('Edge cases', () => {
    it('debe manejar arrays de diferentes longitudes', () => {
      expect(() => {
        metricsService.calculateEnhancedMetrics([1, 2], [1]);
      }).not.toThrow();
    });

    it('debe manejar valores NaN', () => {
      const predicted = [1, NaN, 0];
      const actual = [1, 1, 0];
      
      expect(() => {
        metricsService.calculateEnhancedMetrics(predicted, actual);
      }).not.toThrow();
    });

    it('debe manejar valores null/undefined', () => {
      const predicted = [1, null, 0];
      const actual = [1, undefined, 0];
      
      expect(() => {
        metricsService.calculateEnhancedMetrics(predicted, actual);
      }).not.toThrow();
    });

    it('debe manejar valores muy grandes', () => {
      const predicted = [1e10, 2e10, 3e10];
      const actual = [1e10, 2e10, 3e10];
      
      const result = metricsService.calculateEnhancedMetrics(predicted, actual, {
        includeRegressionMetrics: true
      });
      
      expect(result.regression).toBeDefined();
    });

    it('debe manejar valores muy pequeños', () => {
      const predicted = [1e-10, 2e-10, 3e-10];
      const actual = [1e-10, 2e-10, 3e-10];
      
      const result = metricsService.calculateEnhancedMetrics(predicted, actual, {
        includeRegressionMetrics: true
      });
      
      expect(result.regression).toBeDefined();
    });
  });
});

