clear
clear mata
clear matrix
set mem 1000m
set more off
cd "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis 1"
set maxvar 10000

*outcomes 

use Johnson_9Dec2019.dta, clear

encode qlet, gen(order)
sort cidB3164 order 
gen id =_n

keep cidB3164 qlet order id ///
Insulin_F24 Glucose_F24 Trig_F24 HDL_F24 LDL_F24 CRP_F24	///
FKBP1030 FKBP1031 FKDX1001 FKDX1031  Chol_F24	///
FKAR0010 FKMS1000 FKMS1030 in_core in_phase2 in_phase3 in_phase4	///
FKCV1131 FKCV2131 FKCV4200	///
FKDX1011 FKDX1012 FKDX1021 FKDX1022 FKDX1032 FKDX1002 ///
FKEC5180 FKEC5080 FKEC5050 FKEC5080 FKEC5090 FKEC5260 FKEC5320	///
FKEC5350 FKEC5330 FKEC5250

order cidB3164 qlet order id

rename FKBP1030 sbp 
rename FKBP1031 dbp
rename FKDX1001 fat
rename FKDX1031 trunk_fat
rename Insulin_F24 insulin
rename Glucose_F24 glucose
rename Trig_F24 trig
rename LDL_F24 ldl
rename HDL_F24 hdl
rename CRP_F24 crp 
rename Chol_F24 chol
rename FKAR0010 age
rename FKMS1000 ht
rename FKMS1030 wt
rename FKCV1131 rimt
rename FKCV2131	limt
rename FKCV4200 pwv
rename FKDX1011 arm_fat
rename FKDX1012 arm_lean
rename FKDX1021 leg_fat
rename FKDX1022 leg_lean
rename FKDX1032 trunk_lean
rename FKDX1002 lean

foreach var in age-FKEC5350 {
recode `var' (-9999/-1 = .)
}

replace ht = ht/10
replace ht = ht /100 

gen bmi = wt/ht^2

replace ht = ht*100

replace age = age/12

foreach x in fat lean arm_fat arm_lean leg_fat leg_lean trunk_fat trunk_lean {
replace `x' = `x'/ 1000 
}

gen peri_fat = arm_fat + leg_fat 
gen peri_lean = arm_lean + leg_lean 

drop arm_fat leg_fat arm_lean leg_lean 

gen imt = (rimt + limt) /2

drop rimt limt

gen rwt = 2 * FKEC5180/FKEC5080
gen lvm = 1.05*(((FKEC5080 + FKEC5180 + FKEC5050)^3) - (FKEC5080^3))
gen lvmi = lvm / (ht/100)^3
gen avs = (FKEC5260+FKEC5320)/2
gen EA = FKEC5350/FKEC5330
gen Ee = FKEC5350/FKEC5250
replace FKEC5080 = (7*FKEC5080^3) / 2.4 + FKEC5080
replace FKEC5090 = (7*FKEC5090^3) / 2.4 + FKEC5090
gen ejfr = ((FKEC5080 - FKEC5090) / FKEC5080)*100 
drop FKEC*

replace ejfr = . if ejfr < 0

egen dum = rownonmiss(wt ht bmi sbp dbp fat lean trunk_fat trunk_lean peri_fat peri_lean trig chol hdl ldl insulin glucose crp pwv imt rwt lvm lvmi avs EA Ee ejfr) 

replace dum = 1 if dum != 0 

order cidB3164 qlet order id	///
in_core in_phase2 in_phase3 in_phase4 ///
age wt ht bmi	///
sbp dbp ///
fat lean trunk_fat trunk_lean peri_fat peri_lean ///
trig chol hdl ldl insulin glucose crp pwv imt	///
rwt lvm lvmi avs EA Ee ejfr

sort cidB3164

save outcomes.dta, replace

*covariates 

use Johnson_9Dec2019.dta, clear

encode qlet, gen(order)
sort cidB3164 order 
gen id =_n

keep cidB3164 qlet order id ///
mz028b- bestgest kz021- pregnancy_diabetes   ///
mplong mblong mtshort  ///
pk4220 pk4221 pc996  ///
kc401 kc403 kc403a kc404 ///
c666a  ///
m5180  ///
kk356a kk356b  ///
g_snssec_analytical_m ///
pe_snssec_analytical_p

drop m6161 m5160  dw042 preeclampsia

order cidB3164 qlet order id

foreach var in kz021-pe_snssec_analytical_p {
recode `var' (-9999/-1 = .)
}

rename kz021 sex 
tab sex
recode sex 1=0 2=1
labdtch sex
label define lsex 0 male 1 female 
label values sex lsex

rename c804 eth 
tab eth 
recode eth 1=0 2=1
labdtch eth
label define leth 0 white 1 nonwhite 
label values eth leth

rename kz030 birthweight
replace birthweight = birthweight

rename bestgest ga 
histogram ga, freq norm 

rename mz028b mage 
histogram mage, freq norm 

rename m4220 mwt 
histogram mwt, freq norm 

rename m4221 mht 
histogram mht, freq norm 

rename pc996 page 
histogram page, freq norm 

rename pk4220 pwt 
histogram pwt, freq norm 

rename pk4221 pht 
histogram pht, freq norm 

gen mbmi = mwt /(mht/100)^2
gen pbmi = pwt /(pht/100)^2
histogram mbmi, freq
histogram pbmi, freq

drop mwt mht pwt pht 

rename c645a med
tab med
tab med, nolab 
vreverse med, gen(meduc)
drop med  
 
rename c666a ped
tab ped
tab ped, nolab 
vreverse ped, gen(peduc)
drop ped  
 
tab gesthyp
tab gesthyp, nolab

tab pregnancy_diabetes
tab pregnancy_diabetes,nolab
recode pregnancy_diabetes (2/3 =1)
labdtch pregnancy_diabetes
label define lpregnancy_diabetes 0 no 1 yes 
label values pregnancy_diabetes lpregnancy_diabetes

rename b665 msmoke
tab msmoke
tab msmoke,nolab 
recode msmoke 1=0 2/5=1
labdtch msmoke
label define lmsmoke 0 no 1 yes 
label values msmoke lmsmoke

rename b721 malc
tab malc
tab malc,nolab 
recode malc 1/2=0 3/6=1
labdtch malc
label define lmalc 0 no 1 yes 
label values malc lmalc 

/*
fre kc401
gen bf = -1 if kc401 == 3 
tab kc403
replace bf = kc403 if bf == .
recode bf (-1=0)(0=1)(1/2=2)(3/5=3)(6/11=4)(12/77=5), gen(breast)
label define lbreast 0 "never" 1 "0" 2 "1-2" 3 "3-5" 4 "6-11" 5 "12+"  
label values breast lbreast
tab breast 
*/

vreverse kc404, gen(breast)
drop kc404

fre m5180 
recode m5180 (1/2=0)(3=1)(4=2)(5=3)(9=.), gen (inc)
tab inc 
label define linc 0 "0-199" 1 "200-299" 2 "300-399" 3 "400+" 
label values inc linc
vreverse inc, gen(income)
drop inc 

rename g_rnssec_analytical_m mocc
rename pe_snssec_analytical_p pocc

clonevar occ = pocc
replace occ = mocc if occ == . 

mdesc mplong mblong mtshort 
replace mplong =. if mplong < 0
replace mblong =. if mblong < 0
replace mtshort =. if mtshort < 0

rename mplong pfai
rename mblong bfai 
rename mtshort cfai 

foreach x in pfai bfai cfai {
recode `x' (0=0)(1=1)(2=2)(3/20=3)(else=.), gen(cat_`x')
}

order cidB3164 qlet order id ///
eth sex birthweight ga gesthyp pregnancy_diabetes ///
mage mbmi meduc msmoke malc mocc	///
page pbmi pedu pocc ///
income occ *pfai *bfai *cfai ///
breast 

drop kc401-mbshort

gen covars_miss = 1 if eth ==. 
replace covars_miss = 1 if sex == .
replace covars_miss = 1 if birthweight== .
replace covars_miss = 1 if ga == .
replace covars_miss = 1 if gesthyp == .
replace covars_miss = 1 if pregnancy_diabetes== .
replace covars_miss = 1 if mage == .
replace covars_miss = 1 if mbmi == .
replace covars_miss = 1 if medu== .
replace covars_miss = 1 if msmok== .
replace covars_miss = 1 if malc== .
replace covars_miss = 1 if mocc== .
replace covars_miss = 1 if page== .
replace covars_miss = 1 if pbmi== .
replace covars_miss = 1 if pedu== .
replace covars_miss = 1 if pocc== .
replace covars_miss = 1 if income== .
replace covars_miss = 1 if pfai== .
replace covars_miss = 1 if bfai== .
replace covars_miss = 1 if cfai== .
replace covars_miss = 1 if breast== .

sort cidB3164 order

reshape wide qlet id sex birthweight breast covars_miss , i(cidB3164) j(order)

gen twin = 1 if id2 != .

reshape long qlet id sex birthweight breast covars_miss , i(cidB3164) j(order)
drop if id ==. 

order cidB3164 qlet order id ///
twin eth sex birthweight ga gesthyp pregnancy_diabetes ///
mage mbmi meduc msmoke malc mocc	///
page pbmi pedu pocc ///
income occ pfai bfai cfai ///
breast 

sort cidB3164 order

save covars.dta, replace

*Anthro 

use Johnson_05Sep2019.dta, clear

encode qlet, gen(order)
sort cidB3164 order 
gen id =_n

keep cidB3164 qlet order id f7003b - FKCO1011 FKMS1000 FKMS1030 FKFH1071 FKMS1040 FKAR0010 in_core in_phase2 in_phase3 in_phase4
drop f7003c f8003c f9003c fd003c fe003c ff0011a fg0011a fh0011a 
drop f9ms026a fdms026a fems026a fg3139 fh3019 FJMR022a FKMS1040 ff2039 FJ003b 

drop f7ms026a

rename f7003b age1 
rename f7ms010 ht1
rename f7ms026 wt1

rename f8003b age2
rename f8lf020 ht2
rename f8lf021 wt2

rename f9003b age3
rename f9ms010 ht3
rename f9ms026 wt3

rename fd003b age4
rename fdms010 ht4 
rename fdms026 wt4

rename fe003b age5
rename fems010 ht5
rename fems026 wt5

rename ff0011b age6
rename ff2000 ht6
rename ff2030 wt6

rename fg0011b age7
rename fg3100 ht7 
rename fg3130 wt7

rename fh0011b age8
rename fh3000 ht8
rename fh3010 wt8

rename FJ003a age9
rename FJMR020 ht9
rename FJMR022 wt9

rename FKAR0010 age10
rename FKMS1000 ht10
rename FKMS1030 wt10

foreach var in age1-wt10 {
recode `var' (-9999/-1 = .)
}

replace ht10 = ht10/10

replace age1 = age1/52
replace age2 = age2/52
replace age3 = age3/52
replace age4 = age4/52
replace age5 = age5/52
replace age6 = age6/52
replace age7 = age7/52
replace age8 = age8/52
replace age9 = age9/12
replace age10 = age10/12

tab FJMR040
tab FJMR040, nolab
replace wt9 = . if FJMR040 ==1
 
tab FKCO1011
tab FKCO1011, nolab
replace wt10 = . if FKCO1011 ==1

tab FKFH1071
tab FKFH1071, nolab 
replace wt10 = . if FKFH1071 ==1

drop FJMR040 FKCO1011 FKFH1071

order cidB3164 qlet order id

*drop age10 wt10 ht10

reshape long age wt ht, i(id) 

rename _j visitn

gen bmi = wt / (ht/100)^2

*drop if bmi ==. & wt ==. & ht ==.

bysort id: egen dum = count(bmi)

*drop if dum == 0 
drop dum 

sort id age 

reshape wide age wt ht bmi, i(id) j(visitn)

sum age*

order cidB3164 qlet order id in_core in_phase2 in_phase3 in_phase4 age1 age2 age3 age4 age5 age6 age7 age8 age9 age10 wt* ht* bmi*

sort cidB3164 order

save anthro, replace 

*select sample

use anthro.dta, clear

merge 1:1 cidB3164 order using covars.dta

drop _merge 

sort cidB3164

merge 1:1 cidB3164 order using outcomes.dta

drop _merge 

count 

*N 15,645

drop if dum == 0

*N 4,019 with at least one outcome
 
/*
egen nbmi =  rownonmiss(bmi1 bmi2 bmi3 bmi4 bmi5 bmi6 bmi7 bmi8 bmi9 bmi10) 

tab nbmi 

drop if nbmi < 2
*/

drop covars_miss 

egen ncovar =  rownonmiss(birthweight- breast) 

tab ncovar in_core 

drop if ncovar == 0 

*N 3,725 with at least one covar (those without any were not in core sample)

save sample.dta, replace

*Prepare for MPLUS

use sample.dta, clear 

keep id age1-age10 bmi1-bmi10 wt1-wt10 ht1-ht10

reshape long age bmi wt ht, i(id) j(visit)

drop if age ==. 
drop if age !=. & bmi ==. 

scatter bmi age 
drop if bmi > 55
drop if bmi < 10 & age > 17

reshape wide age bmi wt ht, i(id) j(visit)

order id age* bmi* wt* ht*

tabstat age1-age10, stat(p5 p50 p95)

reshape long age bmi wt ht, i(id) j(visit)

drop if age ==. 

recode age(7.365385/7.730769=1)(8.423077/9.057692=2)(9.538462/10.42308=3)(10.42308/11.07692=4)(11.51923/12.15385=5)		///
(12.53846/13.23077=6)(13.67308/14.25=7)(15.21154/16.07692=8)(17.33333/18.3333=9)(23.16667/25.83333=10)(else=.), gen(visit2)

drop if visit2==.

drop visit 
rename visit2 visit

tabstat age if visit ==1, stat(p50) 
gen dage = sqrt((7.5-age)^2) if visit ==1

tabstat age if visit ==2, stat(p50)  
replace dage = sqrt((8.615385-age)^2) if visit ==2

tabstat age if visit ==3, stat(p50)  
replace dage = sqrt((9.846154-age)^2) if visit ==3

tabstat age if visit ==4, stat(p50) 
replace dage = sqrt((10.63462-age)^2) if visit ==4

tabstat age if visit ==5, stat(p50) 
replace dage = sqrt((11.76923-age)^2) if visit ==5

tabstat age if visit ==6, stat(p50) 
replace dage = sqrt((12.86538-age)^2) if visit ==6

tabstat age if visit ==7, stat(p50) 
replace dage = sqrt((13.86538-age)^2) if visit ==7

tabstat age if visit ==8, stat(p50) 
replace dage = sqrt((15.44231-age)^2) if visit ==8

tabstat age if visit ==9, stat(p50) 
replace dage = sqrt((17.66667-age)^2) if visit ==9

tabstat age if visit ==10, stat(p50) 
replace dage = sqrt((24.41667-age)^2) if visit ==10

sort id visit dage
quietly by id visit:  gen dup = cond(_N==1,0,_n)

drop if dup ==2

drop dup dage

sort id age

bysort id: gen n = _N

tab n 

drop if n ==0
drop if n ==1

bysort id: gen first= 1  if _n == 1 
bysort id: gen last= 1  if _n == _N

bysort id: gen firstage = age if first ==1
by id: carryforward firstage, replace

by id: gen lastage = age if last ==1
bysort id (lastage): carryforward lastage, replace

gen agerange = lastage - firstage

sort id age 

drop first last 

reshape wide age bmi wt ht, i(id) j(visit)
 
order id age1-age9 bmi1-bmi9 wt1-wt9 ht1-ht9

tabstat age1 age2 age3 age4 age5 age6 age7 age8 age9 age10, stat(p50) 
sum age1 age2 age3 age4 age5 age6 age7 age8 age9 age10

gen cage1 = age1 - 7.5
gen cage2 = age2 - 8.6
gen cage3 = age3 - 9.8
gen cage4 = age4 - 10.6
gen cage5 = age5 - 11.8
gen cage6 = age6 - 12.9
gen cage7 = age7 - 13.9
gen cage8 = age8 - 15.4
gen cage9 = age9 - 17.7
gen cage10 = age10 - 24.4

recode _all (.=-9999)
sort id

foreach var of varlist id-lastage {
	label variable `var' " "
	}

labdtch _all

order id bmi1 bmi2 bmi3 bmi4 bmi5 bmi6 bmi7 bmi8 bmi9 bmi10	///
age1 age2 age3 age4 age5 age6 age7 age8 age9 age10 ///
cage1 cage2 cage3 cage4 cage5 cage6 cage7 cage8 cage9 cage10 ///
wt1 wt2 wt3 wt4 wt5 wt6 wt7 wt8 wt9 wt10 ///
ht1 ht2 ht3 ht4 ht5 ht6 ht7 ht8 ht9 ht10
 
sort id

save mplusexclusions.dta, replace

keep id bmi1-bmi10 cage1-cage10

sort id 

export excel using "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\mplusdata.xls", sheetreplace firstrow(variables) nolabel 
outsheet using "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\mplusdata.txt", nonames replace

save mplusdata.dta, replace

/*
export excel using "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\mplusdata2.xls", sheetreplace firstrow(variables) nolabel 
outsheet using "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\mplusdata2.txt", nonames replace

save mplusdata2.dta, replace
*/

*final sample selection 

use sample.dta, clear

drop age1-bmi10

merge 1:1 id using mplusexclusions.dta 

drop if _merge ==1

drop dum 
drop ncovar

foreach var in bmi1-ht10 {
recode `var' (-9999 = .)
}

drop _merge 

drop cage*
sort id 

save finalsample.dta, replace 

*3549 
