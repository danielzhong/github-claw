#!/usr/bin/env bash
# prepare-preview.sh — Download PR test assets and start a local preview server.
#
# Usage:
#   bash prepare-preview.sh <PR_NUMBER> [PORT]
#
# Environment:
#   CODESPACE_HOST  — override the Codespaces forwarded-port base URL
#                     (default: https://miniature-doodle-vg6gx5wvrrphwg57-8081.app.github.dev)
#   ASSET_URLS      — space-separated list of asset URLs to download

set -euo pipefail

PR_NUMBER="${1:-}"
PORT="${2:-8081}"

if [[ -z "$PR_NUMBER" ]]; then
  echo "Usage: $0 <PR_NUMBER> [PORT]"
  echo "  PR_NUMBER  — the CesiumGS/cesium pull request number"
  echo "  PORT       — local port for http-server (default: 8081)"
  exit 1
fi

CODESPACE_HOST="${CODESPACE_HOST:-https://miniature-doodle-vg6gx5wvrrphwg57-${PORT}.app.github.dev}"

# ── Create working directory ──────────────────────────────────────────
PREVIEW_DIR=$(mktemp -d -t cesium-preview-XXXX)
echo "Preview directory: $PREVIEW_DIR"
cd "$PREVIEW_DIR"

# ── Download assets ───────────────────────────────────────────────────
if [[ -n "${ASSET_URLS:-}" ]]; then
  for url in $ASSET_URLS; do
    echo "Downloading: $url"
    curl -L -O --fail "$url" || echo "WARNING: failed to download $url"
  done
else
  echo "No ASSET_URLS provided — creating placeholder index.html"
  cat > index.html <<'HTML'
<!DOCTYPE html>
<html><head><title>Cesium PR Preview</title></head>
<body><h1>Cesium PR Preview Server</h1><p>No assets were downloaded. Drop files here or re-run with ASSET_URLS.</p></body>
</html>
HTML
fi

echo ""
echo "Files in preview directory:"
ls -lah "$PREVIEW_DIR"

# ── Start http-server ─────────────────────────────────────────────────
echo ""
echo "Starting http-server on port $PORT …"
npx http-server ./ --cors=X-Correlation-Id -p "$PORT" &
SERVER_PID=$!
sleep 3

# Verify
if kill -0 "$SERVER_PID" 2>/dev/null; then
  echo "✅ Server running (PID $SERVER_PID)"
else
  echo "❌ Server failed to start"
  exit 1
fi

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:${PORT}/" || true)
if [[ "$HTTP_STATUS" == "200" ]]; then
  echo "✅ Server responding (HTTP $HTTP_STATUS)"
else
  echo "⚠️  Server responded with HTTP $HTTP_STATUS"
fi

# ── Print URLs ────────────────────────────────────────────────────────
echo ""
echo "══════════════════════════════════════════════"
echo "  Preview Base URL: ${CODESPACE_HOST}/"
echo "══════════════════════════════════════════════"
echo ""
echo "Hosted files:"
for f in "$PREVIEW_DIR"/*; do
  fname=$(basename "$f")
  echo "  ${CODESPACE_HOST}/${fname}"
done
echo ""
echo "Server PID: $SERVER_PID (kill $SERVER_PID to stop)"
