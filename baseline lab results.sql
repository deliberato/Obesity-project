-- code for the baseline laboratory result

select 
co.icustay_id
, avg(case when itemid in (51300,51301) then valuenum else null end) as avgwbc_baseline
, avg(case when itemid = 51265 then valuenum else null end ) as avgplatelets_baseline
, avg (case when itemid in (50983,50824) then valuenum else null end) as avgsodium_baseline
, avg (case when itemid in (50971,50822) then valuenum else null end) as avgpotassium_baseline
, avg (case when itemid = 51006 then valuenum else null end) as avgbun_baseline
, avg (case when itemid in (50912,51081) then valuenum else null end) as avgcreatinine_baseline
, avg (case when itemid in (50882,50803) then valuenum else null end) as avgbic_baseline
from final_2 co -- replace by the table name created by you in the cohort selection
inner join admissions adm
on co.hadm_id = adm.hadm_id
left join labevents le
on co.subject_id = le.subject_id
and le.charttime between adm.admittime - interval  '365' day and adm.admittime - interval '3' day
group by co.subject_id, co.hadm_id, co.icustay_id, adm.admittime
order by icustay_id
