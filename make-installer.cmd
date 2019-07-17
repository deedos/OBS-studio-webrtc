@echo off
mkdir .\release
mkdir .\build\installer\new\core
robocopy .\CI\wininstaller .\build\installer\ /E /PURGE /XF .gitignore
robocopy .\build64\rundir\Release .\build\installer\new\core\ /E /XF .gitignore
copy /y /b .\cmake\winrc\obs-studio.ico .\build\installer\obs-studio.ico
cd .\build\installer
makensis installer.nsi
REM signtool sign /v /f cosmosoftware.pfx /p cosmosoftware /tr http://timestamp.globalsign.com/?signature=sha2 /td sha256 OBS-WebRTC-*Installer.exe
cd ..\..
copy /y /b .\build\installer\OBS-WebRTC-*Installer.exe .\release\
copy /y /b .\build\installer\OBS-WebRTC-*Installer.exe .\release\OBS-WebRTC-Installer.exe
echo Installer is located at %CD%\release\OBS-WebRTC-Installer.exe
