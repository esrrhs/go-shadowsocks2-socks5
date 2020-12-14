# go-shadowsocks2-socks5
增加一条ss server到socks5 server的转发链路，方便利用起现有的socks5 server
```
curl google.com-->ss client-->ss server-->socks5 server-->google.com
```
用法：
```
go-shadowsocks2 -s 'ss://AEAD_CHACHA20_POLY1305:your-password@:8488' -verbose -ss yoursocks5server.com:1080
```
