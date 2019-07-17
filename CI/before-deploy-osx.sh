#!/usr/bin/env bash

export CEF_BUILD_VERSION=${CEF_BUILD_VERSION:-3.3282.1726.gc8368c8}

_BUILD_TYPE=${1:-RELEASE}
export BUILD_TYPE=${BUILD_TYPE:-$_BUILD_TYPE}

_CEF_BUILD_TYPE=${2:-Release}
if [[ BUILD_TYPE == "Debug" ]]; then
  _CEF_BUILD_TYPE=Debug
fi
export CEF_BUILD_TYPE=${CEF_BUILD_TYPE:-$_CEF_BUILD_TYPE}

hr() {
  echo "───────────────────────────────────────────────────"
  echo "$1"
  echo "───────────────────────────────────────────────────"
}

# Exit if something fails
set -e

# Generate file name variables
export GIT_HASH=$(git rev-parse --short HEAD)
export FILE_DATE=$(date +%Y-%m-%d.%H-%M-%S)
export FILENAME=${FILE_DATE}-${GIT_HASH}-${TRAVIS_BRANCH}-osx.pkg

CURDIR="$(pwd)"
cd ..
PARENT_DIR=$(pwd)
cd "$CURDIR"

export DEV_DIR="${DEV_DIR:-$PARENT_DIR}"
export OBSDEPS="${OBSDEPS:-$DEV_DIR/obsdeps}"
export DEPS_DEST="$OBSDEPS"

hr "BUILD TYPE: $BUILD_TYPE"

cd ./build

# Move obslua
if [ -f ./rundir/$BUILD_TYPE/data/obs-scripting/obslua.so ]; then
	hr "Moving OBS LUA"
	mv ./rundir/$BUILD_TYPE/data/obs-scripting/obslua.so ./rundir/$BUILD_TYPE/bin/
fi

# Move obspython (not ready yet)
# if [ -f ./rundir/$BUILD_TYPE/data/obs-scripting/_obspython.so ]; then
# 	hr "Moving _obspython.so"
# 	mv ./rundir/$BUILD_TYPE/data/obs-scripting/_obspython.so ./rundir/$BUILD_TYPE/bin/
# fi
# if [ -f ./rundir/$BUILD_TYPE/data/obs-scripting/obspython.py ]; then
# 	hr "Moving obspython.py"
# 	mv ./rundir/$BUILD_TYPE/data/obs-scripting/obspython.py ./rundir/$BUILD_TYPE/bin/
# fi

# Package everything into a nice .app
hr "Packaging .app"
STABLE=false
if [ -n "${TRAVIS_TAG}" ]; then
  STABLE=true
fi

sudo python ../CI/install/osx/build_app.py --build-type=$BUILD_TYPE --public-key ../CI/install/osx/OBSPublicDSAKey.pem --stable=$STABLE

# Copy Chromium embedded framework to app Frameworks directory
if [ -f ./rundir/$BUILD_TYPE/obs-plugins/obs-browser.so ]; then
	hr "Copying Chromium Embedded Framework.framework"
	sudo mkdir -p OBS.app/Contents/Frameworks
 	sudo cp -r $DEPS_DEST/cef_binary_${CEF_BUILD_VERSION}_macosx64/Release/Chromium\ Embedded\ Framework.framework OBS.app/Contents/Frameworks/
	sudo install_name_tool -change \
 		@rpath/Frameworks/Chromium\ Embedded\ Framework.framework/Chromium\ Embedded\ Framework \
		../../Frameworks/Chromium\ Embedded\ Framework.framework/Chromium\ Embedded\ Framework \
		OBS.app/Contents/Resources/obs-plugins/obs-browser.so
	sudo install_name_tool -change \
		@rpath/Frameworks/Chromium\ Embedded\ Framework.framework/Chromium\ Embedded\ Framework \
		../../Frameworks/Chromium\ Embedded\ Framework.framework/Chromium\ Embedded\ Framework \
		OBS.app/Contents/Resources/obs-plugins/cef-bootstrap
fi

# Package app
hr "Generating .pkg"
if [ -f ./rundir/$BUILD_TYPE/obs-plugins/obs-browser.so ]; then
	hr "Packaging with browser source"
	packagesbuild ../CI/install/osx/CMakeLists.pkgproj
else
	hr "Packaging without browser source"
	packagesbuild ../CI/install/osx/CMakeLists-no-browser.pkgproj
fi

#if [[ $TRAVIS ]]; then
	# Signing stuff
	# hr "Decrypting Cert"
	# openssl aes-256-cbc -K $encrypted_dd3c7f5e9db9_key -iv $encrypted_dd3c7f5e9db9_iv -in ../CI/osxcert/Certificates.p12.enc -out Certificates.p12 -d
	# hr "Creating Keychain"
	# security create-keychain -p mysecretpassword build.keychain
	# security default-keychain -s build.keychain
	# security unlock-keychain -p mysecretpassword build.keychain
	# security set-keychain-settings -t 3600 -u build.keychain
	# hr "Importing certs into keychain"
	# security import ./Certificates.p12 -k build.keychain -T /usr/bin/productsign -P ""
	# # macOS 10.12+
	# security set-key-partition-list -S apple-tool:,apple: -s -k mysecretpassword build.keychain
	# hr "Signing Package"
	# productsign --sign 2MMRE5MTB8 ./OBS.pkg ./$FILENAME
#else
	# cp ./OBS.pkg ./$FILENAME
#fi

hr "Finished building OBS WebRTC"

hr "Package location: $CURDIR/build/OBS.pkg"

# Move to the folder that travis uses to upload artifacts from
# hr "Renaming package"
# mkdir -p ../nightly
# sudo mv OBS.pkg $FILENAME
