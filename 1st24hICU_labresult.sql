-- code for the most abnormal lab result in the first 24h of the ICU admission

select final_2.icustay_id, labsfirstday.wbc_max as wbc_icu, labsfirstday.platelet_min as platelet_icu, labsfirstday.sodium_min as Na_icu, labsfirstday.potassium_max as k_icu, labsfirstday.bun_max as BUN_icu, labsfirstday.creatinine_max as Cr_icu, labsfirstday.bicarbonate_min as BIC_icu
from public.final_2 -- replace by the table name created by you in the cohort selection
left join labsfirstday
on final_2.icustay_id = labsfirstday.icustay_id
order by icustay_id
