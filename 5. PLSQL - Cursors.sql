DROP TABLE DEPARTMENTS;

--CREATE DEPARTMENTS TABLE
CREATE TABLE DEPARTMENTS(DEPT_ID NUMBER NOT NULL PRIMARY KEY,
                         DEPT_NAME VARCHAR2(60));
                         
INSERT INTO DEPARTMENTS VALUES(1, 'IT');
INSERT INTO DEPARTMENTS VALUES(2, 'Accounting');
COMMIT;

CREATE TABLE EMPLOYEE(EMP_ID NUMBER NOT NULL PRIMARY KEY,
                      EMP_NAME VARCHAR2(60),
                      EMP_DEPT_ID NUMBER,
                      EMP_LOC VARCHAR2(60),
                      EMP_SAL NUMBER,
                      CONSTRAINT EMP_DEPT_FK FOREIGN KEY(EMP_DEPT_ID) REFERENCES DEPARTMENTS(DEPT_ID));
     
--UNCOMMENT ONLY WHEN YOU HAVE TO INSERT DATA.
--INSERT INTO EMPLOYEE(EMP_ID,
--                     EMP_NAME,
--                     EMP_DEPT_ID,
--                     EMP_LOC,
--                     EMP_SAL)
--VALUES              ('&EMP_ID',
--                     '&EMP_NAME',
--                     '&EMP_DEPT_ID',
--                     '&EMP_LOC',
--                     '&EMP_SAL');

--INSERT INTO EMPLOYEE(EMP_ID,
--                     EMP_NAME,
--                     EMP_DEPT_ID,
--                     EMP_LOC,
--                     EMP_SAL)
--VALUES              ('10',
--                     'Tom',
--                     '1',
--                     'CA',
--                     '50000');

--INSERT INTO EMPLOYEE(EMP_ID,
--                     EMP_NAME,
--                     EMP_DEPT_ID,
--                     EMP_LOC,
--                     EMP_SAL)
--VALUES              ('20',
--                     'John',
--                     '1',
--                     'CA',
--                     '40000');

--INSERT INTO EMPLOYEE(EMP_ID,
--                     EMP_NAME,
--                     EMP_DEPT_ID,
--                     EMP_LOC,
--                     EMP_SAL)
--VALUES              ('50',
--                     'Tim',
--                     '2',
--                     'CA',
--                     '40000');

--INSERT INTO EMPLOYEE(EMP_ID,
--                     EMP_NAME,
--                     EMP_DEPT_ID,
--                     EMP_LOC,
--                     EMP_SAL)
--VALUES              ('60',
--                     'Jack',
--                     '2',
--                     'CA',
--                     '70000');

COMMIT;


--IMPLICIT CURSORS
DECLARE
  l_dept_id DEPARTMENTS.DEPT_ID%TYPE;
  l_dept_name DEPARTMENTS.DEPT_NAME%TYPE;
BEGIN
  SELECT DEPT_ID,
         DEPT_NAME
  INTO   l_dept_id,
         l_dept_name
  FROM   DEPARTMENTS;     --Multiple value error will be invoked.
  --WHERE  DEPT_ID = 1;   --Query will run and return a row.
  --WHERE  DEPT_ID = 10;  --Query will throw "Data not found exception"
    
    IF SQL%FOUND THEN
      DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT);
    END IF;
END;


--EXPLICIT CURSORS AND CURSOR ATTRIBUTES
DECLARE
  CURSOR cur_get_departments(p_rows NUMBER DEFAULT 5) IS
    SELECT dept_id,
           dept_name
    FROM   departments
    WHERE  ROWNUM <= p_rows;
  cur_get_departments_var cur_get_departments%ROWTYPE;
BEGIN
  OPEN cur_get_departments(2);
  LOOP
    FETCH cur_get_departments
      INTO cur_get_departments_var;
    EXIT WHEN cur_get_departments%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Dept Id: ' || cur_get_departments_var.dept_id);
    DBMS_OUTPUT.PUT_LINE('RowCount: ' || cur_get_departments%ROWCOUNT);
  END LOOP;
  IF cur_get_departments%ISOPEN THEN
    CLOSE cur_get_departments;
  END IF;
END;


--IMPLICIT CURSOR FOR LOOP
DECLARE
  CURSOR cur_emp_info (p_dept_id employee.emp_dept_id%TYPE) IS
    SELECT emp_name FROM EMPLOYEE WHERE EMP_DEPT_ID = p_dept_id;
BEGIN
  <<dept_loop>>
  FOR cur_dept_info_var IN (SELECT dept_id FROM DEPARTMENTS)
    LOOP
      DBMS_OUTPUT.PUT_LINE('Dept id : ' || cur_dept_info_var.dept_id);
      <<emp_loop>>
      FOR cur_emp_info_var IN cur_emp_info(cur_dept_info_var.dept_id)
        LOOP
          DBMS_OUTPUT.PUT_LINE('Emp Name : ' || cur_emp_info_var.emp_name);
        END LOOP emp_loop;
      END LOOP dept_loop;
END;


--DECLARATION AND USING FOR UPDATE CURSOR
DECLARE
  CURSOR cur_move_emp(p_emp_loc EMPLOYEE.EMP_LOC%TYPE) IS
    SELECT emp_id,
           dept_name
    FROM   DEPARTMENTS,
           EMPLOYEE
    WHERE  emp_dept_id = dept_id
    AND    emp_loc = p_emp_loc
    FOR UPDATE OF emp_loc NOWAIT;
BEGIN
  FOR cur_move_emp_var IN cur_move_emp('CA') LOOP
    UPDATE employee
      SET emp_loc = 'WA'
    WHERE CURRENT OF cur_move_emp;
  END LOOP;
  COMMIT;
END;


--STRONGLY TYPED CURSOR VARIABLES AND ASSIGNING VALUES
DECLARE
  TYPE rc_dept IS REF CURSOR RETURN DEPARTMENTS%ROWTYPE;
  rc_cur_initial rc_dept;
  rc_cur_final rc_dept;
  l_dept_rowtype DEPARTMENTS%ROWTYPE;
  l_choice NUMBER := 1;
  l_lower NUMBER := 1;
  l_upper NUMBER := 2;
BEGIN
  IF l_choice = 1 THEN
    OPEN rc_cur_initial FOR
      SELECT * FROM DEPARTMENTS
      WHERE  dept_id BETWEEN l_lower AND l_upper;
  ELSE
    OPEN rc_cur_initial FOR
      SELECT * FROM DEPARTMENTS
      WHERE  dept_name = 'Accounting';
  END IF;
  rc_cur_final := rc_cur_initial;
  LOOP
    FETCH rc_cur_final INTO l_dept_rowtype;
    EXIT WHEN rc_cur_final%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(l_dept_rowtype.dept_id);
  END LOOP;
    CLOSE rc_cur_final;
END;


--WEAKLY TYPED REF CURSOR VARIABLES AND ASSIGNING VALUES
DECLARE
  TYPE rc_weak IS REF CURSOR;
  rc_weak_cur rc_weak;
  l_dept_rowtype DEPARTMENTS%ROWTYPE;
  l_emp_rowtype EMPLOYEE%ROWTYPE;
BEGIN
  OPEN rc_weak_cur FOR
    SELECT * FROM DEPARTMENTS WHERE DEPT_ID = 1;
      LOOP
        FETCH rc_weak_cur INTO l_dept_rowtype;
        EXIT WHEN rc_weak_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(l_dept_rowtype.dept_name);
      END LOOP;
    DBMS_OUTPUT.PUT_LINE('Now running the ref cursor for the employee query');
    OPEN rc_weak_cur FOR
      SELECT * FROM employee WHERE emp_dept_id = 2;
        LOOP
          FETCH rc_weak_cur INTO l_emp_rowtype;
          EXIT WHEN rc_weak_cur%NOTFOUND;
          DBMS_OUTPUT.PUT_LINE(l_emp_rowtype.emp_id);
        END LOOP;
    CLOSE rc_weak_cur;
END;


--CURSOR EXPRESSIONS
DECLARE
  CURSOR cur_dept_info(p_num NUMBER) IS
    SELECT dept_id,
      CURSOR(SELECT emp_id
             FROM EMPLOYEE
             WHERE emp_dept_id = dept_id
             AND ROWNUM <= p_num) emp_info
    FROM DEPARTMENTS
    WHERE ROWNUM <= p_num;
  l_dept_id DEPARTMENTS.DEPT_ID%TYPE;
  rc_emp_info SYS_REFCURSOR;
  l_emp_id EMPLOYEE.EMP_ID%TYPE;
BEGIN
  OPEN cur_dept_info(2);
  LOOP
    FETCH cur_dept_info INTO l_dept_id, rc_emp_info;
    EXIT WHEN cur_dept_info%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('  l_dept_id: ' || l_dept_id);
      LOOP
        FETCH rc_emp_info INTO l_emp_id;
        EXIT WHEN rc_emp_info%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('    l_emp_id: ' || l_emp_id);
      END LOOP;
  END LOOP;
  CLOSE cur_dept_info;
END; 