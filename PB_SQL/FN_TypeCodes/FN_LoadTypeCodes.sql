DROP FUNCTION IF EXISTS FN_LoadTypeCodes;

CREATE OR REPLACE FUNCTION FN_LoadTypeCodes(
	typename character varying
)
RETURNS TABLE (
	typevalue character varying,
    typedescription character varying
) AS
$$ BEGIN
    IF (typename = null) THEN
        RETURN;
    END IF;

    RETURN QUERY SELECT 
        TC."Value",
        TC."ShortDescription"
    FROM 
        "TypeCode" TC
    WHERE 
        TC."TypeName" = typename
	FOR UPDATE;

END $$ LANGUAGE 'plpgsql';

IF (1 = 0) THEN
	SELECT *
	FROM FN_LoadOperatorHistory("WashingType");
END IF;