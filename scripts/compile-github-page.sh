#!/usr/bin/env bash
set -euo pipefail

mkdir -p _site

if [ -f main.pdf ]; then
  cp main.pdf _site/main.pdf
else
  echo "main.pdf not found; PDF buttons will point to a missing file in local preview."
fi

pandoc main.tex --from=latex --to=html5 | awk '
  NR == FNR {
    fragment = fragment $0 ORS
    next
  }
  $0 == "{{CV_FRAGMENT}}" {
    printf "%s", fragment
    next
  }
  { print }
' - .github/templates/cv-page.html > _site/index.html

echo "Generated _site/index.html"