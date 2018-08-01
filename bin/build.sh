#! /bin/bash

mkdir -p build
docker build -t qvmf-vbios-patch .       
docker run -v "$PWD/build:/build" -v "$PWD/roms:/roms" qvmf-vbios-patch /compile-qvmf.sh
tar -czf build/qvmf-vbios-patced.tgz build/OVMF*
