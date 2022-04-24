select ACRA.receipt_number  NUMERO_RECIBO,      --01
       HOR.NAME                          ,                   --02
       ACRA.STATUS,                             --03
       APSA.CASH_RECEIPT_ID                     --04
from ar_cash_receipts_all         ACRA, -- Tabla de todos los recibos/cobros/pagos
     AR_PAYMENT_SCHEDULES_ALL     APSA, -- Tabla de todos los saldos del modulo AR
     HR_OPERATING_UNITS           HOR   -- Tabla de las unidades Operativas del sistema
WHERE 1 = 1    -- verdadero
    and ACRA.cash_receipt_id = APSA.cash_receipt_id
    AND HOR.ORGANIZATION_ID  = ACRA.ORG_ID
    and ACRA.STATUS          = 'UNID'