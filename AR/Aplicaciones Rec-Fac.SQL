WITH
    T_TOTALES_BASE
    AS
        (SELECT ARA2.CASH_RECEIPT_ID                                                      t_CASHRECEIPT_ID        --> Identificador del Recibo/Cobro/Pago
              , RCT2.CUSTOMER_TRX_ID                                                      t_CUSTOMERTRX_ID        --> Identificador de la Factura
              , ACR2.currency_code                                                        Moneda_rec              --> Moneda del Recibo/Cobro/Pago
              , RCT2.INVOICE_CURRENCY_CODE                                                Moneda_fac              --> Moneda de la Factura
              , zxl.TAX_RATE_CODE                                                         Codigo_impuesto         --> Codigo de Impuesto de la Linea de la Factura
              , RCTLA2.LINE_TYPE                                                          Tipo_linea              --> Tipo de Linea: "Linea o Impuesto"
              , NVL( acr2.exchange_rate, 1 )                                              tipo_cambio_rec         --> Tipo de Cambio del Recibo
              , NVL( ARA2.TRANS_TO_RECEIPT_RATE, 1 )                                      tipo_cambio_app         --> Tipo de Cambio de la Aplicacion
              , NVL( rct2.exchange_rate, 1 )                                              tipo_cambio_fac         --> Tipo de Cambio de la Factura
              , (1 / (1 / NVL( acr2.exchange_rate, 1 )))                                  TC_inverso_rec          --> Tipo de Cambio Inverso del Recibo                             
              , (1 / (1 / NVL( ARA2.TRANS_TO_RECEIPT_RATE, 1 )))                          TC_inverso_app          --> Tipo de Cambio Inverso de la Aplicacion
              , (1 / (1 / NVL( rct2.exchange_rate, 1 )))                                  TC_inverso_rec          --> Tipo de Cambio Inverso de la Factura 
              --------------------------------------------------------------------------------------------------------
              , RCTLA2.TAXABLE_AMOUNT                                                     Impuesto_linea_TRX      --> Linea de la Factura  
              , RCTLA2.EXTENDED_AMOUNT                                                    Monto_Linea_TRX         --> Linea de la Factura
              , RCTLA2.REVENUE_AMOUNT                                                     Monto_Ingresos_TRX      --> Linea de la Factura
              , ARA2.LINE_APPLIED                                                         Linea_aplicada          --> Aplicacion
              , ARA2.TAX_APPLIED                                                          Impuesto_aplicado       --> Aplicacion
              , ARA2.AMOUNT_APPLIED                                                       MONTO_APLICDO           --> Aplicacion
            ----------------------------------------------------------------------------------------------------------
              , 1 / ARA2.TRANS_TO_RECEIPT_RATE                                            equivalencia            --> Aplicacion           Calculos de Ejemplos
              , 1/(1 / ARA2.TRANS_TO_RECEIPT_RATE)                                        nuevo_TC                --> Nuevo Tipo de Cambio Calculos de Ejemplos
           FROM AR_CASH_RECEIPTS_ALL            ACR2   --* Recibos
              , AR_RECEIVABLE_APPLICATIONS_ALL  ARA2   --* Aplicaciones
              , RA_CUSTOMER_TRX_ALL             RCT2   --* Facturas
              , RA_CUSTOMER_TRX_LINES_ALL       RCTLA2 --* Lineas de las Facturas
              , zx_lines                        zxl    --* Impuestos de las lineas de la Factura
          WHERE 1 = 1   -- cuando sea verdadero
            AND ACR2.CASH_RECEIPT_ID         = ARA2.CASH_RECEIPT_ID     -- Del Recibo a la aplicacion
            AND ARA2.STATUS                  = 'APP'                    -- En la aplicacion
            AND ARA2.AMOUNT_APPLIED          <> 0                       -- En la aplicacion
            AND ARA2.DISPLAY                 = 'Y'                      -- En la aplicacion
            AND ARA2.APPLIED_CUSTOMER_TRX_ID = RCT2.CUSTOMER_TRX_ID     -- De la aplicacion a la factura
            AND RCT2.CUSTOMER_TRX_ID         = RCTLA2.CUSTOMER_TRX_ID   -- De la factura a las lineas de las Facturas
            AND RCTLA2.tax_line_id           = zxl.tax_line_id          -- De la linea de la factura a sus detalles de impuestos
                                  )
select ttb.t_CASHRECEIPT_ID  
     , ttb.t_CUSTOMERTRX_ID  
     , ttb.Moneda_rec        
     , ttb.Moneda_fac        
     , ttb.Codigo_impuesto   
     , ttb.Tipo_linea        
     , ttb.tipo_cambio_rec   
     , ttb.tipo_cambio_app   
     , ttb.tipo_cambio_fac   
     , ttb.TC_inverso_rec    
     , ttb.TC_inverso_app    
     , ttb.TC_inverso_rec    
     , ttb.Impuesto_linea_TRX
     , ttb.Monto_Linea_TRX   
     , ttb.Monto_Ingresos_TRX
     , ttb.Linea_aplicada    
     , ttb.Impuesto_aplicado 
     , ttb.MONTO_APLICDO     
     , ttb.equivalencia      
     , ttb.nuevo_TC          
  from T_TOTALES_BASE ttb

