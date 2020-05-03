#! /usr/bin/env bash

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
