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

DECLARE FUNCTION check_error(error_code AS LONG) AS STRING

FUNCTION check_error(error_code AS LONG) AS STRING
    DIM e AS STRING
    SELECT CASE error_code
        CASE 0
            e = "no error"
        CASE 1
                  e = "Illegal function call"
        CASE 2
            e = "File not found"
        CASE 3
            e = "File I/O error"
        CASE 4
            e = "Out of memory"
        CASE 5
            e = "Illegal resume"
        CASE 6
            e = "Out of bounds array access"
        CASE 7
            e = "Null Pointer Access"
        CASE 8
            e = "No privileges"
        CASE 9
            e = "Interrupted signal"
        CASE 10
            e = "Illegal instruction signal"
        CASE 11
            e = "Floating point error signal"
        CASE 12
            e = "Segmentation violation signal"
        CASE 13
            e = "Termination request signal"
        CASE 14
            e = "Abnormal termination signal"
        CASE 15
            e = "Quit request signal"
        CASE 16
            e = "Return without gosub"
        CASE 17
            e = "End of file"
    END SELECT
RETURN e
END FUNCTION
