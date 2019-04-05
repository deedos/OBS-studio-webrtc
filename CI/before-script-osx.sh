# Make sure ccache is found
export PATH=/usr/local/opt/ccache/libexec:$PATH

BUILD_TYPE=${1:-RELEASE}

export CMAKE_PREFIX_PATH=/usr/local/opt/qt5/lib/cmake
export CEF_BUILD_VERSION=3.3282.1726.gc8368c8
WEBRTC_ROOT_DIR=${WEBRTC_ROOT_DIR:-$PWD/../../webrtc-checkout}

git fetch --tags

mkdir -p build
cd build

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

#cmake --build .
