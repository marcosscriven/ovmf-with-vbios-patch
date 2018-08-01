#! /bin/bash

mkdir -p build
docker build -t ovmf-vbios-patch docker-build       
docker run -v "$PWD/build:/build" -v "$PWD/roms:/roms" ovmf-vbios-patch /ovmf/compile-ovmf.sh quadro-1200m.rom
tar -czf build/ovmf-vbios-patched.tgz build/OVMF*
