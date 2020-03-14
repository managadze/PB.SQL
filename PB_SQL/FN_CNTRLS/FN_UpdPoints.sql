DROP FUNCTION IF EXISTS FN_UpdOutPoints;

CREATE OR REPLACE FUNCTION FN_UpdOutPoints(
    cntrlname character varying,
	pointid integer,
	enabled boolean,
    execby character varying
)
RETURNS boolean AS
$$ BEGIN
	UPDATE "Controllers"
	SET
		"ExtendedParams" = xml(REPLACE(
			"ExtendedParams"::text,
			data.from_change,
			data.to_change
		)),
        "updated_by" = execby,
        "updated_dt" = NOW()
	FROM 
		(
			select
				"RefID",
				unnest(xpath(CONCAT('//OutPoint[@id = ''', pointid, ''']'), "ExtendedParams"))::text,
				REPLACE(
					unnest(xpath(CONCAT('//OutPoint[@id = ''', pointid, ''']'), "ExtendedParams"))::text,
					CONCAT(
						'enabled="',
						unnest(xpath(CONCAT('//OutPoint[@id = ''', pointid, ''']/@enabled'), "ExtendedParams"))::text,
						'"'
					),
					CONCAT(
						'enabled="',
						enabled,
						'"'
					)
				)
			from "Controllers"
			where 
				"Name" = cntrlname AND
				xmlexists(CONCAT('//OutPoint[@id = ''', pointid, ''']') PASSING by ref "ExtendedParams")
		) as data(refid, from_change, to_change)
	WHERE
		"RefID" = data.refid;

    RETURN 1;
	COMMIT;
END $$ LANGUAGE 'plpgsql';