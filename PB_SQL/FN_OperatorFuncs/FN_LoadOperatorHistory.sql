DROP FUNCTION IF EXISTS FN_LoadOperatorHistory;

CREATE OR REPLACE FUNCTION FN_LoadOperatorHistory(
	userrefid uuid,
	operationtype character varying,
	datefrom timestamp,
	dateto timestamp,
	is_return_json boolean DEFAULT true,
	last_action boolean DEFAULT false
)
RETURNS TABLE (
	operatorfi text,
	type character varying,
	data character varying,
	dateofoperation timestamp
) AS
$$ BEGIN

	IF (is_return_json = true) THEN
		IF (last_action = true) THEN
			RETURN QUERY SELECT 
				CONCAT(U."FirstName", ' ', U."SecondName"),
				OH."OperationType",
				OH."OperationData", 
				OH."Date"
			FROM "OperatorHistory" OH
				INNER JOIN "Users" U
					ON U."RefID" = OH."UserRefID"
			WHERE
				(userrefid is null OR U."RefID" = userrefid) AND
				(OH."OperationType" = operationtype OR operationtype is null) 
			ORDER BY OH."Date" DESC
			LIMIT 1
			FOR UPDATE;
		ELSE
			RETURN QUERY SELECT 
				CONCAT(U."FirstName", ' ', U."SecondName"),
				OH."OperationType",
				OH."OperationData", 
				OH."Date"
			FROM "OperatorHistory" OH
				INNER JOIN "Users" U
					ON U."RefID" = OH."UserRefID"
			WHERE
				(userrefid is null OR U."RefID" = userrefid) AND
				(OH."OperationType" = operationtype OR operationtype is null) AND
				(OH."Date" >= datefrom and OH."Date" <= dateto)
			ORDER BY OH."Date" DESC
			FOR UPDATE;
		END IF;
	END IF;

END $$ LANGUAGE 'plpgsql';

IF (1 = 0) THEN
	SELECT *
	FROM FN_LoadOperatorHistory(null, null, NOW(), NOW() + integer '7', false)
END IF;

IF (1 = 0) THEN
	SELECT *
	FROM FN_LoadOperatorHistory('82d8f92c-5e4d-11ea-aab5-001d6001edc0', 'WASHING', NOW(), NOW() + integer '7', false)
END IF;