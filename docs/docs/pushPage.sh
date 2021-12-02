#!/usr/bin/env bash

cp -rf _book docs
git add --all
git commit -m "commit in 17"
git push origin master --force
echo "git push github page"
