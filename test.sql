-- Hospital/ICU Information
-- ICU Diagnosis - DONE on hadm_id_
select final_2.hadm_id, primary_dx.icd9_code, primary_dx.short_title, primary_dx.long_title
from public.final_2
left join public.primary_dx
on public.final_2.hadm_id = public.primary_dx.hadm_id
order by hadm_id


-- MV at ICU admission (first 24h) - DONE on icustay_id
select final_2.icustay_id, ventfirstday.mechvent as MV_1stday
from public.final_2
left join ventfirstday
on final_2.icustay_id = ventfirstday.icustay_id
order by icustay_id

-- Dialysis at ICU admission (first 24h) - DONE on icustay_id
select final_2.icustay_id, rrtfirstday.rrt as RRT_1stday
from public.final_2
left join rrtfirstday
on final_2.icustay_id = rrtfirstday.icustay_id
order by icustay_id
