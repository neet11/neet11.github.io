# vagrant安装

## 常用虚拟机管理命令

[参考文章](https://segmentfault.com/a/1190000019897182)

```yaml
启动虚拟机: vagrant up
登录虚拟机: vagrant ssh
重启虚拟机: vagrant reload
关闭虚拟机: vagrant halt
销毁虚拟机: vagrant destroy
```

## 修改 Vagrantfile

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
