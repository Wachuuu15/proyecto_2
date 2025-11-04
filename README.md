# Proyecto 2 - Sistema de Logging con ELK Stack

## ?? Objetivo
Implementar un sistema de monitoreo y logging para contenedores Docker usando Elasticsearch, Kibana y Filebeat (ELK Stack).

## ?? Progreso

### ? Paso 1: Juice Shop B?sico
- [x] Dockerfile configurado
- [x] docker-compose.yml b?sico
- [x] Servicio funcionando en puerto 3000

### ? Paso 2: Elasticsearch
- [x] Servicio Elasticsearch agregado
- [x] Configurado para nodo ?nico
- [x] Volumen persistente para datos
- [x] Healthcheck configurado
- [x] Red compartida elk-network

### ? Paso 3: Kibana
- [x] Servicio Kibana agregado
- [x] Conectado a Elasticsearch
- [x] Healthcheck configurado
- [x] Dependencia de Elasticsearch configurada
- [x] Interfaz web en puerto 5601

### ? Paso 4: Filebeat
- [x] Servicio Filebeat agregado
- [x] Configurado para leer logs de Docker
- [x] Conectado a Elasticsearch y Kibana
- [x] Vol?menes montados correctamente
- [x] Procesadores configurados
- [x] ?ndices din?micos por contenedor

### ? Paso 5: Visualizaci?n en Kibana
- [x] Data Views configurados
- [x] Discover para explorar logs
- [x] Visualizaciones creadas
- [x] Dashboard armado
- [x] Gu?a completa de uso

## ?? Sistema Completo

El sistema ELK est? 100% funcional:
```
Juice Shop ? Docker ? Filebeat ? Elasticsearch ? Kibana ? Usuario
   ?         ?        ?           ?             ?        ?
```

## ?? Inicio R?pido

### 1. Levantar el sistema
```bash
docker compose up -d
```

### 2. Esperar que los servicios inicien (~2 minutos)
```bash
docker compose ps
```

### 3. Generar logs de prueba
```bash
for i in {1..20}; do 
  curl -s http://localhost:3000 > /dev/null
  echo "Request $i"
  sleep 1
done
```

### 4. Ver logs en Kibana
1. Abre http://localhost:5601
2. Ve a Management ? Data Views
3. Crea Data View: `filebeat-*`
4. Ve a Analytics ? Discover
5. ?Explora tus logs!

## ?? Acceso a Servicios

- **Juice Shop**: http://localhost:3000
- **Kibana**: http://localhost:5601
- **Elasticsearch API**: http://localhost:9200

## ?? Documentaci?n Detallada

Cada paso tiene su documentaci?n completa con explicaciones t?cnicas y c?mo se relaciona con los dem?s componentes:

- `PASO_1_JUICE_SHOP.md` - Configuraci?n de Juice Shop
- `PASO_2_ELASTICSEARCH.md` - Implementaci?n de Elasticsearch
- `PASO_3_KIBANA.md` - Configuraci?n de Kibana
- `PASO_4_FILEBEAT.md` - Integraci?n con Filebeat
- `PASO_5_VISUALIZACION_KIBANA.md` - Gu?a de uso de Kibana

## ?? Comandos ?tiles

### Ver logs
```bash
# Todos los servicios
docker compose logs -f

# Servicio espec?fico
docker compose logs -f filebeat
docker compose logs -f elasticsearch
```

### Verificar servicios
```bash
# Estado de contenedores
docker compose ps

# Salud de Elasticsearch
curl http://localhost:9200/_cluster/health?pretty

# ?ndices creados
curl http://localhost:9200/_cat/indices?v

# Estado de Kibana
curl http://localhost:5601/api/status
```

### Detener sistema
```bash
# Detener sin eliminar datos
docker compose down

# Detener y eliminar vol?menes (limpieza completa)
docker compose down -v
```

## ?? Historial de Commits

Cada paso est? documentado en un commit separado para control de versiones:

- **Paso 1**: Configurar Juice Shop b?sico
- **Paso 2**: Agregar Elasticsearch
- **Paso 3**: Agregar Kibana
- **Paso 4**: Agregar Filebeat - Completar flujo de datos
- **Paso 5**: Configurar visualizaci?n en Kibana

```bash
# Ver historial
git log --oneline

# Ver cambios de un paso espec?fico
git show <commit-hash>

# Ver diferencias entre pasos
git diff <commit1> <commit2>
```

## ??? Arquitectura del Sistema

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
????????????????????????            ????????????????????????
           ?                                   ?
           ? stdout/stderr                     ? Queries
           ?                                   ?
????????????????????????                       ?
?  Docker Engine       ?                       ?
?  Captura logs        ?                       ?
????????????????????????                       ?
           ?                                   ?
           ? Archivos .log                     ?
           ?                                   ?
????????????????????????                       ?
?   Filebeat           ?                       ?
?   Recolecta          ?                       ?
?   Procesa            ?                       ?
????????????????????????                       ?
           ?                                   ?
           ? HTTP POST (JSON)                  ?
           ?                                   ?
????????????????????????                       ?
?   Elasticsearch      ?????????????????????????
?   Puerto 9200        ?
?   Indexa y Almacena  ?
????????????????????????
           ?
           ?
????????????????????????
?  Vol?menes           ?
?  Persistencia        ?
????????????????????????
```

## ?? Conceptos Aprendidos

- **Docker Compose**: Orquestaci?n de m?ltiples contenedores
- **Elasticsearch**: Motor de b?squeda y an?lisis de logs
- **Kibana**: Visualizaci?n y exploraci?n de datos
- **Filebeat**: Recolecci?n ligera de logs
- **Redes Docker**: Comunicaci?n entre contenedores
- **Vol?menes**: Persistencia de datos
- **Healthchecks**: Verificaci?n de disponibilidad
- **Dependencies**: Orden de inicio de servicios

## ?? Troubleshooting

### Servicios no inician
```bash
# Ver logs de error
docker compose logs

# Verificar recursos
docker stats

# Reiniciar servicios
docker compose restart
```

### No veo logs en Kibana
1. Verifica que Filebeat est? corriendo: `docker compose ps`
2. Genera tr?fico en Juice Shop
3. Espera 30-60 segundos
4. Verifica ?ndices: `curl http://localhost:9200/_cat/indices?v`
5. Ampl?a rango de tiempo en Kibana

### Elasticsearch sin memoria
```bash
# Editar docker-compose.yml
# Cambiar: ES_JAVA_OPTS=-Xms256m -Xmx256m
docker compose restart elasticsearch
```

## ?? Licencia

Este proyecto es con fines educativos.

## ?? Autor

Proyecto 2 - Sistema de Logging con ELK Stack
