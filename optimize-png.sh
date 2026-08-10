#!/bin/bash
set -euo pipefail

STAMP=".optipng-stamp"

find _book -name "*.png" -newer "$STAMP" -print0 2>/dev/null \
  | xargs -0 -r optipng -quiet -o3

touch "$STAMP"ind _book -name "*.png" -exec optipng -quiet -o3 {} +
