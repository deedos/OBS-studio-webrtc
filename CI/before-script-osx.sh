#!/usr/bin/env bash

set -e

# Make sure ccache is found
# export PATH=/usr/local/opt/ccache/libexec:$PATH

#export CMAKE_PREFIX_PATH=/usr/local/opt/qt/lib/cmake
export CEF_BUILD_VERSION=${CEF_BUILD_VERSION:-3.3282.1726.gc8368c8}
export WEBRTC_MAJOR_VERSION=${WEBRTC_VERSION:-73}

export MACOSX_DEPLOYMENT_TARGET=10.11

_BUILD_TYPE=${1:-RELEASE}
CMAKE_BUILD_TYPE=${BUILD_TYPE:-$_BUILD_TYPE}
export BUILD_TYPE=${CMAKE_BUILD_TYPE}

export BUILD_BROWSER=${BROWSER:-ON}
export BROWSER=${BUILD_BROWSER}

export ENABLE_SCRIPTING=${SCRIPTING:-ON}

export DISABLE_PYTHON=${DISABLE_PYTHON:-ON}

CURDIR="$(pwd)"
cd ..
PARENT_DIR=$(pwd)
cd "$CURDIR"

export DEV_DIR="${DEV_DIR:-$PARENT_DIR}"
export OBSDEPS="${OBSDEPS:-$DEV_DIR/obsdeps}"
export DepsPath="$OBSDEPS"

export CFLAGS="-I$OBSDEPS/include"
export LDFLAGS="-L$OBSDEPS/lib"
export PKG_CONFIG_PATH="$OBSDEPS/lib/pkgconfig"

export QTDIR="${QTDIR:-/usr/local/Cellar/qt/5.10.1}"

_WEBRTC_DIR="${WEBRTC:-$DEV_DIR/webrtc-checkout}"
export WEBRTC_ROOT_DIR="${WEBRTC_ROOT_DIR:-$_WEBRTC_DIR}"

_OPENSSL_DIR="${OPENSSL:-/usr/local/opt/openssl@1.1}"
export OPENSSL_ROOT_DIR="${OPENSSL_ROOT_DIR:-$_OPENSSL_DIR}"

# store current xcode-select path
XCODE_SELECT="$(xcode-select -p)"

# if [ -d /Applications/Xcode-9.4.1.app ]; then
#   sudo xcode-select --switch "/Applications/Xcode-9.4.1.app"
# fi

echo "XCODE: $XCODE_SELECT"
echo "BUILD TYPE: $BUILD_TYPE"
echo "BROWSWER: $BUILD_BROWSER"
echo "SCRIPTING: $ENABLE_SCRIPTING"
echo "DISABLE_PYTHON: $DISABLE_PYTHON"
echo " "
echo "DEV_DIR=$DEV_DIR"
echo "OBSDEPS=$OBSDEPS"
echo "WEBRTC_ROOT_DIR=$WEBRTC_ROOT_DIR"
echo "OPENSSL_ROOT_DIR=$OPENSSL_ROOT_DIR"
echo "QTDIR=$QTDIR"
echo " "

git fetch --tags

set -v

mkdir -p build
cd build

cmake \
-DBUILD_REDISTRIBUTABLE=ON \
-DCMAKE_OSX_DEPLOYMENT_TARGET=$MACOSX_DEPLOYMENT_TARGET \
-DDepsPath="$OBSDEPS" \
-DQTDIR="$QTDIR" \
-DVLCPath="$OBSDEPS/vlc-3.0.4" \
-DBUILD_BROWSER=$BUILD_BROWSER \
-DBROWSER_DEPLOY=$BUILD_BROWSER \
-DENABLE_SCRIPTING=$ENABLE_SCRIPTING \
-DDISABLE_PYTHON=$DISABLE_PYTHON \
-DCMAKE_BUILD_TYPE=$BUILD_TYPE \
-DCEF_ROOT_DIR="$OBSDEPS/cef_binary_${CEF_BUILD_VERSION}_macosx64" \
-DOPENSSL_ROOT_DIR="$OPENSSL_ROOT_DIR" \
-DWEBRTC_ROOT_DIR="$WEBRTC_ROOT_DIR" \
-DWEBRTC_MAJOR_VERSION=$WEBRTC_MAJOR_VERSION -LA ..

cmake --build .

cd ..

# sudo xcode-select --switch "$XCODE_SELECT"
