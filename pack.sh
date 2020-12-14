#! /bin/sh

go build
zip go-shadowsocks2-socks5_linux64.zip go-shadowsocks2-socks5

GOOS=darwin GOARCH=amd64 go build
zip go-shadowsocks2-socks5_mac.zip go-shadowsocks2-socks5

GOOS=windows GOARCH=amd64 go build
zip go-shadowsocks2-socks5_windows64.zip go-shadowsocks2-socks5.exe

GOOS=linux GOARCH=mipsle go build
zip go-shadowsocks2-socks5_mipsle.zip go-shadowsocks2-socks5

GOOS=linux GOARCH=arm go build
zip go-shadowsocks2-socks5_arm.zip go-shadowsocks2-socks5

GOOS=linux GOARCH=mips go build
zip go-shadowsocks2-socks5_mips.zip go-shadowsocks2-socks5

GOOS=windows GOARCH=386 go build
zip go-shadowsocks2-socks5_windows32.zip go-shadowsocks2-socks5.exe

GOOS=linux GOARCH=arm64 go build
zip go-shadowsocks2-socks5_arm64.zip go-shadowsocks2-socks5

GOOS=linux GOARCH=mips64 go build
zip go-shadowsocks2-socks5_mips64.zip go-shadowsocks2-socks5

GOOS=linux GOARCH=mips64le go build
zip go-shadowsocks2-socks5_mips64le.zip go-shadowsocks2-socks5
