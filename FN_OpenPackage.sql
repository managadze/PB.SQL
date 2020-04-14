DROP FUNCTION IF EXISTS FN_OpenPackage;

CREATE OR REPLACE FUNCTION FN_OpenPackage (
cell_name varchar
)
RETURNS boolean
AS
$$ BEGIN
 UPDATE "Cell"
 SET "IsOpen" = TRUE
 WHERE "Code" = cell_name;
 COMMIT;
 RETURN TRUE;
EXCEPTION
 WHEN OTHERS THEN
  BEGIN
    ROLLBACK;
    RETURN FALSE;
  END;
END $$ LANGUAGE 'plpgsql';


select FN_OpenPackage('B2_D4');