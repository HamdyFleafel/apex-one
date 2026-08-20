-- =============================================================================
-- Project        : APEXONE Enterprise Platform
-- Module         : Core
-- Component      : Packages
-- Object Name    : PKG_CORE
-- Object Type    : PACKAGE BODY
-- File           : PKG_CORE.pkb
-- Path           : database/modules/core/packages/body/PKG_CORE.pkb
-- Schema         : APEXONE
-- Version        : 1.1.0-alpha.1
-- Status         : Development
-- -----------------------------------------------------------------------------
-- Author         : Hamdy Fleafel
-- -----------------------------------------------------------------------------
-- Description    : Implements installation lifecycle management.
-- =============================================================================

CREATE OR REPLACE PACKAGE BODY PKG_CORE
IS

    FUNCTION install_start
    (
        p_module_name    IN VARCHAR2,
        p_module_version IN VARCHAR2
    )
    RETURN NUMBER
    IS
        l_install_id NUMBER;
    BEGIN
        INSERT INTO APP_INSTALL_LOG
        (
            MODULE_NAME,
            MODULE_VERSION,
            STATUS
        )
        VALUES
        (
            p_module_name,
            p_module_version,
            'RUNNING'
        )
        RETURNING INSTALL_ID INTO l_install_id;

        COMMIT;

        RETURN l_install_id;
    END;

    PROCEDURE install_success
    (
        p_install_id IN NUMBER
    )
    IS
    BEGIN
        UPDATE APP_INSTALL_LOG
           SET STATUS       = 'SUCCESS',
               COMPLETED_AT = SYSTIMESTAMP
         WHERE INSTALL_ID  = p_install_id;

        COMMIT;
    END;

    PROCEDURE install_failure
    (
        p_install_id IN NUMBER,
        p_error_msg  IN VARCHAR2
    )
    IS
    BEGIN
        UPDATE APP_INSTALL_LOG
           SET STATUS        = 'FAILED',
               COMPLETED_AT  = SYSTIMESTAMP,
               ERROR_MESSAGE = SUBSTR(p_error_msg, 1, 2000)
         WHERE INSTALL_ID  = p_install_id;

        COMMIT;
    END;

END PKG_CORE;
/