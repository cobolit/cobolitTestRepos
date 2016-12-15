PATH=../../bin/:$PATH
export PATH
citpgsql :IncludeSearchPath=../../include ./cit_test.cob
citpgsql :IncludeSearchPath=../../include ./cit_test2.cob
citpgsql :IncludeSearchPath=../../include ./dbconnect.cob
cobc dbconnect.cbp 
cobc cit_test2.cbp 
cobc -x cit_test.cbp 

