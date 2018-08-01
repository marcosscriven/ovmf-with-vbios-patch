#! /bin/bash

mkdir -p build
docker build -t qvmf-vbios-patch docker-build       
docker run -v "$PWD/build:/build" -v "$PWD/roms:/roms" ovmf-vbios-patch /ovmf/compile-qvmf.sh
tar -czf build/ovmf-vbios-patched.tgz build/OVMF*
