#!/bin/bash

MESSAGE=${1:-'Published changes'}

hugo
cd public
git add .
git commit -m "$MESSAGE"
git push
cd ..
git add .
git commit -m "${MESSAGE} - source"
git push