# Build using the Msys2 tool.

## Initial installation and set-up

This build method for Windows, uses the Msys2 tool.  Msys2 provides a 
Linux like development environment with a wide range of open source 
development tools and pre-packaged libraries.  It comes with a package 
installer (based on Arch Linux pacman) that is easy use and makes it 
easy to keep your environment up to date.

First, visit the Msys2 website 
[https://www.msys2.org/](https://www.msys2.org/), then download and run 
the installer.  Accept the defaults following the steps described on 
the site.  When complete, you will have the basic environment installed 
and up to date.

Msys provides a Linux-like terminal environment with three terminal
types.  The default terminal is generic (not specific to the processor
architecture) and cannot be used to build code.  The other types are
for building 32-bit or 64-bit applications.  You can select the
specific build terminal from the Msys launcher which can always be
opened with a right-click of the Msys icon.

The set-up and build scripts provided in this repo must be run from
either the 32-bit or 64-bit terminal.  Open a terminal of the type
needed for the client version you want to build and use that going
forwards.

Now, install the git package so you can download the github repository
that holds the setup scripts and the scripts to build the client.

```
pacman -S git
```

You can now clone this repository which will enable you to use the 
client set-up and build scripts.

```
cd ~/
git clone https://github.com/pjbroad/el-build-methods.git
```

To complete initial set-up, run the provided set-up script. Accept the 
defaults, this will take some time as over 100 packages will be installed. These 
include the c/c++ build environment and all the packages needed to build 
the client.

```
cd ~/el-build-methods/windows-10/msys2
./setup.bash
```

Now and in the future, you can update your Msys2 environment and all 
the packaged libraries you just installed using a single command: 
`pacman -Syu`.


## Building additional libraries

We need to build libraries required by the client that are not 
available from the Msys2 package manager.

```
cd ~/el-build-methods/windows-10/msys2
./build-libraries.bash
```

## Building the client

Now we can build the client.  This step can be repeated if you make 
changes to the client code.  When run for the first time, the script
downloads the source code from git into a local repository.  You can
keep this copy up to date using standard git commands.

```
cd ~/el-build-methods/windows-10/msys2
./build-client.bash dev
```

This script builds the client, then creates a date-tagged zip file
containing the client executable and all the required DLL files.  You
can unzip this file into a pre-installed client directory to use your
new build.  You can build either a development `dev` version that
contains debug symbols and a version string tagged with the build date,
or a release `rel` version that uses full optimisation and the
current release version string.

The created zip file is located in the `~/build` directory.  From the Windows 
file explorer, this directory can be found using, for example, 
`C:\msys64\home\Paul\build`.

To remove the build directory, you can specify the `clean` parameter 
for the build script, then re-build as before.

```
cd ~/el-build-methods/windows-10/msys2
./build-client.bash dev clean
```

## Updating the client code

Assuming you used the provided scripts, the client code will be located 
in `~/build/elc`.  You can update the code using `git pull` or 
switch to a tagged release using, for example `git checkout 1.9.5.8`, 
then re-run the build script to build a new version.

The built code is located a sub-directory of the source directory 
named, for example `mingw-w64-x86_64-dev`.  A different directory is 
used for development and release builds.

Have fun, and help improve this information and scripts by offering 
pull requests.


