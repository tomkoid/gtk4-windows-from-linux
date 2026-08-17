#!/usr/bin/env bash
set -e

EXE_PATH="target/x86_64-pc-windows-gnu/release/relm4-test.exe"
MINGW_BIN="/usr/x86_64-w64-mingw32/sys-root/mingw/bin"
OUTPUT_DIR="relm4-test-windows"

echo "building project for Windows..."
cargo build --release --target x86_64-pc-windows-gnu

echo "packaging executable and DLL dependencies..."
mkdir -p "$OUTPUT_DIR"
cp "$EXE_PATH" "$OUTPUT_DIR/"

peldd "$EXE_PATH" --path "$MINGW_BIN" -a --ignore-errors 2>/dev/null | xargs -I {} cp {} "$OUTPUT_DIR/"

echo "zipping the release..."
zip -r "${OUTPUT_DIR}.zip" "$OUTPUT_DIR"

echo "${OUTPUT_DIR}.zip"
