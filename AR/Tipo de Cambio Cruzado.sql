WITH T_CROSS_CURRENCY_RATE
     AS (
         SELECT CASH.RECEIPT_NUMBER                                             RECEIPT_NUMBER
              , TRX.TRX_NUMBER                                                  TRX_NUMBER
              , CASH.AMOUNT                                                     RECEIPT_AMOUNT
              , CASH.CURRENCY_CODE                                              RECEIPT_CURRENCY
              , TRX.INVOICE_CURRENCY_CODE                                       TRX_CURRENCY
              , APPS.AMOUNT_APPLIED                                             TRX_AMT_APPLIED
              , APPS.ACCTD_AMOUNT_APPLIED_TO                                    TRX_AMT_APPLIED_BASE
              , APPS.AMOUNT_APPLIED_FROM                                        ACTUAL_ALLOC_RECEIPT_AMT
              , APPS.ACCTD_AMOUNT_APPLIED_FROM                                  ACTUAL_ALLOC_RECEIPT_AMT_BASE
              ,  APPS.TRANS_TO_RECEIPT_RATE                                     ACTUAL_CROSS_CURR_RATE
              , CASH.RECEIPT_DATE                                               RECEIPT_DATE
              , CASH.EXCHANGE_RATE                                              RECEIPT_EXCHANGE_RATE
              , TRX.TRX_DATE                                                    TRX_DATE
              , CURR.PRECISION                                                  RECEIPT_PRECISION
              , CASH.CASH_RECEIPT_ID                                            RECEIPT_ID
             FROM FND_CURRENCIES                 CURR
                , AR_RECEIVABLE_APPLICATIONS_ALL APPS
                , RA_CUSTOMER_TRX_ALL            TRX
                , AR_CASH_RECEIPTS_ALL           CASH
            WHERE 1 = 1
              AND APPS.APPLIED_CUSTOMER_TRX_ID = TRX.CUSTOMER_TRX_ID
              AND APPS.CASH_RECEIPT_ID         = CASH.CASH_RECEIPT_ID
              AND APPS.STATUS                  = 'APP'
              AND APPS.DISPLAY                 = 'Y'
              AND CURR.CURRENCY_CODE(+)        = CASH.CURRENCY_CODE
              AND CASH.CURRENCY_CODE          != TRX.INVOICE_CURRENCY_CODE 
              AND CASH.RECEIPT_NUMBER          = NVL(:P_RECIBO,CASH.RECEIPT_NUMBER) -- '20200701-11'
            order by CASH.CASH_RECEIPT_ID asc
                   , TRX.CUSTOMER_TRX_ID  asc
        )
-----------------------------------------------------------------------------------------------------

SELECT RECEIPT_NUMBER
     , TRX_NUMBER
     , trim(TO_CHAR(RECEIPT_AMOUNT                 , '999,999,999,999,999.000000'))  RECEIPT_AMOUNT
     , RECEIPT_CURRENCY
     , TRX_CURRENCY
     , trim(TO_CHAR(TRX_AMT_APPLIED                , '999,999,999,999,999.000000'))  TRX_AMT_APPLIED              
     , trim(TO_CHAR(TRX_AMT_APPLIED_BASE           , '999,999,999,999,999.000000'))  TRX_AMT_APPLIED_BASE         
     , trim(TO_CHAR(ACTUAL_ALLOC_RECEIPT_AMT       , '999,999,999,999,999.000000'))  ACTUAL_ALLOC_RECEIPT_AMT     
     , trim(TO_CHAR(ACTUAL_CROSS_CURR_RATE         , '999,999,999,999,999.000000'))  ACTUAL_CROSS_CURR_RATE       
     , trim(TO_CHAR((
        SELECT SUM (T1.ACCTD_AMOUNT_APPLIED_FROM )
          FROM AR_RECEIVABLE_APPLICATIONS_ALL T1
         WHERE 1 = 1
           AND T1.STATUS          = 'APP'
           AND T1.DISPLAY         = 'Y'
           AND T1.CASH_RECEIPT_ID = RECEIPT_ID
       ), '999,999,999,999,999.000000')) SUMA
     , (case when trunc(RECEIPT_AMOUNT) = trunc((SELECT SUM (T1.ACCTD_AMOUNT_APPLIED_FROM )
                                                   FROM AR_RECEIVABLE_APPLICATIONS_ALL T1
                                                  WHERE 1 = 1
                                                    AND T1.STATUS          = 'APP'
                                                    AND T1.DISPLAY         = 'Y'
                                                    AND T1.CASH_RECEIPT_ID = RECEIPT_ID)) then 
          'TRUE'
        ELSE
          'FALSE'  
        end) BANDERA
     , (RECEIPT_AMOUNT -  (SELECT SUM (T1.ACCTD_AMOUNT_APPLIED_FROM )
                                                   FROM AR_RECEIVABLE_APPLICATIONS_ALL T1
                                                  WHERE 1 = 1
                                                    AND T1.STATUS          = 'APP'
                                                    AND T1.DISPLAY         = 'Y'
                                                    AND T1.CASH_RECEIPT_ID = RECEIPT_ID) ) diferencia
  FROM T_CROSS_CURRENCY_RATE TCCR
 where 1 = 1
   and (case when trunc(RECEIPT_AMOUNT) = trunc((SELECT SUM (T1.ACCTD_AMOUNT_APPLIED_FROM )
                                                   FROM AR_RECEIVABLE_APPLICATIONS_ALL T1
                                                  WHERE 1 = 1
                                                    AND T1.STATUS          = 'APP'
                                                    AND T1.DISPLAY         = 'Y'
                                                    AND T1.CASH_RECEIPT_ID = RECEIPT_ID)) then 
          'TRUE'
        ELSE
          'FALSE'  
        end)     =  'TRUE'  
   and (TCCR.RECEIPT_AMOUNT -  (SELECT SUM (T1.ACCTD_AMOUNT_APPLIED_FROM )
                                                   FROM AR_RECEIVABLE_APPLICATIONS_ALL T1
                                                  WHERE 1 = 1
                                                    AND T1.STATUS          = 'APP'
                                                    AND T1.DISPLAY         = 'Y'
                                                    AND T1.CASH_RECEIPT_ID = RECEIPT_ID) ) between -1 
                                                                                               and 1