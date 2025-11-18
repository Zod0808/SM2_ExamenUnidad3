module.exports = {
  testEnvironment: 'node',
  coverageDirectory: 'coverage',
  collectCoverageFrom: [
    'services/**/*.js',
    'ml/**/*.js',
    'models/**/*.js',
    '!**/node_modules/**',
    '!**/coverage/**',
    '!**/tests/**',
    '!**/scripts/**',
    '!index.js' // Excluir archivo principal si no se testea
  ],
  testMatch: [
    '**/tests/**/*.test.js',
    '**/__tests__/**/*.js'
  ],
  verbose: true,
  testTimeout: 10000,
  setupFilesAfterEnv: ['<rootDir>/tests/setup.js'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/$1'
  },
  // Reportes de cobertura
  coverageReporters: [
    'text',           // Salida en consola
    'text-summary',   // Resumen en consola
    'lcov',           // Formato LCOV para herramientas externas
    'html',           // Reporte HTML
    'json',           // JSON para procesamiento
    'json-summary'    // Resumen JSON
  ],
  // Umbrales mínimos de cobertura
  coverageThreshold: {
    global: {
      branches: 75,
      functions: 75,
      lines: 75,
      statements: 75
    },
    // Umbrales por directorio (más estrictos para servicios críticos)
    './services/': {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    },
    // Umbrales para ML
    './ml/': {
      branches: 70,
      functions: 70,
      lines: 70,
      statements: 70
    }
  },
  // Mostrar archivos sin cobertura
  coveragePathIgnorePatterns: [
    '/node_modules/',
    '/coverage/',
    '/tests/',
    '/scripts/'
  ]
};

