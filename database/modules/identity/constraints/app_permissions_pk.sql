-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Identity
-- Component      : Constraints
-- Object Name    : PK_APP_PERMISSIONS
-- Object Type    : PRIMARY KEY CONSTRAINT
-- =============================================================================

PROMPT Adding PK_APP_PERMISSIONS

DECLARE
    l_exists NUMBER;
BEGIN

    SELECT COUNT(*)
      INTO l_exists
      FROM USER_CONSTRAINTS
     WHERE CONSTRAINT_NAME = 'PK_APP_PERMISSIONS'
       AND TABLE_NAME      = 'APP_PERMISSIONS'
       AND CONSTRAINT_TYPE = 'P';

    IF l_exists = 0 THEN

        EXECUTE IMMEDIATE '
            ALTER TABLE APP_PERMISSIONS
            ADD CONSTRAINT PK_APP_PERMISSIONS
            PRIMARY KEY (PERMISSION_ID)
                         USING INDEX TABLESPACE APEXONE_INDEX
        ';

        DBMS_OUTPUT.PUT_LINE('PK_APP_PERMISSIONS created.');

    ELSE
        DBMS_OUTPUT.PUT_LINE('PK_APP_PERMISSIONS already exists.');
    END IF;

END;
/

COMMIT;
PROMPT Completed.