#!/bin/bash

# Install dependencies
sudo apt -y install libasound2-dev libx11-dev libxrandr-dev libxi-dev libgl1-mesa-dev \
libglu1-mesa-dev libxcursor-dev libxinerama-dev libwayland-dev libxkbcommon-dev \
git make cmake glslc glslang-tools libshaderc-dev libshaderc1 vulkan-tools mingw-w64 shim-signed
sudo apt -y update && sudo apt -y upgrade && sudo apt -y autoremove
mkdir bin && mkdir bin-web

# Install emscriptenSDK
git clone https://github.com/emscripten-core/emsdk.git && cd emsdk
./emsdk install latest && ./emsdk activate latest
source ./emsdk_env.sh
echo 'source ~/emsdk/emsdk_env.sh' >> ~/.bashrc
source ~/.bashrc && cd ..

# Install raylib
git clone https://github.com/raysan5/raylib.git && cd raylib
mkdir build && cd build
cmake -DBUILD_SHARED_LIBS=ON ..
make && sudo make install && sudo ldconfig
cmake .. -DCMAKE_TOOLCHAIN_FILE=../../mingw-toolchain.cmake -DCMAKE_INSTALL_PREFIX=../../bin -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=OFF
make -j$(nproc) && sudo make install
cd .. && mkdir build-web && cd build-web
emcmake cmake .. && emmake make
mv raylib ../../bin-web/
cd ../.. && rm -rf raylib

# Install Box2D for 2D Physics
git clone https://github.com/erincatto/box2d.git && cd box2d
cmake -DCMAKE_VERBOSE_MAKEFILE=ON .
make
sudo cmake -DCMAKE_INSTALL_PREFIX=/usr/local -P cmake_install.cmake
cp ../src/force_includes.h ./force_includes.h
cmake . -DCMAKE_TOOLCHAIN_FILE=../mingw-toolchain.cmake -DCMAKE_INSTALL_PREFIX=../bin -DCMAKE_CXX_FLAGS="-includeforce_includes.h"
cmake . -DCMAKE_TOOLCHAIN_FILE=../mingw-toolchain.cmake -DCMAKE_INSTALL_PREFIX=../bin -DCMAKE_CXX_FLAGS="-includeforce_includes.h"
make -j$(nproc)
sudo cmake -DCMAKE_INSTALL_PREFIX=../bin/ -P cmake_install.cmake
mkdir build-web && cd build-web
export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/share/pkgconfig:/usr/lib/x86_64-linux-gnu/pkgconfig
emcmake cmake .. -DCMAKE_TOOLCHAIN_FILE=$EMSDK/upstream/emscripten/cmake/Modules/Platform/Emscripten.cmake \
-DCMAKE_CROSSCOMPILING_EMULATOR=$EMSDK/node/20.18.0_64bit/bin/node \
-DGLFW_BUILD_WAYLAND=OFF -DGLFW_BUILD_X11=OFF -DGLFW_USE_OSMESA=OFF \
-DGLFW_BUILD_WIN32=OFF -DGLFW_BUILD_COCOA=OFF -DGLFW_BUILD_TESTS=OFF -DGLFW_BUILD_DOCS=OFF \
-DCMAKE_C_FLAGS="-std=gnu99 -pthread -s USE_PTHREADS=1 -DPOSIX_REQUIRED_STANDARD=199309L -D_POSIX_C_SOURCE=POSIX_REQUIRED_STANDARD -D_POSIX_SOURCE=POSIX_REQUIRED_STANDARD" \
-DCMAKE_CXX_FLAGS="-std=gnu++17 -Wno-nontrivial-memcall -pthread -s USE_PTHREADS=1" -DCMAKE_EXE_LINKER_FLAGS="-pthread -s USE_PTHREADS=1 -s ERROR_ON_UNDEFINED_SYMBOLS=0"
emmake make -j
cd .. && mv build-web ../bin-web/box2d
cd .. && rm -rf box2d

# Install JoltPhysics for 3D Physics
git clone https://github.com/jrouwe/JoltPhysics.git && cd JoltPhysics/Build/
cmake . && make && sudo make install
cmake . -DCMAKE_TOOLCHAIN_FILE=../../mingw-toolchain.cmake -DCMAKE_INSTALL_PREFIX=../../bin
make -j$(nproc) && sudo make install
mkdir ../Build-Web && cd ../Build-Web
emcmake cmake ../Build/ && emmake make && cd ..
mv Build-Web ../bin-web/JoltPhysics/
cd .. && rm -rf JoltPhysics

# Build for Linux
GAME_DIR="$(basename "$(pwd)")"
g++ src/main.cpp -o "${GAME_DIR}.sh"
chmod u+x "${GAME_DIR}.sh" && ./"${GAME_DIR}.sh"
