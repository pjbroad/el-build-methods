#! /usr/bin/env bash

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
	echo "$(basename $0) <rel | dev> [<make options e.g. VERBOSE=1>]"
	exit
fi
buildtype=$1
shift

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
cp -p \
${MSYSTEM_PREFIX}/bin/libiconv-2.dll \
${MSYSTEM_PREFIX}/bin/libjpeg-8.dll \
${MSYSTEM_PREFIX}/bin/liblzma-5.dll \
${MSYSTEM_PREFIX}/bin/libopenal-1.dll \
${MSYSTEM_PREFIX}/bin/libpng16-16.dll \
${MSYSTEM_PREFIX}/bin/libstdc++-6.dll \
${MSYSTEM_PREFIX}/bin/libtiff-5.dll \
${MSYSTEM_PREFIX}/bin/libwebp-7.dll \
${MSYSTEM_PREFIX}/bin/libwinpthread-1.dll \
${MSYSTEM_PREFIX}/bin/libxml2-2.dll \
${MSYSTEM_PREFIX}/bin/libzstd.dll \
${MSYSTEM_PREFIX}/bin/SDL2.dll \
${MSYSTEM_PREFIX}/bin/SDL2_image.dll \
${MSYSTEM_PREFIX}/bin/SDL2_net.dll \
${MSYSTEM_PREFIX}/bin/zlib1.dll \
${MSYSTEM_PREFIX}/bin/libogg-0.dll \
${MSYSTEM_PREFIX}/bin/libvorbis-0.dll \
${MSYSTEM_PREFIX}/bin/libvorbisfile-3.dll \
${PACKAGELOCAL}/bin/libcal3d-12.dll \
.
if [ "$MSYSTEM" = "MINGW32" ]
then
	cp -p ${MSYSTEM_PREFIX}/bin/libgcc_s_dw2-1.dll .
elif [ "$MSYSTEM" = "MINGW64" ]
then
	cp -p ${MSYSTEM_PREFIX}/bin/libgcc_s_seh-1.dll .
fi

# zip up the directory of files
cd ${CLIENTBASE}/${ZIPPREFIX}-${BUILDTARGET}-${buildtype}
target_zip="../${ZIPPREFIX}-${BUILDTARGET}-${buildtype}-${DATETAG}.zip"
rm -f $target_zip
zip -rq $target_zip .
pwd
ls -lh $target_zip
