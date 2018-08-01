#! /bin/bash

mkdir -p /patches

function preparePatch() {
  rom_file = $1

  xxd -i "/roms/${rom_file}" /patches/vrom.h
  sed -i 's/vBIOS_bin/VROM_BIN/g; s/_len/_LEN/g' vrom.h
  rom_len=$(grep VROM_BIN_LEN vrom.h | cut -d' ' -f5 | sed 's/;//g')
  sed -i "s/103936/$rom_len/g" ssdt.asl
  iasl -f ssdt.asl
  xxd -c1 Ssdt.aml | tail -n +37 | cut -f2 -d' ' | paste -sd' ' | sed 's/ //g' | xxd -r -p > vrom_table.aml
  xxd -i vrom_table.aml | sed 's/vrom_table_aml/vrom_table/g' > vrom_table.h

  mv "$srcdir/vrom.h" "${srcdir}/edk2/OvmfPkg/AcpiPlatformDxe/"
  mv "$srcdir/vrom_table.h" "${srcdir}/edk2/OvmfPkg/AcpiPlatformDxe/"

  dos2unix "$srcdir/edk2/OvmfPkg/AcpiPlatformDxe/QemuFwCfgAcpi.c"
  cd "$srcdir/edk2"
  patch -p1 < "$srcdir/nvidia-hack.diff"
  unix2dos "$srcdir/edk2/OvmfPkg/AcpiPlatformDxe/QemuFwCfgAcpi.c"
}

function preparePatches() {
    preparePatch quadro-1200m.rom 
}