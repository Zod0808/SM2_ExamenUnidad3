#!/usr/bin/env node

/**
 * Script de Migración de Base de Datos
 * 
 * Este script ayuda a migrar y actualizar la estructura de la base de datos.
 * 
 * Uso:
 *   node scripts/migrate.js [comando]
 * 
 * Comandos:
 *   up        - Ejecutar migraciones pendientes
 *   down      - Revertir última migración
 *   status    - Ver estado de migraciones
 *   create    - Crear nueva migración
 */

require('dotenv').config();
const mongoose = require('mongoose');
const fs = require('fs').promises;
const path = require('path');

const MIGRATIONS_DIR = path.join(__dirname, '../migrations');
const MIGRATION_LOG_COLLECTION = 'migration_logs';

// Conectar a MongoDB
async function connectDB() {
  try {
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      dbName: process.env.DB_NAME || 'ASISTENCIA'
    });
    console.log('✅ Conectado a MongoDB');
  } catch (error) {
    console.error('❌ Error conectando a MongoDB:', error);
    process.exit(1);
  }
}

// Crear índices necesarios
async function createIndexes() {
  console.log('📊 Creando índices...');
  
  const db = mongoose.connection.db;
  
  try {
    // Índices para asistencias
    await db.collection('asistencias').createIndex({ dni: 1, fecha_hora: -1 });
    await db.collection('asistencias').createIndex({ fecha_hora: -1 });
    await db.collection('asistencias').createIndex({ codigo_universitario: 1 });
    console.log('✅ Índices de asistencias creados');
    
    // Índices para presencia
    await db.collection('presencia').createIndex({ estudiante_dni: 1, esta_dentro: 1 });
    await db.collection('presencia').createIndex({ esta_dentro: 1, hora_entrada: 1 });
    console.log('✅ Índices de presencia creados');
    
    // Índices para alumnos
    await db.collection('alumnos').createIndex({ codigo_universitario: 1 }, { unique: true });
    await db.collection('alumnos').createIndex({ dni: 1 });
    console.log('✅ Índices de alumnos creados');
    
    // Índices para usuarios
    await db.collection('usuarios').createIndex({ email: 1 }, { unique: true });
    await db.collection('usuarios').createIndex({ dni: 1 }, { unique: true });
    console.log('✅ Índices de usuarios creados');
    
  } catch (error) {
    console.error('❌ Error creando índices:', error);
    throw error;
  }
}

// Validar estructura de colecciones
async function validateSchema() {
  console.log('🔍 Validando estructura de colecciones...');
  
  const db = mongoose.connection.db;
  const collections = await db.listCollections().toArray();
  
  const requiredCollections = [
    'usuarios',
    'alumnos',
    'asistencias',
    'presencia',
    'puntos_control',
    'asignaciones',
    'decisiones_manuales',
    'sesiones_guardias',
    'visitas',
    'externos',
    'facultades',
    'escuelas'
  ];
  
  const existingCollections = collections.map(c => c.name);
  const missingCollections = requiredCollections.filter(
    c => !existingCollections.includes(c)
  );
  
  if (missingCollections.length > 0) {
    console.warn('⚠️  Colecciones faltantes:', missingCollections);
    console.log('💡 Estas colecciones se crearán automáticamente al usarse');
  } else {
    console.log('✅ Todas las colecciones requeridas existen');
  }
}

// Aplicar políticas de retención
async function applyRetentionPolicies() {
  console.log('🗑️  Aplicando políticas de retención...');
  
  const db = mongoose.connection.db;
  const retentionDays = parseInt(process.env.RETENTION_DAYS_ASISTENCIAS) || 730;
  const cutoffDate = new Date();
  cutoffDate.setDate(cutoffDate.getDate() - retentionDays);
  
  try {
    // Eliminar asistencias antiguas (solo si está configurado)
    if (process.env.APPLY_RETENTION === 'true') {
      const result = await db.collection('asistencias').deleteMany({
        fecha_hora: { $lt: cutoffDate }
      });
      console.log(`✅ Eliminadas ${result.deletedCount} asistencias antiguas`);
    } else {
      console.log('ℹ️  Retención automática deshabilitada (APPLY_RETENTION != true)');
    }
  } catch (error) {
    console.error('❌ Error aplicando políticas de retención:', error);
  }
}

// Comando: up
async function migrateUp() {
  console.log('🚀 Ejecutando migraciones...');
  
  await connectDB();
  await createIndexes();
  await validateSchema();
  
  console.log('✅ Migraciones completadas');
  await mongoose.connection.close();
}

// Comando: status
async function showStatus() {
  await connectDB();
  
  const db = mongoose.connection.db;
  
  console.log('\n📊 Estado de la Base de Datos\n');
  
  // Contar documentos en cada colección
  const collections = [
    'usuarios', 'alumnos', 'asistencias', 'presencia',
    'puntos_control', 'asignaciones', 'decisiones_manuales',
    'sesiones_guardias', 'visitas', 'externos'
  ];
  
  for (const collectionName of collections) {
    try {
      const count = await db.collection(collectionName).countDocuments();
      console.log(`  ${collectionName.padEnd(25)}: ${count} documentos`);
    } catch (error) {
      console.log(`  ${collectionName.padEnd(25)}: No existe`);
    }
  }
  
  // Verificar índices
  console.log('\n📇 Índices:\n');
  try {
    const indexes = await db.collection('asistencias').indexes();
    console.log('  asistencias:');
    indexes.forEach(idx => {
      console.log(`    - ${JSON.stringify(idx.key)}`);
    });
  } catch (error) {
    console.log('  Error obteniendo índices');
  }
  
  await mongoose.connection.close();
}

// Comando principal
async function main() {
  const command = process.argv[2] || 'up';
  
  switch (command) {
    case 'up':
      await migrateUp();
      break;
    case 'status':
      await showStatus();
      break;
    case 'retention':
      await connectDB();
      await applyRetentionPolicies();
      await mongoose.connection.close();
      break;
    default:
      console.log(`
Uso: node scripts/migrate.js [comando]

Comandos:
  up        - Ejecutar migraciones (crear índices, validar estructura)
  status    - Ver estado de la base de datos
  retention - Aplicar políticas de retención de datos
      `);
      process.exit(1);
  }
}

// Ejecutar
main().catch(error => {
  console.error('❌ Error:', error);
  process.exit(1);
});

