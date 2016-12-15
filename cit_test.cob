       IDENTIFICATION DIVISION.
       PROGRAM-ID.    TESTSQL.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
       DATA DIVISION.
       FILE SECTION.
      $SET constant coco=cici
       WORKING-STORAGE SECTION.
           EXEC SQL
               BEGIN DECLARE SECTION
           END-EXEC.
       01 CUST-RECORD.
               05 COL-1  PIC X(20).
               05 COL-2  PIC 9(5)V9(5).
               05 COL-3  PIC 9(6)      COMP.
               05 COL-4  PIC X(5000)  USAGE VARRAW.
               05 COL-5  PIC X(50)    USAGE VARCHAR.

      **************** THE SQLCA FILE MUST BE IN THE DIRECTORY**
           EXEC SQL
                 INCLUDE SQLCA
           END-EXEC.

           EXEC SQL END
              DECLARE SECTION
           END-EXEC
      ****************************************************************
       PROCEDURE DIVISION.
           MOVE 0 TO SQLCODE
           PERFORM CONNECT-DB
           PERFORM DROP-TABLE
           PERFORM CREATE-TABLE
           PERFORM POPULATE-DB
           PERFORM READ-DB
           PERFORM READ-DB-DIRECT
           PERFORM READ-DB-DIRECT
           PERFORM DISCONNECT
           EXEC SQL DECLARE 
              SEQTAB CURSOR FOR SELECT COL_1 , COL_2 , COL_3, 
                 COL_4, COL_5  FROM TAB1
           END-EXEC
           GOBACK.
      ****************************************************************
       CONNECT-DB.
      ***** THE COMPLETE CONNECTION SEE THE MANUAL FOR OTHER
         CALL "dbconnect".
      ****************************************************************
       DROP-TABLE.
           DISPLAY '2-  DROP TABLE TAB_1 IF EXIST'
           EXEC SQL
                DROP TABLE TAB1
           END-EXEC
           IF SQLCODE NOT = 0 THEN
              DISPLAY 'SQLCODE = ' SQLCODE '->' SQLERRMC
           END-IF.
      ****************************************************************
       CREATE-TABLE.
           DISPLAY '3-  CREATE TABLE TAB_1'
           EXEC SQL
                CREATE TABLE TAB1
                (
                 COL_1        CHAR(20),  
                 COL_2        NUMERIC(10,5),
                 COL_3        INT,
                 COL_4        BYTEA,
                 COL_5        VARCHAR(50)
                )
           END-EXEC
           IF SQLCODE = 0 THEN
              DISPLAY '   CREATE TABLE OK'
           ELSE
              DISPLAY 'CREATE TABLE TROUBLE'
              DISPLAY 'SQLCODE = ' SQLCODE '->' SQLERRMC
              GOBACK
           END-IF.
      ****************************************************************
       POPULATE-DB.
         MOVE  "ABCDERF"      TO COL-1
         MOVE  1.2345         TO COL-2
         MOVE  12345          TO COL-3
         MOVE  40             TO COL-4-LEN
         MOVE  "1234567890123456789012345678901234567890"   
               TO COL-4-ARR
         MOVE  10             TO COL-5-LEN
         MOVE  "12345678901234567890"   TO COL-5-ARR
         DISPLAY '4-  POPULATE TAB_1. VALUE IS '
                 COL-1' 'COL-2' 'COL-3' '
                 COL-4-LEN' "' COL-4-ARR(1:COL-4-LEN) '" '
                 COL-5-LEN' "' COL-5-ARR(1:COL-5-LEN) '"'
         EXEC SQL
                INSERT into TAB1
                 (
                    COL_1, COL_2, COL_3, COL_4, COL_5
                 )
                VALUES
                 (
                    :COL-1,  :COL-2, :COL-3, :COL-4,:COL-5
                 )
         END-EXEC
         IF SQLCODE = 0 THEN
             DISPLAY '    POPULATE OK'
         ELSE
             DISPLAY 'POPULATE TROUBLE'
             DISPLAY 'SQLCODE = ' SQLCODE '->' SQLERRMC
             GOBACK
         END-IF        .
      ****************************************************************
       READ-DB-ONE.
         DISPLAY '5.1- READ TAB_1'
         INITIALIZE  CUST-RECORD         
         EXEC SQL
           FETCH NEXT SEQTAB INTO
                   :COL-1 , :COL-2, :COL-3, :COL-4, :COL-5
         END-EXEC
         EVALUATE SQLCODE
            WHEN LESS THAN 0
                DISPLAY 'READ Error ' SQLCODE '->' SQLERRMC 
                        ' SQLSTATE : ' SQLSTATE
            WHEN GREATER THAN 0
                DISPLAY 'READ Message ' SQLCODE '->' SQLERRMC
                        ' SQLSTATE : ' SQLSTATE
            WHEN OTHER 
                DISPLAY  '   READ TAB_1 IS OK VALUE IS '
                 COL-1' 'COL-2' 'COL-3' '
                 COL-4-LEN' "'COL-4-ARR(1:COL-4-LEN)'" '
                 COL-5-LEN' "'COL-5-ARR(1:COL-5-LEN)'"'
         END-EVALUATE .
      ****************************************************************
       READ-DB.
         DISPLAY '5.0- READ TAB_1'
         EXEC SQL
            OPEN SEQTAB
         END-EXEC
         PERFORM READ-DB-ONE
         PERFORM READ-DB-ONE
         .
       READ-DB-DIRECT.
         DISPLAY '6.0- READ DIRECT TAB_1'
           CALL "cit_test2" 
           CANCEL "cit_test2" 
           CALL "cit_test2" 
         .
      ****************************************************************
       DISCONNECT.
         DISPLAY 'DISCONNECT'
         EXEC SQL
            DISCONNECT ALL
         END-EXEC
         DISPLAY 'Retry READ ... Error expected'
         PERFORM READ-DB.

