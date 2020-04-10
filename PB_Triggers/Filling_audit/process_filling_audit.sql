DROP FUNCTION IF EXISTS process_filling_audit;

CREATE OR REPLACE FUNCTION process_filling_audit() RETURNS TRIGGER AS $$
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            INSERT INTO "Filling_audit" SELECT 'D', now(), user, OLD.*;
            RETURN OLD;
        ELSIF (TG_OP = 'UPDATE') THEN
            INSERT INTO "Filling_audit" SELECT 'U', now(), user, OLD.*;
            RETURN NEW;
        END IF;
        RETURN NULL;
    END;
$$ LANGUAGE plpgsql;