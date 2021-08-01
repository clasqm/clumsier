@echo off
REM This is very clumsy, I know (pun intended)
REM I'm better at shell scripts than batch files these days
    REM find fbc
    set FBC=NUL
    if exist c:\fbc\fbc.exe set FBC=c:\fbc\fbc.exe
    if exist c:\devel\fbc\fbc.exe set FBC=c:\devel\fbc\fbc.exe
    if exist c:\fdos\devel\fbc\fbc.exe set FBC=c:\fdos\devel\fbc\fbc.exe
    if exist c:\dev\fbc\fbc.exe set FBC=c:\dev\fbc\fbc.exe
    if exist c:\fdos\dev\fbc\fbc.exe set FBC=c:\fdos\dev\fbc\fbc.exe
    if exist c:\msdos\devel\fbc\fbc.exe set FBC=c:\msdos\devel\fbc\fbc.exe
    if exist c:\msdos\dev\fbc\fbc.exe set FBC=c:\msdos\dev\fbc\fbc.exe
    if exist c:\dos\devel\fbc\fbc.exe set FBC=c:\dos\devel\fbc\fbc.exe
    if exist c:\dos\dev\fbc\fbc.exe set FBC=c:\dos\dev\fbc\fbc.exe
    if %FBC%==NUL goto ERROR
:MAIN
    echo This will compile CLUMSIER
    echo.
    echo Compiling clumsier ...
    %FBC%  -v -x clumsier.exe clumsier.bas
    echo.
    echo.
    echo compiling fbeauty ...
    %FBC% -v -x fbeauty.exe fbeauty.bas
    move fbeauty.exe C:\fdos\bin\
    echo.
    echo Creating configuration file CLUMSY.CFG. Please check this with
    echo F4 once CLUMSIER is up and running.
    echo "FreeBASIC compiler path","%FBC%" > clumsy.cfg
    echo.
    echo You will probably want to move the CLUMSIER
    echo executables somewhere in your PATH now. CLUMSY.CFG needs
    echo to be in the same directory as well, or it will need to be
    echo recreated later. The easiest way to achive this is to use
    echo the included INSTALL.BAT
    goto END
:ERROR
    echo FreeBASIC compiler (fbc) not found in any of the usual places
    echo You can still compile CLUMSIER manually. Just open this batch
    echo file and see what it does. It's not that complicated. 
:END
