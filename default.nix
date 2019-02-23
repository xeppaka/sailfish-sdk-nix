with (import <nixpkgs> {});

#{ stdenv, fetchurl, patchelf, glibc, makeWrapper, autoPatchelfHook, glib, openssl, gcc,
#qt5, gtk2, pango, p7zip }:

let
  srcs = {
    x86_64-linux = {
      qtcreator = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/linux-64/org.merproject.qtcreator/4.7.2-2qtcreator.7z";
        sha1 = "e64c8c684899c024cc6395962c9094ed77ade915";
      };
      qmllive = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/linux-64/org.merproject.qmllive/0.1.0-9qmllive.7z";
        sha1 = "1069c13f3f6b1a8a451c11a0a02308c339eac14b";
      };
      sdkmaintenance = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/linux-64/org.merproject.maintenance/1.5.28-29sdkmaintenance.7z";
        sha1 = "11189381fb51468dfba218c77d63a1ffc203cd0e";
      };
      gdb = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/linux-64/org.merproject.tools.gdb/7.6.2-3gdb.7z";
        sha1 = "cb40b7a9371b5cbbc673e5a2176e396655daa555";
      };
      emulator = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/common/org.merproject.emulator/2019.01.04-1emulator.7z";
        sha1 = "197d719d1787807d7dc6babbcb62ed8e902167a3";
      };
      mersdk = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/common/org.merproject.mersdk/2019.01.04-1mersdk.7z";
        sha1 = "8a0b2775d5b58ab66b8faa1602f7107df6e44a48";
      };
      sailfish-ambience-template = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/common/org.merproject.examples.sailfishtemplate/2019.01.16-1sailfish-ambience-template.7z";
        sha1 = "fb5cc7add4f3d3b4b7152ddcf7b0b4ff5f19db51";
      };
      sailfish-qml-template = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/common/org.merproject.examples.sailfishtemplate/2019.01.16-1sailfish-qml-template.7z";
        sha1 = "3dadc86c1094e85b086ddde1cb576866ba50200e";
      };
      sailfish-template = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/common/org.merproject.examples.sailfishtemplate/2019.01.16-1sailfish-template.7z";
        sha1 = "46b7966165e0637c5033616c482fad484fc49d9c";
      };
    };
  };
in stdenv.mkDerivation {
  name = "sailfish-sdk";

  srcs = [
    srcs.${stdenv.hostPlatform.system}.qtcreator
    srcs.${stdenv.hostPlatform.system}.qmllive
    srcs.${stdenv.hostPlatform.system}.sdkmaintenance
    srcs.${stdenv.hostPlatform.system}.gdb
    srcs.${stdenv.hostPlatform.system}.sailfish-ambience-template
    srcs.${stdenv.hostPlatform.system}.sailfish-qml-template
    srcs.${stdenv.hostPlatform.system}.sailfish-template
    ./scripts
  ];
  buildInputs = [ qt5.qtbase qt5.qtxmlpatterns qt5.qtquickcontrols2 qt5.qttools qt5.qtwebkit gtk3 gcc pango ncurses5 wayland xorg.libXtst ];
  nativeBuildInputs = [ autoPatchelfHook p7zip ];
  #runtimeDependencies = openssl.out;
  dontPatchELF = true;
  dontStrip = true;
  sourceRoot = "sailfish-sdk";
  emulator = srcs.${stdenv.hostPlatform.system}.emulator;
  mersdk = srcs.${stdenv.hostPlatform.system}.mersdk;
  packageExtractor = p7zip;

  unpackCmd = ''
    7z -osailfish-sdk x $curSrc
  '';

  buildPhase = ''
    cp ../scripts/install-sdk.sh .
    substituteAllInPlace install-sdk.sh
  '';

  installPhase = ''
    mkdir -p $out
    cp -R bin lib libexec qmllive-examples share install-sdk.sh $out
    cp -R sailfishos-ambience sailfishos-qtquick2app sailfishos-qtquick2app-qmlonly $out/share/qtcreator/templates/wizards
    runHook postInstall
  '';

  postInstall = ''
    chmod +x $out/install-sdk.sh
    rm $out/bin/python/lib/python2.7/config/python.o
  '';

  preFixup = ''
    patchelf --remove-rpath $out/qmllive-examples/app/app
    patchelf --remove-rpath $out/lib/libqmllive.so.1.0.0
    patchelf --remove-rpath $out/bin/qmlliveruntime
    patchelf --remove-rpath $out/bin/qmllivebench
  '';
}
