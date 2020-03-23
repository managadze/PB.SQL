DROP FUNCTION IF EXISTS FN_Users_S;

CREATE OR REPLACE FUNCTION FN_Users_S(
	point_refid uuid
)
RETURNS TABLE (
	operatorfi text,
	refid uuid
) AS
$$ BEGIN

	RETURN QUERY SELECT 
		CONCAT(U."FirstName", ' ', U."SecondName"),
		U."RefID"
	FROM "Users" U
	FOR UPDATE;

END $$ LANGUAGE 'plpgsql';