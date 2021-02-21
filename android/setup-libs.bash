#! /usr/bin/env bash

#       Copyright 2021 Paul Broadhead
#       Contact: pjbroad@twinmoons.org.uk
#
#       This file is part of el-build-methods:
#       https://github.com/pjbroad/el-build-methods
#
#       el-build-methods is free software: you can redistribute it and/or modify
#       it under the terms of the GNU General Public License as published by
#       the Free Software Foundation, either version 3 of the License, or
#       (at your option) any later version.
#
#       el-build-methods is distributed in the hope that it will be useful,
#       but WITHOUT ANY WARRANTY; without even the implied warranty of
#       MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#       GNU General Public License for more details.
#
#       You should have received a copy of the GNU General Public License
#       along with el-build-methods.  If not, see <http://www.gnu.org/licenses/>.

set -e

for arg in $*
do
	case $arg in
		"--help")
			echo "$(basename $0) [--clean]"
			exit 0
			;;
		"--clean")
			clean_libs=true
			echo "Removing Libs..."
			;;
	esac
done

cd $(dirname $0)

# Setup for configure using NDK
#
if [ -z "$clean_libs" ]
then
	if [ -z "$ANDROID_HOME" ]
	then
		echo "ANDROID_HOME not set"
		exit
	fi

	NDK_ROOT=$ANDROID_HOME/ndk-bundle
	API_LEVEL=19
	SYSROOT=$NDK_ROOT/platforms/android-$API_LEVEL/arch-arm
	export CC="$NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin/armv7a-linux-androideabi${API_LEVEL}-clang"
	export CFLAGS="$($NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-config --cflags)"
	export LDFLAGS="$($NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-config --ldflags)"
fi


# path to java files from SDL2
libsdlappdir=$(pwd)/src/org/libsdl/app
cd jni
basedir=$(pwd)
libdir=libsrc


# libxml2
#
cd $basedir
version="2.9.10"
rm -rf ${libdir}/libxml2-${version}/
rm -f xml2
if [ -z "$clean_libs" ]
then
	cd ${libdir}/
	[ ! -r libxml2-${version}.tar.gz ] && wget ftp://xmlsoft.org/libxml2/libxml2-${version}.tar.gz
	tar xfz libxml2-${version}.tar.gz
	cd ..
	ln -s ${libdir}/libxml2-${version} xml2
	cp -p ${libdir}/xml2-Android.mk xml2/Android.mk
	cd xml2
	./configure --host=arm-linux-gnueabi --disable-static --enable-shared \
		--with-lzma=no --with-zlib=no --with-html=no --with-http=no \
		--with-ftp=no --disable-dependency-tracking
	cd ..
fi


# cal3d
#
cd $basedir
version="0.11.0"
rm -rf ${libdir}/cal3d-${version}/
rm -f cal3d
if [ -z "$clean_libs" ]
then
	cd ${libdir}/
	[ ! -r cal3d-${version}.tar.gz ] && wget https://github.com/raduprv/Eternal-Lands/releases/download/1.9.5.2/cal3d-${version}.tar.gz
	[ ! -r cal3d-${version}-patch ] && wget https://github.com/raduprv/Eternal-Lands/releases/download/1.9.5.2/cal3d-${version}-patch
	tar xfz cal3d-${version}.tar.gz
	cd ..
	ln -s ${libdir}/cal3d-${version} cal3d
	cp -p ${libdir}/cal3d-Android.mk cal3d/Android.mk
	cp -p ${libdir}/cal3d-${version}-patch cal3d
	cd cal3d/
	patch -p1 < cal3d-${version}-patch
	sed -i 's|CAL_COREMOPRHANIMATION_H|CAL_COREMORPHANIMATION_H|g' src/cal3d/coremorphanimation.h
	cd ..
fi


# glu
#
cd $basedir
version="9.0.1"
rm -rf ${libdir}/glu-${version}/
rm -f glu
if [ -z "$clean_libs" ]
then
	cd ${libdir}/
	[ ! -r glu-${version}.tar.gz ] && wget https://mesa.freedesktop.org/archive/glu/glu-${version}.tar.gz
	tar xfz glu-${version}.tar.gz
	cd ..
	ln -s ${libdir}/glu-${version} glu
	cp -p ${libdir}/glu-Android.mk glu/Android.mk
fi


# iconv
# 
cd $basedir
version="1.16"
rm -rf ${libdir}/libiconv-${version}/
rm -f iconv
if [ -z "$clean_libs" ]
then
	cd ${libdir}/
	[ ! -r libiconv-${version}.tar.gz ] && wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-${version}.tar.gz
	tar xfz libiconv-${version}.tar.gz 
	cd ..
	ln -s ${libdir}/libiconv-${version} iconv
	cp -p ${libdir}/iconv-Android.mk iconv/Android.mk
	cd iconv
	./configure --host=arm-linux-gnueabi --disable-static --enable-shared
	cd ..
fi


# SDL2
#
cd $basedir
version="2.0.14"
rm -rf ${libdir}/SDL2-${version}/
rm -f SDL2
rm -f ${libsdlappdir}/*.java
[ -d ${libsdlappdir} ] && rmdir --ignore-fail-on-non-empty --parents ${libsdlappdir}/
if [ -z "$clean_libs" ]
then
	cd ${libdir}/
	[ ! -r SDL2-${version}.tar.gz ] && wget https://www.libsdl.org/release/SDL2-${version}.tar.gz
	tar xfz SDL2-${version}.tar.gz
	cd ..
	ln -s ${libdir}/SDL2-${version} SDL2
	sed -i 's|-lGLESv2||g' SDL2/Android.mk
	sed -i 's|#define SDL_VIDEO_OPENGL_ES2|//#define SDL_VIDEO_OPENGL_ES2|g' SDL2/include/SDL_config_android.h
	sed -i 's|#define SDL_VIDEO_RENDER_OGL_ES2|//#define SDL_VIDEO_RENDER_OGL_ES2|g' SDL2/include/SDL_config_android.h
	cp -p ${libdir}/SDLActivity.java.patch SDL2/android-project/app/src/main/java/org/libsdl/app/
	cd SDL2/android-project/app/src/main/java/org/libsdl/app/
	patch -p0 < SDLActivity.java.patch
	mkdir -p ${libsdlappdir}
	cp -p *.java ${libsdlappdir}/
	cd $basedir
fi


# SDL2_image
#
cd $basedir
version="2.0.5"
rm -rf ${libdir}/SDL2_image-${version}/
rm -f SDL2_image
if [ -z "$clean_libs" ]
then
	cd ${libdir}/
	[ ! -r SDL2_image-${version}.tar.gz ] && wget https://www.libsdl.org/projects/SDL_image/release/SDL2_image-${version}.tar.gz
	tar xfz SDL2_image-${version}.tar.gz
	cd ..
	ln -s ${libdir}/SDL2_image-${version} SDL2_image
fi


# SDL2_net
#
cd $basedir
version="2.0.1"
rm -rf ${libdir}/SDL2_net-${version}/
rm -f SDL2_net
if [ -z "$clean_libs" ]
then
	cd ${libdir}/
	[ ! -r SDL2_net-${version}.tar.gz ] && wget https://www.libsdl.org/projects/SDL_net/release/SDL2_net-2.0.1.tar.gz
	tar xfz SDL2_net-${version}.tar.gz
	cd ..
	ln -s ${libdir}/SDL2_net-${version} SDL2_net
fi


# SDL2_ttf
#
cd $basedir
version="2.0.15"
rm -rf ${libdir}/SDL2_ttf-${version}/
rm -f SDL2_ttf
if [ -z "$clean_libs" ]
then
	cd ${libdir}/
	[ ! -r SDL2_ttf-${version}.tar.gz ] && wget https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-${version}.tar.gz
	tar xfz SDL2_ttf-${version}.tar.gz
	cd ..
	ln -s ${libdir}/SDL2_ttf-${version} SDL2_ttf
fi


# gl4es
#
cd $basedir
rm -rf gl4es
if [ -z "$clean_libs" ]
then
	git clone https://github.com/ptitSeb/gl4es.git
	cd gl4es/
	git checkout --quiet v0.9.5
	cp -p ../${libdir}/gl4es-0.9.5-patch .
	cp -p ../${libdir}/gl4esinit.h include/gl4esinit.h
	patch -p1 < gl4es-0.9.5-patch
	cd ..
fi
