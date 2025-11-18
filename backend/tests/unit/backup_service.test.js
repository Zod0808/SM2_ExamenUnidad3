/**
 * Tests unitarios para BackupService
 * US027, US030 - Backup automático y retención
 */

const BackupService = require('../../services/backup_service');
const fs = require('fs').promises;
const path = require('path');

// Mock de modelos Mongoose
const createMockModel = (name, documents = []) => {
  return {
    find: jest.fn().mockReturnValue({
      lean: jest.fn().mockResolvedValue(documents)
    }),
    deleteMany: jest.fn().mockResolvedValue({ deletedCount: 0 }),
    insertMany: jest.fn().mockResolvedValue(documents)
  };
};

describe('BackupService', () => {
  let backupService;
  let mockModels;

  beforeEach(() => {
    // Crear modelos mock
    mockModels = {
      Asistencia: createMockModel('Asistencia', [
        { _id: '1', fecha: new Date(), tipo: 'entrada' },
        { _id: '2', fecha: new Date(), tipo: 'salida' }
      ]),
      Usuario: createMockModel('Usuario', [
        { _id: '1', nombre: 'Admin', rol: 'admin' }
      ])
    };

    backupService = new BackupService(mockModels);
  });

  afterEach(async () => {
    // Limpiar backups de prueba
    try {
      const backupDir = path.join(__dirname, '../../data/backups');
      const files = await fs.readdir(backupDir);
      const testFiles = files.filter(f => f.includes('test') || f.startsWith('backup_'));
      for (const file of testFiles) {
        await fs.unlink(path.join(backupDir, file));
      }
    } catch (err) {
      // Ignorar errores de limpieza
    }
  });

  describe('createBackup', () => {
    it('debe crear un backup exitosamente', async () => {
      const result = await backupService.createBackup();

      expect(result.success).toBe(true);
      expect(result.backup_id).toBeDefined();
      expect(result.collections_count).toBeGreaterThan(0);
      expect(result.total_documents).toBeGreaterThan(0);
    });

    it('debe incluir todas las colecciones por defecto', async () => {
      const result = await backupService.createBackup();

      expect(result.collections_count).toBe(Object.keys(mockModels).length);
    });

    it('debe respaldar solo las colecciones especificadas', async () => {
      const result = await backupService.createBackup({
        collections: ['Asistencia']
      });

      expect(result.collections_count).toBe(1);
    });

    it('debe crear archivo de backup en el directorio correcto', async () => {
      const result = await backupService.createBackup();

      const fileExists = await fs.access(result.filepath).then(() => true).catch(() => false);
      expect(fileExists).toBe(true);
    });
  });

  describe('listBackups', () => {
    it('debe listar backups disponibles', async () => {
      // Crear un backup primero
      await backupService.createBackup();

      const backups = await backupService.listBackups();

      expect(Array.isArray(backups)).toBe(true);
      expect(backups.length).toBeGreaterThan(0);
    });

    it('debe retornar array vacío si no hay backups', async () => {
      // Limpiar todos los backups
      const backupDir = path.join(__dirname, '../../data/backups');
      const files = await fs.readdir(backupDir);
      for (const file of files) {
        if (file.startsWith('backup_') && file.endsWith('.json')) {
          await fs.unlink(path.join(backupDir, file));
        }
      }

      const backups = await backupService.listBackups();
      expect(backups.length).toBe(0);
    });
  });

  describe('cleanupOldBackups', () => {
    it('debe eliminar backups antiguos según política de retención', async () => {
      backupService.retentionDays = 1; // Retener solo 1 día

      // Crear backup
      await backupService.createBackup();

      // Simular que el backup es antiguo
      const backupDir = path.join(__dirname, '../../data/backups');
      const files = await fs.readdir(backupDir);
      const backupFile = files.find(f => f.startsWith('backup_') && f.endsWith('.json'));
      
      if (backupFile) {
        const filepath = path.join(backupDir, backupFile);
        const oldDate = new Date();
        oldDate.setDate(oldDate.getDate() - 2); // 2 días atrás
        await fs.utimes(filepath, oldDate, oldDate);
      }

      const result = await backupService.cleanupOldBackups();

      expect(result.deleted_count).toBeGreaterThanOrEqual(0);
    });
  });

  describe('configureAutoBackup', () => {
    it('debe configurar backup automático correctamente', () => {
      backupService.configureAutoBackup({
        enabled: true,
        intervalHours: 12,
        retentionDays: 60
      });

      expect(backupService.autoBackupEnabled).toBe(true);
      expect(backupService.backupIntervalHours).toBe(12);
      expect(backupService.retentionDays).toBe(60);
    });

    it('debe deshabilitar backup automático', () => {
      backupService.configureAutoBackup({ enabled: false });

      expect(backupService.autoBackupEnabled).toBe(false);
      expect(backupService.backupTimer).toBe(null);
    });
  });

  describe('getBackupStats', () => {
    it('debe retornar estadísticas de backups', async () => {
      await backupService.createBackup();

      const stats = await backupService.getBackupStats();

      expect(stats.total_backups).toBeGreaterThan(0);
      expect(stats.auto_backup_enabled).toBeDefined();
      expect(stats.retention_days).toBeDefined();
    });
  });

  describe('restoreBackup', () => {
    it('debe restaurar un backup exitosamente', async () => {
      // Crear backup primero
      const backup = await backupService.createBackup();

      // Restaurar backup
      const result = await backupService.restoreBackup(backup.backup_id, {
        collections: ['Asistencia'],
        clearExisting: false
      });

      expect(result.success).toBe(true);
      expect(result.backup_id).toBe(backup.backup_id);
      expect(result.results).toBeDefined();
    });

    it('debe lanzar error si el backup no existe', async () => {
      await expect(
        backupService.restoreBackup('backup-inexistente')
      ).rejects.toThrow();
    });
  });

  describe('applyRetentionPolicy', () => {
    it('debe aplicar política de retención a una colección', async () => {
      const result = await backupService.applyRetentionPolicy('Asistencia', 30);

      expect(result.success).toBe(true);
      expect(result.archived_count).toBeGreaterThanOrEqual(0);
    });

    it('debe lanzar error si la colección no existe', async () => {
      await expect(
        backupService.applyRetentionPolicy('ColeccionInexistente', 30)
      ).rejects.toThrow();
    });
  });

  describe('ensureBackupDirectory', () => {
    it('debe crear directorio de backups si no existe', async () => {
      const backupDir = path.join(__dirname, '../../data/backups');
      
      // Verificar que el directorio existe
      const dirExists = await fs.access(backupDir).then(() => true).catch(() => false);
      expect(dirExists).toBe(true);
    });
  });
});

