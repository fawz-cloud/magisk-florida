# MagiskFlorida
> [Frida](https://frida.re) is a dynamic instrumentation toolkit for developers, reverse-engineers, and security researchers

> MagiskFlorida runs an **anti-detection** frida-server (built from [Florida](https://github.com/Ylarod/Florida)) on boot with [Magisk](https://github.com/topjohnwu/Magisk), KernelSU and APatch

## Supported architectures
- `arm64`, `arm`, `x86`, `x86_64`

## Stealth
- Server binary is installed under a randomized name (defeats `pgrep frida-server` / cmdline scans)
- Anti-detection server spoofs frida string/symbol/thread signatures

## For issues and more information, check out the [project repo](https://github.com/fawz-cloud/magisk-florida)
