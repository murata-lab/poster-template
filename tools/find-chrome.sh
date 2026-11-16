#!/bin/sh
# Print the path of a Chrome / Chromium that can print to PDF headlessly.
# Order: $CHROME, Playwright's headless shell (`make setup` installs it), system Chrome/Chromium.
if [ -n "$CHROME" ]; then printf '%s\n' "$CHROME"; exit 0; fi

found=
for c in "$HOME"/.cache/ms-playwright/chromium_headless_shell-*/chrome-headless-shell-linux64/chrome-headless-shell \
         "$HOME"/Library/Caches/ms-playwright/chromium_headless_shell-*/chrome-headless-shell-mac-*/chrome-headless-shell; do
  [ -x "$c" ] && found=$c   # globs sort ascending, so the last hit is the newest
done
if [ -n "$found" ]; then printf '%s\n' "$found"; exit 0; fi

for c in google-chrome google-chrome-stable chromium chromium-browser; do
  p=$(command -v "$c" 2>/dev/null) && { printf '%s\n' "$p"; exit 0; }
done
for c in "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
         "/Applications/Chromium.app/Contents/MacOS/Chromium"; do
  [ -x "$c" ] && { printf '%s\n' "$c"; exit 0; }
done
exit 1
