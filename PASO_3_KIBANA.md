# Paso 3: Agregar Kibana

## ?? Objetivo
Implementar Kibana como interfaz visual para explorar y analizar los datos almacenados en Elasticsearch.

## ?? Relaci?n con pasos anteriores

### Flujo de datos hasta ahora:
```
PASO 1: Juice Shop          PASO 2: Elasticsearch       PASO 3: Kibana
???????????????              ????????????????           ????????????????
? Juice Shop  ?              ?              ?           ?              ?
?             ?              ? Elasticsearch?????????????   Kibana     ?
? Genera logs ?????????????????              ?  Consulta ?  (Interfaz)  ?
? (Todav?a no ?  (Pr?ximo    ? Almacena     ?  datos    ?              ?
?  conectado) ?   paso)      ? logs         ?           ?              ?
???????????????              ????????????????           ????????????????
                                    ?                          ?
                                    ?                          ?
                                    ????????????????????????????
                                       Usuario visualiza logs
```

### ?C?mo se relacionan?

**Elasticsearch (Paso 2)** es el **backend**:
- Almacena los datos
- Procesa b?squedas
- Realiza agregaciones
- No tiene interfaz gr?fica

**Kibana (Paso 3)** es el **frontend**:
- Se conecta a Elasticsearch
- Traduce clicks en queries
- Muestra resultados visualmente
- Crea gr?ficos y dashboards

**Analog?a**:
- Elasticsearch = Base de datos MySQL
- Kibana = phpMyAdmin (interfaz web para MySQL)

## ?? ?Qu? es Kibana?

**Kibana** es la interfaz de visualizaci?n oficial para Elasticsearch, desarrollada por Elastic.

### Caracter?sticas principales:

1. **Discover**: Explora logs en tiempo real
2. **Visualize**: Crea gr?ficos (barras, l?neas, pie charts)
3. **Dashboard**: Combina m?ltiples visualizaciones
4. **Dev Tools**: Consola para queries directas
5. **Management**: Configura ?ndices y patrones

### ?Por qu? necesitamos Kibana?

**Sin Kibana** (solo Elasticsearch):
```bash
# Buscar logs con curl
curl -X GET "http://localhost:9200/logs/_search" \
  -H 'Content-Type: application/json' \
  -d '{
    "query": {
      "match": {
        "message": "error"
      }
    }
  }'

# Respuesta: JSON crudo, dif?cil de leer
{
  "hits": {
    "total": 1523,
    "hits": [
      {"_source": {"message": "error 1", ...}},
      {"_source": {"message": "error 2", ...}},
      ...
    ]
  }
}
```

**Con Kibana**:
1. Abres http://localhost:5601
2. Vas a Discover
3. Escribes "error" en la barra de b?squeda
4. Ves resultados en tabla interactiva
5. Creas gr?fico de errores por hora con 3 clicks

## ?? Componentes Implementados

### Configuraci?n en docker-compose.yml

```yaml
kibana:
  image: docker.elastic.co/kibana/kibana:8.11.0
  container_name: kibana
  ports:
    - "5601:5601"
  environment:
    - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    - ELASTICSEARCH_URL=http://elasticsearch:9200
  networks:
    - elk-network
  depends_on:
    elasticsearch:
      condition: service_healthy
  restart: unless-stopped
  healthcheck:
    test: ["CMD-SHELL", "curl -f http://localhost:5601/api/status || exit 1"]
    interval: 30s
    timeout: 10s
    retries: 5
```

### Explicaci?n detallada:

#### 1. **Imagen**
```yaml
image: docker.elastic.co/kibana/kibana:8.11.0
```
- **Misma versi?n que Elasticsearch (8.11.0)**: ?IMPORTANTE!
- Las versiones deben coincidir
- Incompatibilidades pueden causar errores

**?Por qu? la misma versi?n?**:
- API de Elasticsearch cambia entre versiones
- Kibana est? optimizado para su versi?n correspondiente
- Evita bugs y problemas de compatibilidad

#### 2. **Puerto**
```yaml
ports:
  - "5601:5601"
```
- **5601**: Puerto est?ndar de Kibana
- Interfaz web accesible en http://localhost:5601
- Solo necesita un puerto (es una aplicaci?n web)

#### 3. **Variables de entorno**

**`ELASTICSEARCH_HOSTS=http://elasticsearch:9200`**

Esta es la configuraci?n **M?S IMPORTANTE**:

```
???????????????
?   Kibana    ?
? Container   ?
???????????????
       ?
       ? http://elasticsearch:9200
       ?
       ?
???????????????
?Elasticsearch?
? Container   ?
???????????????
```

**?Por qu? "elasticsearch" y no "localhost"?**:
- Dentro de Docker, cada contenedor tiene su propio "localhost"
- "elasticsearch" es el **nombre del servicio** en docker-compose
- Docker DNS resuelve "elasticsearch" ? IP del contenedor

**Prueba conceptual**:
```bash
# Desde tu m?quina (funciona)
curl http://localhost:9200

# Desde dentro de Kibana (NO funciona)
curl http://localhost:9200  # ? Buscar?a en el mismo contenedor

# Desde dentro de Kibana (funciona)
curl http://elasticsearch:9200  # ? Encuentra el otro contenedor
```

#### 4. **Red compartida**
```yaml
networks:
  - elk-network
```

**?Qu? hace?**:
- Ambos contenedores (Kibana y Elasticsearch) est?n en la misma red
- Pueden comunicarse usando nombres de servicio
- Aislados de otros contenedores

**Sin red compartida**:
```
???????????        ???????????????
? Kibana  ?   ?    ?Elasticsearch?
? Red A   ?        ?   Red B     ?
???????????        ???????????????
    No se pueden comunicar
```

**Con red compartida (elk-network)**:
```
????????????????????????????????
?       elk-network            ?
?  ???????????  ???????????????
?  ? Kibana  ????Elasticsearch??
?  ???????????  ???????????????
????????????????????????????????
    Se comunican libremente
```

#### 5. **depends_on con healthcheck**
```yaml
depends_on:
  elasticsearch:
    condition: service_healthy
```

**?Qu? hace?**:
1. Docker Compose inicia Elasticsearch primero
2. Espera a que el healthcheck de Elasticsearch pase
3. Solo entonces inicia Kibana

**?Por qu? es necesario?**:

**Sin depends_on**:
```
t=0s:  Elasticsearch inicia ?
t=0s:  Kibana inicia        ?  Ambos al mismo tiempo
t=5s:  Kibana intenta conectar a Elasticsearch
       ? ERROR: Elasticsearch no est? listo
       Kibana falla y se reinicia
t=30s: Elasticsearch finalmente est? listo
t=35s: Kibana se reinicia y conecta
       ? Funciona, pero tard? m?s
```

**Con depends_on + healthcheck**:
```
t=0s:  Elasticsearch inicia
t=30s: Elasticsearch healthcheck pasa ?
t=30s: Kibana inicia
t=35s: Kibana conecta a Elasticsearch
       ? Funciona a la primera
```

#### 6. **Healthcheck de Kibana**
```yaml
healthcheck:
  test: ["CMD-SHELL", "curl -f http://localhost:5601/api/status || exit 1"]
```

**?Qu? verifica?**:
- Endpoint `/api/status` de Kibana
- Retorna informaci?n sobre el estado de Kibana

**Respuesta del endpoint**:
```json
{
  "status": {
    "overall": {
      "state": "green",
      "title": "Green"
    }
  }
}
```

**Estados posibles**:
- ?? **green**: Todo funcionando
- ?? **yellow**: Funcional con advertencias
- ?? **red**: Problemas cr?ticos

## ?? Flujo de comunicaci?n completo

### Cuando accedes a Kibana:

```
1. Usuario abre navegador
   ?
   ?
2. http://localhost:5601
   ?
   ?
3. ???????????????????????
   ?  Kibana Container   ?
   ?  - Carga interfaz   ?
   ?  - Muestra UI       ?
   ???????????????????????
              ?
4. Usuario busca "error" en Discover
   ?
   ?
5. Kibana traduce a query de Elasticsearch:
   {
     "query": {
       "match": {
         "message": "error"
       }
     }
   }
   ?
   ?
6. Kibana env?a query a:
   http://elasticsearch:9200/logs/_search
   ?
   ?
7. ???????????????????????????
   ? Elasticsearch Container ?
   ? - Recibe query          ?
   ? - Busca en ?ndices      ?
   ? - Retorna resultados    ?
   ???????????????????????????
              ?
8. Kibana recibe JSON con resultados
   ?
   ?
9. Kibana formatea y muestra en tabla
   ?
   ?
10. Usuario ve logs en pantalla
```

## ? Verificaci?n

### 1. Levantar servicios
```bash
docker compose up -d
```

### 2. Ver logs de inicio
```bash
docker compose logs -f kibana
```

**Mensajes importantes a buscar**:
```
kibana  | [info] Kibana is now available
kibana  | [info] http server running at http://0.0.0.0:5601
```

**?Cu?nto tarda?**:
- Elasticsearch: 30-60 segundos
- Kibana: 30-45 segundos adicionales
- **Total**: ~1-2 minutos

### 3. Verificar estado de servicios
```bash
docker compose ps
```

**Salida esperada**:
```
NAME            STATUS
elasticsearch   Up (healthy)
kibana          Up (healthy)
juice-shop      Up
```

### 4. Verificar conectividad Kibana ? Elasticsearch
```bash
# Desde tu m?quina, pregunta a Kibana su estado
curl http://localhost:5601/api/status
```

**Respuesta esperada**:
```json
{
  "status": {
    "overall": {
      "state": "green"
    },
    "core": {
      "elasticsearch": {
        "level": "available"
      }
    }
  }
}
```

**Clave**: `"elasticsearch": {"level": "available"}` confirma que Kibana ve a Elasticsearch.

### 5. Acceder a la interfaz web

**Abre en tu navegador**: http://localhost:5601

**Primera vez que accedes**:
1. Ver?s pantalla de bienvenida
2. Puede pedir configuraci?n inicial
3. Click en "Explore on my own"

### 6. Verificar conexi?n desde Kibana UI

En Kibana:
1. Ve al men? (?) ? **Management** ? **Dev Tools**
2. Escribe en la consola:
```
GET /
```
3. Click en el bot?n ? (Play)

**Respuesta esperada**:
```json
{
  "name" : "elasticsearch",
  "cluster_name" : "docker-cluster",
  "version" : {
    "number" : "8.11.0"
  }
}
```

Esto confirma que Kibana puede ejecutar queries en Elasticsearch.

## ?? Explorando Kibana

### Secciones principales:

#### 1. **Discover** (Explorar logs)
- Ruta: Analytics ? Discover
- Funci?n: Ver logs en tiempo real
- Uso: Buscar, filtrar, explorar

#### 2. **Visualize** (Crear gr?ficos)
- Ruta: Analytics ? Visualize
- Funci?n: Crear gr?ficos individuales
- Tipos: Barras, l?neas, pie, mapas

#### 3. **Dashboard** (Paneles)
- Ruta: Analytics ? Dashboard
- Funci?n: Combinar m?ltiples visualizaciones
- Uso: Vista general del sistema

#### 4. **Dev Tools** (Consola)
- Ruta: Management ? Dev Tools
- Funci?n: Ejecutar queries directamente
- Uso: Testing, debugging

#### 5. **Stack Management** (Configuraci?n)
- Ruta: Management ? Stack Management
- Funci?n: Configurar ?ndices, usuarios, etc.
- Uso: Administraci?n

## ?? Prueba de integraci?n

### Crear un log de prueba desde Elasticsearch:

```bash
# Crear un ?ndice con un documento
curl -X POST "http://localhost:9200/test-logs/_doc" \
  -H 'Content-Type: application/json' \
  -d '{
    "@timestamp": "2025-11-04T10:00:00Z",
    "level": "INFO",
    "message": "Test log from Elasticsearch",
    "service": "test"
  }'
```

### Ver el log en Kibana:

1. Abre Kibana: http://localhost:5601
2. Ve a **Management** ? **Stack Management** ? **Data Views**
3. Click **Create data view**
4. Configuraci?n:
   - **Name**: Test Logs
   - **Index pattern**: `test-logs*`
   - **Timestamp field**: `@timestamp`
5. Click **Save data view**
6. Ve a **Analytics** ? **Discover**
7. Selecciona "Test Logs" en el dropdown
8. ?Deber?as ver tu log!

## ?? Arquitectura Actual

```
????????????????????????????????????????????????????????????
?                     TU M?QUINA                           ?
?                                                          ?
?  Navegador ??????? http://localhost:5601 (Kibana UI)   ?
?                                                          ?
????????????????????????????????????????????????????????????
                         ?
                         ? HTTP
                         ?
????????????????????????????????????????????????????????????
?                    DOCKER - elk-network                  ?
?                                                          ?
?  ???????????????????         ????????????????????      ?
?  ?  Juice Shop     ?         ?   Kibana         ?      ?
?  ?  Puerto 3000    ?         ?   Puerto 5601    ?      ?
?  ?                 ?         ?                  ?      ?
?  ? (Genera logs)   ?         ? (Visualiza logs) ?      ?
?  ???????????????????         ????????????????????      ?
?                                       ?                 ?
?         (Pr?ximo paso:                ?                 ?
?          conectar con                 ?                 ?
?          Filebeat)                    ?                 ?
?                                       ?                 ?
?                                       ?                 ?
?                              ????????????????????       ?
?                              ? Elasticsearch    ?       ?
?                              ? Puerto 9200      ?       ?
?                              ?                  ?       ?
?                              ? (Almacena logs)  ?       ?
?                              ????????????????????       ?
?                                       ?                 ?
?                                       ?                 ?
?                              ????????????????????       ?
?                              ?  Volumen         ?       ?
?                              ?  (Persistencia)  ?       ?
?                              ????????????????????       ?
????????????????????????????????????????????????????????????
```

## ?? Conceptos Clave

### 1. **Data View (antes Index Pattern)**
- Define qu? ?ndices de Elasticsearch mostrar en Kibana
- Usa wildcards: `logs-*` muestra todos los ?ndices que empiecen con "logs-"
- Necesario antes de usar Discover

### 2. **KQL (Kibana Query Language)**
```
# Buscar logs con "error"
message: error

# Buscar logs de un servicio espec?fico
service: "juice-shop"

# Combinar condiciones
service: "juice-shop" AND level: "ERROR"

# Rangos de tiempo
@timestamp >= "2025-11-04"
```

### 3. **Time Filter**
- Selector en la esquina superior derecha
- Opciones: Last 15 minutes, Last 1 hour, Last 7 days, etc.
- Crucial para limitar b?squedas

### 4. **Saved Searches**
- Guarda b?squedas frecuentes
- Reutilizables en dashboards
- Ahorra tiempo

## ?? Relaci?n con el siguiente paso

**Estado actual**:
- ? Juice Shop genera logs
- ? Elasticsearch puede almacenar logs
- ? Kibana puede visualizar logs
- ? **FALTA**: Conectar Juice Shop ? Elasticsearch

**Pr?ximo paso (Filebeat)**:
```
???????????????
? Juice Shop  ?
?             ?
? Logs ???????????
???????????????  ?
                 ?
                 ?
            ???????????
            ?Filebeat ? ? Pr?ximo paso
            ?(Recolec-?
            ?  tor)   ?
            ???????????
                 ?
                 ?
         ????????????????
         ?Elasticsearch ?
         ????????????????
                ?
                ?
         ????????????????
         ?   Kibana     ?
         ????????????????
```

Filebeat ser? el "puente" que:
1. Lee los logs de Juice Shop
2. Los procesa y formatea
3. Los env?a a Elasticsearch
4. Kibana los muestra autom?ticamente

## ?? Troubleshooting

### Problema: Kibana no carga
```bash
# Verificar que Elasticsearch est? healthy
docker compose ps

# Ver logs de Kibana
docker compose logs kibana

# Buscar errores de conexi?n
```

### Problema: "Kibana server is not ready yet"
- **Causa**: Kibana a?n est? iniciando
- **Soluci?n**: Esperar 1-2 minutos m?s
- **Verificar**: `docker compose logs kibana`

### Problema: No puede conectar a Elasticsearch
```bash
# Verificar que est?n en la misma red
docker network inspect proyecto_2_elk-network

# Deber?as ver ambos contenedores listados
```

### Problema: Versiones incompatibles
- **S?ntoma**: Errores raros, features no funcionan
- **Soluci?n**: Verificar que Kibana y Elasticsearch tienen la misma versi?n
```bash
# Ver versi?n de Elasticsearch
curl http://localhost:9200

# Ver versi?n de Kibana
curl http://localhost:5601/api/status
```

## ?? Siguiente Paso

Con Kibana funcionando, el siguiente paso es agregar **Filebeat** para recolectar los logs de Juice Shop y enviarlos a Elasticsearch, completando as? el flujo de datos.

## ?? Resumen

? **Logrado**:
- Kibana corriendo en puerto 5601
- Conectado exitosamente a Elasticsearch
- Interfaz web accesible
- Healthcheck funcional
- Dependencia de Elasticsearch configurada

? **Verificado**:
- Kibana puede consultar Elasticsearch
- Interfaz web responde correctamente
- Dev Tools funcional
- Puede crear Data Views

? **Entendido**:
- C?mo Kibana se comunica con Elasticsearch
- Importancia de la red compartida
- Uso de nombres de servicio en Docker
- Dependencias entre servicios
- Flujo de datos: Usuario ? Kibana ? Elasticsearch ? Usuario
