#!/usr/bin/env bash
set -euo pipefail

UPSTREAM_URL=${1:-}
OUT_FILE=${2:-$GITHUB_OUTPUT}

# Follow redirects and pull only headers
headers="$(curl -sSLI "$UPSTREAM_URL" | tr -d '\r')"

filename=$(echo "$headers" | grep -i '^content-disposition:' | sed -nE 's/.*filename="?([^";]+)".*/\1/p')
if [[ -z "$filename" ]]; then
  echo "::error::Filename not found"
  exit 1
fi
echo "filename=$filename" >> "$OUT_FILE"

version=$(echo "$filename" | sed -nE 's/.*-v?([0-9]+\.[0-9]+\.[0-9]+)\..*/\1/p')
if [[ -z "$version" ]]; then
  echo "::error::Version not recognised"
  exit 1
fi
echo "version=$version" >> "$OUT_FILE"
