 ---
title: "R codes Obesity Project"
created by Rodrigo Deliberato
output: html_document
---

## Loading dataset

loading the 02 different final_2 (= normal weght) and final_4(= obese)

```{r} 
 final_4 <- read.csv("~/Desktop/final_4/final_4.csv")
  View(final_4)
 
 final_2 <- read.csv("~/Desktop/final_2/final_2.csv")
   View(final_2)

```

# DATA TRANSFORMATION

## changing NA to 0 in the pressor_1stday column in the final dataset using the code below:

dataset$column[is.na(dataset$column)]<-0
```{r}
final_4$pressor_1stday[is.na(final_4$pressor_1stday)]<-0

final_2$pressor_1stday[is.na(final_2$pressor_1stday)]<-0
```

# Correcting age

MIMIC has changed teh age of very old patients to 300.0011 to protect them. Here we are change it for 91.4 years
```{r}
final_2$age[final_2$age ==300.0011] <- 91.4

final_4$age[final_4$age ==300.0011] <- 91.4
```

# adjusting height and BMI

I looked back the database searching for the correct height based by the hadm_id. I looked the echodata (available on MIMIC database). After correcting the height I excluded 1 patient because of his new BMI and 1 patient because I couldn't find his/her correct height.This is the explanation why obese patients have 1258 individual

#Adjusting some variables like Sodium

You may find one or two sodium measures like 12.6 which clear means a typo and the actually value is 126

If the value is too akward like potassium of 126, we deleted the measure.


# Data exploration

- data distribution in the variables (look the example below)
```{r}
hist(final_2$age)
hist(final_4$age)

```

#Statistical analysis according to the varible distribution (Table 1)

```{r}
 wilcox.test(final_2$age,final_4.16022017$age,correct = FALSE)
 wilcox.test(final_2$elixhauser,final_4.16022017$elixhauser,correct = FALSE)
 wilcox.test(final_2$bmi,final_4.16022017$bmi,correct = FALSE)
 wilcox.test(final_2$sapsii,final_4.16022017$sapsii,correct = FALSE)
 t.test(final_2$sofa,final_4$sofa, paired = FALSE)

```

#Statistical analysis proportion comparisons (table 1)

  1. gender
```{r}
 x<-matrix(c(338,517,431,741), nrow = 2)
 view(x)
 chisq.test(x)

```
 2. ethnicity
```{r}
 w<-matrix (c(583,53,17,25,91,935,95,38,0,190), ncol = 2)
 View(w)
 chisq.test(w)
```
3. Marital Status
```{r}
a<-matrix (c(415,227,111,16,738,352,151,17), ncol = 2)
 View(a)
 chisq.test(a)

```
4. Insurance
```{r}
b<-matrix (c(497,248,24,709,521,28),ncol = 2)
chisq.test(b)
```
5. smoking
```{r}
y<-matrix (c (259,377,379,649,131,232), nrow = 2)
chisq.test(y)
```
6. Admission type
```{r}
q<- matrix(c(433,15,321,491,15,752),ncol = 2)
chiqs.test(q)
```
7. Source of Admission
```{r}
r<- matrix (c(54,310,367,35,3,71,319,822,45,1), ncol = 2)
chiqs.test(r)
```
8. ICU type
```{r}
s<- matrix(c(73,300,286,110,87,726,272,173), ncol=2)
chiqs.test(s)
```
9. Primary diagnosis
```{r}
e<- matrix(c(110,357,49,47,20,186,188,528,50,88,26,378), ncol = 2)
chisq.test(e)
```
10. Mechanical ventilation first 24h
```{r}
m<-matrix(c(453,316,937,321), ncol= 2)
chisq.test(m)
```
11. Vasopressors in the first 24h
```{r}
v<-matrix(c(346,423,731,527), ncol=2)
chisq.test(v)
```
13. renal replacement Therapy in the first 24h
```{r}
r<-matrix(c(32,737,35,1221), ncol =2)
chisq.test(r)
```

## QQ plots (to assess normality) for baseline labs on both obese and normal weight

```{r}
 with(final_4 , qqnorm((avgwbc_baseline)))
 with(final_2 , qqnorm((avgwbc_baseline)))
 
 with(final_4. , qqnorm((avgsodium_baseline)))
 with(final_2 , qqnorm((avgsodium_baseline)))
 
 with(final_4 , qqnorm((avgpotassium_baseline)))
 with(final_2 , qqnorm((avgpotassium_baseline)))
 
 with(final_4 , qqnorm((avgbun_baseline)))
 with(final_2 , qqnorm((avgbun_baseline)))
 
 with(final_4 , qqnorm((avgbic_baseline)))
 with(final_2 , qqnorm((avgbic_baseline)))
 
 with(final_4 , qqnorm(avgcreatinine_baseline)))
 with(final_2 , qqnorm(avgcreatinine_baseline)))
 
 with(final_4 , qqnorm((avgplatelets_baseline)))
 with(final_2 , qqnorm((avgplatelets_baseline)))
```

## QQ Plots for the diference (ICU-baseline)for obese and normal weight


```{r}
with(final_4 , qqnorm((avgwbc_baseline - wbc_icu)))
with(final_2, qqnorm((avgwbc_baseline - wbc_icu)))

with(final_4, qqnorm((avgsodium_baseline - na_icu)))
with(final_2 , qqnorm((avgsodium_baseline - na_icu)))

with(final_4 , qqnorm((avgpotassium_baseline - k_icu)))
with(final_2 , qqnorm((avgpotassium_baseline - k_icu)))

with(final_4, qqnorm((avgbun_baseline - bun_icu)))
with(final_2, qqnorm((avgbun_baseline - bun_icu)))

with(final_4 , qqnorm((avgbic_baseline - bic_icu)))
with(final_2 , qqnorm((avgbic_baseline - bic_icu)))

with(final_4 , qqnorm(avgcreatinine_baseline -cr_icu)))
with(final_2, qqnorm(avgcreatinine_baseline - cr_icu)))

with(final_4 , qqnorm((avgplatelets_baseline - platelet_icu)))
with(final_2 , qqnorm((avgplatelets_baseline - platelet_icu)))
```



# Baseline comparison (lab results between normal weight and obese patients)


```{r}
wilcox.test(final_2$avgwbc_baseline, final_4$avgwbc_baseline, correct = TRUE)

wilcox.test(final_2$avgsodium_baseline, final_4$avgsodium_baseline, correct = TRUE)

wilcox.test(final_2$avgpotassium_baseline, final_4$avgpotassium_baseline, correct = TRUE)

wilcox.test(final_2$avgbun_baseline, final_4$avgbun_baseline, correct = TRUE)

wilcox.test(final_2$avgbic_baseline, final_4$avgbic_baseline, correct = TRUE)

wilcox.test(final_2$avgcreatinine_baseline, final_4$avgcreatinine_baseline, correct = TRUE)

wilcox.test(final_2$avgplatelets_baseline, final_4$avgplatelets_baseline, correct = TRUE)


```
## Creating the laboratory deviation column (ICU - baseline)

```{r}
final_2 ["deviation_wbc"]<-NA
final_2 ["deviation_platelets"]<-NA
final_2 ["deviation_na"]<-NA
final_2 ["deviation_k"]<-NA
final_2 ["deviation_cr"]<-NA
final_2 ["deviation_bun"]<-NA
final_2 ["deviation_bic"]<-NA

final_4 ["deviation_wbc"]<-NA
final_4 ["deviation_platelets"]<-NA
final_4 ["deviation_na"]<-NA
final_4 ["deviation_k"]<-NA
final_4 ["deviation_cr"]<-NA
final_4 ["deviation_bun"]<-NA
final_4 ["deviation_bic"]<-NA

final_2$deviation_wbc<-final_2$wbc_icu - final_2$avgwbc_baseline
final_2$deviation_platelets	<-final_2$platelet_icu - final_2$avgplatelets_baseline
final_2$deviation_na	<-final_2$na_icu - final_2$avgsodium_baseline
final_2$deviation_k	<-final_2$k_icu - final_2$avgpotassium_baseline
final_2$deviation_cr	<-final_2$cr_icu - final_2$avgcreatinine_baseline
final_2$deviation_bun	<-final_2$bun_icu - final_2$avgbun_baseline
final_2$deviation_bic	<-final_2$bic_icu - final_2$avgbic_baseline

final_4$deviation_wbc<-final_4$wbc_icu - final_4$avgwbc_baseline
final_4$deviation_platelets	<-final_4$platelet_icu - final_4$avgplatelets_baseline
final_4$deviation_na	<-final_4$na_icu - final_4$avgsodium_baseline
final_4$deviation_k	<-final_4$k_icu - final_4$avgpotassium_baseline
final_4$deviation_cr	<-final_4$cr_icu - final_4$avgcreatinine_baseline
final_4$deviation_bun	<-final_4$bun_icu - final_4$avgbun_baseline
final_4$deviation_bic	<-final_4$bic_icu - final_4$avgbic_baseline


```
## Unadjusted Statistical anlysis of the deviation

```{r}
 t.test(final_2$deviation_wbc, final_4$deviation_wbc, paired = F)
 
 t.test(final_2$deviation_platelets, final_4$deviation_platelets, paired = F)
 
 t.test(final_2$deviation_na, final_4$deviation_na, paired = F)
  
 t.test(final_2$deviation_k, final_4$deviation_k, paired = F)
       
 t.test(final_2$deviation_bic, final_4$deviation_bic, paired = F)

## Creating log_bun , log_creatinine , deviation and t test .
```{r}
final_4$log_bun_baseline<- log10(final_4$avgbun_baseline)
final_4$log_bun_icu<- log10(final_4$bun_icu)
final_4$deviation_log_bun<- final_4$log_bun_icu - final_4$log_bun_baseline
mean (final_4$deviation_log_bun, na.rm = TRUE)
sd(final_4$deviation_log_bun, na.rm = TRUE)
with(final_4 , qqnorm(log10(avgbun_baseline)))
with(final_4. , qqnorm(log10(avgbun_baseline) -log10(bun_icu)))

 
final_2$log_bun_baseline<- log10(final_2$avgbun_baseline)
final_2$log_bun_icu<- log10(final_2$bun_icu)
final_2$deviation_log_bun<-final_2$log_bun_icu - final_2$log_bun_baseline
mean (final_2$deviation_log_bun, na.rm = TRUE)
sd(final_2$deviation_log_bun, na.rm = TRUE)
with(final_2 , qqnorm(log10(avgbun_baseline)))
with(final_2 , qqnorm(log10(avgbun_baseline) -log10(bun_icu)))


t.test(final_4$deviation_log_bun,final_2$deviation_log_bun, paired= FALSE)

final_4$log_creatinine_baseline<- log10(final_4$avgcreatinine_baseline)
final_4$log_cr_icu<- log10(final_4$cr_icu)
final_4$deviation_log_creatinine<- final_4$log_cr_icu - final_4$log_creatinine_baseline
mean (final_4$deviation_log_creatinine, na.rm = TRUE)
sd(final_4$deviation_log_creatinine, na.rm = TRUE)
with(final_4 , qqnorm(log10(avgcreatinine_baseline)))
with(final_4 , qqnorm(log10(avgcreatinine_baseline) -log10(cr_icu)))

final_2$log_creatinine_baseline<- log10(final_2$avgcreatinine_baseline)
final_2$log_cr_icu<- log10(final_2$cr_icu)
final_2$deviation_log_creatinine<-final_2$log_cr_icu - final_2$log_creatinine_baseline
mean (final_2$deviation_log_creatinine, na.rm = TRUE)
sd(final_2$deviation_log_creatinine, na.rm = TRUE)
with(final_2 , qqnorm(log10(avgcreatinine_baseline)))
with(final_2 , qqnorm(log10(avgcreatinine_baseline) -log10(cr_icu)))

t.test(final_4$deviation_log_creatinine, final_2$deviation_log_creatinine, paired= FALSE)
```

### Merging the two files normal weight(final_2) with obese (final_4)
```{r}
total<-rbind(final_4,final_2)

```


## Adjusted laboratory deviation analysis

The differences in deviation from baseline between both groups were compared using multivariable linear regression adjusted for age, gender, comorbidity index index, SAPS-II score or SOFA score, and type of ICU, and the relevant baseline laboratory result. A full model comprising the BMI status and all the covariates was initially fit, and subjected to stepwise backwards elimination retaining BMI status in the model, until a final model was obtained with only statistically significant variables. 

```{r multiple linear regression wbc}

fit_wbc<-lm(deviation_wbc~age+gender+elixhauser+icu_type+bmi_group+avgwbc_baseline +sapsii, data=total) 
summary(fit_wbc)

fit_wbc<-lm(deviation_wbc~age+elixhauser+icu_type+bmi_group+avgwbc_baseline +sapsii, data=total) 
summary(fit_wbc)

fit_wbc<-lm(deviation_wbc~age+icu_type+bmi_group+avgwbc_baseline +sapsii, data=total) 
summary(fit_wbc)

drop1(fit_wbc, test="F")

sjPlot::sjt.lm(fit_wbc)
```

```{r multiple linear regression platelets}

fit_platelets<-lm(deviation_platelets~age+gender+elixhauser+icu_type+bmi_group+avgplatelets_baseline +sofa_score, data=total)
summary(fit_platelets)

fit_platelets<-lm(deviation_platelets~age+gender+icu_type+bmi_group+avgplatelets_baseline +sofa_score, data=total)
summary(fit_platelets)

drop1(fit_platelets, test="F")

sjPlot::sjt.lm(fit_platelets)


```


```{r  multiple linear regression sodium}

fit_na <-lm(deviation_na~age+gender+elixhauser+icu_type+bmi_group+avgsodium_baseline +sapsii, data= total)
summary(fit_na)

fit_na <-lm(deviation_na~gender+elixhauser+icu_type+bmi_group+avgsodium_baseline +sapsii, data= total)
summary(fit_na)

fit_na <-lm(deviation_na~elixhauser+icu_type+bmi_group+avgsodium_baseline +sapsii, data= total)
summary(fit_na)

drop1(fit_na, test="F")

sjPlot::sjt.lm(fit_na)

par(mfcol=c(2,2))
plot(fit_na)

```

```{r multiple linear regression potassium}

fit_k <- lm(deviation_k~age+gender+elixhauser+icu_type+bmi_group+avgpotassium_baseline +sapsii, data=total)
summary(fit_k)


fit_k <- lm(deviation_k~age+elixhauser+icu_type+bmi_group+avgpotassium_baseline +sapsii, data=total)
summary(fit_k)

fit_k <- lm(deviation_k~age+icu_type+bmi_group+avgpotassium_baseline +sapsii, data=total)
summary(fit_k)


drop1(fit_k, test= "F")

sjPlot::sjt.lm(fit_k)

par(mfcol=c(2,2))
plot(fit_k)

```

```{r multiple linear regression log creatinine}

total$log_cr_baseline<- log10(total$avgcreatinine_baseline)

total$log_cr_icu<- log10(total$cr_icu)

total$deviation_log_creatinine <- total$log_cr_icu - total$log_cr_baseline

with(total,t.test(deviation_log_creatinine~bmi_group))

fit_log_creatinine <-lm(deviation_log_creatinine~age+gender+elixhauser+icu_type+bmi_group+log_cr_baseline +sofa_score, data= total)
summary(fit_log_creatinine)

fit_log_creatinine <-lm(deviation_log_creatinine~gender+elixhauser+icu_type+bmi_group+log_cr_baseline +sofa_score, data= total)
summary(fit_log_creatinine)

drop1(fit_log_creatinine, test="F")

sjPlot::sjt.lm(fit_log_creatinine)

par(mfcol=c(2,2))
plot(fit_log_creatinine)

```

```{r multiple linear regression log BUN}

total$log_bun_baseline<- log10(total$avgbun_baseline)
total$log_bun_icu<- log10(total$bun_icu)
total$deviation_log_bun <- total$log_bun_icu - total$log_bun_baseline

with(total,t.test(deviation_log_bun~bmi_group))

fit_log_bun <-lm(deviation_log_bun~age+gender+elixhauser+icu_type+bmi_group+log_bun_baseline +sofa_score, data= total)
summary(fit_log_bun)

drop1(fit_log_bun, test="F")

sjPlot::sjt.lm(fit_log_bun)

par(mfcol=c(2,2))
plot(fit_log_bun)

```

```{r multiple linear regression BIC}

fit_bic <-lm(deviation_bic~age+gender+elixhauser+icu_type+bmi_group+avgbic_baseline+sapsii, data= total)
summary(fit_bic)

fit_bic <-lm(deviation_bic~age+elixhauser+icu_type+bmi_group+avgbic_baseline+sapsii, data= total)
summary(fit_bic)


drop1(fit_bic, test="F")

fit_bic <-lm(deviation_bic~age+elixhauser+bmi_group+avgbic_baseline+sapsii, data= total)
summary(fit_bic)

sjPlot::sjt.lm(fit_bic)

par(mfcol=c(2,2))
plot(fit_bic)

```

 # Extracting all outputs of the multivariate linear regression
 
```{r}

sjPlot::sjt.lm(fit_wbc)

sjPlot::sjt.lm(fit_platelets)

sjPlot::sjt.lm(fit_na)

sjPlot::sjt.lm(fit_k)

sjPlot::sjt.lm(fit_log_creatinine)

sjPlot::sjt.lm(fit_log_bun)

sjPlot::sjt.lm(fit_bic)



```

# Creation of subset without any missing variable and analyzing the impact of the statiscally significant deviations in the hospital mortality

```{r}

total_s<-subset(total, !is.na(deviation_wbc) & !is.na(deviation_log_bun) & !is.na(deviation_log_creatinine))
nrow(total)
nrow(total_s)

lr<-glm (hospital_expire_flag ~ sapsii + sofa_score + age + wbc_icu + log_bun_icu + log_cr_icu, data=total_s, family = binomial)
summary(lr)

lr1<-glm (hospital_expire_flag ~ sapsii + sofa_score + age + wbc_icu + deviation_wbc + log_bun_icu +  deviation_log_bun + log_cr_icu + deviation_log_creatinine, data=total_s, family = binomial)
summary(lr1)

anova(lr1, lr, test ="Chisq")
```




