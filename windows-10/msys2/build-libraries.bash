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

set -e

if [ -z "$MINGW_PACKAGE_PREFIX" ]
then
	echo "Run from MSYS 32/64 terminal"
	exit
fi

source $(dirname $0)/common.bash

mkdir -p ${PACKAGEBASE}

cd ${PACKAGEBASE}
if [ ! -d "cal3d-0.11.0" ]
then
	wget https://github.com/raduprv/Eternal-Lands/releases/download/1.9.5.2/cal3d-0.11.0.tar.gz
	wget https://github.com/raduprv/Eternal-Lands/releases/download/1.9.5.2/cal3d-0.11.0-patch
	tar xfz cal3d-0.11.0.tar.gz
	cd cal3d-0.11.0/
	patch -p1 < ../cal3d-0.11.0-patch
	export "CFLAGS=-I${PACKAGELOCAL}/include -O3"
	export "CPPFLAGS=-I${PACKAGELOCAL}/include -O3"
	export "LDFLAGS=-L${PACKAGELOCAL}/lib"
	export "PKG_CONFIG_PATH=${PACKAGELOCAL}/lib/pkgconfig"
	./configure --prefix=${PACKAGELOCAL} && make && make install-strip
else
	echo "cal3d-0.11.0 exists"
fi
