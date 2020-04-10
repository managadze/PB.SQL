DROP TRIGGER IF EXISTS filling_audit ON "Filling";

CREATE TRIGGER filling_audit
BEFORE UPDATE OR DELETE ON "Filling"
FOR EACH ROW EXECUTE PROCEDURE process_filling_audit();