# Install dependencies
sudo apt install libasound2-dev libx11-dev libxrandr-dev libxi-dev libgl1-mesa-dev libglu1-mesa-dev libxcursor-dev libxinerama-dev libwayland-dev libxkbcommon-dev git make cmake glslc glslang-tools libshaderc-dev libshaderc1 vulkan-tools mingw-w64
sudo apt -y update && sudo apt -y upgrade && sudo apt -y autoremove
sudo mkdir bin && sudo mkdir bin-web

# Install emscriptenSDK
git clone https://github.com/emscripten-core/emsdk.git && cd emsdk
./emsdk install latest && ./emsdk activate latest
source ./emsdk_env.sh
echo 'source ~/emsdk/emsdk_env.sh' >> ~/.bashrc
source ~/.bashrc && cd ..

# Install raylib
sudo git clone https://github.com/raysan5/raylib.git && cd raylib
sudo mkdir build && cd build
sudo cmake -DBUILD_SHARED_LIBS=ON ..
sudo make && sudo make install && sudo ldconfig
sudo cmake .. -DCMAKE_TOOLCHAIN_FILE=../../mingw-toolchain.cmake -DCMAKE_INSTALL_PREFIX=../../bin -DBUILD_EXAMPLES=OFF -DBUILD_SHARED_LIBS=OFF
sudo make -j$(nproc) && sudo make install
cd ../.. && sudo rm -rf raylib

# Install Box2D for 2D Physics
sudo git clone https://github.com/erincatto/box2d.git && cd box2d
sudo cmake -DCMAKE_VERBOSE_MAKEFILE=ON .
sudo make
sudo cmake -DCMAKE_INSTALL_PREFIX=/usr/local -P cmake_install.cmake
sudo cp ../src/force_includes.h ./force_includes.h
sudo cmake . -DCMAKE_TOOLCHAIN_FILE=../mingw-toolchain.cmake -DCMAKE_INSTALL_PREFIX=../bin -DCMAKE_CXX_FLAGS="-includeforce_includes.h"
sudo cmake . -DCMAKE_TOOLCHAIN_FILE=../mingw-toolchain.cmake -DCMAKE_INSTALL_PREFIX=../bin -DCMAKE_CXX_FLAGS="-includeforce_includes.h"
sudo make -j$(nproc)
sudo cmake -DCMAKE_INSTALL_PREFIX=../bin/ -P cmake_install.cmake
cd .. && sudo rm -rf box2d

# Install JoltPhysics for 3D Physics
sudo git clone https://github.com/jrouwe/JoltPhysics.git && cd JoltPhysics/Build/
sudo cmake . && sudo make && sudo make install
sudo cmake . -DCMAKE_TOOLCHAIN_FILE=../../mingw-toolchain.cmake -DCMAKE_INSTALL_PREFIX=../../bin
sudo make -j$(nproc) && sudo make install
cd ../.. && sudo rm -rf JoltPhysics

# Run tests
GAME_DIR="$(basename "$(pwd)")"
emcc -v
g++ src/main.cpp -o "${GAME_DIR}.sh"
chmod u+x "${GAME_DIR}.sh" && ./"${GAME_DIR}.sh"
