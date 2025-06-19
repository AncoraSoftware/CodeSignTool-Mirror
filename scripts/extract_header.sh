#!/usr/bin/env bash
set -euo pipefail

UPSTREAM_URL=${1:-}
OUT_FILE=${2:-${GITHUB_OUTPUT:-}}

# Download file and capture headers in a single request
temp_header_file=$(mktemp)
curl -sL \
  -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" \
  --dump-header "$temp_header_file" \
  -J -O \
  "$UPSTREAM_URL" 2>/dev/null

headers="$(cat "$temp_header_file" | tr -d '\r')"
rm -f "$temp_header_file"

filename=$(echo "$headers" | grep -i '^content-disposition:' | sed -nE 's/.*filename="?([^";]+)".*/\1/p')
if [[ -z "$filename" ]]; then
  # Check if we got HTML content instead of a file download
  content_type=$(echo "$headers" | grep -i '^content-type:' | head -1)
  if [[ "$content_type" == *"text/html"* ]]; then
    echo "::error::URL serves HTML content, not a direct file download. You may need to find the direct download URL." >&2
  else
    echo "::error::Content-Disposition header not found in response" >&2
  fi
  exit 1
fi
if [[ -n "$OUT_FILE" ]]; then
  echo "filename=$filename" >> "$OUT_FILE"
else
  echo "filename=$filename"
fi

version=$(echo "$filename" | sed -nE 's/.*-v?([0-9]+\.[0-9]+\.[0-9]+)\..*/\1/p')
if [[ -z "$version" ]]; then
  echo "::error::Version not recognised from filename: '$filename'" >&2
  exit 1
fi
if [[ -n "$OUT_FILE" ]]; then
  echo "version=$version" >> "$OUT_FILE"
else
  echo "version=$version"
fi

echo "Downloaded: $filename" >&2
