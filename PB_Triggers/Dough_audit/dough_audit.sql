DROP TRIGGER IF EXISTS dough_audit ON "Dough";

CREATE TRIGGER dough_audit
BEFORE UPDATE OR DELETE ON "Dough"
FOR EACH ROW EXECUTE PROCEDURE process_dough_audit();