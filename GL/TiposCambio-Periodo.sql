SELECT     trunc(AVG(1/CONVERSION_RATE),3)                    CONVERSION_RATE
          , RAT.FROM_CURRENCY          TO_CURRENCY
          , RAT.TO_CURRENCY                 FROM_CURRENCY
          , gp.period_name
       FROM GL_DAILY_RATES             RAT,
	        GL_PERIODS                 GP
       WHERE 1 = 1
         AND RAT.CONVERSION_TYPE = 'Corporate'
         AND RAT.FROM_CURRENCY   = :P_MONEDA_LIBRO
		 AND TO_CHAR(RAT.CONVERSION_DATE,'MMYYYY') = to_char(gp.end_date,'MMYYYY')
		 and gp.period_name = :P_PERIODO
		  GROUP BY 
        	RAT.FROM_CURRENCY          
          , RAT.TO_CURRENCY            
          , gp.period_name