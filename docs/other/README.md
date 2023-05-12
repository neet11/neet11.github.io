# 其他

<!--sec data-title="common links" data-id="section0" data-show=true data-collapse=false ces-->
## cheat sheet

* [bash](https://cs.leops.cn/#/cheatsheet/linux/bash)
* [style](https://zh-google-styleguide.readthedocs.io/en/latest/google-shell-styleguide/environment/)

## markdown tools

* [emojiall](https://www.emojiall.com/zh-hans/sub-categories/H14)
* [favicon](https://realfavicongenerator.net/)

## online tools

* [file transfer](https://wormhole.app)
<!--endsec-->

<!--sec data-title="code snippets" data-id="section1" data-show=true data-collapse=false ces-->
## vimrc imap esc

```bash
vim ~/.vimrc
imap jk <Esc> 
source ~/.vimrc
```

## 读取另一个文件全部内容到当前文档光标处

```bash
:r [filename]
# 当前文件中进入命令行模式输入r指令和待插入内容文件名
```

## 读取另一个文件指定内容到当前文档光标处

```bash
:r! sed -n '1,10p' < [filename]
#r! cmd 将命令的返回结果插入文件当前位置
```

## 合并行

> 大写J

## 大小写转换

> ~符号

## 重复执行

> .符号,重复执行一次
> 数字加命令,重复执行的次数: 10j(向下移动10行)

## 翻页

|上一页|下一页|上半页|下半页|
|:---:|:---:|:---:|:---:|
|ctrl+b|ctrl+f|ctrl+d|ctrl+u|

## 正则表达符号

|符号|说明|
|:---:|:---:|
|^|行的第一个字符|
|.|表示任意字符或1个字符|
|[]|[]内的字符之一|
|[^]|除绑定字符外的任意字符|
|\*|之前内容重复0次以上|
|\<|词首|
|\n.|换行字符|
|%|第一行到最后一行|
|[AB]|A或B|
|[0-9]|0~9之间中所有整数|
|$|行尾|
|\\|如实解析下一个字符|
|\\\||表示or|

## markdown section collapse

```js
<!--sec data-title="Example.com" data-id="section0" data-show=true data-collapse=false ces-->
<!--endsec-->
```
<!--endsec-->
