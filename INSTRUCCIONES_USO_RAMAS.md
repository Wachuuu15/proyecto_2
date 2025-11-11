# Instrucciones de Uso de Ramas - Proyecto Acumulativo

## 🎯 Objetivo

Este proyecto está organizado en **6 ramas Git** que representan los pasos incrementales del proyecto. Cada rama contiene solo los archivos necesarios para ese paso específico.

## 🌳 Ramas Disponibles

```
paso-1-juice-shop       → Solo Juice Shop básico
paso-2-elasticsearch    → + Elasticsearch
paso-3-kibana          → + Kibana
paso-4-filebeat        → + Filebeat (sistema completo)
paso-5-visualizacion   → + Guía de visualización
paso-6-blue-team       → + Scripts y operaciones defensivas
```

## 📋 Flujo de Trabajo Recomendado

### Paso 1: Juice Shop Básico

```bash
# 1. Cambiar a la rama del paso 1
git checkout paso-1-juice-shop

# 2. Ver qué archivos hay
ls -la

# Deberías ver:
# - Dockerfile
# - docker-compose.yml (solo juice-shop)
# - PASO_1_JUICE_SHOP.md
# - Documentación de guías (ESTRATEGIA_RAMAS.md, GUIA_DOCUMENTACION.md, etc.)

# 3. Leer la documentación
cat PASO_1_JUICE_SHOP.md

# 4. Seguir las instrucciones del PLAN_PRUEBAS.md
cat PLAN_PRUEBAS.md | grep -A 50 "PASO 1"

# 5. Levantar el servicio
docker compose up -d

# 6. Verificar
docker compose ps
curl http://localhost:3000

# 7. Capturar screenshots según GUIA_DOCUMENTACION.md

# 8. Documentar en tu reporte usando PLANTILLA_DOCUMENTACION_ESTUDIANTE.md

# 9. IMPORTANTE: Limpiar antes de pasar al siguiente paso
docker compose down -v

# 10. Verificar que todo está limpio
docker compose ps
docker volume ls
```

### Paso 2: Agregar Elasticsearch

```bash
# 1. Cambiar a la rama del paso 2
git checkout paso-2-elasticsearch

# 2. Ver qué cambió respecto al paso anterior
git diff paso-1-juice-shop paso-2-elasticsearch

# Verás que se agregó:
# - Servicio elasticsearch en docker-compose.yml
# - Red elk-network
# - Volumen elasticsearch-data
# - PASO_2_ELASTICSEARCH.md

# 3. Leer la documentación
cat PASO_2_ELASTICSEARCH.md

# 4. Levantar servicios
docker compose up -d

# 5. Verificar
docker compose ps
curl http://localhost:9200/_cluster/health?pretty

# 6. Seguir las pruebas del PLAN_PRUEBAS.md

# 7. Capturar screenshots

# 8. Documentar en tu reporte

# 9. Limpiar antes de continuar
docker compose down -v
```

### Paso 3: Agregar Kibana

```bash
# 1. Cambiar a la rama del paso 3
git checkout paso-3-kibana

# 2. Ver cambios
git diff paso-2-elasticsearch paso-3-kibana

# 3. Leer documentación
cat PASO_3_KIBANA.md

# 4. Levantar servicios
docker compose up -d

# 5. Verificar (esperar 1-2 minutos)
docker compose ps
curl http://localhost:5601/api/status

# 6. Abrir en navegador
open http://localhost:5601  # macOS
# o visitar http://localhost:5601 en tu navegador

# 7. Seguir pruebas, capturar screenshots, documentar

# 8. Limpiar
docker compose down -v
```

### Paso 4: Agregar Filebeat (Sistema Completo)

```bash
# 1. Cambiar a la rama del paso 4
git checkout paso-4-filebeat

# 2. Ver cambios
git diff paso-3-kibana paso-4-filebeat

# Verás que se agregó:
# - Servicio filebeat en docker-compose.yml
# - filebeat.yml (configuración)
# - Volumen filebeat-data

# 3. Leer documentación
cat PASO_4_FILEBEAT.md

# 4. Levantar servicios
docker compose up -d

# 5. Esperar que todos inicien (2-3 minutos)
docker compose ps

# 6. Generar tráfico
for i in {1..20}; do 
  curl -s http://localhost:3000 > /dev/null
  echo "Request $i"
  sleep 1
done

# 7. Esperar procesamiento (30-60 segundos)
sleep 60

# 8. Verificar índices
curl "http://localhost:9200/_cat/indices?v" | grep filebeat

# 9. Ver un log
curl "http://localhost:9200/filebeat-juice-shop-*/_search?size=1&pretty"

# 10. Seguir pruebas, capturar screenshots, documentar

# 11. NO LIMPIAR AÚN (necesitamos los datos para el paso 5)
```

### Paso 5: Visualización en Kibana

```bash
# 1. Cambiar a la rama del paso 5
git checkout paso-5-visualizacion

# IMPORTANTE: NO hacer docker compose down -v
# Los servicios deben seguir corriendo con los datos del paso 4

# 2. Leer documentación
cat PASO_5_VISUALIZACION_KIBANA.md

# 3. Verificar que los servicios están corriendo
docker compose ps

# Si no están corriendo:
docker compose up -d

# 4. Abrir Kibana
open http://localhost:5601

# 5. Seguir la guía paso a paso:
#    - Crear Data Views
#    - Usar Discover
#    - Crear visualizaciones
#    - Armar dashboard
#    - Probar Dev Tools

# 6. Capturar MUCHOS screenshots (mínimo 12)

# 7. Documentar en tu reporte

# 8. NO LIMPIAR AÚN (necesitamos para el paso 6)
```

### Paso 6: Blue Team y Red Team

```bash
# 1. Cambiar a la rama del paso 6
git checkout paso-6-blue-team

# Los servicios deben seguir corriendo

# 2. Leer documentación
cat PASO_6_BLUE_TEAM.md
cat ACTIVIDADES_RED_TEAM.md

# 3. Ejecutar script de tráfico legítimo
chmod +x scripts/blue-team-traffic.sh
./scripts/blue-team-traffic.sh

# 4. Configurar reglas de detección en Kibana
# (Seguir PASO_6_BLUE_TEAM.md)

# 5. Ejecutar ataques (Red Team)
# (Seguir ACTIVIDADES_RED_TEAM.md)

# Ejemplo de ataque SQLi:
curl "http://localhost:3000/rest/products/search?q=' OR 1=1 --"

# 6. Verificar alertas en Kibana
open http://localhost:5601

# 7. Capturar screenshots de:
#    - Reglas configuradas
#    - Ataques ejecutados
#    - Alertas generadas
#    - Dashboard de detecciones

# 8. Documentar todo en tu reporte

# 9. Ahora sí, limpiar todo
docker compose down -v
```

## 📸 Captura de Screenshots

### Por Cada Paso

Consulta **GUIA_DOCUMENTACION.md** para la lista completa de screenshots a capturar.

**Mínimos por paso**:
- Paso 1: 4 screenshots
- Paso 2: 5 screenshots
- Paso 3: 4 screenshots
- Paso 4: 5 screenshots
- Paso 5: 12 screenshots
- Paso 6: 12 screenshots

**Total mínimo**: 42 screenshots

### Organización Sugerida

```
tu-proyecto/
├── documentacion/
│   ├── reporte-final.md (o .pdf)
│   └── screenshots/
│       ├── paso-1/
│       │   ├── 01-docker-compose-ps.png
│       │   ├── 02-interfaz-web.png
│       │   └── ...
│       ├── paso-2/
│       ├── paso-3/
│       ├── paso-4/
│       ├── paso-5/
│       └── paso-6/
└── proyecto_2/ (repositorio clonado)
```

## ✅ Checklist de Verificación

### Antes de Cambiar de Rama

- [ ] He completado todas las pruebas del paso actual
- [ ] He capturado todos los screenshots requeridos
- [ ] He documentado el paso en mi reporte
- [ ] He verificado el checklist del PLAN_PRUEBAS.md
- [ ] He ejecutado `docker compose down -v` (excepto entre pasos 4-5-6)

### Antes de Entregar

- [ ] He completado los 6 pasos
- [ ] Tengo mínimo 42 screenshots
- [ ] Mi reporte está completo usando la plantilla
- [ ] He documentado 4 vulnerabilidades (Red Team)
- [ ] He configurado 3 reglas de detección (Blue Team)
- [ ] He exportado las reglas de Kibana
- [ ] He exportado el dashboard
- [ ] He revisado ortografía y formato

## 🔍 Comandos Útiles

### Ver Diferencias Entre Pasos

```bash
# Ver qué cambió entre dos pasos
git diff paso-1-juice-shop paso-2-elasticsearch

# Ver solo nombres de archivos que cambiaron
git diff --name-only paso-2-elasticsearch paso-3-kibana

# Ver cambios en un archivo específico
git diff paso-3-kibana paso-4-filebeat -- docker-compose.yml
```

### Ver Archivos de una Rama Sin Cambiar a Ella

```bash
# Ver archivos en una rama
git ls-tree --name-only paso-3-kibana

# Ver contenido de un archivo en otra rama
git show paso-4-filebeat:filebeat.yml
```

### Ver Historial de Commits

```bash
# Ver commits de todas las ramas
git log --all --graph --oneline --decorate

# Ver commits de una rama específica
git log paso-2-elasticsearch --oneline
```

## 🆘 Troubleshooting

### Problema: "Changes would be overwritten"

```bash
# Guardar cambios locales
git stash

# Cambiar de rama
git checkout paso-X-nombre

# Si necesitas recuperar los cambios
git stash pop
```

### Problema: Servicios del paso anterior aún corriendo

```bash
# Detener y eliminar todo
docker compose down -v

# Verificar que no quede nada
docker compose ps
docker volume ls | grep proyecto
docker network ls | grep elk
```

### Problema: No puedo ver los cambios entre ramas

```bash
# Asegúrate de estar en el directorio correcto
cd /ruta/al/proyecto_2

# Verifica que las ramas existen
git branch -a

# Usa el comando diff correcto
git diff rama-origen rama-destino
```

### Problema: Puerto ya en uso

```bash
# Ver qué está usando el puerto
lsof -i :3000  # o :5601, :9200

# Detener el proceso
kill -9 <PID>

# O cambiar el puerto en docker-compose.yml
```

## 📚 Documentos de Referencia

| Documento | Cuándo Consultarlo |
|-----------|-------------------|
| **ESTRATEGIA_RAMAS.md** | Al inicio, para entender la estructura |
| **GUIA_DOCUMENTACION.md** | Antes de capturar cada screenshot |
| **PLAN_PRUEBAS.md** | Durante cada paso, para verificar |
| **PLAN_PROYECTO_ACUMULATIVO.md** | Para visión general del proyecto |
| **PLANTILLA_DOCUMENTACION_ESTUDIANTE.md** | Al documentar cada paso |
| **PASO_X_*.md** | Documentación técnica de cada paso |
| **ACTIVIDADES_RED_TEAM.md** | Para explotación de vulnerabilidades |
| **README_PROYECTO_COMPLETO.md** | Resumen ejecutivo del proyecto |

## 💡 Tips de Éxito

1. **Lee primero, ejecuta después**: Lee toda la documentación del paso antes de ejecutar comandos

2. **Captura en tiempo real**: Toma screenshots mientras ejecutas, no después

3. **Documenta errores**: Los problemas y sus soluciones son valiosos

4. **Verifica cada paso**: Usa los checklists del PLAN_PRUEBAS.md

5. **Organiza tus archivos**: Usa la estructura de carpetas sugerida

6. **No mezcles pasos**: Completa un paso antes de pasar al siguiente

7. **Limpia entre pasos**: Ejecuta `docker compose down -v` (excepto 4-5-6)

8. **Pregunta temprano**: No te atasques por horas, pide ayuda

9. **Guarda backups**: Haz copias de tus screenshots y documentación

10. **Revisa antes de entregar**: Usa el checklist final

## 🎓 Aprendizaje Esperado

Al completar todos los pasos, deberías poder:

- ✅ Explicar cómo funciona el stack ELK
- ✅ Configurar un sistema de logging desde cero
- ✅ Crear visualizaciones en Kibana
- ✅ Detectar amenazas usando reglas
- ✅ Explotar vulnerabilidades (éticamente)
- ✅ Analizar logs de seguridad
- ✅ Documentar proyectos técnicos
- ✅ Resolver problemas de forma autónoma
- ✅ Trabajar con Git y ramas
- ✅ Usar Docker y contenedores

## 📞 Soporte

Si tienes problemas:

1. **Consulta el troubleshooting** del documento correspondiente
2. **Revisa el PLAN_PRUEBAS.md** para ese paso
3. **Busca en la documentación oficial** de la herramienta
4. **Pregunta al instructor** en horario de clase
5. **Colabora con compañeros** (sin copiar)

---

**¡Buena suerte con tu proyecto!** 🚀✨

**Recuerda**: Este es un proyecto de aprendizaje. Los errores son oportunidades para entender mejor. Documenta todo, pregunta cuando tengas dudas, y disfruta construyendo un sistema profesional.

---

**Última actualización**: 2025-11-10  
**Versión**: 1.0
