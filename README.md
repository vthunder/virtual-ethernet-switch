# virtual-ethernet-switch

A WebSocket server that acts as a virtual network gateway for the [Infinite Mac](https://infinitemac.org) emulator. Enables Mac OS 8 to browse the modern web through Netscape Navigator.

## What it does

- **ARP**: Responds to "who has 10.0.0.1?" with the gateway MAC address
- **DHCP**: Hands out IP config to the Mac (10.0.0.2, gateway 10.0.0.1, DNS 10.0.0.1)
- **DNS**: Resolves hostnames by forwarding to 8.8.8.8
- **ICMP**: Responds to pings (needed for Open Transport to confirm gateway reachability)
- **TCP + HTTP/1.0 proxy**: Accepts TCP connections from Netscape, fetches pages via WebOne, returns HTTP/1.0 responses
- **WebOne sidecar**: HTTP proxy that handles HTTPS→HTTP/1.0 downgrade and image conversion (PNG/WebP → JPEG 320×240)

## Virtual network

```
Mac IP:      10.0.0.2
Gateway IP:  10.0.0.1  (this server)
Gateway MAC: 02:00:00:00:00:01
Subnet:      255.255.255.0
DNS:         10.0.0.1
```

## Local development

```bash
npm install
npm run proxy   # start with full HTTP proxy (checkpoint 4)
```

Environment:
- `PORT` — WebSocket port (default: 3001)
- `CHECKPOINT` — 2=ARP only, 3=TCP passthrough, 4=full HTTP proxy

WebOne must be running on `127.0.0.1:8118` for HTTP proxying to work. See `webone-retro.conf` for config.

## Production (Docker)

```bash
docker build -t virtual-ethernet-switch .
docker run -p 3001:3001 virtual-ethernet-switch
```

The Dockerfile bundles Node 20 + .NET 8 runtime + WebOne 0.18.1. WebOne starts as a sidecar process on 127.0.0.1:8118.

## Architecture

```
Browser (Mac OS 8 emulator)
    │ WebSocket
    ▼
Cloudflare Worker (ethernet zone relay)
    │ WebSocket
    ▼
virtual-ethernet-switch  ← this repo
    │ HTTP forward proxy
    ▼
WebOne (sidecar, :8118)
    │ HTTPS downgrade + image resize
    ▼
Real internet
```
