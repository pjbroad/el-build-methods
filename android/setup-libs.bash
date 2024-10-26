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
	export PATH=$NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin:$PATH
fi


# path to java files from SDL2
libsdlappdir=$(pwd)/src/org/libsdl/app
cd jni
basedir=$(pwd)
libdir=libsrc

libxml2_version="2.9.14"
cal3d_version="0.11.0"
glu_version="9.0.3"
libiconv_version="1.17"
SDL2_version="2.26.5"
SDL2_image_version="2.8.2"
SDL2_net_version="2.2.0"
SDL2_ttf_version="2.22.0"
gl4es_version="0.9.5"
openssl_version="1.1.1w"

# libxml2
#
if [ -n "${libxml2_version}" ]
then
	cd $basedir
	rm -rf ${libdir}/libxml2-${libxml2_version}/
	rm -f xml2
	if [ -z "$clean_libs" ]
	then
		cd ${libdir}/
		[ ! -r libxml2-${libxml2_version}.tar.xz ] && wget https://download.gnome.org/sources/libxml2/$(echo "$libxml2_version" | cut -d "." -f1-2)/libxml2-${libxml2_version}.tar.xz
		tar xf libxml2-${libxml2_version}.tar.xz --xz
		cd ..
		ln -s ${libdir}/libxml2-${libxml2_version} xml2
		cp -p ${libdir}/xml2-Android.mk xml2/Android.mk
		cd xml2
		./configure --host=arm-linux-gnueabi --disable-static --enable-shared \
			--with-lzma=no --with-zlib=no --with-html=no --with-http=no \
			--with-ftp=no --disable-dependency-tracking
		cd ..
	fi
fi


# cal3d
#
if [ -n "${cal3d_version}" ]
then
	cd $basedir
	rm -rf ${libdir}/cal3d-${cal3d_version}/
	rm -f cal3d
	if [ -z "$clean_libs" ]
	then
		cd ${libdir}/
		[ ! -r cal3d-${cal3d_version}.tar.gz ] && wget https://github.com/raduprv/Eternal-Lands/releases/download/1.9.5.2/cal3d-${cal3d_version}.tar.gz
		[ ! -r cal3d-${cal3d_version}-patch ] && wget https://github.com/raduprv/Eternal-Lands/releases/download/1.9.5.2/cal3d-${cal3d_version}-patch
		tar xfz cal3d-${cal3d_version}.tar.gz
		cd ..
		ln -s ${libdir}/cal3d-${cal3d_version} cal3d
		cp -p ${libdir}/cal3d-Android.mk cal3d/Android.mk
		cp -p ${libdir}/cal3d-${cal3d_version}-patch cal3d
		cd cal3d/
		patch -p1 < cal3d-${cal3d_version}-patch
		sed -i 's|CAL_COREMOPRHANIMATION_H|CAL_COREMORPHANIMATION_H|g' src/cal3d/coremorphanimation.h
		cd ..
	fi
fi


# glu
#
if [ -n "${glu_version}" ]
then
	cd $basedir
	rm -rf ${libdir}/glu-${glu_version}/
	rm -f glu
	if [ -z "$clean_libs" ]
	then
		cd ${libdir}/
		[ ! -r glu-${glu_version}.tar.xz ] && wget https://mesa.freedesktop.org/archive/glu/glu-${glu_version}.tar.xz
		tar xf glu-${glu_version}.tar.xz --xz
		cd ..
		ln -s ${libdir}/glu-${glu_version} glu
		cp -p ${libdir}/glu-Android.mk glu/Android.mk
	fi
fi


# iconv
#
if [ -n "${libiconv_version}" ]
then
	cd $basedir
	rm -rf ${libdir}/libiconv-${libiconv_version}/
	rm -f iconv
	if [ -z "$clean_libs" ]
	then
		cd ${libdir}/
		[ ! -r libiconv-${libiconv_version}.tar.gz ] && wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-${libiconv_version}.tar.gz
		tar xfz libiconv-${libiconv_version}.tar.gz
		cd ..
		ln -s ${libdir}/libiconv-${libiconv_version} iconv
		cp -p ${libdir}/iconv-Android.mk iconv/Android.mk
		cd iconv
		./configure --host=arm-linux-gnueabi --disable-static --enable-shared
		cd ..
	fi
fi


# SDL2
#
if [ -n "${SDL2_version}" ]
then
	cd $basedir
	rm -rf ${libdir}/SDL2-${SDL2_version}/
	rm -f SDL2
	rm -f ${libsdlappdir}/*.java
	[ -d ${libsdlappdir} ] && rmdir --ignore-fail-on-non-empty --parents ${libsdlappdir}/
	if [ -z "$clean_libs" ]
	then
		cd ${libdir}/
		[ ! -r SDL2-${SDL2_version}.tar.gz ] && wget https://www.libsdl.org/release/SDL2-${SDL2_version}.tar.gz
		tar xfz SDL2-${SDL2_version}.tar.gz
		cd ..
		ln -s ${libdir}/SDL2-${SDL2_version} SDL2
		sed -i 's|-lGLESv2||g' SDL2/Android.mk
		sed -i 's|#define SDL_VIDEO_OPENGL_ES2|//#define SDL_VIDEO_OPENGL_ES2|g' SDL2/include/SDL_config_android.h
		sed -i 's|#define SDL_VIDEO_RENDER_OGL_ES2|//#define SDL_VIDEO_RENDER_OGL_ES2|g' SDL2/include/SDL_config_android.h
		# diff -Naur SDLActivity.java.orginal SDLActivity.java > SDLActivity.java.patch
		mkdir -p ${libsdlappdir}
		cp -p SDL2/android-project/app/src/main/java/org/libsdl/app/*.java ${libsdlappdir}/
		cp -p ${libdir}/SDLActivity.java.patch ${libsdlappdir}/
		cd ${libsdlappdir}/
		patch -p0 < SDLActivity.java.patch
		rm -f SDLActivity.java.patch SDLActivity.java.orig
		cd $basedir
	fi
fi


# SDL2_image
#
if [ -n "${SDL2_image_version}" ]
then
	cd $basedir
	rm -rf ${libdir}/SDL2_image-${SDL2_image_version}/
	rm -f SDL2_image
	if [ -z "$clean_libs" ]
	then
		cd ${libdir}/
		[ ! -r SDL2_image-${SDL2_image_version}.tar.gz ] && wget https://www.libsdl.org/projects/SDL_image/release/SDL2_image-${SDL2_image_version}.tar.gz
		tar xfz SDL2_image-${SDL2_image_version}.tar.gz
		cd ..
		ln -s ${libdir}/SDL2_image-${SDL2_image_version} SDL2_image
	fi
fi


# SDL2_net
#
if [ -n "${SDL2_net_version}" ]
then
	cd $basedir
	rm -rf ${libdir}/SDL2_net-${SDL2_net_version}/
	rm -f SDL2_net
	if [ -z "$clean_libs" ]
	then
		cd ${libdir}/
		[ ! -r SDL2_net-${SDL2_net_version}.tar.gz ] && wget https://www.libsdl.org/projects/SDL_net/release/SDL2_net-${SDL2_net_version}.tar.gz
		tar xfz SDL2_net-${SDL2_net_version}.tar.gz
		cd ..
		ln -s ${libdir}/SDL2_net-${SDL2_net_version} SDL2_net
	fi
fi


# SDL2_ttf
#
if [ -n "${SDL2_ttf_version}" ]
then
	cd $basedir
	rm -rf ${libdir}/SDL2_ttf-${SDL2_ttf_version}/
	rm -f SDL2_ttf
	if [ -z "$clean_libs" ]
	then
		cd ${libdir}/
		[ ! -r SDL2_ttf-${SDL2_ttf_version}.tar.gz ] && wget https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-${SDL2_ttf_version}.tar.gz
		tar xfz SDL2_ttf-${SDL2_ttf_version}.tar.gz
		cd ..
		ln -s ${libdir}/SDL2_ttf-${SDL2_ttf_version} SDL2_ttf
	fi
fi


# gl4es
#
if [ -n "${gl4es_version}" ]
then
	cd $basedir
	rm -rf gl4es
	if [ -z "$clean_libs" ]
	then
		git clone https://github.com/ptitSeb/gl4es.git
		cd gl4es/
		git checkout --quiet "v${gl4es_version}"
		cp -p ../${libdir}/gl4es-${gl4es_version}-patch .
		cp -p ../${libdir}/gl4esinit.h include/gl4esinit.h
		patch -p1 < gl4es-${gl4es_version}-patch
		cd ..
	fi
fi

# openssl
#
if [ -n "${openssl_version}" ]
then
	cd $basedir
	rm -rf ${libdir}/openssl-${openssl_version}
	rm -f openssl
	if [ -z "$clean_libs" ]
	then
		SYSROOT=${NDK_ROOT}/platforms/android-${API_LEVEL}/arch-arm
		PLATFORM=android-arm

		cd ${libdir}/
		[ ! -r openssl-${openssl_version}.tar.gz ] && wget https://www.openssl.org/source/openssl-${openssl_version}.tar.gz
		tar xfz openssl-${openssl_version}.tar.gz
		cd ..
		ln -s ${libdir}/openssl-${openssl_version} openssl

		cp ${libdir}/openssl-android-config.mk openssl/android-config.mk
		cp ${libdir}/openssl-Android.mk openssl/Android.mk
		cp ${libdir}/openssl-crypto-Android.mk openssl/crypto/Android.mk
		cp ${libdir}/openssl-ssl-Android.mk openssl/ssl/Android.mk

		cd openssl

		# This may not be the way to go about it, but I don't know
		# how else to coax the Configure script into running
		ln -snf ${ANDROID_HOME}/platforms ${NDK_ROOT}/platforms
		ln -snf ${NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/sysroot ${SYSROOT}
		ANDROID_NDK_HOME=${NDK_ROOT} \
			CROSS_SYSROOT=${SYSROOT} \
			PATH="${PATH}:$NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/bin/" \
			./Configure ${PLATFORM}

		# Generate configuration headers, cheerfully stolen from the
		# generated Makefile
		perl -I. -Mconfigdata "util/dofile.pl" "-oMakefile" \
			include/crypto/bn_conf.h.in > include/crypto/bn_conf.h
		perl -I. -Mconfigdata "util/dofile.pl" "-oMakefile" \
			include/crypto/dso_conf.h.in > include/crypto/dso_conf.h
		perl -I. -Mconfigdata "util/dofile.pl" "-oMakefile" \
			include/openssl/opensslconf.h.in > include/openssl/opensslconf.h
		perl util/mkbuildinf.pl "" ${PLATFORM} > crypto/buildinf.h

		#perl ./crypto/armv4cpuid.pl void ./crypto/armv4cpuid.S

		# Generate 32-bit asm files
		perl ./crypto/aes/asm/aes-armv4.pl void ./crypto/aes/aes-armv4.S
		perl ./crypto/aes/asm/aesv8-armx.pl void ./crypto/aes/aesv8-armx.S
		perl ./crypto/aes/asm/bsaes-armv7.pl void ./crypto/aes/bsaes-armv7.S
		perl ./crypto/bn/asm/armv4-gf2m.pl void ./crypto/bn/armv4-gf2m.S
		perl ./crypto/bn/asm/armv4-mont.pl void ./crypto/bn/armv4-mont.S
		perl ./crypto/chacha/asm/chacha-armv4.pl void ./crypto/chacha/chacha-armv4.S
		perl ./crypto/ec/asm/ecp_nistz256-armv4.pl void ./crypto/ec/ecp_nistz256-armv4.S
		perl ./crypto/modes/asm/ghash-armv4.pl void ./crypto/modes/ghash-armv4.S
		perl ./crypto/modes/asm/ghashv8-armx.pl void ./crypto/modes/ghashv8-armx.S
		perl ./crypto/poly1305/asm/poly1305-armv4.pl void crypto/poly1305/poly1305-armv4.S
		perl ./crypto/sha/asm/keccak1600-armv4.pl void crypto/sha/keccak1600-armv4.S
		perl ./crypto/sha/asm/sha1-armv4-large.pl void crypto/sha/sha1-armv4-large.S
		perl ./crypto/sha/asm/sha256-armv4.pl void ./crypto/sha/sha256-armv4.S
		perl ./crypto/sha/asm/sha512-armv4.pl void ./crypto/sha/sha512-armv4.S
		perl ./crypto/armv4cpuid.pl void ./crypto/armv4cpuid.S

		# Generate 64-bit asm files
		perl ./crypto/arm64cpuid.pl void ./crypto/arm64cpuid.S
		perl ./crypto/ec/asm/ecp_nistz256-armv8.pl void ./crypto/ec/asm/ecp_nistz256-armv8.S
		perl ./crypto/aes/asm/aesv8-armx.pl linux64 ./crypto/aes/aesv8-armx-64.S
		perl ./crypto/modes/asm/ghashv8-armx.pl linux64 crypto/modes/ghashv8-armx-64.S

	fi
fi
