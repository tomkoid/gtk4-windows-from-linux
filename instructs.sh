#!/usr/bin/env bash

EXE_PATH="target/x86_64-pc-windows-gnu/release/relm4-test.exe"
MINGW_BIN="/usr/x86_64-w64-mingw32/sys-root/mingw/bin"
OUTPUT_DIR="relm4-test-windows"

mkdir $OUTPUT_DIR

rustup default nightly
rustup target add x86_64-pc-windows-gnu

sudo dnf install -y mingw64-gcc mingw64-freetype mingw64-cairo mingw64-harfbuzz mingw64-pango mingw64-poppler mingw64-gtk4 mingw64-winpthreads-static mingw64-glib2-static gcc boost zip && dnf clean all -y

git clone https://github.com/gsauthof/pe-util
cd pe-util
git submodule update --init
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release
make
sudo cp peldd /usr//bin/
cd ../..

sudo ln -s /usr/x86_64-w64-mingw32/sys-root/mingw/lib/libvulkan-1.dll.a /usr/x86_64-w64-mingw32/sys-root/mingw/lib/libvulkan.dll.a

PKG_CONFIG_ALLOW_CROSS=1 PKG_CONFIG_PATH=/usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig/ GTK_INSTALL_PATH=/usr/x86_64-w64-mingw32/sys-root/mingw/ cargo build --release --target x86_64-pc-windows-gnu

peldd "$EXE_PATH" --path "$MINGW_BIN" -a --ignore-errors | xargs -I {} cp {} "$OUTPUT_DIR/"
