# Golang安装

## 默认安装

```bash
curl -sSL https://my5353.com/confgo | bash
```

## 使用帮助

```bash
curl -sSL https://my5353.com/confgo | bash /dev/stdin -h
```

## 安装指定版本

```bash
curl -sSL https://my5353.com/confgo | bash /dev/stdin -v "1.18.6"
```

## 清除已安装环境

```bash
curl -sSL https://my5353.com/confgo | bash /dev/stdin -r
```

## 完整脚本

<!--sec data-title="Install Go" data-id="section0" data-show=true ces-->

```bash
#!/usr/bin/env bash

###
 # @Descripttion : Install Go Sdk In Linux
 # @version      : v1.0.0
 # @Author       : neet11 neetwy@163.com
 # @Date         : 2022-09-27 03:01:36
 # @LastEditors  : neet11 neetwy@163.com
 # @LastEditTime : 2022-10-09 09:18:56
 # @FilePath     : /shell/config-dev-env/install_golang.sh
### 

#set -o xtrace           # Print commands and their arguments

set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline


# global constant
TAG="CMD"
# LOG_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )/logs
LOG_PATH="/tmp/shell/logs"
LOG_FILE="${LOG_PATH}/install_golang_$(date +"%Y%m%d").log"
HIDE_LOG=true

# global environment variable
go_sdk_version="1.19.1"
go_sdk_package="go${go_sdk_version}.linux-amd64.tar.gz"


# log handler
function log() {
    [ ! -d "${LOG_PATH}" ] && mkdir -p "${LOG_PATH}"
    if [ $HIDE_LOG ]; then
        echo -e "[$(date +"%Y/%m/%d:%H:%M:%S %z")] [$(whoami)] [$TAG]" "${@}" >> "${LOG_FILE}"
    else
        echo "[$(date +"%Y/%m/%d:%H:%M:%S %z")] [$(whoami)] [$TAG]" "${@}" | tee -a "${LOG_FILE}"
    fi
}

# trap err signal
function script_trap_err() {
    local exit_code=1

    # Disable the error trap handler to prevent potential recursion
    trap - ERR

    # Consider any further errors non-fatal to ensure we run to completion
    set +o errexit
    set +o pipefail

    log "[E] ERROR" "${@}" 
    status_closure clear_go_env

    exit "$exit_code"
}

# trap exit signal
function script_trap_exit() {
    log "[I] shell exec done."
}

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
function status_closure () {
  print_color "green" "${1}"
  eval "${*}"
  print_color "green" "${1} executed successfully"
}

# show help info
function help() {
  echo "Usage: ./install_golang.sh [-h -r] [-v version]"
  echo "    -h          : display this help and exit"
  echo "    -v          : input golang version default 1.19.1"
  echo "    -r          : remove golang env and exit"
  exit 0
}

# config files
function config_profile() {
  print_color "blue" "append go env to /etc/profile"

  if [ "$(grep -c "GOROOT" /etc/profile)" -eq '0' ] 
  then 
    append_profile="sudo tee -a /etc/profile"
    echo -e "\n#GOROOT PATH\nexport GOROOT=/usr/local/go" | $append_profile
    echo -e "#GOHOME PATH\nexport GOPATH=\$HOME/go" | $append_profile
    echo -e "#GOBIN PATH\nexport GOBIN=\$GOPATH/bin" | $append_profile
    echo -e "\nexport PATH=\$PATH:\$GOPATH:\$GOBIN:\$GOROOT/bin" | $append_profile
    # shellcheck source=/dev/null
    source /etc/profile
  else
    print_color "blue" "/etc/profile has been added!"
  fi
}
 
# get golang sdk url
function download_sdk_pkg() {
  mkdir -p "${HOME}"/tools
  print_color "blue" "download golang sdk in ${HOME}/tools/"
  if [ ! -f "${HOME}"/tools/"${go_sdk_package}" ]
  then 
    wget -P "${HOME}"/tools https://go.dev/dl/"${go_sdk_package}"
  fi
}

# unarchive sdk to dir
function install_go_sdk() {
  if [ ! -d /usr/local/go"${go_sdk_version}" ]
  then
    sudo tar -zxf "${HOME}"/tools/"${go_sdk_package}" -C /usr/local/
    print_color "green" "unarchive_go_sdk executed successfully"
    sudo mv /usr/local/go /usr/local/go"${go_sdk_version}"
    print_color "blue" "unarchive golang sdk in /usr/local/"
  else
    print_color "blue" "/usr/local/go directory already exists"
    sudo rm -rf /usr/local/go
  fi
  sudo ln -s /usr/local/go"${go_sdk_version}" /usr/local/go
}

# config go path env
function config_go_env() {
  go env -w GO111MODULE=on && \
  go env -w GOPROXY=https://goproxy.cn,direct && \
  go env -w GOROOT=/usr/local/go && \
  go env -w GOBIN="${HOME}/go/bin" && \
  go env -w GOPATH="${HOME}/go"
}

# create go paht dir
function create_go_path() {
  mkdir -p "${HOME}"/go/{bin,pkg,src}
  print_color "blue" "create golang path in ${HOME}/go"
}

# entry function 
function run_install_golang() {
  status_closure config_profile 
  status_closure download_sdk_pkg
  status_closure install_go_sdk
  status_closure config_go_env
  status_closure create_go_path
  print_color "green" "golang-${go_sdk_version} installation completed!" 
  print_color "yellow" "exec \"source /etc/profile\" after installation completed !!!"
}

# clean go env
function clear_go_env() {
  sudo rm -rf "${HOME}"/go && \
  sudo rm -rf "${HOME}"/tools/go* && \
  sudo rm -rf /usr/local/go* && \
  sudo sed -i '/GOROOT/d'  /etc/profile > /dev/null && \
  sudo sed -i '/GOPATH/d'  /etc/profile > /dev/null && \
  sudo sed -i '/GOHOME/d'  /etc/profile > /dev/null && \
  sudo sed -i '/GOBIN/d'  /etc/profile > /dev/null && \
  sudo sed -i ':n;/^\n*$/{$! N;$d;bn}'  /etc/profile
  print_color "green" "golang env clear completed!" 
}

function main() {
  trap script_trap_err INT TERM QUIT HUP ERR
  trap script_trap_exit EXIT
  log "[I] shell start"

  if [ $# -ne 0 ]
  then
    case $1 in
        -h|help)
          help
        ;;
        -v|version)
          go_sdk_version=$2
          go_sdk_package=go"${go_sdk_version}".linux-amd64.tar.gz
          status_closure run_install_golang
        ;;
        -r|remove)
          status_closure clear_go_env
        ;;
        *)
          print_color "red" "unknown parameter" && help
        ;;
    esac
  else
    status_closure run_install_golang
  fi
}

# run script
main "${@}"
```
<!--endsec-->