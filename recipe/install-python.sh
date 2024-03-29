#!/bin/bash

set -ex
pushd ${SRC_DIR}/build

# get python options
if [ "${PY3K}" -eq 1 ]; then
  PYTHON_BUILD_OPTS="-DENABLE_SWIG_PYTHON2=no -DENABLE_SWIG_PYTHON3=yes -DPYTHON3_EXECUTABLE=${PYTHON}"
else
  PYTHON_BUILD_OPTS="-DENABLE_SWIG_PYTHON3=no -DENABLE_SWIG_PYTHON2=yes -DPYTHON2_EXECUTABLE=${PYTHON}"
fi

# configure
cmake .. \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=RelWithBuildInfo \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
  ${PYTHON_BUILD_OPTS}

# build
cmake --build python -- -j${CPU_COUNT}

# install
cmake --build python --target install

# test
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
ctest -V
fi

popd
