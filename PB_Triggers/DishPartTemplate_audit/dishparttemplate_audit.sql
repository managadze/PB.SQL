DROP TRIGGER IF EXISTS dishparttemplate_audit ON "DishPartTemplate";

CREATE TRIGGER dishparttemplate_audit
BEFORE UPDATE OR DELETE ON "DishPartTemplate"
FOR EACH ROW EXECUTE PROCEDURE process_dishparttemplate_audit();