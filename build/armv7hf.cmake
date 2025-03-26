# target operating system
set(CMAKE_SYSTEM_NAME Linux)
set(CROSS_PATH /usr)

# which compilers to use for C and C++
set(CMAKE_C_COMPILER ${CROSS_PATH}/bin/arm-linux-gnueabihf-gcc)
set(CMAKE_CXX_COMPILER ${CROSS_PATH}/bin/arm-linux-gnueabihf-g++)
message(STATUS "CMAKE_C_COMPILER ===== ${CMAKE_C_COMPILER}")
message(STATUS "CMAKE_CXX_COMPILER ===== ${CMAKE_CXX_COMPILER}")

set(CROSS_COMPILE_DIR /usr/bin/)
set(CROSS_COMPILE arm-linux-gnueabihf)
set(CROSS_COMPILE_PREFIX ${CROSS_COMPILE_DIR}${CROSS_COMPILE}-)
set(TARGET_PLATFORM linux-generic32)
set(CC ${CROSS_COMPILE_PREFIX}gcc)
set(CURL_CROSS_COMPILE_ARGS --target=${CROSS_COMPILE} --host=${CROSS_COMPILE})
set(XML_CROSS_COMPILE_ARGS --target=${CROSS_COMPILE} --host=${CROSS_COMPILE})
set(SIP_CROSS_COMPILE_ARGS --target=${CROSS_COMPILE} --host=${CROSS_COMPILE})
set(PCAP_CROSS_COMPILE_ARGS --target=${CROSS_COMPILE} --host=${CROSS_COMPILE})
set(FFMPEG_CROSS_COMPILE_ARGS --arch=armv7hf --target-os=linux --cross-prefix=${CROSS_COMPILE_PREFIX} --enable-cross-compile)

# search headers and libraries in the target environment
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(SIP_LIBS_REPLACE_STR -arm-unknown-linux-gnueabihf)
