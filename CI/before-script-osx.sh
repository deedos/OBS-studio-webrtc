# Make sure ccache is found
export PATH=/usr/local/opt/ccache/libexec:$PATH
mkdir build
cd build
cmake \
-DDepsPath=/tmp/obsdeps \
-DCMAKE_BUILD_TYPE=RELEASE \
-DVLCPath=$PWD/../../vlc-master \
-DQTDIR=/usr/local/Cellar/qt/5.10.1 \
-DCMAKE_OSX_DEPLOYMENT_TARGET=10.10 \
-DOPENSSL_ROOT_DIR=/usr/local/opt/openssl@1.1 \
-Dlibwebrtc_DIR=/tmp/libWebRTC-73.0-x64-Rel-COMMUNITY-BETA/cmake \
..

