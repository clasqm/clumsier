@echo off
echo This will uninstall all of CLUMSIER, except for any programs you 
echo may have written with it.
echo You will find those files in the directory CLUMSIER\PRJ within
echo your FreeBASIC directory structure, so you can move them somewhere
echo else where another IDE will find them.
echo.
echo Searching for FreeBASIC ...
    set FBC=NUL
    if exist c:\fbc\fbc.exe set FBC=c:\fbc
    if exist c:\devel\fbc\fbc.exe set FBC=c:\devel\fbc
    if exist c:\fdos\devel\fbc\fbc.exe set FBC=c:\fdos\devel\fbc
    if exist c:\dev\fbc\fbc.exe set FBC=c:\dev\fbc
    if exist c:\fdos\dev\fbc\fbc.exe set FBC=c:\fdos\dev\fbc
    if exist c:\msdos\devel\fbc\fbc.exe set FBC=c:\msdos\devel\fbc
    if exist c:\msdos\dev\fbc\fbc.exe set FBC=c:\msdos\dev\fbc
    if exist c:\dos\devel\fbc\fbc.exe set FBC=c:\dos\devel\fbc
    if exist c:\dos\dev\fbc\fbc.exe set FBC=c:\dos\dev\fbc
    if %FBC%==NUL goto ERROR
:MAIN
    delete /y %FBC%\clumsier\clumsier.exe
    delete /y %FBC%\clumsier\clumsy.cfg
    delete /y %FBC%\clumsier\src\*.*
    rmdir /y %FBC%\clumsier\src
    delete /y c:\fdos\bin\fbeauty.exe
    if not exist c:/fdos/bin/clumsier.bat goto NOTFREEDOS
    if exist c:/fdos/bin/clumsier.bat delete /y c:/fdos/bin/clumsier.bat
    GOTO END
:ERROR
    echo.
    echo The FreeBASIC compiler was not found in any of the usual places.
    echo You can still uninstall CLUMSIER manually. Just open this batch
    echo file and see what it does. It's not that complicated. 
    goto END
:NOTFREEDOS
    echo.
    echo Uninstallation finished. All you need to do manually is to find
    echo the CLUMSIER.BAT file somewhere in your PATH and delete it.
    echo.
    echo Your PATH: %PATH%
    echo.
:END
