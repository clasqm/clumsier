@echo off
REM This is very clumsy, I know (pun intended)
REM I'm better at shell scripts than batch files these days
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
    echo creating directories ...
    mkdir %FBC%\clumsier > NUL
    mkdir %FBC%\clumsier\prj > NUL
    mkdir %FBC%\clumsier\src > NUL
REM     mkdir %FBC%\clumsier\fbkotd > NUL
    echo copying files ...
    move /y clumsier.exe %FBC%\clumsier
    move /y clumsy.cfg %FBC%\clumsier
    copy /y *.bas %FBC%\clumsier\src
    copy /y *.bat %FBC%\clumsier\src
    copy /y prj\*.* %FBC%\clumsier\prj
    move /y fbeauty.exe c:\fdos\bin
REM     copy /y fbkotd\*.* %FBC%\clumsier\fbkotd
    echo Creating launcher script ...
    echo @ECHO OFF > clumsier.bat
    echo C: >> clumsier.bat
    echo cd %FBC%\clumsier >> clumsier.bat
    echo clumsier.exe $1 $2 $3 $4 $5 $6 $7 $8 $9 >> clumsier.bat
    echo Moving script to directory on PATH ...
    if exist c:\fdos\bin\format.exe move /y clumsier.bat c:\fdos\bin
    if not exist c:\fdos\bin\format.exe goto NOTFREEDOS
    goto END
:ERROR
    echo The FreeBASIC compiler was not found in any of the usual places.
    echo You can still install CLUMSIER manually. Just open this batch
    echo file and see what it does. It's not that complicated.
    goto END
:NOTFREEDOS
    echo.
    echo Your PATH: %PATH%
    set /p PDIR=Which directory of these?
    move /Y clumsier.bat %PDIR%
    goto END
:END
