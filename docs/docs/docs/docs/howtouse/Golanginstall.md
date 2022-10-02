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
 # @LastEditTime : 2022-10-02 01:09:19
 # @FilePath     : /shell/config-dev-env/install_golang.sh
### 


# global environment variable
go_sdk_version=1.19.1
go_sdk_package=go"${go_sdk_version}".linux-amd64.tar.gz

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
  echo "    -r          : remove golang env and exit"
  exit 1
}

# config files
function config_profile() {
  print_color "green" "config_profile"
  print_color "blue" "append go env to /etc/profile"

  if [ "$(grep -c "GOROOT" /etc/profile)" -eq '0' ] 
  then 
    append_profile="sudo tee -a /etc/profile"
    echo -e "\n#GOROOT PATH\nexport GOROOT=/usr/local/go" | $append_profile
    echo -e "#GOBIN PATH\nexport GOBIN=\$GOROOT/bin" | $append_profile
    echo -e "#GOHOME PATH\nexport GOPATH=\$HOME/go" | $append_profile
    echo -e "\nexport PATH=\$PATH:\$GOPATH:\$GOBIN:\$GOROOT" | $append_profile
    # shellcheck source=/dev/null
    source /etc/profile
  else
    print_color "blue" "/etc/profile has been added!"
  fi
  check_command_status "config_profile"

}
 
# get golang sdk url
function download_sdk_pkg() {
  print_color "green" "download_sdk_pkg"
  mkdir -p "${HOME}"/tools
  print_color "blue" "download golang sdk in ${HOME}/tools/"
  if [ ! -f "${HOME}"/tools/"${go_sdk_package}" ]
  then 
    wget -P "${HOME}"/tools https://gomirrors.org/dl/go/"${go_sdk_package}"
  fi
  check_command_status "download_sdk_pkg"
}

# unarchive sdk to dir
function install_go_sdk() {
  print_color "green" "install_go_sdk"
  if [ ! -d /usr/local/go ]
  then
    sudo tar -zxf "${HOME}"/tools/"${go_sdk_package}" -C /usr/local/
    check_command_status "unarchive_go_sdk"
    sudo mv /usr/local/go /usr/local/go"${go_sdk_version}"
    sudo ln -s /usr/local/go"${go_sdk_version}" /usr/local/go
    print_color "blue" "unarchive golang sdk in /usr/local/"
  else
    print_color "blue" "/usr/local/go directory already exists"
  fi
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
  config_profile && download_sdk_pkg && install_go_sdk && config_go_env && create_go_path && \
  check_command_status "run_install_golang"
  print_color "green" "golang-${go_sdk_version} installation completed!" 
  print_color "yellow" "exec \"source /etc/profile\" after installation completed !!!"
  exit 0
}

# clean go env
function clear_go_env() {
  print_color "green" "clear_go_env"
  sudo rm -rf "${HOME}"/go && \
  sudo rm -rf "${HOME}"/tools/go* && \
  sudo rm -rf /usr/local/go* && \
  sudo sed -i '/GOROOT/d'  /etc/profile > /dev/null && \
  sudo sed -i '/GOPATH/d'  /etc/profile > /dev/null && \
  sudo sed -i '/GOHOME/d'  /etc/profile > /dev/null && \
  sudo sed -i '/GOBIN/d'  /etc/profile > /dev/null && \
  sudo sed -i ':n;/^\n*$/{$! N;$d;bn}'  /etc/profile
  check_command_status "clear_go_env"
  print_color "green" "golang env clear completed!" 
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
        -r|remove)
          clear_go_env
        ;;
        *)
          print_color "red" "unknown parameter" && help
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