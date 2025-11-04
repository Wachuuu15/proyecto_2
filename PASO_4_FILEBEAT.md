# Paso 4: Agregar Filebeat - El Conector Cr?tico

## ?? Objetivo
Implementar Filebeat como recolector de logs que conecta Juice Shop con Elasticsearch, completando el flujo de datos del sistema ELK.

## ?? Relaci?n con TODOS los pasos anteriores

### El problema que resolvemos:

**Hasta ahora tenemos**:
```
PASO 1: Juice Shop          PASO 2: Elasticsearch       PASO 3: Kibana
???????????????              ????????????????           ????????????????
? Juice Shop  ?              ?              ?           ?              ?
?             ?              ? Elasticsearch?????????????   Kibana     ?
? Logs en     ?      ?      ?              ?           ?              ?
? archivos    ?   NO HAY     ? Vac?o        ?           ? Sin datos    ?
?             ?   CONEXI?N   ?              ?           ? para mostrar ?
???????????????              ????????????????           ????????????????
```

**El flujo COMPLETO con Filebeat**:
```
PASO 1              PASO 4 (NUEVO)        PASO 2              PASO 3
????????????        ????????????        ????????????        ????????????
?  Juice   ?        ?          ?        ?          ?        ?          ?
?  Shop    ?????????? Filebeat ??????????Elastics- ??????????  Kibana  ?
?          ?  logs  ?          ?  JSON  ?  earch   ? query  ?          ?
? Genera   ?        ? Lee      ?        ? Almacena ?        ? Muestra  ?
? logs     ?        ? Procesa  ?        ? Indexa   ?        ? Visualiza?
????????????        ????????????        ????????????        ????????????
    ?                    ?                    ?                   ?
    ?                    ?                    ?                   ?
    ?                    ?                    ?                   ?
Archivos            Monitorea            ?ndices             Usuario
.log en             archivos             con datos           ve logs
contenedor          Docker               estructurados       en tiempo
                                                             real
```

## ?? ?Qu? es Filebeat?

**Filebeat** es un "shipper" (transportador) ligero de logs, parte de la familia Beats de Elastic.

### Familia Beats:
- **Filebeat**: Logs de archivos
- **Metricbeat**: M?tricas del sistema (CPU, RAM)
- **Packetbeat**: Tr?fico de red
- **Heartbeat**: Monitoreo de disponibilidad
- **Auditbeat**: Auditor?a de seguridad

### ?Por qu? Filebeat espec?ficamente?

1. **Ligero**: Consume pocos recursos (~10-50MB RAM)
2. **Confiable**: No pierde datos si Elasticsearch cae
3. **Espec?fico para logs**: Optimizado para leer archivos de texto
4. **Integrado**: Dise?ado para trabajar con Elasticsearch

## ?? ?C?mo funciona Filebeat?

### Arquitectura interna:

```
???????????????????????????????????????????????????????????
?                    FILEBEAT                             ?
?                                                         ?
?  ???????????????      ????????????????                ?
?  ?   Inputs    ????????  Processors  ?                ?
?  ?             ?      ?              ?                ?
?  ? - Container ?      ? - Parse JSON ?                ?
?  ? - Log       ?      ? - Add fields ?                ?
?  ? - Syslog    ?      ? - Filter     ?                ?
?  ???????????????      ????????????????                ?
?                              ?                         ?
?                              ?                         ?
?                       ????????????????                ?
?                       ?   Output     ?                ?
?                       ?              ?                ?
?                       ? Elasticsearch?                ?
?                       ? Logstash     ?                ?
?                       ? Kafka        ?                ?
?                       ????????????????                ?
???????????????????????????????????????????????????????????
```

### Proceso paso a paso:

1. **Input lee archivos**:
   ```
   /var/lib/docker/containers/abc123.../abc123...-json.log
   ```

2. **Parser extrae informaci?n**:
   ```json
   {
     "log": "GET /api/Products 200 45ms\n",
     "stream": "stdout",
     "time": "2025-11-04T10:30:00Z"
   }
   ```

3. **Processors enriquecen**:
   ```json
   {
     "message": "GET /api/Products 200 45ms",
     "@timestamp": "2025-11-04T10:30:00Z",
     "container": {
       "name": "juice-shop",
       "id": "abc123..."
     },
     "host": {
       "name": "docker-host"
     }
   }
   ```

4. **Output env?a a Elasticsearch**:
   ```
   POST http://elasticsearch:9200/filebeat-logs/_doc
   ```

## ?? Componentes Implementados

### 1. Servicio en docker-compose.yml

```yaml
filebeat:
  image: docker.elastic.co/beats/filebeat:8.11.0
  container_name: filebeat
  user: root
  volumes:
    - ./filebeat.yml:/usr/share/filebeat/filebeat.yml:ro
    - /var/lib/docker/containers:/var/lib/docker/containers:ro
    - /var/run/docker.sock:/var/run/docker.sock:ro
    - filebeat-data:/usr/share/filebeat/data
  environment:
    - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    - KIBANA_HOST=http://kibana:5601
  networks:
    - elk-network
  depends_on:
    elasticsearch:
      condition: service_healthy
  restart: unless-stopped
  command: filebeat -e -strict.perms=false
```

#### Explicaci?n l?nea por l?nea:

**`user: root`**
```yaml
user: root
```
**?Por qu? root?**:
- Necesita leer archivos de Docker en `/var/lib/docker/containers`
- Estos archivos pertenecen a root
- Sin root: "Permission denied"

**?? Nota de seguridad**: En producci?n, usar permisos m?s restrictivos.

**`volumes` - Los 4 montajes cr?ticos**:

1. **Configuraci?n de Filebeat**:
```yaml
- ./filebeat.yml:/usr/share/filebeat/filebeat.yml:ro
```
- Monta nuestro archivo de configuraci?n
- `:ro` = read-only (solo lectura)
- Filebeat lee este archivo al iniciar

2. **Logs de Docker**:
```yaml
- /var/lib/docker/containers:/var/lib/docker/containers:ro
```
**?Qu? hay aqu??**:
```
/var/lib/docker/containers/
??? abc123.../
?   ??? abc123...-json.log  ? Logs de juice-shop
??? def456.../
?   ??? def456...-json.log  ? Logs de elasticsearch
??? ghi789.../
    ??? ghi789...-json.log  ? Logs de kibana
```

**Formato de los logs**:
```json
{"log":"Server listening on port 3000\n","stream":"stdout","time":"2025-11-04T10:30:00.123Z"}
{"log":"GET /api/Products 200\n","stream":"stdout","time":"2025-11-04T10:30:05.456Z"}
```

3. **Socket de Docker**:
```yaml
- /var/run/docker.sock:/var/run/docker.sock:ro
```
**?Para qu??**:
- API de Docker
- Filebeat consulta metadatos de contenedores:
  - Nombre del contenedor
  - Labels
  - IDs
  - Estado

**Ejemplo de uso**:
```bash
# Filebeat pregunta: "?Qu? contenedor tiene ID abc123?"
# Docker responde: "juice-shop"
# Filebeat agrega: container.name = "juice-shop"
```

4. **Datos de Filebeat**:
```yaml
- filebeat-data:/usr/share/filebeat/data
```
**?Qu? almacena?**:
- **Registry**: Qu? archivos ya ley? y hasta d?nde
- **Estado**: Posici?n actual en cada archivo
- **Metadata**: Informaci?n de tracking

**?Por qu? es importante?**:
- Evita duplicados
- Contin?a donde qued? si se reinicia
- No pierde datos

**Ejemplo de registry**:
```json
{
  "/var/lib/docker/containers/abc123.../abc123...-json.log": {
    "offset": 12345,
    "timestamp": "2025-11-04T10:30:00Z"
  }
}
```

**`environment`**:
```yaml
- ELASTICSEARCH_HOSTS=http://elasticsearch:9200
- KIBANA_HOST=http://kibana:5601
```
- Sobrescribe valores en filebeat.yml
- Permite configuraci?n flexible
- Usa nombres de servicio Docker

**`depends_on`**:
```yaml
depends_on:
  elasticsearch:
    condition: service_healthy
```
**Orden de inicio**:
```
1. Elasticsearch inicia
2. Elasticsearch healthcheck pasa ?
3. Filebeat inicia
4. Filebeat conecta inmediatamente
```

**`command`**:
```yaml
command: filebeat -e -strict.perms=false
```
- `-e`: Logs a stderr (los vemos con `docker compose logs`)
- `-strict.perms=false`: Ignora permisos de filebeat.yml

### 2. Archivo filebeat.yml

```yaml
filebeat.inputs:
  - type: container
    enabled: true
    paths:
      - '/var/lib/docker/containers/*/*.log'
    processors:
      - add_docker_metadata:
          host: "unix:///var/run/docker.sock"
      - decode_json_fields:
          fields: ["message"]
          target: "json"
          overwrite_keys: true

processors:
  - add_host_metadata:
      when.not.contains.tags: forwarded
  - add_cloud_metadata: ~
  - add_docker_metadata: ~

output.elasticsearch:
  hosts: ["${ELASTICSEARCH_HOSTS:elasticsearch:9200}"]
  indices:
    - index: "filebeat-juice-shop-%{+yyyy.MM.dd}"
      when.contains:
        container.name: "juice-shop"
    - index: "filebeat-docker-%{+yyyy.MM.dd}"

setup.kibana:
  host: "${KIBANA_HOST:kibana:5601}"

setup.dashboards.enabled: true

logging.level: info
logging.to_files: true
logging.files:
  path: /var/log/filebeat
  name: filebeat
  keepfiles: 7
  permissions: 0644
```

#### Explicaci?n secci?n por secci?n:

**`filebeat.inputs`** - ?Qu? leer?:

```yaml
- type: container
```
- Input especializado para contenedores Docker
- Entiende el formato JSON de Docker
- Maneja rotaci?n de logs autom?ticamente

```yaml
paths:
  - '/var/lib/docker/containers/*/*.log'
```
- `*/*`: Todos los contenedores, todos los logs
- Wildcard permite detectar nuevos contenedores autom?ticamente

**`processors`** - ?C?mo procesar?:

1. **add_docker_metadata**:
```yaml
- add_docker_metadata:
    host: "unix:///var/run/docker.sock"
```

**Antes**:
```json
{
  "message": "GET /api/Products 200"
}
```

**Despu?s**:
```json
{
  "message": "GET /api/Products 200",
  "container": {
    "id": "abc123",
    "name": "juice-shop",
    "image": {
      "name": "bkimminich/juice-shop"
    }
  }
}
```

2. **decode_json_fields**:
```yaml
- decode_json_fields:
    fields: ["message"]
    target: "json"
    overwrite_keys: true
```

**Antes**:
```json
{
  "message": "{\"level\":\"info\",\"msg\":\"Server started\"}"
}
```

**Despu?s**:
```json
{
  "message": "{\"level\":\"info\",\"msg\":\"Server started\"}",
  "json": {
    "level": "info",
    "msg": "Server started"
  }
}
```

3. **add_host_metadata**:
```yaml
- add_host_metadata:
```

Agrega:
```json
{
  "host": {
    "name": "docker-host",
    "os": {
      "platform": "darwin",
      "version": "25.0.0"
    },
    "ip": ["192.168.1.100"]
  }
}
```

**`output.elasticsearch`** - ?D?nde enviar?:

```yaml
hosts: ["${ELASTICSEARCH_HOSTS:elasticsearch:9200}"]
```
- `${VAR:default}`: Lee variable de entorno o usa default
- Permite configuraci?n flexible

**?ndices din?micos**:
```yaml
indices:
  - index: "filebeat-juice-shop-%{+yyyy.MM.dd}"
    when.contains:
      container.name: "juice-shop"
  - index: "filebeat-docker-%{+yyyy.MM.dd}"
```

**?Qu? hace?**:
- Si el log es de "juice-shop" ? `filebeat-juice-shop-2025.11.04`
- Si es de otro contenedor ? `filebeat-docker-2025.11.04`
- `%{+yyyy.MM.dd}`: Fecha actual

**Ventajas**:
- Logs separados por aplicaci?n
- ?ndices diarios (f?cil de limpiar logs viejos)
- B?squedas m?s r?pidas (menos datos por ?ndice)

**`setup.kibana`** - Configuraci?n de Kibana:

```yaml
setup.kibana:
  host: "${KIBANA_HOST:kibana:5601}"

setup.dashboards.enabled: true
```

**?Qu? hace?**:
- Filebeat carga dashboards predefinidos en Kibana
- Crea visualizaciones autom?ticas
- Configura Data Views

**Dashboards incluidos**:
- Docker overview
- Container metrics
- Log analysis

## ?? Flujo Completo de un Log

### Paso a paso detallado:

```
1. Usuario accede a Juice Shop
   http://localhost:3000
   ?
   ?
2. Juice Shop procesa request y genera log
   console.log("GET /api/Products 200 45ms")
   ?
   ?
3. Docker captura stdout y lo escribe en archivo
   /var/lib/docker/containers/abc123.../abc123...-json.log
   {"log":"GET /api/Products 200 45ms\n","stream":"stdout","time":"2025-11-04T10:30:00Z"}
   ?
   ?
4. Filebeat detecta nuevo contenido en archivo
   (monitorea con inotify/fsnotify)
   ?
   ?
5. Filebeat lee la l?nea nueva
   ?
   ?
6. Filebeat parsea JSON de Docker
   Extrae: log, stream, time
   ?
   ?
7. Filebeat consulta Docker API
   "?Qu? contenedor es abc123?"
   Docker responde: "juice-shop"
   ?
   ?
8. Filebeat agrega metadata
   {
     "message": "GET /api/Products 200 45ms",
     "@timestamp": "2025-11-04T10:30:00Z",
     "container": {
       "name": "juice-shop",
       "id": "abc123"
     },
     "host": {...}
   }
   ?
   ?
9. Filebeat determina ?ndice
   container.name = "juice-shop"
   ? ?ndice: "filebeat-juice-shop-2025.11.04"
   ?
   ?
10. Filebeat env?a a Elasticsearch
    POST http://elasticsearch:9200/filebeat-juice-shop-2025.11.04/_doc
    ?
    ?
11. Elasticsearch indexa el documento
    Analiza texto, crea ?ndice invertido
    ?
    ?
12. Elasticsearch confirma a Filebeat
    {"result": "created", "_id": "xyz789"}
    ?
    ?
13. Filebeat actualiza registry
    "Le? hasta posici?n 12345 del archivo abc123...-json.log"
    ?
    ?
14. Usuario abre Kibana
    http://localhost:5601
    ?
    ?
15. Kibana consulta Elasticsearch
    GET /filebeat-*/_search
    ?
    ?
16. Elasticsearch retorna resultados
    ?
    ?
17. Kibana muestra log en pantalla
    ? Usuario ve: "GET /api/Products 200 45ms"
```

**Tiempo total**: ~1-2 segundos (near real-time)

## ?? Arquitectura Completa Final

```
????????????????????????????????????????????????????????????????????
?                        TU M?QUINA                                ?
?                                                                  ?
?  Navegador ??? http://localhost:3000 (Juice Shop)              ?
?  Navegador ??? http://localhost:5601 (Kibana)                  ?
?                                                                  ?
????????????????????????????????????????????????????????????????????
                             ?
                             ? HTTP
                             ?
????????????????????????????????????????????????????????????????????
?                    DOCKER - elk-network                          ?
?                                                                  ?
?  ???????????????????                                            ?
?  ?  Juice Shop     ?                                            ?
?  ?  Puerto 3000    ?                                            ?
?  ?                 ?                                            ?
?  ? 1. Genera logs  ?                                            ?
?  ???????????????????                                            ?
?           ?                                                      ?
?           ? stdout/stderr                                        ?
?           ?                                                      ?
?  ???????????????????????????????????????                       ?
?  ?  Docker Engine                      ?                       ?
?  ?  /var/lib/docker/containers/        ?                       ?
?  ?  ??? abc123.../abc123...-json.log   ?                       ?
?  ?  2. Escribe logs en archivos        ?                       ?
?  ???????????????????????????????????????                       ?
?           ?                                                      ?
?           ? lee archivos                                         ?
?           ?                                                      ?
?  ???????????????????                                            ?
?  ?   Filebeat      ?                                            ?
?  ?                 ?                                            ?
?  ? 3. Lee logs     ?                                            ?
?  ? 4. Procesa      ?                                            ?
?  ? 5. Enriquece    ?                                            ?
?  ???????????????????                                            ?
?           ?                                                      ?
?           ? HTTP POST (JSON)                                     ?
?           ?                                                      ?
?  ???????????????????         ???????????????????              ?
?  ? Elasticsearch   ???????????   Kibana        ?              ?
?  ? Puerto 9200     ?  query  ?   Puerto 5601   ?              ?
?  ?                 ?         ?                 ?              ?
?  ? 6. Indexa       ?         ? 8. Consulta     ?              ?
?  ? 7. Almacena     ?         ? 9. Visualiza    ?              ?
?  ???????????????????         ???????????????????              ?
?           ?                                                      ?
?           ?                                                      ?
?  ???????????????????                                            ?
?  ?  Volumen        ?                                            ?
?  ?  elasticsearch- ?                                            ?
?  ?  data           ?                                            ?
?  ?                 ?                                            ?
?  ? Persistencia    ?                                            ?
?  ???????????????????                                            ?
????????????????????????????????????????????????????????????????????
```

## ? Verificaci?n

### 1. Levantar todos los servicios
```bash
docker compose up -d
```

### 2. Verificar que Filebeat inici? correctamente
```bash
docker compose logs filebeat | grep -i "elasticsearch\|kibana\|pipeline"
```

**Mensajes esperados**:
```
filebeat  | "Elasticsearch url: http://elasticsearch:9200"
filebeat  | "Kibana url: http://kibana:5601"
filebeat  | "Pipeline is connecting"
filebeat  | "Connection to backoff(elasticsearch(http://elasticsearch:9200)) established"
```

### 3. Generar logs en Juice Shop
```bash
# Hacer 10 requests
for i in {1..10}; do
  curl -s http://localhost:3000 > /dev/null
  echo "Request $i"
  sleep 1
done
```

### 4. Esperar procesamiento
```bash
# Esperar 30 segundos para que Filebeat procese
sleep 30
```

### 5. Verificar ?ndices en Elasticsearch
```bash
curl 'http://localhost:9200/_cat/indices?v'
```

**Salida esperada**:
```
health status index                          docs.count
yellow open   filebeat-juice-shop-2025.11.04     10
yellow open   filebeat-docker-2025.11.04         50
```

### 6. Ver un log espec?fico
```bash
curl -X GET "http://localhost:9200/filebeat-juice-shop-*/_search?size=1&pretty"
```

**Respuesta esperada**:
```json
{
  "hits": {
    "hits": [
      {
        "_source": {
          "@timestamp": "2025-11-04T10:30:00Z",
          "message": "GET / 200",
          "container": {
            "name": "juice-shop",
            "id": "abc123"
          },
          "host": {
            "name": "docker-host"
          }
        }
      }
    ]
  }
}
```

### 7. Verificar en Kibana

1. Abre http://localhost:5601
2. Ve a **Management** ? **Stack Management** ? **Data Views**
3. Deber?as ver:
   - `filebeat-*` (creado autom?ticamente)
4. Ve a **Analytics** ? **Discover**
5. Selecciona `filebeat-*`
6. Filtra: `container.name: "juice-shop"`
7. ?Deber?as ver tus logs!

## ?? Conceptos Clave

### 1. **Registry de Filebeat**
- Archivo que trackea qu? se ha le?do
- Ubicaci?n: `/usr/share/filebeat/data/registry`
- Evita duplicados
- Permite reanudar despu?s de reinicio

### 2. **Backpressure**
- Si Elasticsearch est? lento, Filebeat espera
- No pierde datos
- Buffer interno para almacenar temporalmente

### 3. **At-least-once delivery**
- Garantiza que cada log llega al menos una vez
- Puede haber duplicados en casos raros
- Elasticsearch maneja duplicados con `_id`

### 4. **Input types**
- `container`: Para logs de Docker
- `log`: Para archivos normales
- `syslog`: Para syslog
- `stdin`: Para entrada est?ndar

## ?? Troubleshooting

### Problema: Filebeat no encuentra logs
```bash
# Verificar que el volumen est? montado
docker exec filebeat ls -la /var/lib/docker/containers

# Deber?a mostrar directorios
```

### Problema: Permission denied
```bash
# Verificar que corre como root
docker compose ps

# USER deber?a ser "root"
```

### Problema: No se crean ?ndices
```bash
# Ver logs de Filebeat
docker compose logs filebeat | grep -i error

# Verificar conectividad a Elasticsearch
docker exec filebeat curl http://elasticsearch:9200
```

### Problema: Logs duplicados
- Normal en reinicios
- Elasticsearch deduplica autom?ticamente
- No es un problema cr?tico

## ?? Siguiente Paso

Con Filebeat funcionando, el sistema ELK est? completo y funcional. El siguiente paso es **configurar visualizaciones en Kibana** para aprovechar al m?ximo los datos recolectados.

## ?? Resumen

? **Logrado**:
- Filebeat corriendo y conectado
- Leyendo logs de todos los contenedores Docker
- Procesando y enriqueciendo logs
- Enviando a Elasticsearch correctamente
- ?ndices creados autom?ticamente

? **Verificado**:
- Logs de Juice Shop en Elasticsearch
- ?ndices con formato correcto
- Metadata de contenedor agregada
- Visible en Kibana

? **Entendido**:
- Flujo completo de un log
- C?mo Filebeat lee archivos de Docker
- Procesamiento y enriquecimiento
- Comunicaci?n entre todos los componentes
- Arquitectura completa del sistema ELK

? **Sistema Completo**:
```
Juice Shop ? Docker ? Filebeat ? Elasticsearch ? Kibana ? Usuario
   ?         ?        ?           ?             ?        ?
```
