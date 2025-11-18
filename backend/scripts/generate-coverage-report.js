/**
 * Script para generar reportes de cobertura mejorados
 * US064 - Cobertura de código y reportes
 */

const fs = require('fs');
const path = require('path');

const coverageDir = path.join(__dirname, '../coverage');
const coverageSummaryPath = path.join(coverageDir, 'coverage-summary.json');
const reportPath = path.join(coverageDir, 'coverage-report.md');

/**
 * Genera un reporte markdown de cobertura
 */
function generateMarkdownReport() {
  try {
    if (!fs.existsSync(coverageSummaryPath)) {
      console.error('❌ coverage-summary.json no encontrado. Ejecuta "npm test" primero.');
      process.exit(1);
    }

    const summary = JSON.parse(fs.readFileSync(coverageSummaryPath, 'utf8'));
    
    let report = `# 📊 Reporte de Cobertura de Código - Backend

**Fecha de generación:** ${new Date().toLocaleString('es-ES')}  
**Generado automáticamente por:** generate-coverage-report.js

---

## 📈 Resumen Global

| Métrica | Cobertura | Estado |
|---------|-----------|--------|
| **Statements** | ${summary.total.statements.pct.toFixed(2)}% | ${getStatusIcon(summary.total.statements.pct, 70)} |
| **Branches** | ${summary.total.branches.pct.toFixed(2)}% | ${getStatusIcon(summary.total.branches.pct, 70)} |
| **Functions** | ${summary.total.functions.pct.toFixed(2)}% | ${getStatusIcon(summary.total.functions.pct, 70)} |
| **Lines** | ${summary.total.lines.pct.toFixed(2)}% | ${getStatusIcon(summary.total.lines.pct, 70)} |

**Umbral mínimo:** 70%

---

## 📁 Cobertura por Archivo

`;

    // Ordenar archivos por cobertura (menor a mayor)
    const files = Object.entries(summary)
      .filter(([key]) => key !== 'total')
      .sort((a, b) => a[1].lines.pct - b[1].lines.pct);

    report += `| Archivo | Statements | Branches | Functions | Lines | Estado |
|---------|------------|----------|-----------|-------|--------|
`;

    files.forEach(([file, data]) => {
      const relativePath = file.replace(process.cwd() + path.sep, '');
      const statements = data.statements.pct.toFixed(1);
      const branches = data.branches.pct.toFixed(1);
      const functions = data.functions.pct.toFixed(1);
      const lines = data.lines.pct.toFixed(1);
      const status = getStatusIcon(data.lines.pct, 70);

      report += `| \`${relativePath}\` | ${statements}% | ${branches}% | ${functions}% | ${lines}% | ${status} |\n`;
    });

    report += `\n---

## ⚠️ Archivos con Baja Cobertura (< 70%)

`;

    const lowCoverageFiles = files.filter(([, data]) => data.lines.pct < 70);
    
    if (lowCoverageFiles.length === 0) {
      report += '✅ Todos los archivos cumplen con el umbral mínimo de cobertura.\n';
    } else {
      lowCoverageFiles.forEach(([file, data]) => {
        const relativePath = file.replace(process.cwd() + path.sep, '');
        report += `- \`${relativePath}\`: ${data.lines.pct.toFixed(1)}% (objetivo: 70%)\n`;
      });
    }

    report += `\n---

## 📊 Estadísticas Detalladas

- **Total de archivos:** ${files.length}
- **Archivos con cobertura >= 70%:** ${files.filter(([, data]) => data.lines.pct >= 70).length}
- **Archivos con cobertura < 70%:** ${lowCoverageFiles.length}
- **Cobertura promedio:** ${(files.reduce((sum, [, data]) => sum + data.lines.pct, 0) / files.length).toFixed(2)}%

---

## 🔗 Enlaces Útiles

- **Reporte HTML:** [coverage/index.html](./index.html)
- **Reporte LCOV:** [coverage/lcov.info](./lcov.info)
- **Resumen JSON:** [coverage/coverage-summary.json](./coverage-summary.json)

---

*Generado automáticamente - No editar manualmente*
`;

    fs.writeFileSync(reportPath, report, 'utf8');
    console.log(`✅ Reporte de cobertura generado: ${reportPath}`);
    
    // Mostrar resumen en consola
    console.log('\n📊 Resumen de Cobertura:');
    console.log(`   Statements: ${summary.total.statements.pct.toFixed(2)}%`);
    console.log(`   Branches: ${summary.total.branches.pct.toFixed(2)}%`);
    console.log(`   Functions: ${summary.total.functions.pct.toFixed(2)}%`);
    console.log(`   Lines: ${summary.total.lines.pct.toFixed(2)}%`);
    
    if (lowCoverageFiles.length > 0) {
      console.log(`\n⚠️  ${lowCoverageFiles.length} archivo(s) con cobertura < 70%`);
    } else {
      console.log('\n✅ Todos los archivos cumplen con el umbral mínimo');
    }

  } catch (error) {
    console.error('❌ Error generando reporte:', error.message);
    process.exit(1);
  }
}

/**
 * Obtiene icono de estado según cobertura
 */
function getStatusIcon(coverage, threshold) {
  if (coverage >= threshold) {
    return '✅';
  } else if (coverage >= threshold - 10) {
    return '⚠️';
  } else {
    return '❌';
  }
}

// Ejecutar si se llama directamente
if (require.main === module) {
  generateMarkdownReport();
}

module.exports = { generateMarkdownReport };

