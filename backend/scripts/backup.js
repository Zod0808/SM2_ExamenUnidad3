#!/usr/bin/env node

/**
 * Script de Backup Manual de Base de Datos
 * 
 * Este script crea un backup completo de la base de datos MongoDB.
 * 
 * Uso:
 *   node scripts/backup.js
 * 
 * Variables de entorno requeridas:
 *   MONGODB_URI - URI de conexión a MongoDB
 *   BACKUP_DIR - Directorio para guardar backups (opcional)
 */

require('dotenv').config();
const mongoose = require('mongoose');
const fs = require('fs').promises;
const path = require('path');
const { exec } = require('child_process');
const { promisify } = require('util');

const execAsync = promisify(exec);

const BACKUP_DIR = process.env.BACKUP_DIR || path.join(__dirname, '../data/backups');
const MAX_BACKUPS = parseInt(process.env.MAX_BACKUPS) || 30;

// Crear directorio de backups si no existe
async function ensureBackupDir() {
  try {
    await fs.mkdir(BACKUP_DIR, { recursive: true });
    console.log(`✅ Directorio de backups: ${BACKUP_DIR}`);
  } catch (error) {
    console.error('❌ Error creando directorio de backups:', error);
    throw error;
  }
}

// Obtener nombre de archivo de backup
function getBackupFilename() {
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  return `backup-${timestamp}.json`;
}

// Crear backup usando mongodump
async function createBackupWithMongodump() {
  const backupFilename = getBackupFilename().replace('.json', '');
  const backupPath = path.join(BACKUP_DIR, backupFilename);
  
  // Extraer información de conexión
  const uri = process.env.MONGODB_URI;
  const uriMatch = uri.match(/mongodb\+srv:\/\/([^:]+):([^@]+)@([^/]+)\/(.+)/);
  
  if (!uriMatch) {
    throw new Error('Formato de MONGODB_URI inválido');
  }
  
  const [, username, password, cluster, database] = uriMatch;
  
  const mongodumpCommand = `mongodump --uri="${uri}" --out="${backupPath}"`;
  
  try {
    console.log('📦 Creando backup con mongodump...');
    const { stdout, stderr } = await execAsync(mongodumpCommand);
    
    if (stderr && !stderr.includes('writing')) {
      console.warn('⚠️  Advertencias:', stderr);
    }
    
    console.log('✅ Backup creado exitosamente');
    console.log(`📁 Ubicación: ${backupPath}`);
    
    return backupPath;
  } catch (error) {
    console.error('❌ Error ejecutando mongodump:', error.message);
    throw error;
  }
}

// Crear backup manual (exportar colecciones a JSON)
async function createManualBackup() {
  await mongoose.connect(process.env.MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    dbName: process.env.DB_NAME || 'ASISTENCIA'
  });
  
  const db = mongoose.connection.db;
  const collections = await db.listCollections().toArray();
  
  const backupData = {
    timestamp: new Date().toISOString(),
    database: db.databaseName,
    collections: {}
  };
  
  console.log(`📊 Exportando ${collections.length} colecciones...`);
  
  for (const collectionInfo of collections) {
    const collectionName = collectionInfo.name;
    console.log(`  Exportando: ${collectionName}`);
    
    const documents = await db.collection(collectionName).find({}).toArray();
    backupData.collections[collectionName] = documents;
  }
  
  const backupFilename = getBackupFilename();
  const backupPath = path.join(BACKUP_DIR, backupFilename);
  
  await fs.writeFile(backupPath, JSON.stringify(backupData, null, 2));
  
  console.log(`✅ Backup guardado en: ${backupPath}`);
  console.log(`📦 Tamaño: ${(await fs.stat(backupPath)).size} bytes`);
  
  await mongoose.connection.close();
  
  return backupPath;
}

// Limpiar backups antiguos
async function cleanOldBackups() {
  try {
    const files = await fs.readdir(BACKUP_DIR);
    const backupFiles = files
      .filter(f => f.startsWith('backup-'))
      .map(f => ({
        name: f,
        path: path.join(BACKUP_DIR, f),
        time: 0
      }));
    
    // Obtener fechas de modificación
    for (const file of backupFiles) {
      const stats = await fs.stat(file.path);
      file.time = stats.mtime.getTime();
    }
    
    // Ordenar por fecha (más antiguos primero)
    backupFiles.sort((a, b) => a.time - b.time);
    
    // Eliminar backups antiguos si exceden el máximo
    if (backupFiles.length > MAX_BACKUPS) {
      const toDelete = backupFiles.slice(0, backupFiles.length - MAX_BACKUPS);
      console.log(`🗑️  Eliminando ${toDelete.length} backups antiguos...`);
      
      for (const file of toDelete) {
        await fs.unlink(file.path);
        console.log(`  Eliminado: ${file.name}`);
      }
    }
    
    console.log(`✅ Total de backups: ${backupFiles.length}`);
  } catch (error) {
    console.error('❌ Error limpiando backups antiguos:', error);
  }
}

// Función principal
async function main() {
  try {
    console.log('🚀 Iniciando backup de base de datos...\n');
    
    await ensureBackupDir();
    
    // Intentar usar mongodump primero, si falla usar método manual
    let backupPath;
    try {
      backupPath = await createBackupWithMongodump();
    } catch (error) {
      console.log('⚠️  mongodump no disponible, usando método manual...');
      backupPath = await createManualBackup();
    }
    
    await cleanOldBackups();
    
    console.log('\n✅ Backup completado exitosamente');
    console.log(`📁 Ubicación: ${backupPath}`);
    
  } catch (error) {
    console.error('\n❌ Error durante el backup:', error);
    process.exit(1);
  }
}

// Ejecutar
main();

