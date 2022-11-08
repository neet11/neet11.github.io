# Nginx安装

> [docker安装nginx](/config_env/docker.md)

## Nginx 极简教程

[在线阅读](https://github.com/dunwu/nginx-tutorial)

## 本地创建ssl证书工具--mkcert

> <https://github.com/FiloSottile/mkcert>

### 源码安装

```bash
git clone https://github.com/FiloSottile/mkcert && cd mkcert
go build -ldflags "-X main.Version=$(git describe --tags)"
```

### 创建证书示例

```bash
$ mkcert -install
Created a new local CA 💥
The local CA is now installed in the system trust store! ⚡️
The local CA is now installed in the Firefox trust store (requires browser restart)! 🦊

$ mkcert example.com "*.example.com" example.test localhost 127.0.0.1 ::1

Created a new certificate valid for the following names 📜
 - "example.com"
 - "*.example.com"
 - "example.test"
 - "localhost"
 - "127.0.0.1"
 - "::1"

The certificate is at "./example.com+5.pem" and the key at "./example.com+5-key.pem" ✅
```

### nginx配置证书

```bash
ssl_certificate /usr/local/etc/nginx/ssl/example.com+5.pem;
ssl_certificate_key /usr/local/etc/nginx/ssl/example.com+5-key.pem;
ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
ssl_prefer_server_ciphers on;
ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES2
```

### nginx配置重载

```bash
nginx -t && nginx -s reload
```
