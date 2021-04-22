# go-shadowsocks2-socks5

[<img src="https://img.shields.io/github/license/esrrhs/go-shadowsocks2-socks5">](https://github.com/esrrhs/go-shadowsocks2-socks5)
[<img src="https://img.shields.io/github/languages/top/esrrhs/go-shadowsocks2-socks5">](https://github.com/esrrhs/go-shadowsocks2-socks5)
[![Go Report Card](https://goreportcard.com/badge/github.com/esrrhs/go-shadowsocks2-socks5)](https://goreportcard.com/report/github.com/esrrhs/go-shadowsocks2-socks5)
[<img src="https://img.shields.io/github/v/release/esrrhs/go-shadowsocks2-socks5">](https://github.com/esrrhs/go-shadowsocks2-socks5/releases)
[<img src="https://img.shields.io/github/downloads/esrrhs/go-shadowsocks2-socks5/total">](https://github.com/esrrhs/go-shadowsocks2-socks5/releases)
[<img src="https://img.shields.io/docker/pulls/esrrhs/go-shadowsocks2-socks5">](https://hub.docker.com/repository/docker/esrrhs/go-shadowsocks2-socks5)

增加一条ss server到socks5 server的转发链路，方便利用起现有的socks5 server
```
curl google.com-->ss client-->ss server-->socks5 server-->google.com
```
用法为添加-ss参数，指明socks5 server地址，例如：
```
go-shadowsocks2-socks5 -s 'ss://AEAD_CHACHA20_POLY1305:your-password@:8488' -verbose -ss yoursocks5server.com:1080
```
如果有多个socks5 server，可以使用[socksfilter](https://github.com/esrrhs/socksfilter)，更多go-shadowsocks2详细用法参考[go-shadowsocks2](https://github.com/shadowsocks/go-shadowsocks2)
