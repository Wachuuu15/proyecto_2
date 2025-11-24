#!/bin/bash
# Script bash para probar ataques y verificar las detecciones
# Ejecutar después de configurar las reglas de detección

JUICE_SHOP_URL="${JUICE_SHOP_URL:-http://localhost:8080}"

echo "========================================"
echo "Script de Prueba de Ataques - Blue Team"
echo "========================================"
echo "URL objetivo: $JUICE_SHOP_URL"
echo ""

# Función para hacer requests y mostrar resultados
invoke_attack() {
    local name="$1"
    local url="$2"
    local description="$3"
    
    echo "Atacando: $name"
    echo "  Descripción: $description"
    
    response_code=$(curl -s -o /dev/null -w "%{http_code}" "$url")
    
    if [ "$response_code" -ge 200 ] && [ "$response_code" -lt 400 ]; then
        echo "  ✓ HTTP $response_code - Request enviado exitosamente"
    elif [ "$response_code" -ge 400 ]; then
        echo "  ⚠ HTTP $response_code - Request enviado (código de error esperado)"
    else
        echo "  ✗ Error de conexión"
    fi
    echo ""
}

# SQL Injection attacks
echo "=== ATAQUES SQL INJECTION ==="
invoke_attack "SQLi - OR 1=1" \
    "$JUICE_SHOP_URL/rest/products/search?q=' OR 1=1 --" \
    "Intento clásico de SQL Injection"

invoke_attack "SQLi - UNION SELECT" \
    "$JUICE_SHOP_URL/rest/products/search?q=apple' UNION SELECT null,null,null--" \
    "Intento de SQL Injection con UNION SELECT"

invoke_attack "SQLi - SLEEP" \
    "$JUICE_SHOP_URL/rest/products/search?q=test' AND SLEEP(1)--" \
    "Intento de SQL Injection basado en tiempo"

sleep 3

# XSS attacks
echo "=== ATAQUES XSS ==="
invoke_attack "XSS - Script Tag" \
    "$JUICE_SHOP_URL/rest/products/search?q=<script>alert('XSS')</script>" \
    "Intento de XSS con tag script"

invoke_attack "XSS - SVG onload" \
    "$JUICE_SHOP_URL/rest/products/search?q=<svg/onload=alert(1)>" \
    "Intento de XSS con SVG onload"

invoke_attack "XSS - JavaScript URI" \
    "$JUICE_SHOP_URL/rest/products/search?q=javascript:alert('XSS')" \
    "Intento de XSS con JavaScript URI"

sleep 3

# Burst/Scanning simulation
echo "=== SIMULACIÓN DE SCANNING/BURST ==="
echo "Generando 30 requests a endpoints inexistentes..."

failed_requests=0
for i in {1..30}; do
    response_code=$(curl -s -o /dev/null -w "%{http_code}" "$JUICE_SHOP_URL/non-existent-endpoint-$i")
    
    if [ "$response_code" -ge 400 ]; then
        echo -n "  HTTP $response_code "
        failed_requests=$((failed_requests + 1))
    else
        echo -n "  HTTP $response_code "
    fi
    
    if [ $((i % 10)) -eq 0 ]; then
        echo ""
    fi
    
    sleep 0.1
done

echo ""
echo "  ✓ $failed_requests requests fallidos generados"
echo ""

# Summary
echo "========================================"
echo "Resumen de Ataques Simulados"
echo "========================================"
echo "  • SQL Injection: 3 intentos"
echo "  • XSS: 3 intentos"
echo "  • Scanning/Burst: 30 requests fallidos"
echo ""
echo "Próximos pasos:"
echo "  1. Espera 5-10 minutos para que las reglas procesen los eventos"
echo "  2. Revisa las detecciones en Kibana: Security → Detections"
echo "  3. Verifica los logs en Discover con: threat.indicator.type: *"
echo ""

