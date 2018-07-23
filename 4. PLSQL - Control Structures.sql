--IF ELSIF ELSE STATEMENTS AND NESTING
DECLARE
  --l_sales_amt NUMBER := 10000;
  l_sales_amt NUMBER;
  l_commission NUMBER := 0;
BEGIN
  IF l_sales_amt < 25000 OR l_sales_amt IS NULL THEN
    l_commission := 2;
  ELSIF l_sales_amt < 35000 THEN
    l_commission := 5;
  ELSE
    l_commission := 10;
  END IF;
  DBMS_OUTPUT.PUT_LINE(l_commission);
END;


--NESTED IF ELSE
DECLARE
  l_sales_amt NUMBER := 10000;
  l_commission NUMBER := 0;
BEGIN
  IF l_sales_amt < 25000 THEN
    l_commission := 2;
  ELSE
    IF l_sales_amt < 35000 THEN
      l_commission := 5;
    ELSE
      l_commission := 10;
    END IF;
  END IF;
  DBMS_OUTPUT.PUT_LINE(l_commission);
END;


--CASE STATEMENTS
DECLARE
  l_ticket_priority VARCHAR2(8) := 'MEDIUM';
  l_support_tier NUMBER;
BEGIN
  CASE l_ticket_priority
    WHEN 'HIGH' THEN
      l_support_tier := 1;
    WHEN 'MEDIUM' THEN
      l_support_tier := 2;
    WHEN 'LOW' THEN
      l_support_tier := 3;
    ELSE
      l_support_tier := 0;
    END CASE;
    DBMS_OUTPUT.PUT_LINE(l_support_tier);
END;


--DECLARING VALUE WITH CASE STATEMENTS
DECLARE
  l_ticket_priority VARCHAR2(8) := 'MEDIUM';
  l_support_tier NUMBER;
BEGIN
  l_support_tier := 
    CASE l_ticket_priority
      WHEN 'HIGH'   THEN    1
      WHEN 'MEDIUM' THEN    2
      WHEN 'LOW'    THEN    3
      ELSE                  0
    END;
    DBMS_OUTPUT.PUT_LINE(l_support_tier);
END;


--SEARCHED CASE STATEMENT
DECLARE
  l_ticket_priority VARCHAR2(8) := 'MEDIUM';
  l_support_tier NUMBER;
BEGIN
  CASE
    WHEN l_ticket_priority = 'HIGH' THEN
      l_support_tier := 1;
    WHEN l_ti/cket_priority = 'MEDIUM' THEN
      l_support_tier := 2;
    WHEN l_ticket_priority = 'LOW' THEN
      l_support_tier := 3;
    ELSE
      l_support_tier := 0;
    END CASE;
    DBMS_OUTPUT.PUT_LINE(l_support_tier);
END;