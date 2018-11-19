#!/nix/store/r47p5pzx52m3n34vdgqpk5rvqgm0m24m-bash-4.4-p23/bin/bash

INSTALL_DIR=$1
echo "Installation directory is $INSTALL_DIR"

mkdir -p $INSTALL_DIR

echo "Extracting emulator...\n"
#/nix/store/x1njq6vdr7iyjvvdq1znhxxl0if7hspz-p7zip-16.02/bin/7z -o$INSTALL_DIR x /nix/store/a14bfxx80s95m1yiklini2s8hp3g6r1q-2018.08.31-1emulator.7z
echo "Extracting mersdk...\n"
#/nix/store/x1njq6vdr7iyjvvdq1znhxxl0if7hspz-p7zip-16.02/bin/7z -o$INSTALL_DIR x /nix/store/ffwmlpgdv6plwsbbxdzpx6imhin0fmk2-2018.08.31-1mersdk.7z
mkdir -p $INSTALL_DIR/vmshare/ssh/private_keys/SailfishOS_Emulator
mkdir -p $INSTALL_DIR/vmshare/ssh/private_keys/engine
echo "Generating emulator ssh keys...\n"
/nix/store/bgjqh8q7l3zv4gsi1l2288m2fygy7j1x-sailfishos-sdk/libexec/qtcreator/merssh generatesshkeys $INSTALL_DIR/vmshare/ssh/private_keys/SailfishOS_Emulator/root $INSTALL_DIR/vmshare/ssh/private_keys/SailfishOS_Emulator/root.pub
/nix/store/bgjqh8q7l3zv4gsi1l2288m2fygy7j1x-sailfishos-sdk/libexec/qtcreator/merssh generatesshkeys $INSTALL_DIR/vmshare/ssh/private_keys/SailfishOS_Emulator/nemo $INSTALL_DIR/vmshare/ssh/private_keys/SailfishOS_Emulator/nemo.pub
echo "Generating mersdk ssh keys...\n"
/nix/store/bgjqh8q7l3zv4gsi1l2288m2fygy7j1x-sailfishos-sdk/libexec/qtcreator/merssh generatesshkeys $INSTALL_DIR/vmshare/ssh/private_keys/engine/root $INSTALL_DIR/vmshare/ssh/private_keys/engine/root.pub
/nix/store/bgjqh8q7l3zv4gsi1l2288m2fygy7j1x-sailfishos-sdk/libexec/qtcreator/merssh generatesshkeys $INSTALL_DIR/vmshare/ssh/private_keys/engine/mersdk $INSTALL_DIR/vmshare/ssh/private_keys/engine/mersdk.pub
echo "Creating emulator devices...\n"
/nix/store/bgjqh8q7l3zv4gsi1l2288m2fygy7j1x-sailfishos-sdk/libexec/qtcreator/sdktool addDev --id SailfishOS Emulator --name Sailfish OS Emulator --osType Mer.Device.Type --origin 1 --sdkProvided true --type 1 --host 127.0.0.1 --sshPort 2223 --uname nemo --authentication 1 --keyFile $INSTALL_DIR/vmshare/ssh/private_keys/SailfishOS_Emulator/nemo --timeout 30 --freePorts 10000-10019 --version 5 --virtualMachine QString:Sailfish OS Emulator --merMac QString:08:00:5A:11:00:01 --merSubnet QString:10:220:220 --merSharedSsh QString:$INSTALL_DIR/emulator/1/ssh --merSharedConfig QString:$INSTALL_DIR/vmshare --merDeviceModel QString:Xperia X MER_DEVICE_VIEW_SCALED bool:true
/nix/store/bgjqh8q7l3zv4gsi1l2288m2fygy7j1x-sailfishos-sdk/libexec/qtcreator/sdktool addMerDeviceModel --name Xperia X --hres-px 1080 --vres-px 1920 --hsize-mm 63 --vsize-mm 111 --dconf-db [desktop/sailfish/silica] theme_pixel_ratio=1.75 theme_icon_subdir='z1.75' icon_size_launcher=172
/nix/store/bgjqh8q7l3zv4gsi1l2288m2fygy7j1x-sailfishos-sdk/libexec/qtcreator/sdktool addMerSdk --installdir $INSTALL_DIR --vm-name Sailfish OS Build Engine --version 4 --autodetected true --shared-home $HOME --shared-targets $INSTALL_DIR/mersdk/targets --shared-ssh $INSTALL_DIR/mersdk/ssh --shared-config $INSTALL_DIR/vmshare --shared-src $HOME/development/sailfish-dev --host 127.0.0.1 --username mersdk --private-key-file $INSTALL_DIR/vmshare/ssh/private_keys/engine/mersdk --ssh-port 2222 --www-port 8080 --headless
