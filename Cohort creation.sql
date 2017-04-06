-- Cohort creation
-- Our cohort: 1st ICU admission of patients >16 years old, with height, weight and laboratory results at least 3 days and at most 1 year befre the hospital admission


 -- create table public.XXXX . as -- use this command to crete a public table

with t1 as
(
select adm.subject_id, adm.hadm_id, adm.admittime
  , rank() over (partition by adm.subject_id order by adm.admittime) as hadm_id_order
  , Extract('epoch'from adm.admittime - pat.dob) / 60.0 / 60.0 / 24.0 / 365.242 as age
from mimiciii.admissions adm, mimiciii.patients pat
where adm.subject_id = pat.subject_id
order by subject_id
)
, t2 as -- first hospital admission
(
select subject_id, hadm_id, extract (epoch from admittime) as admittime, age
from t1
where hadm_id_order = 1
)
, t3_lab as -- all lab values (hemoglobin, white blood cells, platelets, sodium, potasium, creatinine, BUN, bicarbonate, glucose and bilirubin)
(
select distinct subject_id, hadm_id , extract(epoch from charttime) as charttime -- , valuenum
from mimiciii.labevents
where itemid in (50912, 50811, 51222, 51300 ,51301, 51265, 50983, 50824, 50971, 50822, 51006, 51081, 50882, 50803, 50902, 50806, 50809, 50931, 50960, 50808)
and hadm_id is null
order by subject_id, charttime
)
, adultswithlabs as
(
-- combining inclusion criteria
select distinct t2.subject_id, t2.hadm_id
from t2, t3_lab as t3
where t2.age >= 16
and t3.charttime between t2.admittime-365.25*24*3600 and t2.admittime-3*24*3600
and t3.subject_id=t2.subject_id
order by t2.hadm_id
)
, t3_wt as -- weight
(
select distinct subject_id, icustay_id, extract(epoch from charttime) as charttime, valuenum as weight
from mimiciii.chartevents
where valuenum is not null and itemid in  (581,580,224639,226512)
order by icustay_id, charttime
)
, t1_icu as
(
  select icu.*, rank() over (partition by icu.subject_id order by icu.intime) as icustay_id_order
  from mimiciii.icustays icu
  order by subject_id
)
, t2_icu as -- 1st icu stay
(
  select subject_id, hadm_id, icustay_id, extract ( epoch from intime) as intime
  from t1_icu
  where icustay_id_order = 1
)
, mean_weight as -- mean weight between 24h before and 24 after the ICu admission
(
select distinct t3.subject_id, avg(t3.weight) as mean_weight
from t2_icu as t2,t3_wt as t3
where t3.charttime between t2.intime-01*24*3600 and t2.intime+1*24*3600 and t3.subject_id=t2.subject_id  -- select weight within -1d / +1d from ICU admission
group by t3.subject_id
order by t3.subject_id
)
,t0 as -- height
(
select distinct subject_id, extract(epoch from charttime) as charttime, itemid,
case when itemid in (920,1394,4187,3486,226707) then valuenum *2.54 else valuenum end as height  -- with conversion inches/cm
from mimiciii.chartevents
where valuenum is not null and itemid in  ( 920,1394,4187,3486,3485,4188, 226707, 226730)
and valuenum != 0
)
-- select max available height per subject_id
, max_height as
(
  select distinct subject_id, max(height) as height
  from t0
  group by subject_id
)
, tempo as -- transforming inches in cm
(
    select ad.subject_id, ad.hadm_id, icu.icustay_id, mw.mean_weight,
  case when mh.height < 100 then mh.height *2.54
  when mh.height>300 then mh.height/2.54
  else mh.height end as height
  from adultswithlabs ad
  left join mean_weight mw
  on ad.subject_id=mw.subject_id
  left join max_height mh
  on ad.subject_id=mh.subject_id
  left join t2_icu icu
  on ad.hadm_id = icu.hadm_id
  order by ad.subject_id
)
, tempo2 as -- calculating BMI
(
  select tempo.*, mean_weight/(height*height/10000) as bmi
  from tempo
  where mean_weight is not null and height is not null
)
, tempo3 as -- defining BMI groups
(
  select tempo2.*,
  case
  when bmi < 18.5 then 1
  when bmi >= 18.5 and bmi < 24.999999999 then 2
  when bmi >= 25 and bmi < 30 then 3
  when bmi >= 30 then 4
  else 0 end as bmi_group
  from tempo2
)

select * -- selecting final cohort
from tempo3
where  icustay_id is not null
and bmi_group =2 -- (normal weight cohort) or bmi_group=4 (obese cohort)

