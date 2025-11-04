# Proyecto 2 - Sistema de Logging con ELK Stack

## Objetivo
Implementar un sistema de monitoreo y logging para contenedores Docker usando Elasticsearch, Kibana y Filebeat (ELK Stack).

## Progreso

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

### ? Siguientes Pasos
- [ ] Paso 5: Configurar visualizaci?n en Kibana

## Uso Actual

```bash
# Levantar todos los servicios
docker compose up -d

# Ver logs
docker compose logs -f

# Ver logs de un servicio espec?fico
docker compose logs -f filebeat

# Detener
docker compose down
```

## Acceso
- Juice Shop: http://localhost:3000
- Kibana: http://localhost:5601
- Elasticsearch API: http://localhost:9200

## Verificar Servicios

```bash
# Ver salud de Elasticsearch
curl http://localhost:9200/_cluster/health?pretty

# Ver estado de Kibana
curl http://localhost:5601/api/status

# Ver ?ndices creados
curl http://localhost:9200/_cat/indices?v

# Ver todos los servicios
docker compose ps
```

## Generar Logs de Prueba

```bash
# Hacer requests a Juice Shop para generar logs
for i in {1..10}; do
  curl -s http://localhost:3000 > /dev/null
  echo "Request $i"
  sleep 1
done
```

## Documentaci?n Detallada

Cada paso tiene su documentaci?n completa:
- `PASO_1_JUICE_SHOP.md` - Configuraci?n de Juice Shop
- `PASO_2_ELASTICSEARCH.md` - Implementaci?n de Elasticsearch
- `PASO_3_KIBANA.md` - Configuraci?n de Kibana
- `PASO_4_FILEBEAT.md` - Integraci?n con Filebeat
