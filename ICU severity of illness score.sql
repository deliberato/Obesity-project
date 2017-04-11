-- code for SAPS-II

select final_2.icustay_id, sapsii.sapsii
from public.final_2 -- replace by the table name created by you in the cohort selection
left join sapsii
on final_2.icustay_id = sapsii.icustay_id
order by icustay_id


--code for SOFA

select final_2.icustay_id, sofa.sofa as sofa_score, sofa.respiration, sofa.coagulation, sofa.liver, sofa.cardiovascular, sofa.cns,sofa.renal
from public.final_2 -- replace by the table name created by you in the cohort selection
left join sapsii
left join sofa
on final_2.icustay_id = sofa.icustay_id
order by icustay_id
