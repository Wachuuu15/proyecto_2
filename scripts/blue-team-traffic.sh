#!/bin/bash
# Script de generación de tráfico legítimo para Blue Team
# Versión bash para ejecución en Docker/Linux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/logs"
LOG_FILE="$LOG_DIR/juice-blue-team.log"

# Crear directorio de logs si no existe
mkdir -p "$LOG_DIR"

ENDPOINTS=(
  "http://juice-shop:3000"
  "http://juice-shop:3000/#/login"
  "http://juice-shop:3000/rest/products/search?q=apple"
  "http://juice-shop:3000/rest/products/search?q=juce"
  "http://juice-shop:3000/api/Products"
  "http://juice-shop:3000/rest/user/login"
)

log() {
    echo "$(date -u '+%Y-%m-%d %H:%M:%S UTC') - $1" | tee -a "$LOG_FILE"
}

log "=== INICIO Ejecución Blue Team Traffic ==="

for url in "${ENDPOINTS[@]}"; do
    response_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    
    if [ "$response_code" -ge 200 ] && [ "$response_code" -lt 400 ]; then
        log "OK - HTTP $response_code - $url"
    else
        log "WARNING - HTTP $response_code - $url"
    fi
    
    sleep 3
done

log "=== FIN Ejecución Blue Team Traffic ==="