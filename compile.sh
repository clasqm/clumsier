#!/bin/sh
FBC=$(which fbc)
FBEAUTY=$(wich fbeauty)
echo "This will compile CLUMSIER"
echo
if [ -n $FBC ]
    then
        echo Compiling clumsier ...
        $FBC -v clumsier.bas
        echo
        echo
        echo Compiling fbeauty ...
        $FBC -v fbeauty.bas
        echo
        echo
        echo "Creating configuration file CLUMSY.CFG. Please check this with"
        echo "F4 once CLUMSIER is up and running."
        echo "\"FreeBASIC compiler path\",\"$FBC\"" > clumsy.cfg
        echo
        echo "You will probably want to move the CLUMSIER and FBEAUTY"
        echo "executables to somewhere in your PATH now. CLUMSY.CFG needs"
        echo "to be in the same directory as well, or it will need to be"
        echo "recreated later. The easiest way to achive this is to use"
            echo "the included install.sh"
        echo
    else
        echo "FreeBasic Compiler (fbc) not found."
        echo "Be sure that the FreeBASIC compiler (fbc) is in your PATH."
        echo 
        exit 1
    fi
exit 0
