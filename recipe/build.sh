#!/bin/bash

set -ex

BUILD_DIR=$(pwd)/_build

# configure
cmake \
  ${CMAKE_ARGS} \
  -DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
  -DENABLE_SWIG_PYTHON3=no \
  -S ${SRC_DIR} \
  -B ${BUILD_DIR}

# build
cmake --build ${BUILD_DIR} --parallel ${CPU_COUNT}

# test
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
ctest --output-on-failure --test-dir ${BUILD_DIR} --verbose --verbose
fi

# install
cmake --build ${BUILD_DIR} --parallel ${CPU_COUNT} --target install
