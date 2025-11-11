# Instrucciones del Proyecto - Paso a Paso

## 📖 Cómo Usar Este Documento

Este documento te guía paso a paso para completar el proyecto. **Lee cada sección completamente antes de ejecutar comandos**.

---

## 🎯 Flujo de Trabajo General

Para cada uno de los 6 pasos, seguirás este proceso:

```
1. Cambiar a la rama del paso
   ↓
2. Leer la documentación técnica (PASO_X.md)
   ↓
3. Ejecutar los comandos
   ↓
4. Capturar screenshots
   ↓
5. Documentar en tu reporte
   ↓
6. Verificar que todo funciona
   ↓
7. Limpiar y pasar al siguiente paso
```

---

## 📋 PASO 1: Juice Shop Básico (30 minutos)

### Objetivo
Configurar y ejecutar OWASP Juice Shop como aplicación base.

### 1.1 Cambiar a la Rama

```bash
git checkout paso-1-juice-shop
```

### 1.2 Leer Documentación

```bash
cat PASO_1_JUICE_SHOP.md
```

### 1.3 Ejecutar Comandos

```bash
# Levantar el servicio
docker compose up -d

# Verificar que está corriendo
docker compose ps
# Debes ver: juice-shop   Up   0.0.0.0:3000->3000/tcp

# Probar conectividad
curl -I http://localhost:3000
# Debes ver: HTTP/1.1 200 OK

# Ver logs
docker compose logs juice-shop | tail -20
# Debes ver: "Server listening on port 3000"

# Generar logs de prueba
for i in {1..10}; do 
  curl -s http://localhost:3000 > /dev/null
  echo "Request $i completada"
  sleep 1
done
```

### 1.4 Capturar Screenshots (mínimo 4)

**Screenshot 1.1**: Terminal con `docker compose ps`
- Debe mostrar juice-shop en estado "Up"

**Screenshot 1.2**: Navegador en http://localhost:3000
- Debe mostrar la interfaz de Juice Shop

**Screenshot 1.3**: Terminal con `curl http://localhost:3000`
- Debe mostrar HTML de respuesta

**Screenshot 1.4**: Terminal con logs
- Debe mostrar "Server listening on port 3000"

### 1.5 Documentar

Abre `PLANTILLA_REPORTE.md` y completa la sección "Paso 1" con:
- Comandos ejecutados y sus outputs
- Screenshots capturados
- Problemas encontrados (si los hubo)
- Conceptos aprendidos

### 1.6 Verificar

- [ ] Contenedor corriendo sin errores
- [ ] Puerto 3000 accesible
- [ ] Interfaz web funcional
- [ ] Logs generándose
- [ ] 4 screenshots capturados
- [ ] Sección del reporte completada

### 1.7 Limpiar

```bash
docker compose down -v
docker compose ps  # Debe mostrar que no hay contenedores
```

---

## 📋 PASO 2: Elasticsearch (45 minutos)

### Objetivo
Agregar Elasticsearch como motor de almacenamiento de logs.

### 2.1 Cambiar a la Rama

```bash
git checkout paso-2-elasticsearch
```

### 2.2 Ver Qué Cambió

```bash
git diff paso-1-juice-shop paso-2-elasticsearch
# Verás que se agregó el servicio elasticsearch
```

### 2.3 Leer Documentación

```bash
cat PASO_2_ELASTICSEARCH.md
```

### 2.4 Ejecutar Comandos

```bash
# Levantar servicios
docker compose up -d

# Verificar servicios
docker compose ps
# Debes ver: juice-shop y elasticsearch en estado "Up"

# Esperar a que Elasticsearch inicie (30-60 segundos)
sleep 60

# Verificar salud de Elasticsearch
curl http://localhost:9200/_cluster/health?pretty
# Debes ver: "status" : "green" o "yellow"

# Ver información del nodo
curl http://localhost:9200
# Debes ver: "tagline" : "You Know, for Search"

# Crear documento de prueba
curl -X POST "http://localhost:9200/test-index/_doc" \
  -H 'Content-Type: application/json' \
  -d '{
    "message": "Test log entry",
    "timestamp": "2025-11-04T10:00:00Z"
  }'
# Debes ver: "result" : "created"

# Buscar el documento
curl "http://localhost:9200/test-index/_search?pretty"

# Ver índices creados
curl "http://localhost:9200/_cat/indices?v"
# Debes ver: test-index
```

### 2.5 Capturar Screenshots (mínimo 5)

**Screenshot 2.1**: `docker compose ps` con ambos servicios

**Screenshot 2.2**: Cluster health (JSON con status green/yellow)

**Screenshot 2.3**: Información del nodo

**Screenshot 2.4**: Documento creado exitosamente

**Screenshot 2.5**: Lista de índices

### 2.6 Verificar

- [ ] Elasticsearch corriendo y healthy
- [ ] Cluster en estado GREEN o YELLOW
- [ ] Puerto 9200 respondiendo
- [ ] Puede crear y buscar documentos
- [ ] 5 screenshots capturados
- [ ] Sección del reporte completada

### 2.7 Limpiar

```bash
docker compose down -v
```

---

## 📋 PASO 3: Kibana (45 minutos)

### Objetivo
Agregar Kibana como interfaz visual para Elasticsearch.

### 3.1 Cambiar a la Rama

```bash
git checkout paso-3-kibana
```

### 3.2 Leer Documentación

```bash
cat PASO_3_KIBANA.md
```

### 3.3 Ejecutar Comandos

```bash
# Levantar servicios
docker compose up -d

# Verificar servicios (esperar 1-2 minutos)
docker compose ps
# Debes ver: juice-shop, elasticsearch y kibana

# Verificar estado de Kibana
curl http://localhost:5601/api/status | jq .
# Debes ver: "state": "green"

# Abrir Kibana en navegador
open http://localhost:5601  # macOS
# o visitar http://localhost:5601 en tu navegador
```

### 3.4 En Kibana (Navegador)

1. Ir a: Menu (☰) → Management → Dev Tools
2. Ejecutar esta query:
   ```
   GET /
   ```
3. Debes ver información de Elasticsearch

### 3.5 Capturar Screenshots (mínimo 4)

**Screenshot 3.1**: `docker compose ps` con los 3 servicios

**Screenshot 3.2**: Pantalla de bienvenida de Kibana

**Screenshot 3.3**: Dev Tools con query GET / y respuesta

**Screenshot 3.4**: Estado de Kibana (curl)

### 3.6 Verificar

- [ ] Kibana corriendo y healthy
- [ ] Puerto 5601 accesible
- [ ] Interfaz web funcional
- [ ] Conectado a Elasticsearch
- [ ] Dev Tools funcional
- [ ] 4 screenshots capturados

### 3.7 Limpiar

```bash
docker compose down -v
```

---

## 📋 PASO 4: Filebeat - Sistema Completo (1 hora)

### Objetivo
Agregar Filebeat para conectar todo el flujo de datos.

### 4.1 Cambiar a la Rama

```bash
git checkout paso-4-filebeat
```

### 4.2 Leer Documentación

```bash
cat PASO_4_FILEBEAT.md
```

### 4.3 Ejecutar Comandos

```bash
# Levantar todos los servicios
docker compose up -d

# Verificar servicios (esperar 2-3 minutos)
docker compose ps
# Debes ver: juice-shop, elasticsearch, kibana, filebeat

# Verificar logs de Filebeat
docker compose logs filebeat | grep -i "connection"
# Debes ver: "Connection to backoff(elasticsearch) established"

# Generar tráfico en Juice Shop
for i in {1..20}; do 
  curl -s http://localhost:3000 > /dev/null
  echo "Request $i"
  sleep 1
done

# Esperar que Filebeat procese (30-60 segundos)
sleep 60

# Verificar índices de Filebeat
curl "http://localhost:9200/_cat/indices?v" | grep filebeat
# Debes ver: filebeat-juice-shop-YYYY.MM.DD

# Ver un log capturado
curl -X GET "http://localhost:9200/filebeat-juice-shop-*/_search?size=1&pretty"
# Debes ver un documento con campos: @timestamp, message, container.name
```

### 4.4 Capturar Screenshots (mínimo 5)

**Screenshot 4.1**: `docker compose ps` con los 4 servicios

**Screenshot 4.2**: Logs de Filebeat mostrando conexión

**Screenshot 4.3**: Generación de tráfico (loop de curl)

**Screenshot 4.4**: Índices filebeat-* creados

**Screenshot 4.5**: Documento de log completo (JSON)

### 4.5 Verificar

- [ ] Filebeat corriendo sin errores
- [ ] Conectado a Elasticsearch
- [ ] Índices filebeat-* creados
- [ ] Logs con metadata completa
- [ ] 5 screenshots capturados

### 4.6 NO LIMPIAR AÚN

⚠️ **IMPORTANTE**: NO ejecutes `docker compose down -v` todavía. Necesitas los datos para el Paso 5.

---

## 📋 PASO 5: Visualización en Kibana (1.5 horas)

### Objetivo
Configurar Data Views, crear visualizaciones y armar dashboards.

### 5.1 Cambiar a la Rama

```bash
git checkout paso-5-visualizacion
# NO hacer docker compose down -v
```

### 5.2 Verificar Servicios

```bash
docker compose ps
# Si no están corriendo:
docker compose up -d
```

### 5.3 Leer Documentación

```bash
cat PASO_5_VISUALIZACION_KIBANA.md
```

### 5.4 Configurar en Kibana

#### 5.4.1 Crear Data View

1. Abrir: http://localhost:5601
2. Menu (☰) → Management → Stack Management → Data Views
3. Click "Create data view"
4. Configurar:
   - **Name**: `Todos los Logs`
   - **Index pattern**: `filebeat-*`
   - **Timestamp field**: `@timestamp`
5. Click "Save data view to Kibana"

#### 5.4.2 Usar Discover

1. Menu (☰) → Analytics → Discover
2. Seleccionar "Todos los Logs"
3. Ajustar rango de tiempo: "Last 1 hour"
4. Buscar: `container.name: "juice-shop"`
5. Agregar columnas: `container.name`, `message`

#### 5.4.3 Crear Visualizaciones

**Visualización 1: Pie Chart**
1. Menu (☰) → Analytics → Visualize Library
2. Click "Create visualization"
3. Tipo: **Pie**
4. Data view: Todos los Logs
5. Slice by: `container.name.keyword`
6. Guardar como: "Distribución de Logs por Contenedor"

**Visualización 2: Line Chart**
1. Crear nueva visualización
2. Tipo: **Line**
3. Horizontal axis: `@timestamp`
4. Break down by: `container.name.keyword`
5. Guardar como: "Volumen de Logs en el Tiempo"

**Visualización 3: Metric**
1. Crear nueva visualización
2. Tipo: **Metric**
3. Metric: Count
4. Guardar como: "Total de Logs"

#### 5.4.4 Crear Dashboard

1. Menu (☰) → Analytics → Dashboard
2. Click "Create dashboard"
3. Click "Add from library"
4. Agregar las 3 visualizaciones creadas
5. Organizar el layout
6. Guardar como: "Overview de Logs del Sistema"

### 5.5 Capturar Screenshots (mínimo 12)

**Screenshot 5.1**: Creación de Data View

**Screenshot 5.2**: Discover mostrando logs

**Screenshot 5.3**: Búsqueda con KQL

**Screenshot 5.4**: Log expandido con todos los campos

**Screenshot 5.5**: Creación de Pie Chart

**Screenshot 5.6**: Pie Chart completado

**Screenshot 5.7**: Creación de Line Chart

**Screenshot 5.8**: Line Chart completado

**Screenshot 5.9**: Metric completado

**Screenshot 5.10**: Visualize Library con las 3 visualizaciones

**Screenshot 5.11**: Dashboard completo

**Screenshot 5.12**: Dev Tools con query avanzada

### 5.6 Verificar

- [ ] Data View creado
- [ ] Discover funcional
- [ ] 3 visualizaciones creadas
- [ ] Dashboard creado
- [ ] 12 screenshots capturados

### 5.7 NO LIMPIAR AÚN

⚠️ **IMPORTANTE**: NO ejecutes `docker compose down -v` todavía. Necesitas los datos para el Paso 6.

---

## 📋 PASO 6: Blue Team & Red Team (2 horas)

### Objetivo
Configurar reglas de detección y explotar vulnerabilidades.

### 6.1 Cambiar a la Rama

```bash
git checkout paso-6-blue-team
# Servicios deben seguir corriendo
```

### 6.2 Leer Documentación

```bash
cat PASO_6_BLUE_TEAM.md
cat ACTIVIDADES_RED_TEAM.md
```

### 6.3 Blue Team: Script de Tráfico Legítimo

```bash
# Ejecutar script
chmod +x scripts/blue-team-traffic.sh
./scripts/blue-team-traffic.sh
```

### 6.4 Blue Team: Configurar Reglas de Detección

En Kibana (http://localhost:5601):

#### Regla 1: SQL Injection
1. Menu (☰) → Security → Detect → Detection rules
2. Click "Create new rule"
3. Configurar:
   - **Name**: Detección SQL Injection
   - **Type**: Custom query
   - **Query**: 
     ```
     url.original:("*' or 1=1*" or "*union select*") or 
     message:("*' or 1=1*" or "*union select*")
     ```
   - **Severity**: High
   - **Risk score**: 75
4. Click "Create & enable rule"

#### Regla 2: XSS
1. Crear nueva regla
2. Configurar:
   - **Name**: Detección XSS
   - **Type**: Threshold
   - **Query**: `url.original:*"<script*" or message:*"<script*"`
   - **Threshold**: >= 1
   - **Group by**: source.ip
   - **Severity**: High
3. Crear y habilitar

#### Regla 3: Scanning/Burst
1. Crear nueva regla
2. Configurar:
   - **Name**: Detección de Scanning
   - **Type**: Threshold
   - **Query**: `http.response.status_code: (400 or 401 or 403 or 404 or 500)`
   - **Threshold**: >= 20
   - **Group by**: source.ip
   - **Time window**: 2 minutes
   - **Severity**: Medium
3. Crear y habilitar

### 6.5 Red Team: Explotar Vulnerabilidades

#### Vulnerabilidad 1: SQL Injection

```bash
# Ataque 1: SQL Injection en búsqueda
curl "http://localhost:3000/rest/products/search?q=' OR 1=1 --"

# Ataque 2: SQL Injection en login
curl -X POST http://localhost:3000/rest/user/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "'\'' OR 1=1--",
    "password": "anything"
  }'
```

#### Vulnerabilidad 2: XSS

```bash
# XSS Reflejado
curl "http://localhost:3000/rest/products/search?q=<script>alert(1)</script>"

# XSS con img tag
curl "http://localhost:3000/rest/products/search?q=<img src=x onerror=alert(1)>"
```

#### Vulnerabilidad 3: Broken Authentication

```bash
# Intentar reset de contraseña del admin
curl -X POST http://localhost:3000/rest/user/reset-password \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@juice-sh.op",
    "answer": "Daniel Boone",
    "new": "NewPassword123!",
    "repeat": "NewPassword123!"
  }'
```

#### Vulnerabilidad 4: Scanning

```bash
# Simular scanning de endpoints
for i in {1..30}; do 
  curl -s -o /dev/null -w "%{http_code}\n" "http://localhost:3000/non-existent-$i"
  sleep 0.5
done
```

### 6.6 Verificar Detecciones

1. Esperar 5 minutos para que las reglas procesen
2. Ir a: Menu (☰) → Security → Detect → Alerts
3. Debes ver alertas generadas

### 6.7 Capturar Screenshots (mínimo 12)

**Screenshot 6.1**: Script de tráfico ejecutándose

**Screenshot 6.2**: Reglas de detección configuradas

**Screenshot 6.3**: Detalle de regla SQLi

**Screenshot 6.4**: Detalle de regla XSS

**Screenshot 6.5**: Detalle de regla Scanning

**Screenshot 6.6**: Ejecución de ataque SQLi

**Screenshot 6.7**: Ejecución de ataque XSS

**Screenshot 6.8**: Ejecución de scanning

**Screenshot 6.9**: Alertas generadas en Kibana

**Screenshot 6.10**: Detalle de una alerta

**Screenshot 6.11**: Dashboard de detecciones

**Screenshot 6.12**: Logs maliciosos en Discover

### 6.8 Documentar Vulnerabilidades

Para cada vulnerabilidad, documenta en tu reporte:

1. **Descripción técnica**: Qué es y cómo funciona
2. **Pasos para reproducir**: Comandos exactos
3. **Payload utilizado**: El código/comando del ataque
4. **Impacto**: Confidencialidad, Integridad, Disponibilidad
5. **Clasificación**:
   - OWASP Top 10: (ej. A03:2021 - Injection)
   - CVSS v3.1: Calcular en https://www.first.org/cvss/calculator/3.1
6. **Screenshots**: Request y response

### 6.9 Verificar

- [ ] 3 reglas de detección configuradas
- [ ] 4 vulnerabilidades explotadas
- [ ] Alertas generadas
- [ ] Dashboard de detecciones creado
- [ ] 12 screenshots capturados
- [ ] Vulnerabilidades documentadas con CVSS

### 6.10 Limpiar

```bash
# Ahora sí, limpiar todo
docker compose down -v
```

---

## 📸 Guía de Screenshots

### Organización

Crea esta estructura de carpetas:

```
mi-proyecto-elk/
├── reporte-final.md (o .pdf)
└── screenshots/
    ├── paso-1/
    │   ├── 01-docker-compose-ps.png
    │   ├── 02-interfaz-web.png
    │   └── ...
    ├── paso-2/
    ├── paso-3/
    ├── paso-4/
    ├── paso-5/
    └── paso-6/
```

### Mejores Prácticas

1. **Nomenclatura**: `XX-descripcion-corta.png`
2. **Formato**: PNG para terminal, JPG para navegador
3. **Resolución**: Mínimo 1280x720
4. **Legibilidad**: Texto debe ser claro
5. **Contexto**: Incluye suficiente información

### Herramientas

- **macOS**: `Cmd + Shift + 4` (área) o `Cmd + Shift + 3` (completa)
- **Linux**: `gnome-screenshot` o `flameshot`
- **Windows**: `Win + Shift + S` o Snipping Tool

---

## 🔧 Problemas Comunes

### Problema 1: Puerto ya en uso

```bash
# Ver qué está usando el puerto
lsof -i :3000  # o :5601, :9200

# Detener el proceso
kill -9 <PID>

# O cambiar el puerto en docker-compose.yml
```

### Problema 2: Elasticsearch no inicia

```bash
# Ver logs
docker compose logs elasticsearch

# Si dice "max virtual memory areas too low":
sudo sysctl -w vm.max_map_count=262144

# Si es problema de memoria:
# Editar docker-compose.yml y cambiar:
# ES_JAVA_OPTS=-Xms256m -Xmx256m
```

### Problema 3: Kibana no carga

```bash
# Verificar que Elasticsearch está healthy
docker compose ps

# Esperar más tiempo (hasta 2 minutos)
docker compose logs kibana | grep "Kibana is now available"
```

### Problema 4: Filebeat no envía logs

```bash
# Verificar que corre como root
docker compose ps | grep filebeat

# Ver logs de error
docker compose logs filebeat | grep -i error

# Verificar conectividad
docker exec filebeat curl http://elasticsearch:9200
```

### Problema 5: No veo logs en Kibana

1. Verifica que Filebeat está corriendo: `docker compose ps`
2. Genera más tráfico en Juice Shop
3. Espera 30-60 segundos
4. Verifica índices: `curl http://localhost:9200/_cat/indices?v`
5. Amplía rango de tiempo en Kibana a "Last 24 hours"

---

## ✅ Checklist Final

Antes de entregar, verifica:

### Documentación
- [ ] Reporte completo con todos los pasos
- [ ] Mínimo 42 screenshots (4+5+4+5+12+12)
- [ ] Screenshots legibles y organizados
- [ ] Comandos documentados con outputs
- [ ] Problemas y soluciones explicados

### Red Team
- [ ] 4 vulnerabilidades explotadas
- [ ] Cada una con PoC reproducible
- [ ] CVSS calculado para cada una
- [ ] OWASP Top 10 clasificación
- [ ] Screenshots de cada ataque

### Blue Team
- [ ] 3 reglas de detección configuradas
- [ ] Alertas funcionando
- [ ] Dashboard de detecciones creado
- [ ] Informe de respuesta a incidentes
- [ ] Screenshots de alertas

### Archivos
- [ ] `reporte-final.md` o `.pdf`
- [ ] `screenshots/` organizado por paso
- [ ] `comandos.txt` con todos los comandos
- [ ] `reglas-deteccion.json` (exportado de Kibana)
- [ ] `dashboard-export.ndjson` (exportado de Kibana)

---

## 📚 Recursos Adicionales

- **Docker**: https://docs.docker.com/
- **Elasticsearch**: https://www.elastic.co/guide/en/elasticsearch/reference/current/
- **Kibana**: https://www.elastic.co/guide/en/kibana/current/
- **Filebeat**: https://www.elastic.co/guide/en/beats/filebeat/current/
- **OWASP Top 10**: https://owasp.org/Top10/
- **CVSS Calculator**: https://www.first.org/cvss/calculator/3.1
- **Juice Shop Solutions**: https://pwning.owasp-juice.shop/

---

## 🎯 Resumen de Tiempo

| Paso | Tiempo Estimado |
|------|----------------|
| Paso 1 | 30 minutos |
| Paso 2 | 45 minutos |
| Paso 3 | 45 minutos |
| Paso 4 | 1 hora |
| Paso 5 | 1.5 horas |
| Paso 6 | 2 horas |
| Documentación final | 1 hora |
| **TOTAL** | **~7 horas** |

---

**¡Éxito con tu proyecto!** 🚀

Recuerda: Documenta todo mientras trabajas, no dejes la documentación para el final.

---

**Versión**: 1.0  
**Fecha**: 2025-11-10
