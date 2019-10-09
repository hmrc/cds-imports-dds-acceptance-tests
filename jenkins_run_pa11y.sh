#!/usr/bin/env bash
set -e

# install node modules required to run pa11y
npm install pa11y

# run pa11y against the service, log all output and exit 1 if any issues are found
mkdir -p target/screenshots
node run_pa11y.js | awk '/code:/ {retstat=1} /Browser Console: Failed/ {retstat=1} /./ {print} END {exit retstat}'
