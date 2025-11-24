#!/bin/bash
# Script bash para configurar reglas de detección en Kibana
# Ejecutar después de que Kibana esté disponible y el pipeline de ingest esté configurado

KIBANA_HOST="${KIBANA_HOST:-http://localhost:5601}"
ELASTICSEARCH_HOST="${ELASTICSEARCH_HOST:-http://localhost:9200}"

echo "Configurando reglas de detección en Kibana..."
echo "Kibana: $KIBANA_HOST"
echo ""

# Función auxiliar para crear reglas
create_rule() {
    local rule_name="$1"
    local rule_config="$2"
    
    local response=$(curl -s -X POST "$KIBANA_HOST/api/detection_engine/rules" \
        -H "Content-Type: application/json" \
        -H "kbn-xsrf: true" \
        -d "$rule_config")
    
    if echo "$response" | grep -q '"id"'; then
        local rule_id=$(echo "$response" | grep -o '"id":"[^"]*' | cut -d'"' -f4)
        echo "✓ Regla '$rule_name' creada exitosamente"
        echo "  ID: $rule_id"
        return 0
    elif echo "$response" | grep -q "already_exists\|409"; then
        echo "⚠ La regla '$rule_name' ya existe, intentando actualizar..."
        # Buscar y actualizar la regla existente
        local search_response=$(curl -s -X GET "$KIBANA_HOST/api/detection_engine/rules/_find?per_page=1000" \
            -H "kbn-xsrf: true")
        local existing_id=$(echo "$search_response" | grep -o "\"name\":\"$rule_name\"[^}]*\"id\":\"[^\"]*" | grep -o '"id":"[^"]*' | cut -d'"' -f4 | head -1)
        
        if [ -n "$existing_id" ]; then
            local update_response=$(curl -s -X PUT "$KIBANA_HOST/api/detection_engine/rules?rule_id=$existing_id" \
                -H "Content-Type: application/json" \
                -H "kbn-xsrf: true" \
                -d "$rule_config")
            if echo "$update_response" | grep -q '"id"'; then
                echo "✓ Regla '$rule_name' actualizada exitosamente"
                return 0
            fi
        fi
        echo "✗ Error al actualizar la regla existente"
        return 1
    else
        echo "✗ Error al crear la regla '$rule_name': $response"
        return 1
    fi
}

# ============================================
# REGLA 1: SQL Injection
# ============================================
echo "[1/3] Creando regla de detección: SQL Injection..."

SQLI_RULE=$(cat <<'EOF'
{
  "name": "Detección SQL Injection - Juice Shop",
  "description": "Detecta intentos de SQL Injection en logs de Juice Shop. Referencia: PASO_6_BLUE_TEAM.md sección 3.1",
  "enabled": true,
  "risk_score": 75,
  "severity": "high",
  "type": "query",
  "rule_id": "elastic-juice-sqli",
  "interval": "5m",
  "from": "now-15m",
  "language": "kuery",
  "query": "url.original:(\"*' or 1=1*\" or \"*union select*\" or \"*sleep(*\" or \"*benchmark(*\") or query:(\"*' or 1=1*\" or \"*union select*\" or \"*sleep(*\" or \"*benchmark(*\") or message:(\"*' or 1=1*\" or \"*union select*\" or \"*sleep(*\" or \"*benchmark(*\") or threat.indicator.type: \"sql-injection\"",
  "index": ["filebeat-juice-shop-*", "filebeat-nginx-*", "filebeat-docker-*"],
  "max_signals": 100,
  "tags": ["juice-shop", "sql-injection", "security", "blue-team"],
  "references": ["https://owasp.org/www-community/attacks/SQL_Injection"],
  "false_positives": ["Consultas legítimas que contengan 'union' como término de búsqueda"],
  "threat": [{
    "framework": "MITRE ATT&CK",
    "tactic": {
      "id": "TA0001",
      "name": "Initial Access",
      "reference": "https://attack.mitre.org/tactics/TA0001"
    },
    "technique": [{
      "id": "T1190",
      "name": "Exploit Public-Facing Application",
      "reference": "https://attack.mitre.org/techniques/T1190"
    }]
  }],
  "note": "Respuesta sugerida: Bloquear IP en Nginx usando 'deny <IP>;' y recargar configuración"
}
EOF
)

create_rule "Detección SQL Injection - Juice Shop" "$SQLI_RULE"
echo ""

# ============================================
# REGLA 2: XSS (Cross-Site Scripting)
# ============================================
echo "[2/3] Creando regla de detección: XSS..."

XSS_RULE=$(cat <<'EOF'
{
  "name": "Detección Cross-Site Scripting (XSS) - Juice Shop",
  "description": "Detecta intentos de Cross-Site Scripting en logs de Juice Shop. Referencia: PASO_6_BLUE_TEAM.md sección 3.2",
  "enabled": true,
  "risk_score": 65,
  "severity": "high",
  "type": "threshold",
  "rule_id": "elastic-juice-xss",
  "interval": "5m",
  "from": "now-15m",
  "language": "kuery",
  "query": "(url.original:*\"<script*\" or url.original:*\"onerror=\" or url.original:*\"javascript:\" or http.request.body.content:*\"<img*\" or message.keyword:*\"<svg*\" or threat.indicator.type: \"xss\")",
  "index": ["filebeat-juice-shop-*", "filebeat-nginx-*", "filebeat-docker-*"],
  "threshold": {
    "field": "source.ip",
    "value": 1,
    "cardinality": []
  },
  "max_signals": 100,
  "tags": ["juice-shop", "xss", "security", "blue-team"],
  "references": ["https://owasp.org/www-community/attacks/xss/"],
  "false_positives": ["Productos o reseñas legítimas que incluyan HTML permitido"],
  "threat": [{
    "framework": "MITRE ATT&CK",
    "tactic": {
      "id": "TA0001",
      "name": "Initial Access",
      "reference": "https://attack.mitre.org/tactics/TA0001"
    },
    "technique": [{
      "id": "T1190",
      "name": "Exploit Public-Facing Application",
      "reference": "https://attack.mitre.org/techniques/T1190"
    }]
  }],
  "note": "Respuesta sugerida: Registrar payload, bloquear IP si repite, habilitar sanitización en Juice Shop"
}
EOF
)

create_rule "Detección Cross-Site Scripting (XSS) - Juice Shop" "$XSS_RULE"
echo ""

# ============================================
# REGLA 3: Burst/Scanning
# ============================================
echo "[3/3] Creando regla de detección: Burst/Scanning..."

BURST_RULE=$(cat <<'EOF'
{
  "name": "Detección de Scanning/Burst - Juice Shop",
  "description": "Detecta actividad de escaneo o ráfagas de requests fallidos indicando posibles ataques automatizados. Referencia: PASO_6_BLUE_TEAM.md sección 3.3",
  "enabled": true,
  "risk_score": 50,
  "severity": "medium",
  "type": "threshold",
  "rule_id": "elastic-juice-burst",
  "interval": "5m",
  "from": "now-15m",
  "language": "kuery",
  "query": "http.response.status_code: (400 or 401 or 403 or 404 or 500 or 503)",
  "index": ["filebeat-juice-shop-*", "filebeat-nginx-*", "filebeat-docker-*"],
  "threshold": {
    "field": "source.ip",
    "value": 20,
    "cardinality": []
  },
  "max_signals": 100,
  "tags": ["juice-shop", "scanning", "burst", "security", "blue-team"],
  "references": [],
  "false_positives": ["Monitoreo agresivo de uptime. Documenta host de monitoreo y exclúyelo"],
  "threat": [{
    "framework": "MITRE ATT&CK",
    "tactic": {
      "id": "TA0043",
      "name": "Reconnaissance",
      "reference": "https://attack.mitre.org/tactics/TA0043"
    },
    "technique": [{
      "id": "T1046",
      "name": "Network Service Scanning",
      "reference": "https://attack.mitre.org/techniques/T1046"
    }]
  }],
  "note": "Respuesta sugerida: Bloquear IP en proxy, activar alertas en Slack/Email"
}
EOF
)

create_rule "Detección de Scanning/Burst - Juice Shop" "$BURST_RULE"
echo ""

# ============================================
# RESUMEN
# ============================================
echo "========================================"
echo "Resumen de reglas configuradas:"
echo "========================================"

ALL_RULES=$(curl -s -X GET "$KIBANA_HOST/api/detection_engine/rules/_find?per_page=1000" \
    -H "kbn-xsrf: true")

if echo "$ALL_RULES" | grep -q "juice-shop"; then
    echo "$ALL_RULES" | grep -A 5 "\"name\":" | grep -E "\"name\"|\"id\"|\"enabled\"|\"severity\"" | head -20
else
    echo "⚠ No se pudieron listar las reglas configuradas"
fi

echo ""
echo "✓ Configuración completada"
echo ""
echo "Próximos pasos:"
echo "  1. Verifica las reglas en Kibana: Security → Detect → Detection rules"
echo "  2. Prueba las detecciones ejecutando los scripts de prueba de ataques"
echo "  3. Revisa las alertas generadas en Security → Detections"

