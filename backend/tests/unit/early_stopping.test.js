/**
 * Tests unitarios para EarlyStopping
 * Tests con casos edge y validación completa
 */

const EarlyStopping = require('../../ml/early_stopping');

describe('EarlyStopping', () => {
  let earlyStopping;

  beforeEach(() => {
    earlyStopping = new EarlyStopping({
      patience: 5,
      minDelta: 0.001,
      monitor: 'loss',
      mode: 'min'
    });
  });

  describe('shouldStop', () => {
    it('debe retornar false cuando hay mejora', () => {
      const shouldStop1 = earlyStopping.shouldStop(0.5);
      expect(shouldStop1).toBe(false);
      
      const shouldStop2 = earlyStopping.shouldStop(0.4);
      expect(shouldStop2).toBe(false);
    });

    it('debe incrementar wait cuando no hay mejora', () => {
      earlyStopping.shouldStop(0.5);
      const state1 = earlyStopping.getState();
      expect(state1.wait).toBe(0);
      
      earlyStopping.shouldStop(0.51); // No mejora (peor)
      const state2 = earlyStopping.getState();
      expect(state2.wait).toBe(1);
    });

    it('debe retornar true cuando se alcanza patience', () => {
      // Mejora inicial
      earlyStopping.shouldStop(0.5);
      
      // Sin mejora por patience veces
      for (let i = 0; i < 5; i++) {
        earlyStopping.shouldStop(0.51);
      }
      
      const shouldStop = earlyStopping.shouldStop(0.51);
      expect(shouldStop).toBe(true);
    });

    it('debe resetear wait cuando hay mejora', () => {
      earlyStopping.shouldStop(0.5);
      earlyStopping.shouldStop(0.51); // wait = 1
      earlyStopping.shouldStop(0.49); // Mejora, wait debe resetearse
      
      const state = earlyStopping.getState();
      expect(state.wait).toBe(0);
    });

    it('debe considerar minDelta para determinar mejora', () => {
      earlyStopping = new EarlyStopping({
        patience: 5,
        minDelta: 0.01,
        mode: 'min'
      });
      
      earlyStopping.shouldStop(0.5);
      const state1 = earlyStopping.getState();
      
      // Mejora menor que minDelta
      earlyStopping.shouldStop(0.495); // Mejora de 0.005 < 0.01
      const state2 = earlyStopping.getState();
      
      expect(state2.wait).toBe(1); // No cuenta como mejora
    });
  });

  describe('getBestWeights', () => {
    it('debe guardar mejores pesos cuando restoreBestWeights está habilitado', () => {
      earlyStopping = new EarlyStopping({
        patience: 5,
        restoreBestWeights: true
      });
      
      const weights1 = [1, 2, 3];
      const bias1 = 0.5;
      
      earlyStopping.shouldStop(0.5, weights1, bias1);
      
      const best = earlyStopping.getBestWeights();
      expect(best.weights).toEqual(weights1);
      expect(best.bias).toBe(bias1);
    });

    it('debe restaurar mejores pesos después de early stopping', () => {
      earlyStopping = new EarlyStopping({
        patience: 3,
        restoreBestWeights: true
      });
      
      const bestWeights = [1, 2, 3];
      const bestBias = 0.5;
      
      // Mejora inicial
      earlyStopping.shouldStop(0.5, bestWeights, bestBias);
      
      // Empeora
      const worseWeights = [4, 5, 6];
      earlyStopping.shouldStop(0.6, worseWeights, 1.0);
      earlyStopping.shouldStop(0.7, worseWeights, 1.0);
      earlyStopping.shouldStop(0.8, worseWeights, 1.0);
      
      const best = earlyStopping.getBestWeights();
      expect(best.weights).toEqual(bestWeights);
      expect(best.bias).toBe(bestBias);
    });
  });

  describe('reset', () => {
    it('debe resetear el estado completamente', () => {
      earlyStopping.shouldStop(0.5);
      earlyStopping.shouldStop(0.51);
      earlyStopping.shouldStop(0.52);
      
      earlyStopping.reset();
      
      const state = earlyStopping.getState();
      expect(state.wait).toBe(0);
      expect(state.bestValue).toBe(Infinity);
    });
  });

  describe('getState', () => {
    it('debe retornar estado actual', () => {
      earlyStopping.shouldStop(0.5);
      
      const state = earlyStopping.getState();
      
      expect(state).toHaveProperty('bestValue');
      expect(state).toHaveProperty('wait');
      expect(state).toHaveProperty('patience');
      expect(state).toHaveProperty('stopped');
    });
  });

  describe('Edge cases', () => {
    it('debe manejar mode max correctamente', () => {
      earlyStopping = new EarlyStopping({
        patience: 5,
        mode: 'max'
      });
      
      earlyStopping.shouldStop(0.5);
      const state1 = earlyStopping.getState();
      
      earlyStopping.shouldStop(0.6); // Mejora en modo max
      const state2 = earlyStopping.getState();
      
      expect(state2.wait).toBe(0);
    });

    it('debe manejar valores iguales', () => {
      earlyStopping.shouldStop(0.5);
      earlyStopping.shouldStop(0.5); // Mismo valor
      
      const state = earlyStopping.getState();
      expect(state.wait).toBe(1);
    });

    it('debe manejar patience = 0', () => {
      earlyStopping = new EarlyStopping({ patience: 0 });
      earlyStopping.shouldStop(0.5);
      
      const shouldStop = earlyStopping.shouldStop(0.51);
      expect(shouldStop).toBe(true);
    });

    it('debe manejar minDelta = 0', () => {
      earlyStopping = new EarlyStopping({ minDelta: 0 });
      earlyStopping.shouldStop(0.5);
      
      const shouldStop = earlyStopping.shouldStop(0.5001);
      expect(shouldStop).toBe(false);
    });

    it('debe manejar valores negativos en modo min', () => {
      earlyStopping.shouldStop(-0.5);
      earlyStopping.shouldStop(-0.4); // Peor (más positivo)
      
      const state = earlyStopping.getState();
      expect(state.wait).toBe(1);
    });

    it('debe manejar restoreBestWeights = false', () => {
      earlyStopping = new EarlyStopping({
        restoreBestWeights: false
      });
      
      earlyStopping.shouldStop(0.5, [1, 2, 3], 0.5);
      const best = earlyStopping.getBestWeights();
      
      expect(best.weights).toBeNull();
      expect(best.bias).toBeNull();
    });
  });
});

