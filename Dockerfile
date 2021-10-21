FROM alpine:3.14 AS build

RUN apk add --no-cache git g++ make curl \
libtorrent-dev cmake libexecinfo-dev boost-dev \
openssl-dev zlib-dev qt5-qtbase-dev qt5-qttools-dev

RUN git clone --depth 1 -b v1.2.12 https://github.com/arvidn/libtorrent && \
cd libtorrent && cmake -D CMAKE_INSTALL_PREFIX=/install . && make install -j $(nproc)

COPY . /src/
RUN mkdir /build && cd /build && cmake -D STACKTRACE=OFF -D GUI=OFF -D CMAKE_INSTALL_PREFIX=/install /src \
&& make -j $(nproc) install


FROM alpine:3.14

RUN apk add --no-cache boost openssl zlib qt5-qtbase qt5-qttools
COPY --from=build /install/ /

ENTRYPOINT ["qbittorrent-nox"]
