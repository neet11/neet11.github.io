# Gitbook安装

## 安装node.js

> node 版本<=10.xx.xx，否则Gitbook不兼容

```powershell
cd /d c:\opt
wget -c https://my5353.com/nodejs
start /wait node-v10.24.1-x64.msi /quiet
```

## 安装gitbook

```powershell
cd /d c:\opt
npm install gitbook-cli -g
```

## 查看gitBook版本

```powershell
c:\opt>where node
C:\Program Files\nodejs\node.exe

c:\opt>node --version
v10.24.1

c:\opt>npm --version
6.14.12

c:\opt>gitbook --version
3.2.3
```

## gitbook初始化

```powershell
mkdir d:\website\www.mygitbook.cn\wiki
cd /d d:\website\www.mygitbook.cn\wiki
gitbook init
```

## 安装gitbook插件

> 保存示例至根目录下book.json文件后执行gitbook install安装插件

<!--sec data-title="gitbook plugin" data-id="section0" data-show=true ces-->
```json
{
    "title": "notes",
    "description": "keep a record",
    "author": "someone",
    "output.name": "site",
    "language": "zh-hans",
    "gitbook": "3.2.0",
    "root": ".",
    "links": {
        "sidebar": {
            "Home": "https://www.google.com"
        }
    },
    "plugins": [
        "-lunr",
        "-search",
        "-highlight",
        "-livereload",
        "hide-element",
        "search-plus@^0.0.11",
        "simple-page-toc@^0.1.1",
        "github@^2.0.0",
        "github-buttons@2.1.0",
        "edit-link@^2.0.2",
        "prism@^2.1.0",
        "prism-themes@^0.0.2",
        "advanced-emoji@^0.2.1",
        "anchors@^0.7.1",
        "include-codeblock@^3.0.2",
        "ace@^0.3.2",
        "emphasize@^1.1.0",
        "katex@^1.1.3",
        "splitter@^0.0.8",
        "mermaid-gb3@2.1.0",
        "tbfed-pagefooter@^0.0.1",
        "expandable-chapters-small@^0.1.7",
        "sectionx@^3.1.0",
        "anchor-navigation-ex@0.1.8",
        "favicon@^0.0.2",
        "terminal@^0.3.2",
        "alerts@^0.2.0",
        "include-csv@^0.1.0",
        "puml@^1.0.1",
        "musicxml@^1.0.2",
        "klipse@^1.2.0",
        "versions-select@^0.1.1",
        "-sharing",
        "graph@^0.1.0",
        "chart@^0.2.0",
        "code",
        "accordion",
        "sectionx",
        "expandable-chapters-small"
    ],

    "pluginsConfig": {
        "hide-element": {
            "elements": [".gitbook-link"]
        },
        "theme-default": {
            "showLevel": true
        },
        "prism": {
            "css": [
                "prism-themes/themes/prism-base16-ateliersulphurpool.light.css"
            ]
        },
        "github": {
            "url": "https://github.com/---"
        },
        "github-buttons": {
            "repo": "xxx/xxx",
            "types": [
                "star"
            ],
            "size": "small"
       },
        "tbfed-pagefooter": {
            "copyright": "Copyright © someone 2022",
            "modify_label": "Latest modification time:",
            "modify_format": "YYYY-MM-DD HH:mm:ss"
        },
        "simple-page-toc": {
            "maxDepth": 3,
            "skipFirstH1": true
        },
        "edit-link": {
            "base": "https://github.com/---/blob/master",
            "label": "Edit This Page"
        },
        "anchor-navigation-ex": {
            "isRewritePageTitle": false,
            "tocLevel1Icon": "fa fa-hand-o-right",
            "tocLevel2Icon": "fa fa-hand-o-right",
            "tocLevel3Icon": "fa fa-hand-o-right"
        },
        "sectionx": {
            "tag": "b"
        },
        "favicon": {
            "shortcut": "favicon.ico",
            "bookmark": "favicon.ico"
        },
        "terminal": {
            "copyButtons": true,
            "fade": false,
            "style": "flat"
        },
        "code": {
            "copyButtons": true
        }
    }
}
```
<!--endsec-->

## gitbook卸载

```bash
npm uninstall -g gitbook
npm uninstall -g gitbook-cli
npm cache clean -f
```

## gitbook常用命令

```bash
# help
gitbook help
# setup and create files for chapters 
gitbook init
# serve the book as a website for testing
gitbook serve
# install all plugins dependencies
gitbook install
# build a book(output _book/)
gitbook build
```
