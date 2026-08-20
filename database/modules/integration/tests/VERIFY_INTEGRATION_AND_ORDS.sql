SET SERVEROUTPUT ON
PROMPT ============================================================
PROMPT APEXONE - INTEGRATION AND ORDS VERIFICATION
PROMPT ============================================================

DECLARE
    PROCEDURE assert_valid(p_name VARCHAR2, p_type VARCHAR2) IS l_status VARCHAR2(7); BEGIN
        SELECT status INTO l_status FROM user_objects WHERE object_name=p_name AND object_type=p_type;
        IF l_status <> 'VALID' THEN RAISE_APPLICATION_ERROR(-20000,'FAIL - '||p_name||' '||p_type||' is '||l_status); END IF;
        DBMS_OUTPUT.PUT_LINE('PASS - '||p_name||' '||p_type||' is VALID');
    EXCEPTION WHEN NO_DATA_FOUND THEN RAISE_APPLICATION_ERROR(-20000,'FAIL - '||p_name||' '||p_type||' does not exist'); END;
BEGIN
    DBMS_OUTPUT.PUT_LINE('[1] Verifying PKG_INTEGRATION status...');
    assert_valid('PKG_INTEGRATION','PACKAGE'); assert_valid('PKG_INTEGRATION','PACKAGE BODY');
    DBMS_OUTPUT.PUT_LINE('[2] Verifying Identity dependency...');
    assert_valid('PKG_IDENTITY','PACKAGE'); assert_valid('PKG_IDENTITY','PACKAGE BODY');
    DBMS_OUTPUT.PUT_LINE('[3] Verifying error framework...');
    assert_valid('PKG_ERRORS','PACKAGE'); assert_valid('PKG_ERRORS','PACKAGE BODY');
END;
/

PROMPT [4] Testing successful user creation...
DECLARE l_user_id NUMBER; l_tag VARCHAR2(30):='VERIFY_'||TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF3'); BEGIN
 l_user_id:=PKG_INTEGRATION.CREATE_USER(l_tag,LOWER(l_tag)||'@example.com','SmokeTestPassword123!');
 DBMS_OUTPUT.PUT_LINE('PASS - User created successfully. USER_ID = '||l_user_id); END;
/
PROMPT [5] Testing duplicate username error propagation...
DECLARE l_tag VARCHAR2(30):='DUPU_'||TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF3'); l_id NUMBER; BEGIN
 l_id:=PKG_INTEGRATION.CREATE_USER(l_tag,LOWER(l_tag)||'a@example.com','SmokeTestPassword123!');
 BEGIN l_id:=PKG_INTEGRATION.CREATE_USER(l_tag,LOWER(l_tag)||'b@example.com','SmokeTestPassword123!'); RAISE_APPLICATION_ERROR(-20000,'FAIL - duplicate username was accepted');
 EXCEPTION WHEN OTHERS THEN IF SQLCODE=-20001 THEN DBMS_OUTPUT.PUT_LINE('PASS - Duplicate username returned SQLCODE -20001'); ELSE RAISE; END IF; END; END;
/
PROMPT [6] Testing duplicate email error propagation...
DECLARE l_tag VARCHAR2(30):='DUPE_'||TO_CHAR(SYSTIMESTAMP,'YYYYMMDDHH24MISSFF3'); l_id NUMBER; BEGIN
 l_id:=PKG_INTEGRATION.CREATE_USER(l_tag,LOWER(l_tag)||'@example.com','SmokeTestPassword123!');
 BEGIN l_id:=PKG_INTEGRATION.CREATE_USER(l_tag||'X',LOWER(l_tag)||'@example.com','SmokeTestPassword123!'); RAISE_APPLICATION_ERROR(-20000,'FAIL - duplicate email was accepted');
 EXCEPTION WHEN OTHERS THEN IF SQLCODE=-20001 THEN DBMS_OUTPUT.PUT_LINE('PASS - Duplicate email returned SQLCODE -20001'); ELSE RAISE; END IF; END; END;
/
PROMPT ============================================================
PROMPT DATABASE INTEGRATION VERIFICATION COMPLETED
PROMPT ============================================================
