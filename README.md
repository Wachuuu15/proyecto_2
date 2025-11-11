# Proyecto 2 - Sistema de Logging con ELK Stack

## 📜 ¿Qué es este proyecto?

Este es un **proyecto acumulativo** donde construirás paso a paso un sistema profesional de monitoreo y logging usando el **ELK Stack** (Elasticsearch, Kibana, Filebeat) con **OWASP Juice Shop** como aplicación de prueba.

<details>
  <summary><strong>¿Qué aprenderás?</strong></summary>

- ✅ **Docker y contenedores**: Orquestación con Docker Compose  
- ✅ **ELK Stack**: Elasticsearch, Kibana, Filebeat  
- ✅ **Seguridad**: Red Team (explotación) y Blue Team (detección)  
- ✅ **OWASP Top 10**: SQL Injection, XSS, Broken Auth, Access Control  
- ✅ **Documentación técnica**: Cómo documentar proyectos profesionalmente

</details>

   <details>
   <summary><strong>¿Qué construirás?</strong></summary>

   Un sistema completo que:
   1. Recolecta logs de aplicaciones Docker en tiempo real
   2. Almacena y indexa logs en Elasticsearch
   3. Visualiza logs en dashboards de Kibana
   4. Detecta ataques de seguridad automáticamente

   </details>

---

## 🎯 Estructura del Proyecto

<details>
<summary><strong>6 Pasos Incrementales</strong></summary>

El proyecto está dividido en **6 pasos** que debes completar en orden. Cada paso construye sobre el anterior:

```
Paso 1: Juice Shop Básico          (30 min)
   ↓
Paso 2: + Elasticsearch             (45 min)
   ↓
Paso 3: + Kibana                    (45 min)
   ↓
Paso 4: + Filebeat                  (1 hora) ← Sistema ELK completo
   ↓
Paso 5: + Visualización             (1.5 horas)
   ↓
Paso 6: + Blue Team & Red Team      (2 horas)
```

**Tiempo total estimado**: ~6-7 horas

</details>

<details>
<summary><strong>Ramas Git</strong></summary>

Cada paso tiene su propia rama Git:

```bash
git checkout paso-1-juice-shop       # Empezar aquí
git checkout paso-2-elasticsearch
git checkout paso-3-kibana
git checkout paso-4-filebeat
git checkout paso-5-visualizacion
git checkout paso-6-blue-team
```
</details>


---

## 📦 Requisitos


<details>
<summary><strong>Software Necesario</strong></summary>

- **Docker**: Versión 20.10+
- **Docker Compose**: Versión 2.0+
- **Git**: Versión 2.30+
- **Navegador web**: Chrome, Firefox o Safari
- **curl**: Para pruebas de API (viene instalado en macOS/Linux)

</details>

<details>
<summary><strong>Recursos de Sistema</strong></summary>

- **RAM**: Mínimo 4GB, recomendado 8GB
- **Disco**: Mínimo 10GB libres
- **CPU**: 2 cores mínimo
- **Puertos libres**: 3000, 5601, 9200, 9300

</details>

<details>
<summary><strong>Verificar Instalación</strong></summary>

```bash
# Docker
docker --version
# Debe mostrar: Docker version 20.10.x o superior

# Docker Compose
docker compose version
# Debe mostrar: Docker Compose version v2.x.x o superior

# Git
git --version
# Debe mostrar: git version 2.30.x o superior
```
</details>


---

## 🚀 Inicio Rápido



<details>
<summary><strong>1. Clonar el Repositorio</strong></summary>

```bash
git clone <url-del-repositorio>
cd proyecto_2
```
</details>

<details>
<summary><strong>2. Leer las Instrucciones</strong></summary>

```bash
# Lee este archivo primero
cat README.md

# Luego lee las instrucciones detalladas
cat INSTRUCCIONES.md
```
</details>

<details>
<summary><strong>3. Empezar con el Paso 1</strong></summary>

```bash
# Cambiar a la rama del paso 1
git checkout paso-1-juice-shop

# Leer la documentación del paso
cat PASO_1_JUICE_SHOP.md

# Seguir las instrucciones en INSTRUCCIONES.md
```
</details>


---

## 📚 Documentos del Proyecto


<details>
<summary><strong>⭐ 3 Archivos Principales (DEBES LEER):</strong></summary>

| Archivo | Propósito | Cuándo leerlo |
|---------|-----------|---------------|
| **README.md** (este archivo) | ¿Qué es el proyecto? | PRIMERO, antes de empezar |
| **INSTRUCCIONES.md** | ¿Cómo completarlo paso a paso? | Durante todo el proyecto |
| **PLANTILLA_REPORTE.md** | ¿Qué entregar? | Mientras documentas |

</details>

<details>
<summary><strong>📖 Documentación Técnica por Paso</strong></summary>

- `PASO_1_JUICE_SHOP.md` - Configuración de Juice Shop
- `PASO_2_ELASTICSEARCH.md` - Implementación de Elasticsearch
- `PASO_3_KIBANA.md` - Configuración de Kibana
- `PASO_4_FILEBEAT.md` - Integración con Filebeat
- `PASO_5_VISUALIZACION_KIBANA.md` - Visualizaciones y dashboards
- `PASO_6_BLUE_TEAM.md` - Operaciones defensivas
- `ACTIVIDADES_RED_TEAM.md` - Explotación de vulnerabilidades

**Nota**: Lee estos documentos cuando estés en ese paso específico para profundizar conceptos.

</details>

---

## 🎯 Flujo de Trabajo Recomendado


```
1. README.md (este archivo)
   ↓
2. INSTRUCCIONES.md (Paso 1)
   ↓
3. PASO_1_JUICE_SHOP.md (profundizar)
   ↓
4. Ejecutar comandos del Paso 1
   ↓
5. Documentar en PLANTILLA_REPORTE.md
   ↓
6. Repetir pasos 2-5 para Pasos 2-6
```

---

## 📋 Entregables



### Qué debes entregar:

<details>
<summary><strong>1. Reporte Final (usando PLANTILLA_REPORTE.md)</strong></summary>

- Formato: PDF o Markdown
- Todos los 6 pasos documentados
- Análisis técnico completo

</details>

<details>
<summary><strong>2. Screenshots (mínimo 42)</strong></summary>

- Paso 1: 4 screenshots
- Paso 2: 5 screenshots
- Paso 3: 4 screenshots
- Paso 4: 5 screenshots
- Paso 5: 12 screenshots
- Paso 6: 12 screenshots
- Organizados por paso, legibles y profesionales

</details>

<details>
<summary><strong>3. Red Team (4 vulnerabilidades)</strong></summary>

- SQL Injection
- Cross-Site Scripting (XSS)
- Broken Authentication
- Broken Access Control
- Cada una con PoC reproducible y CVSS v3.1

</details>

<details>
<summary><strong>4. Blue Team (3 reglas de detección)</strong></summary>

- Detección de SQLi
- Detección de XSS
- Detección de Scanning/Burst
- Dashboard de detecciones

</details>

<details>
<summary><strong>5. Archivos Adicionales</strong></summary>

- `comandos.txt` - Todos los comandos ejecutados
- `reglas-deteccion.json` - Reglas exportadas de Kibana
- `dashboard-export.ndjson` - Dashboard exportado

</details>

---

## 🏗️ Arquitectura del Sistema

<details>
<summary>Mostrar/Ocultar contenido</summary>

```
┌─────────────────────────────────────────────────────────────────┐
│                         USUARIO                                 │
│  1. Usa Juice Shop → Genera logs                               │
│  2. Abre Kibana → Ve logs en tiempo real                       │
│  3. Red Team → Explota vulnerabilidades                        │
│  4. Blue Team → Detecta y responde                             │
└─────────────────────────────────────────────────────────────────┘
             │                                 │
             │ HTTP                            │ HTTP
             │                                 │
┌──────────────────┐            ┌──────────────────────┐
│   Juice Shop     │            │   Kibana             │
│   Puerto 3000    │            │   Puerto 5601        │
└──────────────────┘            └──────────────────────┘
           │                                   │
           │ stdout/stderr                     │ Queries
           │                                   │
┌──────────────────┐                           │
│  Docker Engine   │                           │
│  Captura logs    │                           │
└──────────────────┘                           │
           │                                   │
           │ Archivos .log                     │
           │                                   │
┌──────────────────┐                           │
│   Filebeat       │                           │
│   Recolecta      │                           │
│   Procesa        │                           │
│   Enriquece      │                           │
└──────────────────┘                           │
           │                                   │
           │ HTTP POST (JSON)                  │
           │                                   │
┌──────────────────┐                           │
│   Elasticsearch  │◄──────────────────────────┘
│   Puerto 9200    │
│   Indexa         │
│   Almacena       │
└──────────────────┘
           │
┌──────────────────┐
│  Volúmenes       │
│  Persistencia    │
└──────────────────┘
```
</details>

---

## 🎓 Criterios de Evaluación



<details>
<summary><strong>Completitud (30%)</strong></summary>

- Todos los 6 pasos completados
- Todos los servicios funcionando
- Todas las verificaciones pasadas

</details>

<details>
<summary><strong>Documentación (30%)</strong></summary>

- Reporte completo y bien estructurado
- Mínimo 42 screenshots de calidad
- Comandos documentados con outputs
- Problemas y soluciones explicados

</details>

<details>
<summary><strong>Comprensión Técnica (25%)</strong></summary>

- Explicación clara de conceptos
- Análisis de arquitectura
- Entendimiento del flujo de datos
- Decisiones de diseño justificadas

</details>

<details>
<summary><strong>Seguridad (15%)</strong></summary>

- 4 vulnerabilidades explotadas (Red Team)
- 3 reglas de detección configuradas (Blue Team)
- Análisis de incidentes
- Informe de respuesta

</details>

---

## 🆘 ¿Necesitas Ayuda?

<summary>Mostrar/Ocultar contenido</summary>

<details>
<summary><strong>Troubleshooting</strong></summary>

Cada documento PASO_X.md incluye una sección de troubleshooting con problemas comunes y soluciones.

Ver también: **INSTRUCCIONES.md** sección "Problemas Comunes"

</details>

<details>
<summary><strong>Comandos Útiles</strong></summary>

```bash
# Ver estado de servicios
docker compose ps

# Ver logs
docker compose logs -f <servicio>

# Reiniciar servicio
docker compose restart <servicio>

# Limpiar todo
docker compose down -v

# Verificar Elasticsearch
curl http://localhost:9200/_cluster/health?pretty

# Verificar Kibana
curl http://localhost:5601/api/status

# Ver índices
curl http://localhost:9200/_cat/indices?v
```
</details>

<details>
<summary><strong>Recursos Adicionales</strong></summary>

- [Docker Documentation](https://docs.docker.com/)
- [Elasticsearch Guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
- [Kibana Guide](https://www.elastic.co/guide/en/kibana/current/index.html)
- [Filebeat Reference](https://www.elastic.co/guide/en/beats/filebeat/current/index.html)
- [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/)
- [OWASP Top 10](https://owasp.org/Top10/)
- [CVSS Calculator](https://www.first.org/cvss/calculator/3.1)

</details>

---

## ✅ Checklist Rápido


<details>
<summary><strong>Antes de empezar:</strong></summary>

- [ ] Docker y Docker Compose instalados
- [ ] Git instalado
- [ ] Puertos 3000, 5601, 9200 libres
- [ ] Mínimo 4GB RAM disponible
- [ ] Leído README.md (este archivo)
- [ ] Leído INSTRUCCIONES.md
- [ ] Descargado PLANTILLA_REPORTE.md

</details>

<details>
<summary><strong>Durante el proyecto:</strong></summary>

- [ ] Paso 1 completado y documentado
- [ ] Paso 2 completado y documentado
- [ ] Paso 3 completado y documentado
- [ ] Paso 4 completado y documentado
- [ ] Paso 5 completado y documentado
- [ ] Paso 6 completado y documentado

</details>

<details>
<summary><strong>Antes de entregar:</strong></summary>

- [ ] Reporte completo (mínimo 42 screenshots)
- [ ] 4 vulnerabilidades explotadas
- [ ] 3 reglas de detección configuradas
- [ ] Archivos exportados (reglas, dashboard)
- [ ] Revisado ortografía y formato

</details>

---

## 🚀 ¡Empecemos!


```bash
# 1. Lee las instrucciones completas
cat INSTRUCCIONES.md

# 2. Cambia a la rama del paso 1
git checkout paso-1-juice-shop

# 3. Lee la documentación del paso 1
cat PASO_1_JUICE_SHOP.md

# 4. ¡Empieza a construir!
docker compose up -d
```

---

## 📞 Contacto


Si tienes preguntas:
- Consulta INSTRUCCIONES.md (sección Troubleshooting)
- Revisa la documentación del paso correspondiente


---

## 🎓 Estructura del Repositorio


```
proyecto_2/
├── README.md ⭐ LEER PRIMERO
├── INSTRUCCIONES.md ⭐ SEGUIR PASO A PASO
├── PLANTILLA_REPORTE.md ⭐ USAR PARA DOCUMENTAR
│
├── PASO_1_JUICE_SHOP.md
├── PASO_2_ELASTICSEARCH.md
├── PASO_3_KIBANA.md
├── PASO_4_FILEBEAT.md
├── PASO_5_VISUALIZACION_KIBANA.md
├── PASO_6_BLUE_TEAM.md
├── ACTIVIDADES_RED_TEAM.md
│
├── Dockerfile
├── docker-compose.yml
├── filebeat.yml
└── scripts/
    └── blue-team-traffic.sh

Ramas Git:
├── paso-1-juice-shop
├── paso-2-elasticsearch
├── paso-3-kibana
├── paso-4-filebeat
├── paso-5-visualizacion
└── paso-6-blue-team
```

