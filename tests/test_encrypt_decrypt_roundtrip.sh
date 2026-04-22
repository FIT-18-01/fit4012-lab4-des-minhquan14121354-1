#!/usr/bin/env bash
# Test that DES encrypt followed by DES decrypt returns original plaintext
set -euo pipefail

BUILD_BIN=./des
if [ ! -x "$BUILD_BIN" ]; then
  echo "Binary $BUILD_BIN not found. Build the project first." >&2
  exit 2
fi

# Use a non-multiple-of-64 plaintext to exercise padding
PLAINTEXT=010101110011
KEY=0001001100110100010101110111100110011011101111001101111111110001

# Encrypt
CIPHERTEXT=$(echo "1 $PLAINTEXT $KEY" | $BUILD_BIN)

# Decrypt
RECOVERED=$(echo "2 $CIPHERTEXT $KEY" | $BUILD_BIN)

echo "Original:  $PLAINTEXT"
echo "Recovered: $RECOVERED"

if [ "$RECOVERED" != "$PLAINTEXT" ]; then
  echo "Roundtrip failed" >&2
  exit 3
fi

exit 0
