#! /bin/bash

# This will take a regular ROM file and create a vrom.h and vrom_table.h for it
function prepareRomPatch() {
  rom_file=$1

  echo "Preparing patch for $rom_file"

  # Work in the /patches dir
  mkdir -p /patches
  pushd /patches

  # Make a header file from the binary rom
  cp "/roms/${rom_file}" vBIOS.bin
  xxd -i vBIOS.bin vrom.h
  sed -i 's/vBIOS_bin/VROM_BIN/g; s/_len/_LEN/g' vrom.h

  # Grab its length and update it in the ssdt
  cp /ovmf/ssdt.asl .
  rom_len=$(grep VROM_BIN_LEN vrom.h | cut -d' ' -f5 | sed 's/;//g')
  sed -i "s/103936/$rom_len/g" ssdt.asl
  iasl -f ssdt.asl

  # Create a vrom table
  xxd -c1 Ssdt.aml | tail -n +37 | cut -f2 -d' ' | paste -sd' ' | sed 's/ //g' | xxd -r -p > vrom_table.aml
  xxd -i vrom_table.aml | sed 's/vrom_table_aml/vrom_table/g' > vrom_table.h

  popd
}

prepareRomPatch $1