#!/bin/bash

MESSAGE=${1:-'Published changes'}

# Update the status
./update-status.sh

# Generate static HTML to ./public
hugo

# commit and publish static site
cd public
git add .
git commit -m "$MESSAGE"
git push

# commit and publish the source
cd ..
git add .
git commit -m "${MESSAGE} - source"
git push

git last -3