# Removing Race from the Kidney Donor Risk Index

 ## Contents:

- [Problem Statement](#Problem-Statement)  
- [Background](#Background)
    - [Limitations of the Original Model](#Limitations-of-the-Original-Model)
- [Data](#Data)
- [Executive Summary](#Executive-Summary)
- [Conclusions and Recommendations](#Conclusions-and-Recommendations)



## Problem Statement

The aim of this project is to create a new and improved Kidney Donor Risk Index by:
 - Eliminating the race-adjustment for Black kidney donors
 - Redefining graft failure using death censorship
 - Utilizing a combination of novel machine learning techniques to isolate important predictive variables and improve predictive accuracy



## Background
The Kidney Donor Risk Index is a prognostic algorithm developed by Rao et al. (2009) and used by physicians to aid in making decisions regarding kidney allocation for transplants.<sup>[1](https://journals.lww.com/transplantjournal/Fulltext/2009/07270/A_Comprehensive_Risk_Quantification_Score_for.13.aspx)</sup> The original paper utilized Cox Regression to model the risk of graft failure or death using 69,440 transplant records from first-time, kidney-only, deceased donor adult transplants occurring between 1995-2005.<sup>[1](https://journals.lww.com/transplantjournal/Fulltext/2009/07270/A_Comprehensive_Risk_Quantification_Score_for.13.aspx)</sup> The KDRI<sub>full</sub> includes 13 donor, recipient, and transplant factors found to predict the risk of graft failure or death based on this model. The KDRI<sub>donor-only</sub> was adapted from the KDRI<sub>full</sub>, and includes the 10 following donor-only characteristics known prior to transplant:
- Age
- Weight
- Height
- Ethnicity/Race
- History of Hypertension
- History of Diabetes
- Cause of Death
- Serum Creatinine
- Hepatitis C Virus
- Donation after Circulatory Death (DCD) criteria<sup>[2](https://journals.lww.com/transplantjournal/Fulltext/2018/01000/Validation_of_the_Prognostic_Kidney_Donor_Risk.29.aspx)</sup>

### Limitations of the Original Model
Though the KDRI has been praised for its granularity compared to the previous Extended Criteria Donor versus Standard Criteria Donor dichotomy, the model and methodology of the original study have substantial limitations.


##### 1. Use of Race/Ethnicity
The use of race and ethnicity in clinical decision-making algorithms has recently come under scrutiny within the medical community.<sup>[3](https://www.nejm.org/doi/full/10.1056/NEJMms2004740)</sup> Use of race ignores historical racial inequity in access to and quality of healthcare which likely contributes to the underlying disparities in graft survival outcomes.
Worse still, use of race in the KDRI may exacerbate existing inequity by shrinking the kidney donor pool for black patients, who already experience longer wait times for kidney transplants than non-black patients.<sup>[3](https://www.nejm.org/doi/full/10.1056/NEJMms2004740)</sup>


##### 2. Predictive Outcome
Though the KDRI is widely understood to predict the risk of graft failure for a particular donor kidney, the original study defined graft failure as return to dialysis, retransplant, or death, without regard to cause of death.<sup>[1](https://journals.lww.com/transplantjournal/Fulltext/2009/07270/A_Comprehensive_Risk_Quantification_Score_for.13.aspx)</sup> This approach reduces the baseline predictive value of the KDRI, and calls the association between the identified transplant characteristics and graft failure into question.

##### 3. Advancements in Transplant Medicine
The original study included transplant data from 1995-2005, but advancements in transplant medicine in the past fifteen years have substantially improved graft survival.<sup>[4](https://journals.lww.com/transplantjournal/fulltext/2010/12270/Induction_Immunosuppression_Improves_Long_Term.43.aspx)</sup> <sup>[5](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5464785/)</sup> In light of these advancements, the KDRI should be reformulated using more recent patient data.


## Data
##### Standard Transplant Analysis and Research Files (STAR)
As per the Organ Transplantation and Procurement Network (OPTN), "STAR files are limited datasets that contain patient-level information about transplant recipients, deceased and living donors, and waiting list candidates back to 10/1/1987."

In accordance with the OPTN Data Use Agreement, the de-identified patient-level data contained in the STAR database and used in the subsequent analysis and modeling are not available in this repository. You may request the data [here](https://optn.transplant.hrsa.gov/data/request-data/data-request-instructions/).






## Executive Summary

### Packages & Documentation

### Modeling


### Custom Model Training with Google AI Platform


### Feature Importances






## Conclusions and Recommendations
