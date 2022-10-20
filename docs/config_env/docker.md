# Docker安装

## docker启动mysql

```bash
docker run -itd --name mysql_dev -p 3306:3306  -v /home/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 mysql:8.0
```
