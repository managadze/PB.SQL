CREATE OR REPLACE FUNCTION FN_CryptPassword(password text)
RETURNS text AS
$$
	SELECT crypt($1, gen_salt('bf'))
$$ LANGUAGE SQL STRICT IMMUTABLE;