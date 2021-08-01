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

''shows message
DECLARE SUB message(text AS STRING, duration AS INTEGER)
''puts key into code array
DECLARE SUB puts_key(viewprint_rows AS UINTEGER, max_cols AS UINTEGER, _
    row AS INTEGER, col AS INTEGER, key AS LONG, _
    text_file_array() AS STRING, _
    BYREF scrolling AS INTEGER)
''erases key (backspace)
DECLARE SUB erases_key(row AS INTEGER, col AS INTEGER, _
    text_file_array() AS STRING, _
    viewprint_rows AS UINTEGER, _
    BYREF scrolling AS INTEGER)
''deletes key (del)
DECLARE SUB deletes_key(row AS INTEGER, col AS INTEGER, _
    text_file_array() AS STRING, _
    viewprint_rows AS UINTEGER, _
    BYREF scrolling AS INTEGER)
''cut line
DECLARE FUNCTION cut_line(row AS INTEGER, _
    text_file_array() AS STRING, _
    viewprint_rows AS UINTEGER, _
    BYREF scrolling AS INTEGER) AS STRING
''copy line
DECLARE FUNCTION copy_line(row AS INTEGER, _
    col AS INTEGER, _
    text_file_array() AS STRING, _
    viewprint_rows AS UINTEGER, _
    BYREF scrolling AS INTEGER) AS STRING
''paste line
DECLARE SUB paste_line(row AS INTEGER, _
    text_file_array() AS STRING, _
    viewprint_rows AS UINTEGER, _
    BYREF scrolling AS INTEGER, _
    code_line AS STRING)
''inserts new code line into code array
DECLARE SUB new_line(max_rows AS UINTEGER, max_cols AS UINTEGER, _
     row AS INTEGER, col AS INTEGER, _
    text_file_array() AS STRING, _
    BYREF scrolling AS INTEGER)
''moves corsor
DECLARE SUB moves_cursor(row AS INTEGER, col AS INTEGER, _
    inc_row AS INTEGER, inc_col AS INTEGER, _
    text_file_array() AS STRING, _
    viewprint_rows AS UINTEGER, _
    BYREF scrolling AS INTEGER)
''prints code
DECLARE SUB prints_code(row AS INTEGER, col AS INTEGER, _
    text_file_array() AS STRING, _
    viewprint_rows AS UINTEGER, _
    BYREF scrolling AS INTEGER)


'shows message
SUB message(text AS STRING, duration AS INTEGER)
    CLS 2
     LOCATE 1, 1, 1
    PRINT text
    SLEEP duration, 1
END SUB

''puts key into code array
SUB puts_key(viewprint_rows AS UINTEGER, max_cols AS UINTEGER, _
    row AS INTEGER, col AS INTEGER, key AS LONG, _
    text_file_array() AS STRING, _
    BYREF scrolling AS INTEGER)
    IF col < max_cols AND LEN(text_file_array(row + scrolling)) < (max_cols - 1) THEN
        IF col <= LEN(text_file_array(row + scrolling)) THEN
            text_file_array(row + scrolling) = _
            MID(text_file_array(row + scrolling), 1, col - 1) & _
            CHR(key) & MID(text_file_array(row + scrolling), col)
        ELSE
            text_file_array(row + scrolling) = _
            text_file_array(row + scrolling) & CHR(key)
        END IF
        prints_code(row, col + 1, text_file_array(), _
        viewprint_rows, scrolling)
    ELSEIF col = max_cols THEN
        BEEP
    ELSE
        BEEP
    END IF
END SUB

''erases key (backspace)
SUB erases_key(row AS INTEGER, col AS INTEGER, _
    text_file_array() AS STRING, _
    viewprint_rows AS UINTEGER, _
    BYREF scrolling AS INTEGER)
    IF col = 1  AND row > 1 THEN
         col = LEN(text_file_array(row - 1 + scrolling))
        text_file_array(row - 1 + scrolling) = text_file_array(row - 1 + _
            scrolling) + text_file_array(row + scrolling)
        FOR i AS INTEGER = row  + scrolling TO UBOUND(text_file_array) - 1
            text_file_array(i) = text_file_array(i + 1)
        NEXT i
        REDIM PRESERVE text_file_array(1 TO UBOUND(text_file_array) - 1)
        prints_code(row - 1, col + 1, text_file_array(), _
        viewprint_rows, scrolling)
    ELSEIF col = 1 AND row  + scrolling = 1 THEN
        ''none
    ELSE
        text_file_array(row + scrolling) = _
        MID(text_file_array(row + scrolling), 1, col - 2) & _
        MID(text_file_array(row + scrolling), col)
        prints_code(row, col - 1, text_file_array(), _
        viewprint_rows, scrolling)
    END IF
END SUB

''deletes key (del)
SUB deletes_key(row AS INTEGER, col AS INTEGER, _
    text_file_array() AS STRING, _
    viewprint_rows AS UINTEGER, _
    BYREF scrolling AS INTEGER)
    IF LEN(text_file_array(row + scrolling)) = 0 THEN
        IF row + scrolling < UBOUND(text_file_array) THEN
            ''deletes line
            FOR i AS INTEGER = row + scrolling TO UBOUND(text_file_array) - 1
                text_file_array(i) = text_file_array(i +1)
            NEXT i
            REDIM PRESERVE text_file_array(1 TO UBOUND(text_file_array) - 1)
        ELSE
            ''none
        END IF
    ELSEIF col > LEN(text_file_array(row + scrolling)) AND _
        row + scrolling < UBOUND(text_file_array) THEN
        ''scrolls up the lines
        text_file_array(row + scrolling) = _
            text_file_array(row + scrolling) & _
        text_file_array(row + scrolling + 1)
        FOR i AS INTEGER = row + _
            scrolling + 1 TO UBOUND(text_file_array) - 1
            text_file_array(i) = text_file_array(i + 1)
         NEXT i
        REDIM PRESERVE text_file_array(1 TO UBOUND(text_file_array) - 1)
    ELSE
        ''deletes character into the line
        text_file_array(row + scrolling) = _
            MID(text_file_array(row + scrolling), 1, col - 1) & _
            MID(text_file_array(row + scrolling), col + 1) 
    END IF
    prints_code(row, col, text_file_array(), viewprint_rows, scrolling)
END SUB

''cut line
FUNCTION cut_line(row AS INTEGER, _
    text_file_array() AS STRING, _
    viewprint_rows AS UINTEGER, _
    BYREF scrolling AS INTEGER) AS STRING
    DIM AS STRING code_line = ""
    FOR i AS INTEGER = 1 TO UBOUND(text_file_array)
        IF i < row + scrolling THEN
            ''none
        ELSEIF i = row + scrolling THEN
            code_line = text_file_array(i)
            IF i < UBOUND(text_file_array) THEN
                text_file_array(i) = text_file_array(i + 1)
            ELSE
                text_file_array(i) = " "
            END IF
        ELSE ''i > row + scrolling
            IF i < UBOUND(text_file_array) THEN
                text_file_array(i) = text_file_array(i + 1)
            ELSE
                text_file_array(i) = " "
            END IF
        END IF
    NEXT i
    IF UBOUND(text_file_array) > 1 THEN
         REDIM PRESERVE text_file_array(1 TO UBOUND(text_file_array) - 1)
    ELSE
        ''none
    END IF
    ''print code
    IF row + scrolling > UBOUND(text_file_array) THEN
        prints_code(row - 1, 1, text_file_array(), _
        viewprint_rows, scrolling)
    ELSE
        prints_code(row, 1, text_file_array(), _
            viewprint_rows, scrolling)
    END IF
    RETURN code_line
END FUNCTION

''copy line
FUNCTION copy_line(row AS INTEGER, _
    col AS INTEGER, _
    text_file_array() AS STRING, _
    viewprint_rows AS UINTEGER, _
    BYREF scrolling AS INTEGER) AS STRING
    DIM AS STRING code_line = ""
    FOR i AS INTEGER = 1 TO UBOUND(text_file_array)
        IF i = row + scrolling THEN
            code_line = text_file_array(i)
        END IF
    NEXT i
    RETURN code_line
END FUNCTION

''past line
SUB paste_line(row AS INTEGER, _
    text_file_array() AS STRING, _
    viewprint_rows AS UINTEGER, _
    BYREF scrolling AS INTEGER, _
    code_line AS STRING)
    REDIM PRESERVE text_file_array(1 TO UBOUND(text_file_array) + 1)
    FOR i AS INTEGER = UBOUND(text_file_array) TO 1 STEP -1
        IF i > row + scrolling + 1 THEN
            text_file_array(i) = text_file_array(i-1)
        ELSEIF i = row + scrolling + 1 THEN
            text_file_array(i) = text_file_array(i-1)
            text_file_array(i-1) = code_line
        END IF
    NEXT i
     prints_code(row, 1, text_file_array(), viewprint_rows, scrolling)
END SUB

''inserts new code line into code array
SUB new_line(viewprint_rows AS UINTEGER, max_cols AS UINTEGER, _
    row AS INTEGER, col AS INTEGER, _
    text_file_array() AS STRING, _
    BYREF scrolling AS INTEGER)
    IF row + scrolling = UBOUND(text_file_array) AND _
        col > LEN(text_file_array(row)) THEN
        ''last line code
        REDIM PRESERVE text_file_array(1 TO UBOUND(text_file_array) + 1)
        text_file_array(UBOUND(text_file_array)) = ""
     ELSE
        ''insert line
        REDIM PRESERVE text_file_array(1 TO UBOUND(text_file_array) + 1)
        FOR i AS INTEGER = UBOUND(text_file_array) TO _
            (row + 1 +scrolling) STEP -1
            text_file_array(i) = text_file_array(i - 1)
        NEXT i
        text_file_array(row + 1 + scrolling) = _
        MID(text_file_array(row + scrolling), col)      
        text_file_array(row + scrolling) = _
        MID(text_file_array(row + scrolling), 1, col - 1)
    END IF
    ''check scrolling
    IF row = viewprint_rows THEN
        scrolling += 1
    END IF
    ''print
    prints_code(row + 1, 1, text_file_array(), viewprint_rows, scrolling)
END SUB

''moves corsor
SUB moves_cursor(row AS INTEGER, col AS INTEGER, _
    inc_row AS INTEGER, inc_col AS INTEGER, _
    text_file_array() AS STRING, _
    viewprint_rows AS UINTEGER, _
    BYREF scrolling AS INTEGER)
    IF inc_col <> 0 THEN ''horizontal moving
        IF col + inc_col <= LEN(text_file_array(row + scrolling)) THEN
            LOCATE row, col + inc_col
        ELSE
            LOCATE row, LEN(text_file_array(row + scrolling)) + 1
        END IF  
    ELSE ''vertical moving
        IF row + inc_row < 1 AND scrolling > 0 THEN
            ''scroll back
            scrolling -= 1
            IF col <= LEN(text_file_array(row + inc_row + scrolling)) THEN
                prints_code(row, col, _
                text_file_array(), viewprint_rows, scrolling)
            ELSE
                prints_code(row, _
                LEN(text_file_array(row + inc_row + scrolling)) + 1, _
                text_file_array(), viewprint_rows, scrolling)
            END IF
        ELSEIF row + inc_row > viewprint_rows AND _
            scrolling + row + inc_row <= UBOUND (text_file_array) THEN
                ''scroll forward
                scrolling += 1
                IF col <= LEN(text_file_array(row + inc_row + scrolling)) THEN
                    prints_code(row, col, _
                    text_file_array(), viewprint_rows, scrolling)
                ELSE
                    prints_code(row, _
                    LEN(text_file_array(row + inc_row + scrolling)) + 1, _
                    text_file_array(), viewprint_rows, scrolling)
                END IF
        ELSE
            ''scroll inside
            IF row + inc_row + scrolling <= UBOUND(text_file_array) THEN
                IF col <= LEN(text_file_array(row + inc_row + scrolling)) THEN
                    LOCATE row + inc_row, col
                ELSE
                    LOCATE row + inc_row, _
                    LEN(text_file_array(row + inc_row + scrolling)) + 1
                END IF
            ELSE
                LOCATE row, col
            END IF
        END IF
    END IF
END SUB

''prints code
SUB prints_code(row AS INTEGER, col AS INTEGER, _
    text_file_array() AS STRING, _
    viewprint_rows AS UINTEGER, _
    BYREF scrolling AS INTEGER)
    CLS 2
    FOR i AS INTEGER = 1 TO viewprint_rows
        LOCATE i, 1, 1
        IF i + scrolling <= UBOUND(text_file_array) THEN
            PRINT text_file_array(i + scrolling);
        ELSE
            EXIT FOR
        END IF
    NEXT i
    LOCATE row, col
END SUB
