GAME_DIR="$(basename "$(pwd)")"
cmake -B build-win -S . \
  -DCMAKE_TOOLCHAIN_FILE=mingw-toolchain.cmake \
  -DPROJECT_NAME="${GAME_DIR}" \
  -DCMAKE_INSTALL_PREFIX=../bin \
  -DCMAKE_VERBOSE_MAKEFILE=ON
cmake --build build-win -- -j$(nproc)
sudo mv ./build-win/*.exe ./
sudo rm -rf build-win
