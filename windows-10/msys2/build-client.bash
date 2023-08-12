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

# get the configuation variables
source $(dirname $0)/common.bash

# show help if we are missing required parameters
if [ "$1" != "rel" -a "$1" != "dev" ]
then
	echo "$(basename $0) <rel | dev> [clean] [<make options e.g. VERBOSE=1>]"
	exit
fi
buildtype=$1
shift

# If clean specified, we delete the build direcotry
if [ "$1" = "clean" ]
then
	echo "Removing build directory"
	rm -rf ${CLIENTBASE}/${REPONAME}/${BUILDTARGET}-${buildtype}/
	echo "Removing ${CLIENTBASE}/${ZIPPREFIX}-${BUILDTARGET}-${buildtype}"
	rm -rf "${CLIENTBASE}/${ZIPPREFIX}-${BUILDTARGET}-${buildtype}"
	exit
fi

# if the git repo does not exist, clone it
# use the configured name and branch
if [ ! -d "${CLIENTBASE}/${REPONAME}" ]
then
	mkdir -p ${CLIENTBASE}
	cd ${CLIENTBASE}
	git clone ${REPOURL} ${REPONAME}
	cd ${REPONAME}
	git checkout -q ${REPOBRANCH}
fi

cd ${CLIENTBASE}/${REPONAME}

# set the build rel/dev specific options
if [ "$buildtype" = "dev" ]
then
	EXTRACMAKE="${EXTRACMAKE} -DVERSION_PREFIX=${BASEVERSION} -DCMAKE_BUILD_TYPE=debug"
fi

# if the build directory does not exist, create it and
# run the cmake part of the build.  A clean or githead
# will remove the directory
if  [ ! -d "${BUILDTARGET}-${buildtype}" ]
then
	mkdir ${BUILDTARGET}-${buildtype}
	cd ${BUILDTARGET}-${buildtype}
	DATETAG="$(date +"%Y%m%d.%H.%M")"
	echo -n "$DATETAG" > datetag
	cmake -G "MSYS Makefiles" \
		-DCMAKE_INCLUDE_PATH="${PACKAGELOCAL}/include" \
		-DCMAKE_LIBRARY_PATH="${PACKAGELOCAL}/lib" \
		${EXTRACMAKE} \
	..
else
	echo "cmake build dir exists"
	DATETAG="$(cat ${BUILDTARGET}-${buildtype}/datetag)"
fi

# make the client
numproc="$(nproc)"
[ -z "$numproc" ] && numproc="2"
cd ${CLIENTBASE}/${REPONAME}/${BUILDTARGET}-${buildtype}
make -j $numproc $*

# create the taget directory and copy built exe and the required DLLs
cd ${CLIENTBASE}
mkdir -p ${ZIPPREFIX}-${BUILDTARGET}-${buildtype} && cd ${ZIPPREFIX}-${BUILDTARGET}-${buildtype}
cp -p ../${REPONAME}/${BUILDTARGET}-${buildtype}/${EXENAME} .
cp -p ${PACKAGELOCAL}/bin/libcal3d-12.dll .
for i in $(ldd el.exe | grep '/mingw' | awk '{print $3}')
do
	cp -p $i .
done

# zip up the directory of files
cd ${CLIENTBASE}/${ZIPPREFIX}-${BUILDTARGET}-${buildtype}
target_zip="../${ZIPPREFIX}-${BUILDTARGET}-${buildtype}-${DATETAG}.zip"
rm -f $target_zip
zip -rq $target_zip .
pwd
ls -lh $target_zip
