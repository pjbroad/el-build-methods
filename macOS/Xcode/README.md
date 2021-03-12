# Building for macOS using Xcode

## Contents

[1. Introduction](#1-introduction)

[2. Prerequisites](#2-prerequisites)

[3. Framework Location](#3-framework-location)

[4. Obtaining the Client Source](#4-obtaining-the-client-source)

[5. Obtaining the Data Pack](#5-obtaining-the-data-pack)

[6. Open the Xcode Project](#6-open-the-xcode-project)

[7. Setting the Data Pack Location](#7-setting-the-data-pack-location)

[8. Build (aka click to bake)](#8-build-aka-click-to-bake)

[9. Further Support](#9-further-support)

## 1. Introduction

This guide describes the steps needed to build the Eternal Lands client 
for macOS using Apple's integrated development environment, Xcode. 
The guide assumes you are looking to build the latest release version of 
the client source. The guide also assumes some familiarity with the 
macOS build process, but efforts have bbeen made to make the process 
as easy to follow as possible.

### Important Note

It is worth noting at this point that any app built by following this guide 
will run **on your local machine only** and **will not be distributable 
to other users unless it has been signed by a registered Apple 
Developer account and subsequently notarised by Apple**. Steps to 
achieve this have not been included in this guide as it is assumed that 
somebody in possession of a registered Apple Developer account will 
already be familiar with the process.

## 2. Prerequisites

To build the client for macOS you'll need both a relatively modern version 
of macOS and a recent release of Xcode. It is recommended that your 
build environment be running at least macOS 10.15.4 (Catalina), though 
11.0 (Big Sur) or later is preferable.

If you are planning to build a universal binary with support for both 
x86_64 (Intel) and ARM64 (Apple Silicon)-based macs you'll need to be 
running Xcode 12.2 or later. If you plan to build for x86_64 only, Xcode 
11.4 or later is recommended.

Xcode can be obtained for free from the [Apple Developer site](https://developer.apple.com/xcode/). If you're new to Xcode it is 
highly recommended that you browse through the "Welcome" section 
of the [Xcode Help guide](https://help.apple.com/xcode/mac/current/) 
before proceeding.

## 3. Framework Location

Before you can build the client, you will need to ensure that you have 
the correct frameworks available on your system. Conveniently, this 
guide has been bundled with all of the frameworks you will need (under 
[Frameworks](Frameworks/)) to build the latest version of the client.

The Xcode project has been configured to search for frameworks in the 
following location: `/Users/<accountname>/Library/Frameworks/`

It is recommended that you download and copy the *.framework 
folders to this location **without modifying them**. If you do not already 
have a `Frameworks` folder in `/Users/<accountname>/Library`, 
it is safe to create it.

If copied correctly, the full path to each framework will be: `/Users/<accountname>/Library/Frameworks/<frameworkname>.framework`

Please note that if you are attempting to build from source that has been 
highly developed since the last client release you may find that you are 
missing some of the necessary frameworks to enable new features. If 
you have followed the above steps correctly and Xcode complains about 
missing headers, this is most likely to be the cause.

## 4. Obtaining the Client Source

You can obtain the latest release version of the client source directly from 
the [releases page](https://github.com/raduprv/Eternal-Lands/releases) 
of the Eternal Lands github. The source code will be listed as an asset 
for the latest release.

 The file you are looking for will be named `Source code (zip)`. 
 Download it and extract it somewhere that'll be easy for you to find.

Once extracted, you should have a folder named 
`Eternal-Lands-<version>` which contains the client source. You 
don't need this quite yet, but keep it safe for now and **do not attempt 
to modify it**.

## 5. Obtaining the Data Pack

You can obtain the latest release version of the data pack directly from 
the [releases page](https://github.com/raduprv/Eternal-Lands/releases) 
 of the Eternal Lands github. If the data pack has been updated recently 
 it'll be listed as an asset for the latest release, otherwise you'll need to 
 look through previous releases to find it.

 The file you are looking for will be named `el_195_p*_data_files.zip` 
 or something very similar. Download it and extract it somewhere that'll 
 be easy for you to find.

Once you have extracted the files from the zip, it is **very important** 
that the main outer folder (the one **directly** containing `2dobjects`, 
`3dobjects`, and a bunch of other stuff) be named `data`. If for whatever 
reason the outer folder is named something other than that, be sure to 
re-name it before continuing to the next step.

## 6. Open the Xcode Project

If you've made it this far, well done! It's finally time to open the Xcode 
project and start the really fun stuff.

You'll find the Xcode project file under `macosx` in the folder of source 
files you extracted back in step 4. If you have Xcode installed correctly, 
double clicking `Eternal Lands.xcodeproj` should open the project 
window.

If you're new or not very familiar with Xcode then feel free to take this 
opportunity to browse around and take everything in. Don't worry if you 
mess anything up, you can always repeat step 4 to start over with fresh 
source!

## 7. Setting the Data Pack Location

Unfortunately, because the data pack is maintained and distributed in a 
separate package, it isn't possible for us to pre-configure the path to it 
in the Xcode project that is distributed with the client source code. The 
good news is that this isn't too difficult to configure yourself, and it 
**should** be the final thing you need to do to before building the client!

1. Select the **Eternal Lands** target.

2. Select the **Build Phases** tab.

3. Expand the **Copy Files** build phase.

4. Select the current entry, `data`, and remove it by clicking the **-**.

5. Click the **+** and select the `data` folder you created back in step 5.

6. When the choose options window pops up, make sure **copy files is 
disabled** and **create folder references is enabled**.

7. Click finish.

If you have followed the above steps correctly, the path to the data folder 
on your Mac should now be correctly configured. You're ready to build!

## 8. Build (aka click to bake)

If all of the above steps have been followed correctly, building the client 
should now be a piece of cake. To build the client you can either click the 
play button at the top of the project window, or press **Command + B**.

The build process can take some time, and if everything worked correctly 
(*Build Succeeded!*) you'll be able to find the complete app bundle in the 
following location: `/Users/<accountname>/Library/Developer/Xcode/DerivedData/Eternal_Lands*/Build/Products/Release`

## 9. Further Support

If something goes wrong or you have any trouble following this guide, 
please feel free to drop me (Ben) a message in-game or via the 
[Eternal Lands forum](http://www.eternal-lands.com/forum/).
