#!/usr/bin/env bash

set -e

#remove that for a build server
export CFLAGS+="-march=native -mtune=native"
export CXXFLAGS+="$CFLAGS"

STARTDIR=`pwd`
TARGETDIR="$STARTDIR/release"
mkdir -p release

MPROJECTS=(mupen64plus-core mupen64plus-input-sdl mupen64plus-audio-sdl mupen64plus-rsp-cxd4 mupen64plus-rsp-hle)

for p in "${MPROJECTS[@]}"
do
  git clone https://github.com/mupen64plus/$p || true
  cd $p
  git pull
  cd projects/unix
  make clean
  make -j`nproc` all V=1 SHAREDIR="."
  mv *.so* "$TARGETDIR"
  cd "$STARTDIR"
done

cp mupen64plus-input-sdl/data/* "$TARGETDIR"
cp mupen64plus-core/data/* "$TARGETDIR"

git clone https://github.com/m64p/mupen64plus-gui.git || true
cd mupen64plus-gui
git pull
mkdir -p build
cd build
qmake ../mupen64plus-gui.pro
make clean
make -j`nproc`
mv mupen64plus-gui "$TARGETDIR"

cd "$STARTDIR"

git clone https://github.com/ata4/angrylion-rdp-plus.git || true
cd angrylion-rdp-plus
git pull
mkdir -p build
cd build
cmake ..
make clean
make -j`nproc` VERBOSE=1
mv *.so* "$TARGETDIR"
cd "$STARTDIR"

git clone https://github.com/gonetz/GLideN64.git || true
cd GLideN64
git pull
sh src/getRevision.sh
cd projects/cmake/
cmake -DVEC4_OPT=On -DMUPENPLUSAPI=On -DUSE_SYSTEM_LIBS=On ../../src/
make clean
make -j`nproc` VERBOSE=1
mv plugin/Release/*.so* "$TARGETDIR"
cp ../../ini/* "$TARGETDIR"
