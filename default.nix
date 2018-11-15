with (import <nixpkgs> {});

#{ stdenv, fetchurl, patchelf, glibc, makeWrapper, autoPatchelfHook, glib, openssl, gcc,
#qt5, gtk2, pango, p7zip }:

let
  qtcreator-version = "4.6.2-1";
  qmllive-version = "0.1.0-8";
  sdkmaintenance-version = "1.5.28-27";
  gdb-version = "7.6.2-2";
  emulator-version = "2018.08.31-1";
  mersdk-version = "2018.08.31-1";
  sailfish-ambience-template-version = "2018.07.04-1";
  sailfish-qml-template-version = "2018.07.04-1";
  sailfish-template-version = "2018.07.04-1";
  srcs = {
    x86_64-linux = {
      qtcreator = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/linux-64/org.merproject.qtcreator/${qtcreator-version}qtcreator.7z";
        sha1 = "a3603776eabc4dbb77b45b9d5128e443f1810379";
      };
      qmllive = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/linux-64/org.merproject.qmllive/${qmllive-version}qmllive.7z";
        sha1 = "f1a5c6de4dd0ff3f25bf7c868c1fb42ec7edf7bd";
      };
      sdkmaintenance = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/linux-64/org.merproject.maintenance/${sdkmaintenance-version}sdkmaintenance.7z";
        sha1 = "aa6d9598e69e936ffb29d4e99a616be007b4cbf5";
      };
      gdb = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/linux-64/org.merproject.tools.gdb/${gdb-version}gdb.7z";
        sha1 = "940df3bf6460d99b78e6391e35f2b8b1517dec71";
      };
      emulator = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/common/org.merproject.emulator/${emulator-version}emulator.7z";
        sha1 = "a5fba28ca037b93339f0ed745d27fbf8cb291ca1";
      };
      mersdk = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/common/org.merproject.mersdk/${mersdk-version}mersdk.7z";
        sha1 = "b11868b606d9aa13fb3895974989737d915e2a37";
      };
      sailfish-ambience-template = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/common/org.merproject.examples.sailfishtemplate/${sailfish-ambience-template-version}sailfish-ambience-template.7z";
        sha1 = "1cc822bece5ede78b1d409a2314c66443682de5c";
      };
      sailfish-qml-template = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/common/org.merproject.examples.sailfishtemplate/${sailfish-qml-template-version}sailfish-qml-template.7z";
        sha1 = "de4caeae250968585645e486d103af71c5f616ef";
      };
      sailfish-template = fetchurl {
        url = "http://releases.sailfishos.org/sdk/repository-ea/common/org.merproject.examples.sailfishtemplate/${sailfish-template-version}sailfish-template.7z";
        sha1 = "ce7579be6654e6d5a9a6d545a2a588e2fb93c5d5";
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
    srcs.${stdenv.hostPlatform.system}.emulator
    srcs.${stdenv.hostPlatform.system}.mersdk
    srcs.${stdenv.hostPlatform.system}.sailfish-ambience-template
    srcs.${stdenv.hostPlatform.system}.sailfish-qml-template
    srcs.${stdenv.hostPlatform.system}.sailfish-template
  ];
  buildInputs = [ qt5.qtbase qt5.qtxmlpatterns qt5.qtquickcontrols2 qt5.qttools qt5.qtwebkit gtk2 gcc pango ncurses5 ];
  nativeBuildInputs = [ autoPatchelfHook p7zip ];
  #runtimeDependencies = openssl.out;
  dontPatchELF = true;
  dontStrip = true;
  dontBuild = true;

  unpackCmd = ''
    7z -osailfish-sdk x $curSrc
  '';

  installPhase = ''
    mkdir -p $out
    cp -R bin emulator lib libexec  mersdk qmllive-examples share $out
    cp -R sailfishos-ambience sailfishos-qtquick2app sailfishos-qtquick2app-qmlonly $out/share/qtcreator/templates/wizards
    runHook postInstall
  '';

  postInstall = ''
    rm $out/bin/python/lib/python2.7/config/python.o
  '';

  preFixup = ''
    patchelf --remove-rpath $out/qmllive-examples/app/app
    patchelf --remove-rpath $out/lib/libqmllive.so.1.0.0
    patchelf --remove-rpath $out/bin/qmlliveruntime
    patchelf --remove-rpath $out/bin/qmllivebench
  '';
}
