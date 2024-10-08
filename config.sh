#!/bin/sh

if [ -z "$1" ]; then
  arch=x64
else
  arch=$1
fi

echo arch=$arch
echo prefix=deps/$arch

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
          --enable-bsf=extract_extradata
