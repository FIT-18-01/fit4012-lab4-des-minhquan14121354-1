#!/usr/bin/env bash
# Negative test: decrypt with wrong key should not return original plaintext
set -euo pipefail

BUILD_BIN=./des
if [ ! -x "$BUILD_BIN" ]; then
  echo "Binary $BUILD_BIN not found. Build the project first." >&2
  exit 2
fi

PLAINTEXT=010101110011
KEY=0001001100110100010101110111100110011011101111001101111111110001
WRONG_KEY=1111000011110000111100001111000011110000111100001111000011110000

# Encrypt
CIPHERTEXT=$(echo "1 $PLAINTEXT $KEY" | $BUILD_BIN)

# Decrypt with wrong key
RECOVERED=$(echo "2 $CIPHERTEXT $WRONG_KEY" | $BUILD_BIN)

echo "Original:  $PLAINTEXT"
echo "Recovered with wrong key: $RECOVERED"

if [ "$RECOVERED" = "$PLAINTEXT" ]; then
  echo "Wrong-key test failed: decrypted to original with wrong key" >&2
  exit 3
fi

exit 0
