[environment]::setenvironmentvariable('GIT_SSH', (resolve-path (scoop which ssh)), 'USER')
scoop install 7zip openssh git curl innounp dark wixtoolset
scoop bucket rm nsis
scoop bucket add nsis https://github.com/NSIS-Dev/scoop-nsis
scoop install nsis/nsis