--ENABLE THE CODE IF YOU ARE RUNNING IT FOR THE FIRST TIME ONLY.
--CREATE TABLE AGENT_SALES(AGENT_ID         NUMBER PRIMARY KEY,
--                         AGENT_SALES_AMT  NUMBER,
--                         AGENT_LOC        VARCHAR2(10));

--INSERT INTO AGENT_SALES VALUES('&AGENT_ID', 
--                               '&AGENT_SALES_AMT', 
--                               '&AGENT_LOC');
--INSERT INTO AGENT_SALES VALUES('10', '100.2', 'CA');
--INSERT INTO AGENT_SALES VALUES('20', '1000', 'NY');
--INSERT INTO AGENT_SALES VALUES('30', '200', 'CA');
COMMIT;


DECLARE
    l_location AGENT_SALES.AGENT_LOC%TYPE := 'NY';
    l_total_sales NUMBER;
    l_previous_year_comm NUMBER;
    l_new_commission number := 0;
    l_ratio NUMBER;
BEGIN
    l_previous_year_comm := 0;
    FOR agent_sales_var IN (SELECT * FROM agent_sales WHERE agent_loc = l_location)
        LOOP
            l_total_sales := l_total_sales + agent_sales_var.agent_sales_amt;
        END LOOP;
        IF l_total_sales > 20000 THEN
            l_new_commission := 2000 * 0.10;
        ELSIF l_total_sales <= 2000 THEN
            l_new_commission := 2000 * 0.05;
        END IF;
        l_ratio := l_previous_year_comm / l_new_commission;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('SQLERRM: ' || SQLERRM);
        --TO GET THE ERROR LINE NUMBER USE THE FOLLOWING CODE
        DBMS_OUTPUT.PUT_LINE('Error Stack: ' || SYS.DBMS_UTILITY.FORMAT_ERROR_STACK);
        DBMS_OUTPUT.PUT_LINE('Error Backtrace: ' || SYS.DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;


DECLARE
    l_location agent_sales.agent_loc%TYPE := 'NY' ;
    l_total_sales        NUMBER ;
    l_previous_year_comm NUMBER ;
    l_new_commission     NUMBER:= 0;
    l_ratio              NUMBER;
BEGIN
    l_previous_year_comm := 0;
    FOR agent_sales_var IN  (SELECT * FROM agent_sales WHERE agent_loc = l_location  )
    LOOP
      l_total_sales := l_total_sales + agent_sales_var.agent_sales_amt;
      DBMS_OUTPUT.PUT_LINE('Agent Id: '||TO_CHAR(agent_sales_var.agent_id)||' Agent Sales Amt: '||
        TO_CHAR(agent_sales_var.agent_sales_amt) ||' l_total_sales '||TO_CHAR(l_total_sales));
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('l_total_sales '||TO_CHAR(l_total_sales));
    IF l_total_sales     > 2000 THEN
      l_new_commission  := 2000 * 0.10;
      DBMS_OUTPUT.PUT_LINE('l_new_commission '||TO_CHAR(l_new_commission));
    ELSIF l_total_sales <= 2000 THEN
      l_new_commission  := 2000 * 0.05;
      DBMS_OUTPUT.PUT_LINE('l_new_commission '||TO_CHAR(l_new_commission));
    END IF;
    l_ratio := l_previous_year_comm / l_new_commission;
EXCEPTION
WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error Stack: '||SYS.dbms_utility.format_error_stack);
    DBMS_OUTPUT.PUT_LINE('Error Backtrace: '||SYS.dbms_utility.format_error_backtrace);
END;


--GRANTING USER PREVILEGES
GRANT DEBUG CONNECT SESSION TO SYSTEM;
GRANT DEBUG ANY PROCEDURE TO SYSTEM;