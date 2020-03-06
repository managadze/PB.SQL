CREATE OR REPLACE FUNCTION FN_DecryptPassword(password text, password_hash text)
RETURNS boolean AS
$$
	SELECT $2 = crypt($1, $2)
$$ LANGUAGE SQL STRICT IMMUTABLE;