DROP FUNCTION IF EXISTS FN_Users_IU;

CREATE OR REPLACE FUNCTION FN_Users_IU(
	refid uuid,
	userfn character varying,
	usersn character varying,
	userln character varying,
	useremail character varying,
	userphone character varying,
	userpwd character varying,
	usernewpwd character varying,
	execby character varying,
	type_qq character varying
)
RETURNS uuid AS 
$$ BEGIN
	IF (type_qq = 'U') THEN 
		IF NOT EXISTS (
			SELECT 1
			FROM "Users"
			WHERE
				FN_DecryptPassword(userpwd, "PasswordHash") = true AND
				"RefID" = refid
			FOR UPDATE
		) THEN
			RETURN NULL;
		END IF;
		
		IF (usernewpwd IS NOT NULL) THEN
			UPDATE "Users"
			SET 
				"RefID" = refid,
				"FirstName" = userfn,
				"SecondName" = usersn,
				"LastName" = userln,
				"Phone" = userphone,
				"Email" = useremail,
				"PasswordHash" = FN_CryptPassword(usernewpwd),
				"updated_by" = execby,
				"updated_dt" = NOW()
			WHERE 
				"RefID" = refid;
		ELSE 
			UPDATE "Users"
			SET 
				"RefID" = refid,
				"FirstName" = userfn,
				"SecondName" = usersn,
				"LastName" = userln,
				"Phone" = userphone,
				"Email" = useremail,
				"updated_by" = execby,
				"updated_dt" = NOW()
			WHERE 
				"RefID" = refid;
		END IF;
		RETURN refid;
	END IF;

	COMMIT;
END $$ LANGUAGE 'plpgsql';