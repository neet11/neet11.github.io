# ansible

## 安装ansible

```bash
# Redhat/CentOS Linux
sudo yum install epel-release
sudo yum install ansible

# Debian/Ubuntu Linux
sudo apt-get update
sudo apt-get install ansible
```

## 配置ansible管理节点免密登录

```bash
# 生成ssh密钥
ssh-keygen
# 复制ssh密钥至远程节点
ssh-copy-id remote_user@remote_server
# 关闭ssh是否保存密码提示
ssh-keyscan remote_server >> ~/.ssh/know_hosts
```

## 配置主机目录

> Host Inventory，主机清单配置文件，保存被管理主机信息

```bash
# 默认配置文件：/etc/ansible/hosts

# 示例
[all]
192.168.60.22
192.168.60.23

[webservers]
one.webserver.com
two.webserver.com

[dbservers]
one.database.com
two.database.com
```

## ansible命令行管理主机

### ansible 命令格式

```bash
ansible <host-pattern> [option]
```

### ansible 命令功能示例

1.检查管理主机是否可以访问

```bash
ansible all -m ping
```

2.执行命令

```bash
ansible all -a "/bin/echo hello world"
```

3.复制文件

```bash
ansible webservers -m copy -a "src=/etc/hosts dest=/tmp/hosts"
```

4.安装软件包

```bash
ansible webservers -m yum -a "name=acme state=present"
```

5.添加用户

```bash
ansible all -m user -a "name=someone password=<crypted password>"
```

6.启动服务

```bash
ansible webservers -m service -a "name=httpd state=started"
```

7.查看获取到的远程主机信息

```bash
ansible all -m setup
```

## ansible使用脚本管理主机

> ansible 脚本名字叫做playbook，使用yaml格式

### 执行脚本示例

```bash
ansible-playbook demo.yml
```

### playbook结构示例

* hosts: 被管理主机ip，主机清单中的主机组，全部主机all
* remote_user: 已某个用户身份执行
* vars: 变量
* tasks: 定义顺序执行的action，每个action调用一个模块，playbook核心  
    1.action语法: module: module_parameter=module_value  
    2.常用模块: yum、copy、template等，相当于bash脚本中的yum、copy等命令
* handers: playbook 的事件处理操作，仅在被action触发时执行，多次触发只执行一次，且按照声明顺序执行

### playbook完整示例如下

```yaml
---
- hosts: webservers
  vars:
    http_port: 80
    max_clients: 200
  remote_user: root
  tasks:
  - name: ensure apache is at the latest version
    yum: pkg=httpd state=latest
  - name: write the apache config file
    template: src=/srv/httpd.j2 dest=/etc/httpd.conf
    notify:
    - restart apache
  - name: ensure apache is running
    service: name=httpd state=started
  handlers:
    - name: restart apache
      service: name=httpd state=restarted
```
