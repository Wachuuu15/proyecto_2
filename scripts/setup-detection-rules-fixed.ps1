# Script PowerShell para configurar reglas de detección en Kibana
# Ejecutar después de que Kibana esté disponible y el pipeline de ingest esté configurado

$KIBANA_HOST = if ($env:KIBANA_HOST) { $env:KIBANA_HOST } else { "http://localhost:5601" }
$ELASTICSEARCH_HOST = if ($env:ELASTICSEARCH_HOST) { $env:ELASTICSEARCH_HOST } else { "http://localhost:9200" }

Write-Host "Configurando reglas de detección en Kibana..." -ForegroundColor Cyan
Write-Host "Kibana: $KIBANA_HOST" -ForegroundColor Gray
Write-Host ""

# Función auxiliar para crear reglas
function Create-DetectionRule {
    param(
        [string]$RuleName,
        [object]$RuleConfig
    )
    
    $uri = "$KIBANA_HOST/api/detection_engine/rules"
    
    # Credenciales para autenticación básica
    $credential = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("elastic:changeme"))
    $headers = @{
        "Authorization" = "Basic $credential"
        "kbn-xsrf" = "true"
        "Content-Type" = "application/json"
    }
    
    try {
        $response = Invoke-RestMethod -Uri $uri `
            -Method Post `
            -Headers $headers `
            -Body ($RuleConfig | ConvertTo-Json -Depth 10)
        
        Write-Host "Regla '$RuleName' creada exitosamente" -ForegroundColor Green
        Write-Host "  ID: $($response.id)" -ForegroundColor Gray
        return $response
    } catch {
        $errorMessage = $_.Exception.Message
        
        # Si la regla ya existe, intentar actualizarla
        if ($errorMessage -match "already_exists" -or $errorMessage -match "409") {
            Write-Host "La regla '$RuleName' ya existe, intentando actualizar..." -ForegroundColor Yellow
            try {
                # Buscar la regla existente por nombre
                $credential = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("elastic:changeme"))
                $headers = @{
                    "Authorization" = "Basic $credential"
                    "kbn-xsrf" = "true"
                }
                $searchUri = "$KIBANA_HOST/api/detection_engine/rules/_find?per_page=1000"
                $existingRules = Invoke-RestMethod -Uri $searchUri -Method Get -Headers $headers
                $existingRule = $existingRules.data | Where-Object { $_.name -eq $RuleName }
                
                if ($existingRule) {
                    $updateUri = "$KIBANA_HOST/api/detection_engine/rules?rule_id=$($existingRule.id)"
                    $RuleConfig.rule_id = $existingRule.id
                    $updateHeaders = @{
                        "Authorization" = "Basic $credential"
                        "kbn-xsrf" = "true"
                        "Content-Type" = "application/json"
                    }
                    $response = Invoke-RestMethod -Uri $updateUri `
                        -Method Put `
                        -Headers $updateHeaders `
                        -Body ($RuleConfig | ConvertTo-Json -Depth 10)
                    Write-Host "Regla '$RuleName' actualizada exitosamente" -ForegroundColor Green
                    return $response
                } else {
                    Write-Host "No se encontro la regla existente para actualizar" -ForegroundColor Red
                }
            } catch {
                Write-Host "Error al actualizar la regla: $_" -ForegroundColor Red
            }
        } else {
            Write-Host "Error al crear la regla '$RuleName': $errorMessage" -ForegroundColor Red
        }
        return $null
    }
}

# REGLA 1: SQL Injection
Write-Host "[1/3] Creando regla de deteccion: SQL Injection..." -ForegroundColor Cyan

$sqliQuery = 'url.original:("*'' or 1=1*" or "*union select*" or "*sleep(*" or "*benchmark(*") or query:("*'' or 1=1*" or "*union select*" or "*sleep(*" or "*benchmark(*") or message:("*'' or 1=1*" or "*union select*" or "*sleep(*" or "*benchmark(*") or threat.indicator.type: "sql-injection"'

$sqliRule = @{
    name = "Deteccion SQL Injection - Juice Shop"
    description = "Detecta intentos de SQL Injection en logs de Juice Shop"
    enabled = $true
    risk_score = 75
    severity = "high"
    type = "query"
    rule_id = "elastic-juice-sqli"
    interval = "5m"
    from = "now-15m"
    language = "kuery"
    query = $sqliQuery
    index = @("filebeat-juice-shop-*", "filebeat-nginx-*", "filebeat-docker-*")
    max_signals = 100
    tags = @("juice-shop", "sql-injection", "security", "blue-team")
}

Create-DetectionRule -RuleName "Deteccion SQL Injection - Juice Shop" -RuleConfig $sqliRule | Out-Null
Write-Host ""

# REGLA 2: XSS
Write-Host "[2/3] Creando regla de deteccion: XSS..." -ForegroundColor Cyan

$xssQuery = '(url.original:*"<script*" or url.original:*"onerror=" or url.original:*"javascript:" or http.request.body.content:*"<img*" or message.keyword:*"<svg*" or threat.indicator.type: "xss")'

$xssRule = @{
    name = "Deteccion Cross-Site Scripting (XSS) - Juice Shop"
    description = "Detecta intentos de Cross-Site Scripting en logs de Juice Shop"
    enabled = $true
    risk_score = 65
    severity = "high"
    type = "threshold"
    rule_id = "elastic-juice-xss"
    interval = "5m"
    from = "now-15m"
    language = "kuery"
    query = $xssQuery
    index = @("filebeat-juice-shop-*", "filebeat-nginx-*", "filebeat-docker-*")
    threshold = @{
        field = "source.ip"
        value = 1
        cardinality = @()
    }
    max_signals = 100
    tags = @("juice-shop", "xss", "security", "blue-team")
}

Create-DetectionRule -RuleName "Deteccion Cross-Site Scripting (XSS) - Juice Shop" -RuleConfig $xssRule | Out-Null
Write-Host ""

# REGLA 3: Burst/Scanning
Write-Host "[3/3] Creando regla de deteccion: Burst/Scanning..." -ForegroundColor Cyan

$burstRule = @{
    name = "Deteccion de Scanning/Burst - Juice Shop"
    description = "Detecta actividad de escaneo o rafagas de requests fallidos"
    enabled = $true
    risk_score = 50
    severity = "medium"
    type = "threshold"
    rule_id = "elastic-juice-burst"
    interval = "5m"
    from = "now-15m"
    language = "kuery"
    query = "http.response.status_code: (400 or 401 or 403 or 404 or 500 or 503)"
    index = @("filebeat-juice-shop-*", "filebeat-nginx-*", "filebeat-docker-*")
    threshold = @{
        field = "source.ip"
        value = 20
        cardinality = @()
    }
    max_signals = 100
    tags = @("juice-shop", "scanning", "burst", "security", "blue-team")
}

Create-DetectionRule -RuleName "Deteccion de Scanning/Burst - Juice Shop" -RuleConfig $burstRule | Out-Null
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Resumen de reglas configuradas:" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

try {
    $credential = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("elastic:changeme"))
    $headers = @{
        "Authorization" = "Basic $credential"
        "kbn-xsrf" = "true"
    }
    $rulesUri = "$KIBANA_HOST/api/detection_engine/rules/_find?per_page=1000"
    $allRules = Invoke-RestMethod -Uri $rulesUri -Method Get -Headers $headers
    $ourRules = $allRules.data | Where-Object { $_.tags -contains "juice-shop" }
    
    foreach ($rule in $ourRules) {
        $status = if ($rule.enabled) { "Habilitada" } else { "Deshabilitada" }
        $statusColor = if ($rule.enabled) { "Green" } else { "Yellow" }
        Write-Host "  - $($rule.name)" -ForegroundColor White
        Write-Host "    ID: $($rule.id) | Estado: $status | Severidad: $($rule.severity)" -ForegroundColor $statusColor
    }
} catch {
    Write-Host "No se pudo obtener la lista de reglas: $_" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Configuracion completada" -ForegroundColor Green
Write-Host ""
Write-Host "Proximos pasos:" -ForegroundColor Yellow
Write-Host "  1. Verifica las reglas en Kibana: Security -> Detect -> Detection rules" -ForegroundColor White
Write-Host "  2. Prueba las detecciones ejecutando los scripts de prueba de ataques" -ForegroundColor White
Write-Host "  3. Revisa las alertas generadas en Security -> Detections" -ForegroundColor White

