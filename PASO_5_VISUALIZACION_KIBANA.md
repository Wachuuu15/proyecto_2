# Paso 5: Configurar Visualizaci?n en Kibana

## ?? Objetivo
Configurar Kibana para visualizar y analizar los logs recolectados, creando Data Views, b?squedas, visualizaciones y dashboards.

## ?? Relaci?n con el sistema completo

### Estado actual del flujo:
```
? Juice Shop ? ? Docker ? ? Filebeat ? ? Elasticsearch ? ? Kibana (sin configurar)
```

**Tenemos**:
- Logs gener?ndose en Juice Shop
- Filebeat recolectando y enviando
- Elasticsearch almacenando (555+ documentos)
- Kibana corriendo pero sin configuraci?n

**Nos falta**:
- Decirle a Kibana qu? ?ndices mostrar
- Crear b?squedas ?tiles
- Crear visualizaciones
- Armar dashboards

## ?? Conceptos de Kibana

### 1. **Data View** (antes Index Pattern)
- Define QU? datos de Elasticsearch mostrar
- Usa wildcards: `filebeat-*` muestra todos los ?ndices filebeat
- Necesario antes de usar Discover, Visualize o Dashboard

### 2. **Discover**
- Explorador de logs en tiempo real
- B?squeda con KQL (Kibana Query Language)
- Filtros interactivos
- Vista de tabla con campos

### 3. **Visualize**
- Crea gr?ficos individuales
- Tipos: l?neas, barras, pie, mapas, m?tricas
- Basados en agregaciones de Elasticsearch

### 4. **Dashboard**
- Combina m?ltiples visualizaciones
- Vista general del sistema
- Interactivo (filtros afectan todas las visualizaciones)

### 5. **Dev Tools**
- Consola para queries directas a Elasticsearch
- ?til para debugging
- Sintaxis JSON

## ??? Configuraci?n Paso a Paso

### PARTE 1: Crear Data View

#### 1.1 Acceder a Kibana
```
http://localhost:5601
```

**Primera vez**:
- Puede mostrar pantalla de bienvenida
- Click en "Explore on my own"
- O ir directamente al men?

#### 1.2 Navegar a Data Views
```
? Menu ? Management ? Stack Management ? Data Views
```

**Ruta completa**:
1. Click en el ?cono de men? (?) arriba a la izquierda
2. Scroll hasta "Management"
3. Click en "Stack Management"
4. En el men? lateral, bajo "Kibana", click en "Data Views"

#### 1.3 Crear Data View para todos los logs

Click en **"Create data view"**

**Configuraci?n**:
```
Name: Todos los Logs
Index pattern: filebeat-*
Timestamp field: @timestamp
```

**Explicaci?n**:
- `filebeat-*`: Incluye todos los ?ndices que empiecen con "filebeat-"
  - filebeat-docker-2025.11.04 ?
  - filebeat-juice-shop-2025.11.04 ?
  - filebeat-docker-2025.11.05 ? (ma?ana)
- `@timestamp`: Campo de tiempo para ordenar logs

Click **"Save data view to Kibana"**

#### 1.4 Crear Data View solo para Juice Shop

Click en **"Create data view"** nuevamente

**Configuraci?n**:
```
Name: Juice Shop Logs
Index pattern: filebeat-juice-shop-*
Timestamp field: @timestamp
```

**?Por qu? crear este adicional?**:
- Filtra autom?ticamente solo logs de Juice Shop
- B?squedas m?s r?pidas (menos datos)
- Visualizaciones espec?ficas de la aplicaci?n

Click **"Save data view to Kibana"**

### PARTE 2: Explorar Logs en Discover

#### 2.1 Acceder a Discover
```
? Menu ? Analytics ? Discover
```

#### 2.2 Seleccionar Data View
- En la parte superior, ver?s un dropdown con el Data View actual
- Click y selecciona "Todos los Logs"

#### 2.3 Ajustar rango de tiempo
- Esquina superior derecha: selector de tiempo
- Click en el calendario
- Selecciona "Last 1 hour" o "Last 15 minutes"
- Click "Apply"

**?Por qu? es importante?**:
- Por defecto muestra ?ltimos 15 minutos
- Si no ves logs, ampl?a el rango
- Logs m?s antiguos pueden estar en ?ndices de d?as anteriores

#### 2.4 Ver la tabla de logs

**Columnas por defecto**:
- `@timestamp`: Cu?ndo ocurri?
- `_source`: Documento completo (JSON)

**Expandir un log**:
1. Click en el s?mbolo `>` a la izquierda de un log
2. Ver?s todos los campos:
   - `message`: Mensaje del log
   - `container.name`: Nombre del contenedor
   - `container.id`: ID del contenedor
   - `host.name`: Host donde corre
   - etc.

#### 2.5 Agregar columnas ?tiles

Click en **"+ Add field"** arriba de la tabla

Agrega estos campos:
1. `container.name`
2. `message`
3. `log.level` (si existe)

**Resultado**: Tabla m?s legible con informaci?n clave

### PARTE 3: B?squedas con KQL

#### 3.1 B?squeda b?sica

En la barra de b?squeda arriba:

**Ver solo logs de Juice Shop**:
```
container.name: "juice-shop"
```

**Ver logs que contienen "error"**:
```
message: *error*
```

**Ver logs de Elasticsearch**:
```
container.name: "elasticsearch"
```

#### 3.2 B?squedas combinadas

**Errores de Juice Shop**:
```
container.name: "juice-shop" AND message: *error*
```

**Logs de Juice Shop o Kibana**:
```
container.name: ("juice-shop" OR "kibana")
```

**Excluir logs de Filebeat**:
```
NOT container.name: "filebeat"
```

#### 3.3 B?squedas por tiempo

**Logs de la ?ltima hora**:
- Usa el selector de tiempo (no KQL)

**Logs de un d?a espec?fico**:
```
@timestamp >= "2025-11-04" AND @timestamp < "2025-11-05"
```

#### 3.4 Guardar b?squeda

1. Click en "Save" arriba
2. Nombre: "Errores de Juice Shop"
3. Click "Save"

**Uso posterior**:
- Click en "Open" arriba
- Selecciona tu b?squeda guardada

### PARTE 4: Crear Visualizaciones

#### 4.1 Acceder a Visualize
```
? Menu ? Analytics ? Visualize Library
```

#### 4.2 Crear visualizaci?n: Logs por Contenedor

Click **"Create visualization"**

**Tipo**: Pie Chart (gr?fico de pastel)

**Configuraci?n**:
1. **Data view**: Selecciona "Todos los Logs"
2. **Time range**: Last 1 hour
3. **Slice by**: 
   - Click en "Add or drag-and-drop a field"
   - Selecciona `container.name.keyword`
4. **Metric**: Count (por defecto)

**Resultado**: Gr?fico circular mostrando distribuci?n de logs por contenedor

Click **"Save"**:
- T?tulo: "Distribuci?n de Logs por Contenedor"
- Click "Save and return"

#### 4.3 Crear visualizaci?n: Logs en el Tiempo

Click **"Create visualization"**

**Tipo**: Line Chart (gr?fico de l?neas)

**Configuraci?n**:
1. **Data view**: "Todos los Logs"
2. **Time range**: Last 1 hour
3. **Horizontal axis**: `@timestamp` (autom?tico)
4. **Vertical axis**: Count
5. **Break down by**: `container.name.keyword`

**Resultado**: L?neas de tiempo mostrando volumen de logs por contenedor

Click **"Save"**:
- T?tulo: "Volumen de Logs en el Tiempo"

#### 4.4 Crear visualizaci?n: Top Mensajes

Click **"Create visualization"**

**Tipo**: Table (tabla)

**Configuraci?n**:
1. **Data view**: "Juice Shop Logs"
2. **Rows**: 
   - `message.keyword`
   - Top 10 values
3. **Metric**: Count

**Resultado**: Tabla con los 10 mensajes m?s frecuentes de Juice Shop

Click **"Save"**:
- T?tulo: "Top 10 Mensajes de Juice Shop"

#### 4.5 Crear visualizaci?n: M?trica Total

Click **"Create visualization"**

**Tipo**: Metric (n?mero grande)

**Configuraci?n**:
1. **Data view**: "Todos los Logs"
2. **Metric**: Count

**Resultado**: N?mero grande mostrando total de logs

Click **"Save"**:
- T?tulo: "Total de Logs"

### PARTE 5: Crear Dashboard

#### 5.1 Acceder a Dashboards
```
? Menu ? Analytics ? Dashboard
```

#### 5.2 Crear nuevo dashboard

Click **"Create dashboard"**

#### 5.3 Agregar visualizaciones

Click **"Add from library"**

Selecciona las visualizaciones que creaste:
1. "Total de Logs"
2. "Distribuci?n de Logs por Contenedor"
3. "Volumen de Logs en el Tiempo"
4. "Top 10 Mensajes de Juice Shop"

Click **"Add"**

#### 5.4 Organizar dashboard

**Redimensionar**:
- Arrastra las esquinas de cada visualizaci?n

**Mover**:
- Arrastra desde el t?tulo

**Sugerencia de layout**:
```
???????????????????????????????????????????????
?  Total de Logs    ?  Distribuci?n (Pie)     ?
???????????????????????????????????????????????
?  Volumen en el Tiempo (Line)               ?
???????????????????????????????????????????????
?  Top 10 Mensajes (Table)                   ?
???????????????????????????????????????????????
```

#### 5.5 Guardar dashboard

Click **"Save"**:
- T?tulo: "Overview de Logs del Sistema"
- Descripci?n: "Dashboard principal mostrando logs de todos los contenedores"
- Click "Save"

### PARTE 6: Usar Dev Tools

#### 6.1 Acceder a Dev Tools
```
? Menu ? Management ? Dev Tools
```

#### 6.2 Queries ?tiles

**Ver salud de Elasticsearch**:
```json
GET /_cluster/health
```

**Ver todos los ?ndices**:
```json
GET /_cat/indices?v
```

**Buscar logs de Juice Shop**:
```json
GET /filebeat-juice-shop-*/_search
{
  "query": {
    "match": {
      "message": "GET"
    }
  },
  "size": 10
}
```

**Contar logs por contenedor**:
```json
GET /filebeat-*/_search
{
  "size": 0,
  "aggs": {
    "por_contenedor": {
      "terms": {
        "field": "container.name.keyword"
      }
    }
  }
}
```

**Logs de las ?ltimas 5 minutos**:
```json
GET /filebeat-*/_search
{
  "query": {
    "range": {
      "@timestamp": {
        "gte": "now-5m"
      }
    }
  }
}
```

## ?? Casos de Uso Pr?cticos

### Caso 1: Monitorear errores en tiempo real

**Objetivo**: Ver errores de Juice Shop inmediatamente

**Pasos**:
1. Discover ? "Juice Shop Logs"
2. B?squeda: `message: *error* OR message: *ERROR*`
3. Time range: "Last 15 minutes"
4. Habilitar auto-refresh (arriba a la derecha)
5. Selecciona "10 seconds"

**Resultado**: Tabla que se actualiza cada 10 segundos con nuevos errores

### Caso 2: Analizar tr?fico HTTP

**Objetivo**: Ver qu? endpoints se est?n usando

**Pasos**:
1. Discover ? "Juice Shop Logs"
2. B?squeda: `message: *GET* OR message: *POST*`
3. Crear visualizaci?n tipo "Data Table"
4. Extraer m?todo y ruta con regex (avanzado)

### Caso 3: Comparar volumen entre contenedores

**Objetivo**: Ver qu? contenedor genera m?s logs

**Pasos**:
1. Visualize ? Bar Chart
2. Horizontal axis: `container.name.keyword`
3. Vertical axis: Count
4. Agregar al dashboard

### Caso 4: Alertas (concepto)

**Objetivo**: Notificar cuando hay muchos errores

**Nota**: Requiere configuraci?n avanzada (Watcher/Alerting)

**Concepto**:
```
IF (count of logs with "error" in last 5 minutes) > 10
THEN send notification
```

## ?? Arquitectura Completa con Usuario

```
????????????????????????????????????????????????????????????????????
?                         USUARIO                                  ?
?                                                                  ?
?  1. Usa Juice Shop ? Genera logs                                ?
?  2. Abre Kibana ? Ve logs en tiempo real                        ?
?                                                                  ?
????????????????????????????????????????????????????????????????????
             ?                                 ?
             ? HTTP                            ? HTTP
             ?                                 ?
????????????????????????            ????????????????????????
?   Juice Shop         ?            ?   Kibana             ?
?   Puerto 3000        ?            ?   Puerto 5601        ?
?                      ?            ?                      ?
? Genera logs          ?            ? - Discover           ?
????????????????????????            ? - Visualize          ?
           ?                        ? - Dashboard          ?
           ? stdout/stderr          ? - Dev Tools          ?
           ?                        ????????????????????????
????????????????????????                      ?
?  Docker Engine       ?                      ? Queries
?  Captura logs        ?                      ?
????????????????????????                      ?
           ?                                  ?
           ? Archivos .log                    ?
           ?                                  ?
????????????????????????                      ?
?   Filebeat           ?                      ?
?   Recolecta          ?                      ?
?   Procesa            ?                      ?
?   Enriquece          ?                      ?
????????????????????????                      ?
           ?                                  ?
           ? HTTP POST (JSON)                 ?
           ?                                  ?
????????????????????????                      ?
?   Elasticsearch      ????????????????????????
?   Puerto 9200        ?
?                      ?
? - Indexa             ?
? - Almacena           ?
? - Busca              ?
? - Agrega             ?
????????????????????????
           ?
           ?
????????????????????????
?  Volumen             ?
?  Persistencia        ?
????????????????????????
```

## ? Verificaci?n

### Checklist de configuraci?n:

- [ ] Data View "Todos los Logs" creado
- [ ] Data View "Juice Shop Logs" creado
- [ ] Discover muestra logs correctamente
- [ ] Al menos 3 visualizaciones creadas
- [ ] Dashboard creado y funcional
- [ ] Dev Tools probado con queries

### Verificar que todo funciona:

**1. Generar logs**:
```bash
for i in {1..20}; do
  curl -s http://localhost:3000 > /dev/null
  echo "Request $i"
  sleep 1
done
```

**2. Ver en Kibana**:
- Discover ? Deber?as ver nuevos logs apareciendo
- Dashboard ? N?meros deber?an aumentar

**3. Probar filtros**:
- Busca: `container.name: "juice-shop"`
- Deber?as ver solo logs de Juice Shop

## ?? Conceptos Avanzados

### 1. **KQL vs Lucene**
- **KQL**: M?s simple, recomendado
  ```
  container.name: "juice-shop"
  ```
- **Lucene**: M?s potente, sintaxis compleja
  ```
  container.name:"juice-shop" AND message:/error.*/
  ```

### 2. **Aggregations**
- Operaciones sobre conjuntos de datos
- Ejemplos:
  - Count: Contar documentos
  - Average: Promedio de un campo
  - Terms: Agrupar por valores ?nicos
  - Date Histogram: Agrupar por tiempo

### 3. **Field Types**
- **keyword**: Texto exacto (para filtros)
- **text**: Texto analizado (para b?squeda full-text)
- **date**: Fechas
- **long**: N?meros enteros
- **float**: N?meros decimales

### 4. **Time Series**
- Datos ordenados por tiempo
- ?ndices diarios (`filebeat-2025.11.04`)
- Facilita:
  - B?squedas por rango de tiempo
  - Eliminaci?n de datos antiguos
  - Optimizaci?n de queries

## ?? Troubleshooting

### Problema: No veo logs en Discover

**Posibles causas**:
1. **Rango de tiempo incorrecto**
   - Soluci?n: Ampl?a a "Last 24 hours"
2. **Data View incorrecto**
   - Soluci?n: Verifica que seleccionaste el correcto
3. **No hay datos**
   - Soluci?n: Verifica ?ndices en Dev Tools
   ```
   GET /_cat/indices?v
   ```

### Problema: "No results match your search criteria"

**Soluci?n**:
1. Elimina todos los filtros
2. Cambia rango de tiempo a "Last 7 days"
3. Verifica que el Data View incluye los ?ndices correctos

### Problema: Visualizaci?n vac?a

**Posibles causas**:
1. **Campo no existe**
   - Soluci?n: Verifica en Discover que el campo existe
2. **Filtro muy restrictivo**
   - Soluci?n: Elimina filtros temporalmente
3. **Datos fuera del rango de tiempo**
   - Soluci?n: Ampl?a rango de tiempo

### Problema: Dashboard lento

**Soluciones**:
1. Reduce rango de tiempo
2. Usa filtros para limitar datos
3. Reduce n?mero de visualizaciones
4. Usa ?ndices espec?ficos (no `*`)

## ?? Pr?ximos Pasos (Opcional)

### Mejoras adicionales:

1. **Alertas**:
   - Configurar Watcher/Alerting
   - Notificaciones por email/Slack
   - Alertas por umbral de errores

2. **Machine Learning**:
   - Detecci?n de anomal?as
   - Predicci?n de tendencias
   - Alertas inteligentes

3. **Seguridad**:
   - Habilitar autenticaci?n
   - Roles y permisos
   - Audit logs

4. **Optimizaci?n**:
   - ILM (Index Lifecycle Management)
   - Snapshots autom?ticos
   - Pol?ticas de retenci?n

5. **Integraci?n**:
   - M?tricas con Metricbeat
   - APM para tracing
   - Uptime monitoring

## ?? Resumen

? **Logrado**:
- Data Views configurados
- Discover funcional para explorar logs
- Visualizaciones creadas
- Dashboard armado
- Dev Tools probado

? **Aprendido**:
- C?mo navegar Kibana
- KQL para b?squedas
- Crear visualizaciones
- Armar dashboards
- Usar Dev Tools

? **Sistema Completo**:
```
Juice Shop ? Docker ? Filebeat ? Elasticsearch ? Kibana ? Usuario
   ?         ?        ?           ?             ?        ?
```

**El sistema ELK est? 100% funcional y configurado** ??

## ?? Resultado Final

Ahora tienes:
- ? Logs recolect?ndose autom?ticamente
- ? Almacenamiento centralizado en Elasticsearch
- ? Visualizaci?n en tiempo real en Kibana
- ? Dashboards para monitoreo
- ? Herramientas para an?lisis y debugging

**?Tu sistema de logging profesional est? completo!**
