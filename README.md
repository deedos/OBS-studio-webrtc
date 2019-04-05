
# OBS-studio WebRTC

This project is a fork of OBS-studio with support for WebRTC. WebRTC supports comes from the inclusion of the open source implementation from webrtc.org used (at least in part) by chrome, firefox, and safari.

The implementation is in the "plugins / obs-outputs" directory, co-existing with the flash and FTL output plugins. The WebRTCStream files contain the high-level implementation, while the xxxx-stream files contain the specific implementation for a given service.

For the time being the following services and sites are supported:
- Janus
- Millicast.com
- Spank.live (SpankChain)

This is mainly a community project with a best effort service. The maintainers of this repository are all based in Singapore, so please take the timezone into account. If you file a ticket at 2am, you won't get an answer for at least 7 hours.

If you need more support, or custom developement, please contact [CoSMo software](http://www.cosmosoftware.io/contact.html).

# Table of content

- [Binaries](#binaries)
- [Usage](#usage)
  * [Configure JANUS](#configure-janus)
  * [OBS settings](#obs-settings)

## Binaries

Pre-built and tested Binaries are available [here](https://github.com/CoSMoSoftware/OBS-studio-webrtc/releases).

## Windows linux or macos

### Prerequisite

The current recommended way of compiling libwebrtc is documented on the libwebrtc website. More specifically: https://webrtc.org/native-code/development/prerequisite-sw/

Note that the recommended version of MSVC 2017 is older that the one you would download today, but we can confirm that the latest one works. There is no specific problem on linux or mac.

This repository code is based on the stable branch 65 of webrtc.org. It should be updated to 69 next, by the end of october 2018.

OpenSSL build of libwebrtc might not be needed.  The flags are already in place in google's code to get that build. More specifically, if you look at the source code, you will see the SSL flags which needs to be passed to the GN GEN command that allow to use an external SSL library, if you need to (line 43):
https://webrtc.googlesource.com/src/+/master/rtc_base/BUILD.gn

You do NOT depend on any external libwebrtc package one might provide. However, compilation of libwebrtc is an under documented process with strong ties to dark magic. From time to time, when people ask nicely, we compile it for them to make their life easier. If you think the compilation of the code from webrtc.org is too difficult, and it makes depending projects NOT easily reproducible, please let Google know, Their bug tracker is there:
https://bugs.chromium.org/p/webrtc/issues/list

### Compilation, Installation and Packaging

Follow the original compilation, Installation and packaging guide https://github.com/obsproject/obs-studio

#### Standard Build (macOS)
``` bash
# Build libwebrtc:
git clone --recursive https://[url of repository host]/[repo owner]/webrtc-checkout.git

cd src
cat README.md
# follow instructions to build webrtc (m69)

git clone --recursive https://[url of repository host]/[repo owner]/obs-studio-mfc.git

cd obs-studio-mfc

sh ./build-deps.sh
sh ./build.sh
sh ./make-package.sh
```

#### Manual Compilation (macOS)
``` bash
mkdir -p /tmp/obsdeps-src
mkdir -p /tmp/obsdeps

# download and extract the following dependencies into /tmp/obsdeps-src:
# FFmpeg n4.0.2, openssl 1.1.0g, libogg 1.3.3, libvorbis 1.3.6, libvpx 1.7.0, opus 1.2.1, x264 r2945

cd ~ # or anywhere

mkdir dev && cd dev

# build package dependencies: see
[./CI/util/build-package-deps-osx.sh script]
# for building info. use prefix = /tmp/obsdeps

# build libwebrtc:

git clone --recursive https://github.com/SCG82/webrtc-checkout.git

cd src # follow instructions in README.md to build webrtc (m69)

# build OBS-studio-webrtc:

git clone --recursive https://github.com/SCG82/OBS-studio-webtrc.git

cd OBS-studio-webrtc

./CI/install-dependencies-osx.sh

brew install qt5

export QTDIR=/usr/local/opt/qt5

./CI/before-script-osx.sh

# to build manually:

mkdir -p build && cd build

export BUILD_TYPE=RELEASE # or Debug
export CEF_BUILD_VERSION=3.3282.1726.gc8368c8
export CMAKE_PREFIX_PATH=/usr/local/opt/qt5/lib/cmake
export WEBRTC_ROOT_DIR=$PWD/../../webrtc-checkout

cmake \
-DCMAKE_OSX_DEPLOYMENT_TARGET=10.10 \
-DQTDIR=/usr/local/opt/qt5 \
-DDepsPath=/tmp/obsdeps \
-DVLCPath=/tmp/obsdeps/vlc-3.0.4 \
-DBUILD_BROWSER=ON \
-DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
-DCEF_ROOT_DIR=/tmp/obsdeps/cef_binary_${CEF_BUILD_VERSION}_macosx64 \
-DOPENSSL_ROOT_DIR=/tmp/obsdeps \
-DDEV_DIR=$PWD/../.. \
-DWEBRTC_ROOT_DIR=$WEBRTC_ROOT_DIR \
-DWEBRTC_MAJOR_VERSION=69 ..

make

# to run OBS:

cd rundir/${BUILD_TYPE}/bin

./obs

```

## Usage with a Janus server

### Configure JANUS

https://github.com/meetecho/janus-gateway.

Configure a JANUS server using the video room plugin with **websocket secure protocol** enabled. (you can enable TLS inside the config file janus.transport.websockets.cfg or e.g directly use Nginx).

For now OBS-Webrtc **support only connection through wss**. 
You can directly use their test webpage videoroomtest.html to receive the stream from OBS-webrtc.

### OBS settings

Launch OBS, go to settings, select the stream tab and change the URL to point to your JANUS server (wss://xxx). if using videoroomtest.html, the default "Server room" value is 1234.
