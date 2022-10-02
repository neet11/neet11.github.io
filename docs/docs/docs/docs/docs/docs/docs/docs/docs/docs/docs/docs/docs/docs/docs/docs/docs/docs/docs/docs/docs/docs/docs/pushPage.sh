#!/usr/bin/env bash

cd $(pwd)
gitbook build

if [[ -d "./docs" ]];then
  rm -rf ./docs
fi

cp -rf _book docs
rm -rf _book 

git add --all
git commit -m "update pages"
git push origin master --force

echo "============================"
echo "git push github page success"
echo "============================"
