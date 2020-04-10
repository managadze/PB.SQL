DROP TRIGGER IF EXISTS users_audit ON "Users";

CREATE TRIGGER users_audit
BEFORE UPDATE OR DELETE ON "Users"
FOR EACH ROW EXECUTE PROCEDURE process_users_audit();
