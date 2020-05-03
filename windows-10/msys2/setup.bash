#! /usr/bin/env bash

#	Copyright 2020 Paul Broadhead
#	Contact: pjbroad@twinmoons.org.uk
#
#	This file is part of el-build-methods:
#	https://github.com/pjbroad/el-build-methods
#
#	el-build-methods is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	(at your option) any later version.
#
#	el-build-methods is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
#	You should have received a copy of the GNU General Public License
#	along with el-build-methods.  If not, see <http://www.gnu.org/licenses/>.

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


