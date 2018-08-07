#! /bin/bash

echo "Starting VM"

sudo qemu-system-x86_64 \
  -name "Windows10-QEMU" \
  -machine type=q35,accel=kvm \
  -global ICH9-LPC.disable_s3=1 \
  -global ICH9-LPC.disable_s4=1 \
  -enable-kvm \
  -cpu host,kvm=off,hv_vapic,hv_relaxed,hv_spinlocks=0x1fff,hv_time,hv_vendor_id=12alphanum \
  -smp 6,sockets=1,cores=3,threads=2 \
  -m 8G \
  -rtc clock=host,base=localtime \
  -device ich9-intel-hda -device hda-output \
  -device qxl,bus=pcie.0,addr=1c.4,id=video.2 \
  -serial none \
  -parallel none \
  -k en-us \
  -spice port=5901,addr=127.0.0.1,disable-ticketing \
  -usb \
  -device ioh3420,bus=pcie.0,addr=1c.0,multifunction=on,port=1,chassis=1,id=root.1 \
  -drive if=pflash,format=raw,readonly=on,file=/home/marcosscriven/Downloads/build/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=/home/marcosscriven/Downloads/build/OVMF_VARS.fd \
  -drive file=/home/marcosscriven/Downloads/Win10_1803_English_x64.iso,format=raw,if=none,id=drive-sata0-0-0,media=cdrom,readonly=on
  -device ide-cd,bus=ide.0,drive=drive-sata0-0-0,id=sata0-0-0,bootindex=1
  -drive file=/var/lib/libvirt/images/win10-2-2.qcow2,format=qcow2,if=none,id=drive-sata0-0-2
  -device ide-hd,bus=ide.2,drive=drive-sata0-0-2,id=sata0-0-2,bootindex=2
  -netdev tap,fd=22,id=hostnet0
  -device rtl8139,netdev=hostnet0,id=net0,mac=52:54:00:50:41:60,bus=pci.8,addr=0x1
  -boot menu=on \
  -boot order=c \
  -device pci-bridge,addr=12.0,chassis_nr=2,id=head.2 
  