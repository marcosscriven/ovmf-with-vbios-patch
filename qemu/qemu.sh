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
  -vcpu vcpunum=0,affinity=1 -vcpu vcpunum=1,affinity=5 \
  -vcpu vcpunum=2,affinity=2 -vcpu vcpunum=3,affinity=6 \
  -vcpu vcpunum=4,affinity=3 -vcpu vcpunum=5,affinity=7 \
  -m 8G \
  -mem-path /dev/hugepages \
  -mem-prealloc \
  -balloon none \
  -rtc clock=host,base=localtime \
  -device ich9-intel-hda -device hda-output \
  -device qxl,bus=pcie.0,addr=1c.4,id=video.2 \
  -vga none \
  -nographic \
  -serial none \
  -parallel none \
  -k en-us \
  -spice port=5901,addr=127.0.0.1,disable-ticketing \
  -usb \
  -device ioh3420,bus=pcie.0,addr=00.0,multifunction=on,port=1,chassis=1,id=root.1 \
  -device vfio-pci,host=01:00.0,bus=root.1,addr=00.0,x-pci-sub-device-id=0x07b1,x-pci-sub-vendor-id=0x1028,multifunction=on,romfile=MyGPU.rom \
  -drive if=pflash,format=raw,readonly=on,file=/usr/share/OVMF/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=WIN_VARS.fd \
  -boot menu=on \
  -boot order=c \
  -drive id=disk0,if=virtio,cache=none,format=raw,file=WindowsVM.img \
  -drive file=windows10.iso,index=1,media=cdrom \
  -drive file=virtio-win-0.1.141.iso,index=2,media=cdrom \
  -netdev type=tap,id=net0,ifname=tap0,script=tap_ifup,downscript=tap_ifdown,vhost=on \
  -device virtio-net-pci,netdev=net0,addr=19.0,mac=<address your generate>
  -device pci-bridge,addr=12.0,chassis_nr=2,id=head.2 \
  -device usb-tablet
  