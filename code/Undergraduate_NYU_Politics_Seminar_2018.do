* Obtain the CCES data from https://cces.gov.harvard.edu/

use "CCES16_Common_OUTPUT_Feb2018_VV.dta"

* Set survey weights
svyset [pw=commonweight_vv]

*****************************
* Prepare covariates / labels
*****************************

gen female = (gender==2) & !mi(gender)
label var female "Female"

gen inc_coarse = faminc
replace inc_coarse = . if faminc == 97
replace inc_coarse = . if faminc == 98
recode inc_coarse 1/3=1 4/6=2 7/9=3 10/31=4
label def inc_coarse_val 1 "Up to $29,999" 2 "$30-$59,999" 3 "$60-$99,999" 4 "$100,000 or more"
label val inc_coarse inc_coarse_val

gen white = (race==1)
gen black = (race==2)
drop hispanic
gen hispanic = (race==3)
gen asian = (race==4)

label var white "White"
label var black "Black"
label var hispanic "Hispanic"
label var asian "Asian"

gen emp_fulltime = (employ==1) if !mi(employ)
gen married = (marstat==1) if !mi(marstat)
label var emp_fulltime "Employed (full-time)"
label var married "Married"

gen age = 2016-birthyr if !mi(birthyr)
gen age_gr_temp = age
recode age_gr_temp (18/30=1 "18-30 years old")  (31/49=2 "31-49 years old")  (50/64=3 "50-64 years old")  (65/99=4 "65 or more years old"), gen(age_group)
drop age_gr_temp

gen beyondHS_yesno = (educ >=3)
label def beyond_val 0 "High school grad or less" 1 "Some college or more"
label val beyondHS_yesno beyond_val

gen pid3_2016_original = pid3
recode pid3 2=3 3=2 4/8=.
label def party_val 1 "Democrat" 2 "Independent" 3 "Republican"
label val pid3 party_val

gen democrat = (pid3==1) if !mi(pid3)
gen republican = (pid3==3) if !mi(pid3)

* Vote choice in 2012:
tab CC16_326
* Vote choice in 2016:
tab CC16_410a

* Generate vote variables
gen clinton16 = (CC16_410a==2)
replace clinton = . if CC16_410a==.
replace clinton = . if CC16_410a==7
replace clinton = . if CC16_410a==98
replace clinton = . if CC16_410a==99

gen trump16 = (CC16_410a==1)
replace trump16 = . if CC16_410a==.
replace trump16 = . if CC16_410a==7
replace trump16 = . if CC16_410a==98
replace trump16 = . if CC16_410a==99

gen obama12 = (CC16_326==1) if !mi(CC16_326)
replace obama12 = .  if CC16_326==4 | CC16_326==5

gen obama12_trump16 = (obama12 == 1 & CC16_410a == 1) if !missing(CC16_410a) & CC16_410a != 99 & CC16_410a != 98 & CC16_410a != 7

* Ideology
gen conservative = (ideo5==4 | ideo5==5) if !mi(ideo5)
gen liberal = (ideo5==1 | ideo5==2) if !mi(ideo5)

********************
* Make charts
********************

* Ideology and age
tab age_gr ideo5 [aw=commonweight_vv_post], row nofreq
reg conservative i.age_gr 
margins, at(age_gr=(1(1)4))

marginsplot
reg conservative i.age_gr##i.democrat
margins democrat, at(age_gr=(1(1)4))
marginsplot, yscale(range(0 .7)) title("Predictions of conservative ideology")

