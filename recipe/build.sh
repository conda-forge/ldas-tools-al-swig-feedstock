#!/bin/bash

mkdir -p build
pushd build

# configure
cmake .. \
	-DCMAKE_INSTALL_PREFIX=${PREFIX} \
	-DCMAKE_BUILD_TYPE=Release \
	-DENABLE_SWIG_PYTHON2=no \
	-DENABLE_SWIG_PYTHON3=no

# build
cmake --build . -- -j${CPU_COUNT}

# test
ctest -V

# install [NOTE: we don't install because this package is essentially empty]
cmake --build . --target install
