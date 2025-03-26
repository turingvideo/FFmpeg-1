CROSS_COMPILE_DIR=/usr/bin/
CROSS_COMPILE=arm-linux-gnueabihf
CROSS_COMPILE_PREFIX=$(CROSS_COMPILE_DIR)$(CROSS_COMPILE)-
TARGET_PLATFORM=linux-armv4
CC=$(CROSS_COMPILE_DIR)$(CROSS_COMPILE)-gcc
CXX=$(CROSS_COMPILE_DIR)$(CROSS_COMPILE)-g++

# Compile args
CURL_CROSS_COMPILE_ARGS=--target=$(CROSS_COMPILE) --host=$(CROSS_COMPILE) CFLAGS="-DHAVE_STRUCT_TIMEVAL"
XML_CROSS_COMPILE_ARGS=--target=$(CROSS_COMPILE) --host=$(CROSS_COMPILE)
SIP_CROSS_COMPILE_ARGS=--target=$(CROSS_COMPILE) --host=$(CROSS_COMPILE) LDFLAGS='-lm' CFLAGS='-Wno-error=unused-label -Wno-error=format' LD=$(CC)
PCAP_CROSS_COMPILE_ARGS=--target=$(CROSS_COMPILE) --host=$(CROSS_COMPILE) CFLAGS="-fPIC"
FFMPEG_CROSS_COMPILE_ARGS=--arch=armv7hf --target-os=linux --cross-prefix=$(CROSS_COMPILE_PREFIX) --enable-cross-compile

#Extra flags
OPENSSL_CROSS_COMPILE_ARGS_EXTRA=unset CROSS_COMPILE && CFLAGS="-fPIC"
FFMPEG_CROSS_COMPILE_ARGS_EXTRA=CFLAGS="-fPIC"
LIBWEBSOCKETS_CMAKE_FLAGS_EXTRA=-DCMAKE_C_FLAGS="-Wno-error"
CFLAGS_EXTRA=-Wno-error=stringop-truncation -Wno-error=stringop-overflow -Wno-error=format-truncation -Wno-error=format-overflow -Wno-error=maybe-uninitialized

SIP_LIBS_REPLACE_STR=-arm-unknown-linux-gnueabihf

