#!/usr/bin/env bash

MPROJECTS=(mupen64plus-core mupen64plus-input-sdl mupen64plus-audio-sdl mupen64plus-rsp-cxd4 mupen64plus-rsp-hle mupen64plus-gui angrylion-rdp-plus GLideN64 release)

for p in "${MPROJECTS[@]}"
do
  rm -rf $p
done
