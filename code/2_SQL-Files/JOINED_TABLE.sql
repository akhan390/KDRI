/* TABLE WITH ADULT, DECEASED DONOR KIDNEY TRANSPLANTS, EXCLUDING MULTI-ORGAN TRANSPLANTS
   AND PATIENTS WITH PREVIOUS TRANSPLANTS, INCLUDING NON-U.S. CITIZEN RECIPIENTS AND DONORS */

CREATE TABLE kidney_transplants_only AS
    SELECT *
    FROM most_recent_kfd mrkfd JOIN kidpan_data kd on mrkfd."TRR_ID_CODE" = kd."TRR_ID_CODE"
        JOIN deceased_donor_data ddd on kd."DONOR_ID" = ddd."DONOR_ID"
    WHERE kd.TX_PROCEDUR_TY_PA IS NULL
      AND kd.AGE >= 18
      AND kd.WL_ORG = 'KI'
      AND kd.TXHRT IS NULL OR 0
      AND kd.TXINT IS NULL OR 0
      AND kd.TXLIV IS NULL OR 0
      AND kd.TXLNG IS NULL OR 0
      AND kd.TXPAN IS NULL OR 0
      AND kd.TXVCA IS NULL OR 0
      AND kd.WLHL IS NULL OR 0
      AND kd.WLHR IS NULL OR 0
      AND kd.WLIN IS NULL OR 0
      AND kd.WLKP IS NULL OR 0
      AND kd.WLLI IS NULL OR 0
      AND kd.WLLU IS NULL OR 0
      AND kd.WLPA IS NULL OR 0
      AND kd.WLPI IS NULL OR 0
      AND kd.WLVC IS NULL OR 0
      AND kd.PREV_TX = 'N'
      AND kd.PREV_TX_ANY = 'N';

/* Get column names */
PRAGMA table_info(kidney_transplants_only);


/* Percent Nulls Per Column Per Year */
/* TRR_ID_CODE gives you total number of transplant records */

SELECT
       COUNT(TRR_ID_CODE) - COUNT() AS TotalNull,
       100.0 * COUNT() / COUNT(TRR_ID_CODE) AS PercentNotNull,
       strftime('%Y', TX_DATE) AS Transplant_Year

FROM kidney_transplants_only

GROUP BY Transplant_Year;


/* Number of Adult kidney transplants (deceased donors only, no previous transplants) */
SELECT COUNT(DISTINCT TRR_ID_CODE)
FROM kidney_transplants_only;
/* RESULTS: 291,247  */


/* Number of Kidney transplants per year (deceased donors only) */
SELECT COUNT (DISTINCT TRR_ID_CODE),
       strftime('%Y', TX_DATE) AS Transplant_Year
FROM kidney_transplants_only
GROUP BY Transplant_Year;


/* Confirm MULTIORG all nulls -- CONFIRMED */
SELECT COUNT(MULTIORG)
FROM kidney_transplants_only;


/* Determine whether Age contains null values for unknown age */
SELECT AGE
FROM kidney_transplants_only
LIMIT 5000;
/* RESULTS: it does not appear so. */

/* Range of transplant dates */
SELECT MIN(TX_DATE), MAX(TX_DATE)
FROM kidney_transplants_only
/* RESULTS: 10-01-87 to 08/27/2020 */

/* WILL ONLY USE RECORDS 2005 ONWARD */
SELECT COUNT(DISTINCT kto.TRR_ID_CODE), strftime('%Y', kto.TX_DATE) AS Transplant_Year
FROM kidney_transplants_only as kto
WHERE Transplant_Year >= '2005'
/* 166,969*/

/* GET NUMBER OF TRANSPLANTS PER YEAR FOR U.S. CITIZENS W/ U.S. DONORS */
SELECT COUNT(DISTINCT TRR_ID_CODE), CITIZENSHIP, CITIZENSHIP_DON,
       strftime('%Y', TX_DATE) AS Transplant_Year
FROM kidney_transplants_only
WHERE CITIZENSHIP = 1 AND CITIZENSHIP_DON = 1
GROUP BY Transplant_Year;
/* RESULTS: 260,291 */

/*  DECEASED DONOR ADULT KIDNEY TRANSPLANTS, INCLUDING MULTI-ORGAN AND PREV TRANSPLANTS
    FOR U.S CITIZENS WITH U.S. CITIZEN DONORS */
    SELECT COUNT(DISTINCT kd.TRR_ID_CODE)
    FROM most_recent_kfd mrkfd JOIN kidpan_data kd on mrkfd."TRR_ID_CODE" = kd."TRR_ID_CODE"
        JOIN deceased_donor_data ddd on kd."DONOR_ID" = ddd."DONOR_ID"
    WHERE kd.TX_PROCEDUR_TY_PA IS NULL
      AND kd.AGE >= 18
      AND kd.WL_ORG = 'KI'
      AND kd.CITIZENSHIP = 1 AND kd.CITIZENSHIP_DON = 1;
    /* RESULTS: 261, 792 */

/*  DECEASED DONOR ADULT KIDNEY TRANSPLANTS, INCLUDING MULTI-ORGAN AND PREV TRANSPLANTS
    FOR U.S CITIZENS WITH U.S. CITIZEN DONORS BY YEAR */
    SELECT COUNT(DISTINCT kd.TRR_ID_CODE), strftime('%Y', TX_DATE) AS Transplant_Year
    FROM most_recent_kfd mrkfd JOIN kidpan_data kd on mrkfd."TRR_ID_CODE" = kd."TRR_ID_CODE"
        JOIN deceased_donor_data ddd on kd."DONOR_ID" = ddd."DONOR_ID"
    WHERE kd.TX_PROCEDUR_TY_PA IS NULL
      AND kd.AGE >= 18
      AND kd.WL_ORG = 'KI'
      AND kd.CITIZENSHIP = 1 AND kd.CITIZENSHIP_DON = 1
    GROUP BY Transplant_Year;


/*  DECEASED DONOR ADULT KIDNEY TRANSPLANTS, EXCLUDING MULTI-ORGAN,
    BUT INCLUDING PREV TRANSPLANTS ONLY FOR U.S. CITIZENS WITH U.S. CITIZNE DONORS  */
    SELECT COUNT(DISTINCT kd.TRR_ID_CODE)
    FROM most_recent_kfd mrkfd JOIN kidpan_data kd on mrkfd."TRR_ID_CODE" = kd."TRR_ID_CODE"
        JOIN deceased_donor_data ddd on kd."DONOR_ID" = ddd."DONOR_ID"
    WHERE kd.TX_PROCEDUR_TY_PA IS NULL
      AND kd.AGE >= 18
      AND kd.WL_ORG = 'KI'
      AND kd.CITIZENSHIP = 1 AND kd.CITIZENSHIP_DON = 1
      AND kd.TXHRT IS NULL OR 0
      AND kd.TXINT IS NULL OR 0
      AND kd.TXLIV IS NULL OR 0
      AND kd.TXLNG IS NULL OR 0
      AND kd.TXPAN IS NULL OR 0
      AND kd.TXVCA IS NULL OR 0
      AND kd.WLHL IS NULL OR 0
      AND kd.WLHR IS NULL OR 0
      AND kd.WLIN IS NULL OR 0
      AND kd.WLKP IS NULL OR 0
      AND kd.WLLI IS NULL OR 0
      AND kd.WLLU IS NULL OR 0
      AND kd.WLPA IS NULL OR 0
      AND kd.WLPI IS NULL OR 0
      AND kd.WLVC IS NULL OR 0;
    /* RESULTS: 260,291 */


/*  DECEASED DONOR ADULT KIDNEY TRANSPLANTS, EXCLUDING MULTI-ORGAN,
    BUT INCLUDING PREV TRANSPLANTS ONLY FOR U.S. CITIZENS WITH U.S. CITIZEN DONORS, BY TRANSPLANT YEAR  */

    SELECT COUNT(DISTINCT kd.TRR_ID_CODE), strftime('%Y', TX_DATE) AS Transplant_Year
    FROM most_recent_kfd mrkfd JOIN kidpan_data kd on mrkfd."TRR_ID_CODE" = kd."TRR_ID_CODE"
        JOIN deceased_donor_data ddd on kd."DONOR_ID" = ddd."DONOR_ID"
    WHERE kd.TX_PROCEDUR_TY_PA IS NULL
      AND kd.AGE >= 18
      AND kd.WL_ORG = 'KI'
      AND kd.CITIZENSHIP = 1 AND kd.CITIZENSHIP_DON = 1
      AND kd.TXHRT IS NULL OR 0
      AND kd.TXINT IS NULL OR 0
      AND kd.TXLIV IS NULL OR 0
      AND kd.TXLNG IS NULL OR 0
      AND kd.TXPAN IS NULL OR 0
      AND kd.TXVCA IS NULL OR 0
      AND kd.WLHL IS NULL OR 0
      AND kd.WLHR IS NULL OR 0
      AND kd.WLIN IS NULL OR 0
      AND kd.WLKP IS NULL OR 0
      AND kd.WLLI IS NULL OR 0
      AND kd.WLLU IS NULL OR 0
      AND kd.WLPA IS NULL OR 0
      AND kd.WLPI IS NULL OR 0
      AND kd.WLVC IS NULL OR 0
    GROUP BY Transplant_Year;

/* CREATE TABLE FOR ALL TRANSPLANTS 2005 AND ONWARD */

CREATE TABLE transplants_2005_2020 AS
    SELECT *,  strftime('%Y', kd.TX_DATE) AS Transplant_Year
    FROM most_recent_kfd mrkfd JOIN kidpan_data kd on mrkfd."TRR_ID_CODE" = kd."TRR_ID_CODE"
        JOIN deceased_donor_data ddd on kd."DONOR_ID" = ddd."DONOR_ID"
    WHERE kd.TX_PROCEDUR_TY_PA IS NULL
      AND Transplant_Year >= '2005'
      AND kd.AGE >= 18
      AND kd.WL_ORG = 'KI'
      AND kd.TXHRT IS NULL OR 0
      AND kd.TXINT IS NULL OR 0
      AND kd.TXLIV IS NULL OR 0
      AND kd.TXLNG IS NULL OR 0
      AND kd.TXPAN IS NULL OR 0
      AND kd.TXVCA IS NULL OR 0
      AND kd.WLHL IS NULL OR 0
      AND kd.WLHR IS NULL OR 0
      AND kd.WLIN IS NULL OR 0
      AND kd.WLKP IS NULL OR 0
      AND kd.WLLI IS NULL OR 0
      AND kd.WLLU IS NULL OR 0
      AND kd.WLPA IS NULL OR 0
      AND kd.WLPI IS NULL OR 0
      AND kd.WLVC IS NULL OR 0
      AND kd.PREV_TX = 'N'
      AND kd.PREV_TX_ANY = 'N';



