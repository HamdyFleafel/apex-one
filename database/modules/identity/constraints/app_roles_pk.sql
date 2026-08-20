-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Constraints
-- Object Name    : PK_APP_ROLES
-- Object Type    : PRIMARY KEY CONSTRAINT
-- =============================================================================

PROMPT Adding PK_APP_ROLES

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'PK_APP_ROLES'
       AND TABLE_NAME      = 'APP_ROLES'
       AND CONSTRAINT_TYPE = 'P';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE '
            ALTER TABLE APP_ROLES
            ADD CONSTRAINT PK_APP_ROLES
            PRIMARY KEY (ROLE_ID)
                        USING INDEX TABLESPACE APEXONE_INDEX
        ';

        DBMS_OUTPUT.PUT_LINE('PK_APP_ROLES created.');

    ELSE
        DBMS_OUTPUT.PUT_LINE('PK_APP_ROLES already exists.');
    END IF;

END;
/

COMMIT;
PROMPT Completed.