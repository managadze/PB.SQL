DROP TRIGGER IF EXISTS additive_audit ON "Additive";

CREATE TRIGGER additive_audit
BEFORE UPDATE OR DELETE ON "Additive"
FOR EACH ROW EXECUTE PROCEDURE process_additive_audit();