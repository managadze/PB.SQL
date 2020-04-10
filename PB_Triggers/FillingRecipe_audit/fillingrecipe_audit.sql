DROP TRIGGER IF EXISTS fillingrecipe_audit ON "FillingRecipe";

CREATE TRIGGER fillingrecipe_audit
BEFORE UPDATE OR DELETE ON "FillingRecipe"
FOR EACH ROW EXECUTE PROCEDURE process_fillingrecipe_audit();