#! /bin/bash
set -e
NAME="go-shadowsocks2-socks5"
VERSION=$(grep -E '^\s*Version\s*=\s*"[^"]+"' version/version.go | sed -E 's/.*"([^"]+)".*/\1/')
GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo unknown)
BUILD_TIME=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
LDFLAGS="-s -w -X 'github.com/esrrhs/go-shadowsocks2-socks5/version.Version=${VERSION}' -X 'github.com/esrrhs/go-shadowsocks2-socks5/version.GitCommit=${GIT_COMMIT}' -X 'github.com/esrrhs/go-shadowsocks2-socks5/version.BuildTime=${BUILD_TIME}'"

build_list=$(go tool dist list)

rm -rf pack
rm -f pack.zip
mkdir pack

for line in $build_list; do
  os=$(echo "$line" | awk -F"/" '{print $1}')
  arch=$(echo "$line" | awk -F"/" '{print $2}')
  echo "os=$os arch=$arch start build"
  if [ "$os" = "android" ] || [ "$os" = "ios" ] || [ "$arch" = "wasm" ]; then
    continue
  fi
  BIN_NAME="$NAME"
  if [ "$os" = "windows" ]; then
    BIN_NAME="$NAME.exe"
  fi
  CGO_ENABLED=0 GOOS=$os GOARCH=$arch go build -ldflags="$LDFLAGS" -o "$BIN_NAME" .
  ARCHIVE_NAME="${NAME}_${VERSION}_${os}_${arch}"
  if [ "$os" = "windows" ]; then
    zip "pack/${ARCHIVE_NAME}.zip" "$BIN_NAME"
    rm -f "$BIN_NAME"
  else
    tar -czvf "pack/${ARCHIVE_NAME}.tar.gz" "$BIN_NAME"
    rm -f "$BIN_NAME"
  fi
  echo "os=$os arch=$arch done build"
done

zip -r pack.zip pack/

echo "all done (version $VERSION)"
