DROP TRIGGER IF EXISTS controllers_audit ON "Controllers";

CREATE TRIGGER controllers_audit
BEFORE UPDATE OR DELETE ON "Controllers"
FOR EACH ROW EXECUTE PROCEDURE process_controllers_audit();