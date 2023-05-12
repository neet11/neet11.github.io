# Docker安装

## 一键安装脚本

```bash
curl -sSL https://get.daocloud.io/docker | sh
```

## 普通用户使用docker

```bash
sudo groupadd docker               # 创建docker组
sudo usermod -aG docker $USER      # 加入当前用户到docker组
newgrp docker                      # 刷新docker组

# 普通用户测试使用docker
docker run hello-world             
```

## docker启动mysql

```bash
docker run -itd --name mysql_dev -p 3306:3306 \
-v /home/mysql/data:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=123456 \
-d mysql:8.0
```

## docker启动nginx

### 创建挂载目录

```bash
mkdir -p /data/docker/nginx/conf/vhost
mkdir -p /data/docker/nginx/logs
mkdir -p /data/docker/nginx/html
mkdir -p /data/docker/nginx/ssl
```

### 配置nginx.conf

```nginx
# vi /data/docker/nginx/conf/nginx.conf
user nginx;
worker_processes 4; 
worker_cpu_affinity 0001 0010 0100 1000;
worker_rlimit_core 768m;
worker_rlimit_nofile 65536;
 
events {
    worker_connections 65535;
    use epoll;
    epoll_events 1024;
}
 
http {
    include mime.types;
    default_type application/octet-stream;
 
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
    '$status $body_bytes_sent "$http_referer" '
    '"$http_user_agent" "$http_x_forwarded_for" $request_time '
    '"$host" "$upstream_addr" "$upstream_status" "$upstream_response_time" '
 
    access_log off;
 
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    server_names_hash_bucket_size 128;
    client_max_body_size 100m;
    client_body_buffer_size 1024k;
    client_header_timeout 250;
    max_ranges 10;
    send_timeout 450;
    keepalive_timeout 750;
    server_name_in_redirect off;
    server_tokens off;
 
 
    gzip on;
    gzip_buffers 4 16k;
    gzip_comp_level 9;
    gzip_http_version 1.0;
    gzip_min_length 800;
    gzip_proxied any;
    gzip_types text/plain application/x-javascript text/css text/javascript application/x-httpd-php image/jpeg image/gif image/png image/jpg;
    gzip_vary on;
 
    proxy_set_header Connection Keep-Alive;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
 
 
    include /etc/nginx/conf.d/*.conf;
}
```

```nginx
# vi /data/docker/nginx/conf/vhost/test.conf
server {
    listen 80;
    server_name 192.168.60.21;

    # listen    443 ssl;
    # server_name www.test.com;

    # ssl_certificate /ssl/server.crt;
    # ssl_certificate_key /ssl/server.key;

    location / {
        root   html;
        index  index.html index.htm;
    }
}
```

## 运行nginx容器

```bash
docker run --restart=always --name=nginx -it -p 80:80 \
-v /data/docker/nginx/conf/vhost:/etc/nginx/conf.d:rw \
-v /data/docker/nginx/logs:/var/log/nginx:rw \
-v /data/docker/nginx/conf/nginx.conf:/etc/nginx/nginx.conf:rw \
-v /data/docker/nginx/html:/etc/nginx/html:rw \
-d nginx:latest
```

## 配置ssl证书

> [生成本地证书](/config_env/nginx.md)

```bash
docker run --restart=always --name=nginx -it -p 80:80 -p 443:443 \
-v /data/docker/nginx/conf/vhost:/etc/nginx/conf.d:rw \
-v /data/docker/nginx/logs:/var/log/nginx:rw \
-v /data/docker/nginx/conf/nginx.conf:/etc/nginx/nginx.conf:rw \
-v /data/docker/nginx/html:/etc/nginx/html:rw \
-v /data/docker/nginx/ssl:/ssl:rw \
-d nginx:latest
```
