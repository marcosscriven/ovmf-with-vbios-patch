#! /bin/bash

mkdir -p build
docker build -t qvmf-vbios-patch docker-build       
docker run -v "$PWD/build:/build" -v "$PWD/roms:/roms" qvmf-vbios-patch /qvmf/compile-qvmf.sh
tar -czf build/qvmf-vbios-patched.tgz build/OVMF*
