       IDENTIFICATION DIVISION.
       PROGRAM-ID.    dbconnect.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       DATA DIVISION.
       FILE SECTION.
       WORKING-STORAGE SECTION.
           EXEC SQL
               BEGIN DECLARE SECTION
           END-EXEC.
       01  WRK-VARS.
           EXEC SQL END
              DECLARE SECTION
           END-EXEC
      ******** INFORMATION TO CONNECT TO THE DB********************
               05 WRK-UNAME  PIC X(80) VALUE "test".
               05 WRK-PASSWD PIC X(80) VALUE "ouvretoi".
               05 WRK-DB     PIC X(80) VALUE "testdbu".
               05 WRK-HOST   PIC X(80) VALUE "WINSRVCIT:5432".
      *************************************************************

      **************** THE SQLCA FILE MUST BE IN THE DIRECTORY**
           EXEC SQL
                 INCLUDE SQLCA
           END-EXEC.
      ****************************************************************
       PROCEDURE DIVISION.
          MOVE 0 TO SQLCODE
           EXEC SQL
             CONNECT TO            :WRK-DB
                     USER          :WRK-UNAME
                     USING         :WRK-HOST
                     IDENTIFIED BY :WRK-PASSWD
          END-EXEC

          IF SQLCODE EQUAL 0 THEN
             DISPLAY '1- CONNECTION IS OK'
          ELSE
             DISPLAY 'CONNECTION TROUBLE'
             DISPLAY 'SQLCODE = ' SQLCODE '->' SQLERRMC
             GOBACK
          END-IF.

