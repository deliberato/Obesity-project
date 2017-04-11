-- code for:age,gender, ethinicty, marital status, insurance coverage, LOS hospital, LOS ICU, admission type, ICU type


with t1 as
(
SELECT ie.subject_id, ie.hadm_id, ie.icustay_id

-- patient level factors
, pat.gender

-- hospital level factors
, adm.admittime, adm.dischtime, adm.insurance, adm.religion,adm.marital_status, adm.diagnosis
, ROUND( (CAST(adm.dischtime AS DATE) - CAST(adm.admittime AS DATE)) , 4) AS los_hospital
, ROUND( (CAST(adm.admittime AS DATE) - CAST(pat.dob AS DATE))  / 365.242, 4) AS age
, adm.ethnicity, adm.ADMISSION_TYPE
, adm.hospital_expire_flag
, DENSE_RANK() OVER (PARTITION BY adm.subject_id ORDER BY adm.admittime) AS hospstay_seq
, CASE
    WHEN DENSE_RANK() OVER (PARTITION BY adm.subject_id ORDER BY adm.admittime) = 1 THEN 'Y'
    ELSE 'N' END AS first_hosp_stay

-- icu level factors
, ie.intime, ie.outtime
, ROUND( (CAST(ie.outtime AS DATE) - CAST(ie.intime AS DATE)) , 4) AS los_icu
, DENSE_RANK() OVER (PARTITION BY ie.hadm_id ORDER BY ie.intime) AS icustay_seq

-- first ICU stay *for the current hospitalization*
,ie.first_careunit as ICU_type, CASE
    WHEN DENSE_RANK() OVER (PARTITION BY ie.hadm_id ORDER BY ie.intime) = 1 THEN 'Y'
    ELSE 'N' END AS first_icu_stay

FROM mimiciii.icustays ie
INNER JOIN mimiciii.admissions adm
    ON ie.hadm_id = adm.hadm_id
INNER JOIN mimiciii.patients pat
    ON ie.subject_id = pat.subject_id
ORDER BY ie.subject_id, adm.admittime, ie.intime
) 
select final_2.icustay_id, gender, age, ethnicity,insurance, marital_status, admittime, dischtime, diagnosis, los_hospital, hospital_expire_flag,admission_type,ICU_type, intime, outtime, los_icu
from final_2 -- replace by the name of the table created by you in the cohort selection
Left join t1
On final_2.icustay_id =t1.icustay_id
Order by icustay_id
