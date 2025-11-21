# Script para configurar la tarea programada en Windows Task Scheduler
# Ejecuta el script blue-team-traffic.ps1 cada 15 minutos

$TASK_NAME = "BlueTeamTrafficGenerator"
$SCRIPT_PATH = Join-Path $PSScriptRoot "blue-team-traffic.ps1"

# Verificar que el script existe
if (-not (Test-Path -Path $SCRIPT_PATH)) {
    Write-Error "No se encontró el script: $SCRIPT_PATH"
    exit 1
}

# Obtener la ruta completa del script
$SCRIPT_FULL_PATH = Resolve-Path $SCRIPT_PATH

Write-Host "Configurando tarea programada: $TASK_NAME"
Write-Host "Script a ejecutar: $SCRIPT_FULL_PATH"
Write-Host ""

# Eliminar la tarea si ya existe
$existingTask = Get-ScheduledTask -TaskName $TASK_NAME -ErrorAction SilentlyContinue
if ($existingTask) {
    Write-Host "Eliminando tarea existente..."
    Unregister-ScheduledTask -TaskName $TASK_NAME -Confirm:$false
}

# Crear la acción (ejecutar PowerShell con el script)
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" `
    -Argument "-ExecutionPolicy Bypass -NoProfile -File `"$SCRIPT_FULL_PATH`""

# Crear el trigger (cada 15 minutos, indefinidamente)
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 15) -RepetitionDuration (New-TimeSpan -Days 365)

# Configuración de la tarea
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

# Registrar la tarea (requiere permisos de administrador)
try {
    Register-ScheduledTask -TaskName $TASK_NAME -Action $action -Trigger $trigger -Settings $settings -Description "Genera tráfico legítimo cada 15 minutos para Blue Team baseline" | Out-Null
    
    Write-Host "[OK] Tarea programada creada exitosamente!" -ForegroundColor Green
    Write-Host ""
    Write-Host "La tarea se ejecutará cada 15 minutos automáticamente."
    Write-Host ""
    Write-Host "Comandos útiles:"
    Write-Host "  Ver estado:     Get-ScheduledTask -TaskName $TASK_NAME"
    Write-Host "  Ejecutar ahora: Start-ScheduledTask -TaskName $TASK_NAME"
    Write-Host "  Detener tarea:  Disable-ScheduledTask -TaskName $TASK_NAME"
    Write-Host "  Eliminar tarea: Unregister-ScheduledTask -TaskName $TASK_NAME -Confirm:`$false"
    
} catch {
    Write-Error "Error al crear la tarea programada. Asegúrate de ejecutar PowerShell como Administrador."
    Write-Host ""
    Write-Host "Para ejecutar como administrador:"
    Write-Host "  1. Click derecho en PowerShell"
    Write-Host "  2. Selecciona 'Ejecutar como administrador'"
    Write-Host "  3. Ejecuta este script nuevamente"
    exit 1
}

