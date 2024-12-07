# Set-up and build Eternal Lands for Android

## Test environment
These instructions are tested using a clean virtual environment created
using the Ubuntu Multipass tool.  Using Multipass a new Ubuntu LTS
environment can be created and launched using a set of commands like
the following.  Be sure to allocate enough disk space.

```
multipass launch --name el-android --disk 10G
multipass shell el-android
sudo apt update && sudo apt upgrade && sudo apt dist-upgrade && sudo apt clean
```

The utilities and java environment needed can be installed using:
```
sudo apt install git wget unzip openjdk-8-jdk-headless ant
```

## Android tools
Currently, the build uses Ant which is no longer included in the
latest ANDROID tools, for now we can use the last supported version.
Despite this, we can still use the current stable build-tools,
platform-tools and NDK.

To use a clean install, create a tools directory, then download and
unpack the android tools:
```
mkdir ~/android-tools
cd ~/android-tools/
wget https://dl.google.com/android/repository/tools_r25.2.5-linux.zip
unzip tools_r25.2.5-linux.zip 
```

Now we have the basic tools, we can get the build-tools, platform-tools
and NDK, and install the android platforms needed for the build:
```
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export ANDROID_HOME=$HOME/android-tools

# note the need to accept the licence
$ANDROID_HOME/tools/bin/sdkmanager "platform-tools"

$ANDROID_HOME/tools/bin/sdkmanager "build-tools;30.0.3"
$ANDROID_HOME/tools/bin/sdkmanager "ndk-bundle"

$ANDROID_HOME/tools/bin/sdkmanager "platforms;android-21"
$ANDROID_HOME/tools/bin/sdkmanager "platforms;android-34"
```

### Setting up the build tree
If you cloned this repo, you will have the build tree already so just
change to the android directory and skip the rest of this step,
otherwise create a directory for the build tree and clone the repo
using steps like this:
```
cd
mkdir el
cd el
git clone https://github.com/pjbroad/el-build-methods.git
cd el-build-methods/android/
```

#### Downloading the Eternal Lands Client
Next, clone the Eternal Lands source into the build tree.
````
cd jni
git clone https://github.com/raduprv/Eternal-Lands.git src
cd ..
````

## Building the Android package
The build process needs the path to JAVA and the path to the android
NDK so ensure those are set.
```
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export ANDROID_HOME=$HOME/android-tools
```

There is a script provided that downloads and sets-up the additional
libraries needed.  Assuming you are in the android directory, run this
using:
```
./setup-libs.bash
```
You only need to do this once, but it can be run again.  Each time it
will remove and set-up the libraries again.  You can also specify a
`--clean` parameter that can be used to just remove the libraries.

The command that you will use more often builds and packages the
client.  The script optionally downloads and creates the assets file
tree, builds the libraries, builds the client and creates the Android
apk file. Run this using:
```
./build-apk.bash
```

### Installing and debugging
You can install the client (and view debug) on your android device if
you use the android debug bridge.  The adb can be installed using `sudo
apt install adb`.  You also have to enable developer mode on your
android device and connected it to your build machine over USB.

Install to the device using:
```
adb install -r bin/SDLActivity-debug.apk
```

You can view debug from the running client using:

```
adb logcat | grep "SDL"
```
