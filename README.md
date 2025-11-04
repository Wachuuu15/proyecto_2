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

### ? Siguientes Pasos
- [ ] Paso 3: Agregar Kibana
- [ ] Paso 4: Agregar Filebeat
- [ ] Paso 5: Configurar visualizaci?n

## Uso Actual

```bash
# Levantar Juice Shop
docker compose up -d

# Ver logs
docker compose logs -f

# Detener
docker compose down
```

## Acceso
- Juice Shop: http://localhost:3000
- Elasticsearch API: http://localhost:9200

## Verificar Elasticsearch

```bash
# Ver salud del cluster
curl http://localhost:9200/_cluster/health?pretty

# Ver informaci?n del nodo
curl http://localhost:9200
```
