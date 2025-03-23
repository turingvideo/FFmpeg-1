# target operating system
set(CMAKE_SYSTEM_NAME Linux)
set(CROSS_PATH /opt/vivotek/amba_cv22/linaro-aarch64-2018.08-gcc8.2/bin)
# set(CROSS_LIB_PATH $(CROSS_PATH)/arm-linux-gnueabihf/libc/usr/)

# Where to look for the target environment. (More paths can be added here)
# set(CMAKE_FIND_ROOT_PATH "${CROSS_LIB_PATH}")

# which compilers to use for C and C++
set(CMAKE_C_COMPILER ${CROSS_PATH}/aarch64-linux-gnu-gcc)
set(CMAKE_CXX_COMPILER ${CROSS_PATH}/aarch64-linux-gnu-g++)
message(STATUS "CMAKE_C_COMPILER ===== ${CMAKE_C_COMPILER}")
message(STATUS "CMAKE_CXX_COMPILER ===== ${CMAKE_CXX_COMPILER}")

set(CROSS_COMPILE_DIR ${CROSS_PATH})
set(CROSS_COMPILE aarch64-linux-gnu)
set(CROSS_COMPILE_PREFIX ${CROSS_COMPILE_DIR}/${CROSS_COMPILE}-)
set(TARGET_PLATFORM linux-generic32)
set(CC ${CROSS_COMPILE_PREFIX}gcc)
set(CURL_CROSS_COMPILE_ARGS --target=${CROSS_COMPILE} --host=${CROSS_COMPILE})
set(XML_CROSS_COMPILE_ARGS --target=${CROSS_COMPILE} --host=${CROSS_COMPILE})
set(SIP_CROSS_COMPILE_ARGS --target=${CROSS_COMPILE} --host=${CROSS_COMPILE})
set(PCAP_CROSS_COMPILE_ARGS --target=${CROSS_COMPILE} --host=${CROSS_COMPILE})
set(OPENSSL_CROSS_COMPILE_ARGS --cross-compile-prefix=${CROSS_COMPILE_PREFIX})
set(FFMPEG_CROSS_COMPILE_ARGS --arch=aarch64 --target-os=linux --cross-prefix=${CROSS_COMPILE_PREFIX} --enable-cross-compile)

# search headers and libraries in the target environment
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(SIP_LIBS_REPLACE_STR -aarch64-unknown-linux-gnu)
