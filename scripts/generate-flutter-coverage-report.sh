#!/bin/bash

# Script para generar reportes de cobertura de Flutter
# US064 - Cobertura de código y reportes

echo "📊 Generando reporte de cobertura de Flutter..."

# Ejecutar tests con cobertura
flutter test --coverage

# Verificar que se generó el archivo de cobertura
if [ ! -f "coverage/lcov.info" ]; then
    echo "❌ Error: No se encontró coverage/lcov.info"
    echo "   Asegúrate de ejecutar 'flutter test --coverage' primero"
    exit 1
fi

# Generar reporte HTML (requiere lcov)
if command -v genhtml &> /dev/null; then
    echo "📄 Generando reporte HTML..."
    genhtml coverage/lcov.info -o coverage/html
    echo "✅ Reporte HTML generado en: coverage/html/index.html"
else
    echo "⚠️  genhtml no está instalado. Instala lcov para generar reportes HTML:"
    echo "   Ubuntu/Debian: sudo apt-get install lcov"
    echo "   macOS: brew install lcov"
fi

# Generar resumen
echo ""
echo "📊 Resumen de Cobertura:"
lcov --summary coverage/lcov.info 2>/dev/null || echo "   (Instala lcov para ver el resumen)"

echo ""
echo "✅ Proceso completado"
echo "   - Reporte LCOV: coverage/lcov.info"
if [ -d "coverage/html" ]; then
    echo "   - Reporte HTML: coverage/html/index.html"
fi

