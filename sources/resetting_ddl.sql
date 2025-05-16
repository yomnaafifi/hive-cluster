DO
$$
DECLARE
    tabname TEXT;
BEGIN
    FOR tabname IN
        SELECT tablename FROM pg_tables
        WHERE schemaname = 'mydwh'
    LOOP
        EXECUTE 'DROP TABLE IF EXISTS public.' || quote_ident(tabname) || ' CASCADE';
    END LOOP;
END
$$;
