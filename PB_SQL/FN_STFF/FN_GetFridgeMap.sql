DROP FUNCTION IF EXISTS FN_GetFridgeMap;

CREATE OR REPLACE FUNCTION FN_GetFridgeMap(
	point_refid uuid
)
RETURNS TABLE (
	refid uuid,
	codename character varying
) AS
$$ 
BEGIN
	
	RETURN QUERY SELECT
		CNTR."RefID",
		CNTR."CodeName"
	FROM "Container" CNTR
	ORDER BY CNTR."CodeName"
	FOR UPDATE;

END $$ LANGUAGE 'plpgsql';



