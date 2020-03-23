DROP FUNCTION IF EXISTS FN_LoadSTFF;

CREATE OR REPLACE FUNCTION FN_LoadSTFF(
	container_codename character varying,
	cell_codename character varying,
	stff_refid uuid,
	operatorfi character varying
)
RETURNS boolean AS
$$ 
DECLARE
	base_balance integer := 0;
BEGIN
	
	IF (container_codename is null OR
	     cell_codename is null OR
	   	  stff_refid is null) THEN
		RETURN false;
	END IF;
	
	base_balance := (
		SELECT 
			STFF_Temp."Balance"
		FROM "Halfstuff" STFF
			INNER JOIN "HalfstuffTemplate" STFF_Temp
				ON STFF."HalfstuffTemplateRefID" = STFF_Temp."RefID"
		WHERE 
			STFF."RefID" = stff_refid
		FOR UPDATE
	);
	
	with data(container_refid) as (
		SELECT "RefID"
		FROM "Container"
		WHERE "CodeName" = container_codename
	)
	UPDATE "Cell"
	SET 
		"Balance" = base_balance,
		"HalfstuffRefID" = stff_refid,
		"ServeTime" = NOW(),
		"updated_by" = operatorfi,
		"updated_dt" = NOW()
	FROM data
	WHERE 
		"ContainerRefID" = data.container_refid AND
		"Code" = cell_codename;
	
	with data(balance) as (
		SELECT SUM("Balance")
		FROM "Cell"
		WHERE 
			"HalfstuffRefID" = stff_refid AND
			"Code" = cell_codename
	)
	UPDATE "Halfstuff"
	SET
		"Balance" = data.balance,
		"LoadDateTime" = NOW(),
		"updated_by" = operatorfi,
		"updated_dt" = NOW()
	FROM data
	WHERE "RefID" = stff_refid;
	
	RETURN true;
	COMMIT;

END $$ LANGUAGE 'plpgsql';



