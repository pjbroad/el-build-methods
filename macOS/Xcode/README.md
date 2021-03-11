# Building for macOS using Xcode

## Contents

[1. Introduction](#1-introduction)

[2. Prerequisites](#2-prerequisites)

[3. Framework Location](#3-framework-location)

[4. Obtaining the Client Source](#4-obtaining-the-client-source)

[5. Data Location](#5-data-location)

## 1. Introduction

This guide describes the steps needed to build the Eternal Lands client 
for macOS using Apple's integrated development environment, Xcode. 
The guide assumes some familiarity with the macOS build process, but 
efforts will be made to make the process as easy to follow as possible.

## 2. Prerequisites

To build the client for macOS you'll need both a relatively modern version 
of macOS and a recent release of Xcode. It is recommended that your 
build environment be running at least macOS 10.15.4 (Catalina), though 
11.0 (Big Sur) is preferable.

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
guide has been bundled with all of the frameworks you will need (under [Frameworks](Frameworks/)) to build the latest release version of the 
client (1.9.5p9).

The Xcode project has been configured to search for these frameworks 
in the following location: `/Users/<youraccountname>/Library/Frameworks/` 
and it is recommended that you download and copy the *.framework 
folders to this location **without modifying them**. If you do not already 
have a `Frameworks` folder in `/Users/<youraccountname>/Library`, 
it is safe to create it.

If copied correctly, the full path to each framework will be: `/Users/youraccountname/Library/Frameworks/<frameworkname>.framework`

Please note that if you are attempting to build from source that has been 
highly developed since the last client release you may find that you are 
missing some of the necessary frameworks to enable new features. If 
you have followed the above steps correctly and Xcode complains about 
missing headers, this is most likely to be the cause.

## 4. Obtaining the Client Source

The next step is to obtain the client source; this section describes two 
popular ways to do this.

### 4.1 Directly from Github

The client source can be downloaded as a zip file directly from the [Eternal 
Lands github](https://github.com/raduprv/Eternal-Lands) page. Once 
extracted, you will be left with a folder in your chosen download location 
named `Eternal-Lands-master` which contains the client source.

### 4.2 Using the Terminal

The client source can be ontained from github using the following terminal
commands:

```
cd ~/Desktop
git clone https://github.com/raduprv/Eternal-Lands.git
```
Once complete, you will be left with a folder on your desktop named 
`Eternal-Lands` which contains the client source.

## 5. Data Location
