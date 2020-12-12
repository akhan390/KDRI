/* Exclusion Criteria */

/* Original number of unique transplant records in combined table */
SELECT COUNT(DISTINCT kd.TRR_ID_CODE)
FROM most_recent_kfd mrkfd JOIN kidpan_data kd on mrkfd."TRR_ID_CODE" = kd."TRR_ID_CODE"
        JOIN deceased_donor_data ddd on kd."DONOR_ID" = ddd."DONOR_ID"
/* RESULTS: 316,733  */

/*Excluded transplants where recipients was < 18 yrs old */
SELECT COUNT(DISTINCT kd.TRR_ID_CODE)
FROM most_recent_kfd mrkfd JOIN kidpan_data kd on mrkfd."TRR_ID_CODE" = kd."TRR_ID_CODE"
        JOIN deceased_donor_data ddd on kd."DONOR_ID" = ddd."DONOR_ID"
WHERE AGE < 18;
/* Removed 12,704 records */

/* Excluded multi-organ transplants (actual or waitlist) and non-kidney (pancreatic) transplants */
SELECT COUNT(DISTINCT kd.TRR_ID_CODE)
FROM most_recent_kfd mrkfd JOIN kidpan_data kd on mrkfd."TRR_ID_CODE" = kd."TRR_ID_CODE"
        JOIN deceased_donor_data ddd on kd."DONOR_ID" = ddd."DONOR_ID"
 WHERE kd.TX_PROCEDUR_TY_PA IS NULL
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
      AND kd.WLVC IS NULL OR 0;
/* RESULT: 303, 796
   316,733(original) - 303,796 = Removed 12,937 */

/* Excluded patients with any previous transplant */
SELECT COUNT(DISTINCT kd.TRR_ID_CODE)
FROM most_recent_kfd mrkfd JOIN kidpan_data kd on mrkfd."TRR_ID_CODE" = kd."TRR_ID_CODE"
        JOIN deceased_donor_data ddd on kd."DONOR_ID" = ddd."DONOR_ID"
WHERE kd.PREV_TX = 'N'
  AND kd.PREV_TX_ANY = 'N';
/* RESULT: 270,866
316,733 (original) - 270, 866 = Removed 45,867 */


/* Number of Adult kidney transplants
   (deceased donors only, no previous transplants or multi-organ transplants) from 1987 - 2020 */
SELECT COUNT(DISTINCT TRR_ID_CODE)
FROM kidney_transplants_only;
/* RESULTS: 291,247 *Note that you included foreign recipients and donors with tx in the US, unlike OPTN */


/*  Number of Adult kidney transplants
(deceased donors only, no previous transplants or multi-organ transplants) from 2005 - 2020 */
SELECT COUNT(DISTINCT TRR_ID_CODE)
FROM transplants_2005_2020;
/* RESULTS: 166, 969 (give rationale for using this time period : advancements in anti-rejection medications,
   time period of previous study, etc) */


/* Number of transplants excluding ABO incompatible transplants */
SELECT COUNT(DISTINCT TRR_ID_CODE), ABO_MAT
FROM transplants_2005_2020
WHERE ABO_MAT <> 3;
/* 165,603

/* FINAL TABLE */
CREATE TABLE final_table AS
SELECT *
    FROM transplants_2005_2020
WHERE ABO_MAT <> 3;

/* Look at transplants where GSTATUS_KI == 1 (GRAFT FAILED) [ 'GRF_STAT' == Y (FUNCTIONING)  */
/* gstatus_ki is calculated */
SELECT TRR_ID_CODE, PX_STAT, COD, COD_OSTXT, GSTATUS_KI, GTIME_KI, FAILDATE_KI, GRF_STAT, GRF_FAIL_DATE, GRF_FAIL_CAUSE_OSTXT, GRF_FAIL_CAUSE_TY,
       ACUTE_REJ_EPI
FROM final_table
WHERE GSTATUS_KI = 1 AND GRF_STAT = 'Y';

SELECT GRF_STAT
FROM kidney_followup_data
WHERE TRR_ID_CODE = 'A426082'

SELECT *
FROM final_table
WHERE TRR_ID_CODE = 'A426082'