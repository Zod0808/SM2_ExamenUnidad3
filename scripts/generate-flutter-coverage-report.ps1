# Script PowerShell para generar reportes de cobertura de Flutter
# US064 - Cobertura de código y reportes

Write-Host "📊 Generando reporte de cobertura de Flutter..." -ForegroundColor Cyan

# Ejecutar tests con cobertura
flutter test --coverage

# Verificar que se generó el archivo de cobertura
if (-not (Test-Path "coverage/lcov.info")) {
    Write-Host "❌ Error: No se encontró coverage/lcov.info" -ForegroundColor Red
    Write-Host "   Asegúrate de ejecutar 'flutter test --coverage' primero" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "✅ Proceso completado" -ForegroundColor Green
Write-Host "   - Reporte LCOV: coverage/lcov.info" -ForegroundColor White

# Nota: Para generar HTML en Windows, se necesita lcov o usar herramientas alternativas
Write-Host ""
Write-Host "💡 Para generar reporte HTML en Windows:" -ForegroundColor Yellow
Write-Host "   1. Instala lcov (usando WSL o herramientas de Windows)" -ForegroundColor White
Write-Host "   2. O usa herramientas online como codecov.io" -ForegroundColor White

