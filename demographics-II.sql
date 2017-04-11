-- Code for Elixhauser index

select final_2.hadm_id, elixhauser_ahrq_score.elixhauser_vanwalraven as elixhauser
from public.final_2 -- replace by the table name created by you in the cohort selection
left join elixhauser_ahrq_score
on final_2.hadm_id = elixhauser_ahrq_score.hadm_id
Order by hadm_id

-- Code for smoking status using Natural language processing searches:

with t1 as
(
WITH terms as (

SELECT subject_id

,CASE 

    --               catches negative terms as 'never smoked', 'non-smoker', 'Pt is not a smoker'

    WHEN ne.text ~* '(never|not|not a|none|non|no|no history of|no h\/o of|denies|denies any|negative)[\s-]?(smoke|smoking|tabacco|tobacco|cigar|cigs)'

    --               catches negative terms as: 'Tobacco: denies.', 'Smoking: no;'

    OR   ne.text ~* '(smoke|smoking|tabacco|tobacco|tabacco abuse|tobacco abuse|cigs|cigarettes):[\s]?(no|never|denies|negative)'

    --               catches negative terms: 'Cigarettes: Smoked no [x]', 'No EtOH, tobacco', 'He does not drink or smoke'

    OR   ne.text ~* 'smoked no \[x\]|no etoh, tobacco|not drink alcohol or smoke|not drink or smoke|absence of current tobacco use|absence of tobacco use'

    then 1

    else 0

end as nonsmoking

,CASE 

    --               catches all terms related to smoking: 'Pt. with long history of smoking', 'Smokes 10 cigs/day', 'nicotine patch'

    WHEN ne.text ~* '(smoke|smoking|tabacco|tobacco|cigar|cigs|marijuana|nicotine)'

    then 1

    else 0

end as smokingterm

FROM  mimiciii.noteevents as ne

),

smoking_merged as (

SELECT subject_id,	 

	 CASE                        --  Define smoking variable:

	 WHEN nonsmoking  = 1 THEN 0 --  0 means patient doesn't smoke -> when there is a negative terms present

         WHEN smokingterm = 1 THEN 1 --  1 means patient smokes        -> when there is a positive term present and no negative term

         ELSE 2 END AS smoking       --  2 means unknown               -> no negatieve or smoking terms mentioned at all

FROM terms

)

-- From multiple notes the query takes the min, so if it's mention the patient is a smoker (1)

-- and that the patient is a non-smoker (0), the function decides that the patient is a non-smoker (0)

-- because the negative terms are more explicit and probably not triggered by accident.

SELECT subject_id,min(smoking) as smoking

from smoking_merged

group by subject_id

order by subject_id
)

 select t1.subject_id, t1.smoking
From public.final_2 ---- replace by the table name created by you in the cohort selection
Left join t1
On final_2.subject_id = t1.subject_id
Order by subject_id
