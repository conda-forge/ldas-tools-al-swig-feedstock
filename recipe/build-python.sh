#!/bin/bash

set -ex

mkdir -p _build
BUILD_DIR=$(pwd)/_build

# configure
cmake \
  ${CMAKE_ARGS} \
  -DENABLE_SWIG_PYTHON3=yes \
  -DPython3_EXECUTABLE=${PYTHON} \
  -S ${SRC_DIR} \
  -B ${BUILD_DIR}

# build
cmake --build ${BUILD_DIR}/python --parallel ${CPU_COUNT}

# test
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
ctest --output-on-failure --test-dir ${BUILD_DIR}/python --verbose --verbose
fi

# install
cmake --build ${BUILD_DIR}/python --parallel ${CPU_COUNT} --target install
