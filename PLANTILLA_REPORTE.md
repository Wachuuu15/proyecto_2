# Proyecto 2 - Sistema de Logging con ELK Stack

**Nombre**: ___________________________  
**Carnet**: ___________________________  
**Fecha**: ___________________________  

---

## 📋 Índice

1. [Resumen Ejecutivo](#resumen-ejecutivo)
2. [Paso 1: Juice Shop Básico](#paso-1-juice-shop-básico)
3. [Paso 2: Elasticsearch](#paso-2-elasticsearch)
4. [Paso 3: Kibana](#paso-3-kibana)
5. [Paso 4: Filebeat](#paso-4-filebeat)
6. [Paso 5: Visualización en Kibana](#paso-5-visualización-en-kibana)
7. [Paso 6: Blue Team & Red Team](#paso-6-blue-team--red-team)
8. [Análisis Técnico](#análisis-técnico)
9. [Problemas y Soluciones](#problemas-y-soluciones)
10. [Conclusiones](#conclusiones)

---

## Resumen Ejecutivo

### Descripción del Proyecto
[Describe en 2-3 párrafos qué es el proyecto, qué tecnologías usaste y qué lograste]

### Objetivos Cumplidos
- [ ] Sistema ELK Stack completamente funcional
- [ ] Logs recolectándose en tiempo real
- [ ] Visualizaciones y dashboards creados
- [ ] 3 reglas de detección configuradas
- [ ] 4 vulnerabilidades explotadas y documentadas

### Tecnologías Utilizadas
- Docker y Docker Compose
- OWASP Juice Shop
- Elasticsearch 8.11.0
- Kibana 8.11.0
- Filebeat 8.11.0

### Tiempo Invertido
| Paso | Tiempo Real |
|------|-------------|
| Paso 1: Juice Shop | ___ min |
| Paso 2: Elasticsearch | ___ min |
| Paso 3: Kibana | ___ min |
| Paso 4: Filebeat | ___ min |
| Paso 5: Visualización | ___ min |
| Paso 6: Blue/Red Team | ___ min |
| Documentación | ___ min |
| **TOTAL** | **___ horas** |

---

## Paso 1: Juice Shop Básico

### Objetivo
[Describe el objetivo de este paso]

### Comandos Ejecutados

```bash
# Comando 1
docker compose up -d

# Output:
[Pega el output aquí]
```

```bash
# Comando 2
docker compose ps

# Output:
[Pega el output aquí]
```

[Continúa con todos los comandos...]

### Screenshots

#### Screenshot 1.1: Docker Compose PS
![Docker PS](./screenshots/paso-1/01-docker-compose-ps.png)

**Descripción**: [Describe qué muestra este screenshot]

**Verificación**:
- [x] Contenedor en estado "Up"
- [x] Puerto 3000 mapeado
- [x] Sin errores

[Repite para cada screenshot...]

### Problemas Encontrados

#### Problema 1: [Título del problema]

**Error**:
```
[Mensaje de error exacto]
```

**Causa**: [Por qué ocurrió]

**Solución**:
```bash
[Comandos que resolvieron el problema]
```

**Resultado**: [Qué pasó después]

### Verificación de Éxito
- [x] Contenedor corriendo sin errores
- [x] Puerto 3000 accesible
- [x] Interfaz web funcional
- [x] Logs generándose
- [x] 4 screenshots capturados

### Conceptos Aprendidos
1. **Docker Compose**: [Explica qué aprendiste]
2. **Port Mapping**: [Explica qué aprendiste]
3. **Container Logs**: [Explica qué aprendiste]

---

## Paso 2: Elasticsearch

### Objetivo
[Describe el objetivo]

### Comandos Ejecutados

[Sigue el mismo formato que el Paso 1]

### Screenshots

[Mínimo 5 screenshots]

### Problemas Encontrados

[Documenta problemas si los hubo]

### Verificación de Éxito
- [ ] Elasticsearch corriendo y healthy
- [ ] Cluster en estado GREEN/YELLOW
- [ ] Puerto 9200 respondiendo
- [ ] Puede crear documentos
- [ ] 5 screenshots capturados

### Conceptos Aprendidos
1. **Elasticsearch**: [Explica]
2. **Índices y Documentos**: [Explica]
3. **RESTful API**: [Explica]

---

## Paso 3: Kibana

### Objetivo
[Describe el objetivo]

### Comandos Ejecutados

[Sigue el mismo formato]

### Screenshots

[Mínimo 4 screenshots]

### Problemas Encontrados

[Documenta problemas]

### Verificación de Éxito
- [ ] Kibana corriendo y healthy
- [ ] Puerto 5601 accesible
- [ ] Conectado a Elasticsearch
- [ ] Dev Tools funcional
- [ ] 4 screenshots capturados

### Conceptos Aprendidos
1. **Kibana**: [Explica]
2. **Dev Tools**: [Explica]
3. **Redes Docker**: [Explica]

---

## Paso 4: Filebeat

### Objetivo
[Describe el objetivo]

### Comandos Ejecutados

[Sigue el mismo formato]

### Screenshots

[Mínimo 5 screenshots]

### Problemas Encontrados

[Documenta problemas]

### Verificación de Éxito
- [ ] Filebeat corriendo sin errores
- [ ] Conectado a Elasticsearch
- [ ] Índices filebeat-* creados
- [ ] Logs con metadata completa
- [ ] 5 screenshots capturados

### Conceptos Aprendidos
1. **Filebeat**: [Explica]
2. **Log Shipping**: [Explica]
3. **Processors**: [Explica]

---

## Paso 5: Visualización en Kibana

### Objetivo
[Describe el objetivo]

### Configuraciones Realizadas

#### Data Views Creados

**Data View 1: Todos los Logs**
- Name: Todos los Logs
- Index pattern: filebeat-*
- Timestamp field: @timestamp

[Describe cómo lo creaste]

#### Visualizaciones Creadas

**Visualización 1: Distribución por Contenedor**
- Tipo: Pie Chart
- Campo: container.name.keyword
- [Describe configuración]

**Visualización 2: Volumen en el Tiempo**
- Tipo: Line Chart
- [Describe configuración]

**Visualización 3: Total de Logs**
- Tipo: Metric
- [Describe configuración]

#### Dashboard Creado

**Nombre**: Overview de Logs del Sistema

**Visualizaciones incluidas**:
1. [Lista de visualizaciones]

[Describe el layout]

### Screenshots

[Mínimo 12 screenshots]

#### Screenshot 5.1: Creación de Data View
![Data View](./screenshots/paso-5/01-data-view.png)

[Continúa con todos...]

### Búsquedas KQL Utilizadas

```kql
# Búsqueda 1: Solo logs de Juice Shop
container.name: "juice-shop"
```

[Documenta todas las búsquedas que hiciste]

### Verificación de Éxito
- [ ] Data View creado
- [ ] Discover funcional
- [ ] 3 visualizaciones creadas
- [ ] Dashboard creado
- [ ] 12 screenshots capturados

### Conceptos Aprendidos
1. **Data Views**: [Explica]
2. **KQL**: [Explica]
3. **Visualizaciones**: [Explica]
4. **Dashboards**: [Explica]

---

## Paso 6: Blue Team & Red Team

### Blue Team: Reglas de Detección

#### Regla 1: Detección de SQL Injection

**Configuración**:
- Name: Detección SQL Injection
- Type: Custom query
- Query: `url.original:("*' or 1=1*" or "*union select*")`
- Severity: High
- Risk score: 75

**Prueba**:
```bash
curl "http://localhost:3000/rest/products/search?q=' OR 1=1 --"
```

**Resultado**: [Describe si se detectó]

#### Regla 2: Detección de XSS

[Sigue el mismo formato]

#### Regla 3: Detección de Scanning

[Sigue el mismo formato]

### Red Team: Vulnerabilidades Explotadas

#### Vulnerabilidad 1: SQL Injection en Login

**Descripción Técnica**:
[Explica qué es SQL Injection y cómo funciona]

**Endpoint Vulnerable**: `/rest/user/login`

**Pasos para Reproducir**:
1. [Paso 1]
2. [Paso 2]
3. [Paso 3]

**Payload Utilizado**:
```bash
curl -X POST http://localhost:3000/rest/user/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "'\'' OR 1=1--",
    "password": "anything"
  }'
```

**Response Obtenida**:
```json
[Pega la respuesta]
```

**Impacto**:
- **Confidencialidad**: 🔴 CRÍTICO - [Explica por qué]
- **Integridad**: 🔴 CRÍTICO - [Explica por qué]
- **Disponibilidad**: 🟡 MEDIO - [Explica por qué]

**Clasificación**:
- **OWASP Top 10**: A03:2021 - Injection
- **CVSS v3.1**: 9.8 (Critical)
- **Vector**: CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:H

**Cálculo CVSS**:
- **AV:N** (Attack Vector: Network) - [Explica por qué]
- **AC:L** (Attack Complexity: Low) - [Explica por qué]
- **PR:N** (Privileges Required: None) - [Explica por qué]
- **UI:N** (User Interaction: None) - [Explica por qué]
- **C:H** (Confidentiality: High) - [Explica por qué]
- **I:H** (Integrity: High) - [Explica por qué]
- **A:H** (Availability: High) - [Explica por qué]

**Screenshots**:
![SQLi Request](./screenshots/paso-6/sqli-01-request.png)
![SQLi Response](./screenshots/paso-6/sqli-02-response.png)

#### Vulnerabilidad 2: Cross-Site Scripting (XSS)

[Sigue el mismo formato detallado]

#### Vulnerabilidad 3: Broken Authentication

[Sigue el mismo formato detallado]

#### Vulnerabilidad 4: Broken Access Control

[Sigue el mismo formato detallado]

### Coordinación Red Team - Blue Team

**Resultados de Detección**:
| Ataque | Detectado | Tiempo de Detección |
|--------|-----------|---------------------|
| SQL Injection | [Sí/No] | [Tiempo] |
| XSS | [Sí/No] | [Tiempo] |
| Auth Bypass | [Sí/No] | [Tiempo] |
| Access Control | [Sí/No] | [Tiempo] |

### Screenshots

[Mínimo 12 screenshots]

### Verificación de Éxito
- [ ] 3 reglas de detección configuradas
- [ ] 4 vulnerabilidades explotadas
- [ ] Alertas generadas
- [ ] Dashboard de detecciones creado
- [ ] 12 screenshots capturados
- [ ] Vulnerabilidades con CVSS calculado

### Conceptos Aprendidos
1. **Reglas de Detección**: [Explica]
2. **SQL Injection**: [Explica]
3. **XSS**: [Explica]
4. **CVSS Scoring**: [Explica]
5. **OWASP Top 10**: [Explica]

---

## Análisis Técnico

### Arquitectura Completa del Sistema

```
[Dibuja o pega el diagrama de arquitectura]
```

**Componentes**:
1. **Juice Shop**: [Explica su rol]
2. **Docker Engine**: [Explica su rol]
3. **Filebeat**: [Explica su rol]
4. **Elasticsearch**: [Explica su rol]
5. **Kibana**: [Explica su rol]

### Flujo de Datos Detallado

```
Usuario → Juice Shop → Docker Logs → Filebeat → Elasticsearch → Kibana
```

**Explicación paso a paso**:
1. [Explica paso 1]
2. [Explica paso 2]
3. [Explica paso 3]
[...]

### Decisiones de Diseño

#### Decisión 1: [Título]
**Contexto**: [Por qué se necesitaba tomar una decisión]
**Decisión Tomada**: [Cuál se eligió]
**Justificación**: [Por qué se eligió]

[Repite para otras decisiones importantes]

---

## Problemas y Soluciones

### Resumen de Problemas

| Paso | Problema | Solución | Tiempo Perdido |
|------|----------|----------|----------------|
| [#] | [Descripción corta] | [Solución corta] | [minutos] |

### Detalle de Problemas Principales

#### Problema 1: [Título]

**Paso**: [En qué paso ocurrió]

**Descripción**: [Descripción detallada]

**Error Exacto**:
```
[Mensaje de error]
```

**Causa Raíz**: [Por qué ocurrió]

**Intentos de Solución**:
1. [Intento 1] - Resultado: [Funcionó/No funcionó]
2. [Intento 2] - Resultado: [Funcionó/No funcionó]

**Solución Final**:
```bash
[Comandos que resolvieron]
```

**Lección Aprendida**: [Qué aprendiste]

[Repite para otros problemas importantes]

---

## Conclusiones

### Logros Principales

1. [Logro 1]
2. [Logro 2]
3. [Logro 3]

### Reflexión Personal

[Escribe 2-3 párrafos sobre:
- ¿Qué fue lo más desafiante?
- ¿Qué fue lo más interesante?
- ¿Cómo te ayudará esto en tu carrera?
- ¿Qué harías diferente la próxima vez?]

### Aplicaciones Prácticas

**En el mundo real, este sistema se podría usar para**:
1. [Aplicación 1]
2. [Aplicación 2]
3. [Aplicación 3]

### Habilidades Desarrolladas

- [ ] Administración de contenedores Docker
- [ ] Configuración de sistemas de logging
- [ ] Análisis de logs de seguridad
- [ ] Creación de visualizaciones de datos
- [ ] Detección de amenazas
- [ ] Explotación de vulnerabilidades (ético)
- [ ] Documentación técnica
- [ ] Troubleshooting

---

## Anexos

### Anexo A: Comandos Completos

```bash
# Paso 1: Juice Shop
git checkout paso-1-juice-shop
docker compose up -d
[... todos los comandos ...]

# Paso 2: Elasticsearch
[... todos los comandos ...]

# [Continuar para todos los pasos]
```

### Anexo B: Reglas de Detección (JSON)

```json
[Pega el export de reglas de Kibana]
```

### Anexo C: Dashboard Export

```json
[Pega el export del dashboard]
```

---

## Estadísticas del Proyecto

- **Total de Screenshots**: ___ (mínimo 42)
- **Total de Comandos Ejecutados**: ___
- **Total de Vulnerabilidades Explotadas**: 4
- **Total de Reglas de Detección**: 3
- **Total de Visualizaciones Creadas**: 3
- **Total de Dashboards Creados**: 2
- **Tiempo Total Invertido**: ___ horas

---

## Checklist de Entrega

### Documentación
- [ ] Reporte completo
- [ ] Todos los pasos documentados
- [ ] Screenshots de calidad
- [ ] Comandos con outputs
- [ ] Problemas explicados

### Red Team
- [ ] 4 vulnerabilidades explotadas
- [ ] Cada una con PoC completo
- [ ] CVSS calculado
- [ ] OWASP Top 10 clasificación

### Blue Team
- [ ] 3 reglas configuradas
- [ ] Alertas funcionando
- [ ] Dashboard de detecciones
- [ ] Informe de respuesta

### Archivos
- [ ] reporte-final.pdf o .md
- [ ] screenshots/ organizado
- [ ] comandos.txt
- [ ] reglas-deteccion.json
- [ ] dashboard-export.ndjson

---

**Fin del Reporte**

**Fecha de Entrega**: ___________________________  
**Firma**: ___________________________
