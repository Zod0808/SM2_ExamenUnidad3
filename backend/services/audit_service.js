/**
 * Servicio de Auditoría - Triggers Automáticos de Cambios
 * US027 - Triggers de auditoría en MongoDB
 */

const mongoose = require('mongoose');

// Schema para historial de auditoría
const AuditLogSchema = new mongoose.Schema({
  entity_type: {
    type: String,
    required: true,
    index: true
  },
  entity_id: {
    type: String,
    required: true,
    index: true
  },
  action: {
    type: String,
    required: true,
    enum: ['create', 'update', 'delete', 'activate', 'deactivate'],
    index: true
  },
  user_id: {
    type: String,
    required: true,
    index: true
  },
  user_name: {
    type: String,
    required: true
  },
  user_role: {
    type: String,
    enum: ['admin', 'guardia', 'sistema'],
    default: 'sistema'
  },
  changes: {
    type: mongoose.Schema.Types.Mixed,
    default: {}
  },
  previous_state: {
    type: mongoose.Schema.Types.Mixed,
    default: null
  },
  new_state: {
    type: mongoose.Schema.Types.Mixed,
    default: null
  },
  ip_address: {
    type: String,
    default: null
  },
  user_agent: {
    type: String,
    default: null
  },
  timestamp: {
    type: Date,
    default: Date.now,
    index: true
  },
  metadata: {
    type: mongoose.Schema.Types.Mixed,
    default: {}
  }
}, {
  timestamps: true
});

// Índices compuestos para búsquedas eficientes
AuditLogSchema.index({ entity_type: 1, entity_id: 1, timestamp: -1 });
AuditLogSchema.index({ user_id: 1, timestamp: -1 });
AuditLogSchema.index({ action: 1, timestamp: -1 });

const AuditLog = mongoose.model('AuditLog', AuditLogSchema);

class AuditService {
  constructor() {
    this.enabled = true;
  }

  /**
   * Habilitar/deshabilitar auditoría
   */
  setEnabled(enabled) {
    this.enabled = enabled;
  }

  /**
   * Registrar acción de auditoría
   */
  async logAction({
    entityType,
    entityId,
    action,
    userId,
    userName,
    userRole = 'sistema',
    changes = {},
    previousState = null,
    newState = null,
    ipAddress = null,
    userAgent = null,
    metadata = {}
  }) {
    if (!this.enabled) {
      return null;
    }

    try {
      const auditLog = new AuditLog({
        entity_type: entityType,
        entity_id: entityId,
        action: action,
        user_id: userId,
        user_name: userName,
        user_role: userRole,
        changes: changes,
        previous_state: previousState,
        new_state: newState,
        ip_address: ipAddress,
        user_agent: userAgent,
        metadata: metadata,
        timestamp: new Date()
      });

      await auditLog.save();
      return auditLog;
    } catch (err) {
      console.error('❌ Error registrando auditoría:', err);
      // No lanzar error para no interrumpir el flujo principal
      return null;
    }
  }

  /**
   * Obtener historial de auditoría
   */
  async getAuditHistory(filters = {}) {
    try {
      const {
        entityType = null,
        entityId = null,
        userId = null,
        action = null,
        startDate = null,
        endDate = null,
        limit = 100,
        skip = 0
      } = filters;

      const query = {};

      if (entityType) query.entity_type = entityType;
      if (entityId) query.entity_id = entityId;
      if (userId) query.user_id = userId;
      if (action) query.action = action;

      if (startDate || endDate) {
        query.timestamp = {};
        if (startDate) query.timestamp.$gte = new Date(startDate);
        if (endDate) query.timestamp.$lte = new Date(endDate);
      }

      const logs = await AuditLog.find(query)
        .sort({ timestamp: -1 })
        .limit(limit)
        .skip(skip)
        .lean();

      const total = await AuditLog.countDocuments(query);

      return {
        logs: logs,
        total: total,
        limit: limit,
        skip: skip
      };
    } catch (err) {
      console.error('❌ Error obteniendo historial de auditoría:', err);
      throw err;
    }
  }

  /**
   * Obtener historial de una entidad específica
   */
  async getEntityHistory(entityType, entityId, limit = 50) {
    try {
      const logs = await AuditLog.find({
        entity_type: entityType,
        entity_id: entityId
      })
        .sort({ timestamp: -1 })
        .limit(limit)
        .lean();

      return logs;
    } catch (err) {
      console.error('❌ Error obteniendo historial de entidad:', err);
      throw err;
    }
  }

  /**
   * Obtener estadísticas de auditoría
   */
  async getAuditStats(startDate = null, endDate = null) {
    try {
      const query = {};
      if (startDate || endDate) {
        query.timestamp = {};
        if (startDate) query.timestamp.$gte = new Date(startDate);
        if (endDate) query.timestamp.$lte = new Date(endDate);
      }

      const stats = await AuditLog.aggregate([
        { $match: query },
        {
          $group: {
            _id: '$action',
            count: { $sum: 1 }
          }
        },
        { $sort: { count: -1 } }
      ]);

      const totalLogs = await AuditLog.countDocuments(query);
      const uniqueUsers = await AuditLog.distinct('user_id', query);
      const uniqueEntities = await AuditLog.distinct('entity_type', query);

      return {
        total_logs: totalLogs,
        by_action: stats.reduce((acc, stat) => {
          acc[stat._id] = stat.count;
          return acc;
        }, {}),
        unique_users: uniqueUsers.length,
        unique_entity_types: uniqueEntities.length,
        period: {
          start: startDate || null,
          end: endDate || null
        }
      };
    } catch (err) {
      console.error('❌ Error obteniendo estadísticas de auditoría:', err);
      throw err;
    }
  }

  /**
   * Middleware para Express que agrega información de auditoría a las requests
   */
  auditMiddleware(req, res, next) {
    // Agregar información de auditoría al request
    req.auditInfo = {
      userId: req.user?.id || req.user?._id || 'sistema',
      userName: req.user?.nombre || req.user?.username || 'Sistema',
      userRole: req.user?.rol || 'sistema',
      ipAddress: req.ip || req.connection.remoteAddress,
      userAgent: req.get('user-agent')
    };
    next();
  }

  /**
   * Función helper para crear middleware de auditoría específico para un modelo
   */
  createModelAuditMiddleware(modelName) {
    return async (req, res, next) => {
      const originalSend = res.json;
      const auditInfo = req.auditInfo || {};

      // Interceptar respuesta para auditar cambios
      res.json = async function(data) {
        try {
          // Si es una operación exitosa (status 200-299)
          if (res.statusCode >= 200 && res.statusCode < 300) {
            const method = req.method;
            const action = 
              method === 'POST' ? 'create' :
              method === 'PUT' || method === 'PATCH' ? 'update' :
              method === 'DELETE' ? 'delete' : null;

            if (action && data && (data._id || data.id || req.params.id)) {
              const entityId = data._id || data.id || req.params.id;

              // Obtener estado anterior si es update
              let previousState = null;
              if (action === 'update' && req.params.id) {
                try {
                  const Model = mongoose.model(modelName);
                  previousState = await Model.findById(req.params.id).lean();
                } catch (err) {
                  // Ignorar si no se puede obtener el estado anterior
                }
              }

              // Calcular cambios
              const changes = {};
              if (previousState && action === 'update') {
                for (const key in data) {
                  if (data[key] !== previousState[key]) {
                    changes[key] = {
                      from: previousState[key],
                      to: data[key]
                    };
                  }
                }
              }

              // Registrar auditoría usando la referencia guardada
              await self.logAction({
                entityType: modelName.toLowerCase(),
                entityId: entityId.toString(),
                action: action,
                userId: auditInfo.userId || 'sistema',
                userName: auditInfo.userName || 'Sistema',
                userRole: auditInfo.userRole || 'sistema',
                changes: changes,
                previousState: previousState,
                newState: action === 'delete' ? null : data,
                ipAddress: auditInfo.ipAddress,
                userAgent: auditInfo.userAgent,
                metadata: {
                  method: method,
                  url: req.originalUrl,
                  params: req.params,
                  body: req.body
                }
              });
            }
          }
        } catch (err) {
          console.error('❌ Error en middleware de auditoría:', err);
          // No interrumpir la respuesta
        }

        // Llamar al método original
        return originalSend.call(this, data);
      };

      next();
    };
  }
}

// Exportar también el modelo para uso directo
module.exports = { AuditService, AuditLog };

