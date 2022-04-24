           SELECT unique HP.PARTY_ID             PARTY_ID
                , HCA.CUST_ACCOUNT_ID            CUST_ACCOUNT_ID
                , HP.party_name                  NOMBRE_CLIENTE
                , HP.JGZZ_FISCAL_CODE            RFC_CLIENTE
                , HP.COUNTRY                     PAIS
                , HCA.ATTRIBUTE3                 CFDI
                , HCA.ACCOUNT_NUMBER             NUMERO_CUENTA
             FROM HZ_CUST_ACCOUNTS         HCA
                , HZ_PARTIES               HP
                , HZ_CUST_ACCT_SITES_ALL   HCASA
                , HZ_ORGANIZATION_PROFILES HOP
                , HZ_CUST_SITE_USES_ALL    HCSUA
                , HZ_PARTY_SITES           HPS
            WHERE 1 = 1
              AND HCA.PARTY_ID            = HP.PARTY_ID
              and HP.PARTY_ID             = HOP.PARTY_ID
              AND HCSUA.CUST_ACCT_SITE_ID = HCASA.CUST_ACCT_SITE_ID
              AND HCA.CUST_ACCOUNT_ID     = HCASA.CUST_ACCOUNT_ID
              AND HCASA.PARTY_SITE_ID     = HPS.PARTY_SITE_ID