#!/system/bin/sh
# Backend for the WebUI (webroot/index.html). Called via KernelSU ksu.exec.
# Reuses utils.sh so the randomized binary name and port live in one place.
MODPATH=${0%/*}
. "$MODPATH/utils.sh" 2>/dev/null || exit 1

case "$1" in
  status)
    busybox pgrep "$SRV_NAME" >/dev/null 2>&1 && echo running || echo stopped
    ;;
  start)
    start_frida_server >/dev/null 2>&1
    sleep 1
    busybox pgrep "$SRV_NAME" >/dev/null 2>&1 && echo running || echo stopped
    ;;
  stop)
    busybox pkill -9 "$SRV_NAME" >/dev/null 2>&1
    echo stopped
    ;;
  setport)
    p="$2"
    # validate: digits only, 1-65535 (frida-server runs as root, so <1024 is fine)
    case "$p" in ''|*[!0-9]*) echo invalid; exit 0 ;; esac
    if [ "$p" -lt 1 ] || [ "$p" -gt 65535 ]; then echo invalid; exit 0; fi
    echo "$p" > "$MODPATH/bin/.srvport"
    FRIDA_PORT="$p"
    busybox pkill -9 "$SRV_NAME" >/dev/null 2>&1
    sleep 1
    start_frida_server >/dev/null 2>&1
    sleep 1
    busybox pgrep "$SRV_NAME" >/dev/null 2>&1 && echo running || echo stopped
    ;;
  info)
    echo "$SRV_NAME $FRIDA_PORT"
    ;;
  *)
    echo "usage: webui.sh {status|start|stop|info}"
    ;;
esac
