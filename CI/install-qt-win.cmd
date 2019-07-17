@echo off
curl -kLRO https://cdn-fastly.obsproject.com/downloads/Qt_5.10.1.7z -f --retry 5 -C -
7z x Qt_5.10.1.7z -oQt
move Qt C:\QtDep
REM dir C:\QtDep
del Qt_5.10.1.7z