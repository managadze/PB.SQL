DROP FUNCTION IF EXISTS FN_OperatorHistory_I;

CREATE OR REPLACE FUNCTION FN_OperatorHistory_I(
	userrefid uuid,
	actiontype character varying,
	actioncontent character varying,
	is_json_content boolean DEFAULT true
) RETURNS boolean AS
$$ BEGIN
	IF (userrefid = null) THEN
		RETURN false;
	END IF;
	
	IF (is_json_content) THEN
		INSERT INTO "OperatorHistory"
		VALUES (
			userrefid,
			uuid_generate_v1(),
			actiontype,
			actioncontent,
			NOW()
		);
	END IF;

	RETURN true;
	COMMIT;
END $$ LANGUAGE 'plpgsql';

IF (1 = 0) THEN
    FN_OperatorHistory_I(null, null, null, false);
END IF;

IF (1 = 0) THEN
    FN_OperatorHistory_I('82d8f92c-5e4d-11ea-aab5-001d6001edc0', 'WASHING', '{"washingType": "Мойка 1"}', true);
END IF;