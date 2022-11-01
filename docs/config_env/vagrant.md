# vagrant安装

## 下载安装包

```bash
https://developer.hashicorp.com/vagrant/downloads
```

## 安装virtualbox

```bash
https://www.virtualbox.org/wiki/Downloads
```

## 查找vagrant box

> 安装对应虚拟机版本(virtualbox)

```bash
https://app.vagrantup.com/boxes/search
```

## 添加vagrant box到本地

```bash
# 添加本地下载box文件
vagrant box add centos7 H:\VagrantBox\centos7.box
# 查看添加是否成功
vagrant box list
```

## 创建虚拟机

> 创建存放Vagrantfile的文件夹：H:\Vagrantfile\centos7\

```bash
# 在vagrantfile文件夹下打开cmd执行如下命令
vagrant init centos7

# 启动虚拟机
vagrant up

# 进入虚拟机
vagrant ssh
```

> 虚拟机的默认用户是vagrant/vagrant，root用户的密码是vagrant 。

## 常用虚拟机管理命令

[参考文章](https://segmentfault.com/a/1190000019897182)

```yaml
启动虚拟机: vagrant up
登录虚拟机: vagrant ssh
重启虚拟机: vagrant reload
关闭虚拟机: vagrant halt
销毁虚拟机: vagrant destroy
```

## 示例Vagrantfile

```yaml
Vagrant.configure("2") do |config|
   (1..4).each do |i|
      
      #定义节点变量
      config.vm.define "node#{i}" do |node|
     
      # box配置
      node.vm.box = "ubuntu/xenial64"

      # 设置虚拟机的主机名
      node.vm.hostname = "node#{i}"

      # 设置虚拟机的IP
      node.vm.network "private_network", ip: "192.168.60.#{10+i}"

      # 设置主机与虚拟机的共享目录
      node.vm.synced_folder "/Users/meetmax", "/home/vagrant/code"
      # VirtaulBox相关配置
      node.vm.provider "virtualbox" do |v|

          # 设置虚拟机的名称
          v.name = "node#{i}"

          # 设置虚拟机的内存大小
          v.memory = 2048

          # 设置虚拟机的CPU个数
          v.cpus = 1
      end
  end
end
end
```
