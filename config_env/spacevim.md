# Spacevim安装

## 默认安装

```bash
curl -sSL https://my5353.com/spacevim | bash
```

## 使用帮助

```bash
curl -sSL https://my5353.com/spacevim | bash /dev/stdin -h
```

## 配置环境

```bash
curl -sSL https://my5353.com/spacevim | bash /dev/stdin -c
```

## 清除已安装环境

```bash
curl -sSL https://my5353.com/spacevim | bash /dev/stdin -r
```

## 完整脚本

<!--sec data-title="Install Go" data-id="section0" data-show=true ces-->

```bash
#!/usr/bin/env bash

###
 # @Descripttion : Install SpaceVim In Linux
 # @version      : v1.0.0
 # @Author       : neet11 neetwy@163.com
 # @Date         : 2022-09-27 03:01:36
 # @LastEditors  : neet11 neetwy@163.com
 # @LastEditTime : 2022-10-11 10:09:10
 # @FilePath     : /shell/config-dev-env/install_spacevim.sh
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
LOG_FILE="${LOG_PATH}/install_spacevim_$(date +"%Y%m%d").log"
HIDE_LOG=true

# global environment variable


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
    status_closure clear_spacevim_env

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
  echo "Usage: ./install_spacevim.sh [-h -c -v -r]"
  echo "    -h          : display this help and exit"
  echo "    -c          : config spacevim and exit"
  echo "    -v          : show spacevim help and exit"
  echo "    -r          : remove sapcevim env and exit"
  exit 0
}

# install spacevim
function install_spacevim() {
    # sh -c 'rm "$(command -v 'starship')"'
    # timedatectl set-timezone Asia/Shanghai
    # while sleep 1;do tput sc;tput cup 0 $(($(tput cols)-29));date;tput rc;done&
    # watch -t -n1 "date +%T|figlet"
    print_color "green" "install spacevim current env"
    curl -sLf https://spacevim.org/cn/install.sh | bash
}

# config spacevim
function config_spacevim_env() {
    print_color "green" "config spacevim current env"
    if [ -f "${HOME}/.SpaceVim.d/init.toml" ];then rm -rf "${HOME}/.SpaceVim.d/init.toml"; fi
    wget https://gitea.com/neet11/config-dev-env/raw/branch/main/.SpaceVim.d/init.toml -P "${HOME}/.SpaceVim.d" && \
    chmod 644 "${HOME}/.SpaceVim.d/init.toml"
    print_color "yellow" "config succeeded, need reopen vim"
}

# clear spacevim env
function clear_spacevim_env() {
    print_color "green" "clear spacevim current env"
    curl -sLf https://spacevim.org/install.sh | bash -s -- --uninstall
    sudo rm -rf "${HOME}/.SpaceVim"
    sudo rm -rf "${HOME}/.SpaceVim.d"
}

# entry function
function run_install_zsh() {
  status_closure install_spacevim
}

function main() {
    trap script_trap_err INT TERM QUIT HUP ERR
    trap script_trap_exit EXIT
    log "[I] shell start"

    if [ "${#}" -ne 0 ]
    then
      case $1 in
          -h|help)
            help
          ;;
          -v|version)
            curl -sLf https://spacevim.org/install.sh | bash -s -- -h
          ;;
          -r|remove)
            status_closure clear_spacevim_env
          ;;
          -c|config)
            status_closure config_spacevim_env
          ;;
          *)
            print_color "red" "unknown parameter" && help
          ;;
      esac
    else
      status_closure run_install_zsh
    fi
}

main "${@}"
```
<!--endsec-->