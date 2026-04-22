#!/usr/bin/env bash
# Test multi-block encryption and zero padding behavior
set -euo pipefail

BUILD_BIN=./des
if [ ! -x "$BUILD_BIN" ]; then
  echo "Binary $BUILD_BIN not found. Build the project first." >&2
  exit 2
fi

# plaintext longer than 64 bits (e.g., 80 bits)
PLAINTEXT=0101011100110011001100110011001100110011001100110011001100110011001100
KEY=0001001100110100010101110111100110011011101111001101111111110001

OUTPUT=$(echo "1 $PLAINTEXT $KEY" | $BUILD_BIN)

echo "Ciphertext length: ${#OUTPUT}"

if [ $(( ${#OUTPUT} % 64 )) -ne 0 ]; then
  echo "Output not multiple of 64 bits" >&2
  exit 3
fi

exit 0
