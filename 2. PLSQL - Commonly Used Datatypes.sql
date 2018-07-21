--DEMO NUMBERS
DECLARE
  l_num NUMBER;
  l_num_constant CONSTANT NUMBER := 5;
  l_num_default NUMBER(5, 2) DEFAULT 5.2;
  l_num_float NUMBER;
BEGIN
  l_num_float := 3.245;
  DBMS_OUTPUT.PUT_LINE('l_num: ' || l_num);
  DBMS_OUTPUT.PUT_LINE('l_num_constant: ' || l_num_constant);
  DBMS_OUTPUT.PUT_LINE('l_num_default: ' || l_num_default);
  DBMS_OUTPUT.PUT_LINE('l_num_float: ' || l_num_float);
END;
/


--PRECISION AND SCALE
DECLARE
  l_num NUMBER(5,2) := 123.45; --NUMBER(PRECISION, SCALE) is the syntax
  --If we specify a negative scale, Oracle rounds the actual data to the
  --specified number of places to the left of the decimal point
  l_num NUMBER(5,-2) := 12345.678;
BEGIN
  DBMS_OUTPUT.PUT_LINE('l_num Assigned 123.45 Final: ' || l_num);
  l_num := 123.789;
  DBMS_OUTPUT.PUT_LINE('l_num Assigned 123.789 Final: ' || l_num);
  --l_num := 1234.56;
END;


--SUBTYPES
DECLARE
  l_int INTEGER := 1.8;
  
  SUBTYPE myinteger IS NUMBER(38,0);
  l_myinteger myinteger := 1.8;
BEGIN
  DBMS_OUTPUT.PUT_LINE('l_int ' || l_int);
  DBMS_OUTPUT.PUT_LINE('l_myinteger ' || l_myinteger);
END;


--%TYPE
CREATE TABLE departments(dept_id NUMBER NOT NULL PRIMARY KEY,
                         dep_name VARCHAR2(60));
                          
DECLARE
  l_num NUMBER(5,2) NOT NULL DEFAULT 2.21;
  l_num_vartype l_num%TYPE := 1.123; --inherits data type and constraint
  l_num_coltype departments.dept_id%TYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE('l_num_vartype assigned value 1.123, Final value ' || l_num_vartype);
  DBMS_OUTPUT.PUT_LINE('l_num_coltype not assigned any value, Final value ' || l_num_coltype);
END;


--Type promotion and rounding error with binary numbers
DECLARE
  l_num1 NUMBER := 0.51;
  l_num2 NUMBER;
  l_num3 NUMBER;
  l_bin_float BINARY_FLOAT := 2f;
BEGIN
  --Expression involving binary_float and number are converted to binary_fload based
  --on default precedence
  l_num2 := l_num1 * l_bin_float;
  DBMS_OUTPUT.PUT_LINE('l_num2: ' || l_num2);
  
  --Stick with NUMBER with explicit conversion
  l_num3 := l_num1 * TO_NUMBER(l_bin_float);
  DBMS_OUTPUT.PUT_LINE('l_num3: ' || l_num3);
  
  --Binary Float computations should be checked with pre-defined constants for errors.
  l_bin_float := l_bin_float / 0; --Infinity
  IF l_bin_float = BINARY_FLOAT_INFINITY THEN
    DBMS_OUTPUT.PUT_LINE('l_bin_float is: ' || l_bin_float);
  END IF;
END;
/


--CHARACTER DATA TYPES
DECLARE
  l_char_with_space CHAR(4) := 'ab ';
  l_char_without_space CHAR(4) := 'ab';
  l_varchar2_without_space VARCHAR2(4) := 'ab';
BEGIN
  IF l_char_with_space = l_char_without_space THEN
    DBMS_OUTPUT.PUT_LINE('l_char_with_space is blank padded and is equal to l_char_without_space');
  END IF;
  IF l_char_with_space != l_varchar2_without_space THEN
    DBMS_OUTPUT.PUT_LINE('l_varchar2_without_space is not blank padded and so is not equal to l_char_with_space');
  END IF;
END;


--DateTime DATA TYPES
--Currently the time zone for the database and the session are both IST
SELECT CURRENT_TIMESTAMP, SYSTIMESTAMP 
FROM DUAL;

--Set Session time zone to Eastern
ALTER SESSION SET TIME_ZONE = 'EST';

SELECT CURRENT_TIMESTAMP, SYSTIMESTAMP
FROM DUAL;

DECLARE
  l_date DATE := CURRENT_DATE;
  l_systimestamp TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;
  l_currenttimestamp TIMESTAMP WITH TIME ZONE := CURRENT_TIMESTAMP;
  l_timestamp TIMESTAMP := CURRENT_TIMESTAMP;
BEGIN
  DBMS_OUTPUT.PUT_LINE('l_date: ' || l_date);
  --System or db timestamp in pacific zone with -8 offset.
  DBMS_OUTPUT.PUT_LINE('l_systimestamp: ' || l_systimestamp);
  --Current timestamp shows the session time in eastern zone
  DBMS_OUTPUT.PUT_LINE('l_currenttimestamp: ' || l_currenttimestamp);
  --Current timestamp fetched in timestamp variable loosing the timezone information
  DBMS_OUTPUT.PUT_LINE('l_timestamp: ' || l_timestamp);
END;
/


--Timezone Data Types
DECLARE
  l_tsmp TIMESTAMP(2);
  l_tsmp_tz TIMESTAMP(2) WITH TIME ZONE;
  l_tsmp_new TIMESTAMP(2);
  l_tsmp_tz_new TIMESTAMP(2) WITH TIME ZONE;
  l_int INTERVAL DAY(2) TO SECOND(2) := '7 00:00:00.00'; -- INTERVAL '7' DAY;
BEGIN
  l_tsmp := TO_TIMESTAMP('02-NOV-2013 10:00:00.00','DD-MON-RRRR HH24:MI:SS.FF');
  
  l_tsmp_tz := TO_TIMESTAMP_TZ('02-NOV-2013 10:00:00.00 PST PDT','DD-MON-RRRR HH24:MI:SS.FF TZR TZD');  
  l_tsmp_tz := TO_TIMESTAMP_TZ('02-NOV-2013 10:00:00.00 America/Los_Angeles PDT','DD-MON-RRRR HH24:MI:SS.FF TZR TZD');
  
  -- Add 7 days
  l_tsmp_new := l_tsmp + l_int ;
  l_tsmp_tz_new := l_tsmp_tz + l_int;
  
  DBMS_OUTPUT.PUT_LINE('New Timestamp is '||TO_CHAR(l_tsmp_new,'DD-MON-RRRR HH24:MI:SS.FF'));
  DBMS_OUTPUT.PUT_LINE('New Timestamp with timezone is '||TO_CHAR(l_tsmp_tz_new,'DD-MON-RRRR HH24:MI:SS.FF TZR TZD'));
    
END;


--RECORDS DATA TYPE
DECLARE
  TYPE emp_rec is RECORD(emp_name   VARCHAR2(60),
                         dept_id    departments.dept_id%TYPE,
                         loc        VARCHAR2(10) DEFAULT 'CA');
  l_emprec emp_rec;
BEGIN
  l_emprec .emp_name := 'John';
  l_emprec .dept_id := 10;
  
  DBMS_OUTPUT.PUT_LINE('Employee Name is ' || l_emprec .emp_name);
  DBMS_OUTPUT.PUT_LINE('Employee Location is ' || l_emprec .loc);
END;


--%ROWTYPE 
DECLARE
  l_dept_rec departments%ROWTYPE;
BEGIN
  l_dept_rec.dept_id := 10;
  DBMS_OUTPUT.PUT_LINE('Department id is ' || l_dept_rec.dept_id);
END;


--NESTED RECORDS
DECLARE
  TYPE employee_rec IS RECORD(emp_name  VARCHAR2(60),
                              deptrec   departments%ROWTYPE,
                              loc       VARCHAR2(10) DEFAULT 'CA');
  l_employee_rec employee_rec;
BEGIN
  l_employee_rec.deptrec.dept_id := 20;
  
  DBMS_OUTPUT.PUT_LINE('Employee Dept is ' || l_employee_rec.deptrec.dept_id);
END;
/