* Purpose: Illustrate basic STATA commands with the CCES data

* Author: Jan Zilinsky 
* Intended for: NYU students in Jonathan Nagler's Elections course

cd "/Users/jz/Dropbox/NYU NOW/JN_explaining_2016/Data_individual/CCES_2016"

use "CCES16_Common_OUTPUT_Jul2017_VV.dta"

* Set survey weights
svyset [pw=commonweight_vv_post]

************
* Covariates
************
gen income = faminc
replace income = . if faminc == 97
replace income = . if faminc == 98
recode income 12/31=12
label def inc_val 1 "Less than $10,000" 2 "$10 - $19,999" 3 "$20 - $29,999" 4 "$30 - $39,999" 5 "$40 - $49,999" 6 "$50 - $59,999" 7 "$60 - $69,999" 8 "$70 - $79,999" 9 "$80 - $99,999" 10 "$100 - $119,999" 11 "$120 - $149,999" 12 "$150,000 or more"
label val income inc_val

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

gen pid3_2016_original = pid3
recode pid3 2=3 3=2 4/8=.

label def party_val 1 "Democrat" 2 "Independent" 3 "Republican"
label val pid3 party_val

* Fidning voters

* Vote choice in 2012:
tab CC16_326

* Vote choice in 2016:
tab CC16_410a

* Run the above without labels so that you know how to clean your variables
tab CC16_410a, nol

* Generate vote variables
gen clinton16 = (CC16_410a==2)
replace clinton = . if CC16_410a==.
replace clinton = . if CC16_410a==98
replace clinton = . if CC16_410a==99

gen obama12_trump16 = (CC16_326 == 1 & CC16_410a == 1)

* Summarize the % of people who switched
summarize obama12_trump16
summarize obama12_trump16 [aw=commonweight_vv_post]
tabstat obama12_trump16 [aw=commonweight_vv_post]
tab obama12_trump16 [aw=commonweight_vv_post]

* Why is the above a problem?

* Look at the N.  The denominator is not right!

drop obama12_trump16 

* THIS IS THE WAY TO DO THE CODING:
gen obama12_trump16 = (CC16_326 == 1 & CC16_410a == 1) if !missing(CC16_326) & !missing(CC16_410a) & CC16_410a != 99 & CC16_410a != 98

summarize obama12_trump16 [aw=commonweight_vv_post]
tabstat obama12_trump16 [aw=commonweight_vv_post]

* Without the appropriate adjustment, we would have understated the number of voters who switched ...

* Crosstabs by ID

* Who switched most often?
tab obama12_trump16 pid3 [aw=commonweight_vv_post], co 
tab obama12_trump16 pid7 [aw=commonweight_vv_post], co

* How loyal were Democrats to Clinton
tab clinton pid3 [aw=commonweight_vv_post], co 


* Attitudes to immigrants:

tab CC16_331_1
tab CC16_331_2
tab CC16_331_6
tab CC16_331_8

tab obama12_trump16 CC16_331_1 [aw=commonweight_vv_post]
tab obama12_trump16 CC16_331_1 [aw=commonweight_vv_post], co


tabstat obama12_trump16 [aw=commonweight], by(CC16_331_1) 
* Repeat for independents only 
tabstat obama12_trump16 [aw=commonweight] if pid3==3, by(CC16_331_1) 


* Obama approval rating
tab CC16_320a


stop

* Predicting the vote

svy: reg clinton16 ib6.income 
margins, at(income=(1(1)12))
marginsplot

svy: reg clinton16 ib3.inc_coarse ib2.pid3
margins, at(inc_coarse=(1(1)4))
marginsplot, title("Probability of voting for Clinton by income") ///
note("Data: CCES (2016). Predictions from a probit regression. PID (not shown) is in the regression." "Analysis by Jan Zilinsky.", pos(6) size(*.8) col(gs10))  

svy: probit clinton16 i.white##ib3.inc_coarse ib2.pid3
margins white, at(inc_coarse=(1(1)4))
marginsplot, title("Probability of voting for Clinton by income and race") ///  
note("Data: CCES (2016). Predictions from a probit regression. PID (not shown) is in the regression." "Analysis by Jan Zilinsky.", pos(6) size(*.8) col(gs10))


svy: reg clinton16 ib6.income if inputstate_post==42

