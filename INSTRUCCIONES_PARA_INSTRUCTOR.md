# Instrucciones para el Instructor

## 🎯 Proyecto Completado

El proyecto está **100% completo y listo para compartir** con los estudiantes.

---

## 📦 Qué se ha Creado

### 6 Ramas Git (Proyecto Acumulativo)

```
paso-1-juice-shop       → Solo Juice Shop básico
paso-2-elasticsearch    → + Elasticsearch
paso-3-kibana          → + Kibana
paso-4-filebeat        → + Filebeat (sistema completo)
paso-5-visualizacion   → + Guía de visualización
paso-6-blue-team       → + Scripts y operaciones defensivas
```

### 16 Documentos de Guía

1. **ESTRATEGIA_RAMAS.md** - Estructura y flujo de trabajo
2. **GUIA_DOCUMENTACION.md** - Cómo capturar screenshots
3. **PLAN_PRUEBAS.md** - Checklist de verificación
4. **PLAN_PROYECTO_ACUMULATIVO.md** - Visión general
5. **INSTRUCCIONES_USO_RAMAS.md** - Guía de uso de ramas
6. **ACTIVIDADES_RED_TEAM.md** - Explotación de vulnerabilidades
7. **PLANTILLA_DOCUMENTACION_ESTUDIANTE.md** - Plantilla de reporte
8. **README_PROYECTO_COMPLETO.md** - Resumen ejecutivo
9. **RESUMEN_PROYECTO_COMPLETO.md** - Resumen final
10. **INSTRUCCIONES_PARA_INSTRUCTOR.md** - Este documento
11-15. **PASO_X_*.md** - Documentación técnica por paso

---

## 🚀 Pasos para Compartir con Estudiantes

### Opción 1: Subir al Repositorio Remoto (Recomendado)

```bash
cd /Users/admin/Documents/Git/UVG/proyecto_2

# 1. Subir todas las ramas al remoto
git push origin paso-1-juice-shop
git push origin paso-2-elasticsearch
git push origin paso-3-kibana
git push origin paso-4-filebeat
git push origin paso-5-visualizacion
git push origin paso-6-blue-team

# 2. Subir la rama principal con toda la documentación
git push origin feat/juice-kibana

# O si quieres que main tenga todo:
git checkout main
git merge feat/juice-kibana
git push origin main
```

### Opción 2: Crear un Release

En GitHub/GitLab:

1. Ve a "Releases" → "Create a new release"
2. Tag: `v1.0-proyecto-completo`
3. Título: "Proyecto ELK Stack - Versión Completa para Estudiantes"
4. Descripción:
   ```markdown
   # Proyecto 2 - Sistema de Logging con ELK Stack
   
   Proyecto educativo completo con 6 pasos incrementales.
   
   ## Ramas Disponibles
   - paso-1-juice-shop
   - paso-2-elasticsearch
   - paso-3-kibana
   - paso-4-filebeat
   - paso-5-visualizacion
   - paso-6-blue-team
   
   ## Documentación
   Ver README_PROYECTO_COMPLETO.md para instrucciones completas.
   
   ## Inicio Rápido
   ```bash
   git clone <url-del-repositorio>
   cd proyecto_2
   git checkout paso-1-juice-shop
   cat INSTRUCCIONES_USO_RAMAS.md
   ```
   ```

### Opción 3: Compartir ZIP

```bash
cd /Users/admin/Documents/Git/UVG

# Crear ZIP con todo
zip -r proyecto_2_completo.zip proyecto_2/ \
  -x "proyecto_2/.git/*" \
  -x "proyecto_2/.DS_Store"

# Compartir el ZIP con los estudiantes
```

---

## 📧 Comunicación a Estudiantes

### Email/Anuncio Sugerido

```
Asunto: Proyecto 2 - Sistema de Logging con ELK Stack

Estimados estudiantes,

Ya está disponible el Proyecto 2 del curso. Este es un proyecto acumulativo 
que construirán paso a paso.

📚 RECURSOS DISPONIBLES:

1. Repositorio Git: [URL del repositorio]
2. Documentación completa en el repositorio
3. 6 ramas Git (una por cada paso)

🚀 CÓMO EMPEZAR:

1. Clonar el repositorio:
   git clone [URL]
   cd proyecto_2

2. Leer la documentación principal:
   - README_PROYECTO_COMPLETO.md (visión general)
   - INSTRUCCIONES_USO_RAMAS.md (cómo usar las ramas)
   - PLAN_PROYECTO_ACUMULATIVO.md (plan completo)

3. Empezar con el Paso 1:
   git checkout paso-1-juice-shop
   cat PASO_1_JUICE_SHOP.md

📋 ENTREGABLES:

- Reporte completo (usar PLANTILLA_DOCUMENTACION_ESTUDIANTE.md)
- Mínimo 42 screenshots
- 4 vulnerabilidades explotadas (Red Team)
- 3 reglas de detección configuradas (Blue Team)
- Archivos exportados (reglas, dashboard)

⏱️ TIEMPO ESTIMADO: ~11 horas

📅 FECHA DE ENTREGA: [Fecha]

🆘 SOPORTE:

- Cada documento incluye sección de troubleshooting
- Horario de consultas: [Horario]
- Email: [Tu email]

¡Éxito con el proyecto!

[Tu nombre]
```

---

## 🎓 Presentación en Clase

### Diapositivas Sugeridas

#### Diapositiva 1: Título
```
Proyecto 2
Sistema de Logging con ELK Stack
Proyecto Acumulativo - 6 Pasos
```

#### Diapositiva 2: Objetivos
```
Objetivos de Aprendizaje:
✓ Docker y contenedores
✓ Stack ELK (Elasticsearch, Kibana, Filebeat)
✓ Seguridad: Red Team y Blue Team
✓ OWASP Top 10
✓ Documentación técnica profesional
```

#### Diapositiva 3: Estructura
```
6 Pasos Incrementales:

1. Juice Shop básico (30 min)
2. + Elasticsearch (45 min)
3. + Kibana (45 min)
4. + Filebeat (1 hora)
5. + Visualización (1.5 horas)
6. + Blue/Red Team (2 horas)

Total: ~11 horas
```

#### Diapositiva 4: Ramas Git
```
Proyecto Acumulativo con Git:

paso-1-juice-shop
paso-2-elasticsearch
paso-3-kibana
paso-4-filebeat
paso-5-visualizacion
paso-6-blue-team

Cada rama = Un paso completo
```

#### Diapositiva 5: Entregables
```
Qué Entregar:

📄 Reporte completo (plantilla incluida)
📸 Mínimo 42 screenshots
🔴 4 vulnerabilidades (Red Team)
🔵 3 reglas de detección (Blue Team)
📦 Archivos exportados
```

#### Diapositiva 6: Recursos
```
Documentación Incluida:

✓ Guía de uso de ramas
✓ Guía de screenshots
✓ Checklist de verificación
✓ Plantilla de reporte
✓ Troubleshooting por paso
✓ Actividades Red Team
✓ Actividades Blue Team
```

#### Diapositiva 7: Evaluación
```
Criterios de Evaluación:

30% - Completitud (6 pasos)
30% - Documentación (reporte + screenshots)
25% - Comprensión técnica
15% - Seguridad (Red + Blue Team)
```

#### Diapositiva 8: Inicio
```
Cómo Empezar:

1. git clone [URL]
2. cd proyecto_2
3. cat README_PROYECTO_COMPLETO.md
4. cat INSTRUCCIONES_USO_RAMAS.md
5. git checkout paso-1-juice-shop
6. cat PASO_1_JUICE_SHOP.md
7. ¡Empezar!
```

---

## 📊 Seguimiento de Estudiantes

### Checklist de Progreso (Sugerido)

Crear una hoja de cálculo para dar seguimiento:

| Estudiante | Paso 1 | Paso 2 | Paso 3 | Paso 4 | Paso 5 | Paso 6 | Entrega |
|------------|--------|--------|--------|--------|--------|--------|---------|
| Estudiante 1 | ✅ | ✅ | 🔄 | ⏸️ | ⏸️ | ⏸️ | ⏸️ |
| Estudiante 2 | ✅ | ⏸️ | ⏸️ | ⏸️ | ⏸️ | ⏸️ | ⏸️ |

Leyenda:
- ✅ Completado
- 🔄 En progreso
- ⏸️ No iniciado
- ❌ Problemas

### Puntos de Revisión

Sugerencia de checkpoints:

1. **Semana 1**: Pasos 1-3 completados
2. **Semana 2**: Pasos 4-5 completados
3. **Semana 3**: Paso 6 y documentación
4. **Semana 4**: Entrega final

---

## 🆘 Preguntas Frecuentes (Anticipadas)

### Para Responder a Estudiantes

**P: ¿Tengo que hacer todos los pasos?**
R: Sí, es un proyecto acumulativo. Cada paso construye sobre el anterior.

**P: ¿Puedo saltar pasos?**
R: No, debes seguir el orden. Cada paso es prerequisito del siguiente.

**P: ¿Cuántos screenshots necesito?**
R: Mínimo 42, recomendado 58. Ver GUIA_DOCUMENTACION.md para detalles.

**P: ¿Qué pasa si no puedo hacer que funcione un paso?**
R: Consulta el troubleshooting en el documento del paso, revisa PLAN_PRUEBAS.md, y pregunta en clase.

**P: ¿Puedo trabajar en equipo?**
R: Pueden colaborar y discutir, pero cada uno debe entregar su propio reporte y screenshots.

**P: ¿Qué formato debe tener el reporte?**
R: Usa PLANTILLA_DOCUMENTACION_ESTUDIANTE.md. Puede ser Markdown o PDF.

**P: ¿Necesito explotar las 4 vulnerabilidades?**
R: Sí, mínimo 4. Ver ACTIVIDADES_RED_TEAM.md para guía completa.

**P: ¿Cómo configuro las reglas de detección?**
R: Ver PASO_6_BLUE_TEAM.md para instrucciones paso a paso.

**P: Mi puerto 3000 está ocupado, ¿qué hago?**
R: Ver troubleshooting en PASO_1_JUICE_SHOP.md o cambiar el puerto en docker-compose.yml.

**P: ¿Puedo usar mi propia máquina o necesito un servidor?**
R: Puedes usar tu máquina local. Requisitos: Docker, 4GB RAM, 10GB disco.

---

## 🔧 Verificación del Proyecto

### Antes de Compartir con Estudiantes

```bash
cd /Users/admin/Documents/Git/UVG/proyecto_2

# 1. Verificar que todas las ramas existen
git branch -a | grep paso-

# Deberías ver:
# paso-1-juice-shop
# paso-2-elasticsearch
# paso-3-kibana
# paso-4-filebeat
# paso-5-visualizacion
# paso-6-blue-team

# 2. Probar cada rama rápidamente
for branch in paso-1-juice-shop paso-2-elasticsearch paso-3-kibana; do
  echo "=== Probando $branch ==="
  git checkout $branch
  ls -la | grep -E '\.(md|yml|sh)$'
  echo ""
done

# 3. Verificar documentos principales
git checkout feat/juice-kibana  # o main
ls -la *.md

# Deberías ver todos los documentos de guía

# 4. Verificar que no hay archivos sensibles
git log --all --pretty=format: --name-only | sort -u | grep -E '\.(env|secret|key|password)'

# No debería mostrar nada
```

### Probar el Flujo Completo (Opcional)

```bash
# Probar paso 1
git checkout paso-1-juice-shop
docker compose up -d
sleep 10
curl http://localhost:3000
docker compose down -v

# Probar paso 2
git checkout paso-2-elasticsearch
docker compose up -d
sleep 30
curl http://localhost:9200/_cluster/health
docker compose down -v

# Etc...
```

---

## 📝 Rúbrica de Evaluación (Sugerida)

### Completitud (30 puntos)

| Criterio | Puntos | Descripción |
|----------|--------|-------------|
| Paso 1 completado | 3 | Juice Shop funcionando |
| Paso 2 completado | 4 | Elasticsearch funcionando |
| Paso 3 completado | 4 | Kibana funcionando |
| Paso 4 completado | 6 | Filebeat enviando logs |
| Paso 5 completado | 6 | Visualizaciones creadas |
| Paso 6 completado | 7 | Reglas y ataques documentados |

### Documentación (30 puntos)

| Criterio | Puntos | Descripción |
|----------|--------|-------------|
| Reporte completo | 10 | Todos los pasos documentados |
| Screenshots | 10 | Mínimo 42, legibles, organizados |
| Comandos documentados | 5 | Con outputs |
| Problemas y soluciones | 5 | Bien explicados |

### Comprensión Técnica (25 puntos)

| Criterio | Puntos | Descripción |
|----------|--------|-------------|
| Explicación de conceptos | 8 | Clara y correcta |
| Análisis de arquitectura | 7 | Flujo de datos explicado |
| Decisiones justificadas | 5 | Por qué se hizo así |
| Reflexión personal | 5 | Aprendizajes |

### Seguridad (15 puntos)

| Criterio | Puntos | Descripción |
|----------|--------|-------------|
| Red Team (4 vulnerabilidades) | 7 | Con PoC y CVSS |
| Blue Team (3 reglas) | 5 | Funcionando |
| Análisis de incidentes | 3 | Informe completo |

**Total**: 100 puntos

---

## 🎯 Consejos para la Implementación

### Semana 1: Introducción
- Presentar el proyecto
- Explicar la estructura de ramas
- Hacer demo del Paso 1 en clase
- Asignar Pasos 1-2 como tarea

### Semana 2: Progreso
- Revisar Pasos 1-2
- Hacer demo del Paso 3 en clase
- Resolver dudas comunes
- Asignar Pasos 3-4 como tarea

### Semana 3: Visualización
- Revisar Pasos 3-4
- Demo de Kibana (Paso 5)
- Introducir conceptos de seguridad
- Asignar Paso 5 como tarea

### Semana 4: Seguridad
- Revisar Paso 5
- Demo de Red Team y Blue Team
- Explicar entregables finales
- Asignar Paso 6 y documentación final

### Semana 5: Entrega
- Sesión de preguntas y respuestas
- Revisión final
- Entrega del proyecto
- Retroalimentación

---

## 📚 Recursos Adicionales para Ti

### Para Profundizar

- [Elastic Stack Documentation](https://www.elastic.co/guide/index.html)
- [Docker Documentation](https://docs.docker.com/)
- [OWASP Juice Shop Solutions](https://pwning.owasp-juice.shop/)
- [OWASP Top 10](https://owasp.org/Top10/)

### Para Actualizar el Proyecto

Si quieres agregar más contenido en el futuro:

```bash
# Crear una nueva rama
git checkout paso-6-blue-team
git checkout -b paso-7-nombre-nuevo

# Agregar contenido
# ...

# Commit
git add -A
git commit -m "feat(paso-7): Descripción"

# Subir
git push origin paso-7-nombre-nuevo
```

---

## ✅ Checklist Final para Ti

Antes de compartir con estudiantes:

- [ ] Todas las ramas creadas y probadas
- [ ] Documentación revisada
- [ ] Sin información sensible en el repo
- [ ] README actualizado
- [ ] Ramas subidas al remoto
- [ ] Release creado (opcional)
- [ ] Email/anuncio preparado
- [ ] Presentación lista
- [ ] Rúbrica definida
- [ ] Horarios de consulta establecidos

---

## 🎉 ¡Listo para Implementar!

El proyecto está completamente preparado y documentado. Los estudiantes tienen todo lo necesario para:

✅ Entender el proyecto  
✅ Seguir los pasos  
✅ Resolver problemas  
✅ Documentar su trabajo  
✅ Entregar un proyecto profesional  

**¡Éxito con la implementación del proyecto!** 🚀

---

**Fecha**: 2025-11-10  
**Versión**: 1.0  
**Estado**: ✅ LISTO PARA COMPARTIR
