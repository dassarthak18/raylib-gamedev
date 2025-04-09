#!/bin/bash

# Install dependencies
sudo apt -y install libasound2-dev libx11-dev libxrandr-dev libxi-dev libgl1-mesa-dev \
libglu1-mesa-dev libxcursor-dev libxinerama-dev libwayland-dev libxkbcommon-dev \
git make cmake glslc glslang-tools libshaderc-dev libshaderc1 vulkan-tools mingw-w64 shim-signed
sudo apt -y update && sudo apt -y upgrade && sudo apt -y autoremove
mkdir bin

# Install raylib
git clone https://github.com/raysan5/raylib.git && cd raylib
mkdir build && cd build
cmake -DBUILD_SHARED_LIBS=ON ..
make && sudo make install && sudo ldconfig
cmake .. -DCMAKE_TOOLCHAIN_FILE=../mingw-toolchain.cmake -DCMAKE_INSTALL_PREFIX=../../bin -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=OFF
make -j$(nproc) && sudo make install
cd ../.. && rm -rf raylib

# Install Box2D for 2D Physics
git clone https://github.com/erincatto/box2d.git && cd box2d
cmake -DCMAKE_VERBOSE_MAKEFILE=ON .
make
sudo cmake -DCMAKE_INSTALL_PREFIX=/usr/local -P cmake_install.cmake
cp ../src/force_includes.h ./force_includes.h
cmake . -DCMAKE_TOOLCHAIN_FILE=../mingw-toolchain.cmake -DCMAKE_INSTALL_PREFIX=../bin -DCMAKE_CXX_FLAGS="-includeforce_includes.h"
make -j$(nproc)
sudo cmake -DCMAKE_INSTALL_PREFIX=../bin/ -P cmake_install.cmake
cd .. && rm -rf box2d

# Install JoltPhysics for 3D Physics
git clone https://github.com/jrouwe/JoltPhysics.git && cd JoltPhysics/Build/
cmake . && make && sudo make install
cmake . -DCMAKE_TOOLCHAIN_FILE=../../mingw-toolchain.cmake -DCMAKE_INSTALL_PREFIX=../../bin
make -j$(nproc) && sudo make install
cd ../.. && rm -rf JoltPhysics

# Build for Linux
GAME_DIR="$(basename "$(pwd)")"
g++ ./src/main.cpp -o "${GAME_DIR}.sh"
chmod u+x "${GAME_DIR}.sh" && ./"${GAME_DIR}.sh"
