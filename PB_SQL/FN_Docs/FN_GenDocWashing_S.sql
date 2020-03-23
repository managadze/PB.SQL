DROP FUNCTION IF EXISTS FN_GenDocWashing_S;

CREATE OR REPLACE FUNCTION FN_GenDocWashing_S(
	userrefid uuid,
	datefrom timestamp,
	dateto timestamp,
	typeofwashing character varying
)
RETURNS TABLE (
	operatorfi text,
	washingexecuter text,
	washingtype character varying,
	data timestamp
) AS
$$ 
DECLARE regexpr character varying := 'WASHING';
BEGIN
	IF typeofwashing = 'WASHING_ALL' THEN
		regexpr := '%WASHING%';
	END IF;
	
	IF (typeofwashing = 'WASHING_AUTO') THEN
		regexpr := 'WASHING_AUTO';
	END IF;

	RETURN QUERY SELECT 
			CONCAT(U."FirstName", ' ', U."SecondName"),
			CASE
				WHEN OH."OperationType" = 'WASHING' THEN 'Мойка произведена оператором'
				WHEN OH."OperationType" = 'WASHING_AUTO' THEN 'Мойка произведена системой' 
			END,
			(OH."OperationData"::json -> 'washingType')::character varying,
			OH."Date"
	FROM "OperatorHistory" OH
		INNER JOIN "Users" U
			ON U."RefID" = OH."UserRefID"
	WHERE 
		(U."RefID" = userrefid OR userrefid is null) AND
		OH."OperationType" LIKE regexpr AND
		(OH."Date" >= datefrom and OH."Date" <= dateto)
	FOR UPDATE;

END $$ LANGUAGE 'plpgsql';

