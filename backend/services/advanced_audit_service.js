/**
 * Servicio de Auditoría Avanzada
 * US067 - Auditoría y trazabilidad avanzada
 * 
 * Extiende el servicio de auditoría base con funcionalidades avanzadas:
 * - Búsqueda avanzada
 * - Exportación de reportes
 * - Dashboard y estadísticas
 * - Alertas y notificaciones
 */

const { AuditService, AuditLog } = require('./audit_service');
const fs = require('fs').promises;
const path = require('path');

class AdvancedAuditService extends AuditService {
  constructor() {
    super();
    this.alertThresholds = {
      suspiciousActivity: 10, // Número de acciones sospechosas
      failedAttempts: 5,      // Intentos fallidos
      bulkOperations: 20      // Operaciones masivas
    };
  }

  /**
   * Búsqueda avanzada de logs de auditoría
   * Soporta búsqueda por texto, múltiples filtros, y rangos de fechas
   */
  async advancedSearch({
    query = null,           // Búsqueda de texto libre
    entityType = null,
    entityId = null,
    userId = null,
    userName = null,
    action = null,
    userRole = null,
    ipAddress = null,
    startDate = null,
    endDate = null,
    changes = null,         // Buscar en cambios específicos
    metadata = null,        // Buscar en metadata
    limit = 100,
    skip = 0,
    sortBy = 'timestamp',
    sortOrder = -1
  }) {
    try {
      const mongoQuery = {};

      // Filtros básicos
      if (entityType) mongoQuery.entity_type = entityType;
      if (entityId) mongoQuery.entity_id = entityId;
      if (userId) mongoQuery.user_id = userId;
      if (action) mongoQuery.action = action;
      if (userRole) mongoQuery.user_role = userRole;
      if (ipAddress) mongoQuery.ip_address = ipAddress;

      // Búsqueda por nombre de usuario (regex case-insensitive)
      if (userName) {
        mongoQuery.user_name = { $regex: userName, $options: 'i' };
      }

      // Rango de fechas
      if (startDate || endDate) {
        mongoQuery.timestamp = {};
        if (startDate) mongoQuery.timestamp.$gte = new Date(startDate);
        if (endDate) mongoQuery.timestamp.$lte = new Date(endDate);
      }

      // Búsqueda de texto libre (en múltiples campos)
      if (query) {
        mongoQuery.$or = [
          { user_name: { $regex: query, $options: 'i' } },
          { entity_type: { $regex: query, $options: 'i' } },
          { entity_id: { $regex: query, $options: 'i' } },
          { ip_address: { $regex: query, $options: 'i' } }
        ];
      }

      // Búsqueda en cambios (usando $elemMatch para objetos anidados)
      if (changes) {
        mongoQuery['changes'] = { $exists: true };
        // Buscar en claves de cambios
        const changeKeys = Object.keys(changes);
        if (changeKeys.length > 0) {
          mongoQuery.$and = mongoQuery.$and || [];
          changeKeys.forEach(key => {
            mongoQuery.$and.push({
              [`changes.${key}`]: { $exists: true }
            });
          });
        }
      }

      // Búsqueda en metadata
      if (metadata) {
        const metadataKeys = Object.keys(metadata);
        if (metadataKeys.length > 0) {
          mongoQuery.$and = mongoQuery.$and || [];
          metadataKeys.forEach(key => {
            mongoQuery.$and.push({
              [`metadata.${key}`]: metadata[key]
            });
          });
        }
      }

      // Ordenamiento
      const sort = {};
      sort[sortBy] = sortOrder;

      const logs = await AuditLog.find(mongoQuery)
        .sort(sort)
        .limit(limit)
        .skip(skip)
        .lean();

      const total = await AuditLog.countDocuments(mongoQuery);

      return {
        logs,
        total,
        limit,
        skip,
        hasMore: (skip + limit) < total
      };
    } catch (err) {
      console.error('❌ Error en búsqueda avanzada:', err);
      throw err;
    }
  }

  /**
   * Exportar reportes de auditoría en diferentes formatos
   */
  async exportReport(filters = {}, format = 'json') {
    try {
      const data = await this.advancedSearch({
        ...filters,
        limit: 10000 // Límite alto para exportación
      });

      switch (format.toLowerCase()) {
        case 'json':
          return this._exportJSON(data.logs);
        case 'csv':
          return this._exportCSV(data.logs);
        case 'pdf':
          return await this._exportPDF(data.logs, filters);
        default:
          throw new Error(`Formato no soportado: ${format}`);
      }
    } catch (err) {
      console.error('❌ Error exportando reporte:', err);
      throw err;
    }
  }

  /**
   * Exportar a JSON
   */
  _exportJSON(logs) {
    return {
      format: 'json',
      generatedAt: new Date().toISOString(),
      total: logs.length,
      logs: logs
    };
  }

  /**
   * Exportar a CSV
   */
  _exportCSV(logs) {
    const headers = [
      'Timestamp',
      'Entity Type',
      'Entity ID',
      'Action',
      'User ID',
      'User Name',
      'User Role',
      'IP Address',
      'Changes',
      'Metadata'
    ];

    const rows = logs.map(log => [
      log.timestamp.toISOString(),
      log.entity_type || '',
      log.entity_id || '',
      log.action || '',
      log.user_id || '',
      log.user_name || '',
      log.user_role || '',
      log.ip_address || '',
      JSON.stringify(log.changes || {}),
      JSON.stringify(log.metadata || {})
    ]);

    const csvContent = [
      headers.join(','),
      ...rows.map(row => row.map(cell => `"${String(cell).replace(/"/g, '""')}"`).join(','))
    ].join('\n');

    return {
      format: 'csv',
      generatedAt: new Date().toISOString(),
      total: logs.length,
      content: csvContent
    };
  }

  /**
   * Exportar a PDF (estructura básica, requiere librería PDF)
   */
  async _exportPDF(logs, filters) {
    // Nota: Para implementación completa, usar librería como pdfkit o puppeteer
    // Por ahora, retornamos estructura de datos
    return {
      format: 'pdf',
      generatedAt: new Date().toISOString(),
      total: logs.length,
      filters: filters,
      logs: logs.slice(0, 100), // Limitar para PDF
      note: 'PDF generation requires additional library (pdfkit or puppeteer)'
    };
  }

  /**
   * Obtener dashboard de auditoría con estadísticas avanzadas
   */
  async getAuditDashboard(startDate = null, endDate = null) {
    try {
      const query = {};
      if (startDate || endDate) {
        query.timestamp = {};
        if (startDate) query.timestamp.$gte = new Date(startDate);
        if (endDate) query.timestamp.$lte = new Date(endDate);
      }

      // Estadísticas por acción
      const byAction = await AuditLog.aggregate([
        { $match: query },
        {
          $group: {
            _id: '$action',
            count: { $sum: 1 }
          }
        },
        { $sort: { count: -1 } }
      ]);

      // Estadísticas por tipo de entidad
      const byEntityType = await AuditLog.aggregate([
        { $match: query },
        {
          $group: {
            _id: '$entity_type',
            count: { $sum: 1 }
          }
        },
        { $sort: { count: -1 } }
      ]);

      // Estadísticas por usuario
      const byUser = await AuditLog.aggregate([
        { $match: query },
        {
          $group: {
            _id: '$user_id',
            userName: { $first: '$user_name' },
            userRole: { $first: '$user_role' },
            count: { $sum: 1 }
          }
        },
        { $sort: { count: -1 } },
        { $limit: 10 }
      ]);

      // Estadísticas por hora del día
      const byHour = await AuditLog.aggregate([
        { $match: query },
        {
          $group: {
            _id: { $hour: '$timestamp' },
            count: { $sum: 1 }
          }
        },
        { $sort: { _id: 1 } }
      ]);

      // Actividad reciente (últimas 24 horas)
      const last24Hours = new Date();
      last24Hours.setHours(last24Hours.getHours() - 24);
      const recentActivity = await AuditLog.countDocuments({
        ...query,
        timestamp: { $gte: last24Hours }
      });

      // Total de logs
      const totalLogs = await AuditLog.countDocuments(query);

      // Usuarios únicos
      const uniqueUsers = await AuditLog.distinct('user_id', query);

      // Entidades únicas
      const uniqueEntities = await AuditLog.distinct('entity_type', query);

      return {
        summary: {
          totalLogs,
          uniqueUsers: uniqueUsers.length,
          uniqueEntities: uniqueEntities.length,
          recentActivity24h: recentActivity,
          period: {
            start: startDate || null,
            end: endDate || null
          }
        },
        byAction: byAction.map(item => ({
          action: item._id,
          count: item.count,
          percentage: totalLogs > 0 ? ((item.count / totalLogs) * 100).toFixed(2) : 0
        })),
        byEntityType: byEntityType.map(item => ({
          entityType: item._id,
          count: item.count,
          percentage: totalLogs > 0 ? ((item.count / totalLogs) * 100).toFixed(2) : 0
        })),
        topUsers: byUser.map(item => ({
          userId: item._id,
          userName: item.userName,
          userRole: item.userRole,
          count: item.count
        })),
        byHour: byHour.map(item => ({
          hour: item._id,
          count: item.count
        }))
      };
    } catch (err) {
      console.error('❌ Error obteniendo dashboard:', err);
      throw err;
    }
  }

  /**
   * Detectar actividad sospechosa
   */
  async detectSuspiciousActivity(startDate = null, endDate = null) {
    try {
      const query = {};
      if (startDate || endDate) {
        query.timestamp = {};
        if (startDate) query.timestamp.$gte = new Date(startDate);
        if (endDate) query.timestamp.$lte = new Date(endDate);
      }

      const suspicious = [];

      // 1. Múltiples acciones de delete en corto tiempo
      const recentDeletes = await AuditLog.aggregate([
        { $match: { ...query, action: 'delete' } },
        {
          $group: {
            _id: '$user_id',
            userName: { $first: '$user_name' },
            count: { $sum: 1 },
            timestamps: { $push: '$timestamp' }
          }
        },
        { $match: { count: { $gte: this.alertThresholds.suspiciousActivity } } }
      ]);

      recentDeletes.forEach(item => {
        suspicious.push({
          type: 'multiple_deletes',
          severity: 'high',
          userId: item._id,
          userName: item.userName,
          count: item.count,
          description: `${item.count} operaciones de eliminación detectadas`
        });
      });

      // 2. Actividad desde múltiples IPs para el mismo usuario
      const multiIPActivity = await AuditLog.aggregate([
        { $match: query },
        {
          $group: {
            _id: '$user_id',
            userName: { $first: '$user_name' },
            uniqueIPs: { $addToSet: '$ip_address' },
            count: { $sum: 1 }
          }
        },
        {
          $match: {
            $expr: { $gt: [{ $size: '$uniqueIPs' }, 3] }
          }
        }
      ]);

      multiIPActivity.forEach(item => {
        suspicious.push({
          type: 'multiple_ips',
          severity: 'medium',
          userId: item._id,
          userName: item.userName,
          ipCount: item.uniqueIPs.length,
          description: `Actividad desde ${item.uniqueIPs.length} direcciones IP diferentes`
        });
      });

      // 3. Operaciones masivas
      const bulkOps = await AuditLog.aggregate([
        { $match: query },
        {
          $group: {
            _id: {
              userId: '$user_id',
              hour: { $hour: '$timestamp' },
              day: { $dayOfMonth: '$timestamp' },
              month: { $month: '$timestamp' },
              year: { $year: '$timestamp' }
            },
            userName: { $first: '$user_name' },
            count: { $sum: 1 }
          }
        },
        { $match: { count: { $gte: this.alertThresholds.bulkOperations } } }
      ]);

      bulkOps.forEach(item => {
        suspicious.push({
          type: 'bulk_operations',
          severity: 'medium',
          userId: item._id.userId,
          userName: item.userName,
          count: item.count,
          description: `${item.count} operaciones en una hora`
        });
      });

      return {
        total: suspicious.length,
        alerts: suspicious,
        generatedAt: new Date().toISOString()
      };
    } catch (err) {
      console.error('❌ Error detectando actividad sospechosa:', err);
      throw err;
    }
  }

  /**
   * Obtener trazabilidad completa de una entidad
   */
  async getEntityTraceability(entityType, entityId) {
    try {
      const logs = await AuditLog.find({
        entity_type: entityType,
        entity_id: entityId
      })
        .sort({ timestamp: 1 }) // Orden cronológico
        .lean();

      // Construir línea de tiempo
      const timeline = logs.map((log, index) => {
        const previousLog = index > 0 ? logs[index - 1] : null;
        return {
          timestamp: log.timestamp,
          action: log.action,
          user: {
            id: log.user_id,
            name: log.user_name,
            role: log.user_role
          },
          changes: log.changes,
          previousState: log.previous_state,
          newState: log.new_state,
          ipAddress: log.ip_address,
          metadata: log.metadata,
          isFirst: index === 0,
          isLast: index === logs.length - 1
        };
      });

      // Resumen de cambios
      const changeSummary = {
        totalChanges: logs.length,
        created: logs.find(l => l.action === 'create') || null,
        lastModified: logs.find(l => l.action === 'update') || null,
        deleted: logs.find(l => l.action === 'delete') || null,
        modifiedBy: [...new Set(logs.map(l => l.user_id))],
        actions: [...new Set(logs.map(l => l.action))]
      };

      return {
        entityType,
        entityId,
        timeline,
        summary: changeSummary,
        totalEvents: logs.length
      };
    } catch (err) {
      console.error('❌ Error obteniendo trazabilidad:', err);
      throw err;
    }
  }

  /**
   * Configurar umbrales de alertas
   */
  setAlertThresholds(thresholds) {
    this.alertThresholds = {
      ...this.alertThresholds,
      ...thresholds
    };
  }
}

module.exports = AdvancedAuditService;

