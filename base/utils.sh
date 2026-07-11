#!/bin/sh
MODPATH=${0%/*}

# Randomized binary name chosen at install time (see customize.sh).
SRV_NAME="$(cat "$MODPATH/bin/.srvname" 2>/dev/null)"
[ -z "$SRV_NAME" ] && SRV_NAME="frida-server"
FRIDA_BIN="$MODPATH/bin/$SRV_NAME"

# Listen port. 27042 is the frida default, so plain `frida -U` / `frida -D` USB
# mode works with no port forwarding. Set to a non-default value for port-scan
# stealth (then connect via `adb forward tcp:PORT tcp:PORT && frida -H 127.0.0.1:PORT`).
FRIDA_PORT="27042"

PATH="$MODPATH/bin:$PATH:/data/adb/ap/bin:/data/adb/magisk:/data/adb/ksu/bin"

# log
exec 2> $MODPATH/logs/utils.log
set -x

check_frida_is_up() {
    if [ -n "$1" ]; then
        timeout="$1"
    else
        timeout=4
    fi
    counter=0

    while [ $counter -lt $timeout ]; do
        result="$(busybox pgrep "$SRV_NAME")"
        if [ -n "$result" ]; then
            echo "[-] Frida-server is running... 💉😜"
            string="description=Run frida-server on boot: ✅ (active)"
            break
        else
            echo "[-] Checking Frida-server status: $counter"
            counter=$((counter + 1))
        fi
        sleep 1.5
    done

    if [ $counter -ge $timeout ]; then
        string="description=Run frida-server on boot: ❌ (failed)"
    fi

    sed -i "s/^description=.*/$string/g" $MODPATH/module.prop
}

start_frida_server() {
  if [ ! -x "$FRIDA_BIN" ]; then
    echo "[-] Frida binary not found: $FRIDA_BIN"
    string="description=Run frida-server on boot: ❌ (missing binary)"
    sed -i "s/^description=.*/$string/g" $MODPATH/module.prop
    return 1
  fi

  "$FRIDA_BIN" -D -l "127.0.0.1:$FRIDA_PORT"
}

wait_for_boot() {
  while true; do
    result="$(getprop sys.boot_completed)"
    if [ $? -ne 0 ]; then
      exit 1
    elif [ "$result" = "1" ]; then
      break
    fi
    sleep 3
  done
}

#EOF
