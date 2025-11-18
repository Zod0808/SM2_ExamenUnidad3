# Script de Extracción de Issues

Este script extrae información completa de todos los issues (abiertos y cerrados) del repositorio usando la API de GitHub.

## Requisitos

1. Python 3.7+
2. Librería PyGithub:
```bash
pip install PyGithub
```

3. Token de GitHub con permisos de lectura:
   - Ve a: https://github.com/settings/tokens
   - Crea un nuevo token con permisos `public_repo` o `repo` (si el repo es privado)
   - Copia el token

## Uso

### Paso 1: Configurar Token

**Windows (PowerShell):**
```powershell
$env:GITHUB_TOKEN="tu_token_aqui"
```

**Windows (CMD):**
```cmd
set GITHUB_TOKEN=tu_token_aqui
```

**Linux/Mac:**
```bash
export GITHUB_TOKEN=tu_token_aqui
```

### Paso 2: Ejecutar Script

```bash
python scripts/extract_issues.py
```

### Paso 3: Revisar Resultados

El script generará:
- `docs/ISSUES_COMPLETO.md` - Documento Markdown completo con todos los issues
- `docs/issues_data.json` - Datos en formato JSON para procesamiento adicional

## Características

El script extrae:
- ✅ Información básica (número, título, estado, URL)
- ✅ User Story
- ✅ Acceptance Criteria (con estado de completitud)
- ✅ Tasks (con estado de completitud)
- ✅ Story Points
- ✅ Estimación de tiempo
- ✅ Prioridad
- ✅ Dependencias
- ✅ Etiquetas
- ✅ Fechas de creación y cierre
- ✅ Asignados y milestones

## Ejemplo de Salida

El script genera un documento Markdown estructurado con:

```markdown
## 1. [#159] [US076] Integración de tests en CI/CD
- **Estado:** Abierto
- **URL:** https://github.com/...
- **Etiquetas:** documentation, enhancement
- **Prioridad:** Media
- **Story Points:** 3
- **Estimación:** 8-12h

### User Story
Automatizar la ejecución de pruebas...

### Acceptance Criteria
- [ ] Tests corren automáticamente...
- [ ] Falla el pipeline si...

### Tasks
- [ ] Añadir jobs de test...
```

## Solución de Problemas

### Error: "GITHUB_TOKEN no configurado"
- Asegúrate de haber configurado la variable de entorno `GITHUB_TOKEN`

### Error: "Bad credentials"
- Verifica que tu token sea válido y tenga los permisos necesarios

### Error: "Not Found"
- Verifica que el nombre del repositorio sea correcto en el script

## Personalización

Puedes modificar las siguientes variables en el script:
- `REPO_OWNER`: Propietario del repositorio
- `REPO_NAME`: Nombre del repositorio
- `output_file`: Archivo de salida Markdown
- `json_file`: Archivo de salida JSON

## Notas

- El script procesa solo issues (no pull requests)
- Los issues se ordenan por número (más recientes primero)
- Los checkboxes en Acceptance Criteria y Tasks reflejan el estado del issue (abierto/cerrado)

