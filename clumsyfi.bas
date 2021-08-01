/'
clumsy is an elementary FreeBASIC IDE for console - beta version
Copyright (C) 2020 Luca Evangelisti
<https://github.com/lucaevangelisti/clumsy>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

Contact: <luca.evangelisti.67@gmail.com>
'/

''function for reading configuration ASCII file
DECLARE FUNCTION reads_configuration_file(file_name AS STRING, _
    text_file_array() AS STRING) _
     AS boolean
''subroutine for writing configuration ASCII file
DECLARE SUB writes_configuration_ascii_file(file_name AS STRING, _
    text_file_array() AS STRING)
''subroutine for reading code ASCII file
DECLARE SUB reads_code_ascii_file(file_name AS STRING, _
    text_file_array() AS STRING, _
     max_cols AS INTEGER)
''subroutine for writing ASCII file
DECLARE SUB writes_ascii_file(file_name AS STRING, _
    text_file_array() AS STRING)
''function for viewing files list in a specified directory
DECLARE FUNCTION list_files(BYREF filespec AS STRING, _
    BYVAL attrib AS INTEGER) AS INTEGER

''subroutine for reading configuration ASCII file
FUNCTION reads_configuration_file(file_name AS STRING, _
    text_file_array() AS STRING) _
    AS boolean
    DIM i AS INTEGER
    DIM file_number AS LONG
    file_number = FREEFILE
    OPEN file_name FOR INPUT  ENCODING "ascii" AS #file_number
    DIM error_type AS STRING
    error_type = check_error(ERR)
    IF error_type = "no error" THEN
        i = 0
        DO
            i += 1
            REDIM PRESERVE text_file_array(1 TO i, 1 TO 2)
            INPUT #file_number, text_file_array(i, 1), text_file_array(i, 2)
        LOOP UNTIL EOF(file_number)
        CLOSE #file_number
        RETURN true
    ELSE
        CLS 2
        PRINT "Attempt to read configuration file . . ."
        PRINT ""
        PRINT error_type
        PRINT ""
        PRINT "------------------"
        PRINT ""
        PRINT "Press any key to continue . . ."
        IF GETKEY THEN
            CLS 2
            LOCATE 1, 1
            RETURN false
        END IF
    END IF
END FUNCTION

''subroutine for writing configuration ASCII file
SUB writes_configuration_ascii_file(file_name AS STRING, _
    text_file_array() AS STRING)
    DIM file_number AS LONG
    file_number = FREEFILE
    OPEN file_name FOR OUTPUT ENCODING "ascii" AS #file_number
    DIM error_type AS STRING
    error_type = check_error(ERR)
    IF error_type = "no error" THEN
        CLS 2
        FOR i AS INTEGER = 1 TO UBOUND(text_file_array)
            WRITE #file_number, text_file_array(1, 1), text_file_array(1, 2)
        NEXT i
        CLOSE #file_number
    ELSE
        PRINT error_type
        PRINT ""
        PRINT "------------------"
        PRINT ""
        PRINT "Press any key to continue . . ."
        IF GETKEY THEN
            CLS 2
            LOCATE 1, 1
         END IF
    END IF
END SUB

''subroutine for reading code ASCII file
SUB reads_code_ascii_file(file_name AS STRING, _
    text_file_array() AS STRING, _
    max_cols AS INTEGER)
    DIM AS INTEGER breack1, breack2
    DIM AS STRING buffer = ""
    DIM i AS INTEGER
    DIM file_number AS LONG
    file_number = FREEFILE
    OPEN file_name FOR INPUT  ENCODING "ascii" AS #file_number
    DIM error_type AS STRING
    error_type = check_error(ERR)
    IF error_type = "no error" THEN
        i = 0
        DO
            breack1 = 1
            breack2 = 1
            i += 1
            REDIM PRESERVE text_file_array(1 TO i)
            LINE INPUT #file_number, text_file_array(i)
             ''line lenght check
            DO UNTIL (LEN(text_file_array(i)) <= max_cols - 1)
                buffer = text_file_array(i)
                breack2 = INSTRREV(MID(buffer, breack1, max_cols - 3), " ")
                text_file_array(i) = _
                MID(buffer, breack1, breack2 - breack1) & " _"
                i += 1
                REDIM PRESERVE text_file_array(1 TO i)
                text_file_array(i) = MID(buffer, breack2)
                breack1 = breack2 
            LOOP
              LOOP UNTIL EOF(file_number)
        CLOSE #file_number
        ELSE
        CLS 2
        PRINT error_type
        PRINT ""
        PRINT "------------------"
        PRINT ""
        PRINT "Press any key to continue . . ."
        IF GETKEY THEN
            CLS 2
            LOCATE 1, 1
         END IF
     END IF
END SUB

''subroutine for writing ASCII file
SUB writes_ascii_file(file_name AS STRING, text_file_array() AS STRING)
    DIM file_number AS LONG
    file_number = FREEFILE
    OPEN file_name FOR OUTPUT ENCODING "ascii" AS #file_number
    FOR i AS INTEGER = LBOUND(text_file_array) TO _
         UBOUND(text_file_array)
        PRINT #file_number, text_file_array(i)
    NEXT i
    CLOSE #file_number
END SUB

''function for viewing files list in a specified directory
FUNCTION list_files(BYREF filespec AS STRING, _
    BYVAL attrib AS INTEGER) AS INTEGER
    DIM AS INTEGER i = 0
    ''Start a file search with the specified filespec/attrib
    ''*AND* get the first filename
    DIM AS STRING filename = DIR(filespec, attrib)
    ''if len(filename) is 0, exit the loop: no more filenames
    ''are left to be read
    DO WHILE LEN(filename) > 0
        i += 1
        PRINT filename & " | ";
        ''search for (and get) the next item matching the initially
        ''specified filespec/attrib
        filename = DIR()
     LOOP
    PRINT ""
    RETURN i
END FUNCTION
