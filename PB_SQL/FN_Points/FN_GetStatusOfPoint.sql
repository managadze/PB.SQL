DROP FUNCTION IF EXISTS FN_GetStatusOfPoint;

CREATE OR REPLACE FUNCTION FN_GetStatusOfPoint(
    address character varying
)
RETURNS character varying AS
$$ BEGIN
	
	RETURN (
		SELECT 
			PC."TurningStatus"
		FROM "Point" PC
		WHERE
			PC."Address" = address
	);

END $$ LANGUAGE 'plpgsql';

