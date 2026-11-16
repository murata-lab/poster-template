#!/bin/sh
# Usage: build.sh poster_en.html poster_en.pdf
# Prints the HTML to PDF with headless Chrome, writes a small preview PNG, and warns when
# the content overflows the page (poster.js puts a red "OVERFLOW" banner into the PDF).
html=$1; pdf=$2; base=${pdf%.pdf}
here=$(cd "$(dirname "$0")" && pwd)

chrome=$(sh "$here/find-chrome.sh") || {
  echo "ERROR: Chrome / Chromium not found. Run 'make setup' at the repository root, or set CHROME=/path/to/chrome." >&2
  exit 1
}

# --virtual-time-budget waits for web fonts, KaTeX and QR codes before printing.
"$chrome" --headless --no-sandbox --disable-gpu --virtual-time-budget=15000 --no-pdf-header-footer \
  --print-to-pdf="$pdf" "file://$(pwd)/$html" 2>/dev/null
if [ ! -s "$pdf" ]; then echo "ERROR: Chrome did not write $pdf" >&2; exit 1; fi

t=$(date +%T)
if ! command -v pdfinfo >/dev/null 2>&1; then
  echo "$t built $pdf (install poppler for the preview PNG and the overflow check)"; exit 0
fi
pdftoppm -png -r 30 -singlefile "$pdf" "${base}_preview"
pages=$(pdfinfo "$pdf" | awk '/^Pages/{print $2}')
if pdftotext "$pdf" - | grep -q 'OVERFLOW: content'; then
  echo "$t WARNING: $pdf overflows (see the red banner at the top of the PDF)"
elif [ "$pages" != 1 ]; then
  echo "$t WARNING: $pdf runs onto $pages pages"
else
  echo "$t built $pdf (1 page)"
fi
