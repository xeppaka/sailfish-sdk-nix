#!/usr/bin/env bash

INSTALL_DIR=$1
mkdir -p $INSTALL_DIR
printf "Copying SDK tools to $INSTALL_DIR...\n"
cp -R @out@/bin @out@/lib @out@/libexec @out@/qmllive-examples @out@/share $INSTALL_DIR
chmod -R +w $INSTALL_DIR/share
mkdir -p $INSTALL_DIR/vmshare
mkdir -p $INSTALL_DIR/vmshare/ssh/private_keys/SailfishOS_Emulator
mkdir -p $INSTALL_DIR/vmshare/ssh/private_keys/engine
prinf "Extracting emulator...\n"
@packageExtractor@/bin/7z -o$INSTALL_DIR x @emulator@
prinf "Extracting mersdk...\n"
@packageExtractor@/bin/7z -o$INSTALL_DIR x @mersdk@
printf "Generating emulator ssh keys...\n"
$INSTALL_DIR/libexec/qtcreator/merssh generatesshkeys $INSTALL_DIR/vmshare/ssh/private_keys/SailfishOS_Emulator/root $INSTALL_DIR/vmshare/ssh/private_keys/SailfishOS_Emulator/root.pub
$INSTALL_DIR/libexec/qtcreator/merssh generatesshkeys $INSTALL_DIR/vmshare/ssh/private_keys/SailfishOS_Emulator/nemo $INSTALL_DIR/vmshare/ssh/private_keys/SailfishOS_Emulator/nemo.pub
printf "Generating mersdk ssh keys...\n"
$INSTALL_DIR/libexec/qtcreator/merssh generatesshkeys $INSTALL_DIR/vmshare/ssh/private_keys/engine/root $INSTALL_DIR/vmshare/ssh/private_keys/engine/root.pub
$INSTALL_DIR/libexec/qtcreator/merssh generatesshkeys $INSTALL_DIR/vmshare/ssh/private_keys/engine/mersdk $INSTALL_DIR/vmshare/ssh/private_keys/engine/mersdk.pub
printf "Deleting emulator devices...\n"
rm -f $INSTALL_DIR/share/qtcreator/SailfishOS-SDK/qtcreator/*.xml
printf "Creating emulator devices...\n"
$INSTALL_DIR/libexec/qtcreator/sdktool addDev --id "SailfishOS Emulator" --name "Sailfish OS Emulator" --osType "Mer.Device.Type" --origin 1 --sdkProvided true --type 1 --host "127.0.0.1" --sshPort 2223 --uname nemo --authentication 1 --keyFile "$INSTALL_DIR/vmshare/ssh/private_keys/SailfishOS_Emulator/nemo" --timeout 30 --freePorts "10000-10019" --version 5 --virtualMachine "QString:Sailfish OS Emulator" --merMac "QString:08:00:5A:11:00:01" --merSubnet "QString:10:220:220" --merSharedSsh "QString:$INSTALL_DIR/emulator/1/ssh" --merSharedConfig "QString:$INSTALL_DIR/vmshare" --merDeviceModel "QString:Xperia X" MER_DEVICE_VIEW_SCALED "bool:true"
$INSTALL_DIR/libexec/qtcreator/sdktool addMerDeviceModel --name "Xperia X" --hres-px 1080 --vres-px 1920 --hsize-mm 63 --vsize-mm 111 --dconf-db [desktop/sailfish/silica] theme_pixel_ratio=1.75 theme_icon_subdir='z1.75' icon_size_launcher=172
$INSTALL_DIR/libexec/qtcreator/sdktool addMerSdk --installdir $INSTALL_DIR --vm-name "Sailfish OS Build Engine" --version 4 --autodetected true --shared-home $HOME --shared-targets "$INSTALL_DIR/mersdk/targets" --shared-ssh "$INSTALL_DIR/mersdk/ssh" --shared-config "$INSTALL_DIR/vmshare" --shared-src "$HOME/development/sailfish-dev" --host "127.0.0.1" --username mersdk --private-key-file "$INSTALL_DIR/vmshare/ssh/private_keys/engine/mersdk" --ssh-port 2222 --www-port 8080 --headless
printf "Deleting MER targets...\n"
rm -f $INSTALL_DIR/mersdk/targets/targets.xml
printf "Creating MER targets...\n"
$INSTALL_DIR/libexec/qtcreator/sdktool addMerTarget --mer-targets-dir "$INSTALL_DIR/mersdk/targets" --target-name "SailfishOS-3.0.1.11-i486" --qmake-query "$INSTALL_DIR/mersdk/dumps/qmake.query.SailfishOS-3.0.1.11-i486" --gcc-dumpmachine "$INSTALL_DIR/mersdk/dumps/gcc.dumpmachine.SailfishOS-3.0.1.11-i486"
$INSTALL_DIR/libexec/qtcreator/sdktool addMerTarget --mer-targets-dir "$INSTALL_DIR/mersdk/targets" --target-name "SailfishOS-3.0.1.11-armv7hl" --qmake-query "$INSTALL_DIR/mersdk/dumps/qmake.query.SailfishOS-3.0.1.11-armv7hl" --gcc-dumpmachine "$INSTALL_DIR/mersdk/dumps/gcc.dumpmachine.SailfishOS-3.0.1.11-armv7hl"
printf "Creating Sailfish OS virtual machine...\n"
./create-vbox-emulator.sh $INSTALL_DIR
printf "Creating Sailfish OS build engine virtual machine...\n"
./create-vbox-build-engine.sh $INSTALL_DIR
