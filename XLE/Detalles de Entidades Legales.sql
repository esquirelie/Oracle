with T_NOMBRE_ENTIDADES
     AS (
        SELECT HOU.ORGANIZATION_ID                                                                                  ORG_ID                 --> CampoIngreso
             , HOU.BU_NAME                                                                                          UNIDAD_OPERATIVA       --> Unidad Operativa
             , XEP.LEGAL_ENTITY_ID                                                                                  LEGAL_ENTITY_ID        --> ID Entidad Legal
             , XEP.NAME                                                                                             NOMBRE_ENTIDAD_LEGAL   --> Nombre Entidad Legal
             , HZ_LOC.COUNTRY                                                                                       COUNTRY_CODE           --> Codigo de Pais
             , HZ_LOC.POSTAL_CODE                                                                                   CODIGO_POSTAL          --> Codigo Postal
             , XEP.LEGAL_ENTITY_IDENTIFIER                                                                          RFC                    --> RFC
        ,'Calle: '  ||DECODE(HZ_LOC.ADDRESS1         ,'','',NULL,'',HZ_LOC.ADDRESS1         ||', ')        ||
         'Colonia: '||DECODE(HZ_LOC.ADDRESS2         ,'','',NULL,'',HZ_LOC.ADDRESS2         ||', ')
                    ||DECODE(HZ_LOC.ADDRESS3         ,'','',NULL,'',HZ_LOC.ADDRESS3         ||', ')
                    ||DECODE(HZ_LOC.ADDRESS4         ,'','',NULL,'',HZ_LOC.ADDRESS4         ||', ')        ||
             ' CP: '||DECODE(HZ_LOC.POSTAL_CODE      ,'','',NULL,'',HZ_LOC.POSTAL_CODE      ||', ')
                    ||DECODE(HZ_LOC.CITY             ,'','',NULL,'',' Ciudad: '             ||HZ_LOC.CITY  ||', ')
                    ||DECODE(HZ_LOC.STATE            ,'','',NULL,'',' Estado: '             ||HZ_LOC.STATE ||', ')     
                    ||DECODE(FND.TERRITORY_SHORT_NAME,'','',NULL,'',FND.TERRITORY_SHORT_NAME)                       DIRECCION              --> Direccion
            FROM HR_OPERATING_UNITS    HOU    --* unidades operativas
               , XLE_ENTITY_PROFILES   XEP    --* perfiles de entidades 
               , XLE_REGISTRATIONS     REG    --* registros
               , HZ_LOCATIONS          HZ_LOC --* locaciones
               , FND_TERRITORIES_TL    FND    --* territorios/paises
           WHERE 1 = 1
             AND HOU.DEFAULT_LEGAL_CONTEXT_ID =  XEP.LEGAL_ENTITY_ID
             AND XEP.LEGAL_ENTITY_ID          =  REG.SOURCE_ID
             AND REG.LOCATION_ID              =  HZ_LOC.LOCATION_ID
             AND REG.SOURCE_TABLE             =  'XLE_ENTITY_PROFILES'
             AND HZ_LOC.COUNTRY               =  FND.TERRITORY_CODE
             AND FND.LANGUAGE                 =  USERENV('LANG')
        )
------------------------------------------------------------------
SELECT TNE.ORG_ID                 --
     , TNE.UNIDAD_OPERATIVA       --
     , TNE.LEGAL_ENTITY_ID        --
     , TNE.NOMBRE_ENTIDAD_LEGAL   --
     , TNE.COUNTRY_CODE           --
     , TNE.CODIGO_POSTAL          --
     , TNE.RFC                    --
     , TNE.DIRECCION              --
  FROM T_NOMBRE_ENTIDADES TNE        
