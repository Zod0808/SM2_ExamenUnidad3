/**
 * Servicio para tracking de sugerencias de horarios de buses implementadas
 * US054 - Uso buses sugerido vs real
 */

class BusScheduleTrackingService {
  constructor(BusScheduleModel = null) {
    this.BusSchedule = BusScheduleModel; // Modelo para guardar sugerencias implementadas
    this.implementedSuggestions = new Map(); // Cache en memoria
  }

  /**
   * Registra que una sugerencia fue implementada
   */
  async recordImplementedSuggestion(suggestion, implementedBy, implementationDate = new Date()) {
    try {
      const suggestionId = this._generateSuggestionId(suggestion);
      
      const record = {
        suggestionId,
        suggestion: suggestion,
        implementedBy: implementedBy,
        implementationDate: implementationDate,
        status: 'implemented',
        createdAt: new Date(),
      };

      // Guardar en base de datos si hay modelo
      if (this.BusSchedule) {
        await this.BusSchedule.create(record);
      } else {
        // Guardar en memoria
        this.implementedSuggestions.set(suggestionId, record);
      }

      return record;
    } catch (error) {
      console.error('Error registrando sugerencia implementada:', error);
      throw error;
    }
  }

  /**
   * Compara sugerencias con datos reales
   */
  async compareSuggestedVsReal(suggestions, actualData, dateRange) {
    try {
      const comparison = {
        dateRange,
        totalSuggestions: suggestions.length,
        implementedSuggestions: [],
        adoptionRate: 0.0,
        efficiencyComparison: {
          suggested: {},
          actual: {},
          improvement: 0.0,
        },
        scheduleComparison: {
          matches: 0,
          differences: [],
        },
      };

      // Obtener sugerencias implementadas
      const implemented = await this.getImplementedSuggestions(dateRange);
      
      // Calcular tasa de adopción
      if (suggestions.length > 0) {
        comparison.adoptionRate = implemented.length / suggestions.length;
      }

      // Comparar horarios sugeridos vs reales
      for (const suggestion of suggestions) {
        const suggestionId = this._generateSuggestionId(suggestion);
        const isImplemented = implemented.some(impl => impl.suggestionId === suggestionId);
        
        if (isImplemented) {
          comparison.implementedSuggestions.push({
            suggestion,
            implemented: true,
            actualData: this._findMatchingActualData(suggestion, actualData),
          });
          comparison.scheduleComparison.matches++;
        } else {
          comparison.scheduleComparison.differences.push({
            suggestion,
            reason: 'not_implemented',
          });
        }
      }

      // Comparar eficiencia
      if (suggestions.efficiencyMetrics && actualData.efficiency) {
        comparison.efficiencyComparison.suggested = suggestions.efficiencyMetrics;
        comparison.efficiencyComparison.actual = actualData.efficiency;
        
        const suggestedEfficiency = suggestions.efficiencyMetrics.overall || 0;
        const actualEfficiency = actualData.efficiency.overall || 0;
        comparison.efficiencyComparison.improvement = actualEfficiency - suggestedEfficiency;
      }

      return comparison;
    } catch (error) {
      console.error('Error comparando sugerido vs real:', error);
      throw error;
    }
  }

  /**
   * Obtiene sugerencias implementadas en un rango de fechas
   */
  async getImplementedSuggestions(dateRange) {
    try {
      if (this.BusSchedule) {
        const query = {};
        if (dateRange.startDate) {
          query.implementationDate = { $gte: new Date(dateRange.startDate) };
        }
        if (dateRange.endDate) {
          query.implementationDate = { ...query.implementationDate, $lte: new Date(dateRange.endDate) };
        }
        
        return await this.BusSchedule.find(query).sort({ implementationDate: -1 });
      } else {
        // Retornar de cache en memoria
        return Array.from(this.implementedSuggestions.values()).filter(impl => {
          if (dateRange.startDate && new Date(impl.implementationDate) < new Date(dateRange.startDate)) {
            return false;
          }
          if (dateRange.endDate && new Date(impl.implementationDate) > new Date(dateRange.endDate)) {
            return false;
          }
          return true;
        });
      }
    } catch (error) {
      console.error('Error obteniendo sugerencias implementadas:', error);
      return [];
    }
  }

  /**
   * Calcula métricas de adopción
   */
  async getAdoptionMetrics(dateRange) {
    try {
      const implemented = await this.getImplementedSuggestions(dateRange);
      
      return {
        totalImplemented: implemented.length,
        adoptionRate: implemented.length > 0 ? 1.0 : 0.0, // Se calcula con el total de sugerencias
        averageImplementationTime: this._calculateAverageImplementationTime(implemented),
        mostActiveImplementer: this._getMostActiveImplementer(implemented),
      };
    } catch (error) {
      console.error('Error calculando métricas de adopción:', error);
      return {
        totalImplemented: 0,
        adoptionRate: 0.0,
        averageImplementationTime: 0,
        mostActiveImplementer: null,
      };
    }
  }

  /**
   * Genera ID único para una sugerencia
   */
  _generateSuggestionId(suggestion) {
    if (suggestion.time && suggestion.route) {
      return `${suggestion.route}_${suggestion.time}_${suggestion.date || ''}`;
    }
    return `${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  }

  /**
   * Encuentra datos reales que coinciden con una sugerencia
   */
  _findMatchingActualData(suggestion, actualData) {
    // Buscar coincidencias por horario y ruta
    if (actualData.schedules) {
      return actualData.schedules.find(schedule => 
        schedule.time === suggestion.time && 
        schedule.route === suggestion.route
      );
    }
    return null;
  }

  /**
   * Calcula tiempo promedio de implementación
   */
  _calculateAverageImplementationTime(implemented) {
    if (implemented.length === 0) return 0;
    
    const times = implemented
      .filter(impl => impl.suggestion && impl.suggestion.createdAt)
      .map(impl => {
        const created = new Date(impl.suggestion.createdAt);
        const implemented = new Date(impl.implementationDate);
        return implemented - created;
      });
    
    if (times.length === 0) return 0;
    
    const average = times.reduce((sum, time) => sum + time, 0) / times.length;
    return Math.round(average / (1000 * 60 * 60)); // Convertir a horas
  }

  /**
   * Obtiene el implementador más activo
   */
  _getMostActiveImplementer(implemented) {
    if (implemented.length === 0) return null;
    
    const implementers = {};
    implemented.forEach(impl => {
      const implementer = impl.implementedBy || 'unknown';
      implementers[implementer] = (implementers[implementer] || 0) + 1;
    });
    
    const mostActive = Object.entries(implementers)
      .sort((a, b) => b[1] - a[1])[0];
    
    return mostActive ? { name: mostActive[0], count: mostActive[1] } : null;
  }
}

module.exports = BusScheduleTrackingService;

