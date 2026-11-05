#!/usr/bin/env bash
set -euo pipefail

CONFIG_GENERATE='package/base-files/files/bin/config_generate'
AUTOCORE_INDEX='package/lean/autocore/files/arm/index.htm'
ARGON_SCRIPT='package/lean/luci-theme-argon/htdocs/luci-static/argon/js/script.js'
MINIUPNPD_CONFIG='feeds/packages/net/miniupnpd/files/upnpd.config'

if [[ -n "${MODIFY_HOSTNAME:-}" ]]; then
  echo '>>> Update Hostname >>>'
  if [ -f "$CONFIG_GENERATE" ]; then
    sed -i "s/hostname='OpenWrt'/hostname='${MODIFY_HOSTNAME}'/g" "$CONFIG_GENERATE"
    echo "patched: $CONFIG_GENERATE"
  else
    echo "skip: $CONFIG_GENERATE not found"
  fi
  echo '<<< Completed Update Hostname <<<'
fi

echo '>>> Remove Autocore Benchmark Display >>>'
if [ -f "$AUTOCORE_INDEX" ]; then
  sed -i 's/ <%=luci.sys.exec("cat \/etc\/bench.log") or ""%>//g' "$AUTOCORE_INDEX"
  echo "patched: $AUTOCORE_INDEX"
else
  echo "skip: $AUTOCORE_INDEX not found"
fi
echo '<<< Completed Remove Autocore Benchmark Display <<<'

echo '>>> Remove Argon Console Log >>>'
if [ -f "$ARGON_SCRIPT" ]; then
  sed -i '/console.log(mainNodeName);/d' "$ARGON_SCRIPT"
  echo "patched: $ARGON_SCRIPT"
else
  echo "skip: $ARGON_SCRIPT not found"
fi
echo '<<< Completed Remove Argon Console Log <<<'

echo '>>> Update MiniUPnPd Lease Path >>>'
if [ -f "$MINIUPNPD_CONFIG" ]; then
  sed -i 's/\/var\/upnp.leases/\/tmp\/upnp.leases/g' "$MINIUPNPD_CONFIG"
  echo "patched: $MINIUPNPD_CONFIG"
else
  echo "skip: $MINIUPNPD_CONFIG not found"
fi
echo '<<< Completed Update MiniUPnPd Lease Path <<<'
