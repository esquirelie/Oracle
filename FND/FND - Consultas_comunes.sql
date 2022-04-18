WITH T_CONSULTA_LOOKUP
     AS (
         SELECT UNIQUE
                FLV.LOOKUP_TYPE
              , FLV.LOOKUP_CODE 
              , FLV.MEANING
              , FLV.DESCRIPTION
              , FLV.TAG
              , FLV.ATTRIBUTE_CATEGORY
              , FLV.ATTRIBUTE1
              , FLV.ATTRIBUTE2
              , FLV.ATTRIBUTE3
              , FLV.ATTRIBUTE4
              , FLV.ATTRIBUTE5
              , FLV.ATTRIBUTE6
              , FLV.ATTRIBUTE7
              , FLV.ATTRIBUTE8
              , FLV.ATTRIBUTE9
              , FLV.ATTRIBUTE10
              , FLV.ATTRIBUTE11
              , FLV.ATTRIBUTE12
              , FLV.ATTRIBUTE13
              , FLV.ATTRIBUTE14
              , FLV.ATTRIBUTE15
           FROM FND_LOOKUP_VALUES FLV
          WHERE 1 = 1
            AND FLV.ENABLED_FLAG  = 'Y'
            AND FLV.LANGUAGE      = USERENV('LANG')
         )
---------------------------------------------------
select *
  from T_CONSULTA_LOOKUP
 where 1 = 1