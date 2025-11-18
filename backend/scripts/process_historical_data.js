/**
 * Script para procesar el dataset histórico automáticamente
 * US055 - Comparativo antes/después
 * 
 * Uso: node scripts/process_historical_data.js
 */

const HistoricalDataService = require('../services/historical_data_service');
const path = require('path');

async function main() {
  console.log('🔄 Procesando dataset histórico...\n');
  
  const service = new HistoricalDataService();
  
  try {
    // Procesar dataset_universidad_10000.csv
    const filename = 'dataset_universidad_10000.csv';
    console.log(`📂 Buscando archivo: ${filename}`);
    
    const result = await service.processHistoricalDataset(filename);
    
    console.log('\n✅ Procesamiento completado exitosamente!');
    console.log(`📊 Total de registros procesados: ${result.totalRecords}`);
    console.log(`📈 Período: ${result.processed.summary.periodo_dias} días`);
    console.log(`⏱️  Tiempo promedio: ${result.processed.summary.tiempo_promedio_segundos.toFixed(1)} segundos`);
    console.log(`❌ Errores promedio: ${result.processed.summary.errores_promedio_porcentaje.toFixed(1)}%`);
    console.log(`✅ Precisión estimada: ${result.processed.summary.precision_promedio.toFixed(1)}%`);
    console.log(`\n💾 Datos guardados en: ${result.savedTo}`);
    
    console.log('\n🎉 Datos históricos listos para comparativo antes/después!');
    
    process.exit(0);
  } catch (error) {
    console.error('\n❌ Error procesando dataset:', error.message);
    process.exit(1);
  }
}

main();

