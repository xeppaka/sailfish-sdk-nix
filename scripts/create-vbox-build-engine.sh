#!/usr/bin/env bash

INSTALL_DIR=$1
VM_NAME="Sailfish OS Build Engine"
VBoxManage createvm --name "$VM_NAME" --ostype Linux26 --register
VBoxManage storagectl "$VM_NAME" --add sata --name SATA --bootable on --portcount 1 --hostiocache off
VBoxManage storageattach "$VM_NAME" --storagectl SATA --type hdd --hotpluggable off --port 0 --device 0 --medium "$INSTALL_DIR/mersdk/mer.vdi"
VBoxManage modifyvm "$VM_NAME" --pae on --longmode on --largepages on --memory 1024 --paravirtprovider default --vram 10 --vrde off --bioslogofadein on --bioslogofadeout on --bioslogodisplaytime 1 --ioapic on --x2apic off --rtcuseutc on
VBoxManage modifyvm "$VM_NAME" --nic1 nat --nictype1 virtio --cableconnected1 on --natdnshostresolver1 on --natpf1 guestssh,tcp,127.0.0.1,2222,,22 --natpf1 guestwww,tcp,127.0.0.1,8080,,9292
VBoxManage modifyvm "$VM_NAME" --nic2 natnetwork --nat-network2 "SailfishOS-SDK" --cableconnected1 on --nictype2 virtio
VBoxManage sharedfolder add "$VM_NAME" --name "ssh" --hostpath "$INSTALL_DIR/emulator/1/ssh"
VBoxManage sharedfolder add "$VM_NAME" --name "config" --hostpath "$INSTALL_DIR/vmshare"
VBoxManage setextradata "$VM_NAME" "GUI/LastNormalWindowPosition" "385,409,800,661"
VBoxManage setextradata "$VM_NAME" "VBoxInternal2/SharedFoldersEnableSymlinksCreate/home" "1"
VBoxManage setextradata "$VM_NAME" "VBoxInternal2/SharedFoldersEnableSymlinksCreate/src1" "1"
VBoxManage setextradata "$VM_NAME" "VBoxInternal2/SharedFoldersEnableSymlinksCreate/targets" "1"
