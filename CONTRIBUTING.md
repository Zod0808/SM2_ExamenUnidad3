# Guía de Contribución

Gracias por tu interés en contribuir al Sistema de Control de Acceso con Pulseras Inteligentes. Esta guía te ayudará a entender cómo contribuir de manera efectiva.

## Tabla de Contenidos

1. [Código de Conducta](#código-de-conducta)
2. [Cómo Contribuir](#cómo-contribuir)
3. [Configuración del Entorno de Desarrollo](#configuración-del-entorno-de-desarrollo)
4. [Estándares de Código](#estándares-de-código)
5. [Proceso de Desarrollo](#proceso-de-desarrollo)
6. [Testing](#testing)
7. [Documentación](#documentación)
8. [Pull Requests](#pull-requests)

---

## Código de Conducta

### Nuestro Compromiso

Nos comprometemos a mantener un ambiente abierto y acogedor para todos, independientemente de edad, tamaño corporal, discapacidad, etnia, identidad y expresión de género, nivel de experiencia, nacionalidad, apariencia personal, raza, religión o identidad y orientación sexual.

### Estándares

- Usar lenguaje acogedor e inclusivo
- Respetar diferentes puntos de vista y experiencias
- Aceptar críticas constructivas con gracia
- Enfocarse en lo que es mejor para la comunidad
- Mostrar empatía hacia otros miembros de la comunidad

---

## Cómo Contribuir

### Reportar Bugs

Si encuentras un bug, por favor:

1. Verifica que no haya sido reportado ya en los [Issues](../../issues)
2. Crea un nuevo issue con:
   - Título descriptivo
   - Descripción clara del problema
   - Pasos para reproducir
   - Comportamiento esperado vs. actual
   - Screenshots si aplica
   - Información del entorno (OS, versión de Flutter/Node.js)

### Sugerir Mejoras

Para sugerir nuevas funcionalidades:

1. Verifica que no haya sido sugerido ya
2. Crea un issue con:
   - Descripción clara de la funcionalidad
   - Casos de uso
   - Beneficios esperados
   - Consideraciones técnicas si aplica

### Contribuir Código

1. Fork el repositorio
2. Crea una rama desde `main` para tu feature/fix
3. Realiza tus cambios siguiendo los estándares
4. Escribe tests para tu código
5. Asegúrate de que todos los tests pasen
6. Actualiza la documentación si es necesario
7. Crea un Pull Request

---

## Configuración del Entorno de Desarrollo

### Requisitos Previos

- **Flutter SDK** >= 3.7.2
- **Node.js** >= 18.x LTS
- **MongoDB Atlas** (cuenta gratuita) o MongoDB local
- **Git** >= 2.30
- **Python** 3.9+ (para ML)
- **Editor de código** (VS Code recomendado)

### Configuración Inicial

#### 1. Clonar el Repositorio

```bash
git clone https://github.com/tu-usuario/MovilesII.git
cd MovilesII
```

#### 2. Configurar Backend

```bash
cd backend
npm install

# Copiar archivo de configuración
cp .env.example .env

# Editar .env con tus credenciales
nano .env
```

**Variables de entorno requeridas (.env):**
```env
MONGODB_URI=mongodb+srv://usuario:password@cluster.mongodb.net/ASISTENCIA
PORT=3000
NODE_ENV=development
JWT_SECRET=tu_secret_jwt_aqui
```

#### 3. Configurar Aplicación Flutter

```bash
# Desde la raíz del proyecto
flutter pub get

# Configurar API endpoint
# Editar lib/config/api_config.dart
```

#### 4. Configurar Machine Learning (Opcional)

```bash
cd backend/ml
pip install -r requirements.txt
```

### Verificar Instalación

```bash
# Backend
cd backend
npm test

# Flutter
flutter test

# Verificar linting
flutter analyze
```

---

## Estándares de Código

### Flutter (Dart)

#### Convenciones de Nomenclatura

- **Clases**: PascalCase (`StudentService`, `AuthViewModel`)
- **Variables y funciones**: camelCase (`studentName`, `getStudent()`)
- **Constantes**: lowerCamelCase con `const` (`const apiBaseUrl`)
- **Archivos**: snake_case (`student_service.dart`, `auth_viewmodel.dart`)

#### Estructura de Archivos

```dart
// 1. Imports (dart, flutter, packages, relative)
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student_model.dart';
import '../services/api_service.dart';

// 2. Clase principal
class StudentService {
  // 2.1. Constantes
  static const String baseUrl = 'https://api.example.com';
  
  // 2.2. Variables privadas
  final ApiService _apiService;
  
  // 2.3. Constructor
  StudentService(this._apiService);
  
  // 2.4. Métodos públicos
  Future<Student> getStudent(String code) async {
    // Implementación
  }
  
  // 2.5. Métodos privados
  void _validateCode(String code) {
    // Implementación
  }
}
```

#### Formato

Usa `dart format` para formatear el código:

```bash
dart format lib/
```

#### Linting

Sigue las reglas de `analysis_options.yaml`. Ejecuta:

```bash
flutter analyze
```

### Node.js (JavaScript)

#### Convenciones de Nomenclatura

- **Clases**: PascalCase (`BackupService`, `AuditService`)
- **Funciones y variables**: camelCase (`createBackup`, `backupId`)
- **Constantes**: UPPER_SNAKE_CASE (`MAX_RETRIES`, `DEFAULT_TIMEOUT`)
- **Archivos**: camelCase (`backupService.js`, `auditService.js`)

#### Estructura de Archivos

```javascript
// 1. Imports
const mongoose = require('mongoose');
const fs = require('fs').promises;

// 2. Constantes
const BACKUP_DIR = './data/backups';
const MAX_BACKUPS = 30;

// 3. Funciones auxiliares (si aplica)
function generateBackupName() {
  return `backup-${Date.now()}.json`;
}

// 4. Clase o funciones principales
class BackupService {
  constructor() {
    // Inicialización
  }
  
  async createBackup() {
    // Implementación
  }
}

// 5. Exports
module.exports = BackupService;
```

#### Formato

Usa Prettier para formatear el código:

```bash
npx prettier --write backend/
```

#### Linting

Sigue las reglas de ESLint. Ejecuta:

```bash
cd backend
npm run lint
```

---

## Proceso de Desarrollo

### 1. Crear una Rama

```bash
# Desde main actualizada
git checkout main
git pull origin main

# Crear rama para feature
git checkout -b feature/nombre-de-la-feature

# O para bugfix
git checkout -b fix/descripcion-del-bug
```

**Convención de nombres de ramas:**
- `feature/nombre-feature` - Nueva funcionalidad
- `fix/descripcion-bug` - Corrección de bug
- `docs/nombre-doc` - Documentación
- `refactor/nombre-refactor` - Refactorización

### 2. Desarrollo

- Realiza commits frecuentes y descriptivos
- Escribe código limpio y legible
- Agrega comentarios cuando sea necesario
- Sigue los principios SOLID
- Mantén funciones pequeñas y enfocadas

### 3. Commits

#### Formato de Mensajes

Usa el formato Conventional Commits:

```
tipo(alcance): descripción breve

Descripción detallada si es necesario

Fixes #123
```

**Tipos:**
- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `docs`: Documentación
- `style`: Formato (sin cambios de código)
- `refactor`: Refactorización
- `test`: Tests
- `chore`: Tareas de mantenimiento

**Ejemplos:**
```
feat(nfc): agregar detección automática de pulseras BLE

Implementa escaneo continuo de dispositivos BLE cercanos
y lectura automática de identificadores únicos.

Closes #45
```

```
fix(sync): resolver conflictos en sincronización offline

Corrige el algoritmo de resolución de conflictos para
usar last-write-wins en lugar de first-write-wins.

Fixes #78
```

### 4. Testing

Antes de hacer commit, asegúrate de:

```bash
# Backend
cd backend
npm test
npm run lint

# Flutter
flutter test
flutter analyze
```

### 5. Documentación

- Actualiza README.md si agregas nuevas funcionalidades
- Documenta funciones complejas
- Agrega ejemplos de uso si es necesario
- Actualiza CHANGELOG.md para cambios significativos

---

## Testing

### Flutter Tests

**Ubicación:** `test/`

**Estructura:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:tu_app/services/student_service.dart';

void main() {
  group('StudentService', () {
    test('debe obtener estudiante por código', () async {
      // Arrange
      final service = StudentService();
      
      // Act
      final student = await service.getStudent('202012345');
      
      // Assert
      expect(student, isNotNull);
      expect(student.codigoUniversitario, equals('202012345'));
    });
  });
}
```

**Ejecutar tests:**
```bash
flutter test
flutter test --coverage
```

### Backend Tests

**Ubicación:** `backend/tests/`

**Estructura:**
```javascript
const request = require('supertest');
const app = require('../index');

describe('POST /login', () => {
  it('debe autenticar usuario válido', async () => {
    const res = await request(app)
      .post('/login')
      .send({
        email: 'test@example.com',
        password: 'password123'
      });
    
    expect(res.statusCode).toEqual(200);
    expect(res.body).toHaveProperty('id');
  });
});
```

**Ejecutar tests:**
```bash
cd backend
npm test
npm run test:watch
npm run test:coverage
```

### Cobertura Mínima

- **Backend:** 60% mínimo
- **Flutter:** 60% mínimo
- **Servicios críticos:** 80% mínimo

---

## Pull Requests

### Antes de Crear un PR

1. ✅ Todos los tests pasan
2. ✅ Código sigue los estándares
3. ✅ No hay conflictos con main
4. ✅ Documentación actualizada
5. ✅ CHANGELOG actualizado (si aplica)

### Crear un Pull Request

1. Push tu rama al repositorio:
```bash
git push origin feature/nombre-feature
```

2. Crea el PR en GitHub con:
   - **Título descriptivo** siguiendo Conventional Commits
   - **Descripción detallada** de los cambios
   - **Referencias a issues** relacionados (#123)
   - **Screenshots** si hay cambios de UI
   - **Checklist** de verificación

**Template de PR:**

```markdown
## Descripción
Breve descripción de los cambios realizados.

## Tipo de Cambio
- [ ] Bug fix
- [ ] Nueva funcionalidad
- [ ] Breaking change
- [ ] Documentación

## Cambios Realizados
- Cambio 1
- Cambio 2
- Cambio 3

## Testing
- [ ] Tests unitarios agregados/actualizados
- [ ] Tests de integración pasan
- [ ] Probado manualmente

## Screenshots (si aplica)
[Agregar screenshots]

## Checklist
- [ ] Código sigue los estándares del proyecto
- [ ] Comentarios agregados donde sea necesario
- [ ] Documentación actualizada
- [ ] No hay warnings del linter
- [ ] Tests pasan localmente
- [ ] CHANGELOG actualizado

## Issues Relacionados
Closes #123
```

### Revisión de Código

- Los PRs requieren al menos 1 aprobación
- Responde a los comentarios de revisión
- Haz los cambios solicitados
- Mantén la conversación constructiva

---

## Estructura del Proyecto

### Flutter App

```
lib/
├── config/          # Configuraciones (API endpoints, etc.)
├── models/          # Modelos de datos
├── services/         # Servicios de negocio
├── viewmodels/      # ViewModels (lógica de presentación)
├── views/           # Pantallas/Vistas
└── widgets/         # Widgets reutilizables
```

### Backend

```
backend/
├── models/          # Modelos Mongoose
├── services/         # Servicios de negocio
├── ml/              # Machine Learning
├── tests/           # Tests
└── public/          # Archivos estáticos
```

---

## Recursos Adicionales

- [Flutter Style Guide](https://flutter.dev/docs/development/ui/widgets-intro)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Node.js Best Practices](https://github.com/goldbergyoni/nodebestpractices)
- [Conventional Commits](https://www.conventionalcommits.org/)
- [Git Flow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow)

---

## Preguntas

Si tienes preguntas sobre cómo contribuir:

1. Revisa la documentación existente
2. Busca en los issues cerrados
3. Crea un nuevo issue con la etiqueta `question`

---

**Gracias por contribuir! 🎉**

