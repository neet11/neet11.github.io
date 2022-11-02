# NodeJs安装

## 默认安装

```bash
curl -sSL https://my5353.com/confnode | bash
```

## 使用帮助

```bash
curl -sSL https://my5353.com/confnode | bash /dev/stdin -h
```

## 安装指定版本

```bash
curl -sSL https://my5353.com/confnode | bash /dev/stdin -v "v1.16.17.1"
```

## 清除已安装环境

```bash
curl -sSL https://my5353.com/confnode | bash /dev/stdin -r
```

## 完整脚本

<!--sec data-title="Install Go" data-id="section0" data-show=true ces-->

```bash
#!/usr/bin/env bash

###
 # @Descripttion : Install NodeJs In Linux
 # @version      : v1.0.0
 # @Author       : neet11 neetwy@163.com
 # @Date         : 2022-09-27 03:01:36
 # @LastEditors  : neet11 neetwy@163.com
 # @LastEditTime : 2022-10-09 10:18:58
 # @FilePath     : /shell/config-dev-env/install_nodejs.sh
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
LOG_FILE="${LOG_PATH}/install_nodejs_$(date +"%Y%m%d").log"
HIDE_LOG=true

# global environment variable
nodejs_version="v18.12.0"
nodejs_package="node-${nodejs_version}-linux-x64.tar.xz"
nodejs_dir="node-${nodejs_version}-linux-x64"

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
  echo "Usage: ./install_nodejs.sh [-h -r] [-v version]"
  echo "    -h          : display this help and exit"
  echo "    -v          : input nodejs version default v18.12.0"
  echo "    -r          : remove nodejs env and exit"
  exit 0
}

# download node pkg
function download_node_pkg() {
  mkdir -p "${HOME}"/tools
  print_color "blue" "download nodejs pkg in ${HOME}/tools/"
  if [ ! -f "${HOME}"/tools/"${nodejs_package}" ]
  then 
    wget -P "${HOME}"/tools https://nodejs.org/dist/"${nodejs_version}"/"${nodejs_package}"
  fi
}

# unarchive nodejs pkg to dir
function install_node_pkg() {
  if [ ! -d /usr/local/"${nodejs_dir}" ]
  then
    sudo tar -xf "${HOME}"/tools/"${nodejs_package}" -C /usr/local/
    print_color "green" "unarchive_node_pkg executed successfully"
  else
    print_color "blue" "/usr/local/node directory already exists"
    if [ -d /usr/local/node ]
    then
      sudo rm -rf /usr/local/node
    fi
  fi
  sudo ln -s /usr/local/"${nodejs_dir}" /usr/local/node
  sudo ln -s /usr/local/node/bin/npm /usr/local/bin/ 
  sudo ln -s /usr/local/node/bin/node /usr/local/bin/
}

# create node paht dir
function create_node_path() {
  if [ ! -d "${HOME}"/node/ ]
  then
    mkdir -p "${HOME}"/node/
    print_color "blue" "create node path in ${HOME}/node/"
  fi
}

# entry function 
function run_install_node() {
  status_closure download_node_pkg
  status_closure install_node_pkg
  status_closure create_node_path
  print_color "green" "node-${nodejs_version} installation completed!" 
  print_color "yellow" "exec node -v and npm -v after installation completed !!!"
  print_color "green" "node -v:" && node -v
  print_color "green" "npm -v:" && npm -v
}

# clean node env
function clear_node_env() {
  sudo rm -rf "${HOME}"/node && \
  sudo rm -rf "${HOME}"/tools/node* && \
  sudo rm -rf /usr/local/node* && \
  sudo rm -rf /usr/local/bin/node && \
  sudo rm -rf /usr/local/bin/npm && \
  print_color "green" "node env clear completed!" 
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
          nodejs_version=$2
          nodejs_package="node-${nodejs_version}-linux-x64.tar.xz"
          nodejs_dir="node-${nodejs_version}-linux-x64"
          status_closure run_install_node
        ;;
        -r|remove)
          status_closure clear_node_env
        ;;
        *)
          print_color "red" "unknown parameter" && help
        ;;
    esac
  else
    status_closure run_install_node
  fi
}

# run script
main "${@}"
```
<!--endsec-->