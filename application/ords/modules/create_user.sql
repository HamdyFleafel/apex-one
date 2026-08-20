-- =============================================================================
-- APEXONE ORDS Module: Create User
-- Endpoint : POST /api/v1/users
-- Dependency: PKG_INTEGRATION.CREATE_USER
-- =============================================================================
SET DEFINE OFF
WHENEVER SQLERROR EXIT FAILURE ROLLBACK

BEGIN
    ORDS.DEFINE_MODULE(
        p_module_name    => 'apexone.api.v1',
        p_base_path      => '/api/v1/',
        p_items_per_page => 25,
        p_status         => 'PUBLISHED',
        p_comments       => 'APEXONE API v1'
    );

    ORDS.DEFINE_TEMPLATE(
        p_module_name => 'apexone.api.v1',
        p_pattern     => 'users',
        p_priority    => 0,
        p_etag_type   => 'NONE',
        p_comments    => 'Create user'
    );

    ORDS.DEFINE_HANDLER(
        p_module_name => 'apexone.api.v1',
        p_pattern     => 'users',
        p_method      => 'POST',
        p_source_type => ORDS.SOURCE_TYPE_PLSQL,
        p_items_per_page => 0,
        p_source      => q'~
DECLARE
    l_username VARCHAR2(32767);
    l_email    VARCHAR2(32767);
    l_password VARCHAR2(32767);
    l_user_id  NUMBER;

    PROCEDURE write_error
    (
        p_status  IN PLS_INTEGER,
        p_code    IN VARCHAR2,
        p_message IN VARCHAR2
    )
    IS
    BEGIN
        :status_code := p_status;
        OWA_UTIL.MIME_HEADER('application/json', FALSE);
        HTP.P('Cache-Control: no-store');
        OWA_UTIL.HTTP_HEADER_CLOSE;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.OPEN_OBJECT('error');
        APEX_JSON.WRITE('code', p_code);
        APEX_JSON.WRITE('message', p_message);
        APEX_JSON.CLOSE_OBJECT;
        APEX_JSON.CLOSE_OBJECT;
    END;
BEGIN
    BEGIN
        APEX_JSON.PARSE(:body_text);
        l_username := APEX_JSON.GET_VARCHAR2('username');
        l_email    := APEX_JSON.GET_VARCHAR2('email');
        l_password := APEX_JSON.GET_VARCHAR2('password');
    EXCEPTION
        WHEN OTHERS THEN
            write_error(400, 'INVALID_REQUEST', 'Invalid JSON request.');
            RETURN;
    END;

    IF l_username IS NULL OR l_email IS NULL OR l_password IS NULL THEN
        write_error(400, 'INVALID_REQUEST', 'username, email and password are required.');
        RETURN;
    END IF;

    BEGIN
        l_user_id := PKG_INTEGRATION.CREATE_USER
        (
            p_username => l_username,
            p_email    => l_email,
            p_password => l_password
        );

        :status_code := 201;
        OWA_UTIL.MIME_HEADER('application/json', FALSE);
        HTP.P('Cache-Control: no-store');
        OWA_UTIL.HTTP_HEADER_CLOSE;
        APEX_JSON.OPEN_OBJECT;
        APEX_JSON.WRITE('user_id', l_user_id);
        APEX_JSON.CLOSE_OBJECT;
    EXCEPTION
        WHEN OTHERS THEN
            IF SQLCODE = -20001 THEN
                write_error(409, 'IDENTITY_ERROR', 'User creation conflicts with an existing identity.');
            ELSE
                write_error(500, 'INTERNAL_ERROR', 'User creation failed.');
            END IF;
    END;
END;
~',
        p_comments    => 'Creates a user through PKG_INTEGRATION'
    );

    COMMIT;
END;
/
