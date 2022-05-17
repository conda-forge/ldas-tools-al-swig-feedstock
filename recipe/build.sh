#!/bin/bash

mkdir -p build
pushd build

# configure
cmake ${CMAKE_ARGS} .. \
	-DCMAKE_INSTALL_PREFIX=${PREFIX} \
	-DCMAKE_BUILD_TYPE=Release \
	-DENABLE_SWIG_PYTHON2=no \
	-DENABLE_SWIG_PYTHON3=no

# build
cmake --build . -- -j${CPU_COUNT}

# test
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
ctest -V
fi

# install [NOTE: we don't install because this package is essentially empty]
cmake --build . --target install
