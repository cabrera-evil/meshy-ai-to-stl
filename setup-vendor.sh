#!/bin/sh

set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")" && pwd)
VENDOR="$ROOT/chrome-extension/vendor"

mkdir -p "$VENDOR"

download() {
  url=$1
  output=$2
  expected=$3

  printf 'Downloading %s\n' "$url"
  curl --fail --location --show-error --silent "$url" --output "$output"

  if [ ! -s "$output" ]; then
    printf 'Downloaded file is empty: %s\n' "$output" >&2
    exit 1
  fi

  if command -v sha256sum >/dev/null 2>&1; then
    actual=$(sha256sum "$output" | cut -d ' ' -f 1)
  else
    actual=$(shasum -a 256 "$output" | cut -d ' ' -f 1)
  fi
  if [ "$actual" != "$expected" ]; then
    rm -f "$output"
    printf 'SHA-256 mismatch for %s\n  expected: %s\n  actual:   %s\n' "$output" "$expected" "$actual" >&2
    printf 'Upstream may have changed. Re-review the file before updating the pinned hash.\n' >&2
    exit 1
  fi

  size=$(wc -c < "$output" | tr -d ' ')
  printf 'Saved %s (%s bytes)\n' "$output" "$size"
}

download \
  "https://www.meshy.ai/pt-BR/resource/decrypt/mesh_loader.js" \
  "$VENDOR/mesh_loader.js" \
  "42d6d4823ad0f51d8cd8c393a269065e1eeb9beb84f99d27e7a82b2bdf2da55c"

download \
  "https://www.meshy.ai/pt-BR/resource/decrypt/mesh_loader.wasm" \
  "$VENDOR/mesh_loader.wasm" \
  "69bb1b1874366d431110470ccc9c53e5a9ef6aeffb9abadf4d33bc9e1a481b58"

printf 'Vendor files are ready.\n'
