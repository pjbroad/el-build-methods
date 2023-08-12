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

# client build and other scripts
BUILDTARGET="${MINGW_PACKAGE_PREFIX}"
CLIENTBASE=~/build/
PACKAGEBASE=${CLIENTBASE}/packages/${BUILDTARGET}
PACKAGELOCAL=${PACKAGEBASE}/local
BASEVERSION="1.9.6"
FILEPREFIX="el"
REPOURL="https://github.com/raduprv/Eternal-Lands.git"
REPONAME="elc"
REPOBRANCH="master"
EXENAME="${FILEPREFIX}.exe"
EXTRACMAKE=""

# the zip package for 
ZIPPREFIX="${FILEPREFIX}-bin"
PACKAGEFILEPREFIX="${FILEPREFIX}_196_install_win10"
