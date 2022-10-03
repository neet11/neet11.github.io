#!/usr/bin/env bash

cd "$(pwd)" || exit

gitbook build

# if [[ -d "./docs" ]];then
#   rm -rf ./docs
# fi

git add --all
git commit -m "update pages"
git push origin master --force

echo "============================"
echo "git push github page success"
echo "============================"
