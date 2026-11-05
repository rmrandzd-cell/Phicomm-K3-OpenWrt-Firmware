#!/usr/bin/env bash
set -euo pipefail

echo '>>> Update Passwall TProxy Dependencies >>>'
APP='package/lean/luci-app-passwall/root/usr/share/passwall/app.sh'
if [ ! -f "$APP" ]; then
  APP=$(grep -rl 'iptables-mod-socket' package/lean/luci-app-passwall 2>/dev/null | head -n 1 || true)
fi
if [ -n "${APP:-}" ] && [ -f "$APP" ]; then
  sed -Ei 's/(^| )iptables-mod-socket( |$)/ /g; s/  +/ /g' "$APP"
  echo "patched: $APP"
else
  echo "skip: target file not found (upstream passwall layout changed)"
fi
echo '<<< Completed Update Passwall TProxy Dependencies <<<'
