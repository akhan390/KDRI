# Removing Race from the Kidney Donor Risk Index

 ## Contents:

- [Problem Statement](#Problem-Statement)  
- [Background](#Background)
    - [Limitations of the Original Model](#Limitations-of-the-Original-Model)
- [Data](#Data)
- [Executive Summary](#Executive-Summary)
    - [Methods](#Methods)
    - [Models](#Model)
      - [Random Survival Forests](#Random-Survival_Forests)
      - [DeepSurv](#DeepSurv)
    - [Model Training](#Model-Training)
    - [Feature Importance](#Feature-Importance)
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


#### Methods
Using SQLite, most recent transplant follow-up records were isolated from the Kidney Follow-Up data table for each transplant record ID. The Kidney/Pancreas data table was filtered sequentially using the same exclusion criteria used in the original model.<sup>[1](https://journals.lww.com/transplantjournal/Fulltext/2009/07270/A_Comprehensive_Risk_Quantification_Score_for.13.aspx)</sup> Kidney/Pancreas, Deceased Donor, and Kidney Follow-Up data tables were then left-joined on Transplant ID from the Kidney/Pancreas data table, and the joined table was filtered for transplant dates occurring in or after 2005. Duplicate transplant records were removed using Python after exporting the data table as a csv.

Data cleaning and initial feature selection was performed in python using `pandas`, `scikit-learn`, `numpy`, and `imblearn`. Manual removal of features pertaining to pancreatic transplants, those unavailable prior to transplant, those pertaining to or utilizing race/ethnicity (eg; GFR), and those leaking graft survival information was performed. The dataframe was then filtered for features containing ≤ 10% null values. The final dataframe contained 102,480 transplant records.

Numeric and categorical features were separated into distinct dataframes for initial feature selection. `RandomUnderSampler` was used to balance the graft failure and survival classes in order to perform ANOVA and chi-square tests on numeric and categorical features, respectively. The top 30 of 38 numeric and top 70 of 1677 features using `SelectKBest` were utilized for model tuning and further feature selection using a Random Survival Forests model.<sup>[6]((https://www.semanticscholar.org/paper/Random-survival-forests-Ishwaran-Kogalur/9ee2d6a8de063e2621eebc620b9d9d3d8a380374)</sup>


#### Models

##### Random Survival Forests
Random Survival Forests was chosen over the original Cox regression model for the ability to avoid the proportional hazards constraint while maintaining interpretability.<sup>[7](https://humboldt-wi.github.io/blog/research/information_systems_1920/group2_survivalanalysis/#rsf)</sup> The model computes a random forest using the log-rank test as the splitting criterion. The cumulative hazard of the leaf nodes in each tree are calculated and averaged in the following ensemble.<sup>[7](https://humboldt-wi.github.io/blog/research/information_systems_1920/group2_survivalanalysis/#rsf)</sup> The `scikit-survival` package  created by Sebastian Pölsterl was used for Random Survival Forest modeling and model evaluation.<sup>[8](https://scikit-survival.readthedocs.io/en/latest/)</sup>  

##### DeepSurv

DeepSurv is a Cox Proportional Hazards deep neural network.<sup>[9](https://bmcmedresmethodol.biomedcentral.com/articles/10.1186/s12874-018-0482-1)</sup> It works by estimating each individual’s effect on their hazard rates with respect to parametrized weights of the network<sup>[7](https://humboldt-wi.github.io/blog/research/information_systems_1920/group2_survivalanalysis/#rsf)</sup>. After determination of Random Survival Forests feature weights, features with non-zero weights were eliminated and the 33 remaining features were used in a DeepSurv model to attempt to improve predictive accuracy. The `CoxPH` method from the `Pycox` package created by Haavard Kvamme was utilized for DeepSurv modeling and evaluation.<sup>[10](https://github.com/havakv/pycox#references)</sup>


#### Model Training
Random Survival Forests training and hyperparameter tuning was performed on Google AI Platform using the set of 100 features selected by initial statistical analysis.


#### Feature Importance
Feature importance was obtained using the `eli5` `PermutationImportance` method, as outlined in the `scikit-survival` Random Survival Forests documentation.<sup>[11](https://scikit-survival.readthedocs.io/en/latest/user_guide/random-survival-forest.html)</sup>


## Conclusions and Recommendations
