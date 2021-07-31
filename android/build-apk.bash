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

if [ -z "$ANDROID_HOME" ]
then
	echo "ANDROID_HOME not set"
	exit
fi
export PATH=$PATH:$ANDROID_HOME/ndk-bundle

cd $(dirname $0)

echo "" && read -p "Clean build? (y/n) [n]: " opt
if [ "$opt" = "Y" -o "$opt" = "y" ]
then
	echo "" && echo "Cleaning ..."
	APP_ALLOW_MISSING_DEPS=true ndk-build --silent clean
	ant -silent clean
	rm -rf obj/ libs/ gen/ proguard-project.txt assets/asset.list
	exit
fi

if [ ! -r assets/asset.list ]
then
	echo "" && echo "Generating Assets ..."
	cd assets
	find fonts/ -name "*.ttf" > ttf_list.txt
	find . -name "*.menu" > user_menus.txt
	find certificates/ -type f > certs.txt
	date +"%s" > asset.list
	find . -type f | grep -v "^./asset.list$" >> asset.list
	cd ../
fi

echo "" && echo "Building ..."
BUILDTAG="1.9.5-$(date +"%Y%m%d.%H%M")"
APP_ALLOW_MISSING_DEPS=true ndk-build --silent -j $(grep -c ^processor /proc/cpuinfo) ELVERSION=$BUILDTAG

echo "" && echo "Packaging ..."
ant -silent debug

if [ -x "./local-build-apk.bash" ]
then
	./local-build-apk.bash "$BUILDTAG" $*
fi
