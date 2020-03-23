DROP FUNCTION IF EXISTS FN_UnloadSTFF;

CREATE OR REPLACE FUNCTION FN_UnloadSTFF(
	container_refid uuid,
	operatorfi character varying
)
RETURNS boolean AS
$$ 
BEGIN
	
	IF (container_refid is null) THEN
		RETURN false;
	END IF;
	
	with data(stff_refid, balance) as (
		SELECT 
			CLL."HalfstuffRefID",
			SUM(CLL."Balance")
		FROM "Cell" CLL
		WHERE 
			CLL."ContainerRefID" = container_refid
		GROUP BY CLL."HalfstuffRefID"
	)
	UPDATE "Halfstuff"
	SET 
		"Balance" = "Balance" - data.balance,
		"updated_by" = operatorfi,
		"updated_dt" = NOW()
	FROM data
	WHERE 
		"RefID" = data.stff_refid;
	
	RETURN true;
	COMMIT;

END $$ LANGUAGE 'plpgsql';