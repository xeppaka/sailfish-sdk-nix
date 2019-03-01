#!/usr/bin/env bash

INSTALL_DIR=$1
VM_NAME="Sailfish OS Emulator"
VBoxManage createvm --name "$VM_NAME" --ostype Linux26 --register
VBoxManage storagectl "$VM_NAME" --add sata --name SATA --bootable on --portcount 1 --hostiocache off
VBoxManage storageattach "$VM_NAME" --storagectl SATA --type hdd --hotpluggable off --port 0 --device 0 --medium "$INSTALL_DIR/emulator/sailfishos.vdi"
VBoxManage modifyvm "$VM_NAME" --pae on --longmode on --largepages on --memory 1024 --paravirtprovider default --vram 128 --vrde off --bioslogofadein on --bioslogofadeout on --bioslogodisplaytime 1 --ioapic on --x2apic off --rtcuseutc on
VBoxManage modifyvm "$VM_NAME" --nic1 nat --nictype1 virtio --cableconnected1 on --natdnshostresolver1 on --natpf1 freeport_10000,tcp,127.0.0.1,10000,,10000 --natpf1 freeport_10001,tcp,127.0.0.1,10001,,10001 --natpf1 freeport_10002,tcp,127.0.0.1,10002,,10002 --natpf1 freeport_10003,tcp,127.0.0.1,10003,,10003 --natpf1 freeport_10004,tcp,127.0.0.1,10004,,10004 --natpf1 freeport_10005,tcp,127.0.0.1,10005,,10005 --natpf1 freeport_10006,tcp,127.0.0.1,10006,,10006 --natpf1 freeport_10007,tcp,127.0.0.1,10007,,10007 --natpf1 freeport_10008,tcp,127.0.0.1,10008,,10008 --natpf1 freeport_10009,tcp,127.0.0.1,10009,,10009 --natpf1 freeport_10010,tcp,127.0.0.1,10010,,10010 --natpf1 freeport_10011,tcp,127.0.0.1,10011,,10011 --natpf1 freeport_10012,tcp,127.0.0.1,10012,,10012 --natpf1 freeport_10013,tcp,127.0.0.1,10013,,10013 --natpf1 freeport_10014,tcp,127.0.0.1,10014,,10014 --natpf1 freeport_10015,tcp,127.0.0.1,10015,,10015 --natpf1 freeport_10016,tcp,127.0.0.1,10016,,10016 --natpf1 freeport_10017,tcp,127.0.0.1,10017,,10017 --natpf1 freeport_10018,tcp,127.0.0.1,10018,,10018 --natpf1 freeport_10019,tcp,127.0.0.1,10019,,10019 --natpf1 guestssh,tcp,127.0.0.1,2223,,22 --natpf1 qmllive_1,tcp,127.0.0.1,10234,,10234
VBoxManage modifyvm "$VM_NAME" --nic2 natnetwork --nat-network2 "SailfishOS-SDK" --cableconnected1 on --nictype2 virtio
VBoxManage sharedfolder add "$VM_NAME" --name "home" --hostpath "$HOME"
VBoxManage sharedfolder add "$VM_NAME" --name "targets" --hostpath "$INSTALL_DIR/mersdk/targets"
VBoxManage sharedfolder add "$VM_NAME" --name "ssh" --hostpath "$INSTALL_DIR/mersdk/ssh"
VBoxManage sharedfolder add "$VM_NAME" --name "config" --hostpath "$INSTALL_DIR/vmshare"
VBoxManage sharedfolder add "$VM_NAME" --name "src1" --hostpath "$HOME/development"
VBoxManage setextradata "$VM_NAME" "CustomVideoMode1" "360x640x32"
VBoxManage setextradata "$VM_NAME" "GUI/LastCloseAction" "PowerOff"
VBoxManage setextradata "$VM_NAME" "GUI/LastNormalWindowPosition" "471,376,360,701"
VBoxManage setextradata "$VM_NAME" "GUI/LastScaleWindowPosition" "325,218,676,1083"
VBoxManage setextradata "$VM_NAME" "GUI/RestrictedCloseActions" "SaveState,Shutdown"
