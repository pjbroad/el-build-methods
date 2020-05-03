# Build using the Msys2 tool.

## Initial installation and set-up

This build method for Windows, uses the Msys2 tool.  Msys2 provides a 
Linux like development enviroment with a wide range of open source 
development tools and pre-packaged libraries.  It comes with an package 
installer (based on Arch Linux pacman) that is easy use and makes it 
easy to keep up your environment to date.

First, visit the Msys2 website 
[https://www.msys2.org/](https://www.msys2.org/), then download and run 
the installer.  Accept the defaults following the steps described on 
the site.  When complete, you will have the basic enviroment installed 
and up to date.

Using a Msys2 terminal for your specific system, for example the 64-bit 
terminal.  Install the git package so you can download the github 
repository that holds the reminaing setup scripts and the script to 
build the client.

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
defaults and approximately 140 packages will be installed. These 
include the c/c++ build enviroment and all the packages needed to build 
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
changes to the client code.  The script downloads the source code from 
git into a local repository that you can keep up to date using standard 
git commands.

```
cd ~/el-build-methods/windows-10/msys2
./build-client.bash dev
```

This script builds the client, then creates a date-tagged zip file
containing the client executable and all the required DLL files.  You
can unzip this file into a pre-installed client directory to use your
build.  You can build either a development `dev` version that
contains debug symbols and a version string tagged with the build date,
or a release `rel` version that uses full optomisation and the
current release version string.

The zip file is located in the `~/build` directory.  From the Windows 
file explorer, this directory can be found using, for exmaple, 
`C:\msys64\home\Paul\build`.

To remove the build directory, you can specify the `clean` parameter 
for the build script, then re-build as before.

``
cd ~/el-build-methods/windows-10/msys2
./build-client.bash dev clean
``

## Updating the client code

Assuming you used the provided scripts, the client code will be located 
in `~/build/elc`.  You can update the code using `git pull` or 
switch to a tagged release using, for example `git checkout 1.9.5.8`, 
then re-run the build script to build a new version.

The built code is located a sub-directory of the source directory 
named, for example `mingw-w64-x86_64-dev`.  A different directory is 
used for development and release builds.

Have fun, and help improve this information and scripts by offereing 
pull requests.


