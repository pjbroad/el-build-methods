#! /usr/bin/env bash

if [ -z "$MINGW_PACKAGE_PREFIX" ]
then
	echo "Run from MSYS 32/64 terminal"
	exit
fi

pacman -Syuu

pacman -S --needed \
	git \
	zip \
	unzip \
	wget \
	base-devel \
	msys2-devel \
	${MINGW_PACKAGE_PREFIX}-toolchain \
	${MINGW_PACKAGE_PREFIX}-cmake

pacman -S --needed \
	${MINGW_PACKAGE_PREFIX}-mesa \
	${MINGW_PACKAGE_PREFIX}-openal \
	${MINGW_PACKAGE_PREFIX}-libxml2 \
	${MINGW_PACKAGE_PREFIX}-SDL2 \
	${MINGW_PACKAGE_PREFIX}-SDL2_image \
	${MINGW_PACKAGE_PREFIX}-SDL2_net \
	${MINGW_PACKAGE_PREFIX}-libvorbis \
	${MINGW_PACKAGE_PREFIX}-libogg \
	${MINGW_PACKAGE_PREFIX}-nlohmann-json


