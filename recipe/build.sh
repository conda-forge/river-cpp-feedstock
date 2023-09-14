#!/bin/bash

set -x -e
set -o pipefail

if [[ "${target_platform}" == osx-* ]]; then
    # See https://conda-forge.org/docs/maintainer/knowledge_base.html#newer-c-features-with-old-sdk
    CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

if [[ "${target_platform}" == osx-arm64 ]]; then
    # ZFP isn't properly built on Conda for OSX ARM64.
    RIVER_BUILD_ZFP="-DRIVER_BUILD_ZFP=OFF"
else
    RIVER_BUILD_ZFP="-DRIVER_BUILD_ZFP=ON"
fi

cd cpp
mkdir -p build/release
cd build/release
cmake -G "Unix Makefiles" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -DCMAKE_INSTALL_LIBDIR=lib \
  -DRIVER_BUILD_INGESTER=OFF \
  -DRIVER_BUILD_TESTS=OFF \
  -DRIVER_INSTALL=ON \
  ${RIVER_BUILD_ZFP} \
  ${CMAKE_ARGS} \
  ../..
make
make install

