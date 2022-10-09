# NerdFont安装

## 默认安装

```bash
curl -SL https://my5353.com/nerdfont | bash
```

## 使用帮助

```bash
curl -SL https://my5353.com/nerdfont | bash /dev/stdin -h
```

## 安装指定字体(仅限FiraCode DroidSansMono DejaVuSansMono CodeNewRoman)

```bash
curl -SL https://my5353.com/nerdfont | bash /dev/stdin -o FiraCode DejaVuSansMono
```

## 清除已安装环境

```bash
curl -SL https://my5353.com/nerdfont | bash /dev/stdin -r
```

## 完整脚本

<!--sec data-title="Install NerdFont" data-id="section0" data-show=true ces-->

```bash
#!/usr/bin/env bash

###
 # @Descripttion : Do Something
 # @version      : v1.0.0
 # @Author       : neet11 neetwy@163.com
 # @Date         : 2022-09-27 03:01:36
 # @LastEditors  : neet11 neetwy@163.com
 # @LastEditTime : 2022-10-09 08:18:18
 # @FilePath     : /shell/config-dev-env/install_nerd_fonts.sh
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
LOG_FILE="${LOG_PATH}/install_nerdfont_$(date +"%Y%m%d").log"
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
    status_closure clear_nerd_fonts_env

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
  echo "Usage: ./install_nerd_font.sh [-h -r] [-o nerdfont-list]"
  echo "    -h          : display this help and exit"
  echo "    -r          : remove nerdfont env and exit"
  echo "    -o          : option nerdfont want to install(only in FiraCode DroidSansMono DejaVuSansMono CodeNewRoman)"
  exit 1
}

# install nerd fonts
function install_nerd_fonts() {
    local fonts_arr
    local prefix_url
    local patched_fonts_dir
    prefix_url="https://gitea.com/neet11/config-dev-env/raw/branch/main/fonts/"
    patched_fonts_dir="${HOME}/tools/patched-fonts/"

    print_color "green" "check whether unzip is installed and patched_fonts dir is created"
    if [ ! "$(which unzip)" ]; then sudo apt -y install unzip; fi
    if [ ! -d "${patched_fonts_dir}" ]; then mkdir "${patched_fonts_dir}" ; fi

    if [ "${#}" -ne 0 ]; 
    then 
        fonts_arr=("${@}")
    else
        fonts_arr=(FiraCode DroidSansMono DejaVuSansMono CodeNewRoman)
    fi
    print_color "green" "install nerd fonts: ${fonts_arr[*]}"
    for font in "${fonts_arr[@]}"
    do
         
        if [ ! -f "${patched_fonts_dir}${font}.zip" ]
        then
            wget -P "${patched_fonts_dir}" "${prefix_url}${font}.zip"
            print_color "green" "unzip ${font}.zip"
            unzip -d "${patched_fonts_dir}" "${patched_fonts_dir}${font}.zip"
            rm -rf "${patched_fonts_dir}/LICENSE.txt"
            rm -rf "${patched_fonts_dir}/readme.md"
        fi
    done

    if [ ! -f "${HOME}/tools/install.sh" ]
    then
        print_color "green" "install nerd fonts install.sh"
        wget -P "${HOME}/tools/" "${prefix_url}"install.sh
    fi

    bash "${HOME}/tools/install.sh" > /dev/null
    print_color "blue" "fonts install to ${HOME}/.local/share/fonts/NerdFonts"
}

# clear nerd fonts env
function clear_nerd_fonts_env() {
    local nerd_fonts_home
    nerd_fonts_home="${HOME}/.local/share/fonts/NerdFonts"

    print_color "green" "remove the nerd fonts" 
    if [ -d "${nerd_fonts_home}" ]
    then
        sudo rm -rf "${nerd_fonts_home}"
    fi

    print_color "green" "clear nerdfont succeeded"
}

# entry function
function run_install_nerdfont() {
  status_closure install_nerd_fonts
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
          -o|option)
            status_closure install_nerd_fonts "${@:2}"
          ;;
          -r|remove)
            status_closure clear_nerd_fonts_env
          ;;
          *)
            print_color "red" "unknown parameter" && help
          ;;
      esac
    else
      status_closure run_install_nerdfont
    fi
}

main "${@}"
```
<!--endsec-->
