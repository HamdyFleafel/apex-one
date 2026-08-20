-- =============================================================================
-- PKG_INTEGRATION CREATE_USER smoke tests
-- =============================================================================
SET SERVEROUTPUT ON
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

DECLARE
    l_user_id NUMBER;
    l_suffix  VARCHAR2(30) := TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3');
BEGIN
    l_user_id := PKG_INTEGRATION.CREATE_USER(
        p_username => 'INT_TEST_' || l_suffix,
        p_email    => 'int_test_' || l_suffix || '@example.test',
        p_password => 'IntegrationTestPassword1!'
    );

    IF l_user_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20000, 'Expected USER_ID was not returned.');
    END IF;

    DBMS_OUTPUT.PUT_LINE('PASS: create_user returned USER_ID=' || l_user_id);
    ROLLBACK;
END;
/

DECLARE
    l_suffix VARCHAR2(30) := TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3');
    l_user_id NUMBER;
    l_code NUMBER;
BEGIN
    l_user_id := PKG_INTEGRATION.CREATE_USER(
        p_username => 'INT_DUP_' || l_suffix,
        p_email    => 'int_dup_' || l_suffix || '@example.test',
        p_password => 'IntegrationTestPassword1!'
    );

    BEGIN
        l_user_id := PKG_INTEGRATION.CREATE_USER(
            p_username => 'INT_DUP_' || l_suffix,
            p_email    => 'other_' || l_suffix || '@example.test',
            p_password => 'IntegrationTestPassword1!'
        );
        RAISE_APPLICATION_ERROR(-20000, 'Expected identity conflict was not raised.');
    EXCEPTION
        WHEN OTHERS THEN
            l_code := SQLCODE;
            IF l_code <> -20001 THEN
                RAISE;
            END IF;
            DBMS_OUTPUT.PUT_LINE('PASS: identity conflict propagated as -20001');
    END;
    ROLLBACK;
END;
/
