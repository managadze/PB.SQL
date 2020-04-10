DROP FUNCTION IF EXISTS process_sauce_audit;

CREATE OR REPLACE FUNCTION process_sauce_audit() RETURNS TRIGGER AS $$
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            INSERT INTO "Sauce_audit" SELECT 'D', now(), user, OLD.*;
            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO "Sauce_audit" SELECT 'U', now(), user, OLD.*;
            RETURN NEW;
        END IF;
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;