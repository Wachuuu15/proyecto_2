# Script de generación de tráfico legítimo para Blue Team
# PowerShell version para Windows

# Obtener el directorio del script (dentro del proyecto)
$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path
$LOG_DIR = Join-Path $SCRIPT_DIR "logs"
$LOG_FILE = Join-Path $LOG_DIR "juice-blue-team.log"

# Crear directorio de logs si no existe
if (-not (Test-Path -Path $LOG_DIR)) {
    New-Item -ItemType Directory -Path $LOG_DIR -Force | Out-Null
    Write-Host "Directorio $LOG_DIR creado exitosamente"
}

# Definir endpoints - Ahora usando el reverse proxy Nginx en puerto 8080
$ENDPOINTS = @(
    "http://localhost:8080"
    "http://localhost:8080/#/login"
    "http://localhost:8080/rest/products/search?q=apple"
    "http://localhost:8080/rest/products/search?q=juce"
    "http://localhost:8080/api/Products"
    "http://localhost:8080/rest/user/login"
)

# Función para registrar mensajes en el log
function Log-Message {
    param(
        [string]$Message
    )
    $timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss UTC")
    $logEntry = "$timestamp - $Message"
    
    # Escribir en el archivo de log
    $logEntry | Out-File -FilePath $LOG_FILE -Append -Encoding UTF8
    
    # También mostrar en consola
    Write-Host $logEntry
}

# Iniciar registro
Log-Message "=== INICIO Ejecución Blue Team Traffic ==="

# Generar tráfico legítimo
foreach ($url in $ENDPOINTS) {
    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -DisableKeepAlive -ErrorAction Stop
        $statusCode = $response.StatusCode
        Log-Message "OK - HTTP $statusCode - $url"
    }
    catch {
        if ($_.Exception.Response) {
            $statusCode = $_.Exception.Response.StatusCode.value__
            Log-Message "WARNING - HTTP $statusCode - $url"
        } else {
            Log-Message "ERROR - No se pudo conectar a $url - $($_.Exception.Message)"
        }
    }
    
    Start-Sleep -Seconds 3
}

# Finalizar registro
Log-Message "=== FIN Ejecución Blue Team Traffic ==="

Write-Host "Blue Team traffic generated - Logs in $LOG_FILE"

