# 🎉 Proyecto Blue y Red Team

## 📊 Resumen Ejecutivo

Este proyecto es una solución educativa profesional e incremental para enseñar el stack ELK (Elasticsearch, Logstash/Filebeat, Kibana) con enfoque a seguridad (Red Team y Blue Team).

### Características Principales

- ✅ **Proyecto acumulativo** con 6 pasos secuenciales
- ✅ **6 ramas Git** independientes (una por cada paso)
- ✅ **15 documentos** de guías y plantillas
- ✅ **4 vulnerabilidades** documentadas (Red Team)
- ✅ **3 reglas de detección** (Blue Team)
- ✅ **Scripts automatizados** incluidos
- ✅ **Plantilla completa** para reporte final

---

## 🌳 Ramas Git Creadas

Cada paso del proyecto tiene su rama, commit y objetivo:

- **paso-1-juice-shop** (`5960de8`)
  - Dockerfile  
  - docker-compose.yml (solo Juice Shop)
  - PASO_1_JUICE_SHOP.md  
  - Documentación base  
  - *Objetivo: Configurar Juice Shop básico*

- **paso-2-elasticsearch** (`693cbe1`)
  - Todo de paso 1 +
  - docker-compose.yml (+ elasticsearch)
  - PASO_2_ELASTICSEARCH.md
  - Red elk-network, volumen elasticsearch-data
  - *Objetivo: Agregar Elasticsearch al stack*

- **paso-3-kibana** (`aa548bd`)
  - Todo de paso 2 +
  - docker-compose.yml (+ kibana)
  - PASO_3_KIBANA.md
  - *Objetivo: Agregar Kibana para visualización*

- **paso-4-filebeat** (`cea1a38`)
  - Todo de paso 3 +
  - docker-compose.yml (+ filebeat)
  - filebeat.yml  
  - PASO_4_FILEBEAT.md  
  - Volumen filebeat-data  
  - *Objetivo: Completar el flujo de datos (ELK completo)*

- **paso-5-visualizacion** (`427d8c8`)
  - Todo de paso 4 +
  - PASO_5_VISUALIZACION_KIBANA.md
  - *Objetivo: Configuración de Kibana para visualizaciones*

- **paso-6-blue-team** (`12eb118`)
  - Todo de paso 5 +
  - scripts/blue-team-traffic.sh  
  - PASO_6_BLUE_TEAM.md  
  - ACTIVIDADES_RED_TEAM.md  
  - *Objetivo: Operaciones defensivas y ofensivas*

---

## 📚 Documentos Creados

### Guías Principales (5)
1. **ESTRATEGIA_RAMAS.md** - Estructura de ramas y flujo
2. **GUIA_DOCUMENTACION.md** - Captura de screenshots (42-58)
3. **PLAN_PRUEBAS.md** - Checklist por paso
4. **PLAN_PROYECTO_ACUMULATIVO.md** - Visión general
5. **INSTRUCCIONES_USO_RAMAS.md** - Uso de ramas Git

### Actividades de Seguridad (2)
6. **ACTIVIDADES_RED_TEAM.md** - Vulnerabilidades, PoC, CVSS
7. **PASO_6_BLUE_TEAM.md** - Reglas, respuesta a incidentes

### Plantillas y Resúmenes (3)
8. **PLANTILLA_DOCUMENTACION_ESTUDIANTE.md** - Reporte final
9. **RESUMEN_PROYECTO_COMPLETO.md** - Resumen final

### Documentación Técnica (5)
10. **PASO_1_JUICE_SHOP.md** - Juice Shop
11. **PASO_2_ELASTICSEARCH.md** - Elasticsearch
12. **PASO_3_KIBANA.md** - Kibana
13. **PASO_4_FILEBEAT.md** - Filebeat
14. **PASO_5_VISUALIZACION_KIBANA.md** - Visualización

---

## 🎯 Contenido por Categoría

### Red Team (Explotación)
**Vulnerabilidades Documentadas (4):**
1. **SQL Injection**
   - PoC en login/búsqueda
   - CVSS: 9.8
   - OWASP: A03:2021
   - Bypass autenticación, extracción de datos
2. **Cross-Site Scripting (XSS)**
   - Reflejado y almacenado
   - CVSS: 6.1-7.1
   - OWASP: A03:2021
   - Robo de cookies/sesiones
3. **Broken Authentication**
   - Password reset predictable, JWT manipulation
   - CVSS: 8.1
   - OWASP: A07:2021
   - Accesos no autorizados
4. **Broken Access Control**
   - IDOR en baskets/perfiles
   - CVSS: 7.5
   - OWASP: A01:2021

### Blue Team (Defensa)
**Reglas de Detección (mínimo 3):**
1. **SQL Injection**  
   - Custom query, severidad alta  
   - Detecta `' OR 1=1`, `UNION SELECT`, etc.
2. **XSS**  
   - Threshold, severidad alta  
   - Detecta `<script>`, `onerror=`, etc.
3. **Scanning/Burst**  
   - >20 errores 4xx/5xx en 2 minutos

**Instrumentación:**
- Script de tráfico legítimo
- CORS/Nginx proxy (opcional)
- Filebeat processors, ingest pipelines
- Dashboards y alertas

---

## 📸 Screenshots Requeridos

| Paso | Mínimo | Recom. | Descripción                        |
|------|--------|--------|-------------------------------------|
| 1    | 4      | 6      | Docker, interfaz web, logs          |
| 2    | 5      | 8      | Elasticsearch, cluster/índices      |
| 3    | 4      | 6      | Kibana, Dev Tools                   |
| 4    | 5      | 8      | Filebeat, logs, índices             |
| 5    | 12     | 15     | Data Views, dashboards              |
| 6    | 12     | 15     | Reglas, ataques, alertas            |
|**Total**|**42**|**58** |                                     |

**Detalle de capturas:**  
Ver **GUIA_DOCUMENTACION.md**: qué y cómo capturar, criterios, ejemplos.

---

## ⏱️ Tiempo Estimado

| Fase                | Tiempo        |
|---------------------|--------------|
| Juice Shop          | 30 min       |
| Elasticsearch       | 45 min       |
| Kibana              | 45 min       |
| Filebeat            | 1 hora       |
| Visualización       | 1.5 horas    |
| Blue Team           | 2 horas      |
| Red Team            | 3 horas      |
| Doc. final          | 2 horas      |
| **TOTAL**           | **~11 horas**|

---

## 🎓 Objetivos de Aprendizaje

**Técnicos**
- Docker y Docker Compose
- Elasticsearch (índices, doc., queries)
- Kibana (visualización, dashboards)
- Filebeat (procesamiento de logs)
- Redes Docker, volúmenes, healthchecks

**Seguridad**
- OWASP Top 10, CVSS v3.1
- SQLi, XSS, Broken Auth, Broken Access Control
- Detección y reglas de seguridad
- Análisis y respuesta a incidentes

**Profesionales**
- Documentación, screenshots
- Troubleshooting
- Git y ramas, metodología incremental

---

## 📦 Entregables

1. **Reporte Final** (PDF/Markdown, plantilla base)
2. **Screenshots** (>=42, organizados por paso, calidad)
3. **Red Team** (4 vulnerabilidades explotadas, PoC, CVSS, OWASP)
4. **Blue Team** (3 reglas, dashboard, respuesta)
5. **Extra:** comandos.txt, dashboard-export.ndjson, reglas-deteccion.json

---

## 🏆 Criterios de Evaluación

- **Completitud (30%)**: 6 pasos, servicios y verificaciones
- **Documentación (30%)**: reportes completos, screenshots, comandos, troubleshooting
- **Comprensión Técnica (25%)**: explicación de arquitectura, decisiones
- **Seguridad (15%)**: explotación, detección y análisis de incidentes

---

## 🛠️ Comandos Útiles

**Git**
```bash
git branch -a             # Ver ramas
git checkout paso-X-nombre  # Cambiar rama
git diff paso-1-juice-shop paso-2-elasticsearch  # Diferencias
git ls-tree --name-only paso-3-kibana            # Archivos de rama
```

**Docker**
```bash
docker compose up -d               # Levantar servicios
docker compose ps                  # Estado
docker compose logs -f <servicio>  # Logs
docker compose down -v             # Limpiar todo
docker stats                       # Recursos
```

**Verificación**
```bash
curl http://localhost:9200/_cluster/health?pretty
curl http://localhost:9200/_cat/indices?v
curl http://localhost:5601/api/status
curl http://localhost:3000
```

---

## 📁 Estructura de Archivos del Proyecto

```
proyecto_2/
├── .git/
├── Dockerfile
├── docker-compose.yml
├── filebeat.yml
├── scripts/
│   └── blue-team-traffic.sh
├── PASO_1_JUICE_SHOP.md
├── PASO_2_ELASTICSEARCH.md
├── PASO_3_KIBANA.md
├── PASO_4_FILEBEAT.md
├── PASO_5_VISUALIZACION_KIBANA.md
├── PASO_6_BLUE_TEAM.md
├── ACTIVIDADES_RED_TEAM.md
├── ESTRATEGIA_RAMAS.md
├── GUIA_DOCUMENTACION.md
├── PLAN_PRUEBAS.md
├── PLAN_PROYECTO_ACUMULATIVO.md
├── INSTRUCCIONES_USO_RAMAS.md
├── PLANTILLA_DOCUMENTACION_ESTUDIANTE.md
├── README_PROYECTO_COMPLETO.md
├── RESUMEN_PROYECTO_COMPLETO.md
└── README.md
```

---

## 🔗 Flujo de Datos Completo

```
┌─────────────┐
│  USUARIO    │
└─────┬───────┘
      │
      │ HTTP
      ▼
┌─────────────┐      stdout/stderr       ┌─────────────┐
│ Juice Shop  │ ───────────────► Docker │ Docker Logs │
│ :3000       │                        └─────┬───────┘
└─────┬───────┘                             │
      │ logs                                │ Archivos .log
      ▼                                     ▼
┌────────────────┐       HTTP POST (JSON) ┌──────────────┐
│   Filebeat     │ ─────────────────────► │ Elasticsearch│
│                │                        │  :9200       │
└────────────────┘                        └─────┬────────┘
      │                                         │
      ▼     Queries                             ▼
┌─────────────┐◄────────────────────────────┐
│   Kibana    │       HTTP                  │
│    :5601    │                             │
└─────────────┘                             │
      │                                     │
      ▼                                     ▼
┌────────────────┐                  ┌──────────────┐
│ Volúmenes      │                  │ Persistencia │
└────────────────┘                  └──────────────┘
```

---

## 📞 Soporte y Contacto

**Para Estudiantes:**
1. Consultar troubleshooting en la documentación de cada paso
2. Revisar PLAN_PRUEBAS.md
3. Consultar documentación oficial
4. Preguntar al instructor
5. Colaborar (sin copiar)

**Para el Instructor:**
- **PLAN_PROYECTO_ACUMULATIVO.md**: Visión y estructura global
- **PLAN_PRUEBAS.md**: Checklist por paso
- **ESTRATEGIA_RAMAS.md**: Git y ramas
- **RESUMEN_PROYECTO_COMPLETO.md**: Este resumen

---

**Creado por:** Sistema de Documentación Automatizada  
**Para:** Proyecto 2 - Sistema Logging ELK Stack  
**Institución:** UVG  
**Curso:** Seguridad en Redes y Sistemas
