-- Code for the primary ICD-9 diagnosis

select final_2.hadm_id, primary_dx.icd9_code, primary_dx.short_title, primary_dx.long_title
from public.final_2 -- replace by the table name created by you in the cohort selection
left join public.primary_dx
on public.final_2.hadm_id = public.primary_dx.hadm_id
order by hadm_id
