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

# optionally remove all build artifacts (preserves library setup)
echo "" && read -p "Clean build? (y/n) [n]: " opt
if [ "$opt" = "Y" -o "$opt" = "y" ]
then
	echo "" && echo "Cleaning ..."
	APP_ALLOW_MISSING_DEPS=true ndk-build --silent clean
	ant -silent clean
	rm -rf obj/ libs/ gen/ proguard-project.txt
fi

# if we have assets, optionally remove them
if [ -r assets/asset.list ]
then
	echo "" && read -p "Clean asset? (y/n) [n]: " opt
	if [ "$opt" = "Y" -o "$opt" = "y" ]
	then
		rm -rf assets/
	fi
fi

# if we do not have the assets, offer to generate them
if [ ! -r assets/asset.list ]
then
	echo "" && read -p "Generate Assset? (y/n) [y]: " opt
	if [ "$opt" = "N" -o "$opt" = "n" ]
	then
		echo "Exiting, we need assets to continue."
		exit
	fi

	echo "" && echo "Generating Assets ..."

	# get the data package and the tab maps, caching for reuse
	dlcache=$(pwd)/assets_download_cache
	mkdir -p $dlcache
	cd $dlcache
	if [ ! -r eternallands-data_1.9.5.9-1.zip ]
	then
		echo "Fetching data package..."
		wget -q https://github.com/raduprv/Eternal-Lands/releases/download/1.9.5.9-1/eternallands-data_1.9.5.9-1.zip
	fi
	if [ ! -r eternallands-android-only-data_1.9.5dev.zip ]
	then
		echo "Fetching android only data package..."
		wget -q https://github.com/raduprv/Eternal-Lands/releases/download/1.9.5.9-1/eternallands-android-only-data_1.9.5dev.zip
	fi
	if [ ! -r BurnedMaps-1.9.5-02-minimal-version.zip ]
	then
		echo "Fetching Burn's tab maps..."
		wget -q https://maps.el-db.com/packs/BurnedMaps-1.9.5-02-minimal-version.zip
	fi
	cd ..

	echo "Unpacking data..."

	# start by unpacking the data package
	rm -rf assets/ el_data/
	unzip -q $dlcache/eternallands-data_1.9.5.9-1.zip
	mv el_data/ assets/
	cd assets/

	# unpack the android only data files
	unzip -oq $dlcache/eternallands-android-only-data_1.9.5dev.zip

	# overwrite the tab maps with Burn's package
	cd maps
	unzip -oq $dlcache/BurnedMaps-1.9.5-02-minimal-version.zip
	cd ..

	# if we have local assets files then include them
	if [ -r ../assets_local/ ]
	then
		echo "Including local assets..."
		cp -pR ../assets_local/* .
	fi

	echo "Making final adjustments..."

	# rename compressed files to that they are not uncmpressed by the packing process
	find . -name "*.gz" -exec mv {} {}.preserve \;
	find . -name "*.xz" -exec mv {} {}.preserve \;

	# we don't currently use the shaders
	rm -rf shaders/

	# generate the font list, user menu list and the certificate list
	find fonts/ -name "*.ttf" > ttf_list.txt
	find . -name "*.menu" > user_menus.txt
	find certificates/ -type f > certs.txt

	# create the asset list
	date +"%s" > asset.list
	find . -type f | grep -v "^./asset.list$" >> asset.list
	cd ../
fi

echo "" && read -p "Build? (y/n) [y]: " opt
if [ "$opt" = "N" -o "$opt" = "n" ]
then
	exit
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
