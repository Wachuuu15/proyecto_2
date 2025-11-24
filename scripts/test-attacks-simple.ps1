# Script PowerShell para probar ataques y verificar las detecciones
$JUICE_SHOP_URL = if ($env:JUICE_SHOP_URL) { $env:JUICE_SHOP_URL } else { "http://localhost:8080" }

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Script de Prueba de Ataques - Blue Team" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "URL objetivo: $JUICE_SHOP_URL" -ForegroundColor Gray
Write-Host ""

# SQL Injection attacks
Write-Host "=== ATAQUES SQL INJECTION ===" -ForegroundColor Magenta

$url1 = "$JUICE_SHOP_URL/rest/products/search?q=' OR 1=1 --"
Write-Host "Atacando: SQLi - OR 1=1" -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $url1 -UseBasicParsing -DisableKeepAlive | Out-Null
    Write-Host "  OK - Request enviado" -ForegroundColor Green
} catch {
    Write-Host "  OK - Request enviado (error esperado)" -ForegroundColor Yellow
}

Start-Sleep -Seconds 2

$url2 = "$JUICE_SHOP_URL/rest/products/search?q=apple' UNION SELECT null,null,null--"
Write-Host "Atacando: SQLi - UNION SELECT" -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $url2 -UseBasicParsing -DisableKeepAlive | Out-Null
    Write-Host "  OK - Request enviado" -ForegroundColor Green
} catch {
    Write-Host "  OK - Request enviado (error esperado)" -ForegroundColor Yellow
}

Start-Sleep -Seconds 2

$url3 = "$JUICE_SHOP_URL/rest/products/search?q=test' AND SLEEP(1)--"
Write-Host "Atacando: SQLi - SLEEP" -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $url3 -UseBasicParsing -DisableKeepAlive | Out-Null
    Write-Host "  OK - Request enviado" -ForegroundColor Green
} catch {
    Write-Host "  OK - Request enviado (error esperado)" -ForegroundColor Yellow
}

Start-Sleep -Seconds 3

# XSS attacks
Write-Host ""
Write-Host "=== ATAQUES XSS ===" -ForegroundColor Magenta

$url4 = "$JUICE_SHOP_URL/rest/products/search?q=<script>alert(1)</script>"
Write-Host "Atacando: XSS - Script Tag" -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $url4 -UseBasicParsing -DisableKeepAlive | Out-Null
    Write-Host "  OK - Request enviado" -ForegroundColor Green
} catch {
    Write-Host "  OK - Request enviado (error esperado)" -ForegroundColor Yellow
}

Start-Sleep -Seconds 2

$url5 = "$JUICE_SHOP_URL/rest/products/search?q=<svg/onload=alert(1)>"
Write-Host "Atacando: XSS - SVG onload" -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $url5 -UseBasicParsing -DisableKeepAlive | Out-Null
    Write-Host "  OK - Request enviado" -ForegroundColor Green
} catch {
    Write-Host "  OK - Request enviado (error esperado)" -ForegroundColor Yellow
}

Start-Sleep -Seconds 2

$url6 = "$JUICE_SHOP_URL/rest/products/search?q=javascript:alert(1)"
Write-Host "Atacando: XSS - JavaScript URI" -ForegroundColor Yellow
try {
    Invoke-WebRequest -Uri $url6 -UseBasicParsing -DisableKeepAlive | Out-Null
    Write-Host "  OK - Request enviado" -ForegroundColor Green
} catch {
    Write-Host "  OK - Request enviado (error esperado)" -ForegroundColor Yellow
}

Start-Sleep -Seconds 3

# Burst/Scanning simulation
Write-Host ""
Write-Host "=== SIMULACION DE SCANNING/BURST ===" -ForegroundColor Magenta
Write-Host "Generando 30 requests a endpoints inexistentes..." -ForegroundColor Yellow

$failedRequests = 0
for ($i = 1; $i -le 30; $i++) {
    $url = "$JUICE_SHOP_URL/non-existent-endpoint-$i"
    try {
        Invoke-WebRequest -Uri $url -UseBasicParsing -DisableKeepAlive | Out-Null
    } catch {
        $failedRequests++
    }
    
    if ($i % 10 -eq 0) {
        Write-Host "  Generados $i requests..." -ForegroundColor Gray
    }
    Start-Sleep -Milliseconds 100
}

Write-Host ""
Write-Host "OK - $failedRequests requests fallidos generados" -ForegroundColor Green
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

