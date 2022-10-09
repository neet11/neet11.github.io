# OhMyZsh安装

## 默认安装

```bash
curl -SL https://my5353.com/ohmyzsh | bash
```

## 使用帮助

```bash
curl -SL https://my5353.com/ohmyzsh | bash /dev/stdin -h
```

## 配置安装环境

```bash
curl -SL https://my5353.com/ohmyzsh | bash /dev/stdin -c
```

## 查看版本信息

```bash
curl -SL https://my5353.com/ohmyzsh | bash /dev/stdin -v
```

## 清除已安装环境

```bash
curl -SL https://my5353.com/ohmyzsh | bash /dev/stdin -r
```

## 完整脚本

<!--sec data-title="Install OhMyZsh" data-id="section0" data-show=true ces-->

```bash
#!/usr/bin/env bash

###
 # @Descripttion : Install Zsh In Linux
 # @version      : v1.0.0
 # @Author       : neet11 neetwy@163.com
 # @Date         : 2022-09-27 03:01:36
 # @LastEditors  : neet11 neetwy@163.com
 # @LastEditTime : 2022-10-08 10:56:58
 # @FilePath     : /shell/config-dev-env/install_ohmyzsh.sh
### 

# set -o xtrace           # Print commands and their arguments

# set -o errexit          # Exit on most errors (see the manual)
# set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline


# global constant
TAG="CMD"
# LOG_PATH=$( cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )/logs
LOG_PATH="/tmp/shell/logs"
LOG_FILE="${LOG_PATH}/install_zsh_$(date +"%Y%m%d").log"
HIDE_LOG=true

# global environment variable
user_name="$(whoami)"


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
    status_closure clear_zsh_env

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
  echo "Usage: ./install_ohmyzsh.sh [-h -v -c -r]"
  echo "    -h          : display this help and exit"
  echo "    -v          : print zsh version and exit"
  echo "    -c          : config zsh env and exit"
  echo "    -r          : remove zsh env and exit"
  exit 0
}

# get user default shell
function get_user_shell() {
    grep "${user_name}" /etc/passwd | awk -F: '{print $NF }'
}

# install oh my zsh
function install_ohmyzsh() {
  # sh -c "$(curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh)"
  echo y | sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

# check zsh is installed
function check_zsh_install() {
    isInstall=$(grep -c zsh /etc/shells)
    if [ "${isInstall}" -eq 0 ]
    then
        print_color "green" "start install zsh"
        sudo apt-get -y install zsh
        # sudo yum -y install zsh
        status_closure set_default_shell "/bin/zsh"
        status_closure install_ohmyzsh
    else
        print_color "green" "zsh has been installed"
        print_color "blue" "version: $(zsh --version)"
    fi
}

# print zsh version
function print_zsh_version() {
    if [ "$(which zsh)" ]
    then 
        zsh --version
    else
        print_color "red" "zsh has not been installed yet"
        print_color "red" "please install zsh first!"
    fi
}

# set default shell
function set_default_shell() {
    print_color "green" "change ${user_name} default shell" 
    if [ "$(get_user_shell)" != "${1}" ];then sudo usermod -s "${1}" vagrant;fi
    print_color "blue" "current shell: $(get_user_shell)"
    print_color "yellow" "shell change succeeded. please login again"
    print_color "green" "${user_name} default shell is ${1}" 
}

# config oh my zsh
function config_oh_my_zsh() {
    local ZSH_CUSTOM
    ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"

    if [ ! -d "${ZSH_CUSTOM}/themes/spaceship-prompt" ]
    then
      print_color "green" "install zsh spaceship theme"
      git clone https://github.com/spaceship-prompt/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1
      ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
    else
      print_color "green" "zsh spaceship-prompt theme installed"
    fi

    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]
    then
      print_color "green" "install zsh zsh-autosuggestions plugin"
      git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-autosuggestions
    else
      print_color "green" "zsh zsh-autosuggestions plugin installed"
    fi

    if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]
    then
      print_color "green" "install zsh zsh-syntax-highlighting plugin"
      git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}"/plugins/zsh-syntax-highlighting
    else
      print_color "green" "zsh zsh-syntax-highlighting  plugin installed"
    fi

    if [ ! -f "${HOME}/.zshrc.old" ]
    then
      print_color "green" "config .zshrc"
      mv "${HOME}/.zshrc" "${HOME}/.zshrc.old"
      wget https://gitea.com/neet11/config-dev-env/raw/branch/main/.zshrc -P "${HOME}/" && chmod 644 "${HOME}/.zshrc"
      print_color "yellow" "reload .zshrc use source ${HOME}/.zshrc"
    else
      print_color "green" "zsh configfile .zshrc has been updated"
    fi
}

# clear zsh env
function clear_zsh_env() {
    local uninstall_oh_my_zsh
    uninstall_oh_my_zsh="${HOME}/.oh-my-zsh/tools/uninstall.sh"

    print_color "green" "remove the oh my zsh" 
    if [ -f "${uninstall_oh_my_zsh}" ]
    then
      #sudo rm -rf ~/.zsh/zsh-autosuggestions
      echo y | bash "${uninstall_oh_my_zsh}"
    fi

    if [ -f "${HOME}/.zshrc" ]
    then
      sudo rm -rf "${HOME}"/.zshrc*
    fi

    print_color "green" "remove the installed zsh" 
    sudo apt-get -y --purge autoremove zsh > /dev/null

    print_color "green" "change default shell to bash" 
    if [ "$(get_user_shell)" != "/bin/bash" ] 
    then
      status_closure set_default_shell "/bin/bash"
    else
      print_color "blue" "current shell: $(get_user_shell)"
      print_color "yellow" "clear zsh succeeded. please login again"
    fi
}


# entry function
function run_install_zsh() {
  status_closure check_zsh_install
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
            print_zsh_version
          ;;
          -r|remove)
            status_closure clear_zsh_env
          ;;
          -c|config)
            status_closure config_oh_my_zsh
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