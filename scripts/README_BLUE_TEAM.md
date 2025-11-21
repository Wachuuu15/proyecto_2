# Blue Team Traffic Generator - Instrucciones

Este directorio contiene scripts para generar tráfico legítimo periódicamente (cada 15 minutos) para establecer un baseline en Kibana.

## 📁 Archivos

- **`blue-team-traffic.ps1`**: Script PowerShell para Windows (principal)
- **`blue-team-traffic.sh`**: Script Bash para Linux/Docker (alternativa)
- **`setup-scheduled-task.ps1`**: Script para configurar Task Scheduler en Windows
- **`cron-entry.sh`**: Wrapper para cron en Linux/Docker
- **`logs/`**: Directorio donde se guardan los logs (se crea automáticamente)

## 🪟 Windows (PowerShell) - Método Recomendado

### 1. Ejecución Manual

```powershell
.\scripts\blue-team-traffic.ps1
```

### 2. Configurar Ejecución Automática cada 15 minutos

Ejecuta el siguiente comando **como Administrador**:

```powershell
.\scripts\setup-scheduled-task.ps1
```

Esto creará una tarea programada en Windows Task Scheduler que ejecutará el script automáticamente cada 15 minutos.

### 3. Gestionar la Tarea Programada

**Ver estado:**
```powershell
Get-ScheduledTask -TaskName "BlueTeamTrafficGenerator"
```

**Ejecutar manualmente ahora:**
```powershell
Start-ScheduledTask -TaskName "BlueTeamTrafficGenerator"
```

**Deshabilitar:**
```powershell
Disable-ScheduledTask -TaskName "BlueTeamTrafficGenerator"
```

**Eliminar:**
```powershell
Unregister-ScheduledTask -TaskName "BlueTeamTrafficGenerator" -Confirm:$false
```

## 🐳 Docker (Opcional)

Si prefieres ejecutar el script desde Docker en lugar de Task Scheduler:

1. Descomenta el servicio `blue-team-traffic` en `docker-compose.yml`
2. Inicia el servicio:

```bash
docker-compose up -d blue-team-traffic
```

El contenedor ejecutará el script cada 15 minutos usando cron.

## 📝 Logs

Los logs se guardan en:
- **Windows**: `scripts/logs/juice-blue-team.log`
- **Docker**: `scripts/logs/juice-blue-team.log` (montado como volumen)

Formato de log:
```
2025-11-21 10:22:30 UTC - === INICIO Ejecución Blue Team Traffic ===
2025-11-21 10:22:30 UTC - OK - HTTP 200 - http://localhost:3000
...
2025-11-21 10:22:48 UTC - === FIN Ejecución Blue Team Traffic ===
```

## ✅ Verificación

Para verificar que el tráfico se está generando:

1. Revisa el archivo de log:
   ```powershell
   Get-Content .\scripts\logs\juice-blue-team.log -Tail 20
   ```

2. Verifica en Kibana:
   - Ve a **Discover** en Kibana (http://localhost:5601)
   - Busca logs con `container.name:"juice-shop"` y timestamps recientes
   - Deberías ver peticiones HTTP cada 15 minutos

## 🔧 Endpoints Generados

El script genera tráfico legítimo a estos endpoints:

- `http://localhost:3000` (página principal)
- `http://localhost:3000/#/login` (página de login)
- `http://localhost:3000/rest/products/search?q=apple` (búsqueda de productos)
- `http://localhost:3000/rest/products/search?q=juce` (búsqueda alternativa)
- `http://localhost:3000/api/Products` (API de productos)
- `http://localhost:3000/rest/user/login` (endpoint de login)

## 📌 Notas

- El script espera que Juice Shop esté ejecutándose en `http://localhost:3000`
- Los logs se acumulan en el archivo `juice-blue-team.log`
- Para limpiar logs antiguos, simplemente elimina o renombra el archivo
- La tarea programada se ejecuta incluso cuando el usuario no está conectado (requiere configuración adicional si es necesario)

