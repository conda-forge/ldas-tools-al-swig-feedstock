#!/bin/bash

set -x
pushd ${SRC_DIR}/build

# get python options
if [ "${PY3K}" -eq 1 ]; then
  PYTHON_BUILD_OPTS="-DENABLE_SWIG_PYTHON2=no -DENABLE_SWIG_PYTHON3=yes -DPYTHON3_EXECUTABLE=${PYTHON}"
  PYTHON_BUILD_DIR="python3"
else
  PYTHON_BUILD_OPTS="-DENABLE_SWIG_PYTHON3=no -DENABLE_SWIG_PYTHON2=yes -DPYTHON2_EXECUTABLE=${PYTHON}"
  PYTHON_BUILD_DIR="python"
fi

# configure
cmake .. \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=RelWithBuildInfo \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
  ${PYTHON_BUILD_OPTS}

# build
cmake --build ${PYTHON_BUILD_DIR} -- -j${CPU_COUNT}

# install
cmake --build ${PYTHON_BUILD_DIR} --target install

# test
ctest -V

popd
