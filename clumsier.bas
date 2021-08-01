' clumsy is an elementary FreeBASIC IDE for console - beta version
' Copyright (C) 2020 Luca Evangelisti
' <https://github.com/lucaevangelisti/clumsy>

' This program is free software: you can redistribute it and/or modify
' it under the terms of the GNU General Public License as published by
' the Free Software Foundation, either version 3 of the License, or
' (at your option) any later version.

' This program is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' GNU General Public License for more details.

' You should have received a copy of the GNU General Public License
' along with this program.  If not, see <https://www.gnu.org/licenses/>.

' Contact: <luca.evangelisti.67@gmail.com>
' Adapted for FreeDOS by clasqm, 2021

#INCLUDE "dir.bi" ''library for working with directories
#INCLUDE "clumsyer.bas"
#INCLUDE "clumsypr.bas"
#INCLUDE "clumsyfi.bas"

''arrays
DIM configuration_file() AS STRING
DIM code_array() AS STRING
'DIM keywords() AS STRING

''variables
DIM SHARED AS INTEGER UnsavedChanges
UnsavedChanges = 0
DIM AS STRING info = ""
DIM SHARED cfgfile AS STRING
cfgfile = "clumsy.cfg"
#IFDEF __FB_DOS__
    DIM AS STRING project_path = "prj\"
#ELSE
    DIM AS STRING project_path = "prj/"
#ENDIF
DIM AS STRING file_name = ""
DIM AS STRING source_file_extension = ".bas"
DIM AS INTEGER choice = 0
DIM AS LONG key ''key entered
DIM AS INTEGER scrolling = 0
DIM AS INTEGER row = 1
DIM AS INTEGER col = 1
DIM AS STRING code_line = ""

''procedures
DECLARE SUB initializes_console()
DECLARE SUB menu()
DECLARE SUB read_data()
DECLARE SUB SaveSourceFile(file_name AS STRING, project_path AS STRING, _
    source_file_extension AS STRING, code_array() AS STRING, _
    row AS INTEGER, col AS INTEGER, scrolling AS INTEGER)
DECLARE FUNCTION get_max_rows() AS INTEGER
DECLARE FUNCTION get_viewprint_rows() AS INTEGER
DECLARE FUNCTION get_max_cols() AS INTEGER
DECLARE SUB update_configuration_file(configuration_file() AS STRING)
DECLARE SUB come_back(project_path AS STRING, _
              file_name AS STRING, _
              source_file_extension AS STRING, _
              code_array() AS STRING)
DECLARE SUB clumsy_cover()
DECLARE SUB tabulation(code_array() AS STRING, _
               scrolling AS INTEGER)
DECLARE SUB fbkotd()
DECLARE SUB prettify(project_path AS STRING, file_name AS STRING, _
    source_file_extension AS STRING)
DECLARE SUB make_backup(project_path AS STRING, file_name AS STRING, _
    source_file_extension AS STRING)

''start program
initializes_console()
clumsy_cover()

''initializes code_array
REDIM PRESERVE code_array(1 TO 1)
code_array(1) = ""

''initializes configuration_file
REDIM PRESERVE configuration_file(1 TO 1, 1 TO 2)
configuration_file(1,1) = "FreeBASIC compiler path"
configuration_file(1,2) = "none"

''main loop
DO
    key = GETKEY
    ' key substitutions
    IF key = 14 THEN key = 15359 ' ^N to F1
    IF key = 15 THEN key = 15615 ' ^O to F2
    IF key = 19 THEN key = 15871 ' ^S to F3
    IF key = 26 THEN key = 16127 ' ^Z to F4
    IF key = 18 THEN key = 16383 ' ^R to F5
    IF key = 24 THEN key = 16639 ' ^X to F6
    'IF key = 3  THEN key = 16895 ' ^C to F7  - deprecated CTRL-C crashes
    IF key = 22 THEN key = 17151 ' ^V to F8
    'IF key = 8  THEN key = 17407 ' ^H to F9  - deprecated: backspace and 
												'CTRL-H have the same scancode. Who knew?
    IF key = 16 THEN key = 17663 ' ^P to f10
    IF key = 6  THEN key = 17919 ' ^F to f11
    IF key = 2 THEN key = 18175  ' ^B to f12
    IF key = 17 THEN key = 27    ' ^Q to ESC

    IF key > 255 THEN ''cursor keys
        key = key SHR 8 ''shifts the bits to the right
        SELECT CASE key
        ' ********************** F1 new source file************************
            CASE 59
                IF UnsavedChanges THEN
                    CLS 2
                    DIM AS STRING answer2 = ""
                    PRINT
                    INPUT "You have unsaved changes! Save them first? (y/n)"; answer2
                    IF UCASE(answer2) = "Y" THEN
                        SaveSourceFile(file_name, project_path, _
                            source_file_extension, code_array(), _
                            row, col, scrolling)
                    'come_back(project_path, file_name, source_file_extension, _
                    '    code_array())
                    ENDIF
                ENDIF
                CLS 2
                LOCATE 1, 1, 1
                REDIM code_array(1 TO 1)
                code_array(1) = ""
                file_name = ""
                UnsavedChanges = 0
        ' ***************************F2 open source file****************
            CASE 60
                IF UnsavedChanges THEN
                    CLS 2
                    DIM AS STRING answer2 = ""
                    PRINT
                    INPUT "You have unsaved changes! Save them first? (y/n)"; answer2
                    IF UCASE(answer2) = "Y" THEN
                        SaveSourceFile(file_name, project_path, _
                            source_file_extension, code_array(), _
                            row, col, scrolling)
                    'come_back(project_path, file_name, source_file_extension, _
                    '    code_array())
                    ENDIF
                ENDIF
                CLS 2
                LOCATE 1, 1, 1
                #IFDEF __FB_DOS__
                    PRINT "Source codes list (in prj\*.bas):"
                #ELSE
                    PRINT "Source codes list (in prj/*.bas):"
                #ENDIF
                PRINT ""
                IF list_files(project_path +"*.bas", fbArchive) > 0 THEN
                    PRINT ""
                    INPUT "Insert file name without extension: ", file_name
                    IF file_name <> "" THEN
                        reads_code_ascii_file(project_path & file_name & _
                            source_file_extension, _
                            code_array(), get_max_cols())
                        scrolling = 0
                        prints_code (1, 1, code_array(), _
                        get_viewprint_rows(), scrolling)
                        UnsavedChanges = 0
                    ELSE
                        CLS 2
                    END IF
                ELSE
                    PRINT "No source files detected . . ."
                END IF
        ' **********************F3 save source file***********************
            CASE 61
                SaveSourceFile(file_name, project_path, _
                    source_file_extension, code_array(), _
                    row, col, scrolling)
        ' ************************F4 configuration***********************
            CASE 62
                reads_configuration_file(cfgfile, _
                configuration_file())
                update_configuration_file(configuration_file())
                come_back(project_path, file_name, source_file_extension, _
                    code_array())
        ' ************F5 compile source code and run executable***********
            CASE 63
                IF UnsavedChanges THEN
                    CLS 2
                    DIM AS STRING answer2 = ""
                    PRINT
                    INPUT "You have unsaved changes! Save them first? (y/n)"; answer2
                    IF UCASE(answer2) = "Y" THEN
                        SaveSourceFile(file_name, project_path, _
                            source_file_extension, code_array(), _
                            row, col, scrolling)
                    'come_back(project_path, file_name, source_file_extension, _
                    '    code_array())
                    ENDIF
                'EXIT SELECT
                ENDIF
                IF file_name <> "" THEN
                    IF reads_configuration_file(cfgfile, _
                        configuration_file()) = true THEN
                        CLS 2
                        EXEC(configuration_file(1, 2), project_path & _
                            file_name & source_file_extension)
                        IF CHR(SCREEN(1,1)) = " " THEN
                            EXEC(project_path & file_name, "")
                        END IF
                        come_back(project_path, file_name, source_file_extension, _
                            code_array())
                    ELSE
                        update_configuration_file(configuration_file())
                        come_back(project_path, file_name, source_file_extension, _
                            code_array())
                    END IF
                    UnsavedChanges = 0
                ELSE
                    CLS 2
                    PRINT "There isn't a source file to compile!"
                    PRINT "You must first write some code and save it."
                    come_back(project_path, file_name, source_file_extension, _
                        code_array())
                END IF
        ' ***********F6 cut the line where the cursor is located*********
            CASE 64
                code_line = cut_line(CSRLIN, code_array(), _
                    get_viewprint_rows(), scrolling)
                UnsavedChanges = 1
        ' ********F7 copy the line where the cursor is located***********
            CASE 65
                code_line = copy_line(CSRLIN, POS, code_array(), _
                    get_viewprint_rows(), scrolling)
        ' *******F8 paste selected line where the cursor is located*******
            CASE 66
                paste_line(CSRLIN, code_array(), get_viewprint_rows(), _
                    scrolling, code_line)
                UnsavedChanges = 1
        ' ***************************F9 help*****************************
            CASE 67
                IF UnsavedChanges THEN
                    CLS 2
                    DIM AS STRING answer2 = ""
                    PRINT
                    INPUT "You have unsaved changes! Save them first? (y/n)"; answer2
                    IF UCASE(answer2) = "Y" THEN
                        SaveSourceFile(file_name, project_path, _
                            source_file_extension, code_array(), _
                            row, col, scrolling)
                    'come_back(project_path, file_name, source_file_extension, _
                    '    code_array())
                    ENDIF
                ENDIF
                RESTORE HELP
                read_data()
                DIM AS STRING answer = ""
                PRINT
                INPUT "Do you want to read the License (Y/N)"; answer
                IF UCASE(answer) = "Y" THEN
                    RESTORE LICENSE
                    read_data()
                END IF
                come_back(project_path, file_name, source_file_extension, _
                    code_array())
        ' ********* F10 prettify *********
            CASE 68
                IF UnsavedChanges THEN
                CLS 2
                DIM AS STRING answer2 = ""
                PRINT
                INPUT "You have unsaved changes! Save them first? (y/n)"; answer2
                IF UCASE(answer2) = "Y" THEN
                    SaveSourceFile(file_name, project_path, _
                        source_file_extension, code_array(), _
                        row, col, scrolling)
                ENDIF
            ENDIF
            prettify(project_path, file_name, source_file_extension)
            come_back(project_path, file_name, source_file_extension, _
                code_array())
        ' ********* F11 FB Keyword of the day - linux only *********
        REM strange delay when implementing THIS in dos - perhaps the
        REM filesystem IS NOT up TO it. Anyway, I have more important
        REM things TO worry about RIGHT now.
            CASE 69
                #IFDEF __FB_DOS__
                    ' do nothing
                #ELSE
                    IF UnsavedChanges THEN
                        CLS 2
                        DIM AS STRING answer2 = ""
                        PRINT
                        INPUT "You have unsaved changes! Save them first? (y/n)"; answer2
                        IF UCASE(answer2) = "Y" THEN
                            SaveSourceFile(file_name, project_path, _
                                source_file_extension, code_array(), _
                                row, col, scrolling)
                        ENDIF
                    ENDIF
                    fbkotd()
                    come_back(project_path, file_name, source_file_extension, _
                        code_array())
                #ENDIF
        ' ********* F12 make a backup *********
            CASE 70
                IF UnsavedChanges THEN
					CLS 2
					DIM AS STRING answer2 = ""
					PRINT
					INPUT "You have unsaved changes! Save them first? (y/n)"; answer2
					IF UCASE(answer2) = "Y" THEN
						SaveSourceFile(file_name, project_path, _
							source_file_extension, code_array(), _
							row, col, scrolling)
					ENDIF
				ENDIF
				make_backup(project_path, file_name, source_file_extension)
				come_back(project_path, file_name, source_file_extension, _
					code_array())
        '' ***********************Cursor movement*************************
            CASE 71 ''home
                LOCATE CSRLIN, 1
            CASE 72 ''up
                moves_cursor(CSRLIN, POS, -1, 0, code_array(), _
                    get_viewprint_rows, scrolling)
            CASE 73 ''page up
                ''up x 12
                FOR i AS INTEGER = 1 TO 12
                    moves_cursor(CSRLIN, POS, -1, 0, code_array(), _
                        get_viewprint_rows, scrolling)
                    NEXT i
            CASE 79 ''end
                LOCATE CSRLIN, LEN(code_array(CSRLIN + scrolling)) + 1
            CASE 80 ''down
                moves_cursor(CSRLIN, POS, 1, 0, code_array(), _
            get_viewprint_rows, scrolling)
            CASE 81 ''page down
                ''down x 12
                FOR i AS INTEGER = 1 TO 12
                    moves_cursor(CSRLIN, POS, 1, 0, code_array(), _
              get_viewprint_rows, scrolling)
                NEXT i
            CASE 77 ''right
                IF POS = LEN(code_array(CSRLIN + scrolling)) + 1 AND _
                    CSRLIN + scrolling < UBOUND (code_array) THEN
                    ''down
                    moves_cursor(CSRLIN, 1, 1, 0, code_array(), _
                        get_viewprint_rows, scrolling)
                ELSE
                    ''right
                    moves_cursor(CSRLIN, POS, 0, 1, code_array(), _
               get_viewprint_rows, scrolling)
                END IF
            CASE 75 ''left
                IF POS = 1 AND CSRLIN + scrolling > 1 THEN
                    ''up
                    moves_cursor(CSRLIN, _
                        LEN(code_array(CSRLIN + scrolling - 1)) + 1, _
                        -1, 0, code_array(), _
                        get_viewprint_rows, scrolling)
                ELSE
                    'left
                    moves_cursor(CSRLIN, POS, 0, -1, code_array(), _
                        get_viewprint_rows, scrolling)
                END IF
            CASE 83 ''delete
                deletes_key(CSRLIN, POS, code_array(), _
                    get_viewprint_rows(), scrolling)
            CASE ELSE
            ''none
        END SELECT
    ELSE ''ASCII extended
        SELECT CASE key
            CASE 3 ''Ctrl+C
                PRINT "Ctrl+C"
            CASE 32 TO 126 ''printable characters
                puts_key(get_viewprint_rows(), get_max_cols(), CSRLIN, POS, _
                    key, code_array(), scrolling)
            CASE 128 TO 255 ''extended ASCII characters
                ''not used in console mode
        ' **************************Editing keys*************************
            CASE 8 ''backspace
                erases_key(CSRLIN, POS, code_array(), _
                    get_viewprint_rows(), scrolling)
            CASE 9 ''tab
                FOR i AS INTEGER = 1 TO 2
                    tabulation(code_array(), scrolling)
                NEXT i
            CASE 13 ''carriage return
                new_line(get_viewprint_rows(), get_max_cols(), CSRLIN, POS, _
                    code_array(), scrolling)
        ' ************************<Esc> quit*****************************
            CASE 27
                IF UnsavedChanges THEN
                    CLS 2
                    DIM AS STRING answer2 = ""
                    PRINT
                    INPUT "You have unsaved changes! Save them first? (y/n)"; answer2
                    IF UCASE(answer2) = "Y" THEN
                        SaveSourceFile(file_name, project_path, _
                            source_file_extension, code_array(), _
                            row, col, scrolling)
                    'come_back(project_path, file_name, source_file_extension, _
                    '    code_array())
                    ENDIF
                ENDIF
                CLS 2
                info = "Thanks for coding with clumsier! :-)"
                ''centers the message
                LOCATE CINT(get_viewprint_rows() / 2), _
                CINT((get_max_cols() - LEN(info)) / 2)
                PRINT info
                SLEEP 3000, 1
                CLS 0 ''clears the entire screen
                #IFDEF __FB_DOS__
                    SHELL "cls"
                #ELSE
                    SHELL "clear"
                #ENDIF
                EXIT DO
            CASE ELSE
            ''none
        END SELECT
        UnsavedChanges = 1
    END IF
  ''to avoid unwanted or repeated characters,
  ''this loop works until the inkey buffer is empty
  WHILE INKEY <> "": WEND
LOOP
'PROGRAM ENDS HERE - SYSTEM OR END STATEMENT NOT REQUIRED

''tabulation
SUB tabulation(code_array() AS STRING, _
   scrolling AS INTEGER)
    puts_key(get_viewprint_rows(), get_max_cols(), CSRLIN, POS, _
        32, code_array(), scrolling)
END SUB

''initializes console
SUB initializes_console()
    CLS 0
    SCREEN 0 ''console-mode functionality
    ''console mode color
    COLOR 15, 0 ''text white, background black
    ''menu
    menu()
    ''console mode color
    COLOR 0, 15 ''text black, background white
    CLS 2 ''clear only the text viewport
END SUB

''menu
SUB menu()
    CLS 0 ''clears the entire screen
    ''footer info
    LOCATE get_max_rows() - 1, 1
    PRINT "<F1> New | <F2> Open | <F3>Save   | <F4> Config | <F5> Run"
    LOCATE get_max_rows(), 1
    PRINT "<F6> Cut | <F7> Copy | <F8> Paste | <F9> Help   | <Esc> Quit";
    ''sets the printable area of the console screen
    VIEW PRINT 1 TO (get_viewprint_rows())
END SUB

''max number of rows
FUNCTION get_max_rows() AS INTEGER
    RETURN HIWORD(WIDTH)
END FUNCTION

''max nomber of viewprint rows
FUNCTION get_viewprint_rows() AS INTEGER
    RETURN get_max_rows() - 2
END FUNCTION

''max number of columns
FUNCTION get_max_cols() AS INTEGER
    RETURN LOWORD(WIDTH)
END FUNCTION

''update configuration file
SUB update_configuration_file(configuration_file() AS STRING)
    DIM AS STRING answer = ""
    CLS 2
    PRINT configuration_file(1,1) & ": " & configuration_file(1,2)
    PRINT ""
    PRINT "You can change the FreeBASIC compiler path."
    PRINT ""
    INPUT "Do you want change it (Y/N)"; answer
    PRINT ""
    IF UCASE(answer) = "Y" THEN
        INPUT "Insert new path: ", configuration_file(1,2)
        writes_configuration_ascii_file(cfgfile, _
            configuration_file())
    END IF
END SUB

''come back
SUB come_back(project_path AS STRING, _
    file_name AS STRING, _
    source_file_extension AS STRING, _
    code_array() AS STRING)
    PRINT "------------------"
    PRINT ""
    PRINT "Press any key to return . . ."
    IF GETKEY THEN
        CLS 2
        IF file_name <> "" THEN
            reads_code_ascii_file(project_path & file_name & _
                source_file_extension, code_array(), _
                get_max_cols())
        END IF
    END IF
    initializes_console()
    prints_code (1, 1, code_array(), get_viewprint_rows(), 0)
END SUB

SUB clumsy_cover()
    RESTORE COVER
    read_data()
    IF GETKEY THEN CLS 2
END SUB

SUB SaveSourceFile(file_name AS STRING, project_path AS STRING, _
    source_file_extension AS STRING, code_array() AS STRING, _
    row AS INTEGER, col AS INTEGER, scrolling AS INTEGER)
    IF file_name = "" THEN
        CLS 2
        LOCATE 1, 1, 1
        INPUT "Insert file name without extension (e.g. prj1): ", _
            file_name
        IF file_name = "" THEN file_name = "untitled"
        #IFDEF __FB_DOS__
            IF LEN(file_name) > 8 THEN file_name = left(file_name, 8)
        #ENDIF
    END IF
    writes_ascii_file(project_path & file_name & _
        source_file_extension, code_array())
    row = CSRLIN
    col = POS
    message("... file saved!", 1000)
    reads_code_ascii_file(project_path & file_name & _
        source_file_extension, code_array(), _
        get_max_cols())
    prints_code (row, col, code_array(), _
    get_viewprint_rows(), scrolling)
    UnsavedChanges = 0
END SUB

SUB read_data()
    DIM display AS STRING = ""
    CLS 2
    DO
        READ display
        IF display = "end_of_data" THEN EXIT DO
        PRINT display
    LOOP
END SUB

SUB fbkotd()
    RANDOMIZE TIMER
    #IFDEF __FB_DOS__
        DIM AS STRING fbkotd_path = "fbkotd\"
        SHELL("dir /b " + fbkotd_path + " > fbkotd.txt")
    #ELSE
        DIM AS STRING fbkotd_path = "fbkotd/"
        SHELL("ls -p ./" + fbkotd_path + " | grep -v / > fbkotd.txt")
    #ENDIF
    DIM ff AS INTEGER
    DIM f AS INTEGER
    DIM f_len AS INTEGER
    DIM f_2_open AS STRING
    DIM fbkotd_key AS INTEGER
    DIM display_this AS STRING
    ff = FREEFILE
    OPEN "fbkotd.txt" FOR INPUT AS #ff
        WHILE NOT EOF(ff)
            LINE INPUT #ff, f_2_open
            f_len = f_len +1
        WEND
    CLOSE #ff
    KILL("fbkotd.txt")
    f_len = INT(RND * f_len) + 1
    f_2_open = fbkotd_path + STR(f_len)
    ff = FREEFILE
    OPEN f_2_open FOR INPUT AS #ff
    CLS 0
    PRINT "Press ESC to get back to programming, any other key to page down."
    PRINT "Loading ........"
    SLEEP 2000, 1
    CLS 0
    DO
        WHILE NOT EOF(ff)
            FOR f = 1 TO get_max_rows() - 1
                LINE INPUT #ff, display_this
                PRINT display_this
            NEXT f
            SLEEP
            fbkotd_key=GETKEY
            IF fbkotd_key = 27 OR EOF(ff)THEN
                CLOSE #ff
                EXIT DO
            ENDIF
        'WHILE INKEY <> "": WEND
        WEND
    LOOP
END SUB

SUB make_backup(project_path AS STRING, file_name AS STRING, _
    source_file_extension AS STRING)
    DIM file1 AS STRING
    DIM file2 AS STRING
    DIM dothis AS STRING
    file1= project_path + file_name + source_file_extension
    file2= project_path + file_name + ".bkp"
    CLS 2
    #IFDEF __FB_DOS__
        dothis= "copy /y " + file1 + " " + file2 + " > NUL"
    #ELSE
        dothis= "cp -f " + file1 + " " + file2
    #ENDIF
    SHELL dothis
    PRINT "backup file " + file2 + " has been created"
    PRINT
END SUB

SUB prettify(project_path AS STRING, file_name AS STRING, _
    source_file_extension AS STRING)
    DIM file1 AS STRING
    DIM file2 AS STRING
    DIM dothis AS STRING
    file1= project_path + file_name + source_file_extension
    file2= project_path + "1x2y3z.tmp"
    CLS 2
    #IFDEF __FB_DOS__
        dothis = "copy /y " + file1 + " " + file2 + " > NUL"
        SHELL dothis
        dothis = "fbeauty.exe < " + file2 + " > " + file1
        SHELL dothis
        dothis = "del " + file2 + " > NUL"
        SHELL dothis
    #ELSE
        dothis= "cp -f " + file1 + " " + file2 + " && fbeauty < " _
            + file2 + " > " + file1 + " && rm -f " + file2
        SHELL dothis
    #ENDIF
    PRINT "All FreeBASIC keywords changed to UPPER CASE"
    PRINT
END SUB

COVER:
DATA "       _             _       "
DATA "   ___| |_   _ _ __ ___  ___(_) ___ _ __ "
DATA "  / __| | | | | '_ ` _ \/ __| |/ _ \ '__|"
DATA " | (__| | |_| | | | | | \__ \ |  __/ |   "
DATA "  \___|_|\__,_|_| |_| |_|___/_|\___|_|   "
DATA " "
DATA "  CLUMSIER is a lighweight FreeBASIC IDE for the"
DATA "  console on Linux and FreeDOS."
DATA " "
DATA "  Copyright (c) 2021 Michel Clasquin-Johnson."
DATA "  Based on CLUMSY (c) Luca Evangelisti 2020"
DATA "  and FBeauty (c) Thomas Freiherr 2020."
DATA "  GNU General Public License version 3."
DATA "  FreeDOS manual:  GFDL license."
DATA " _________________________________________________"
DATA " "
DATA "  Press any key to continue . . ."
DATA "end_of_data"

HELP:
DATA "CLUMSIER Help"
DATA " "
DATA "<F1> or ^N  - New source file"
DATA "<F2> or ^O  - Open source file"
DATA "<F3> or ^S  - Save source file"
DATA "<F4> or ^Z  - Configuration"
DATA "<F5> or ^R  - Compile source code and run executable file"
DATA "<F6> or ^X  - Cut the line where the cursor is located"
DATA "<F7>   " + "     - Copy the line where the cursor is located"
DATA "              (CTRL-C does not work, sorry)"
DATA "<F8> or ^V  - Paste the line that was selected with F6 or F7"
DATA "<F9>        - Help"
DATA "F10> or ^P  - Prettify source code (capitalize keywords)"
#IFDEF __FB_DOS__
    DATA "F11> or ^F  - Not used in DOS version"
#ELSE
    data "F11> or ^F  - Random FreeBASIC Keyword of the day"
#ENDIF
DATA "F12> or ^B  - Make a backup"
DATA "<Esc> or ^Q - Quit program"
DATA "end_of_data"

LICENSE:
DATA "CLUMSIER is a lightweight FreeBASIC IDE for the console"
DATA "for FreeDOS and Linux. (c) Michel Clasquin-Johnson 2021."
DATA "Based on CLUMSY (c) Luca Evangelisti 2020,"
DATA "and FBeauty (c) Thomas Freiherr 2020."
DATA "FreeDOS manual used in FBKOTD function: GFDL license."
DATA " "
DATA "This program is free software: you can redistribute it and/or modify"
DATA "it under the terms of the GNU General Public License AS published by"
DATA "the Free Software Foundation, either version 3 of the License, or"
DATA "(at your option) any later version."
DATA " "
DATA "This program is distributed in the hope that it will be useful, but"
DATA "WITHOUT ANY WARRANTY; without even the implied warranty of"
DATA "MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. See the"
DATA "GNU General Public License for more details."
DATA "You should have received a copy of the GNU General Public License"
DATA "along with this program. If not, see <https://www.gnu.org/licenses/>."
DATA " "
DATA "Contact: <clasqm@gmail.com>"
DATA "end_of_data"
