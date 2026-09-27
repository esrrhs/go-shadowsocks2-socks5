# go-shadowsocks2-socks5

[<img src="https://img.shields.io/github/license/esrrhs/go-shadowsocks2-socks5">](https://github.com/esrrhs/go-shadowsocks2-socks5)
[<img src="https://img.shields.io/github/languages/top/esrrhs/go-shadowsocks2-socks5">](https://github.com/esrrhs/go-shadowsocks2-socks5)
[<img src="https://img.shields.io/github/v/release/esrrhs/go-shadowsocks2-socks5">](https://github.com/esrrhs/go-shadowsocks2-socks5/releases)
[<img src="https://img.shields.io/github/downloads/esrrhs/go-shadowsocks2-socks5/total">](https://github.com/esrrhs/go-shadowsocks2-socks5/releases)
[<img src="https://img.shields.io/docker/pulls/esrrhs/go-shadowsocks2-socks5">](https://hub.docker.com/repository/docker/esrrhs/go-shadowsocks2-socks5)
[<img src="https://img.shields.io/github/actions/workflow/status/esrrhs/go-shadowsocks2-socks5/go.yml?branch=master">](https://github.com/esrrhs/go-shadowsocks2-socks5/actions)

A fork of [go-shadowsocks2](https://github.com/shadowsocks/go-shadowsocks2) that adds an optional Shadowsocks-to-SOCKS5 backend hop on the server side, so you can reuse an existing SOCKS5 proxy as the egress path.

## What This Adds

In stock go-shadowsocks2, the server dials the destination host directly after decrypting the client request.

This fork adds `-ss`, which makes the Shadowsocks server forward each TCP connection through an upstream SOCKS5 server instead:

```text
client --> ss client --> ss server --> socks5 server --> destination
```

Typical use cases:

- Reuse an existing SOCKS5 egress (corporate proxy, residential proxy, another tunnel endpoint)
- Aggregate or filter multiple SOCKS5 backends with [socksfilter](https://github.com/esrrhs/socksfilter)
- Keep Shadowsocks as the public-facing protocol while letting SOCKS5 handle the final hop

Without `-ss`, behavior matches upstream go-shadowsocks2 (direct dial).

## Features

Inherited from go-shadowsocks2:

- SOCKS5 proxy with UDP Associate (client)
- AEAD ciphers only (modern Shadowsocks)
- TCP / UDP tunneling
- SIP003 plugins
- Replay attack mitigation (Bloom filter)
- Linux Netfilter redirect and macOS Packet Filter redirect

Added in this fork:

- `-ss` server option: forward decrypted TCP traffic to a SOCKS5 backend

## Install

### From source

```sh
go install github.com/esrrhs/go-shadowsocks2-socks5@latest
```

### Pre-built binaries

Download release packages from [Releases](https://github.com/esrrhs/go-shadowsocks2-socks5/releases).

### Docker

```sh
docker pull esrrhs/go-shadowsocks2-socks5
```

## Quick Start (SOCKS5 Backend)

### 1. Shadowsocks server with SOCKS5 egress

Listen on `:8488`, decrypt with `AEAD_CHACHA20_POLY1305`, and forward every TCP request to `yoursocks5server.com:1080`:

```sh
go-shadowsocks2-socks5 \
  -s 'ss://AEAD_CHACHA20_POLY1305:your-password@:8488' \
  -verbose \
  -ss yoursocks5server.com:1080
```

### 2. Shadowsocks client (unchanged)

Any Shadowsocks client works. Example with this binary:

```sh
go-shadowsocks2-socks5 \
  -c 'ss://AEAD_CHACHA20_POLY1305:your-password@[server_address]:8488' \
  -verbose \
  -socks :1080 \
  -u
```

Traffic path:

```text
curl --> local SOCKS (:1080) --> ss client --> ss server --> remote SOCKS5 --> internet
```

### Multiple SOCKS5 backends

Point `-ss` at a local [socksfilter](https://github.com/esrrhs/socksfilter) instance to load-balance or geo-route across several SOCKS5 servers.

## Basic Usage (Same as Upstream)

### Server (direct egress)

```sh
go-shadowsocks2-socks5 -s 'ss://AEAD_CHACHA20_POLY1305:your-password@:8488' -verbose
```

### Client

```sh
go-shadowsocks2-socks5 \
  -c 'ss://AEAD_CHACHA20_POLY1305:your-password@[server_address]:8488' \
  -verbose \
  -socks :1080 \
  -u \
  -udptun :8053=8.8.8.8:53,:8054=8.8.4.4:53 \
  -tcptun :8053=8.8.8.8:53,:8054=8.8.4.4:53
```

Password can also be provided via the `SS_PASSWORD` environment variable when `-password` / URL password is empty.

## Docker Usage

Server with SOCKS5 backend:

```sh
docker run --name ss-socks5 -d --restart=always \
  -p 8488:8488 \
  esrrhs/go-shadowsocks2-socks5 \
  -s 'ss://AEAD_CHACHA20_POLY1305:your-password@:8488' \
  -verbose \
  -ss yoursocks5server.com:1080
```

On Linux, host networking is also fine:

```sh
docker run --name ss-socks5 -d --restart=always \
  --network host \
  esrrhs/go-shadowsocks2-socks5 \
  -s 'ss://AEAD_CHACHA20_POLY1305:your-password@:8488' \
  -verbose \
  -ss yoursocks5server.com:1080
```

## Notable Flags

| Flag | Mode | Description |
|------|------|-------------|
| `-s` | server | Server listen address or `ss://` URL |
| `-c` | client | Client remote address or `ss://` URL |
| `-ss` | server | Upstream SOCKS5 address (`host:port`). Empty = direct dial |
| `-socks` | client | Local SOCKS5 listen address |
| `-u` | client | Enable UDP for local SOCKS |
| `-cipher` | both | Cipher name (default `AEAD_CHACHA20_POLY1305`) |
| `-password` | both | Password (or use `SS_PASSWORD`) |
| `-plugin` / `-plugin-opts` | both | SIP003 plugin |
| `-udp` | server | Enable UDP support |
| `-verbose` | both | Verbose logging |

For full upstream option details (redir, tcptun/udptun, replay-filter env vars, plugins), see [go-shadowsocks2](https://github.com/shadowsocks/go-shadowsocks2).

## Build

```sh
# local binary
go build -o go-shadowsocks2-socks5

# print version
./go-shadowsocks2-socks5 -version

# cross-platform release packages
./pack.sh
```

Releases are published automatically by CI when `version/version.go` is updated on `master` (or when a version tag is pushed).
## Related Projects

- [go-shadowsocks2](https://github.com/shadowsocks/go-shadowsocks2) — upstream Shadowsocks implementation
- [socksfilter](https://github.com/esrrhs/socksfilter) — SOCKS5 routing / aggregation for multiple backends

## License

Same as upstream: MIT. See [LICENSE](LICENSE).
