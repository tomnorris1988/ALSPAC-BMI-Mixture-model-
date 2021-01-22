clear
clear mata
clear matrix
set mem 1000m
set more off
cd "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis"
set maxvar 10000

*table 1
use finalsample.dta, clear
mdesc
sum birthweight ga mage page 
tabstat mbmi pbmi, stat(q)
fre sex
fre eth 
fre meduc
fre msmoke 
fre malc
fre gesthyp
fre pregnancy_diab
fre pedu 
fre income
fre occ 
fre breast 
fre cat_pfai
fre cat_bfai
fre cat_cfai

*table 2
use finalsample.dta, clear
mdesc
sum age ht sbp dbp chol hdl ldl pwv imt lvmi rwt ejfr avs EA Ee
tabstat wt bmi fat trunk_fat peri_fat lean trunk_lean peri_lean tri insulin glucose crp, stat(q)

*table 3

use imputed3.dta, replace 

set matsize 1000 
mi set mlong

mi svyset [iw=cprob]

mi estimate: svy: mean birthweight ga mage page if class ==0 
mi estimate: svy: mean birthweight ga mage page if class ==1 
mi estimate: svy: mean birthweight ga mage page if class ==2 
mi estimate: svy: mean birthweight ga mage page if class ==3 
mi estimate: svy: mean birthweight ga mage page if class ==4 
mi estimate: svy: mean birthweight ga mage page if class ==5 

mi estimate, eform: svy: reg ln_mbmi lnorm normover norm_to_over overob norm_to_ob
mi estimate, eform: svy: reg ln_mbmi nlnorm  normover norm_to_over overob norm_to_ob
mi estimate, eform: svy: reg ln_mbmi nlnorm lnorm  norm_to_over overob norm_to_ob
mi estimate, eform: svy: reg ln_mbmi nlnorm lnorm normover  overob norm_to_ob
mi estimate, eform: svy: reg ln_mbmi nlnorm lnorm normover norm_to_over  norm_to_ob
mi estimate, eform: svy: reg ln_mbmi nlnorm lnorm normover norm_to_over overob

mi estimate, eform: svy: reg ln_pbmi lnorm normover norm_to_over overob norm_to_ob
mi estimate, eform: svy: reg ln_pbmi nlnorm  normover norm_to_over overob norm_to_ob
mi estimate, eform: svy: reg ln_pbmi nlnorm lnorm  norm_to_over overob norm_to_ob
mi estimate, eform: svy: reg ln_pbmi nlnorm lnorm normover  overob norm_to_ob
mi estimate, eform: svy: reg ln_pbmi nlnorm lnorm normover norm_to_over  norm_to_ob
mi estimate, eform: svy: reg ln_pbmi nlnorm lnorm normover norm_to_over overob

mi estimate: svy: proportion sex eth gesthyp pregnancy_diabetes msmoke malc meduc peduc occ income breast if class ==0 
mi estimate: svy: proportion sex eth gesthyp pregnancy_diabetes msmoke malc meduc peduc occ income breast if class ==1 
mi estimate: svy: proportion sex eth gesthyp pregnancy_diabetes msmoke malc meduc peduc occ income breast if class ==2 
mi estimate: svy: proportion sex eth gesthyp pregnancy_diabetes msmoke malc meduc peduc occ income breast if class ==3 
mi estimate: svy: proportion sex eth gesthyp pregnancy_diabetes msmoke malc meduc peduc occ income breast if class ==4 
mi estimate: svy: proportion sex eth gesthyp pregnancy_diabetes msmoke malc meduc peduc occ income breast if class ==5 


foreach x in pfai bfai cfai {
recode `x' (0=0)(1=1)(2=2)(3/20=3)(else=.), gen(cat_`x'2)
}

mi estimate: svy: proportion cat_pfai2 cat_bfai2 cat_cfai2 if class ==0 
mi estimate: svy: proportion cat_pfai2 cat_bfai2 cat_cfai2 if class ==1 
mi estimate: svy: proportion cat_pfai2 cat_bfai2 cat_cfai2 if class ==2 
mi estimate: svy: proportion cat_pfai2 cat_bfai2 cat_cfai2 if class ==3 
mi estimate: svy: proportion cat_pfai2 cat_bfai2 cat_cfai2 if class ==4 
mi estimate: svy: proportion cat_pfai2 cat_bfai2 cat_cfai2 if class ==5 



*table 4

/*
use imputed2.dta, clear 

set matsize 1000 
mi set mlong

mi passive: gen ln_wt100 = ln_wt*100
mi passive: gen ln_bmi100 = ln_bmi*100

mi passive: gen ln_fat100 = ln_fat*100
mi passive: gen ln_trunk_fat100 = ln_trunk_fat*100
mi passive: gen ln_peri_fat100 = ln_peri_fat*100

mi passive: gen ln_lean100 = ln_lean*100
mi passive: gen ln_trunk_lean100 = ln_trunk_lean*100
mi passive: gen ln_peri_lean100 = ln_peri_lean*100

mi passive: gen ln_trig100 = ln_trig*100
mi passive: gen ln_insulin100 = ln_insulin*100
mi passive: gen ln_glucose100 = ln_glucose*100
mi passive: gen ln_crp100 = ln_crp*100

recode c(5=0)(2=1)(1=2)(6=5), gen(class)

label define lclass 0 "nlnorm" 1 "lnorm" 2 "normover" 3 "norm_to_over" 4 "overob" 5 "norm_to_ob"
label values class lclass

tab class, gen(dum)

rename dum1 nlnorm
rename dum2 lnorm
rename dum3 normover
rename dum4 norm_to_over
rename dum5 overob
rename dum6 norm_to_ob

gen cprob = cprob1 if c ==1
replace cprob = cprob2 if c ==2
replace cprob = cprob3 if c ==3
replace cprob = cprob4 if c ==4
replace cprob = cprob5 if c ==5
replace cprob = cprob6 if c ==6

save imputed3.dta, replace 
*/

use imputed3.dta, replace 

set matsize 1000 
mi set mlong

mi svyset [iw=cprob]

*main 
mi estimate: svy: regress ht age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress sbp age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress dbp  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress chol age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress hdl age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ldl age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress pwv age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress imt age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress lvmi age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  rwt age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ejfr age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress avs age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress EA age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress Ee age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast

mi estimate: svy: regress ln_wt100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_bmi100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_fat100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_fat100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_fat100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_lean100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_lean100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_lean100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trig100   age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_insulin100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  ln_glucose100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress   ln_crp100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast

***8th January 2021
*in response to reviewer comments we had to do the regressions stratified by sex
preserve 
keep if sex==0
mi estimate: svy: regress ht age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress sbp age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress dbp  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress chol age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress hdl age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ldl age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress pwv age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress imt age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress lvmi age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  rwt age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ejfr age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress avs age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress EA age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress Ee age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast

mi estimate: svy: regress ln_wt100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_bmi100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_fat100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_fat100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_fat100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_lean100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_lean100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_lean100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trig100   age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_insulin100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  ln_glucose100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress   ln_crp100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
restore
preserve
keep if sex==1
mi estimate: svy: regress ht age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress sbp age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress dbp  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress chol age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress hdl age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ldl age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress pwv age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress imt age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress lvmi age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  rwt age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ejfr age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress avs age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress EA age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress Ee age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast

mi estimate: svy: regress ln_wt100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_bmi100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_fat100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_fat100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_fat100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_lean100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_lean100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_lean100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trig100   age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_insulin100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  ln_glucose100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress   ln_crp100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
restore



*overcomp
mi estimate: svy: regress ht age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress sbp age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress dbp  age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress chol age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress hdl age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ldl age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress pwv age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress imt age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress lvmi age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  rwt age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ejfr age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress avs age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress EA age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress Ee age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast

mi estimate: svy: regress ln_wt100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_bmi100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_fat100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_fat100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_fat100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_lean100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_lean100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_lean100  age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trig100   age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_insulin100  age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  ln_glucose100  age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress   ln_crp100  age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast

***8th january 2021 in response to reviewer comments we have to regressions by sex
preserve
keep if sex==0
mi estimate: svy: regress ht age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress sbp age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress dbp  age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress chol age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress hdl age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ldl age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress pwv age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress imt age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress lvmi age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  rwt age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ejfr age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress avs age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress EA age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress Ee age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast

mi estimate: svy: regress ln_wt100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_bmi100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_fat100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_fat100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_fat100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_lean100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_lean100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_lean100  age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trig100   age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_insulin100  age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  ln_glucose100  age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress   ln_crp100  age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
restore
preserve
keep if sex==1
mi estimate: svy: regress ht age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress sbp age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress dbp  age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress chol age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress hdl age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ldl age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress pwv age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress imt age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress lvmi age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  rwt age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ejfr age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress avs age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress EA age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress Ee age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast

mi estimate: svy: regress ln_wt100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_bmi100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_fat100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_fat100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_fat100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_lean100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_lean100 age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_lean100  age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trig100   age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_insulin100  age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  ln_glucose100  age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress   ln_crp100  age							///
lnorm nlnorm norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
restore


*obesecomp
mi estimate: svy: regress ht age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress sbp age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress dbp  age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress chol age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress hdl age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ldl age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress pwv age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress imt age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress lvmi age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  rwt age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ejfr age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress avs age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress EA age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress Ee age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast

mi estimate: svy: regress ln_wt100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_bmi100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_fat100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_fat100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_fat100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_lean100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_lean100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_lean100  age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trig100   age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_insulin100  age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  ln_glucose100  age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress   ln_crp100  age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast

***8th january 2021 in response to reviewer comments we have to regressions by sex
preserve
keep if sex==0
mi estimate: svy: regress ht age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress sbp age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress dbp  age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress chol age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress hdl age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ldl age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress pwv age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress imt age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress lvmi age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  rwt age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ejfr age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress avs age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress EA age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress Ee age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast

mi estimate: svy: regress ln_wt100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_bmi100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_fat100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_fat100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_fat100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_lean100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_lean100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_lean100  age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trig100   age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_insulin100  age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  ln_glucose100  age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress   ln_crp100  age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
restore
preserve
keep if sex==1
mi estimate: svy: regress ht age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress sbp age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress dbp  age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress chol age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress hdl age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ldl age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress pwv age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress imt age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress lvmi age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  rwt age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ejfr age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress avs age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress EA age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress Ee age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast

mi estimate: svy: regress ln_wt100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_bmi100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_fat100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_fat100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_fat100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_lean100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_lean100 age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_lean100  age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trig100   age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_insulin100  age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  ln_glucose100  age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress   ln_crp100  age							///
lnorm nlnorm norm_to_over normover norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
restore

*Supp Table 1 - comparison to F24 sample & ALSPAC
use anthro.dta, clear
merge 1:1 cidB3164 order using covars.dta
drop _merge 
sort cidB3164
merge 1:1 cidB3164 order using outcomes.dta
drop _merge 
count 

drop if kz011b == -9999
drop if kz011b == 2

sum age
drop if age ==. 
sum birthweight ga mage page 
tabstat mbmi pbmi, stat(q)
fre sex
fre eth 
fre meduc
fre msmoke 
fre malc
fre gesthyp
fre pregnancy_diab
fre pedu 
fre income
fre occ 
fre breast 
fre cat_pfai
fre cat_bfai
fre cat_cfai
mdesc  ///
sex eth birthweight ga gesthyp pregnancy_diabetes ///
msmoke malc mage mbmi meduc  	///
page pbmi pedu  ///
occ income pfai bfai cfai ///
breast 

*Supp Table 2 - description of anthro 
use mplusexclusions.dta, clear
foreach x in bmi1-ht10        { 
recode `x' (-9999=.)
}
sum wt* ht* 
tabstat bmi* age* , stat(q min max range n)

*Supp Table 5 - final mixture model summary
*redo for each class solution 
use finalsample.dta, replace
merge 1:1 id using six.dta 
drop _merge 
tab c
sum cprob1 if c==1
sum cprob2 if c==2
sum cprob3 if c==3
sum cprob4 if c==4
sum cprob5 if c==5
sum cprob6 if c==6
tab cprob1_cat if c==1
tab cprob2_cat if c==2
tab cprob3_cat if c==3
tab cprob4_cat if c==4
tab cprob5_cat if c==5
tab cprob6_cat if c==6

*Supp Table 6 - missing data patterns 
use finalsample.dta, replace
mvpatterns ///
sex eth birthweight ga gesthyp pregnancy_diabetes ///
msmoke malc mage mbmi meduc  	///
page pbmi pedu  ///
occ income pfai bfai cfai ///
breast ///
ht wt bmi  ///
fat trunk_fat peri_fat  /// 
lean trunk_lean peri_lean ///
sbp dbp ///
chol hdl ldl trig  ///
insulin glucose crp pwv imt ///
lvmi rwt ejfr avs EA Ee 

*Supp Table 7 - comp missing on key var 
use finalsample.dta, clear

gen nmis_cardio =1 if lvmi == . & rwt  == . & ejfr  == . & avs  == . & EA == . & Ee  == . & pwv == . & imt == . 
replace nmis_cardio =0 if nmis_cardio ==.
tab nmis_cardio
tab sex nmis_cardio, chi col 
tab eth nmis_cardio, chi col
tab gesthyp nmis_cardio, chi col
tab pregnancy_diabetes nmis_cardio, chi col
tab msmoke nmis_cardio, chi col
tab malc nmis_cardio, chi col
tab medu nmis_cardio, chi col
tab pedu nmis_cardio, chi col
tab occ nmis_cardio, chi col
tab income nmis_cardio, chi col
tab cat_pfai nmis_cardio, chi col
tab cat_bfai nmis_cardio, chi col
tab cat_cfai nmis_cardio, chi col
tab breast nmis_cardio, chi col
bysort nmis_cardio: sum birthweight ga mage page age ht sbp dbp chol hdl ldl pwv imt lvmi rwt ejfr avs EA Ee
bysort nmis_cardio: tabstat mbmi pbmi wt bmi fat trunk_fat peri_fat lean trunk_lean peri_lean tri insulin glucose crp , stat(p50)
foreach x in birthweight ga mage page age ht sbp dbp chol hdl ldl  {
ttest `x', by(nmis_cardio)
}
foreach x in mbmi pbmi wt bmi fat trunk_fat peri_fat lean trunk_lean peri_lean trig insulin glucose crp   {
ranksum `x', by(nmis_cardio)
}

gen nmis_blood =1 if chol == . & hdl == . & ldl == . & trig == . & insulin == . & glucose == . & crp
replace nmis_blood =0 if nmis_blood ==. 
tab nmis_blood
tab nmis_blood
tab sex nmis_blood, chi col 
tab eth nmis_blood, chi col
tab gesthyp nmis_blood, chi col
tab pregnancy_diabetes nmis_blood, chi col
tab msmoke nmis_blood, chi col
tab malc nmis_blood, chi col
tab medu nmis_blood, chi col
tab pedu nmis_blood, chi col
tab occ nmis_blood, chi col
tab income nmis_blood, chi col
tab cat_pfai nmis_blood, chi col
tab cat_bfai nmis_blood, chi col
tab cat_cfai nmis_blood, chi col
tab breast nmis_blood, chi col
bysort nmis_blood: sum birthweight ga mage page age ht sbp dbp chol hdl ldl pwv imt lvmi rwt ejfr avs EA Ee
bysort nmis_blood: tabstat mbmi pbmi wt bmi fat trunk_fat peri_fat lean trunk_lean peri_lean tri insulin glucose crp , stat(p50)
foreach x in birthweight ga mage page age ht sbp dbp pwv imt lvmi rwt ejfr avs EA Ee  {
ttest `x', by(nmis_blood)
}
foreach x in mbmi pbmi wt bmi fat trunk_fat peri_fat lean trunk_lean peri_lean   {
ranksum `x', by(nmis_blood)
}

*Supp Table 8 - unweighted 

use imputed3.dta, replace 

set matsize 1000 
mi set mlong

mi estimate:  regress ht age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress sbp age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress dbp  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress chol age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress hdl age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress ldl age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress pwv age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress imt age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress lvmi age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress  rwt age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress ejfr age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress avs age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress EA age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress Ee age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast

mi estimate:  regress ln_wt100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress ln_bmi100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress ln_fat100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress ln_trunk_fat100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress ln_peri_fat100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress ln_lean100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress ln_trunk_lean100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress ln_peri_lean100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress ln_trig100   age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress ln_insulin100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress  ln_glucose100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate:  regress   ln_crp100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast

*Supp Table 9 - unadjusted  

use imputed3.dta, replace 

set matsize 1000 
mi set mlong

mi svyset [iw=cprob]

mi estimate: svy: regress ht 							///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress sbp 							///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress dbp  							///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress chol 							///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress hdl 							///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress ldl 							///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress pwv 							///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress imt 							///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress lvmi 							///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress  rwt 							///
lnorm normover norm_to_over overob norm_to_ob			
mi estimate: svy: regress ejfr 							///
lnorm normover norm_to_over overob norm_to_ob			
mi estimate: svy: regress avs 							///
lnorm normover norm_to_over overob norm_to_ob			
mi estimate: svy: regress EA 							///
lnorm normover norm_to_over overob norm_to_ob			
mi estimate: svy: regress Ee 							///
lnorm normover norm_to_over overob norm_to_ob				

mi estimate: svy: regress ln_wt100 							///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress ln_bmi100 						///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress ln_fat100 						///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress ln_trunk_fat100 					///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress ln_peri_fat100 					///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress ln_lean100 						///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress ln_trunk_lean100 					///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress ln_peri_lean100  					///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress ln_trig100   						///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress ln_insulin100  					///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress  ln_glucose100  					///
lnorm normover norm_to_over overob norm_to_ob				
mi estimate: svy: regress   ln_crp100  						///
lnorm normover norm_to_over overob norm_to_ob


*Supp Table 10 - complete outcome 

/*
use imputed2_ycomplete.dta, clear 

set matsize 1000 
mi set mlong

mi passive: gen ln_wt100 = ln_wt*100
mi passive: gen ln_bmi100 = ln_bmi*100

mi passive: gen ln_fat100 = ln_fat*100
mi passive: gen ln_trunk_fat100 = ln_trunk_fat*100
mi passive: gen ln_peri_fat100 = ln_peri_fat*100

mi passive: gen ln_lean100 = ln_lean*100
mi passive: gen ln_trunk_lean100 = ln_trunk_lean*100
mi passive: gen ln_peri_lean100 = ln_peri_lean*100

mi passive: gen ln_trig100 = ln_trig*100
mi passive: gen ln_insulin100 = ln_insulin*100
mi passive: gen ln_glucose100 = ln_glucose*100
mi passive: gen ln_crp100 = ln_crp*100

recode c(5=0)(2=1)(1=2)(6=5), gen(class)

label define lclass 0 "nlnorm" 1 "lnorm" 2 "normover" 3 "norm_to_over" 4 "overob" 5 "norm_to_ob"
label values class lclass

tab class, gen(dum)

rename dum1 nlnorm
rename dum2 lnorm
rename dum3 normover
rename dum4 norm_to_over
rename dum5 overob
rename dum6 norm_to_ob

gen cprob = cprob1 if c ==1
replace cprob = cprob2 if c ==2
replace cprob = cprob3 if c ==3
replace cprob = cprob4 if c ==4
replace cprob = cprob5 if c ==5
replace cprob = cprob6 if c ==6

save imputed3_ycomplete.dta, replace 
*/

use imputed3_ycomplete.dta, replace 

set matsize 1000 
mi set mlong

mi svyset [iw=cprob]

mi estimate: svy: regress ht age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress sbp age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress dbp  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress chol age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress hdl age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ldl age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress pwv age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress imt age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress lvmi age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  rwt age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ejfr age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress avs age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress EA age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress Ee age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast

mi estimate: svy: regress ln_wt100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_bmi100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_fat100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_fat100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_fat100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_lean100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trunk_lean100 age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_peri_lean100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_trig100   age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress ln_insulin100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress  ln_glucose100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
mi estimate: svy: regress   ln_crp100  age							///
lnorm normover norm_to_over overob norm_to_ob				///
sex eth birthweight ga gesthyp pregnancy_diabetes msmoke malc mage ln_mbmi i.meduc page ln_pbmi	i.pedu i.occ i.income pfai bfai cfai i.breast
