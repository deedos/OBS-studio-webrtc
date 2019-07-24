@echo off

if defined BUILD_TYPE (set build_config=%BUILD_TYPE%) else (set build_config=Release)
if defined build_config (set build_config=%build_config%)

set OBS_DIR=%CD%
cd ..

rem ---------------------------------------------------------------------
curl -c ./cookie -s -L "https://drive.google.com/uc?export=download&id=1mgOr53httBCxmmIoln4VozIdrw-sOUuY" > nul
for /f "delims="  %%x in ('findstr /C:"NID" cookie') do set "confirm_line=%%x"
for /f "tokens=2 delims==" %%a in ("%confirm_line%") do set "confirm_id=%%a"
curl -Lb ./cookie "https://drive.google.com/uc?export=download&confirm=%confirm_id%&id=1mgOr53httBCxmmIoln4VozIdrw-sOUuY" -olibWebRTC-73.0-x64-Rel-msvc2017-COMMUNITY-BETA.zip
7z x libWebRTC-73.0-x64-Rel-msvc2017-COMMUNITY-BETA.zip -olibWebRTC-73
set libwebrtcPath=%CD%\libWebRTC-73\cmake
rem ---------------------------------------------------------------------

if defined MSVC_PATH (set MSVC_PATH=%MSVC_PATH%) else (set MSVC_PATH="C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\msbuild.exe")

if defined MSVC_VERSION (set MSVC_VERSION=%MSVC_VERSION%) else (set MSVC_VERSION="Visual Studio 15 2017")
set MSVC_VERSION_64=%MSVC_VERSION% + " Win64"

if defined CEF_VERSION (set CEF_VERSION=%CEF_VERSION%) else (set CEF_VERSION=3.3440.1805.gbe070f9)

if defined DepsPath (set DepsPath64=%DepsPath%) else (set DepsPath64=%CD%\dependencies2017\win64)
if defined DepsPath64 (set DepsPath64=%DepsPath64%)

if defined VLCPath (set VLCPath=%VLCPath%) else (set VLCPath=%CD%\vlc)

if defined QTDIR (set QTDIR64=%QTDIR%) else (set QTDIR64=%CD%\Qt\5.10.1\msvc2017_64)
if defined QTDIR64 (set QTDIR64=%QTDIR64%)

if defined CEF (set CEF_64=%CEF%) else (set CEF_64=%CD%\CEF_64\cef_binary_%CEF_VERSION%_windows64)
if defined CEF_64 (set CEF_64=%CEF_64%)

if defined WEBRTC_ROOT_DIR (set WEBRTC_ROOT_DIR=%WEBRTC_ROOT_DIR%) else (set WEBRTC_ROOT_DIR=%CD%\webrtc-checkout)
if defined WEBRTC (set WEBRTC_ROOT_DIR=%WEBRTC%)

if defined OPENSSL_ROOT_DIR (set OPENSSL_ROOT_DIR=%OPENSSL_ROOT_DIR%) else (set OPENSSL_ROOT_DIR=%CD%\OpenSSL-Win64)
if defined OPENSSL (set OPENSSL_ROOT_DIR=%OPENSSL%)

set InstallPath64="C:\Program Files\obs-mfc"

mkdir %WEBRTC_ROOT_DIR%\lib > nul 2> nul

%OBS_DIR%\CI\wininstaller\check_for_64bit_visual_studio_2017_runtimes.exe || curl -LRO https://mfcobs.com/download/win/vc_redist.x64.exe -f --retry 5 -C -

if not exist %QTDIR64%\lib\cmake\Qt5\Qt5Config.cmake (curl -LRO https://mfcobs.com/download/win/Qt_5.10.1.7z -f --retry 5 -C -) else (echo Qt already installed)

if not exist %DepsPath64%\include\libavcodec\avcodec.h (curl -LRO https://mfcobs.com/download/win/dependencies2017.zip -f --retry 5 -C -) else (echo OBS dependencies already installed)

if not exist %VLCPath%\include\vlc\libvlc.h (curl -LRO https://mfcobs.com/download/win/vlc.zip -f --retry 5 -C -) else (echo VLC already installed)

if not exist %CEF_64%\include\cef_version.h (curl -LRO https://mfcobs.com/download/win/cef_binary_%CEF_VERSION%_windows64.zip -f --retry 5 -C -) else (echo CEF 64 already installed)

if not exist %WEBRTC_ROOT_DIR%\lib\webrtc.lib (curl -LRO https://mfcobs.com/download/webrtc/latest-win/webrtc.lib -f --retry 5 -C -) else (echo WebRTC library already installed)

if not exist %WEBRTC_ROOT_DIR%\include\pc\channel.h (curl -LRO https://mfcobs.com/download/webrtc/latest-win/webrtc-headers-win.zip -f --retry 5 -C -) else (echo WebRTC headers already installed)

if not exist %OPENSSL_ROOT_DIR%\include\openssl\opensslv.h (curl -LRO https://mfcobs.com/download/openssl/openssl_1_1_0k.zip -f --retry 5 -C -) else (echo OpenSSL 1.1.0 already installed)

if exist vc_redist.x64.exe (vc_redist.x64.exe /install /quiet)

if exist Qt_5.10.1.7z (7z x Qt_5.10.1.7z -oQt)
if exist dependencies2017.zip (7z x dependencies2017.zip -odependencies2017)
if exist vlc.zip (7z x vlc.zip -ovlc)
if exist cef_binary_%CEF_VERSION%_windows64.zip (7z x cef_binary_%CEF_VERSION%_windows64.zip -oCEF_64)
if exist webrtc.lib (move webrtc.lib %WEBRTC_ROOT_DIR%\lib)
if exist webrtc-headers-win.zip (7z x webrtc-headers-win.zip -o%WEBRTC_ROOT_DIR%)
if exist openssl_1_1_0k.zip (7z x openssl_1_1_0k.zip)

if exist Qt_5.10.1.7z (del Qt_5.10.1.7z)
if exist dependencies2017.zip (del dependencies2017.zip)
if exist vlc.zip (del vlc.zip)
if exist cef_binary_%CEF_VERSION%_windows64.zip (del cef_binary_%CEF_VERSION%_windows64.zip)
if exist webrtc-headers-win.zip (del webrtc-headers-win.zip)
if exist openssl_1_1_0k.zip (del openssl_1_1_0k.zip)

echo MSVC_PATH: %MSVC_PATH%
echo MSVC_VERSION: %MSVC_VERSION%
echo InstallPath64: %InstallPath64%
echo DepsPath64: %DepsPath64%
echo QTDIR64: %QTDIR64%
echo CEF_64: %CEF_64%
echo VLCPath: %VLCPath%
echo WEBRTC_ROOT_DIR: %WEBRTC_ROOT_DIR%
echo OPENSSL_ROOT_DIR: %OPENSSL_ROOT_DIR%
echo build_config: %build_config%

cd %OBS_DIR%

rmdir /q /s build build64 > nul 2> nul
mkdir build build64

cd ./build64

cmake -G %MSVC_VERSION% -A x64 -T host=x64 -DCMAKE_BUILD_TYPE=%build_config%^
 -DENABLE_SCRIPTING=OFF^
 -DCMAKE_INSTALL_PREFIX=%InstallPath64% -DCOPIED_DEPENDENCIES=false^
 -DCOPY_DEPENDENCIES=true -DBUILD_CAPTIONS=true -DCOMPILE_D3D12_HOOK=true^
 -Dlibwebrtc_DIR=%libwebrtcPath% -DOPENSSL_ROOT_DIR=%opensslPath%^
 -DBUILD_BROWSER=true -DCEF_ROOT_DIR=%CEF_64% ..

%MSVC_PATH% obs-studio.sln /nologo /nr:false /m /p:Configuration=%build_config%

cd ..
