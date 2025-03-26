#!/bin/sh

set -e

if [ -z "$1" ]; then
  arch=x64
else
  arch=$1
fi

echo arch=$arch
echo prefix=deps/$arch

SCRIPT_DIR=$(dirname "$(realpath "$0")")
cd "$SCRIPT_DIR"

if [[ "$TARGET_ARCH" == "sigmaster" ]]; then
  CROSS_COMPILE_MAKE="./build/cross_compile_arm.mk"
  CMAKE_TOOLCHAIN_FILE="./build/cross_compile_arm.cmake"
elif [[ "$TARGET_ARCH" == "cv22" ]]; then
  CROSS_COMPILE_MAKE="./build/cv22.mk"
  CMAKE_TOOLCHAIN_FILE="./build/cv22.cmake"
elif [[ "$TARGET_ARCH" == "armv7hf" ]]; then
  CROSS_COMPILE_MAKE="./build/armv7hf.mk"
  CMAKE_TOOLCHAIN_FILE="./build/armv7hf.cmake"
elif [[ "$TARGET_ARCH" == "aarch64" ]]; then
  CROSS_COMPILE_MAKE="./build/aarch64.mk"
  CMAKE_TOOLCHAIN_FILE="./build/aarch64.cmake"
elif [[ "$TARGET_ARCH" == "x64" || -z "$TARGET_ARCH" ]]; then
  echo "No cross compile needed for x64"
  CROSS_COMPILE_MAKE=""
fi

SRT_PKG_URL=https://github.com/Haivision/srt/archive/refs/tags/v1.5.4.tar.gz
SRT_CONFIG= -DENABLE_APPS=OFF -DENABLE_STATIC=ON -DENABLE_SHARED=OFF -DUSE_OPENSSL_PC=FALSE \
	-DCMAKE_TOOLCHAIN_FILE=$(CMAKE_TOOLCHAIN_FILE) \
	-DCMAKE_INSTALL_PREFIX=$(LIB_PREFIX) \
	-DOPENSSL_INCLUDE_DIR=$(LIB_PREFIX)/include/ \
	-DOPENSSL_LIBRARIES=$(LIB_PREFIX)/lib/

wget -c $(SRT_PKG_URL) -P $(DOWNLOAD_DIR) --output-document $(SRT_PKG) && tar -zxvf $(SRT_PKG) -C $(DEPENDENCY_DIR)
cd $(DEPENDENCY_DIR)/srt-$(SRT_TAG) && cmake . $(SRT_CONFIG) && make -j$(nproc) && make install

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