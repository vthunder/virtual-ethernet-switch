#!/bin/sh
# Start WebOne proxy as sidecar (background), then Node switch in foreground
cd /app
DOTNET_ROOT=/opt/dotnet ./webone webone-retro.conf &
WEBONE_PID=$!
echo "[start] WebOne started (pid $WEBONE_PID)"

# Wait for WebOne to be ready on 8118
for i in $(seq 1 15); do
  if curl -s -o /dev/null -w "%{http_code}" --max-time 1 http://127.0.0.1:8118/ 2>/dev/null | grep -q ""; then
    echo "[start] WebOne ready"
    break
  fi
  sleep 1
done

exec node server.js
