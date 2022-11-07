# 常用命令总结

<!--sec data-title="ss命令" data-id="section0" data-show=true ces-->
## 常用选项

> [参考地址](https://cloud.tencent.com/developer/article/1721800)

```bash
 -h, –help 帮助
 -V, –version 显示版本号
 -t, –tcp 显示 TCP 协议的 sockets
 -u, –udp 显示 UDP 协议的 sockets
 -x, –unix 显示 unix domain sockets，与 -f 选项相同
 -n, –numeric 不解析服务的名称，如 “22” 端口不会显示成 “ssh”
 -l, –listening 只显示处于监听状态的端口
 -p, –processes 显示监听端口的进程
 -a, –all 对 TCP 协议来说，既包含监听的端口，也包含建立的连接
 -r, –resolve 把 IP 解释为域名，把端口号解释为协议名称
```

## 常用示例

* **显示概要信息**

```bash
ss -s
```

* **查看主机监听的端口**

```bash
ss -ntl
```

* **解析 IP 和端口号**

```bash
ss -tlr
```

* **查看监听端口的程序名称**

```bash
ss -tlp
```

* **查看建立的 TCP 连接**

```bash
ss -nta
```

<!--endsec-->