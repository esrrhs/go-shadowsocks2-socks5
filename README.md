# go-shadowsocks2-socks5
增加一条ss server到socks5 server的转发链路，方便利用起现有的socks5 server
```
curl google.com-->ss client-->ss server-->socks5 server-->google.com
```
用法为添加-ss参数，指明socks5 server地址，例如：
```
go-shadowsocks2-socks5 -s 'ss://AEAD_CHACHA20_POLY1305:your-password@:8488' -verbose -ss yoursocks5server.com:1080
```
如果有多个socks5 server，可以使用[socksfilter](https://github.com/esrrhs/socksfilter)，go-shadowsocks2详细用法参考[go-shadowsocks2](https://github.com/shadowsocks/go-shadowsocks2)
