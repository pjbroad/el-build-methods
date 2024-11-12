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

extractdatadir="el_data/"
maindatapath="https://twinmoons.org.uk/el/rel/197/eternallands-data_1.9.7.zip"
patchdatapath=""
androiddatapath="https://twinmoons.org.uk/el/rel/197/eternallands-android-only-data_1.9.6.zip"
androidmaps=""
tabmappath="https://twinmoons.org.uk/el/rel/197/512pxMapsForAndroid.tar.gz"

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
		chmod -R +w assets/
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
	if [ -n "$maindatapath" -a ! -r "$(basename "$maindatapath")" ]
	then
		echo "Fetching data package..."
		wget -q "$maindatapath"
	fi
	if [ -n "$patchdatapath" -a ! -r "$(basename "$patchdatapath")" ]
	then
		echo "Fetching data patch..."
		wget -q "$patchdatapath"
	fi
	if [ -n "$androiddatapath" -a ! -r "$(basename "$androiddatapath")" ]
	then
		echo "Fetching android only data package..."
		wget -q "$androiddatapath"
	fi
	if [ -n "$tabmappath" -a ! -r "$(basename "$tabmappath")" ]
	then
		echo "Fetching Burn's tab maps..."
		wget -q "$tabmappath"
	fi
	if [ -n "$androidmaps" -a ! -r "$(basename "$androidmaps")" ]
	then
		echo "Fetching android maps..."
		wget -q "$androidmaps"
	fi

	cd ..
	rm -rf assets/

	echo "Unpacking data..."

	# start by unpacking the data package
	if [ -n "$maindatapath" ]
	then
		unzip -q "$dlcache/$(basename "$maindatapath")"
		mv "$extractdatadir" assets/
	else
		mkdir assets/
	fi
	cd assets/

	# unpack the android only data files
	[ -n "$androiddatapath" ] && unzip -oq "$dlcache/$(basename "$androiddatapath")"

	# unpack and data patch
	[ -n "$patchdatapath" ] && unzip -oq "$dlcache/$(basename "$patchdatapath")"

	# overwrite the tab maps with Burn's package
	if [ -n "$tabmappath" ]
	then
		mkdir -p maps
		cd maps
		tar xfz "$dlcache/$(basename "$tabmappath")"
		mv 512pxMapsForAndroid/* .
		cd ..
	fi

	# overwrite the maps if we have a full pack package
	if [ -n "$androidmaps" ]
	then
		rm -rf maps/
		unzip -oq "$dlcache/$(basename "$androidmaps")"
	fi

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

	# we don't currently use the shaders, sound or music
	rm -rf shaders/ sound/ music/

	# generate the font list, user menu list and the certificate list
	[ -d fonts ] && find fonts/ -name "*.ttf" > ttf_list.txt
	find . -name "*.menu" > user_menus.txt
	[ -d certificates ] && find certificates/ -type f > certs.txt

	# create the asset list
	date +"%s" > asset.list
	find . -type f | grep -v "^./asset.list$" >> asset.list
	for file in $(find . -type f -name "*.xz.preserve") $(find . -type f -name "*.gz.preserve")
	do
		basefile=$(echo $file | rev |cut -f3- -d'.' | rev)
		echo "$basefile" >> asset.list
		echo "$basefile.gz" >> asset.list
		echo "$basefile.xz" >> asset.list
	done
	cd ../
fi

echo "" && read -p "Build? (y/n) [y]: " opt
if [ "$opt" = "N" -o "$opt" = "n" ]
then
	exit
fi

echo "" && echo "Building ..."
BUILDTAG="1.9.7"
APP_ALLOW_MISSING_DEPS=true ndk-build --silent -j $(grep -c ^processor /proc/cpuinfo) ELVERSION=$BUILDTAG

echo "" && read -p "Package debug? (y/n) [y]: " opt
if [ "$opt" != "N" -a "$opt" != "n" ]
then
	echo "" && echo "Packaging ..."
	ant -silent debug
fi

if [ -x "./local-build-apk.bash" ]
then
	./local-build-apk.bash "$BUILDTAG" $*
fi
