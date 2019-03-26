# Make sure ccache is found
export PATH=/usr/local/opt/ccache/libexec:$PATH

export CMAKE_PREFIX_PATH=/usr/local/opt/qt5/lib/cmake
export CEF_BUILD_VERSION=3.3282.1726.gc8368c8

git fetch --tags

mkdir build
cd build

cmake -DCMAKE_OSX_DEPLOYMENT_TARGET=10.11 \
-DQTDIR=/usr/local/Cellar/qt/5.10.1 \
-DDepsPath=/tmp/obsdeps \
-DVLCPath=$PWD/../../vlc-3.0.4 \
-DBUILD_BROWSER=ON \
-DBROWSER_DEPLOY=ON \
-DCMAKE_BUILD_TYPE=RELEASE \
-DCEF_ROOT_DIR=$PWD/../../cef_binary_${CEF_BUILD_VERSION}_macosx64 ..

#cmake --build .
