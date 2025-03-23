CROSS_COMPILE_DIR=/opt/gcc-sigmastar-9.1.0-2019.11-x86_64_arm-linux-gnueabihf/bin/
CROSS_COMPILE=arm-linux-gnueabihf
CROSS_COMPILE_PREFIX=$(CROSS_COMPILE_DIR)$(CROSS_COMPILE)-
TARGET_PLATFORM=linux-generic32
CC=$(CROSS_COMPILE_PREFIX)gcc
CXX=$(CROSS_COMPILE_PREFIX)g++
CURL_CROSS_COMPILE_ARGS=--target=$(CROSS_COMPILE) --host=$(CROSS_COMPILE)
XML_CROSS_COMPILE_ARGS=--target=$(CROSS_COMPILE) --host=$(CROSS_COMPILE)
SIP_CROSS_COMPILE_ARGS=--target=$(CROSS_COMPILE) --host=$(CROSS_COMPILE)
PCAP_CROSS_COMPILE_ARGS=--target=$(CROSS_COMPILE) --host=$(CROSS_COMPILE)
OPENSSL_CROSS_COMPILE_ARGS=--cross-compile-prefix=$(CROSS_COMPILE_PREFIX)
FFMPEG_CROSS_COMPILE_ARGS=--arch=armv7l --target-os=linux --cross-prefix=$(CROSS_COMPILE_PREFIX) --enable-cross-compile
SIP_LIBS_REPLACE_STR=-arm-unknown-linux-gnueabihf

