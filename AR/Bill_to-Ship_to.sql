-- Bill-To site number:

SELECT hcsu.location                 -- Site number shown in AR transaction page
  FROM hz_cust_accounts        hca
     , hz_cust_acct_sites_all  hcsa
     , hz_cust_site_uses_all   hcsu
 WHERE hca.cust_account_id    = hcsa.cust_account_id
   AND hcsa.cust_acct_site_id = hcsu.cust_acct_site_id
   AND HCSU.SITE_USE_CODE     = 'BILL_TO';

--- Ship-To site number:

SELECT hps.party_site_number         -- Ship-To Site number shown in AR transaction page
  FROM hz_cust_accounts        hca
     , hz_cust_acct_sites_all  hcsa
     , hz_cust_site_uses_all   hcsu
     , hz_party_sites          hps
 WHERE hca.cust_account_id    = hcsa.cust_account_id
   AND hcsa.cust_acct_site_id = hcsu.cust_acct_site_id
   AND hcsa.party_site_id     = hps.party_site_id
   AND HCSU.SITE_USE_CODE     = 'SHIP_TO';