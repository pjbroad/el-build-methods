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
BASEVERSION="1.9.5"
FILEPREFIX="el"
REPOURL="https://github.com/raduprv/Eternal-Lands.git"
REPONAME="elc"
REPOBRANCH="master"
EXENAME="${FILEPREFIX}.exe"
EXTRACMAKE=""

# the zip package for 
ZIPPREFIX="${FILEPREFIX}-bin"
PACKAGEFILEPREFIX="${FILEPREFIX}_195_install_win10"
