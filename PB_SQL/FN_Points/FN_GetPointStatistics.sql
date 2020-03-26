DROP FUNCTION IF EXISTS FN_GetPointStatistics;

CREATE OR REPLACE FUNCTION FN_GetPointStatistics(
	point_refid uuid
)
RETURNS TABLE (
	numberoforderstoday integer,
	numberofordersnow integer,
	numberoferrors integer,
	numberofunavailabledishes integer
) AS
$$ 
DECLARE 
	numberoforderstoday integer := 0;
	numberofordersnow integer := 0;
	numberofunavailabledishes integer := 0;
	numberoferrors integer := 0;
BEGIN
	
	numberofordersnow := (
		SELECT 
			COUNT(1)
		FROM "Order"
		WHERE 
			"State" != 'Ready' AND
			"OrderDateTime"::date = NOW()::date
			
	);
	
	numberoforderstoday := (
		SELECT 
			COUNT(1)
		FROM "Order"
		WHERE
			"State" = 'Ready' AND
			"OrderDateTime"::date = NOW()::date
	);
	
	numberoferrors := (
		SELECT 
			COUNT(1)
		FROM "ClientSideLogs"
		WHERE 
			"IsError" = true AND
			"created_dt"::date = NOW()::date
	);
	
	numberofunavailabledishes := 
	(
		SELECT 
			COUNT(1)
		FROM "Dough" D
		WHERE 
			FN_CheckAvailablityOfSTFF('dough', D."RefID") = true AND
			FN_CheckAvailablityOfSTFF('paper', null) = true
	) +
	(
		SELECT 
			COUNT(1)
		FROM "Sauce" S
		WHERE 
			FN_CheckAvailablityOfSTFF('sauce', S."RefID") = true AND
			FN_CheckAvailablityOfSTFF('paper', null) = true
	) +
	(
		SELECT 
			COUNT(1)
		FROM "Additive" ADVE
		WHERE 
			FN_CheckAvailablityOfSTFF('additive', ADVE."RefID") = true AND
			FN_CheckAvailablityOfSTFF('paper', null) = true
	) +
	(
		SELECT 
			COUNT(1)
		FROM "Filling" FLNG
		WHERE 
			FN_CheckAvailablityOfSTFF('filling', FLNG."RefID") = true AND
			FN_CheckAvailablityOfSTFF('paper', null) = true
	) +
	(
		SELECT 
			COUNT(1)
		FROM "Dish" DSH
		WHERE  
			DSH."IsCustomDish" = false AND
			FN_CheckAvailablityOfSTFF('dough', DSH."DoughRefID") = true AND
			FN_CheckAvailablityOfSTFF('sauce', DSH."SauceRefID") = true AND
			FN_CheckAvailablityOfSTFF('filling', DSH."FillingRefID") = true AND
			FN_CheckAvailablityOfSTFF('additive', DSH."AdditiveRefID") = true AND
			FN_CheckAvailablityOfSTFF('paper', null) = true
	);
	
	RETURN QUERY SELECT 
		numberoforderstoday, 
		numberofordersnow,
		numberoferrors,
		numberofunavailabledishes;

END $$ LANGUAGE 'plpgsql';



