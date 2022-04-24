          SELECT UNIQUE FPOT.USER_PROFILE_OPTION_NAME  PROFILE_NAME
               , FPOV.PROFILE_OPTION_VALUE             PROFILE_VALUE
               , FPOV.PROFILE_OPTION_ID                FPO_ID
            FROM FND_PROFILE_OPTIONS        FPO
               , FND_PROFILE_OPTIONS_TL     FPOT
               , FND_PROFILE_OPTION_VALUES  FPOV
           WHERE 1 = 1
             AND FPO.PROFILE_OPTION_NAME     = FPOT.PROFILE_OPTION_NAME
             AND FPO.PROFILE_OPTION_ID       = FPOV.PROFILE_OPTION_ID
             AND FPOT.LANGUAGE               = USERENV( 'LANG' )