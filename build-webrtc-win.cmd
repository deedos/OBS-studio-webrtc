set DEPOT_TOOLS_WIN_TOOLCHAIN=0

if defined WEBRTC_VERSION (set WEBRTC_VERSION=%WEBRTC_VERSION%) else (set WEBRTC_VERSION=73)

set OBS_DIR=%CD%
cd ..
set DEV_DIR=%CD%

call gclient

if %ERRORLEVEL% NEQ 0 (curl -L -O https://storage.googleapis.com/chrome-infra/depot_tools.zip)
if exist depot_tools.zip (7z x depot_tools.zip -odepot_tools)
if exist depot_tools.zip (set PATH="%PATH%;%DEV_DIR%\depot_tools")
if exist depot_tools.zip (call gclient)
if exist depot_tools.zip (del depot_tools.zip)

mkdir webrtc-checkout\lib
cd webrtc-checkout

call fetch --nohooks webrtc
call gclient sync -D -R --no-history

cd src
git checkout -b m%WEBRTC_VERSION% refs/remotes/branch-heads/m%WEBRTC_VERSION%
call gclient sync -D -R --no-history

gn gen out\Release --args="use_rtti=true is_debug=false rtc_use_h264=true proprietary_codecs=true use_openh264=true ffmpeg_branding=\"Chrome\" rtc_include_tests=false rtc_build_examples=false rtc_build_tools=false libcxx_abi_unstable=false"

ninja -C out\Release

copy /y /b out\Release\obj\webrtc.lib %DEV_DIR%\webrtc-checkout\lib\webrtc.lib
REM rsync -avh --prune-empty-dirs --exclude="out" --include="*/" --include="*.h" --exclude="*" ./* ../include/

cd %OBS_DIR%
