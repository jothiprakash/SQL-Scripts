--DEMO OF ANONYMOUS BLOCK STRUCTURE AND COMMENT STYLES
DECLARE
  -- Declare local variables.
  l_counter NUMBER;
BEGIN
  l_counter := 1; -- l_var assigned value
  DBMS_OUTPUT.PUT_LINE('l_counter in the inner block is ' || l_counter);
  /* dbms_output.put_line sends output messages
     to the console
  */
EXCEPTION
  WHEN OTHERS THEN
    NULL;
END;


--NESTED ANONYMOUS BLOCKS
DECLARE
  l_var NUMBER;
  l_outer NUMBER;
BEGIN
  l_outer := 1;
  l_var := 1;
  --NESTED BLOCK 
  DECLARE
    l_var NUMBER;
    l_inner NUMBER;
  BEGIN
    l_inner := 2;
    l_var := 2;
    DBMS_OUTPUT.PUT_LINE('l_var in the inner block is '|| l_var);
    DBMS_OUTPUT.PUT_LINE('l_inner in the inner block is '|| l_inner);
    DBMS_OUTPUT.PUT_LINE('l_outer in the inner block is '|| l_outer);
  END;
  DBMS_OUTPUT.PUT_LINE('l_var in the outer block is ' || l_var);
EXCEPTION
  WHEN OTHERS THEN
  --DO SOMETHING
  NULL;
END;


--NESTED ANONYMOUS BLOCK WITH PARENT
<<parent>>
DECLARE
  l_var NUMBER;
  l_outer NUMBER;
BEGIN
  l_outer := 1;
  l_var := 1;
  --NESTED BLOCK 
  DECLARE
    l_var NUMBER;
    l_inner NUMBER;
  BEGIN
    l_inner := 2;
    l_var := 2;
    DBMS_OUTPUT.PUT_LINE('l_var in the inner block is ' || l_var);
    DBMS_OUTPUT.PUT_LINE('l_var from the outher block using label is ' || parent.l_var);
  END;
  DBMS_OUTPUT.PUT_LINE('l_var in the outer block is ' || l_var);
EXCEPTION
  WHEN OTHERS THEN
  --DO SOMETHING
  NULL;
END;
/