FROM fedora:latest AS builder

RUN dnf install -y git cmake gcc-c++ boost-devel

WORKDIR /build
RUN git clone https://github.com/gsauthof/pe-util && \
    cd pe-util && \
    git submodule update --init && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release && \
    make

FROM fedora:latest

RUN dnf install -y mingw64-gcc mingw64-freetype mingw64-cairo \
    mingw64-harfbuzz mingw64-pango mingw64-poppler mingw64-gtk4 \
    mingw64-winpthreads-static mingw64-glib2-static mingw64-vulkan-loader \
    gcc boost zip curl git && \
    dnf clean all -y

RUN ln -s /usr/x86_64-w64-mingw32/sys-root/mingw/lib/libvulkan-1.dll.a /usr/x86_64-w64-mingw32/sys-root/mingw/lib/libvulkan.dll.a

COPY --from=builder /build/pe-util/build/peldd /usr/bin/peldd

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

RUN rustup default nightly && \
    rustup target add x86_64-pc-windows-gnu

ENV PKG_CONFIG_ALLOW_CROSS=1
ENV PKG_CONFIG_PATH=/usr/x86_64-w64-mingw32/sys-root/mingw/lib/pkgconfig/
ENV GTK_INSTALL_PATH=/usr/x86_64-w64-mingw32/sys-root/mingw/

COPY package.sh /usr/bin/package.sh
RUN chmod +x /usr/bin/package.sh

WORKDIR /src
VOLUME /src

CMD ["/usr/bin/package.sh"]
