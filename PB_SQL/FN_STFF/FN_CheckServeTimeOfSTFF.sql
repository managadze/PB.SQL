DROP FUNCTION IF EXISTS FN_CheckServeTimeOfSTFF;

CREATE OR REPLACE FUNCTION FN_CheckServeTimeOfSTFF(
	stff_refid uuid
) RETURNS boolean AS
$$ 
DECLARE
	TimeOfServer time;
	TimeOfServeWithoutUsing time;
BEGIN
		
	 TimeOfServer := NOW()-(
	SELECT CL."ServeTime" + STFF_Temp."ServerTime"::interval
		FROM "Cell" CL
			INNER JOIN "Halfstuff" STFF
		ON STFF."RefID" = CL."RefID"
			INNER JOIN "HalfstuffTemplate" STFF_Temp
		ON STFF_Temp."RefID" = CL."RefID"		 
		 	WHERE STFF."RefID" = refid		 	
	);
	
	TimeOfServeWithoutUsing := NOW()-(
	SELECT CL."ServeTime" + STFF_Temp."ServeTimeWithoutUsing"::interval
		FROM "Cell" CL
			INNER JOIN "Halfstuff" STFF
		ON STFF."RefID" = CL."RefID"
			INNER JOIN "HalfstuffTemplate" STFF_Temp
		ON STFF_Temp."RefID" = CL."RefID"		
		  WHERE STFF."RefID" = refid
	);
	
	IF (TimeOfServeWithoutUsing < TimeServer)
		THEN  TimeOfServer := TimeOfServeWithoutUsing;
	END IF;
	
	IF (TimeOfServer < 0 )
		THEN  RETURN false; 
	END IF;
	
	IF (TimeOfServer > 0)
		THEN RETURN true;
	END IF;
		
END $$ LANGUAGE 'plpgsql';
