clear
clear mata
clear matrix
set mem 1000m
set more off
cd "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis"
set maxvar 10000

*Imputation 

use finalsample.dta, clear 

merge 1:1 id using six.dta 

drop _merge 

rename age age24
rename wt wt24
rename ht ht24
rename bmi bmi24

reshape long age wt ht bmi ,i(id) j(visit)

egen zwt = zanthro(wt,wa,UK), xvar(age) gender(sex) gencode(male=0, female=1) nocutoff 		
egen zht = zanthro(ht,ha,UK), xvar(age) gender(sex) gencode(male=0, female=1) nocutoff 		
egen zbmi = zanthro(bmi,ba,UK), xvar(age) gender(sex) gencode(male=0, female=1) nocutoff 		

reshape wide age wt ht bmi zwt zht zbmi, i(id) j(visit)

order id cidB3164- cprob6_cat age* wt* ht* bmi* zwt* zht* zbmi*

*drop cprob1_cat cprob2_cat cprob3_cat cprob4_cat cprob5_cat cprob6_cat 
*reshape long cprob ,i(id) j(class)

rename age24 age
rename wt24 wt
rename ht24 ht
rename bmi24 bmi 
drop zwt24 zht24 zbmi24

mdesc eth sex birthweight ga gesthyp pregnancy_diabetes ///
mage mbmi meduc msmoke malc page pbmi pedu income occ	///
pfai bfai cfai breast	/// 
wt ht bmi sbp dbp		///
fat lean trunk_fat trunk_lean peri_fat peri_lean 	///
trig chol hdl ldl insulin glucose crp pwv imt	///
rwt lvmi avs EA Ee ejfr	///
zht1 zht9 zwt1 zwt9	///
age c	

foreach x in mbmi pbmi wt bmi 		///
fat lean trunk_fat trunk_lean peri_fat peri_lean	///
trig insulin glucose crp {
gen ln_`x' = ln(`x')
}

foreach x in meduc pedu income occ  {
wridit `x', gen(wr_`x')
}

set matsize 1000 
mi set mlong

mi register imputed 										///	
eth birthweight gesthyp pregnancy_diabetes  ///
ln_mbmi meduc msmoke malc page ln_pbmi pedu income occ	///
pfai bfai cfai breast	/// 
ln_wt ht ln_bmi sbp dbp		///
ln_fat ln_lean ln_trunk_fat ln_trunk_lean ln_peri_fat ln_peri_lean 	///
ln_trig chol hdl ldl ln_insulin ln_glucose ln_crp pwv imt	///
rwt lvmi avs EA Ee ejfr zht1 zht9 zwt1 zwt9	

mi impute chained 													///
(regress) ln_mbmi ln_pbmi	/// 
ln_wt ln_bmi 	///
ln_fat ln_lean ln_trunk_fat ln_trunk_lean ln_peri_fat ln_peri_lean 	///
ln_trig ln_insulin ln_glucose ln_crp 	///
zht1 zht9 zwt1 zwt9	///
birthweight ht sbp dbp chol hdl ldl pwv imt lvmi rwt avs EA Ee page ejfr  	///
(logit) eth gesthyp pregnancy_diabetes msmoke malc	///
(mlogit, ascont) breast meduc pedu income occ 	///
(ologit, ascont) pfai bfai cfai 	///
= i.sex i.c ga mage age 					///
, rseed(1250) augment add(100) noisily

save imputed2.dta, replace

mi impute chained 			///
(regress) ln_mbmi ln_pbmi page	/// 
zht1 zht9 zwt1 zwt9			///
birthweight   				///
(logit) eth gesthyp pregnancy_diabetes msmoke malc	///
(mlogit, ascont) breast meduc pedu income occ 	///
(ologit, ascont) pfai bfai cfai 	///
= i.sex i.c ga mage  					///
, rseed(1250) augment add(100) noisily

save imputed2_ycomplete.dta, replace

mi impute chained 													///
(regress) ln_mbmi ln_pbmi	/// 
ln_wt ln_bmi 	///
ln_fat ln_lean ln_trunk_fat ln_trunk_lean ln_peri_fat ln_peri_lean 	///
ln_trig ln_insulin ln_glucose ln_crp 	///
zht1 zht9 zwt1 zwt9	///
birthweight ht sbp dbp chol hdl ldl pwv imt lvmi rwt avs EA Ee page ejfr  	///
(truncreg, ll(0) ul(18)) pfai bfai   	///
(truncreg, ll(0) ul(15)) cfai  ///
(logit) eth gesthyp pregnancy_diabetes msmoke malc	///
(mlogit, ascont) breast meduc pedu income occ 	///
= i.sex i.c ga mage age  					///
, rseed(1250) augment add(100) noisily

save imputed.dta, replace
