--INTERNAL ERROR RAISED BY ORACLE
DECLARE
    l_name DEPARTMENTS.DEPT_NAME%TYPE;
BEGIN
    SELECT DEPT_NAME
    INTO   l_name
    FROM   DEPARTMENTS
    WHERE  DEPT_ID = 10;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('System Error. Please contact Application Support');
        DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQLERRM: ' || SQLERRM);
END;


--PREDEFINED EXCEPTIONS
DECLARE
    l_name DEPARTMENTS.DEPT_NAME%TYPE;
BEGIN
    SELECT DEPT_NAME
    INTO   l_name
    FROM   DEPARTMENTS;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQLERRM: ' || SQLERRM);
END;


--USER DEFINED EXCEPTIONS TO MAP ORACLE INTERNAL ERRORS
DECLARE
    l_num PLS_INTEGER := NULL;
    too_big EXCEPTION;
    PRAGMA EXCEPTION_INIT (too_big, -1426);
BEGIN
    l_num := 2147483648;
EXCEPTION
    WHEN too_big THEN
        DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('SQLERRM: ' || SQLERRM);
END;


--MANUALLY RAISING EXCEPTION
DECLARE
    invalid_quantity EXCEPTION;
    i_order_qty number := -2;
BEGIN
    IF i_order_qty < 0 THEN
        RAISE invalid_quantity;
    END IF;
EXCEPTION
    WHEN invalid_quantity THEN
        DBMS_OUTPUT.PUT_LINE('Outer Exception Handler Raised');
END;


--SCOPE OF EXCEPTION AND THEIR PROPOGATION
DECLARE
    invalid_quantity EXCEPTION;
    l_order_qty number := -2;
BEGIN
    DECLARE
        --invalid_quantity EXCEPTION;
    BEGIN
        IF l_order_qty < 0 THEN
            RAISE invalid_quantity;
        END IF;
    END;
    DBMS_OUTPUT.PUT_LINE('Resuming Outer Block');
EXCEPTION
    WHEN invalid_quantity THEN
        DBMS_OUTPUT.PUT_LINE('Inside outer block invalid_quantity handler');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Inside outer block when Others');
END;