#!/bin/sh

set -e

if [ -z "$1" ]; then
  arch=x64
else
  arch=$1
fi

echo TARGET_ARCH=$arch

DEPENDENCY_DIR=dependency
DOWNLOAD_DIR=downloads
SCRIPT_DIR=$(realpath "$(dirname "$0")")
LIB_PREFIX=$SCRIPT_DIR/deps/$arch

if [[ "$arch" == "sigmaster" ]]; then
  CROSS_COMPILE_MAKE="$SCRIPT_DIR/build/cross_compile_arm.mk"
  CMAKE_TOOLCHAIN_FILE="$SCRIPT_DIR/build/ccross_compile_arm.cmake"
elif [[ "$arch" == "cv22" ]]; then
  CROSS_COMPILE_MAKE="$SCRIPT_DIR/build/ccv22.mk"
  CMAKE_TOOLCHAIN_FILE="$SCRIPT_DIR/build/ccv22.cmake"
elif [[ "$arch" == "armv7hf" ]]; then
  CROSS_COMPILE_MAKE="$SCRIPT_DIR/build/carmv7hf.mk"
  CMAKE_TOOLCHAIN_FILE="$SCRIPT_DIR/build/carmv7hf.cmake"
elif [[ "$arch" == "aarch64" ]]; then
  CROSS_COMPILE_MAKE="$SCRIPT_DIR/build/aarch64.mk"
  CMAKE_TOOLCHAIN_FILE="$SCRIPT_DIR/build/aarch64.cmake"
elif [[ "$arch" == "x64" || -z "$arch" ]]; then
  echo "No cross compile needed for x64"
  CROSS_COMPILE_MAKE=""
fi

echo "begin build zlib"
ZLIB_VERSION=1.2.13
ZLIB_DIR_NAME=zlib-$ZLIB_VERSION
ZLIB_PKG_URL=https://github.com/turingvideo/zlib/archive/refs/tags/v$ZLIB_VERSION.tar.gz
ZLIB_PKG=$DOWNLOAD_DIR/$ZLIB_DIR_NAME.tar.gz

wget -c $ZLIB_PKG_URL -P $DOWNLOAD_DIR --output-document $ZLIB_PKG
tar -xzvf $ZLIB_PKG -C $DEPENDENCY_DIR
cd $DEPENDENCY_DIR/$ZLIB_DIR_NAME && \
CC=$CC ./configure --static -prefix=$LIB_PREFIX && \
make -j$(nproc) && make install

echo "begin build openssl"
OPENSSL_VERSION=openssl-3.0.2
OPENSSL_PKG_URL=https://www.openssl.org/source/$OPENSSL_VERSION.tar.gz
OPENSSL_PKG=$DOWNLOAD_DIR/$OPENSSL_VERSION.tar.gz

wget -c $OPENSSL_PKG_URL -P $DOWNLOAD_DIR --output-document $OPENSSL_PKG
tar -xzvf $OPENSSL_PKG -C $DEPENDENCY_DIR
cd $DEPENDENCY_DIR/$OPENSSL_VERSION && OPENSSL_CROSS_COMPILE_ARGS_EXTRA=$OPENSSL_CROSS_COMPILE_ARGS_EXTRA CC=$CC ./Configure $TARGET_PLATFORM no-shared --prefix=$LIB_PREFIX \
		--openssldir=$LIB_PREFIX/openssl --libdir=$LIB_PREFIX/lib --with-zlib-include=$LIB_PREFIX/include --with-zlib-lib=$LIB_PREFIX/lib && make -j$(nproc) && make install


echo "begin build srt"
SRT_TAG=1.5.4
SRT_PKG_URL=https://github.com/Haivision/srt/archive/refs/tags/v$SRT_TAG.tar.gz
SRT_CONFIG="-DENABLE_APPS=OFF -DENABLE_STATIC=ON -DENABLE_SHARED=OFF -DUSE_OPENSSL_PC=FALSE \
	-DCMAKE_TOOLCHAIN_FILE=$CMAKE_TOOLCHAIN_FILE \
	-DCMAKE_INSTALL_PREFIX=$LIB_PREFIX \
	-DOPENSSL_INCLUDE_DIR=$LIB_PREFIX/include/ \
	-DOPENSSL_LIBRARIES=$LIB_PREFIX/lib/"

wget -c "$SRT_PKG_URL" -P "$DOWNLOAD_DIR" --output-document srt-v$SRT_TAG.tar.gz && tar -zxvf srt-v$SRT_TAG.tar.gz -C $DEPENDENCY_DIR

cd $DEPENDENCY_DIR/srt-$SRT_TAG && cmake . $SRT_CONFIG && make -j$(nproc) && make install

./configure --prefix=deps/$arch --pkg-config=pkg-config \
          --enable-small \
          --enable-static \
          --disable-shared \
          --disable-runtime-cpudetect \
          --disable-autodetect \
          --disable-ffplay \
          --disable-ffprobe \
          --disable-doc \
          --disable-htmlpages \
          --disable-manpages \
          --disable-podpages \
          --disable-txtpages \
          --enable-nonfree \
          --enable-avcodec \
          --enable-avformat \
          --enable-avfilter \
          --enable-pthreads \
          --enable-network \
          --enable-swscale \
          --enable-swscale-alpha \
          --disable-avdevice \
          --disable-postproc \
          --disable-everything \
          --enable-protocol=file \
          --enable-protocol=rtmp \
          --enable-filter=aresample \
          --enable-filter=scale \
          --enable-decoder=h264 \
          --enable-decoder=pcm_alaw \
          --enable-decoder=pcm_mulaw \
          --enable-decoder=hevc \
          --enable-encoder=aac \
          --enable-encoder=mjpeg \
          --enable-parser=h264 \
          --enable-parser=hevc \
          --enable-parser=mjpeg \
          --enable-muxer=mp4 \
          --enable-muxer=flv \
          --enable-muxer=mpegts \
          --enable-muxer=rtsp \
          --enable-muxer=rtp \
          --enable-muxer=hevc \
          --enable-muxer=image2 \
          --enable-muxer=mjpeg \
          --enable-muxer=data \
          --enable-demuxer=mov \
          --enable-demuxer=flv \
          --enable-demuxer=mpegts \
          --enable-demuxer=rtsp \
          --enable-demuxer=rtp \
          --enable-demuxer=hevc \
          --enable-demuxer=matroska \
          --enable-bsf=extract_extradata \
          --enable-libsrt \
          --enable-protocol=libsrt

make -j$(nproc) && make install