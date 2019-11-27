#!/bin/bash
DATUM=$(date -u +\"%Y-%m-%dT%H:%M:%SZ\")
cat << EOF | tee ./content/status.md
+++
date = $DATUM
title = "status"
url = "/status"
+++

### Status

$(hugo version)

$(pygmentize -V)

Blog commit: $(git rev-parse HEAD)

Theme commit: $(cd ./themes/even && git rev-parse HEAD)

Published: $DATUM
EOF
