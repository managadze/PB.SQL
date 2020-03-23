DROP FUNCTION IF EXISTS FN_GetAllSTFFsStatus;

CREATE OR REPLACE FUNCTION FN_GetAllSTFFsStatus(
	point_refid uuid
)
RETURNS TABLE (
	stffname character varying,
	balance integer
) AS
$$ 
BEGIN
	
	RETURN QUERY SELECT
		STFF."Name", 
		STFF."Balance"
	FROM "Halfstuff" STFF
	ORDER BY STFF."Balance";

END $$ LANGUAGE 'plpgsql';

