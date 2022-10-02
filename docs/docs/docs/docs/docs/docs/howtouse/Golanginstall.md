# Golang安装

<!--sec data-title="Install Go" data-id="section0" data-show=true ces-->

```bash
#!/usr/bin/env bash

###
 # @Descripttion : Install Go Sdk In Linux
 # @version      : v1.0.0
 # @Author       : neet11 neetwy@163.com
 # @Date         : 2022-09-27 03:01:36
 # @LastEditors  : neet11 neetwy@163.com
 # @LastEditTime : 2022-09-30 13:30:17
 # @FilePath     : /shell/config-dev-env/install_golang.sh
### 


# global environment variable
go_sdk_version=1.19.1

# define:info(32green) warn(31red) process(33yellow)
function print_color () {
  case $1 in
    red) echo -e "\033[31m$2 \033[0m" ;;
    green) echo -e "\033[32m$2 \033[0m" ;;
    yellow) echo -e "\033[33m$2 \033[0m" ;;
    blue) echo -e "\033[34m$2 \033[0m" ;;
    *) echo -e "\033[31m[Color Error]$2 \033[0m" ;;
   esac
}

# check the command execution status
function check_command_status () {
  if [ $? -eq 0 ]; then
    print_color "green" "$1 executed successfully"
  else
    print_color "red" "$1 execution failed"
    exit 1
  fi
}

# show help info
function help() {
  echo "Usage:"
  echo "    -h          : display this help and exit"
  echo "    -v          : input golang version default 1.19.1"
  exit 1
}

# config files
function config_profile() {
  print_color "green" "config_profile"
  print_color "blue" "append go env to /etc/profile"
  echo "
  #GOROOT PATH
  export GOROOT=/usr/local/go
  #GOBIN PATH
  export GOBIN=\$GOROOT/bin
  #GOHOME PATH
  export GOPATH=\$HOME/go
  export PATH=\$PATH:\$GOPATH:\$GOBIN:\$GOROOT 
  " | sudo tee -a /etc/profile > /dev/null
  check_command_status "config_profile"

  # shellcheck source=/dev/null
  source /etc/profile
}
 
# get golang sdk url
function wget_sdk_url() {
  print_color "green" "wget_sdk_url"
  mkdir -p "$HOME"/tools
  print_color "blue" "download golang sdk in ${HOME}/tools/"
  wget -P "${HOME}"/tools https://studygolang.com/dl/golang/go"${go_sdk_version}".linux-amd64.tar.gz
  check_command_status "wget_sdk_url"
}

# unarchive sdk to dir
function install_go_sdk() {
  print_color "green" "install_go_sdk"
  sudo tar -zxf "${HOME}"/tools/go"${go_sdk_version}".linux-amd64.tar.gz -C /usr/local/
  check_command_status "unarchive_go_sdk"
  print_color "blue" "unarchive golang sdk in /usr/local/"
  sudo mv /usr/local/go /usr/local/go"${go_sdk_version}"
  sudo ln -s /usr/local/go"${go_sdk_version}" /usr/local/go
  check_command_status "install_go_sdk"
}

# config go path env
function config_go_env() {
  print_color "green" "config_go_env"
  go env -w GO111MODULE=on && \
  go env -w GOPROXY=https://goproxy.cn,direct && \
  go env -w GOROOT=/usr/local/go && \
  go env -w GOBIN=/usr/local/go/bin && \
  go env -w GOPATH="${HOME}"/go
  check_command_status "config_go_env"
}

# create go paht dir
function create_go_path() {
  print_color "green" "create_go_path"
  mkdir -p "${HOME}"/go/{bin,pkg,src}
  print_color "blue" "create golang path in ${HOME}/go"
  check_command_status "create_go_path"
}

# entry function 
function run_install_golang() {
  print_color "green" "run_install_golang"
  config_profile && wget_sdk_url && install_go_sdk && config_go_env && create_go_path && \
  check_command_status "run_install_golang"
  print_color "green" "golang-${go_sdk_version} installation completed!" 
  print_color "red" "exec \"source /etc/profile\" after installation completed !!!"
  exit 0
}

function main() {

  if [ $# -ne 0 ]
  then
    case $1 in
        -h|help)
          help
        ;;
        -v|version)
          go_sdk_version=$2
          run_install_golang
        ;;
        *)
        echo "unknown parameter" && help
        ;;
    esac
  else
    run_install_golang
  fi
}

# run script
main "$@"
```

<!--endsec-->