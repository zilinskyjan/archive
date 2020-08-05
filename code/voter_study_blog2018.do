* Author: Jan Zilinsky

* Data available at: https://www.voterstudygroup.org/data
use "2017_VOTER/VOTER_Survey_July17_Release1-dta.dta"
set more off, perm

* Vote choice

gen obama08 = (presvote08_baseline==1) if !mi(presvote08_baseline)
gen mccain08 =  (presvote08_baseline==2) if !mi(presvote08_baseline)
gen obama12 = (post_presvote12_2012==1) if !mi(post_presvote12_2012)
gen romney12 = (post_presvote12_2012==2) if !mi(post_presvote12_2012)

gen obamaTrumpVoter = (post_presvote12_2012==1 & presvote16post_2016==2) if presvote16post_2016 != 7 & post_presvote12_2012 !=7 & presvote16post_2016 != . & post_presvote12_2012 !=.

gen clinton16 = (presvote16post_2016==1) if !mi(presvote16post_2016) & presvote16post_2016 != 7
gen trump16 = (presvote16post_2016==2) if !mi(presvote16post_2016) & presvote16post_2016 != 7
label var trump16 "Voted for Trump"
label var clinton16 "Voted for Clinton"
gen turned_out = (turnout16_2016==1) if !mi(turnout16_2016)


************
* Covariates
************
gen female = (gender_baseline==2)
gen married = (marstat_2016==1) if !mi(marstat_2016)
gen emp_fulltime = (employ_2016==1) if !mi(employ_2016)  

gen age = 2016-birthyr_baseline if !mi(birthyr_baseline)


gen age_group = age
recode age_group 18/30=1 31/49=2 50/64=3 65/99=4
label def age_val 1 "18-30 years old" 2 "31-49 years old" 3 "50-64 years old" 4 "65 or more years old", replace
label val age_group age_val

*tab educ_2016, gen(ed_group)
label define EDUC_201 1 "No high school", modify
label define EDUC_201 2 "HS graduate", modify
label define EDUC_201 4 "2-year college", modify
label define EDUC_201 5 "4-year college", modify

gen ed_coarse = educ_2016
recode ed_coarse 1/2=0 3/6=1
label def edc_val 0 "HS grad or less" 1 "At least some college"
label val ed_coarse edc_val

replace pid3_baseline=. if pid3_baseline==4 | pid3_baseline==5
replace post_pid3_2012=. if post_pid3_2012==4 | post_pid3_2012==5
replace pid3_2016=. if pid3_2016==4 | pid3_2016==5

gen party_switch_2011_16 = (pid3_2016 != pid3_baseline) if !mi(pid3_2016) & !mi(pid3_baseline) /* 2016 is reorded later so it must be placed here early on */
gen party_switch_2012_16 = (pid3_2016 != post_pid3_2012) if !mi(pid3_2016) & !mi(post_pid3_2012) /* 2016 is reorded later so it must be placed here early on */

gen pid3_2016_original = pid3_2016
recode pid3_2016 2=3 3=2 4/5=.
tab pid3_2016, gen(partyid)
label def party_val 1 "Democrat" 2 "Independent" 3 "Republican"
label val pid3_2016 party_val
gen democrat = (partyid1==1)
gen republican = (partyid3==1)

gen white = (race_2016==1) if !mi(race_2016)
gen black = (race_2016==2) if !mi(race_2016)
gen hispanic = (race_2016==3) if !mi(race_2016)
gen asian = (race_2016==4) if !mi(race_2016)

gen union_member = (labunmemb_2016==1)

recode faminc_2016 97=.
gen inc_less_than_20K = (faminc_2016==1 | faminc_2016==2)  if !mi(faminc_2016)
gen inc_50to70K = (faminc_2016==6 | faminc_2016==7)  if !mi(faminc_2016)
gen inc_70to120K = (faminc_2016==8 | faminc_2016==9 | faminc_2016==10)  if !mi(faminc_2016)
gen inc_120Kplus = (faminc_2016 >=11) if !mi(faminc_2016)

gen inc_group = faminc_2016
recode inc_group 1/2=1 3/5=2 6/7=3 8/10=4 11/31=5
label def inc_val 1 "Less than $19,999" 2 "$20K-$49.9K" 3 "$50K-$69.9K" 4 "$70K-$119.9K" 5 "$120,000 or more", replace
label val inc_group inc_val


label var democrat "Democrat"
label var republican "Republican"

label var sander_favorable "Favorable view of Sanders"
label var econ_better "Economy getting better"
label var white "White"
label var black "Black"
label var hispanic "Hispanic"
label var asian "Asian"
label var female "Female"
label var married "Married"
label var union_member "Labor union member"
label var emp_fulltime "Employed full-time"

label var immigration_very_important "Immigration: v. important issue"
label var whites_discriminated "Discrim. against whites: a big problem"


******
* BLOG
******

* CLAIM: Among young moderates, 70% voted for Clinton in 2016.
 tab ideo5_2016 clinton [aw=weight_2016] if age_group==1, r
 
* Charts originally posted at http://janzilinsky.com/voting-patterns-in-2016-age/ are based on the following:
tab age_group ideo5_2016 [aw=weight_2016], r nof
tab age_group democrat [aw=weight_2016], r nof


