/* Formatted on 25-04-2022 23:23:15 (QP5 v5.381) */
----Traslados

SELECT *
  FROM ( SELECT ZL.TAX_LINE_ID
              , ABS( ZL.TAXABLE_AMT )                                 "BASE" --38
              , DECODE( ZB.TAX,  'ISR', '001',  'IVA', '002' )        "IMPUESTO" -- 39  --LK
              -- ,FND_IMP.TAG "ImpuestoConcepRetencion"
              , 'Tasa'                                                "TIPO_FACTOR" -- 40 -- LK
              , ABS( ZL.TAX_RATE / 100 )                              "TASA_CUOTA" -- 41
              , TO_CHAR( ABS( ZL.TAX_AMT ), 'FM9999999999990.00' )    "IMPORTE" --42    ORIGINAL
              , 0                                                     FAC_MUESTRA
              , 0                                                     TRASLADO
           FROM ZX_LINES     ZL
              , ZX_TAXES_TL  ZTT
              , ZX_TAXES_B   ZB
              , (SELECT RCTL.TAX_LINE_ID, RCTTA.TYPE TIPO
                   FROM AR_LOOKUPS                 AL
                      , RA_CUST_TRX_TYPES_ALL      RCTTA
                      , RA_CUSTOMER_TRX_ALL        RCT
                      , RA_CUSTOMER_TRX_LINES_ALL  RCTL
                  WHERE 1 = 1                --RCTL.TAX_LINE_ID = ZL.TAX_LINE_ID
                    AND RCTL.CUSTOMER_TRX_ID = RCT.CUSTOMER_TRX_ID
                    AND RCTTA.CUST_TRX_TYPE_SEQ_ID = RCT.CUST_TRX_TYPE_SEQ_ID
                    AND AL.LOOKUP_TYPE = 'INV/CM'
                    AND AL.LOOKUP_CODE = RCTTA.TYPE
                    AND AL.LOOKUP_CODE = 'CM'--AND ROWNUM = 1
                                             ) XXTYP
          WHERE ZTT.LANGUAGE = USERENV( 'LANG' )
            AND XXTYP.TAX_LINE_ID(+) = ZL.TAX_LINE_ID
            AND ZL.TAX_ID = ZTT.TAX_ID
            AND ZB.TAX_ID = ZTT.TAX_ID
            AND DECODE( XXTYP.TIPO, 'CM', ABS( ZL.TAX_AMT ), ZL.TAX_AMT ) >= 0
            --and ZL.TAX_LINE_ID = 148025
            AND 1 = 1
         UNION ALL
         SELECT ZL.TAX_LINE_ID
              , ABS( ZL.TAXABLE_AMT )                             "BASE"    --38
              , DECODE( ZB.TAX,  'ISR', '001',  'IVA', '002' )    "IMPUESTO" -- 39  --LK
              -- ,FND_IMP.TAG "ImpuestoConcepRetencion"
              , 'Tasa'                                            "TIPO_FACTOR" -- 40 -- LK
              , 0                                                 "TASA_CUOTA" -- 41
              , '0.00'                                            "IMPORTE" --42    ORIGINAL
              , 1                                                 FAC_MUESTRA
              , 0                                                 TRASLADO
           FROM ZX_LINES     ZL
              , ZX_TAXES_TL  ZTT
              , ZX_TAXES_B   ZB
              , (SELECT RCTL.TAX_LINE_ID, RCTTA.TYPE TIPO
                   FROM AR_LOOKUPS                 AL
                      , RA_CUST_TRX_TYPES_ALL      RCTTA
                      , RA_CUSTOMER_TRX_ALL        RCT
                      , RA_CUSTOMER_TRX_LINES_ALL  RCTL
                  WHERE 1 = 1                --RCTL.TAX_LINE_ID = ZL.TAX_LINE_ID
                    AND RCTL.CUSTOMER_TRX_ID = RCT.CUSTOMER_TRX_ID
                    AND RCTTA.CUST_TRX_TYPE_SEQ_ID = RCT.CUST_TRX_TYPE_SEQ_ID
                    AND AL.LOOKUP_TYPE = 'INV/CM'
                    AND AL.LOOKUP_CODE = RCTTA.TYPE
                    AND AL.LOOKUP_CODE = 'CM'--AND ROWNUM = 1
                                             ) XXTYP
          WHERE ZTT.LANGUAGE = USERENV( 'LANG' )
            AND XXTYP.TAX_LINE_ID(+) = ZL.TAX_LINE_ID
            AND ZL.TAX_ID = ZTT.TAX_ID
            AND ZB.TAX_ID = ZTT.TAX_ID
            AND DECODE( XXTYP.TIPO, 'CM', ABS( ZL.TAX_AMT ), ZL.TAX_AMT ) >= 0
            --and ZL.TAX_LINE_ID = 148025
            AND 1 = 1
         UNION ALL
         SELECT ZL.TAX_LINE_ID
              , NULL     "BASE"                                             --38
              , NULL     "IMPUESTO"                                  -- 39  --LK
              -- ,FND_IMP.TAG "ImpuestoConcepRetencion"
              , NULL     "TIPO_FACTOR"                               -- 40 -- LK
              , NULL     "TASA_CUOTA"                                      -- 41
              , NULL     "IMPORTE"                              --42    ORIGINAL
              , 0        FAC_MUESTRA
              , 1        TRASLADO
           FROM ZX_LINES     ZL
              , ZX_TAXES_TL  ZTT
              , ZX_TAXES_B   ZB
              , (SELECT RCTL.TAX_LINE_ID, RCTTA.TYPE TIPO
                   FROM AR_LOOKUPS                 AL
                      , RA_CUST_TRX_TYPES_ALL      RCTTA
                      , RA_CUSTOMER_TRX_ALL        RCT
                      , RA_CUSTOMER_TRX_LINES_ALL  RCTL
                  WHERE 1 = 1                --RCTL.TAX_LINE_ID = ZL.TAX_LINE_ID
                    AND RCTL.CUSTOMER_TRX_ID = RCT.CUSTOMER_TRX_ID
                    AND RCTTA.CUST_TRX_TYPE_SEQ_ID = RCT.CUST_TRX_TYPE_SEQ_ID
                    AND AL.LOOKUP_TYPE = 'INV/CM'
                    AND AL.LOOKUP_CODE = RCTTA.TYPE
                    AND AL.LOOKUP_CODE = 'CM'--AND ROWNUM = 1
                                             ) XXTYP
          WHERE ZTT.LANGUAGE = USERENV( 'LANG' )
            AND XXTYP.TAX_LINE_ID(+) = ZL.TAX_LINE_ID
            AND ZL.TAX_ID = ZTT.TAX_ID
            AND ZB.TAX_ID = ZTT.TAX_ID
            AND DECODE( XXTYP.TIPO, 'CM', ABS( ZL.TAX_AMT ), ZL.TAX_AMT ) >= 0
            --and ZL.TAX_LINE_ID = 148025
            AND 1 = 1 )