#!/bin/bash
set -euo pipefail

STAMP=".optipng-stamp"

[ -f "$STAMP" ] || touch -d @0 "$STAMP"

find _book -name "*.png" -newer "$STAMP" -print0 2>/dev/null \
  | xargs -0 -r optipng -quiet -o3

touch "$STAMP"
