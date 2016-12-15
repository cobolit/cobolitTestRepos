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

       01 charficd PIC X(2) usage varraw.
       01 CFBARSCLE PIC X(3) usage varraw.
       01 charetab PIC X(1) usage varraw.

 **************** THE SQLCA FILE MUST BE IN THE DIRECTORY**
           EXEC SQL
                 INCLUDE SQLCA
           END-EXEC.

           EXEC SQL END
              DECLARE SECTION
           END-EXEC
      ****************************************************************
       PROCEDURE DIVISION.
           EXEC SQL 
            SELECT COL_1 , COL_2 INTO :COL-1 , :COL-2  FROM TAB1 
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
                 COL-1' 'COL-2
         END-EVALUATE .

