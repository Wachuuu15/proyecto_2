# Script para crear service account token para Kibana
# Ejecutar después de que Elasticsearch esté disponible

$ELASTICSEARCH_HOST = if ($env:ELASTICSEARCH_HOST) { $env:ELASTICSEARCH_HOST } else { "http://localhost:9200" }
$ELASTIC_USER = "elastic"
$ELASTIC_PASSWORD = "changeme"

Write-Host "Creando service account token para Kibana..." -ForegroundColor Cyan

# Crear service account para Kibana (si no existe)
Write-Host "Verificando service account de Kibana..." -ForegroundColor Yellow

try {
    # El service account 'elastic/kibana' debería existir por defecto
    # Solo necesitamos crear el token
    $tokenRequest = @{
        name = "kibana-token"
        service = "elastic/kibana"
    } | ConvertTo-Json

    $tokenResponse = Invoke-RestMethod -Uri "$ELASTICSEARCH_HOST/_security/service/elastic/kibana/credential/token" `
        -Method Post `
        -ContentType "application/json" `
        -Headers @{
            Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${ELASTIC_USER}:${ELASTIC_PASSWORD}"))
        } `
        -Body $tokenRequest

    $token = $tokenResponse.token.value
    
    Write-Host "✓ Token creado exitosamente" -ForegroundColor Green
    Write-Host ""
    Write-Host "Token: $token" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Agrega esta variable de entorno a Kibana en docker-compose.yml:" -ForegroundColor Cyan
    Write-Host "  ELASTICSEARCH_SERVICEACCOUNTTOKEN: `"$token`"" -ForegroundColor White
    Write-Host ""
    Write-Host "Y elimina estas líneas:" -ForegroundColor Cyan
    Write-Host "  ELASTICSEARCH_USERNAME=elastic" -ForegroundColor White
    Write-Host "  ELASTICSEARCH_PASSWORD=changeme" -ForegroundColor White
    
    return $token
} catch {
    Write-Host "✗ Error al crear el token: $_" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Respuesta: $responseBody" -ForegroundColor Yellow
    }
    exit 1
}

