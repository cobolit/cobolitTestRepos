       IDENTIFICATION DIVISION.
       PROGRAM-ID.  hello.
       ENVIRONMENT DIVISION. 
       DATA DIVISION.
       WORKING-STORAGE SECTION. 
       77 dummy PIC x.
       PROCEDURE DIVISION. 
       MAIN SECTION.
           DISPLAY "hello world" LINE 10 COL 10.
           ACCEPT dummy LINE 10 col 22.
           STOP RUN.
