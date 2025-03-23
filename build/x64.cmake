# target operating system
set(CMAKE_SYSTEM_NAME Linux)
#set(CROSS_PATH /opt/gcc-sigmastar-9.1.0-2019.11-x86_64_arm-linux-gnueabihf)
set(LIB_PATH /usr/local)

# Where to look for the target environment. (More paths can be added here)
set(CMAKE_FIND_ROOT_PATH "${LIB_PATH}")

# which compilers to use for C and C++
#set(CMAKE_C_COMPILER arm-linux-gnueabihf-gcc)
#set(CMAKE_CXX_COMPILER arm-linux-gnueabihf-g++)

# search headers and libraries in the target environment
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(SIP_LIBS_REPLACE_STR -x86_64-unknown-linux-gnu)
set(LIBWEBSOCKETS_CMAKE_FLAGS_EXTRA -DCMAKE_C_FLAGS="-Wno-error=enum-int-mismatch")
