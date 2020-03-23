DROP FUNCTION IF EXISTS FN_GetOrderRecipes;
CREATE OR REPLACE FUNCTION FN_GetOrderRecipes 
(	
	order_refid uuid
)
RETURNS TABLE 
(
	orderchekcode character varying,
	orderstate character varying,
	doughrecipepath character varying,
	fillingrecipepath character varying,
	saucerecipepath character varying,
	additiverecipepath character varying
) AS
$$
BEGIN
   RETURN QUERY SELECT
   		ORD."CheckCode"::character varying,
		ORD."State"::character varying,
		D_Temp."RecipesPath"::character varying,
		FIL_Temp."RecipesPath"::character varying,
		SAU_Temp."RecipesPath"::character varying,
		ADVE_Temp."RecipesPath"::character varying		
   FROM "DishesInOrder" DinORD
   		INNER JOIN "Order" ORD
			ON ORD."RefID" = DinORD."OrderRefID"
		INNER JOIN "Dish" DIS
			ON DIS."RefID" = DinORD."DishRefID"
		INNER JOIN "Additive" ADVE
			ON ADVE."RefID" =  DIS."AdditiveRefID"
		INNER JOIN "Dough" DOU
			ON DOU."RefID" = DIS."DoughRefID"
		INNER JOIN "Filling" FIL
			ON FIL."RefID" = DIS."FillingRefID"
		INNER JOIN "Sauce" SAU
			ON SAU."RefID" = DIS."SauceRefID"
		INNER JOIN "DishPartTemplate" ADVE_Temp
			ON ADVE_Temp."RefID" = ADVE."TemplateRefID"
		INNER JOIN "DishPartTemplate" D_Temp
			ON D_Temp."RefID" = DOU."TemplateRefID"
		INNER JOIN "DishPartTemplate" FIL_Temp
			ON FIL_Temp."RefID" = FIL."TemplateRefID"
		INNER JOIN "DishPartTemplate" SAU_Temp
			ON SAU_Temp."RefID" = SAU."TemplateRefID"
	WHERE DinORD."OrderRefID" = order_refid
	FOR UPDATE;
END $$ LANGUAGE 'plpgsql';
