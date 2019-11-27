#!/bin/bash

cd ./content
sed -i "s@HUGO_VERSION@$(hugo version)@g" status.md
sed -i "s@PYGMENTS_VERSION@$(pygmentize -V)@g" status.md
sed -i "s@BLOG_COMMIT@$(git rev-parse HEAD)@g" status.md
sed -i "s@THEME_COMMIT@$(cd ../themes/even && git rev-parse HEAD)@g" status.md