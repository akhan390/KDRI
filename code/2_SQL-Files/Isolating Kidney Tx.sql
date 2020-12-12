/* Total number of kidney (non kidney-pancreas) rows in dataset - Number of non-nulls in pancreas transplant type column */
/* Gives number of nulls for pancreas transplant type (meaning no pancreatic transplant occurred) */
SELECT COUNT(*) - COUNT(TX_PROCEDUR_TY_PA)
FROM kidpan_data ;

/* Look at waitlist organ variables */
SELECT WL_ORG
FROM kidpan_data
LIMIT 100;

/* Waitlisted for multi-organ transplants */
SELECT COUNT(WLHL) AS HEART_LUNG_WL, COUNT(WLHR) AS HEART_WL, COUNT(WLIN) AS INTESTINE_WL, COUNT(WLKP) AS KIDNEY_PANCREAS_WL,
       COUNT(WLLI) AS LIVER_WL, COUNT(WLLU) AS LUNG_WL, COUNT(WLPA) AS PANCREAS_WL, COUNT(WLPI) AS PANCREATIC_ISLET_WL, COUNT(WLVC) AS VCA_WL
FROM kidpan_data;

/* Simultaneous multi-organ transplants */
SELECT COUNT(TXHRT) AS SIM_HEART,  COUNT(TXINT) AS SIM_INTESTINE, COUNT(TXLIV) AS SIM_LIVER,
       COUNT(TXLNG) AS SIM_LUNG,  COUNT(TXPAN) AS SIM_PANCREAS, COUNT(TXVCA) AS SIM_VCA
FROM kidpan_data

/* Size of each table (NOT DISTINCT) */
SELECT COUNT(TRR_ID_CODE)
FROM kidpan_data
/* 521,064 */

/* LIKELY MULTIPLE FOLLOW-UP RECORDS PER PATIENT */
SELECT COUNT(TRR_ID_CODE)
FROM kidney_followup_data
/* 3,813,134 */

SELECT COUNT(DISTINCT DONOR_ID)
FROM deceased_donor_data
/* 233,354 */

/* Recipient status date at time of follow-up */
SELECT MAX(PX_STAT_DATE), TRR_ID_CODE
FROM kidney_followup_data as kfd
GROUP BY TRR_ID_CODE
LIMIT 10;


/*There are many followup dates per transplant id code.*/
SELECT TRR_ID_CODE, COUNT(DISTINCT PX_STAT_DATE)
FROM kidney_followup_data AS kfd
GROUP BY TRR_ID_CODE;

/* ISOLATE LATEST FOLLOWUP DATE PER TRANSPLANT ID CODE.*/
CREATE TABLE most_recent_kfd AS
SELECT kfd1.*
FROM kidney_followup_data AS kfd1
INNER JOIN
    (SELECT TRR_ID_CODE, MAX(PX_STAT_DATE) AS latest_encounter
        FROM kidney_followup_data
        GROUP BY TRR_ID_CODE) AS grouped
ON kfd1.TRR_ID_CODE = grouped.TRR_ID_CODE
AND kfd1.PX_STAT_DATE = grouped.latest_encounter


SELECT COUNT(DISTINCT TRR_ID_CODE)
FROM most_recent_kfd
/* RESULTS: 474,451 */

/* Check to make sure there is only 1 followup record per TRR_ID */
SELECT TRR_ID_CODE, COUNT(DISTINCT PX_STAT_DATE)
FROM most_recent_kfd
GROUP BY TRR_ID_CODE;

/* Need to exclude patients with any previous transplant history */
SELECT PREV_TX, PREV_TX_ANY
FROM kidpan_data
LIMIT 1000

SELECT ABO
FROM kidpan_data
LIMIT 1000