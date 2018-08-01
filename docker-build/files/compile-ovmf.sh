#! /bin/bash

# This build is based on information gather from:
#
#   https://www.reddit.com/r/VFIO/comments/8gv60l/current_state_of_optimus_muxless_laptop_gpu/
#   https://github.com/jscinoz/optimus-vfio-docs/issues/2#issuecomment-380335101
#   https://gist.github.com/Ashymad/2c8192519492dec262b344deb68fed44
#

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

# Patch
/ovmf/prepare-rom-patch.sh
cp patches/vrom.h OvmfPkg/AcpiPlatformDxe/
cp patches/vrom_table.h OvmfPkg/AcpiPlatformDxe/

dos2unix OvmfPkg/AcpiPlatformDxe/QemuFwCfgAcpi.c
patch -p1 < /ovmf/QemuFwCfgAcpi.c.patch
unix2dos OvmfPkg/AcpiPlatformDxe/QemuFwCfgAcpi.c

# Build OVMF
. edksetup.sh BaseTools
./BaseTools/BinWrappers/PosixLike/build -t GCC5 -a X64 -p OvmfPkg/OvmfPkgX64.dsc -n $(nproc) -b RELEASE -D FD_SIZE_2MB

# Copy to host build dir
cp ${SRC_DIR}/Build/OvmfX64/RELEASE_GCC5/FV/OVMF_CODE.fd /build
cp ${SRC_DIR}/Build/OvmfX64/RELEASE_GCC5/FV/OVMF_VARS.fd /build