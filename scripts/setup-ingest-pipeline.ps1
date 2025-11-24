# Script PowerShell para configurar el pipeline de ingest en Elasticsearch
# Ejecutar después de que Elasticsearch esté disponible

$ELASTICSEARCH_HOST = if ($env:ELASTICSEARCH_HOST) { $env:ELASTICSEARCH_HOST } else { "http://localhost:9200" }

Write-Host "Configurando pipeline de ingest para detección de amenazas..." -ForegroundColor Cyan

# Construir el script de detección como un array de líneas y unirlas
$scriptLines = @(
    "if (ctx?.url?.original != null) {",
    "  String urlLower = ctx.url.original.toLowerCase();",
    "  if (urlLower.contains(`"union select`") ||",
    "      urlLower.contains(`" or 1=1`") ||",
    "      urlLower.contains(`"'' or`") ||",
    "      urlLower.contains(`"--`") ||",
    "      urlLower.contains(`"sleep(`") ||",
    "      urlLower.contains(`"benchmark(`")) {",
    "    if (ctx.threat == null) {",
    "      ctx.threat = [:];",
    "    }",
    "    if (ctx.threat.indicator == null) {",
    "      ctx.threat.indicator = [:];",
    "    }",
    "    ctx.threat.indicator.type = `"sql-injection`";",
    "  }",
    "  if (urlLower.contains(`"<script`") ||",
    "      urlLower.contains(`"onerror=`") ||",
    "      urlLower.contains(`"<img`") ||",
    "      urlLower.contains(`"<svg`") ||",
    "      urlLower.contains(`"javascript:`")) {",
    "    if (ctx.threat == null) {",
    "      ctx.threat = [:];",
    "    }",
    "    if (ctx.threat.indicator == null) {",
    "      ctx.threat.indicator = [:];",
    "    }",
    "    ctx.threat.indicator.type = `"xss`";",
    "  }",
    "  if (urlLower.contains(`"../../`") ||",
    "      urlLower.contains(`"/bin/`") ||",
    "      urlLower.contains(`"cat /etc/passwd`")) {",
    "    if (ctx.threat == null) {",
    "      ctx.threat = [:];",
    "    }",
    "    if (ctx.threat.indicator == null) {",
    "      ctx.threat.indicator = [:];",
    "    }",
    "    ctx.threat.indicator.type = `"lfi`";",
    "  }",
    "}",
    "if (ctx?.message != null) {",
    "  String msgLower = ctx.message.toLowerCase();",
    "  if (msgLower.contains(`"union select`") ||",
    "      msgLower.contains(`" or 1=1`") ||",
    "      msgLower.contains(`"sleep(`") ||",
    "      msgLower.contains(`"benchmark(`")) {",
    "    if (ctx.threat == null) {",
    "      ctx.threat = [:];",
    "    }",
    "    if (ctx.threat.indicator == null) {",
    "      ctx.threat.indicator = [:];",
    "    }",
    "    ctx.threat.indicator.type = `"sql-injection`";",
    "  }",
    "}",
    "if (ctx?.query != null) {",
    "  String queryLower = ctx.query.toLowerCase();",
    "  if (queryLower.contains(`"union select`") ||",
    "      queryLower.contains(`" or 1=1`") ||",
    "      queryLower.contains(`"sleep(`") ||",
    "      queryLower.contains(`"benchmark(`")) {",
    "    if (ctx.threat == null) {",
    "      ctx.threat = [:];",
    "    }",
    "    if (ctx.threat.indicator == null) {",
    "      ctx.threat.indicator = [:];",
    "    }",
    "    ctx.threat.indicator.type = `"sql-injection`";",
    "  }",
    "}"
)

$scriptSource = $scriptLines -join "`n"

# Crear pipeline para normalización y detección de amenazas
$pipelineConfig = @{
    description = "Normaliza logs de Juice Shop y detecta payloads comunes"
    processors = @(
        @{
            lowercase = @{
                field = "url.original"
                ignore_missing = $true
            }
        },
        @{
            script = @{
                source = $scriptSource
            }
        }
    )
}

# Convertir a JSON para enviarlo
$pipelineJson = $pipelineConfig | ConvertTo-Json -Depth 10 -Compress

Write-Host "Creando pipeline en Elasticsearch..." -ForegroundColor Cyan

try {
    $response = Invoke-RestMethod -Uri "$ELASTICSEARCH_HOST/_ingest/pipeline/juice-threat-normalizer" `
        -Method Put `
        -ContentType "application/json" `
        -Body $pipelineJson
    
    Write-Host "Pipeline 'juice-threat-normalizer' creado exitosamente" -ForegroundColor Green
} catch {
    Write-Host "Error al crear el pipeline: $_" -ForegroundColor Red
    if ($_.Exception.Response) {
        $reader = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
        $responseBody = $reader.ReadToEnd()
        Write-Host "Respuesta del servidor: $responseBody" -ForegroundColor Yellow
    }
    exit 1
}

# Verificar que el pipeline se creó correctamente
Write-Host ""
Write-Host "Verificando pipeline creado..." -ForegroundColor Cyan
try {
    $pipeline = Invoke-RestMethod -Uri "$ELASTICSEARCH_HOST/_ingest/pipeline/juice-threat-normalizer" -Method Get
    Write-Host "Pipeline verificado correctamente" -ForegroundColor Green
    $pipeline | ConvertTo-Json -Depth 10
} catch {
    Write-Host "Error al verificar el pipeline: $_" -ForegroundColor Red
}

Write-Host ""
Write-Host "Pipeline configurado. El filebeat.yml ya esta configurado para usarlo." -ForegroundColor Yellow
Write-Host "Reinicia Filebeat con: docker-compose restart filebeat" -ForegroundColor Yellow
