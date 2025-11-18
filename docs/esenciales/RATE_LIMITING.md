# 🛡️ Rate Limiting - Protección de API

**Sistema de Control de Acceso - MovilesII**  
**Fecha de implementación:** 18 de Noviembre 2025

---

## 📋 Resumen

Sistema de rate limiting implementado para proteger la API contra abuso, ataques DDoS y fuerza bruta.

---

## 🎯 Objetivos

- ✅ Proteger contra ataques DDoS
- ✅ Prevenir brute force en login
- ✅ Limitar operaciones de escritura
- ✅ Controlar acceso a endpoints de auditoría
- ✅ Mejorar seguridad general de la API

---

## 🔧 Configuración

### Rate Limiters Implementados

#### 1. General Limiter
**Aplicado a:** Todas las rutas  
**Límite:** 100 requests por IP en 15 minutos  
**Headers:** `RateLimit-*` estándar

```javascript
windowMs: 15 * 60 * 1000  // 15 minutos
max: 100                  // 100 requests
```

#### 2. Login Limiter
**Aplicado a:** `/login`  
**Límite:** 5 intentos por IP en 15 minutos  
**Características:**
- No cuenta requests exitosos
- Previene brute force attacks

```javascript
windowMs: 15 * 60 * 1000  // 15 minutos
max: 5                    // 5 intentos
skipSuccessfulRequests: true
```

#### 3. Write Limiter
**Aplicado a:** Endpoints POST, PUT, DELETE  
**Límite:** 30 operaciones por IP por minuto

```javascript
windowMs: 1 * 60 * 1000   // 1 minuto
max: 30                   // 30 operaciones
```

#### 4. Read Limiter
**Aplicado a:** Endpoints de lectura pesada (reportes, búsquedas)  
**Límite:** 60 requests por IP por minuto

```javascript
windowMs: 1 * 60 * 1000   // 1 minuto
max: 60                   // 60 requests
```

#### 5. Audit Limiter
**Aplicado a:** Endpoints de auditoría (`/api/audit/*`)  
**Límite:** 20 requests por IP en 5 minutos

```javascript
windowMs: 5 * 60 * 1000    // 5 minutos
max: 20                   // 20 requests
```

---

## 📊 Headers de Respuesta

Cuando se aplica rate limiting, la respuesta incluye headers estándar:

```
RateLimit-Limit: 100
RateLimit-Remaining: 95
RateLimit-Reset: 1637251200
```

---

## ⚠️ Respuestas de Error

Cuando se excede el límite, se retorna:

```json
{
  "error": "Demasiadas solicitudes desde esta IP, por favor intenta de nuevo más tarde.",
  "retryAfter": "15 minutos",
  "limit": 100,
  "windowMs": "15 minutos"
}
```

**Status Code:** `429 Too Many Requests`

---

## 🔒 Endpoints Protegidos

### Login
- `/login` - Login limiter (5 intentos/15min)

### Escritura
- `/puntos-control` (POST, PUT, DELETE)
- `/usuarios` (POST, PUT)
- `/asistencias` (POST)
- `/asignaciones` (POST, PUT)
- `/decisiones-manuales` (POST)
- `/presencia` (POST)
- `/sesiones/*` (POST)

### Auditoría
- `/api/audit/history`
- `/api/audit/search`
- `/api/audit/dashboard`
- `/api/audit/export`
- `/api/audit/suspicious`
- `/api/audit/traceability/*`

---

## 🧪 Testing

### Verificar Rate Limiting

```bash
# Hacer múltiples requests rápidas
for i in {1..6}; do
  curl -X POST http://localhost:3000/login \
    -H "Content-Type: application/json" \
    -d '{"email":"test@test.com","password":"wrong"}'
done
```

Después del 5to intento, debería retornar `429 Too Many Requests`.

---

## 📝 Configuración Avanzada

### Variables de Entorno

Puedes configurar los límites mediante variables de entorno:

```env
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX=100
RATE_LIMIT_LOGIN_MAX=5
RATE_LIMIT_WRITE_MAX=30
```

### Almacenamiento

Por defecto, `express-rate-limit` usa almacenamiento en memoria. Para producción, considera usar Redis:

```javascript
const RedisStore = require('rate-limit-redis');
const redis = require('redis');

const client = redis.createClient({
  host: process.env.REDIS_HOST,
  port: process.env.REDIS_PORT
});

const limiter = rateLimit({
  store: new RedisStore({
    client: client
  }),
  // ... configuración
});
```

---

## 🚀 Mejoras Futuras

1. **Redis Storage:** Para rate limiting distribuido
2. **Whitelist:** IPs confiables sin límites
3. **Dynamic Limits:** Ajustar límites según carga
4. **Metrics:** Monitoreo de rate limit hits
5. **User-based Limiting:** Límites por usuario además de IP

---

**Última actualización:** 18 de Noviembre 2025

