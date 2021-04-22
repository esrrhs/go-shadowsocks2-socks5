FROM golang AS build-env

RUN GO111MODULE=off go get -u github.com/esrrhs/go-shadowsocks2-socks5
RUN GO111MODULE=off go get -u github.com/esrrhs/go-shadowsocks2-socks5/...
RUN GO111MODULE=off go install github.com/esrrhs/go-shadowsocks2-socks5

FROM debian
COPY --from=build-env /go/bin/go-shadowsocks2-socks5 .
WORKDIR ./
