PROJECT_DIR=$(PWD)
DOWNLOAD_DIR=$(PROJECT_DIR)/downloads
DEPENDENCY_DIR=$(PROJECT_DIR)/dependency

LIB_ROOT=$(PROJECT_DIR)

ifeq ($(sigmastar),1)
  vivotek=1
  include $(PROJECT_DIR)/cross_compile_arm.mk
  LIB_PREFIX=$(LIB_ROOT)/deps/sigmastar
  SIP_SPECIAL_CONFIGS=--disable-libwebrtc
  PLATFORM=sigmastar
else ifeq ($(cv22),1)
  vivotek=1
  include $(PROJECT_DIR)/cv22.mk
  LIB_PREFIX=$(LIB_ROOT)/deps/cv22
  PLATFORM=cv22
else ifeq ($(armv7hf),1)
  axis=1
  include $(AXIS_PLATFORM_DIR)/armv7hf.mk
  LIB_PREFIX=$(LIB_ROOT)/deps/armv7hf
  SIP_SPECIAL_CONFIGS=--disable-libwebrtc
  PLATFORM=armv7hf
else ifeq ($(aarch64),1)
  axis=1
  include $(AXIS_PLATFORM_DIR)/aarch64.mk
  LIB_PREFIX=$(LIB_ROOT)/deps/aarch64
  PLATFORM=aarch64
else ifeq ($(darwin),1)
  vivotek=1
  include $(PROJECT_DIR)/darwin.mk
  LIB_PREFIX=$(LIB_ROOT)/deps/darwin
else
  is_X64=1
  vivotek=1
  include $(PROJECT_DIR)/x64.mk
  LIB_PREFIX=$(LIB_ROOT)/deps/x64
endif

WGET=wget -c


#srt
SRT_TAG=1.5.4
SRT_PKG_URL=https://github.com/turingvideo/FFmpeg-1/releases/download/v5.0-turing-$(FFMPEG_RELEASE_TAG)/srt-$(SRT_TAG).tar.gz
SRT_PKG=$(DOWNLOAD_DIR)/srt-$(SRT_TAG).tar.gz
SRT_CONFIG= -DENABLE_APPS=OFF -DENABLE_STATIC=ON -DENABLE_SHARED=OFF -DUSE_OPENSSL_PC=FALSE \
	-DCMAKE_TOOLCHAIN_FILE=$(CMAKE_TOOLCHAIN_FILE) \
	-DCMAKE_INSTALL_PREFIX=$(LIB_PREFIX) \
	-DOPENSSL_INCLUDE_DIR=$(LIB_PREFIX)/include/ \
	-DOPENSSL_LIBRARIES=$(LIB_PREFIX)/lib/

#ffmpeg
FFMPEG_RELEASE_TAG=0.1.13
ifeq ($(COMPLIE_FFMPEG_SRC),1) #src
FFMPEG_VERSION=FFmpeg-1-5.0-turing-$(FFMPEG_RELEASE_TAG)
FFMPEG_PKG_URL=https://github.com/turingvideo/FFmpeg-1/archive/refs/tags/v5.0-turing-$(FFMPEG_RELEASE_TAG).tar.gz
else #release
FFMPEG_VERSION=ffmpeg-$(PLATFORM)-ubuntu-v5.0-turing-$(FFMPEG_RELEASE_TAG)
FFMPEG_PKG_URL=https://github.com/turingvideo/FFmpeg-1/releases/download/v5.0-turing-$(FFMPEG_RELEASE_TAG)/$(FFMPEG_VERSION).tar.gz
endif

FFMPEG_PKG=$(DOWNLOAD_DIR)/$(FFMPEG_VERSION).tar.gz
FFMPEG_STATIC_LIB=$(LIB_PREFIX)/libavutil.a
FFMPEG_CONFIG= $(FFMPEG_CROSS_COMPILE_ARGS) --pkg-config=pkg-config \
				--extra-cflags="-I$(LIB_PREFIX)/include/ -fPIC" \
				--extra-ldflags="-L$(LIB_PREFIX)/lib/ -lsrt -lssl -lcrypto -lpthread -lm -lstdc++" \
				--extra-libs="-lsrt -lssl -lcrypto -lpthread -lm -lstdc++ -ldl" \
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
				--enable-demuxer=wav \
				--enable-demuxer=pcm_mulaw \
				--enable-demuxer=pcm_alaw \
				--enable-bsf=extract_extradata \
				--enable-libsrt \
				--enable-protocol=libsrt

$(FFMPEG_PKG):
	mkdir -p $(DOWNLOAD_DIR)
	@echo "ffmpeg begin downolad..."
	$(WGET) $(FFMPEG_PKG_URL) -P $(DOWNLOAD_DIR) --output-document $(FFMPEG_PKG)
	mkdir -p $(DEPENDENCY_DIR)

$(FFMPEG_STATIC_LIB): $(FFMPEG_PKG)
ifeq ($(COMPLIE_FFMPEG_SRC),1)
	@echo "srt build config..."
	echo ${SRT_CONFIG}
	$(WGET) $(SRT_PKG_URL) -P $(DOWNLOAD_DIR) --output-document $(SRT_PKG) && tar -zxvf $(SRT_PKG) -C $(DEPENDENCY_DIR)
	cd $(DEPENDENCY_DIR)/srt-$(SRT_TAG) && cmake . $(SRT_CONFIG) && make -j $(JOBS) && make install

	tar -xvf $(FFMPEG_PKG) -C $(DEPENDENCY_DIR)
	@echo "ffmpeg begin config..."
	cd $(DEPENDENCY_DIR)/$(FFMPEG_VERSION) && $(FFMPEG_CROSS_COMPILE_ARGS_EXTRA) PKG_CONFIG_PATH=$(PKG_CONFIG_PATH):$(LIB_PREFIX)/lib/pkgconfig CC=$(CC) ./configure --prefix=$(LIB_PREFIX) $(FFMPEG_CONFIG)
	@echo "ffmpeg begin make..."
	cd $(DEPENDENCY_DIR)/$(FFMPEG_VERSION) && make -j $(JOBS) && make install
else
	@echo "copy ffmpeg include/lib/exe"
	tar -xvf $(FFMPEG_PKG) -C $(LIB_ROOT)
endif
	@echo "copy ffmpeg exe to build dir"
	mkdir -p $(BUILD_DIR)
	cp -f $(LIB_PREFIX)/bin/ffmpeg $(BUILD_DIR)
	chmod +x $(BUILD_DIR)/ffmpeg

ffmpeg: openssl $(FFMPEG_STATIC_LIB)

ZLIB_VERSION=1.2.13
ZLIB_DIR_NAME=zlib-$(ZLIB_VERSION)
ZLIB_PKG_URL=https://github.com/turingvideo/zlib/archive/refs/tags/v$(ZLIB_VERSION).tar.gz
ZLIB_PKG=$(DOWNLOAD_DIR)/$(ZLIB_DIR_NAME).tar.gz
ZLIB_CONFIG_FILE=$(DEPENDENCY_DIR)/$(ZLIB_DIR_NAME)/configure
ZLIB_STATIC_LIB=$(LIB_PREFIX)/lib/libz.a
ZLIB_MAKEFILE=$(DEPENDENCY_DIR)/$(ZLIB_DIR_NAME)/Makefile

$(ZLIB_PKG):
	mkdir -p $(DOWNLOAD_DIR)
	$(WGET) $(ZLIB_PKG_URL) -P $(DOWNLOAD_DIR) --output-document $(ZLIB_PKG)

$(ZLIB_CONFIG_FILE): $(ZLIB_PKG)
	mkdir -p $(DEPENDENCY_DIR)
	tar -xzvf $(ZLIB_PKG) -C $(DEPENDENCY_DIR)

$(ZLIB_MAKEFILE): $(ZLIB_CONFIG_FILE)
	cd $(DEPENDENCY_DIR)/$(ZLIB_DIR_NAME) && CC=$(CC) ./configure $(CONFIG_DEBUG) --static -prefix=$(LIB_PREFIX)

$(ZLIB_STATIC_LIB): $(ZLIB_MAKEFILE)
	cd $(DEPENDENCY_DIR)/$(ZLIB_DIR_NAME) && make -j $(JOBS) && make install

zlib: $(ZLIB_STATIC_LIB)

OPENSSL_VERSION=openssl-3.0.2
OPENSSL_PKG_URL=https://www.openssl.org/source/$(OPENSSL_VERSION).tar.gz
OPENSSL_CONFIG_FILE=$(DEPENDENCY_DIR)/$(OPENSSL_VERSION)/Configure
OPENSSL_MAKEFILE=$(DEPENDENCY_DIR)/$(OPENSSL_VERSION)/Makefile
OPENSSL_PKG=$(DOWNLOAD_DIR)/$(OPENSSL_VERSION).tar.gz
OPENSSL_CRYPTO_LIB=$(LIB_PREFIX)/lib/libcrypto.a
OPENSSL_SSL_LIB=$(LIB_PREFIX)/lib/libssl.a
OPENSSL_STATIC_LIBS="$(OPENSSL_SSL_LIB);$(OPENSSL_CRYPTO_LIB)"

$(OPENSSL_PKG):
	mkdir -p $(DOWNLOAD_DIR)
	$(WGET) $(OPENSSL_PKG_URL) -P $(DOWNLOAD_DIR) --output-document $(OPENSSL_PKG)

$(OPENSSL_CONFIG_FILE): $(OPENSSL_PKG)
	mkdir -p $(DEPENDENCY_DIR)
	tar -xzvf $(OPENSSL_PKG) -C $(DEPENDENCY_DIR)

$(OPENSSL_MAKEFILE): $(OPENSSL_CONFIG_FILE) $(ZLIB_STATIC_LIB)
	cd $(DEPENDENCY_DIR)/$(OPENSSL_VERSION) && $(OPENSSL_CROSS_COMPILE_ARGS_EXTRA) CC=$(CC) ./Configure $(TARGET_PLATFORM) no-shared $(CONFIG_DEBUG) --prefix=$(LIB_PREFIX) \
		--openssldir=$(LIB_PREFIX)/openssl --libdir=$(LIB_PREFIX)/lib --with-zlib-include=$(LIB_PREFIX)/include --with-zlib-lib=$(LIB_PREFIX)/lib

$(OPENSSL_CRYPTO_LIB): $(OPENSSL_MAKEFILE)
	mkdir -p $(LIB_PREFIX)
	cd $(DEPENDENCY_DIR)/$(OPENSSL_VERSION) && make -j $(JOBS) && make install_sw

$(OPENSSL_SSL_LIB): $(OPENSSL_MAKEFILE)
	mkdir -p $(LIB_PREFIX)
	cd $(DEPENDENCY_DIR)/$(OPENSSL_VERSION) && make -j $(JOBS) && make install_sw

openssl: zlib $(OPENSSL_SSL_LIB)