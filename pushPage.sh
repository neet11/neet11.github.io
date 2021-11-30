#!/usr/bin/env bash

rm -rf ./docs/*
cp -rf ./_book/* ./docs
git add --all
git commit -m "commit in 17"
git push origin master --force
