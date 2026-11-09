#!/bin/bash
# Stop at the first failing step: a failed build must never be committed or pushed.
set -euo pipefail

MESSAGE=${1:-'Published changes'}

# Update the status
./update-status.sh

# Generate static HTML to ./public (clean out files no longer produced by the build)
hugo --cleanDestinationDir

# --cleanDestinationDir also removes the submodule's .git pointer file — restore it
[ -f public/.git ] || echo "gitdir: ../.git/modules/public" > public/.git

# commit and publish static site
cd public
git add .
# (nothing staged is not an error: skip the commit, still push)
git diff --cached --quiet || git commit -m "$MESSAGE"
git push

# commit and publish the source
cd ..
git add .
git diff --cached --quiet || git commit -m "${MESSAGE} - source"
git push

git last -3