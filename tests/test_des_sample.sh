#!/usr/bin/env bash
# Simple sample test that runs DES encrypt on a short plaintext
set -euo pipefail

# Example: encrypt 64-bit plaintext with example key (from original sample in des.cpp)
MODE=1
PLAINTEXT=0001001000110100010101100111100010011010101111001101111011110001
KEY=0001001100110100010101110111100110011011101111001101111111110001

BUILD_BIN=./des
if [ ! -x "$BUILD_BIN" ]; then
  echo "Binary $BUILD_BIN not found. Build the project first." >&2
  exit 2
fi

OUTPUT=$(echo "$MODE $PLAINTEXT $KEY" | $BUILD_BIN)
echo "$OUTPUT"

# Expect 64-bit ciphertext output
if [ ${#OUTPUT} -ne 64 ]; then
  echo "Unexpected ciphertext length: ${#OUTPUT}" >&2
  exit 3
fi

exit 0
