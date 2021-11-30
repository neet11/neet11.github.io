#!/usr/bin/env bash

rm -rf ./docs/*
echo "rm -rf ./docs/*"
cp -rf ./_book/* ./docs
echo "cp -rf ./_book/* ./docs"
git add --all
git commit -m "commit in 17"
git push origin master --force
echo "git push github page"
