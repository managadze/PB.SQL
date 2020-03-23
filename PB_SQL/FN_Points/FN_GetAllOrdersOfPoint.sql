DROP FUNCTION IF EXISTS FN_GetAllOrdersOfPoint;

CREATE OR REPLACE FUNCTION FN_GetAllOrdersOfPoint(
	point_refid uuid
)
RETURNS TABLE (
	numberoforderstoday integer,
	numberofordersnow integer
) AS
$$ 
DECLARE 
	numberoforderstoday integer := 0;
	numberofordersnow integer := 0;
BEGIN
	
	numberofordersnow := (
		SELECT 
			COUNT(1)
		FROM "Order"
		WHERE 
			"State" != 'Ready' AND
			date_part('day', "OrderDateTime") = date_part('day', NOW())
	);
	
	numberoforderstoday := (
		SELECT 
			COUNT(1)
		FROM "Order"
		WHERE
			"State" = 'Ready' AND
			date_part('day', "OrderDateTime") = date_part('day', NOW())
	);
	
	RETURN QUERY SELECT numberoforderstoday, numberofordersnow;
		

END $$ LANGUAGE 'plpgsql';

