#!/usr/bin/env bash
# Negative test: tamper with ciphertext and ensure decrypted plaintext differs
set -euo pipefail

BUILD_BIN=./des
if [ ! -x "$BUILD_BIN" ]; then
  echo "Binary $BUILD_BIN not found. Build the project first." >&2
  exit 2
fi

PLAINTEXT=010101110011
KEY=0001001100110100010101110111100110011011101111001101111111110001

# Encrypt
CIPHERTEXT=$(echo "1 $PLAINTEXT $KEY" | $BUILD_BIN)

# Tamper: flip first bit
TAMPERED="${CIPHERTEXT}"
if [ "${TAMPERED:0:1}" = "0" ]; then
  TAMPERED="1${TAMPERED:1}"
else
  TAMPERED="0${TAMPERED:1}"
fi

# Decrypt tampered ciphertext
RECOVERED=$(echo "2 $TAMPERED $KEY" | $BUILD_BIN)

echo "Original:  $PLAINTEXT"
echo "Recovered: $RECOVERED"

if [ "$RECOVERED" = "$PLAINTEXT" ]; then
  echo "Tamper test failed: tampered ciphertext decrypted to original" >&2
  exit 3
fi

exit 0
