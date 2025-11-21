#!/bin/bash
# Script wrapper para cron - ejecuta blue-team-traffic.sh cada 15 minutos

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Ejecutar el script y redirigir salida al log
bash "$SCRIPT_DIR/blue-team-traffic.sh" >> "$SCRIPT_DIR/logs/cron.log" 2>&1

