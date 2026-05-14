#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PREFERRED_PORT="${PORT:-8080}"
HOST="${HOST:-0.0.0.0}"

cd "$ROOT_DIR"

find_available_port() {
  local preferred_port="$1"
  local port

  for ((port=preferred_port; port<=preferred_port+50; port++)); do
    if python3 - "$HOST" "$port" <<'PY' >/dev/null 2>&1
import socket
import sys

host = sys.argv[1]
port = int(sys.argv[2])

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
try:
    sock.bind((host, port))
except OSError:
    sys.exit(1)
finally:
    sock.close()
PY
    then
      echo "$port"
      return 0
    fi
  done

  return 1
}

PORT="$(find_available_port "$PREFERRED_PORT")" || {
  echo "Failed to find an available port near ${PREFERRED_PORT}."
  exit 1
}

if [[ "$PORT" != "$PREFERRED_PORT" ]]; then
  echo "Preferred port ${PREFERRED_PORT} is busy. Switched to ${PORT}."
fi

LAN_IP="$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || true)"

echo "Starting Flutter web server on ${HOST}:${PORT}"
if [[ -n "$LAN_IP" ]]; then
  echo "Phone URL: http://${LAN_IP}:${PORT}"
else
  echo "Phone URL: http://<your-mac-lan-ip>:${PORT}"
fi

exec fvm flutter run -d web-server --web-hostname "$HOST" --web-port "$PORT"
