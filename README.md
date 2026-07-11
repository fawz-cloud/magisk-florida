# MagiskFlorida

Anti-detection fork of [MagiskFrida](https://github.com/ViRb3/magisk-frida): runs a
[Florida](https://github.com/Ylarod/Florida)-patched frida-server on boot, under a randomized
binary name.

> [Frida](https://frida.re) is a dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers

> [MagiskFrida](README.md) lets you run frida-server on boot with multiple root solutions

This fork ships an **anti-detection** server built from [Florida](https://github.com/Ylarod/Florida)
and adds module-level stealth: the server binary is installed under a randomized name and listens on
a non-default port, so `pgrep frida-server` / cmdline scans and the common `connect(127.0.0.1:27042)`
check both come up empty.

## Supported root solutions

[Magisk](https://github.com/topjohnwu/Magisk), [KernelSU](https://github.com/tiann/KernelSU) and [APatch](https://github.com/bmax121/APatch)

## Supported architectures

`arm64`, `arm`, `x86`, `x86_64`

## Instructions

Install `MagiskFrida.zip` from [the releases](https://github.com/ViRb3/magisk-frida/releases)

> :information_source: Do not use the Magisk modules repository, it is obsolete and no longer receives updates

## Connecting

The server listens on the default port `27042`, so the usual USB workflow works directly:

```bash
frida -U -f com.example.app -l script.js
# or target a specific device
frida -D <device-id> -f com.example.app -l script.js
```

For port-scan stealth, set a non-default `FRIDA_PORT` in [`base/utils.sh`](base/utils.sh) and
connect with `adb forward tcp:PORT tcp:PORT && frida -H 127.0.0.1:PORT`.

## How fast are frida-server updates?

Server binaries come from the [Florida fork](https://github.com/fawz-cloud/Florida), which tracks
upstream Frida releases

## Issues?

Check out the [troubleshooting guide](TROUBLESHOOTING.md)

## Building yourself

```bash
uv sync
uv run python3 main.py
```

- Release ZIP will be under `/build`
- frida-server downloads will be under `/downloads`
