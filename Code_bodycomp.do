clear
clear mata
clear matrix
set mem 1000m
set more off
cd "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis 2"
set maxvar 10000

*Anthro 

use Johnson_9Dec2019.dta, clear

encode qlet, gen(order)
sort cidB3164 order 
gen id =_n

keep cidB3164 id f7003b - FKCO1011 FKMS1000 FKMS1030 FKFH1071 FKMS1040 FKAR0010  ///
FKDX1031 FKDX1032 f9dx126 f9dx127 fedx126 fedx127 fg3245 fg3246 fh2245 fh2246 FJDX126 FJDX127  ///
FKDX1021 FKDX1022 f9dx117 f9dx118 fedx117  fedx118 fg3236  fg3237 fh2236  fh2237 FJDX117 FJDX118 ///
FKDX1011 FKDX1012 f9dx108 f9dx109 fedx108 fedx109 fg3227 fg3228 fh2227 fh2228 FJDX108 FJDX109 kz021 ///
FKDX1000 FKDX1001 FKDX1002 f9dx134 f9dx135 f9dx136 fedx134 fedx135 fedx136 fg3253 fg3254 fg3255 fh2253	///
fh2254 fh2255 FJDX134 FJDX135 FJDX136 f9ms026 fems026 fg3130 fh3010	FJMR022 FKMS1030

renvars _all, lower

rename kz021 sex 
tab sex
recode sex 1=0 2=1
labdtch sex
label define lsex 0 male 1 female 
label values sex lsex

rename f9003b age1
rename f9ms010 ht1
rename f9ms026 wt1
rename f9dx108 arm_fat1
rename f9dx109 arm_lean1
rename f9dx117 leg_fat1
rename f9dx118 leg_lean1
rename f9dx126 trunk_fat1
rename f9dx127 trunk_lean1
rename f9dx135 fat1
rename f9dx136 lean1
rename f9dx134 bone1

rename fe003b age2
rename fems010 ht2
rename fems026 wt2
rename fedx108 arm_fat2
rename fedx109 arm_lean2
rename fedx117 leg_fat2
rename fedx118 leg_lean2
rename fedx126 trunk_fat2
rename fedx127 trunk_lean2
rename fedx135 fat2
rename fedx136 lean2
rename fedx134 bone2

rename fg0011b age3
rename fg3100 ht3
rename fg3130 wt3
rename fg3227 arm_fat3
rename fg3228 arm_lean3
rename fg3236 leg_fat3
rename fg3237 leg_lean3
rename fg3245 trunk_fat3
rename fg3246 trunk_lean3
rename fg3254 fat3
rename fg3255 lean3
rename fg3253 bone3

rename fh0011b age4
rename fh3000 ht4
rename fh3010 wt4
rename fh2227 arm_fat4
rename fh2228 arm_lean4
rename fh2236 leg_fat4
rename fh2237 leg_lean4
rename fh2245 trunk_fat4
rename fh2246 trunk_lean4
rename fh2254 fat4
rename fh2255 lean4
rename fh2253 bone4

rename fj003a age5
rename fjmr020 ht5
rename fjmr022 wt5
rename fjdx108 arm_fat5
rename fjdx109 arm_lean5
rename fjdx117 leg_fat5
rename fjdx118 leg_lean5
rename fjdx126 trunk_fat5
rename fjdx127 trunk_lean5
rename fjdx135 fat5
rename fjdx136 lean5
rename fjdx134 bone5

rename fkar0010 age6
rename fkms1000 ht6
rename fkms1030 wt6
rename fkdx1011 arm_fat6
rename fkdx1012 arm_lean6
rename fkdx1021 leg_fat6
rename fkdx1022 leg_lean6
rename fkdx1031 trunk_fat6
rename fkdx1032 trunk_lean6
rename fkdx1001 fat6
rename fkdx1002 lean6
rename fkdx1000 bone6

order cidb3164 id age* ht* wt* fat* lean* bone* arm* leg* trunk*

tab fjmr040
tab fjmr040, nolab
drop if fjmr040 ==1
 
tab fkco1011
tab fkco1011, nolab
drop if fkco1011 ==1

tab fkfh1071
tab fkfh1071, nolab 
drop if fkfh1071 ==1

drop f7003b - fkms1040

foreach var in age1-trunk_lean5 {
recode `var' (-9999/-1 = .)
}

replace ht6 = ht6/10

replace age1 = age1/52
replace age2 = age2/52
replace age3 = age3/52
replace age4 = age4/52
replace age5 = age5/12
replace age6 = age6/12

order cidb3164 id

reshape long age wt ht fat lean bone arm_fat arm_lean leg_fat leg_lean trunk_fat trunk_lean, i(id) 

rename _j visitn

sort id age 

*drop if visit ==6

merge m:1 id using six.dta 

drop if _merge ==1
drop if _merge ==2
drop cprob1 - _merge

sort id visit 
mdesc age- trunk_lean
mvpatterns age- trunk_lean

drop if age ==.
drop if ht ==.
drop if fat ==. 

foreach x in fat lean bone arm_fat arm_lean leg_fat leg_lean trunk_fat trunk_lean {
replace `x' = `x' / 1000
}

*replace ht = ht /100 

*gen periph_fat = arm_fat + leg_fat 
*gen periph_lean = arm_lean + leg_lean 
*drop arm_fat arm_lean leg_fat leg_lean

order cidb3164 id sex visitn age ht fat lean bone arm_fat arm_lean leg_fat leg_lean trunk_fat trunk_lean c

gen dum = fat + lean + bone
gen dif = dum - wt
sum dif 
count if dif > 1.619436*2
count if dif < -1.619436*2
drop if dif > 1.619436*2
drop if dif < -1.619436*2
drop dum dif

sort id age 

bysort id: gen n = _N

sort id age

tab n 

bysort id: gen first= 1  if _n == 1 
bysort id: gen last= 1  if _n == _N

bysort id: gen firstage = age if first ==1
by id: carryforward firstage, replace

by id: gen lastage = age if last ==1
bysort id (lastage): carryforward lastage, replace

gen agerange = lastage - firstage

egen pickone = tag(id)

gen dumage = age
replace dumage = 23 if age > 23 

egen zht = zanthro(ht,ha,UK), xvar(dumage) gender(sex) gencode(male=0, female=1) nocutoff 	

drop dumage 

sort id visit 

gen peri_fat = arm_fat + leg_fat 
gen peri_lean = arm_lean + leg_lean 

foreach x in fat trunk_fat peri_fat lean trunk_lean peri_lean	{
gen ln_`x' = ln(`x')
}

sort id age 

save bodycomp.dta, replace

*FAT modelling 

use bodycomp.dta, clear

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =1 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =2 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =3 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =4 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =5 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =6 if dum ==1
drop dum 

gen dum =1 if id ==.

gen cons =1

gen cage = age -10 

tab c, gen(class)

sum zht 
gen czht = zht - r(mean)
replace czht = 0 if dum ==1

global MLwiN_path "C:\Program Files\MLwiN v3.04\mlwin.exe"

mkspline s = cage, cubic nknots(4) displayknots

foreach x in class2 class3 class4 class5 class6 {
gen s1_`x' = s1*`x' 
gen s2_`x' = s2*`x' 
gen s3_`x' = s3*`x' 
}

gen s1_czht = czht*s1
gen s2_czht = czht*s2
gen s3_czht = czht*s3

sort id visit

matrix A = (1,1,1,1,1,1,1,1,1,1,0,0,0,0,1)

runmlwin ln_fat cons s1 s2 s3 			///
class2 s1_class2 s2_class2 s3_class2	///
class3 s1_class3 s2_class3 s3_class3	///
class4 s1_class4 s2_class4 s3_class4	///
class5 s1_class5 s2_class5 s3_class5	///
class6 s1_class6 s2_class6 s3_class6	///
czht s1_czht s2_czht s3_czht ,		/// 
level2(id: cons s1 s2 s3 czht, element(A))				///					
level1(visit: class1 class2 class3 class4 class5 class6, diagonal resid(r)) nopause maxiterations(1000)

scatter r0 age if c ==2
scatter r1 age if c ==3
scatter r2 age if c ==4
scatter r3 age if c ==5
scatter r4 age if c ==6
scatter r5 age if c ==1

replace ln_fat = . if r0 > 0.5 & c==2  
replace ln_fat = . if r0 < -0.5 & c==2  

replace ln_fat = . if r1 > 0.5 & c==3  
replace ln_fat = . if r1 < -0.5 & c==3  

replace ln_fat = . if r2 > 0.5 & c==4  
replace ln_fat = . if r2 < -0.5 & c==4  

replace ln_fat = . if r3 > 0.5 & c==5  
replace ln_fat = . if r3 < -0.5 & c==5  

replace ln_fat = . if r4 > 0.5 & c==6  
replace ln_fat = . if r4 < -0.5 & c==6  

replace ln_fat = . if r5 > 0.5 & c==1  
replace ln_fat = . if r5 < -0.5 & c==1  

drop r0-r5se

sort id age

matrix A = (1,1,1,1,1,1,1,1,1,1,0,0,0,0,1)

runmlwin ln_fat cons s1 s2 s3 			///
class2 s1_class2 s2_class2 s3_class2	///
class3 s1_class3 s2_class3 s3_class3	///
class4 s1_class4 s2_class4 s3_class4	///
class5 s1_class5 s2_class5 s3_class5	///
class6 s1_class6 s2_class6 s3_class6	///
czht s1_czht s2_czht s3_czht ,		/// 
level2(id: cons s1 s2 s3 czht, element(A))				///					
level1(visit: class1 class2 class3 class4 class5 class6, diagonal resid(r)) nopause maxiterations(1000)

predict yfat 
replace yfat = exp(yfat)

predict sefat, stdp
replace sefat = exp(sefat)

generate fat5 = yfat - invnormal(0.975)*sefat
generate fat95 = yfat + invnormal(0.975)*sefat

twoway(scatter fat age if c==1)(line yfat age if dum ==1 & c==1, sort)(line fat5 age if dum ==1 & c==1, sort)(line fat95 age if dum ==1 & c==1, sort)
twoway(scatter fat age if c==2)(line yfat age if dum ==1 & c==2, sort)(line fat5 age if dum ==1 & c==2, sort)(line fat95 age if dum ==1 & c==2, sort)
twoway(scatter fat age if c==3)(line yfat age if dum ==1 & c==3, sort)(line fat5 age if dum ==1 & c==3, sort)(line fat95 age if dum ==1 & c==3, sort)
twoway(scatter fat age if c==4)(line yfat age if dum ==1 & c==4, sort)(line fat5 age if dum ==1 & c==4, sort)(line fat95 age if dum ==1 & c==4, sort)
twoway(scatter fat age if c==5)(line yfat age if dum ==1 & c==5, sort)(line fat5 age if dum ==1 & c==5, sort)(line fat95 age if dum ==1 & c==5, sort)
twoway(scatter fat age if c==6)(line yfat age if dum ==1 & c==6, sort)(line fat5 age if dum ==1 & c==6, sort)(line fat95 age if dum ==1 & c==6, sort)

twoway	///
(line yfat age if c==1 & dum==1, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line yfat age if c==2 & dum==1, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line yfat age if c==3 & dum==1, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line yfat age if c==4 & dum==1, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line yfat age if c==5 & dum==1, sort legend(label(5 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
(line yfat age if c==6 & dum==1, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, legend(order(1 2 3 4 5 6))

drop if id != .
keep age c yfat  

sort c age
gen id = _n if c==1
replace id = _n - 151 if c==2
replace id = _n - 151 - 151 if c==3
replace id = _n - 151 - 151 - 151 if c==4
replace id = _n - 151 - 151 - 151 - 151 if c==5
replace id = _n - 151 - 151 - 151 - 151 - 151 if c==6

reshape wide age yfat, i(id) j(c)

gen yfat1v5 = yfat1 - yfat5
gen yfat2v5 = yfat2 - yfat5
gen yfat3v5 = yfat3 - yfat5
gen yfat4v5 = yfat4 - yfat5
gen yfat5v5 = yfat5 - yfat5
gen yfat6v5 = yfat6 - yfat5

twoway	///
(line yfat1v5 age1, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line yfat2v5 age1, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line yfat3v5 age1, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line yfat4v5 age1, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line yfat5v5 age1, sort legend(label(5 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
(line yfat6v5 age1, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, legend(order(1 2 3 4 5 6))

save fat.dta, replace

*TRUNKFAT modelling 

use bodycomp.dta, clear

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =1 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =2 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =3 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =4 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =5 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =6 if dum ==1
drop dum 

gen dum =1 if id ==.

gen cons =1

gen cage = age -10 

tab c, gen(class)

sum zht 
gen czht = zht - r(mean)
replace czht = 0 if dum ==1

global MLwiN_path "C:\Program Files\MLwiN v3.04\mlwin.exe"

mkspline s = cage, cubic nknots(4) displayknots

foreach x in class2 class3 class4 class5 class6 {
gen s1_`x' = s1*`x' 
gen s2_`x' = s2*`x' 
gen s3_`x' = s3*`x' 
}

gen s1_czht = czht*s1
gen s2_czht = czht*s2
gen s3_czht = czht*s3

sort id visit

matrix A = (1,1,1,1,1,1,1,1,1,1,0,0,0,0,1)

runmlwin ln_trunk_fat cons s1 s2 s3 			///
class2 s1_class2 s2_class2 s3_class2	///
class3 s1_class3 s2_class3 s3_class3	///
class4 s1_class4 s2_class4 s3_class4	///
class5 s1_class5 s2_class5 s3_class5	///
class6 s1_class6 s2_class6 s3_class6	///
czht s1_czht s2_czht s3_czht ,		/// 
level2(id: cons s1 s2 s3 czht, element(A))				///					
level1(visit: class1 class2 class3 class4 class5 class6, diagonal resid(r)) nopause maxiterations(1000)

scatter r0 age if c ==2
scatter r1 age if c ==3
scatter r2 age if c ==4
scatter r3 age if c ==5
scatter r4 age if c ==6
scatter r5 age if c ==1

replace ln_trunk_fat = . if r0 > 0.5 & c==2  
replace ln_trunk_fat = . if r0 < -0.5 & c==2  

replace ln_trunk_fat = . if r1 > 0.5 & c==3  
replace ln_trunk_fat = . if r1 < -0.5 & c==3  

replace ln_trunk_fat = . if r2 > 0.5 & c==4  
replace ln_trunk_fat = . if r2 < -0.5 & c==4  

replace ln_trunk_fat = . if r3 > 0.5 & c==5  
replace ln_trunk_fat = . if r3 < -0.5 & c==5  

replace ln_trunk_fat = . if r4 > 0.5 & c==6  
replace ln_trunk_fat = . if r4 < -0.5 & c==6  

replace ln_trunk_fat = . if r5 > 0.5 & c==1  
replace ln_trunk_fat = . if r5 < -0.5 & c==1  

drop r0-r5se

sort id age

matrix A = (1,1,1,1,1,1,1,1,1,1,0,0,0,0,1)

runmlwin ln_trunk_fat cons s1 s2 s3 			///
class2 s1_class2 s2_class2 s3_class2	///
class3 s1_class3 s2_class3 s3_class3	///
class4 s1_class4 s2_class4 s3_class4	///
class5 s1_class5 s2_class5 s3_class5	///
class6 s1_class6 s2_class6 s3_class6	///
czht s1_czht s2_czht s3_czht ,		/// 
level2(id: cons s1 s2 s3 czht, element(A))				///					
level1(visit: class1 class2 class3 class4 class5 class6, diagonal resid(r)) nopause maxiterations(1000)

predict ytrunk_fat 
replace ytrunk_fat = exp(ytrunk_fat)

predict setrunk_fat, stdp
replace setrunk_fat = exp(setrunk_fat)

generate trunk_fat5 = ytrunk_fat - invnormal(0.975)*setrunk_fat
generate trunk_fat95 = ytrunk_fat + invnormal(0.975)*setrunk_fat

twoway(scatter trunk_fat age if c==1)(line ytrunk_fat age if dum ==1 & c==1, sort)(line trunk_fat5 age if dum ==1 & c==1, sort)(line trunk_fat95 age if dum ==1 & c==1, sort)
twoway(scatter trunk_fat age if c==2)(line ytrunk_fat age if dum ==1 & c==2, sort)(line trunk_fat5 age if dum ==1 & c==2, sort)(line trunk_fat95 age if dum ==1 & c==2, sort)
twoway(scatter trunk_fat age if c==3)(line ytrunk_fat age if dum ==1 & c==3, sort)(line trunk_fat5 age if dum ==1 & c==3, sort)(line trunk_fat95 age if dum ==1 & c==3, sort)
twoway(scatter trunk_fat age if c==4)(line ytrunk_fat age if dum ==1 & c==4, sort)(line trunk_fat5 age if dum ==1 & c==4, sort)(line trunk_fat95 age if dum ==1 & c==4, sort)
twoway(scatter trunk_fat age if c==5)(line ytrunk_fat age if dum ==1 & c==5, sort)(line trunk_fat5 age if dum ==1 & c==5, sort)(line trunk_fat95 age if dum ==1 & c==5, sort)
twoway(scatter trunk_fat age if c==6)(line ytrunk_fat age if dum ==1 & c==6, sort)(line trunk_fat5 age if dum ==1 & c==6, sort)(line trunk_fat95 age if dum ==1 & c==6, sort)

twoway	///
(line ytrunk_fat age if c==1 & dum==1, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line ytrunk_fat age if c==2 & dum==1, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line ytrunk_fat age if c==3 & dum==1, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line ytrunk_fat age if c==4 & dum==1, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line ytrunk_fat age if c==5 & dum==1, sort legend(label(5 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
(line ytrunk_fat age if c==6 & dum==1, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, legend(order(1 2 3 4 5 6))

drop if id != .
keep age c ytrunk_fat  

sort c age
gen id = _n if c==1
replace id = _n - 151 if c==2
replace id = _n - 151 - 151 if c==3
replace id = _n - 151 - 151 - 151 if c==4
replace id = _n - 151 - 151 - 151 - 151 if c==5
replace id = _n - 151 - 151 - 151 - 151 - 151 if c==6

reshape wide age ytrunk_fat, i(id) j(c)

gen ytrunk_fat1v5 = ytrunk_fat1 - ytrunk_fat5
gen ytrunk_fat2v5 = ytrunk_fat2 - ytrunk_fat5
gen ytrunk_fat3v5 = ytrunk_fat3 - ytrunk_fat5
gen ytrunk_fat4v5 = ytrunk_fat4 - ytrunk_fat5
gen ytrunk_fat5v5 = ytrunk_fat5 - ytrunk_fat5
gen ytrunk_fat6v5 = ytrunk_fat6 - ytrunk_fat5

twoway	///
(line ytrunk_fat1v5 age1, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line ytrunk_fat2v5 age1, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line ytrunk_fat3v5 age1, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line ytrunk_fat4v5 age1, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line ytrunk_fat5v5 age1, sort legend(label(5 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
(line ytrunk_fat6v5 age1, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, legend(order(1 2 3 4 5 6))

save trunk_fat.dta, replace

*PERIPHERAL FAT modelling 

use bodycomp.dta, clear

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =1 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =2 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =3 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =4 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =5 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =6 if dum ==1
drop dum 

gen dum =1 if id ==.

gen cons =1

gen cage = age -10 

tab c, gen(class)

sum zht 
gen czht = zht - r(mean)
replace czht = 0 if dum ==1

global MLwiN_path "C:\Program Files\MLwiN v3.04\mlwin.exe"

mkspline s = cage, cubic nknots(4) displayknots

foreach x in class2 class3 class4 class5 class6 {
gen s1_`x' = s1*`x' 
gen s2_`x' = s2*`x' 
gen s3_`x' = s3*`x' 
}

gen s1_czht = czht*s1
gen s2_czht = czht*s2
gen s3_czht = czht*s3

sort id visit

matrix A = (1,1,1,1,1,1,1,1,1,1,0,0,0,0,1)

runmlwin ln_peri_fat cons s1 s2 s3 			///
class2 s1_class2 s2_class2 s3_class2	///
class3 s1_class3 s2_class3 s3_class3	///
class4 s1_class4 s2_class4 s3_class4	///
class5 s1_class5 s2_class5 s3_class5	///
class6 s1_class6 s2_class6 s3_class6	///
czht s1_czht s2_czht s3_czht ,		/// 
level2(id: cons s1 s2 s3 czht, element(A))				///					
level1(visit: class1 class2 class3 class4 class5 class6, diagonal resid(r)) nopause maxiterations(1000)

scatter r0 age if c ==2
scatter r1 age if c ==3
scatter r2 age if c ==4
scatter r3 age if c ==5
scatter r4 age if c ==6
scatter r5 age if c ==1

replace ln_peri_fat = . if r0 > 0.5 & c==2  
replace ln_peri_fat = . if r0 < -0.5 & c==2  

replace ln_peri_fat = . if r1 > 0.5 & c==3  
replace ln_peri_fat = . if r1 < -0.5 & c==3  

replace ln_peri_fat = . if r2 > 0.5 & c==4  
replace ln_peri_fat = . if r2 < -0.5 & c==4  

replace ln_peri_fat = . if r3 > 0.5 & c==5  
replace ln_peri_fat = . if r3 < -0.5 & c==5  

replace ln_peri_fat = . if r4 > 0.5 & c==6  
replace ln_peri_fat = . if r4 < -0.5 & c==6  

replace ln_peri_fat = . if r5 > 0.5 & c==1  
replace ln_peri_fat = . if r5 < -0.5 & c==1  

drop r0-r5se

sort id age

matrix A = (1,1,1,1,1,1,1,1,1,1,0,0,0,0,1)

runmlwin ln_peri_fat cons s1 s2 s3 			///
class2 s1_class2 s2_class2 s3_class2	///
class3 s1_class3 s2_class3 s3_class3	///
class4 s1_class4 s2_class4 s3_class4	///
class5 s1_class5 s2_class5 s3_class5	///
class6 s1_class6 s2_class6 s3_class6	///
czht s1_czht s2_czht s3_czht ,		/// 
level2(id: cons s1 s2 s3 czht, element(A))				///					
level1(visit: class1 class2 class3 class4 class5 class6, diagonal resid(r)) nopause maxiterations(1000)

predict yperi_fat 
replace yperi_fat = exp(yperi_fat)

predict seperi_fat, stdp
replace seperi_fat = exp(seperi_fat)

generate peri_fat5 = yperi_fat - invnormal(0.975)*seperi_fat
generate peri_fat95 = yperi_fat + invnormal(0.975)*seperi_fat

twoway(scatter peri_fat age if c==1)(line yperi_fat age if dum ==1 & c==1, sort)(line peri_fat5 age if dum ==1 & c==1, sort)(line peri_fat95 age if dum ==1 & c==1, sort)
twoway(scatter peri_fat age if c==2)(line yperi_fat age if dum ==1 & c==2, sort)(line peri_fat5 age if dum ==1 & c==2, sort)(line peri_fat95 age if dum ==1 & c==2, sort)
twoway(scatter peri_fat age if c==3)(line yperi_fat age if dum ==1 & c==3, sort)(line peri_fat5 age if dum ==1 & c==3, sort)(line peri_fat95 age if dum ==1 & c==3, sort)
twoway(scatter peri_fat age if c==4)(line yperi_fat age if dum ==1 & c==4, sort)(line peri_fat5 age if dum ==1 & c==4, sort)(line peri_fat95 age if dum ==1 & c==4, sort)
twoway(scatter peri_fat age if c==5)(line yperi_fat age if dum ==1 & c==5, sort)(line peri_fat5 age if dum ==1 & c==5, sort)(line peri_fat95 age if dum ==1 & c==5, sort)
twoway(scatter peri_fat age if c==6)(line yperi_fat age if dum ==1 & c==6, sort)(line peri_fat5 age if dum ==1 & c==6, sort)(line peri_fat95 age if dum ==1 & c==6, sort)

twoway	///
(line yperi_fat age if c==1 & dum==1, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line yperi_fat age if c==2 & dum==1, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line yperi_fat age if c==3 & dum==1, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line yperi_fat age if c==4 & dum==1, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line yperi_fat age if c==5 & dum==1, sort legend(label(5 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
(line yperi_fat age if c==6 & dum==1, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, legend(order(1 2 3 4 5 6))

drop if id != .
keep age c yperi_fat  

sort c age
gen id = _n if c==1
replace id = _n - 151 if c==2
replace id = _n - 151 - 151 if c==3
replace id = _n - 151 - 151 - 151 if c==4
replace id = _n - 151 - 151 - 151 - 151 if c==5
replace id = _n - 151 - 151 - 151 - 151 - 151 if c==6

reshape wide age yperi_fat, i(id) j(c)

gen yperi_fat1v5 = yperi_fat1 - yperi_fat5
gen yperi_fat2v5 = yperi_fat2 - yperi_fat5
gen yperi_fat3v5 = yperi_fat3 - yperi_fat5
gen yperi_fat4v5 = yperi_fat4 - yperi_fat5
gen yperi_fat5v5 = yperi_fat5 - yperi_fat5
gen yperi_fat6v5 = yperi_fat6 - yperi_fat5

twoway	///
(line yperi_fat1v5 age1, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line yperi_fat2v5 age1, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line yperi_fat3v5 age1, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line yperi_fat4v5 age1, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line yperi_fat5v5 age1, sort legend(label(5 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
(line yperi_fat6v5 age1, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, legend(order(1 2 3 4 5 6))

save peri_fat.dta, replace

*LEAN modelling 

use bodycomp.dta, clear

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =1 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =2 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =3 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =4 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =5 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =6 if dum ==1
drop dum 

gen dum =1 if id ==.

gen cons =1

gen cage = age -10 

tab c, gen(class)

sum zht 
gen czht = zht - r(mean)
replace czht = 0 if dum ==1

global MLwiN_path "C:\Program Files\MLwiN v3.04\mlwin.exe"

mkspline s = cage, cubic nknots(4) displayknots

foreach x in class2 class3 class4 class5 class6 {
gen s1_`x' = s1*`x' 
gen s2_`x' = s2*`x' 
gen s3_`x' = s3*`x' 
}

gen s1_czht = czht*s1
gen s2_czht = czht*s2
gen s3_czht = czht*s3

sort id visit

matrix A = (1,1,1,0,0,1)

runmlwin ln_lean cons s1 s2 s3 			///
class2 s1_class2 s2_class2 s3_class2	///
class3 s1_class3 s2_class3 s3_class3	///
class4 s1_class4 s2_class4 s3_class4	///
class5 s1_class5 s2_class5 s3_class5	///
class6 s1_class6 s2_class6 s3_class6	///
czht s1_czht s2_czht s3_czht ,		/// 
level2(id: cons s1 czht, element(A))				///					
level1(visit: class1 class2 class3 class4 class5 class6, diagonal resid(r)) nopause maxiterations(1000)

scatter r0 age if c ==2
scatter r1 age if c ==3
scatter r2 age if c ==4
scatter r3 age if c ==5
scatter r4 age if c ==6
scatter r5 age if c ==1

replace ln_lean  = . if r0 > 0.2 & c==2  
replace ln_lean  = . if r0 < -0.2 & c==2  

replace ln_lean  = . if r1 > 0.2 & c==3  
replace ln_lean  = . if r1 < -0.2 & c==3  

replace ln_lean  = . if r2 > 0.2 & c==4  
replace ln_lean  = . if r2 < -0.2 & c==4  

replace ln_lean  = . if r3 > 0.2 & c==5  
replace ln_lean  = . if r3 < -0.2 & c==5  

replace ln_lean  = . if r4 > 0.2 & c==6  
replace ln_lean  = . if r4 < -0.2 & c==6  

replace ln_lean  = . if r5 > 0.2 & c==1  
replace ln_lean  = . if r5 < -0.2 & c==1  

drop r0-r5se

sort id age

matrix A = (1,1,1,0,0,1)

runmlwin ln_lean cons s1 s2 s3 			///
class2 s1_class2 s2_class2 s3_class2	///
class3 s1_class3 s2_class3 s3_class3	///
class4 s1_class4 s2_class4 s3_class4	///
class5 s1_class5 s2_class5 s3_class5	///
class6 s1_class6 s2_class6 s3_class6	///
czht s1_czht s2_czht s3_czht ,		/// 
level2(id: cons s1 czht, element(A))				///					
level1(visit: class1 class2 class3 class4 class5 class6, diagonal resid(r)) nopause maxiterations(1000)

predict ylean 
replace ylean = exp(ylean)

predict selean, stdp
replace selean = exp(selean)

generate lean5 = ylean - invnormal(0.975)*selean
generate lean95 = ylean + invnormal(0.975)*selean

twoway(scatter lean age if c==1)(line ylean age if dum ==1 & c==1, sort)(line lean5 age if dum ==1 & c==1, sort)(line lean95 age if dum ==1 & c==1, sort)
twoway(scatter lean age if c==2)(line ylean age if dum ==1 & c==2, sort)(line lean5 age if dum ==1 & c==2, sort)(line lean95 age if dum ==1 & c==2, sort)
twoway(scatter lean age if c==3)(line ylean age if dum ==1 & c==3, sort)(line lean5 age if dum ==1 & c==3, sort)(line lean95 age if dum ==1 & c==3, sort)
twoway(scatter lean age if c==4)(line ylean age if dum ==1 & c==4, sort)(line lean5 age if dum ==1 & c==4, sort)(line lean95 age if dum ==1 & c==4, sort)
twoway(scatter lean age if c==5)(line ylean age if dum ==1 & c==5, sort)(line lean5 age if dum ==1 & c==5, sort)(line lean95 age if dum ==1 & c==5, sort)
twoway(scatter lean age if c==6)(line ylean age if dum ==1 & c==6, sort)(line lean5 age if dum ==1 & c==6, sort)(line lean95 age if dum ==1 & c==6, sort)

twoway	///
(line ylean age if c==1 & dum==1, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line ylean age if c==2 & dum==1, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line ylean age if c==3 & dum==1, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line ylean age if c==4 & dum==1, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line ylean age if c==5 & dum==1, sort legend(label(5 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
(line ylean age if c==6 & dum==1, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, legend(order(1 2 3 4 5 6)) 

drop if id != .
keep age c ylean  

sort c age
gen id = _n if c==1
replace id = _n - 151 if c==2
replace id = _n - 151 - 151 if c==3
replace id = _n - 151 - 151 - 151 if c==4
replace id = _n - 151 - 151 - 151 - 151 if c==5
replace id = _n - 151 - 151 - 151 - 151 - 151 if c==6

reshape wide age ylean, i(id) j(c)

gen ylean1v5 = ylean1 - ylean5
gen ylean2v5 = ylean2 - ylean5
gen ylean3v5 = ylean3 - ylean5
gen ylean4v5 = ylean4 - ylean5
gen ylean5v5 = ylean5 - ylean5
gen ylean6v5 = ylean6 - ylean5

twoway	///
(line ylean1v5 age1, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line ylean2v5 age1, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line ylean3v5 age1, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line ylean4v5 age1, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line ylean5v5 age1, sort legend(label(5 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
(line ylean6v5 age1, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, legend(order(1 2 3 4 5 6))

save lean.dta, replace

*TURNK LEAN modelling 

use bodycomp.dta, clear

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =1 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =2 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =3 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =4 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =5 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =6 if dum ==1
drop dum 

gen dum =1 if id ==.

gen cons =1

gen cage = age -10 

tab c, gen(class)

sum zht 
gen czht = zht - r(mean)
replace czht = 0 if dum ==1

global MLwiN_path "C:\Program Files\MLwiN v3.04\mlwin.exe"

mkspline s = cage, cubic nknots(4) displayknots

foreach x in class2 class3 class4 class5 class6 {
gen s1_`x' = s1*`x' 
gen s2_`x' = s2*`x' 
gen s3_`x' = s3*`x' 
}

gen s1_czht = czht*s1
gen s2_czht = czht*s2
gen s3_czht = czht*s3

sort id visit

matrix A = (1,1,1,0,0,1)

runmlwin ln_trunk_lean cons s1 s2 s3 			///
class2 s1_class2 s2_class2 s3_class2	///
class3 s1_class3 s2_class3 s3_class3	///
class4 s1_class4 s2_class4 s3_class4	///
class5 s1_class5 s2_class5 s3_class5	///
class6 s1_class6 s2_class6 s3_class6	///
czht s1_czht s2_czht s3_czht ,		/// 
level2(id: cons s1 czht, element(A))				///					
level1(visit: class1 class2 class3 class4 class5 class6, diagonal resid(r)) nopause maxiterations(1000)

scatter r0 age if c ==2
scatter r1 age if c ==3
scatter r2 age if c ==4
scatter r3 age if c ==5
scatter r4 age if c ==6
scatter r5 age if c ==1

replace ln_trunk_lean  = . if r0 > 0.2 & c==2  
replace ln_trunk_lean  = . if r0 < -0.2 & c==2  

replace ln_trunk_lean  = . if r1 > 0.2 & c==3  
replace ln_trunk_lean  = . if r1 < -0.2 & c==3  

replace ln_trunk_lean  = . if r2 > 0.2 & c==4  
replace ln_trunk_lean  = . if r2 < -0.2 & c==4  

replace ln_trunk_lean  = . if r3 > 0.2 & c==5  
replace ln_trunk_lean  = . if r3 < -0.2 & c==5  

replace ln_trunk_lean  = . if r4 > 0.2 & c==6  
replace ln_trunk_lean  = . if r4 < -0.2 & c==6  

replace ln_trunk_lean  = . if r5 > 0.2 & c==1  
replace ln_trunk_lean  = . if r5 < -0.2 & c==1  

drop r0-r5se

sort id age

matrix A = (1,1,1,0,0,1)

runmlwin ln_trunk_lean cons s1 s2 s3 			///
class2 s1_class2 s2_class2 s3_class2	///
class3 s1_class3 s2_class3 s3_class3	///
class4 s1_class4 s2_class4 s3_class4	///
class5 s1_class5 s2_class5 s3_class5	///
class6 s1_class6 s2_class6 s3_class6	///
czht s1_czht s2_czht s3_czht ,		/// 
level2(id: cons s1 czht, element(A))				///					
level1(visit: class1 class2 class3 class4 class5 class6, diagonal resid(r)) nopause maxiterations(1000)

predict ytrunk_lean 
replace ytrunk_lean = exp(ytrunk_lean)

predict setrunk_lean, stdp
replace setrunk_lean = exp(setrunk_lean)

generate trunk_lean5 = ytrunk_lean - invnormal(0.975)*setrunk_lean
generate trunk_lean95 = ytrunk_lean + invnormal(0.975)*setrunk_lean

twoway(scatter trunk_lean age if c==1)(line ytrunk_lean age if dum ==1 & c==1, sort)(line trunk_lean5 age if dum ==1 & c==1, sort)(line trunk_lean95 age if dum ==1 & c==1, sort)
twoway(scatter trunk_lean age if c==2)(line ytrunk_lean age if dum ==1 & c==2, sort)(line trunk_lean5 age if dum ==1 & c==2, sort)(line trunk_lean95 age if dum ==1 & c==2, sort)
twoway(scatter trunk_lean age if c==3)(line ytrunk_lean age if dum ==1 & c==3, sort)(line trunk_lean5 age if dum ==1 & c==3, sort)(line trunk_lean95 age if dum ==1 & c==3, sort)
twoway(scatter trunk_lean age if c==4)(line ytrunk_lean age if dum ==1 & c==4, sort)(line trunk_lean5 age if dum ==1 & c==4, sort)(line trunk_lean95 age if dum ==1 & c==4, sort)
twoway(scatter trunk_lean age if c==5)(line ytrunk_lean age if dum ==1 & c==5, sort)(line trunk_lean5 age if dum ==1 & c==5, sort)(line trunk_lean95 age if dum ==1 & c==5, sort)
twoway(scatter trunk_lean age if c==6)(line ytrunk_lean age if dum ==1 & c==6, sort)(line trunk_lean5 age if dum ==1 & c==6, sort)(line trunk_lean95 age if dum ==1 & c==6, sort)

twoway	///
(line ytrunk_lean age if c==1 & dum==1, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line ytrunk_lean age if c==2 & dum==1, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line ytrunk_lean age if c==3 & dum==1, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line ytrunk_lean age if c==4 & dum==1, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line ytrunk_lean age if c==5 & dum==1, sort legend(label(5 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
(line ytrunk_lean age if c==6 & dum==1, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, legend(order(1 2 3 4 5 6)) 

drop if id != .
keep age c ytrunk_lean  

sort c age
gen id = _n if c==1
replace id = _n - 151 if c==2
replace id = _n - 151 - 151 if c==3
replace id = _n - 151 - 151 - 151 if c==4
replace id = _n - 151 - 151 - 151 - 151 if c==5
replace id = _n - 151 - 151 - 151 - 151 - 151 if c==6

reshape wide age ytrunk_lean, i(id) j(c)

gen ytrunk_lean1v5 = ytrunk_lean1 - ytrunk_lean5
gen ytrunk_lean2v5 = ytrunk_lean2 - ytrunk_lean5
gen ytrunk_lean3v5 = ytrunk_lean3 - ytrunk_lean5
gen ytrunk_lean4v5 = ytrunk_lean4 - ytrunk_lean5
gen ytrunk_lean5v5 = ytrunk_lean5 - ytrunk_lean5
gen ytrunk_lean6v5 = ytrunk_lean6 - ytrunk_lean5

twoway	///
(line ytrunk_lean1v5 age1, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line ytrunk_lean2v5 age1, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line ytrunk_lean3v5 age1, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line ytrunk_lean4v5 age1, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line ytrunk_lean5v5 age1, sort legend(label(5 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
(line ytrunk_lean6v5 age1, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, legend(order(1 2 3 4 5 6))

save trunklean.dta, replace

*PERI LEAN modelling 

use bodycomp.dta, clear

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =1 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =2 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =3 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =4 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =5 if dum ==1
drop dum 

count 
set obs `=_N + 151'
gen dum =1 if age ==.
sort dum
replace age = 9.5 + ((_n-1)/10) if dum ==1 
replace c =6 if dum ==1
drop dum 

gen dum =1 if id ==.

gen cons =1

gen cage = age -10 

tab c, gen(class)

sum zht 
gen czht = zht - r(mean)
replace czht = 0 if dum ==1

global MLwiN_path "C:\Program Files\MLwiN v3.04\mlwin.exe"

mkspline s = cage, cubic nknots(4) displayknots

foreach x in class2 class3 class4 class5 class6 {
gen s1_`x' = s1*`x' 
gen s2_`x' = s2*`x' 
gen s3_`x' = s3*`x' 
}

gen s1_czht = czht*s1
gen s2_czht = czht*s2
gen s3_czht = czht*s3

sort id visit

matrix A = (1,1,1,0,0,1)

runmlwin ln_peri_lean cons s1 s2 s3 			///
class2 s1_class2 s2_class2 s3_class2	///
class3 s1_class3 s2_class3 s3_class3	///
class4 s1_class4 s2_class4 s3_class4	///
class5 s1_class5 s2_class5 s3_class5	///
class6 s1_class6 s2_class6 s3_class6	///
czht s1_czht s2_czht s3_czht ,		/// 
level2(id: cons s1 czht, element(A))				///					
level1(visit: class1 class2 class3 class4 class5 class6, diagonal resid(r)) nopause maxiterations(1000)

scatter r0 age if c ==2
scatter r1 age if c ==3
scatter r2 age if c ==4
scatter r3 age if c ==5
scatter r4 age if c ==6
scatter r5 age if c ==1

replace ln_peri_lean  = . if r0 > 0.2 & c==2  
replace ln_peri_lean  = . if r0 < -0.2 & c==2  

replace ln_peri_lean  = . if r1 > 0.2 & c==3  
replace ln_peri_lean  = . if r1 < -0.2 & c==3  

replace ln_peri_lean  = . if r2 > 0.2 & c==4  
replace ln_peri_lean  = . if r2 < -0.2 & c==4  

replace ln_peri_lean  = . if r3 > 0.2 & c==5  
replace ln_peri_lean  = . if r3 < -0.2 & c==5  

replace ln_peri_lean  = . if r4 > 0.2 & c==6  
replace ln_peri_lean  = . if r4 < -0.2 & c==6  

replace ln_peri_lean  = . if r5 > 0.2 & c==1  
replace ln_peri_lean  = . if r5 < -0.2 & c==1  

drop r0-r5se

sort id age

matrix A = (1,1,1,0,0,1)

runmlwin ln_peri_lean cons s1 s2 s3 			///
class2 s1_class2 s2_class2 s3_class2	///
class3 s1_class3 s2_class3 s3_class3	///
class4 s1_class4 s2_class4 s3_class4	///
class5 s1_class5 s2_class5 s3_class5	///
class6 s1_class6 s2_class6 s3_class6	///
czht s1_czht s2_czht s3_czht ,		/// 
level2(id: cons s1 czht, element(A))				///					
level1(visit: class1 class2 class3 class4 class5 class6, diagonal resid(r)) nopause maxiterations(1000)

predict yperi_lean 
replace yperi_lean = exp(yperi_lean)

predict seperi_lean, stdp
replace seperi_lean = exp(seperi_lean)

generate peri_lean5 = yperi_lean - invnormal(0.975)*seperi_lean
generate peri_lean95 = yperi_lean + invnormal(0.975)*seperi_lean

twoway(scatter peri_lean age if c==1)(line yperi_lean age if dum ==1 & c==1, sort)(line peri_lean5 age if dum ==1 & c==1, sort)(line peri_lean95 age if dum ==1 & c==1, sort)
twoway(scatter peri_lean age if c==2)(line yperi_lean age if dum ==1 & c==2, sort)(line peri_lean5 age if dum ==1 & c==2, sort)(line peri_lean95 age if dum ==1 & c==2, sort)
twoway(scatter peri_lean age if c==3)(line yperi_lean age if dum ==1 & c==3, sort)(line peri_lean5 age if dum ==1 & c==3, sort)(line peri_lean95 age if dum ==1 & c==3, sort)
twoway(scatter peri_lean age if c==4)(line yperi_lean age if dum ==1 & c==4, sort)(line peri_lean5 age if dum ==1 & c==4, sort)(line peri_lean95 age if dum ==1 & c==4, sort)
twoway(scatter peri_lean age if c==5)(line yperi_lean age if dum ==1 & c==5, sort)(line peri_lean5 age if dum ==1 & c==5, sort)(line peri_lean95 age if dum ==1 & c==5, sort)
twoway(scatter peri_lean age if c==6)(line yperi_lean age if dum ==1 & c==6, sort)(line peri_lean5 age if dum ==1 & c==6, sort)(line peri_lean95 age if dum ==1 & c==6, sort)

twoway	///
(line yperi_lean age if c==1 & dum==1, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line yperi_lean age if c==2 & dum==1, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line yperi_lean age if c==3 & dum==1, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line yperi_lean age if c==4 & dum==1, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line yperi_lean age if c==5 & dum==1, sort legend(label(5 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
(line yperi_lean age if c==6 & dum==1, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, legend(order(1 2 3 4 5 6)) 

drop if id != .
keep age c yperi_lean  

sort c age
gen id = _n if c==1
replace id = _n - 151 if c==2
replace id = _n - 151 - 151 if c==3
replace id = _n - 151 - 151 - 151 if c==4
replace id = _n - 151 - 151 - 151 - 151 if c==5
replace id = _n - 151 - 151 - 151 - 151 - 151 if c==6

reshape wide age yperi_lean, i(id) j(c)

gen yperi_lean1v5 = yperi_lean1 - yperi_lean5
gen yperi_lean2v5 = yperi_lean2 - yperi_lean5
gen yperi_lean3v5 = yperi_lean3 - yperi_lean5
gen yperi_lean4v5 = yperi_lean4 - yperi_lean5
gen yperi_lean5v5 = yperi_lean5 - yperi_lean5
gen yperi_lean6v5 = yperi_lean6 - yperi_lean5

twoway	///
(line yperi_lean1v5 age1, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line yperi_lean2v5 age1, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line yperi_lean3v5 age1, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line yperi_lean4v5 age1, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line yperi_lean5v5 age1, sort legend(label(5 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
(line yperi_lean6v5 age1, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, legend(order(1 2 3 4 5 6))

save perilean.dta, replace

*final figures

use fat.dta, clear
merge 1:1 id using trunk_fat.dta
drop _merge
merge 1:1 id using peri_fat.dta
drop _merge
merge 1:1 id using lean.dta
drop _merge
merge 1:1 id using trunklean.dta
drop _merge
merge 1:1 id using perilean.dta
drop _merge
rename age1 age 
drop age2 age3 age4 age5 age6 

count 
set obs `=_N + 1'
replace age = 9 if age ==. 
replace yfat5v5 =0 if yfat5v5 ==. 
replace ytrunk_fat5v5 =0 if ytrunk_fat5v5 ==. 
replace yperi_fat5v5 =0 if yperi_fat5v5 ==. 
replace ylean5v5 =0 if ylean5v5 ==. 
replace ytrunk_lean5v5 =0 if ytrunk_lean5v5 ==. 
replace yperi_lean5v5 =0 if yperi_lean5v5 ==. 

count 
set obs `=_N + 1'
replace age = 25 if age ==. 
replace yfat5v5 =0 if yfat5v5 ==. 
replace ytrunk_fat5v5 =0 if ytrunk_fat5v5 ==. 
replace yperi_fat5v5 =0 if yperi_fat5v5 ==. 
replace ylean5v5 =0 if ylean5v5 ==. 
replace ytrunk_lean5v5 =0 if ytrunk_lean5v5 ==. 
replace yperi_lean5v5 =0 if yperi_lean5v5 ==. 

set scheme s1color

twoway	///
(line yfat1v5 age, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line yfat2v5 age, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line yfat3v5 age, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line yfat4v5 age, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line yfat5v5 age, sort legend(label(5 "Class 5: Normal weight [non-linear] REFERENT")) lcolor(midgreen) lwidth(thick) lstyle(solid) lpattern(longdash))	///
(line yfat6v5 age, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, ytitle("Fat mass (kg) difference", color(black) size(medium)) 							///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(-5 "-5" 0 5 "+5" 10 "+10" 15 "+15"  20 "+20" 25 "+25"  30 "+30" , nogrid labsize(small))								///		
xlabel(9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
legend(off)	

graph export fat.tif, replace width(1000)

twoway	///
(line ylean1v5 age, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line ylean2v5 age, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line ylean3v5 age, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line ylean4v5 age, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line ylean5v5 age, sort legend(label(5 "Class 5: Normal weight [non-linear] REFERENT")) lcolor(midgreen) lwidth(thick) lstyle(solid) lpattern(longdash))	///
(line ylean6v5 age, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, ytitle("Lean mass (kg) difference", color(black) size(medium)) 							///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(-5 "-5" 0 5 "+5" 10 "+10" 15 "+15"  20 "+20" 25 "+25"  30 "+30" , nogrid labsize(small))								///		
ytick(-2, notick)																///	
xlabel(9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
legend(ring(0) bplacement(nwest) order(4 6 1 3 2 5) cols(1) color(black) size(small) region(lcolor(none) fcolor(none)))	

graph export lean.tif, replace width(1000)

twoway	///
(line ytrunk_fat1v5 age, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line ytrunk_fat2v5 age, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line ytrunk_fat3v5 age, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line ytrunk_fat4v5 age, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line ytrunk_fat5v5 age, sort legend(label(5 "Class 5: Normal weight [non-linear] REFERENT")) lcolor(midgreen) lwidth(thick) lstyle(solid) lpattern(longdash))	///
(line ytrunk_fat6v5 age, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, ytitle("Trunk fat mass (kg) difference", color(black) size(medium)) 							///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(-5 "-5" 0 5 "+5" 10 "+10" 15 "+15"  , nogrid labsize(small))								///		
ytick(16, notick)				///
xlabel(9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
legend(off)	

graph export trunkfat.tif, replace width(1000)

twoway	///
(line yperi_fat1v5 age, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line yperi_fat2v5 age, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line yperi_fat3v5 age, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line yperi_fat4v5 age, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line yperi_fat5v5 age, sort legend(label(5 "Class 5: Normal weight [non-linear] REFERENT")) lcolor(midgreen) lwidth(thick) lstyle(solid) lpattern(longdash))	///
(line yperi_fat6v5 age, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, ytitle("Peripheral fat mass (kg) difference", color(black) size(medium)) 							///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(-5 "-5" 0 5 "+5" 10 "+10" 15 "+15"   , nogrid labsize(small))								///		
ytick(16, notick)				///
xlabel(9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
legend(off)	

graph export perifat.tif, replace width(1000)

twoway	///
(line ytrunk_lean1v5 age, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line ytrunk_lean2v5 age, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line ytrunk_lean3v5 age, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line ytrunk_lean4v5 age, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line ytrunk_lean5v5 age, sort legend(label(5 "Class 5: Normal weight [non-linear] REFERENT")) lcolor(midgreen) lwidth(thick) lstyle(solid) lpattern(longdash))	///
(line ytrunk_lean6v5 age, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, ytitle("Trunk lean mass (kg) difference", color(black) size(medium)) 							///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(-5 "-5" 0 5 "+5" 10 "+10" 15 "+15"  , nogrid labsize(small))								///	
ytick(16, notick)				///	
xlabel(9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
legend(ring(0) bplacement(nwest) order(4 6 1 3 2 5) cols(1) color(black) size(small) region(lcolor(none) fcolor(none)))		

graph export trunklean.tif, replace width(1000)

twoway	///
(line yperi_lean1v5 age, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line yperi_lean2v5 age, sort legend(label(2 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line yperi_lean3v5 age, sort legend(label(3 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line yperi_lean4v5 age, sort legend(label(4 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line yperi_lean5v5 age, sort legend(label(5 "Class 5: Normal weight [non-linear] REFERENT")) lcolor(midgreen) lwidth(thick) lstyle(solid) lpattern(longdash))	///
(line yperi_lean6v5 age, sort legend(label(6 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, ytitle("Peripheral lean mass (kg) difference", color(black) size(medium)) 							///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(-5 "-5" 0 5 "+5" 10 "+10" 15 "+15"   , nogrid labsize(small))								///	
ytick(16, notick)				///	
xlabel(9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
legend(ring(0) bplacement(nwest) order(4 6 1 3 2 5) cols(1) color(black) size(small) region(lcolor(none) fcolor(none)))	

graph export perilean.tif, replace width(1000)
