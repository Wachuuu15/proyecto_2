# Proyecto 2 - Sistema de Logging con ELK Stack

## Objetivo
Implementar un sistema de monitoreo y logging para contenedores Docker usando Elasticsearch, Kibana y Filebeat (ELK Stack).

## Progreso

### ? Paso 1: Juice Shop B?sico
- [x] Dockerfile configurado
- [x] docker-compose.yml b?sico
- [x] Servicio funcionando en puerto 3000

### ? Siguientes Pasos
- [ ] Paso 2: Agregar Elasticsearch
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
