#!/usr/bin/env bash
set -euo pipefail

VERSION=$1
OUT_FILE=${2:-${GITHUB_OUTPUT:-check_release.out.txt}}

if gh release view "v${VERSION}" >/dev/null 2>&1
then echo "found=true"  >> "$OUT_FILE"
else echo "found=false" >> "$OUT_FILE"
fi
