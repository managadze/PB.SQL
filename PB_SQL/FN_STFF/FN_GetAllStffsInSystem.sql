DROP FUNCTION IF EXISTS FN_GetAllStffsInSystem;

CREATE OR REPLACE FUNCTION FN_GetAllStffsInSystem(
	point_refid uuid
)
RETURNS TABLE (
	refid uuid,
	stffname character varying
) AS
$$ 
BEGIN
	
	RETURN QUERY SELECT
		STFF."RefID",
		STFF."Name"
	FROM "Halfstuff" STFF
	ORDER BY STFF."Name"
	FOR UPDATE;

END $$ LANGUAGE 'plpgsql';



