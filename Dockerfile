FROM golang:1.23 AS build-env
WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 go build -ldflags="-s -w" -o /out/go-shadowsocks2-socks5 .

FROM debian:bookworm-slim
COPY --from=build-env /out/go-shadowsocks2-socks5 /go-shadowsocks2-socks5
ENTRYPOINT ["/go-shadowsocks2-socks5"]
