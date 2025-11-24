# Script PowerShell para probar ataques y verificar las detecciones
# Ejecutar después de configurar las reglas de detección

$JUICE_SHOP_URL = if ($env:JUICE_SHOP_URL) { $env:JUICE_SHOP_URL } else { "http://localhost:8080" }

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Script de Prueba de Ataques - Blue Team" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "URL objetivo: $JUICE_SHOP_URL" -ForegroundColor Gray
Write-Host ""

# Función para hacer requests y mostrar resultados
function Invoke-Attack {
    param(
        [string]$Name,
        [string]$Url,
        [string]$Description
    )
    
    Write-Host "Atacando: $Name" -ForegroundColor Yellow
    Write-Host "  Descripción: $Description" -ForegroundColor Gray
    
    try {
        $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -DisableKeepAlive -ErrorAction Stop
        Write-Host "  ✓ HTTP $($response.StatusCode) - Request enviado exitosamente" -ForegroundColor Green
        Start-Sleep -Seconds 2
    } catch {
        if ($_.Exception.Response) {
            $statusCode = $_.Exception.Response.StatusCode.value__
            Write-Host "  ⚠ HTTP $statusCode - Request enviado (código de error esperado)" -ForegroundColor Yellow
        } else {
            Write-Host "  ✗ Error de conexión: $($_.Exception.Message)" -ForegroundColor Red
        }
    }
    Write-Host ""
}

# SQL Injection attacks
Write-Host "=== ATAQUES SQL INJECTION ===" -ForegroundColor Magenta
Invoke-Attack -Name "SQLi - OR 1=1" `
    -Url "$JUICE_SHOP_URL/rest/products/search?q=' OR 1=1 --" `
    -Description "Intento clásico de SQL Injection"

Invoke-Attack -Name "SQLi - UNION SELECT" `
    -Url "$JUICE_SHOP_URL/rest/products/search?q=apple' UNION SELECT null,null,null--" `
    -Description "Intento de SQL Injection con UNION SELECT"

Invoke-Attack -Name "SQLi - SLEEP" `
    -Url "$JUICE_SHOP_URL/rest/products/search?q=test' AND SLEEP(1)--" `
    -Description "Intento de SQL Injection basado en tiempo"

Start-Sleep -Seconds 3

# XSS attacks
Write-Host "=== ATAQUES XSS ===" -ForegroundColor Magenta
Invoke-Attack -Name "XSS - Script Tag" `
    -Url "$JUICE_SHOP_URL/rest/products/search?q=<script>alert('XSS')</script>" `
    -Description "Intento de XSS con tag script"

Invoke-Attack -Name "XSS - SVG onload" `
    -Url "$JUICE_SHOP_URL/rest/products/search?q=<svg/onload=alert(1)>" `
    -Description "Intento de XSS con SVG onload"

Invoke-Attack -Name "XSS - JavaScript URI" `
    -Url "$JUICE_SHOP_URL/rest/products/search?q=javascript:alert('XSS')" `
    -Description "Intento de XSS con JavaScript URI"

Start-Sleep -Seconds 3

# Burst/Scanning simulation
Write-Host "=== SIMULACIÓN DE SCANNING/BURST ===" -ForegroundColor Magenta
Write-Host "Generando 30 requests a endpoints inexistentes..." -ForegroundColor Yellow

$failedRequests = 0
for ($i = 1; $i -le 30; $i++) {
    try {
        $response = Invoke-WebRequest -Uri "$JUICE_SHOP_URL/non-existent-endpoint-$i" -UseBasicParsing -DisableKeepAlive -ErrorAction Stop
        Write-Host "  HTTP $($response.StatusCode)" -NoNewline
    } catch {
        if ($_.Exception.Response) {
            $statusCode = $_.Exception.Response.StatusCode.value__
            Write-Host "  HTTP $statusCode" -NoNewline -ForegroundColor Yellow
            $failedRequests++
        } else {
            Write-Host "  Error" -NoNewline -ForegroundColor Red
        }
    }
    
    if ($i % 10 -eq 0) {
        Write-Host ""
    }
    Start-Sleep -Milliseconds 100
}

Write-Host ""
Write-Host "  ✓ $failedRequests requests fallidos generados" -ForegroundColor Green
Write-Host ""

# Summary
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Resumen de Ataques Simulados" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  - SQL Injection: 3 intentos" -ForegroundColor White
Write-Host "  - XSS: 3 intentos" -ForegroundColor White
Write-Host "  - Scanning/Burst: 30 requests fallidos" -ForegroundColor White
Write-Host ""
Write-Host "Proximos pasos:" -ForegroundColor Yellow
Write-Host "  1. Espera 5-10 minutos para que las reglas procesen los eventos" -ForegroundColor White
Write-Host "  2. Revisa las detecciones en Kibana: Security -> Detections" -ForegroundColor White
Write-Host "  3. Verifica los logs en Discover buscando threat.indicator.type" -ForegroundColor White
Write-Host ""

