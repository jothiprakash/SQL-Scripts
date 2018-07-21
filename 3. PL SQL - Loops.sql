--SIMPLE LOOPS
DECLARE
  l_counter NUMBER := 0;
  l_sum NUMBER := 0;
BEGIN
  LOOP
    l_sum := l_sum + l_counter;
    l_counter := l_counter + 1;
    DBMS_OUTPUT.PUT_LINE(l_sum);
      IF l_sum > 2 THEN
        --GOTO out_of_loop; --EXIT, RETURN and GOTO can be used to exit the loop.
        --EXIT;
        RETURN;
      END IF;
  END LOOP;
  <<out_of_loop>>
  NULL;
END;


--FOR LOOPS
BEGIN
  FOR l_counter IN 1..5 LOOP
    DBMS_OUTPUT.PUT_LINE(l_counter);
  END LOOP;
END;



--REVERSE FOR LOOPS
BEGIN
  FOR l_counter IN REVERSE 1..5 LOOP
    DBMS_OUTPUT.PUT_LINE(l_counter);
  END LOOP;
END;


--SIMULATING STEPS USING FOR LOOPS
DECLARE
  l_step_counter NUMBER;
BEGIN
  FOR l_counter IN 1..3 LOOP
    l_step_counter := l_counter * 2;
    DBMS_OUTPUT.PUT_LINE(l_step_counter);
  END LOOP;
END;


--FOR LOOP WITH SQL
INSERT INTO departments VALUES (1, 'Sales');
INSERT INTO departments VALUES (2, 'IT');

DECLARE
  l_dept_count NUMBER;
BEGIN
  SELECT COUNT(*)
    INTO l_dept_count
      FROM DEPARTMENTS;
  FOR l_counter IN 1..l_dept_count LOOP
    DBMS_OUTPUT.PUT_LINE(l_counter);
  END LOOP;
END;


--FOR LOOP WITH CONTINUE KEYWORD
BEGIN
  FOR l_counter IN 1..4 LOOP
    IF l_counter = 3 THEN
      CONTINUE;
    END IF;
    DBMS_OUTPUT.PUT_LINE(l_counter);
  END LOOP;
END;


--NESTED LOOP WITH LABELS AND EXIT KEYWORD
BEGIN
  <<outer>>
  FOR l_outer_counter IN 1..3 LOOP
    DBMS_OUTPUT.PUT_LINE('l_outer_counter: ' || l_outer_counter);
    <<inner>>
    FOR l_inner_counter IN 1..5 LOOP
      EXIT outer WHEN l_inner_counter = 3;
      DBMS_OUTPUT.PUT_LINE('  l_inner_counter: ' || l_inner_counter);
    END LOOP inner;
  END LOOP outer;
END;


--NESTED LOOP WITH LABELS AND CONTINUE KEYWORD
BEGIN
  <<outer>>
  FOR l_outer_counter IN 1..3 LOOP
    DBMS_OUTPUT.PUT_LINE('l_outer_counter: ' || l_outer_counter);
    <<inner>>
    FOR l_inner_counter IN 1..3 LOOP
      CONTINUE outer WHEN l_inner_counter = 2;
      DBMS_OUTPUT.PUT_LINE('  l_inner_counter: ' || l_inner_counter);
    END LOOP inner;
    DBMS_OUTPUT.PUT_LINE('l_outer_counter at end: ' || l_outer_counter);
  END LOOP outer;
END;


--WHILE LOOP
DECLARE
  l_check INTEGER := 1;
BEGIN
  WHILE l_check < 5 LOOP
      l_check := SYS.DBMS_RANDOM.VALUE(1,10);
      DBMS_OUTPUT.PUT_LINE (l_check);
    END LOOP;
END;