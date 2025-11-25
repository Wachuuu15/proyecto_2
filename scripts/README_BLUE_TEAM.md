# 🛡️ Blue Team - Sistema de Defensa y Detección

Este documento explica cómo funciona el sistema completo de Blue Team, desde la generación de tráfico legítimo hasta las reglas de detección de amenazas.

---

## 📋 Tabla de Contenidos

1. [Visión General del Sistema](#visión-general-del-sistema)
2. [1. Tareas Programadas (Scheduled Tasks)](#1-tareas-programadas-scheduled-tasks)
3. [2. Pipeline de Ingest en Elasticsearch](#2-pipeline-de-ingest-en-elasticsearch)
4. [3. Reglas de Detección en Kibana](#3-reglas-de-detección-en-kibana)
5. [4. Flujo Completo de Datos](#4-flujo-completo-de-datos)
6. [5. Scripts Disponibles](#5-scripts-disponibles)
7. [6. Verificación y Troubleshooting](#6-verificación-y-troubleshooting)

---

## 🎯 Visión General del Sistema

El sistema Blue Team está diseñado para:

1. **Generar tráfico legítimo** periódicamente para establecer un baseline
2. **Procesar logs** mediante pipelines de ingest que detectan patrones de amenazas
3. **Detectar ataques** automáticamente usando reglas de detección en Kibana
4. **Alertar** sobre actividades sospechosas en tiempo real

```
┌─────────────────┐
│  Blue Team      │  Genera tráfico legítimo cada 15 min
│  Traffic Gen    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Juice Shop     │  Aplicación web vulnerable
│  (puerto 8080)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Nginx Proxy    │  Reverse proxy con logging ampliado
│  (puerto 8080)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Filebeat       │  Recolecta logs de Docker y Nginx
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Elasticsearch  │  Pipeline de ingest detecta amenazas
│  (puerto 9200)  │  y enriquece logs con threat.indicator
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Kibana         │  Reglas de detección generan alertas
│  (puerto 5601)  │  cuando detectan patrones sospechosos
└─────────────────┘
```

---

## 1. Tareas Programadas (Scheduled Tasks)

### 1.1 ¿Qué son?

Las tareas programadas ejecutan automáticamente el script `blue-team-traffic.ps1` cada 15 minutos para generar tráfico legítimo que establece un baseline en Kibana.

### 1.2 Configuración en Windows

**Ejecutar como Administrador:**

```powershell
.\scripts\setup-scheduled-task.ps1
```

Esto crea una tarea en Windows Task Scheduler llamada `BlueTeamTrafficGenerator` que:
- Se ejecuta cada 15 minutos
- Funciona incluso cuando el usuario no está conectado
- Genera tráfico legítimo a endpoints específicos de Juice Shop

### 1.3 Gestión de la Tarea

**Ver estado:**
```powershell
Get-ScheduledTask -TaskName "BlueTeamTrafficGenerator"
```

**Ejecutar manualmente ahora:**
```powershell
Start-ScheduledTask -TaskName "BlueTeamTrafficGenerator"
```

**Deshabilitar temporalmente:**
```powershell
Disable-ScheduledTask -TaskName "BlueTeamTrafficGenerator"
```

**Eliminar la tarea:**
```powershell
Unregister-ScheduledTask -TaskName "BlueTeamTrafficGenerator" -Confirm:$false
```

### 1.4 Endpoints Generados

El script genera tráfico legítimo a estos endpoints:

- `http://localhost:8080` - Página principal (a través de Nginx)
- `http://localhost:8080/#/login` - Página de login
- `http://localhost:8080/rest/products/search?q=apple` - Búsqueda de productos
- `http://localhost:8080/rest/products/search?q=juce` - Búsqueda alternativa
- `http://localhost:8080/api/Products` - API de productos
- `http://localhost:8080/rest/user/login` - Endpoint de login

**Nota:** El script usa el puerto `8080` (Nginx proxy) en lugar de `3000` directamente.

### 1.5 Logs Generados

Los logs se guardan en: `scripts/logs/juice-blue-team.log`

Formato de log:
```
2025-11-24 10:22:30 UTC - === INICIO Ejecución Blue Team Traffic ===
2025-11-24 10:22:30 UTC - OK - HTTP 200 - http://localhost:8080
2025-11-24 10:22:35 UTC - OK - HTTP 200 - http://localhost:8080/#/login
...
2025-11-24 10:22:48 UTC - === FIN Ejecución Blue Team Traffic ===
```

---

## 2. Pipeline de Ingest en Elasticsearch

### 2.1 ¿Qué es?

El pipeline de ingest `juice-threat-normalizer` procesa los logs **antes** de que se indexen en Elasticsearch. Detecta patrones de amenazas y enriquece los logs con el campo `threat.indicator.type`.

### 2.2 Configuración

**Ejecutar el script de configuración:**

```powershell
.\scripts\setup-ingest-pipeline.ps1
```

**Credenciales:**
- **Usuario:** `elastic`
- **Contraseña:** `changeme`
- **URL:** `http://localhost:9200`

### 2.3 ¿Qué detecta el pipeline?

El pipeline detecta tres tipos de amenazas:

#### 2.3.1 SQL Injection
Patrones detectados:
- `union select`
- ` or 1=1`
- `'' or`
- `--` (comentarios SQL)
- `sleep(`
- `benchmark(`

Campo agregado: `threat.indicator.type: "sql-injection"`

#### 2.3.2 Cross-Site Scripting (XSS)
Patrones detectados:
- `<script`
- `onerror=`
- `<img`
- `<svg`
- `javascript:`

Campo agregado: `threat.indicator.type: "xss"`

#### 2.3.3 Local File Inclusion (LFI)
Patrones detectados:
- `../../`
- `/bin/`
- `cat /etc/passwd`

Campo agregado: `threat.indicator.type: "lfi"`

### 2.4 Verificación

**Verificar que el pipeline existe:**
```powershell
curl -u elastic:changeme "http://localhost:9200/_ingest/pipeline/juice-threat-normalizer"
```

**Probar el pipeline manualmente:**
```powershell
$testDoc = @{
    url = @{
        original = "http://localhost:8080/rest/products/search?q=' OR 1=1 --"
    }
} | ConvertTo-Json

curl -u elastic:changeme -X POST "http://localhost:9200/_ingest/pipeline/juice-threat-normalizer/_simulate" `
    -H "Content-Type: application/json" `
    -d "{`"docs`":[$testDoc]}"
```

### 2.5 Integración con Filebeat

El pipeline se aplica automáticamente a todos los logs que Filebeat envía a Elasticsearch. Ver `filebeat.yml`:

```yaml
output.elasticsearch:
  hosts: ["${ELASTICSEARCH_HOSTS:elasticsearch:9200}"]
  username: "${ELASTICSEARCH_USERNAME:elastic}"
  password: "${ELASTICSEARCH_PASSWORD:changeme}"
  pipeline: "juice-threat-normalizer"  # ← Pipeline aplicado aquí
```

---

## 3. Reglas de Detección en Kibana

### 3.1 ¿Qué son?

Las reglas de detección en Kibana (Elastic Security) monitorean los logs indexados y generan alertas cuando detectan patrones sospechosos.

### 3.2 Configuración

**Ejecutar el script de configuración:**

```powershell
.\scripts\setup-detection-rules-fixed.ps1
```

**Credenciales:**
- **Usuario:** `elastic`
- **Contraseña:** `changeme`
- **URL:** `http://localhost:5601`

### 3.3 Reglas Configuradas

#### 3.3.1 Regla 1: SQL Injection
- **Nombre:** `Deteccion SQL Injection - Juice Shop`
- **Tipo:** Query (búsqueda en logs)
- **Severidad:** High
- **Risk Score:** 75
- **Intervalo:** Cada 5 minutos
- **Ventana de tiempo:** Últimos 15 minutos

**Query KQL:**
```kql
url.original:("*' or 1=1*" OR "*union select*" OR "*sleep(*" OR "*benchmark(*") OR
query:("*' or 1=1*" OR "*union select*" OR "*sleep(*" OR "*benchmark(*") OR
message:("*' or 1=1*" OR "*union select*" OR "*sleep(*" OR "*benchmark(*") OR
threat.indicator.type: "sql-injection"
```

**Índices monitoreados:**
- `filebeat-juice-shop-*`
- `filebeat-nginx-*`
- `filebeat-docker-*`

#### 3.3.2 Regla 2: Cross-Site Scripting (XSS)
- **Nombre:** `Deteccion Cross-Site Scripting (XSS) - Juice Shop`
- **Tipo:** Threshold (umbral de eventos)
- **Severidad:** High
- **Risk Score:** 65
- **Intervalo:** Cada 5 minutos
- **Ventana de tiempo:** Últimos 15 minutos

**Query KQL:**
```kql
(url.original:*"<script*" OR url.original:*"onerror=" OR url.original:*"javascript:" OR
http.request.body.content:*"<img*" OR message.keyword:*"<svg*" OR threat.indicator.type: "xss")
```

**Threshold:**
- **Campo:** `source.ip`
- **Valor:** 1 (alerta si hay al menos 1 evento por IP)

#### 3.3.3 Regla 3: Scanning/Burst
- **Nombre:** `Deteccion de Scanning/Burst - Juice Shop`
- **Tipo:** Threshold (umbral de eventos)
- **Severidad:** Medium
- **Risk Score:** 50
- **Intervalo:** Cada 5 minutos
- **Ventana de tiempo:** Últimos 15 minutos

**Query KQL:**
```kql
http.response.status_code: (400 OR 401 OR 403 OR 404 OR 500 OR 503)
```

**Threshold:**
- **Campo:** `source.ip`
- **Valor:** 20 (alerta si hay 20+ errores HTTP por IP en 2 minutos)

### 3.4 Verificación en Kibana

1. **Abrir Kibana:** `http://localhost:5601`
2. **Login:** `elastic` / `changeme`
3. **Ir a:** Security → Detect → Detection rules
4. **Verificar:** Las 3 reglas deben estar listadas y habilitadas

### 3.5 Ver Alertas Generadas

1. **Ir a:** Security → Detect → Detections
2. **Filtrar por:** Regla específica o todas las alertas
3. **Revisar:** Detalles de cada alerta (timestamp, IP, query, etc.)

---

## 4. Flujo Completo de Datos

### 4.1 Flujo Normal (Tráfico Legítimo)

```
1. Blue Team Traffic Generator
   └─> Ejecuta cada 15 minutos
   └─> Genera requests a http://localhost:8080
   └─> Escribe logs en scripts/logs/juice-blue-team.log

2. Juice Shop (puerto 3000 interno)
   └─> Procesa requests legítimos
   └─> Genera logs de aplicación

3. Nginx Proxy (puerto 8080)
   └─> Proxy reverso para Juice Shop
   └─> Escribe logs en /var/log/nginx/juice_access.log

4. Filebeat
   └─> Recolecta logs de:
       - Docker containers (juice-shop, nginx)
       - scripts/logs/juice-blue-team.log
       - /var/log/nginx/*.log
   └─> Envía a Elasticsearch con pipeline "juice-threat-normalizer"

5. Elasticsearch
   └─> Pipeline procesa logs
   └─> NO detecta amenazas (tráfico legítimo)
   └─> Indexa en índices filebeat-*

6. Kibana
   └─> Reglas de detección evalúan logs
   └─> NO generan alertas (tráfico legítimo)
```

### 4.2 Flujo de Ataque (Tráfico Malicioso)

```
1. Red Team / Atacante
   └─> Ejecuta script de ataques: .\scripts\test-attacks-simple.ps1
   └─> Genera requests maliciosos a http://localhost:8080
   └─> Ejemplos:
       - SQL Injection: /rest/products/search?q=' OR 1=1 --
       - XSS: /rest/products/search?q=<script>alert(1)</script>
       - Scanning: Múltiples requests a endpoints inexistentes

2. Juice Shop
   └─> Procesa requests (puede ser vulnerable)
   └─> Genera logs con URLs/querys maliciosas

3. Nginx Proxy
   └─> Registra requests en access.log
   └─> Incluye URLs completas con payloads maliciosos

4. Filebeat
   └─> Recolecta logs con contenido malicioso
   └─> Envía a Elasticsearch con pipeline

5. Elasticsearch - Pipeline de Ingest
   └─> Detecta patrones de amenazas:
       - SQL Injection → threat.indicator.type: "sql-injection"
       - XSS → threat.indicator.type: "xss"
       - LFI → threat.indicator.type: "lfi"
   └─> Enriquece logs con campos de amenaza
   └─> Indexa en índices filebeat-*

6. Kibana - Reglas de Detección
   └─> Regla SQL Injection:
       - Detecta threat.indicator.type: "sql-injection"
       - Detecta patrones en url.original, query, message
       - Genera alerta de severidad HIGH
   └─> Regla XSS:
       - Detecta threat.indicator.type: "xss"
       - Detecta patrones en URL y body
       - Genera alerta de severidad HIGH
   └─> Regla Scanning/Burst:
       - Detecta múltiples errores HTTP (4xx/5xx)
       - Genera alerta de severidad MEDIUM

7. Security → Detections
   └─> Muestra alertas generadas
   └─> Incluye detalles: timestamp, IP, query, tipo de amenaza
```

---

## 5. Scripts Disponibles

### 5.1 Generación de Tráfico

| Script | Descripción | Uso |
|--------|-------------|-----|
| `blue-team-traffic.ps1` | Genera tráfico legítimo | Ejecución manual o automática |
| `setup-scheduled-task.ps1` | Configura tarea programada en Windows | Ejecutar como Administrador |

### 5.2 Configuración del Sistema

| Script | Descripción | Uso |
|--------|-------------|-----|
| `setup-ingest-pipeline.ps1` | Crea pipeline de ingest en Elasticsearch | Ejecutar una vez después de iniciar Elasticsearch |
| `setup-detection-rules-fixed.ps1` | Crea reglas de detección en Kibana | Ejecutar una vez después de iniciar Kibana |
| `create-kibana-service-account.ps1` | Genera service account token para Kibana | Ejecutar si se necesita regenerar el token |

### 5.3 Pruebas

| Script | Descripción | Uso |
|--------|-------------|-----|
| `test-attacks-simple.ps1` | Simula ataques (SQLi, XSS, Scanning) | Ejecutar para probar las reglas de detección |

---

## 6. Verificación y Troubleshooting

### 6.1 Verificar Tarea Programada

```powershell
# Ver estado
Get-ScheduledTask -TaskName "BlueTeamTrafficGenerator"

# Ver última ejecución
Get-ScheduledTaskInfo -TaskName "BlueTeamTrafficGenerator"
```

### 6.2 Verificar Pipeline de Ingest

```powershell
# Verificar que existe
curl -u elastic:changeme "http://localhost:9200/_ingest/pipeline/juice-threat-normalizer"

# Probar con un documento de prueba
$testDoc = @{
    url = @{
        original = "http://localhost:8080/rest/products/search?q=' OR 1=1 --"
    }
} | ConvertTo-Json

curl -u elastic:changeme -X POST "http://localhost:9200/_ingest/pipeline/juice-threat-normalizer/_simulate" `
    -H "Content-Type: application/json" `
    -d "{`"docs`":[$testDoc]}"
```

### 6.3 Verificar Reglas de Detección

```powershell
# Listar todas las reglas
$credential = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("elastic:changeme"))
$headers = @{
    "Authorization" = "Basic $credential"
    "kbn-xsrf" = "true"
}
Invoke-RestMethod -Uri "http://localhost:5601/api/detection_engine/rules/_find?per_page=1000" `
    -Method Get -Headers $headers | ConvertTo-Json -Depth 5
```

### 6.4 Verificar Logs en Kibana

1. **Abrir Kibana:** `http://localhost:5601`
2. **Ir a:** Discover
3. **Buscar:** `threat.indicator.type: "sql-injection"` o `threat.indicator.type: "xss"`
4. **Verificar:** Logs con campos de amenaza enriquecidos

### 6.5 Verificar Alertas Generadas

1. **Abrir Kibana:** `http://localhost:5601`
2. **Ir a:** Security → Detect → Detections
3. **Filtrar por:**
   - Regla específica
   - Rango de tiempo
   - Severidad

### 6.6 Problemas Comunes

#### Problema: La tarea programada no se ejecuta

**Solución:**
```powershell
# Verificar que la tarea existe y está habilitada
Get-ScheduledTask -TaskName "BlueTeamTrafficGenerator"

# Ejecutar manualmente para probar
Start-ScheduledTask -TaskName "BlueTeamTrafficGenerator"

# Ver logs del script
Get-Content .\scripts\logs\juice-blue-team.log -Tail 50
```

#### Problema: El pipeline no detecta amenazas

**Solución:**
1. Verificar que el pipeline existe en Elasticsearch
2. Verificar que Filebeat está usando el pipeline (ver `filebeat.yml`)
3. Verificar que los logs contienen los campos esperados (`url.original`, `message`, `query`)

#### Problema: Las reglas no generan alertas

**Solución:**
1. Verificar que las reglas están habilitadas en Kibana
2. Verificar que los índices monitoreados existen y tienen datos
3. Ejecutar el script de pruebas: `.\scripts\test-attacks-simple.ps1`
4. Esperar 5-10 minutos para que las reglas evalúen los logs
5. Revisar Security → Detect → Detections

#### Problema: Filebeat no envía logs

**Solución:**
```powershell
# Ver logs de Filebeat
docker logs filebeat --tail 50

# Verificar que Filebeat puede conectarse a Elasticsearch
docker exec filebeat curl -u elastic:changeme http://elasticsearch:9200/_cluster/health
```

---

## 📌 Notas Importantes

- **Credenciales por defecto:**
  - Elasticsearch/Kibana: `elastic` / `changeme`
  - **IMPORTANTE:** Cambiar en producción

- **Puertos:**
  - Juice Shop (interno): `3000`
  - Nginx Proxy: `8080`
  - Elasticsearch: `9200`
  - Kibana: `5601`

- **Persistencia:**
  - Los datos de Elasticsearch se guardan en el volumen `elasticsearch-data`
  - Las reglas de detección se guardan en Kibana (requieren clave de encriptación configurada)

- **Rendimiento:**
  - Las reglas se ejecutan cada 5 minutos
  - Puede haber un retraso de 5-10 minutos entre un ataque y la generación de la alerta

---

## 🔗 Referencias

- **Documentación principal:** `PASO_6_BLUE_TEAM.md`
- **Configuración de Filebeat:** `filebeat.yml`
- **Configuración de Docker:** `docker-compose.yml`
- **Configuración de Kibana:** `kibana.yml`

---

**Última actualización:** 2025-11-24
