#! /bin/bash

# Prepare env
export SRC_DIR="/edk2"
export PATH="${SRC_DIR}/bin:${PATH}"
export EDK_TOOLS_PATH="${SRC_DIR}/BaseTools"

# Prepare for build
cd ${SRC_DIR}
mkdir -p bin
ln -sf /usr/bin/python2.7 bin/python 
git pull

# Build Basetools
make -C BaseTools

# Build QVMF
. edksetup.sh BaseTools
./BaseTools/BinWrappers/PosixLike/build -t GCC5 -a X64 -p OvmfPkg/OvmfPkgX64.dsc -n $(nproc) -b RELEASE -D FD_SIZE_2MB