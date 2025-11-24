#!/bin/bash
# Script para configurar el pipeline de ingest en Elasticsearch
# Ejecutar después de que Elasticsearch esté disponible

ELASTICSEARCH_HOST="${ELASTICSEARCH_HOST:-http://localhost:9200}"

echo "Configurando pipeline de ingest para detección de amenazas..."

# Crear pipeline para normalización y detección de amenazas
curl -X PUT "$ELASTICSEARCH_HOST/_ingest/pipeline/juice-threat-normalizer" \
  -H "Content-Type: application/json" \
  -d '{
    "description": "Normaliza logs de Juice Shop y detecta payloads comunes",
    "processors": [
      {
        "lowercase": {
          "field": "url.original",
          "ignore_missing": true
        }
      },
      {
        "script": {
          "source": """
            if (ctx?.url?.original != null) {
              String urlLower = ctx.url.original.toLowerCase();
              if (urlLower.contains(\"union select\") || 
                  urlLower.contains(\" or 1=1\") || 
                  urlLower.contains(\"\\'\' or\") ||
                  urlLower.contains(\"--\") ||
                  urlLower.contains(\"sleep(\") || 
                  urlLower.contains(\"benchmark(\")) {
                if (ctx.threat == null) {
                  ctx.threat = [:];
                }
                if (ctx.threat.indicator == null) {
                  ctx.threat.indicator = [:];
                }
                ctx.threat.indicator.type = \"sql-injection\";
              }
              if (urlLower.contains(\"<script\") || 
                  urlLower.contains(\"onerror=\") || 
                  urlLower.contains(\"<img\") ||
                  urlLower.contains(\"<svg\") ||
                  urlLower.contains(\"javascript:\")) {
                if (ctx.threat == null) {
                  ctx.threat = [:];
                }
                if (ctx.threat.indicator == null) {
                  ctx.threat.indicator = [:];
                }
                ctx.threat.indicator.type = \"xss\";
              }
              if (urlLower.contains(\"../../\") || 
                  urlLower.contains(\"/bin/\") || 
                  urlLower.contains(\"cat /etc/passwd\")) {
                if (ctx.threat == null) {
                  ctx.threat = [:];
                }
                if (ctx.threat.indicator == null) {
                  ctx.threat.indicator = [:];
                }
                ctx.threat.indicator.type = \"lfi\";
              }
            }
            if (ctx?.message != null) {
              String msgLower = ctx.message.toLowerCase();
              if (msgLower.contains(\"union select\") || 
                  msgLower.contains(\" or 1=1\") ||
                  msgLower.contains(\"sleep(\") || 
                  msgLower.contains(\"benchmark(\")) {
                if (ctx.threat == null) {
                  ctx.threat = [:];
                }
                if (ctx.threat.indicator == null) {
                  ctx.threat.indicator = [:];
                }
                ctx.threat.indicator.type = \"sql-injection\";
              }
            }
            if (ctx?.query != null) {
              String queryLower = ctx.query.toLowerCase();
              if (queryLower.contains(\"union select\") || 
                  queryLower.contains(\" or 1=1\") ||
                  queryLower.contains(\"sleep(\") || 
                  queryLower.contains(\"benchmark(\")) {
                if (ctx.threat == null) {
                  ctx.threat = [:];
                }
                if (ctx.threat.indicator == null) {
                  ctx.threat.indicator = [:];
                }
                ctx.threat.indicator.type = \"sql-injection\";
              }
            }
          """
        }
      }
    ]
  }'

if [ $? -eq 0 ]; then
    echo "✓ Pipeline 'juice-threat-normalizer' creado exitosamente"
else
    echo "✗ Error al crear el pipeline"
    exit 1
fi

# Verificar que el pipeline se creó correctamente
echo ""
echo "Verificando pipeline creado..."
curl -X GET "$ELASTICSEARCH_HOST/_ingest/pipeline/juice-threat-normalizer" | python3 -m json.tool

echo ""
echo "Pipeline configurado. Ahora puedes descomentar la línea 'pipeline: \"juice-threat-normalizer\"' en filebeat.yml"

