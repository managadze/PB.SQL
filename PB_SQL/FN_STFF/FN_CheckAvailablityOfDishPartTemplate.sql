DROP FUNCTION IF EXISTS FN_CheckAvailablityOfDishPartTemplate;

CREATE OR REPLACE FUNCTION FN_CheckAvailablityOfDishPartTemplate(
	stff_type character varying,
	refid uuid
) RETURNS boolean AS
$$ 
DECLARE
	IsStffAvailable boolean := true;
	CountOfIngredients integer := 0;
	CountOfAvailableIngredients integer := 0;
	TimeOfServer time;
	TimeOfServeWithoutUsing time;
BEGIN
	
	IF (stff_type = 'dough') THEN
	
	 TimeOfServer := NOW()-(
	SELECT CL."ServeTime" + STFF_Temp."ServerTime"::interval
		FROM "Cell" CL
			INNER JOIN "Halfstuff" STFF
		ON STFF."RefID" = CL."RefID"
			INNER JOIN "HalfstuffTemplate" STFF_Temp
		ON STFF_Temp."RefID" = CL."RefID"		 
		 	INNER JOIN "Dough" D
		 ON D."HalfstuffRefID" = STFF."RefID"
		 	WHERE D."RefID" = refid AND CL."RefID" = refid		 	
	);
	
	TimeOfServeWithoutUsing := NOW()-(
	SELECT CL."ServeTime" + STFF_Temp."ServeTimeWithoutUsing"::interval
		FROM "Cell" CL
			INNER JOIN "Halfstuff" STFF
		ON STFF."RefID" = CL."RefID"
			INNER JOIN "HalfstuffTemplate" STFF_Temp
		ON STFF_Temp."RefID" = CL."RefID"		
		    INNER JOIN "Dough" D
	    ON D."HalfstuffRefID" = STFF."RefID"
		 	WHERE D."RefID" = refid	AND CL."RefID" = refid
	);
	
	IF (TimeOfServer < TimeOfServeWithoutUsing)
		THEN  TimeOfServer := TimeServer;
	END IF;
	
	IF (TimeOfServer > TimeOfServeWithoutUsing)
		THEN  TimeOfServeWithoutUsing := TimeOfServeWithoutUsing;
	END IF;
		
		IsStffAvailable = (
			SELECT 
				COUNT(1)
			FROM "Dough" D
			INNER JOIN "Halfstuff" STFF
					ON D."HalfstuffRefID" = STFF."RefID"
			INNER JOIN "Cell" CL
					ON D."RefID" = CL."RefID"
			WHERE 
				STFF."Balance" >= 1 AND
				D."RefID" = refid 
			
		) > 0;
	
	ELSEIF (stff_type = 'additive') THEN
	
	 TimeOfServer := NOW()-(
	SELECT CL."ServeTime" + STFF_Temp."ServerTime"::interval
		FROM "Cell" CL
			INNER JOIN "Halfstuff" STFF
		ON STFF."RefID" = CL."RefID"
			INNER JOIN "HalfstuffTemplate" STFF_Temp
		ON STFF_Temp."RefID" = CL."RefID"		 
		 	INNER JOIN "Additive" ADVE
		 ON ADVE."HalfstuffRefID" = STFF."RefID"
		 	WHERE ADVE."RefID" = refid AND CL."RefID" = refid		 	
	);
	
	TimeOfServeWithoutUsing := NOW()-(
	SELECT CL."ServeTime" + STFF_Temp."ServeTimeWithoutUsing"::interval
		FROM "Cell" CL
			INNER JOIN "Halfstuff" STFF
		ON STFF."RefID" = CL."RefID"
			INNER JOIN "HalfstuffTemplate" STFF_Temp
		ON STFF_Temp."RefID" = CL."RefID"		
		    INNER JOIN "Additive" ADVE
	    ON ADVE."HalfstuffRefID" = STFF."RefID"
		 	WHERE ADVE."RefID" = refid	AND CL."RefID" = refid
	);
	
	IF (TimeOfServer < TimeOfServeWithoutUsing)
		THEN  TimeOfServer := TimeServer;
	END IF;
	
	IF (TimeOfServer > TimeOfServeWithoutUsing)
		THEN  TimeOfServeWithoutUsing := TimeOfServeWithoutUsing;
	END IF;
	
		IsStffAvailable = (
			SELECT 
				COUNT(1)
			FROM "Additive" ADVE
				INNER JOIN "Halfstuff" STFF
					ON ADVE."HalfstuffRefID" = STFF."RefID"
			INNER JOIN "Cell" CL
					ON ADVE."RefID" = CL."RefID"
			WHERE 
				STFF."Balance" >= 1 AND
				ADVE."RefID" = refid
			
		) > 0;
	
	ELSEIF (stff_type = 'sauce') THEN
	
	 TimeOfServer := NOW()-(
	SELECT CL."ServeTime" + STFF_Temp."ServerTime"::interval
		FROM "Cell" CL
			INNER JOIN "Halfstuff" STFF
		ON STFF."RefID" = CL."RefID"
			INNER JOIN "HalfstuffTemplate" STFF_Temp
		ON STFF_Temp."RefID" = CL."RefID"		 
		 	INNER JOIN "Sauce" S
		 ON S."HalfstuffRefID" = STFF."RefID"
		 	WHERE S."RefID" = refid AND CL."RefID" = refid		 	
	);
	
	TimeOfServeWithoutUsing := NOW()-(
	SELECT CL."ServeTime" + STFF_Temp."ServeTimeWithoutUsing"::interval
		FROM "Cell" CL
			INNER JOIN "Halfstuff" STFF
		ON STFF."RefID" = CL."RefID"
			INNER JOIN "HalfstuffTemplate" STFF_Temp
		ON STFF_Temp."RefID" = CL."RefID"		
		    INNER JOIN "Sauce" S
	    ON S."HalfstuffRefID" = STFF."RefID"
		 	WHERE S."RefID" = refid	AND CL."RefID" = refid
	);
	
	IF (TimeOfServer < TimeOfServeWithoutUsing)
		THEN  TimeOfServer := TimeServer;
	END IF;
	
	IF (TimeOfServer > TimeOfServeWithoutUsing)
		THEN  TimeOfServeWithoutUsing := TimeOfServeWithoutUsing;
	END IF;
	
		IsStffAvailable = (
			SELECT 
				COUNT(1)
			FROM "Sauce" S
				INNER JOIN "Halfstuff" STFF
					ON S."HalfstuffRefID" = STFF."RefID"
			INNER JOIN "Cell" CL
					ON S."RefID" = CL."RefID"
			WHERE 
				STFF."Balance" >= 1 AND
				S."RefID" = refid
			
		) > 0;
	
	ELSEIF (stff_type = 'filling') THEN
		
		CountOfIngredients := (
			SELECT 
				COUNT(1)
			FROM "FillingRecipe" FLNG_R
			INNER JOIN "Cell" CL
					ON FLNG_R."FillingRefID" = CL."RefID"
			WHERE
				FLNG_R."FillingRefID" = reif
			
		);
		
		CountOfAvailableIngredients := (
			SELECT 
				COUNT(1)
			FROM "FillingRecipe" FLNG_R
				INNER JOIN "Halfstuff" STFF
					ON STFF."RefID" = FLNG_R."HalfstuffRefID"
			WHERE 
				FLNG_R."FillingRefID" = refid AND
				STFF."Balance" - FLNG_R."Balance" >= 0
			
		);
		
		IsStffAvailable := (
			SELECT
				CountOfAvailableIngredients - CountOfIngredients >= 0
		);
	
	ELSEIF (stff_type = 'paper') THEN
	
		IsStffAvailable := (
			SELECT 
				COUNT(1)
			FROM "Halfstuff" STFF
			WHERE 
				STFF."Type" = 'paper' AND
				STFF."Balance" >= 1
			
		) > 0;
	
	END IF;
	
	RETURN IsStffAvailable;

END $$ LANGUAGE 'plpgsql';




