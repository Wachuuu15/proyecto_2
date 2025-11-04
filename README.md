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

### ? Siguientes Pasos
- [ ] Paso 4: Agregar Filebeat
- [ ] Paso 5: Configurar visualizaci?n

## Uso Actual

```bash
# Levantar todos los servicios
docker compose up -d

# Ver logs
docker compose logs -f

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

# Ver todos los servicios
docker compose ps
```
