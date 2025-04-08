# Game Development in C++ using raylib

## Step 1: Setting Up the Framework

### Installing Raylib and Friends

Refer to the ``install.sh`` script for installing and setting up [**raylib**](https://www.raylib.com/) and friends (**mingw-w64** for cross-platform compilation to Windows, [**Box2D**](https://box2d.org/) for 2D physics, [**JoltPhysics**](https://jrouwe.github.io/JoltPhysicsDocs/5.2.0/index.html) for 3D physics and **emscriptenSDK** for compiling to HTML5):

```bash
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
```

Please note that this code is specific for Debian-based Linux distros (which use the apt package manager). For RPM or Arch-based distros, which have different package managers, the commands for installing dependencies will vary.

### Compiling Executables for Windows and Linux

The last part of the script demonstrates how to compile any code such as our example ``src/main.cpp``:

```C++
#include<raylib.h>
#include<box2d/box2d.h>
#include<Jolt/Jolt.h>

int main()
{
    return 0;
}
```

into a Linux executable. Similarly, we can leverage ``mingw-w64`` to cross-compile to Windows executables (.exe) as well. This is automated into the ``windows_build.sh``, and should pose no problem. Please note that the assets used in your games must be included along with the binaries (Windows/Linux) when shipping the game.

### Compiling to HTML5 for Browser-Based Play

Text describing emscriptenSDK.

### TL;DR

```bash
# clone this repository
git clone https://github.com/dassarthak18/raylib-gamedev.git
# install all libraries (assuming Ubuntu)
# this creates a bin directory, a bin-web directory and an emsdk directory which will be important later
sudo ./install.sh
# can compile your code cross-platform (to Windows)
sudo ./windows_build.sh
```

### Next

* [Step 2: Basic Game Structure](docs/step_2.md)
