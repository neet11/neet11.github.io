#!/usr/bin/env bash

###
 # @Descripttion : Auto Git Push GitBook
 # @version      : v1.0.0
 # @Author       : neet11 neetwy@163.com
 # @Date         : 2022-09-26 13:08:04
 # @LastEditors  : neet11 neetwy@163.com
 # @LastEditTime : 2022-10-09 17:35:00
 # @FilePath     : \neet11.github.io\pushPage.sh
### 



if [[ -d "docs" ]];then
  rm -rf docs
fi

gitbook build

mv _book docs

git add --all
git commit -m "update pages"
git push origin master --force

echo "============================"
echo "git push github page success"
echo "============================"
