# Game Development in C++ using raylib

## Step 1: Setting Up the Framework

### Installing raylib and Friends

Refer to the ``install.sh`` script for installing and setting up [**raylib**](https://www.raylib.com/) and friends (**mingw-w64** for cross-platform compilation to Windows, [**Box2D**](https://box2d.org/) for 2D physics and [**JoltPhysics**](https://jrouwe.github.io/JoltPhysicsDocs/5.2.0/index.html) for 3D physics):

```bash
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

### TL;DR

```bash
# clone this repository
git clone https://github.com/dassarthak18/raylib-gamedev.git
# install all libraries (assuming Ubuntu)
sudo ./install.sh
# can compile your code cross-platform (to Windows)
sudo ./windows_build.sh
```
These scripts, battle-tested, are provided in this repository so that you don't have to spend hours and hours setting things up before even having the chance to get started!

### Next

* [Step 2: Basic Game Structure](docs/step_2.md)
