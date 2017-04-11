-- code for mechanical ventilation in the first 24h of ICU

select final_2.icustay_id, ventfirstday.mechvent as MV_1stday
from public.final_2 -- replace by the table name created by you in the cohort selection
left join ventfirstday
on final_2.icustay_id = ventfirstday.icustay_id
order by icustay_id


-- code for pressors in the first 24h of ICU

with t2 as
(
with t1 as
(
SELECT 
  distinct vasopressordurations.icustay_id, 
  (vasopressordurations.starttime) as starttime, 
  rank () over (partition by vasopressordurations.icustay_id order by starttime) as pressor_order,
  case 
  when starttime >= icustays.intime - interval '1' day
  and starttime <= icustays.intime + interval '1' day  then 1
  else 0 end as pressor_1stday
  ,
  icustays.intime
  
FROM 
  public.vasopressordurations, 
  mimiciii.icustays
WHERE 
  vasopressordurations.icustay_id = icustays.icustay_id 
  group by vasopressordurations.icustay_id, icustays.intime, starttime
  order by vasopressordurations.icustay_id
)

select icustay_id,pressor_1stday, pressor_order
from t1
where pressor_order =1
)
select public.final_2.icustay_id, t2.pressor_1stday
from public.final_2 -- replace by the table name created by you in the cohort selection
left join t2
on public.final_2.icustay_id=t2.icustay_id
order by icustay_id


-- code for renal replacement therapy in the first 24h of ICU

select final_2.icustay_id, rrtfirstday.rrt as RRT_1stday
from public.final_2 -- replace by the table name created by you in the cohort selection
left join rrtfirstday
on final_2.icustay_id = rrtfirstday.icustay_id
order by icustay_id
