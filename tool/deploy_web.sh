#!/usr/bin/env bash
#
# Builds the web app for walkanddiscover.org and packs it for upload.
#
# The API URL is baked in at compile time (see lib/data/api_client.dart), so a
# build made without --dart-define silently points at localhost and the live
# site loads with no data. That is the whole reason this script exists.
#
# Run with: tool/deploy_web.sh
# Output:   build/walkanddiscover-web.zip  (upload + extract into public_html)
set -euo pipefail

API_BASE_URL="${API_BASE_URL:-https://hickersready-production.up.railway.app/api}"
ZIP_NAME="walkanddiscover-web.zip"

cd "$(dirname "$0")/.."

echo "==> Building with API_BASE_URL=$API_BASE_URL"
flutter build web --release --dart-define=API_BASE_URL="$API_BASE_URL"

# Sanity check: a build that kept the placeholders is unservable, and the
# symptom (blank white page) looks identical to a hosting problem.
if grep -q '{{flutter_js}}\|\$FLUTTER_BASE_HREF' build/web/index.html; then
  echo "ERROR: build/web/index.html still has build-time placeholders." >&2
  exit 1
fi

rm -f "build/$ZIP_NAME"
( cd build/web && zip -qr "../$ZIP_NAME" . )

echo
echo "==> build/$ZIP_NAME ready ($(du -h "build/$ZIP_NAME" | cut -f1))"
cat <<'STEPS'

Deploy steps (GoDaddy origin, Cloudflare in front):

  1. cPanel -> File Manager -> public_html
  2. DELETE the existing site files first. Do not upload over the top:
     mixing two builds leaves a stale index.html pinned to an old
     engineRevision, which fails against a newer main.dart.js and renders
     a blank page.
  3. Upload the zip into public_html and Extract it there. index.html must
     end up directly in public_html, not in a subfolder.
  4. Cloudflare -> Caching -> Configuration -> Purge Everything.
  5. Open the site in a private window. A normal window replays the old
     Flutter service worker and will look unchanged.

Verify: the browser tab should read "Walk & Discover Group". If it still
reads "hikers_way", the upload did not land — redo steps 2-3.

Backend note: the Railway service needs
  ALLOWED_ORIGINS=https://walkanddiscover.org
or the site loads but every API call is blocked by CORS (the default in
backend/src/main/resources/application.properties is http://localhost:*).
STEPS
