/**
 * Script de Optimización de Índices MongoDB
 * Crea índices estratégicos para mejorar rendimiento de queries
 */

require('dotenv').config();
const mongoose = require('mongoose');

async function optimizeIndexes() {
  try {
    // Conectar a MongoDB
    await mongoose.connect(process.env.MONGODB_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      dbName: 'ASISTENCIA'
    });

    console.log('📊 Iniciando optimización de índices MongoDB...\n');

    const db = mongoose.connection.db;

    // ==================== ÍNDICES PARA ASISTENCIAS ====================
    console.log('📇 Creando índices para asistencias...');
    
    // Índice compuesto para búsquedas por fecha y tipo
    await db.collection('asistencias').createIndex(
      { fecha_hora: -1, tipo: 1 },
      { name: 'idx_fecha_tipo' }
    );
    console.log('  ✅ Índice: fecha_hora + tipo');

    // Índice compuesto para búsquedas por estudiante y fecha
    await db.collection('asistencias').createIndex(
      { codigo_universitario: 1, fecha_hora: -1 },
      { name: 'idx_codigo_fecha' }
    );
    console.log('  ✅ Índice: codigo_universitario + fecha_hora');

    // Índice compuesto para búsquedas por guardia y fecha
    await db.collection('asistencias').createIndex(
      { guardia_id: 1, fecha_hora: -1 },
      { name: 'idx_guardia_fecha' }
    );
    console.log('  ✅ Índice: guardia_id + fecha_hora');

    // Índice compuesto para búsquedas por puerta y fecha
    await db.collection('asistencias').createIndex(
      { puerta: 1, fecha_hora: -1 },
      { name: 'idx_puerta_fecha' }
    );
    console.log('  ✅ Índice: puerta + fecha_hora');

    // Índice compuesto para búsquedas por facultad y fecha
    await db.collection('asistencias').createIndex(
      { siglas_facultad: 1, fecha_hora: -1 },
      { name: 'idx_facultad_fecha' }
    );
    console.log('  ✅ Índice: siglas_facultad + fecha_hora');

    // Índice para entrada_tipo (filtros frecuentes)
    await db.collection('asistencias').createIndex(
      { entrada_tipo: 1 },
      { name: 'idx_entrada_tipo' }
    );
    console.log('  ✅ Índice: entrada_tipo');

    // ==================== ÍNDICES PARA PRESENCIA ====================
    console.log('\n📇 Creando índices para presencia...');
    
    // Índice compuesto para estudiantes dentro del campus
    await db.collection('presencia').createIndex(
      { esta_dentro: 1, hora_entrada: -1 },
      { name: 'idx_dentro_entrada' }
    );
    console.log('  ✅ Índice: esta_dentro + hora_entrada');

    // Índice compuesto para búsquedas por estudiante
    await db.collection('presencia').createIndex(
      { estudiante_dni: 1, esta_dentro: 1 },
      { name: 'idx_estudiante_dentro' }
    );
    console.log('  ✅ Índice: estudiante_dni + esta_dentro');

    // Índice para punto de entrada
    await db.collection('presencia').createIndex(
      { punto_entrada: 1 },
      { name: 'idx_punto_entrada' }
    );
    console.log('  ✅ Índice: punto_entrada');

    // ==================== ÍNDICES PARA ALUMNOS ====================
    console.log('\n📇 Creando índices para alumnos...');
    
    // Índice único para código universitario (ya existe, pero verificamos)
    await db.collection('alumnos').createIndex(
      { codigo_universitario: 1 },
      { unique: true, name: 'idx_codigo_unique' }
    );
    console.log('  ✅ Índice único: codigo_universitario');

    // Índice para búsquedas por DNI
    await db.collection('alumnos').createIndex(
      { dni: 1 },
      { name: 'idx_dni' }
    );
    console.log('  ✅ Índice: dni');

    // Índice compuesto para búsquedas por facultad y estado
    await db.collection('alumnos').createIndex(
      { siglas_facultad: 1, estado: 1 },
      { name: 'idx_facultad_estado' }
    );
    console.log('  ✅ Índice: siglas_facultad + estado');

    // Índice de texto para búsquedas por nombre
    await db.collection('alumnos').createIndex(
      { nombre: 'text', apellido: 'text' },
      { name: 'idx_text_search' }
    );
    console.log('  ✅ Índice de texto: nombre + apellido');

    // ==================== ÍNDICES PARA USUARIOS ====================
    console.log('\n📇 Creando índices para usuarios...');
    
    // Índice único para email (ya existe, pero verificamos)
    await db.collection('usuarios').createIndex(
      { email: 1 },
      { unique: true, name: 'idx_email_unique' }
    );
    console.log('  ✅ Índice único: email');

    // Índice único para DNI (ya existe, pero verificamos)
    await db.collection('usuarios').createIndex(
      { dni: 1 },
      { unique: true, name: 'idx_dni_unique' }
    );
    console.log('  ✅ Índice único: dni');

    // Índice compuesto para búsquedas por rango y estado
    await db.collection('usuarios').createIndex(
      { rango: 1, estado: 1 },
      { name: 'idx_rango_estado' }
    );
    console.log('  ✅ Índice: rango + estado');

    // Índice para puerta a cargo
    await db.collection('usuarios').createIndex(
      { puerta_acargo: 1 },
      { name: 'idx_puerta_acargo' }
    );
    console.log('  ✅ Índice: puerta_acargo');

    // ==================== ÍNDICES PARA ASIGNACIONES ====================
    console.log('\n📇 Creando índices para asignaciones...');
    
    // Índice compuesto para asignaciones activas
    await db.collection('asignaciones').createIndex(
      { guardia_id: 1, estado: 1, fecha_inicio: -1 },
      { name: 'idx_guardia_estado_fecha' }
    );
    console.log('  ✅ Índice: guardia_id + estado + fecha_inicio');

    // Índice compuesto para búsquedas por punto
    await db.collection('asignaciones').createIndex(
      { punto_id: 1, estado: 1 },
      { name: 'idx_punto_estado' }
    );
    console.log('  ✅ Índice: punto_id + estado');

    // Índice para rango de fechas
    await db.collection('asignaciones').createIndex(
      { fecha_inicio: 1, fecha_fin: 1 },
      { name: 'idx_fechas' }
    );
    console.log('  ✅ Índice: fecha_inicio + fecha_fin');

    // ==================== ÍNDICES PARA DECISIONES MANUALES ====================
    console.log('\n📇 Creando índices para decisiones manuales...');
    
    // Índice compuesto para búsquedas por estudiante y fecha
    await db.collection('decisiones_manuales').createIndex(
      { estudiante_dni: 1, timestamp: -1 },
      { name: 'idx_estudiante_timestamp' }
    );
    console.log('  ✅ Índice: estudiante_dni + timestamp');

    // Índice compuesto para búsquedas por guardia y fecha
    await db.collection('decisiones_manuales').createIndex(
      { guardia_id: 1, timestamp: -1 },
      { name: 'idx_guardia_timestamp' }
    );
    console.log('  ✅ Índice: guardia_id + timestamp');

    // Índice para autorización
    await db.collection('decisiones_manuales').createIndex(
      { autorizado: 1, timestamp: -1 },
      { name: 'idx_autorizado_timestamp' }
    );
    console.log('  ✅ Índice: autorizado + timestamp');

    // ==================== ÍNDICES PARA SESIONES GUARDIAS ====================
    console.log('\n📇 Creando índices para sesiones guardias...');
    
    // Índice compuesto para sesiones activas
    await db.collection('sesiones_guardias').createIndex(
      { guardia_id: 1, is_active: 1, last_activity: -1 },
      { name: 'idx_guardia_active_activity' }
    );
    console.log('  ✅ Índice: guardia_id + is_active + last_activity');

    // Índice para punto de control
    await db.collection('sesiones_guardias').createIndex(
      { punto_control: 1, is_active: 1 },
      { name: 'idx_punto_active' }
    );
    console.log('  ✅ Índice: punto_control + is_active');

    // ==================== ÍNDICES PARA VISITAS ====================
    console.log('\n📇 Creando índices para visitas...');
    
    // Índice compuesto para búsquedas por fecha y puerta
    await db.collection('visitas').createIndex(
      { fecha_hora: -1, puerta: 1 },
      { name: 'idx_fecha_puerta' }
    );
    console.log('  ✅ Índice: fecha_hora + puerta');

    // Índice para guardia
    await db.collection('visitas').createIndex(
      { guardia_nombre: 1 },
      { name: 'idx_guardia_nombre' }
    );
    console.log('  ✅ Índice: guardia_nombre');

    // ==================== RESUMEN ====================
    console.log('\n✅ Optimización de índices completada!\n');
    
    // Listar todos los índices creados
    const collections = [
      'asistencias', 'presencia', 'alumnos', 'usuarios',
      'asignaciones', 'decisiones_manuales', 'sesiones_guardias', 'visitas'
    ];

    console.log('📊 Resumen de índices por colección:\n');
    
    for (const collectionName of collections) {
      try {
        const indexes = await db.collection(collectionName).indexes();
        console.log(`${collectionName}:`);
        indexes.forEach(idx => {
          const keys = Object.keys(idx.key).map(k => `${k}:${idx.key[k]}`).join(', ');
          console.log(`  - ${idx.name || 'default'}: {${keys}}`);
        });
        console.log('');
      } catch (error) {
        console.log(`  ⚠️  Error obteniendo índices: ${error.message}\n`);
      }
    }

    await mongoose.connection.close();
    console.log('✅ Conexión cerrada');
    process.exit(0);

  } catch (error) {
    console.error('❌ Error optimizando índices:', error);
    await mongoose.connection.close();
    process.exit(1);
  }
}

// Ejecutar si se llama directamente
if (require.main === module) {
  optimizeIndexes();
}

module.exports = { optimizeIndexes };

