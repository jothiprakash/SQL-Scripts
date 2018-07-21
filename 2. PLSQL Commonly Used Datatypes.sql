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

