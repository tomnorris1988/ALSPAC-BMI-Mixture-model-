clear
clear mata
clear matrix
set mem 1000m
set more off
cd "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis"
set maxvar 10000

*class membership two  

import excel "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\two.xlsx", sheet("two") clear

rename A cprob1
rename B cprob2
rename C c
rename D id

recode cprob1(0/0.69999=0)(0.7/1=1), gen(cprob1_cat)
recode cprob2(0/0.69999=0)(0.7/1=1), gen(cprob2_cat)

tab cprob1_cat if c ==1 
tab cprob2_cat if c ==2

order id c cprob1 cprob2 cprob1_cat cprob2_cat

sort id 

save two.dta, replace 

*class membership three  

import excel "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\three.xlsx", sheet("three") clear

rename A cprob1
rename B cprob2
rename C cprob3
rename D c
rename E id

recode cprob1(0/0.69999=0)(0.7/1=1), gen(cprob1_cat)
recode cprob2(0/0.69999=0)(0.7/1=1), gen(cprob2_cat)
recode cprob3(0/0.69999=0)(0.7/1=1), gen(cprob3_cat)

tab cprob1_cat if c ==1 
tab cprob2_cat if c ==2
tab cprob3_cat if c ==3

order id c cprob1 cprob2 cprob3 cprob1_cat cprob2_cat cprob3_cat

sort id 

save three.dta, replace 

*class membership four 

import excel "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\four.xlsx", sheet("four") clear

rename A cprob1
rename B cprob2
rename C cprob3
rename D cprob4
rename E c
rename F id

recode cprob1(0/0.69999=0)(0.7/1=1), gen(cprob1_cat)
recode cprob2(0/0.69999=0)(0.7/1=1), gen(cprob2_cat)
recode cprob3(0/0.69999=0)(0.7/1=1), gen(cprob3_cat)
recode cprob4(0/0.69999=0)(0.7/1=1), gen(cprob4_cat)

tab cprob1_cat if c ==1 
tab cprob2_cat if c ==2
tab cprob3_cat if c ==3
tab cprob4_cat if c ==4

order id c cprob1 cprob2 cprob3 cprob4 cprob1_cat cprob2_cat cprob3_cat cprob4_cat

sort id 

save four.dta, replace 

*class membership five

import excel "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\five.xlsx", sheet("five") clear

rename A cprob1
rename B cprob2
rename C cprob3
rename D cprob4
rename E cprob5
rename F c
rename G id

recode cprob1(0/0.69999=0)(0.7/1=1), gen(cprob1_cat)
recode cprob2(0/0.69999=0)(0.7/1=1), gen(cprob2_cat)
recode cprob3(0/0.69999=0)(0.7/1=1), gen(cprob3_cat)
recode cprob4(0/0.69999=0)(0.7/1=1), gen(cprob4_cat)
recode cprob5(0/0.69999=0)(0.7/1=1), gen(cprob5_cat)

tab cprob1_cat if c ==1 
tab cprob2_cat if c ==2
tab cprob3_cat if c ==3
tab cprob4_cat if c ==4
tab cprob5_cat if c ==5

order id c cprob1 cprob2 cprob3 cprob4 cprob5	///
cprob1_cat cprob2_cat cprob3_cat cprob4_cat cprob5_cat

sort id 

save five.dta, replace 

*class membership six

import excel "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\six.xlsx", sheet("six") clear

rename A cprob1
rename B cprob2
rename C cprob3
rename D cprob4
rename E cprob5
rename F cprob6
rename G c
rename H id

recode cprob1(0/0.69999=0)(0.7/1=1), gen(cprob1_cat)
recode cprob2(0/0.69999=0)(0.7/1=1), gen(cprob2_cat)
recode cprob3(0/0.69999=0)(0.7/1=1), gen(cprob3_cat)
recode cprob4(0/0.69999=0)(0.7/1=1), gen(cprob4_cat)
recode cprob5(0/0.69999=0)(0.7/1=1), gen(cprob5_cat)
recode cprob6(0/0.69999=0)(0.7/1=1), gen(cprob6_cat)

tab cprob1_cat if c ==1 
tab cprob2_cat if c ==2
tab cprob3_cat if c ==3
tab cprob4_cat if c ==4
tab cprob5_cat if c ==5
tab cprob6_cat if c ==6

order id c cprob1 cprob2 cprob3 cprob4 cprob5 cprob6	///
cprob1_cat cprob2_cat cprob3_cat cprob4_cat cprob5_cat cprob6_cat

sort id 

save six.dta, replace 

*class membership seven

import excel "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\seven.xlsx", sheet("seven") clear

rename A cprob1
rename B cprob2
rename C cprob3
rename D cprob4
rename E cprob5
rename F cprob6
rename G cprob7
rename H c
rename I id

recode cprob1(0/0.69999=0)(0.7/1=1), gen(cprob1_cat)
recode cprob2(0/0.69999=0)(0.7/1=1), gen(cprob2_cat)
recode cprob3(0/0.69999=0)(0.7/1=1), gen(cprob3_cat)
recode cprob4(0/0.69999=0)(0.7/1=1), gen(cprob4_cat)
recode cprob5(0/0.69999=0)(0.7/1=1), gen(cprob5_cat)
recode cprob6(0/0.69999=0)(0.7/1=1), gen(cprob6_cat)
recode cprob7(0/0.69999=0)(0.7/1=1), gen(cprob7_cat)

tab cprob1_cat if c ==1 
tab cprob2_cat if c ==2
tab cprob3_cat if c ==3
tab cprob4_cat if c ==4
tab cprob5_cat if c ==5
tab cprob6_cat if c ==6
tab cprob7_cat if c ==7

order id c cprob1 cprob2 cprob3 cprob4 cprob5 cprob6 cprob7	///
cprob1_cat cprob2_cat cprob3_cat cprob4_cat cprob5_cat cprob6_cat cprob7_cat

sort id 

save seven.dta, replace 

*Six class post prob figures

use six.dta, clear

set scheme s1color

gen dum1 = cprob1 if c==1
gen dum2 = cprob2 if c==2
gen dum3 = cprob3 if c==3
gen dum4 = cprob4 if c==4
gen dum5 = cprob5 if c==5
gen dum6 = cprob6 if c==6

kdensity cprob1 if c ==1, at(dum1) color(sienna) recast(area)								///
ytitle("Density", color(black) size(medium)) 											///
xtitle("Posterior probability", color(black) size(medium)) 								///	
ylabel(0 1 2 3 4 5, nogrid labsize(small))												///
xlabel(0.25 "0.25" 0.5 "0.5" 0.75 "0.75" 1 "1", nogrid labsize(small))					///
title("Class 1: Normal weight or overweight")																			///
addplot(hist cprob1 if c==1, /// adding and overlaying distribution of length
freq blcolor(black) fcolor(black) /// bar line and fill colors
discrete /// tells stata to graph actual distribution of length
yaxis(2) /// calls for 2nd y-axis, which we'll suppress
yscale(lcolor() axis(2)) /// 2nd y-axis scaling
ylabel(0 "0" 10 "10" 20 "20" 30 "30" , /// minimizing the height of histogram
labcolor() axis(2) tlcolor(black) tlwidth(thin) labsize(small) tl(0)) /// label options for 2nd axis
ytitle("Frequency", color(black) size(medium) axis(2)) /// no title on 2nd axis
plotregion(lcolor(none))															///
graphregion(margin(small))															///
legend(off))	///
saving(class6_c1prob , replace) 

graph export class6_c1prob.tif, replace width(1000)

kdensity cprob2 if c ==2, at(dum2) color(dkgreen) recast(area)								///
ytitle("Density", color(black) size(medium)) 											///
xtitle("Posterior probability", color(black) size(medium)) 								///	
ylabel(0 1 2 3 4 5, nogrid labsize(small))												///
xlabel(0.25 "0.25" 0.5 "0.5" 0.75 "0.75" 1 "1", nogrid labsize(small))					///
title("Class 2: Normal weight [linear]")																			///
addplot(hist cprob2 if c==2, /// adding and overlaying distribution of length
freq blcolor(black) fcolor(black) /// bar line and fill colors
discrete /// tells stata to graph actual distribution of length
yaxis(2) /// calls for 2nd y-axis, which we'll suppress
yscale(lcolor() axis(2)) /// 2nd y-axis scaling
ylabel(0 "0" 10 "10" 20 "20" 30 "30" , /// minimizing the height of histogram
labcolor() axis(2) tlcolor(black) tlwidth(thin) labsize(small) tl(0)) /// label options for 2nd axis
ytitle("Frequency", color(black) size(medium) axis(2)) /// no title on 2nd axis
plotregion(lcolor(none))															///
graphregion(margin(small))															///
legend(off))	///
saving(class6_c2prob , replace) 

graph export class6_c2prob.tif, replace width(1000)

kdensity cprob3 if c ==3, at(dum3) color(orange) recast(area)								///
ytitle("Density", color(black) size(medium)) 											///
xtitle("Posterior probability", color(black) size(medium)) 								///	
ylabel(0 1 2 3 4 5, nogrid labsize(small))												///
xlabel(0.25 "0.25" 0.5 "0.5" 0.75 "0.75" 1 "1", nogrid labsize(small))					///
title("Class 3: Normal weight increasing to overweight")																			///
addplot(hist cprob3 if c==3, /// adding and overlaying distribution of length
freq blcolor(black) fcolor(black) /// bar line and fill colors
discrete /// tells stata to graph actual distribution of length
yaxis(2) /// calls for 2nd y-axis, which we'll suppress
yscale(lcolor() axis(2)) /// 2nd y-axis scaling
ylabel(0 "0" 10 "10" 20 "20" 30 "30" , /// minimizing the height of histogram
labcolor() axis(2) tlcolor(black) tlwidth(thin) labsize(small) tl(0)) /// label options for 2nd axis
ytitle("Frequency", color(black) size(medium) axis(2)) /// no title on 2nd axis
plotregion(lcolor(none))															///
graphregion(margin(small))															///
legend(off))	///
saving(class6_c3prob , replace) 

graph export class6_c3prob.tif, replace width(1000)

kdensity cprob4 if c ==4, at(dum4) color(cranberry) recast(area)								///
ytitle("Density", color(black) size(medium)) 											///
xtitle("Posterior probability", color(black) size(medium)) 								///	
ylabel(0 1 2 3 4 5, nogrid labsize(small))												///
xlabel(0.25 "0.25" 0.5 "0.5" 0.75 "0.75" 1 "1", nogrid labsize(small))					///
title("Class 4: Overweight or obesity")																			///
addplot(hist cprob4 if c==4, /// adding and overlaying distribution of length
freq blcolor(black) fcolor(black) /// bar line and fill colors
discrete /// tells stata to graph actual distribution of length
yaxis(2) /// calls for 2nd y-axis, which we'll suppress
yscale(lcolor() axis(2)) /// 2nd y-axis scaling
ylabel(0 "0" 10 "10" 20 "20" 30 "30" , /// minimizing the height of histogram
labcolor() axis(2) tlcolor(black) tlwidth(thin) labsize(small) tl(0)) /// label options for 2nd axis
ytitle("Frequency", color(black) size(medium) axis(2)) /// no title on 2nd axis
plotregion(lcolor(none))															///
graphregion(margin(small))															///
legend(off))	///
saving(class6_c4prob , replace) 

graph export class6_c4prob.tif, replace width(1000)

kdensity cprob5 if c ==5, at(dum5) color(midgreen) recast(area)								///
ytitle("Density", color(black) size(medium)) 											///
xtitle("Posterior probability", color(black) size(medium)) 								///	
ylabel(0 1 2 3 4 5, nogrid labsize(small))												///
xlabel(0.25 "0.25" 0.5 "0.5" 0.75 "0.75" 1 "1", nogrid labsize(small))					///
title("Class 5: Normal weight [non-linear]")																			///
addplot(hist cprob5 if c==5, /// adding and overlaying distribution of length
freq blcolor(black) fcolor(black) /// bar line and fill colors
discrete /// tells stata to graph actual distribution of length
yaxis(2) /// calls for 2nd y-axis, which we'll suppress
yscale(lcolor() axis(2)) /// 2nd y-axis scaling
ylabel(0 "0" 10 "10" 20 "20" 30 "30" , /// minimizing the height of histogram
labcolor() axis(2) tlcolor(black) tlwidth(thin) labsize(small) tl(0)) /// label options for 2nd axis
ytitle("Frequency", color(black) size(medium) axis(2)) /// no title on 2nd axis
plotregion(lcolor(none))															///
graphregion(margin(small))															///
legend(off))	///
saving(class6_c5prob , replace) 

graph export class6_c5prob.tif, replace width(1000)

kdensity cprob6 if c ==6, at(dum6) color(red) recast(area)								///
ytitle("Density", color(black) size(medium)) 											///
xtitle("Posterior probability", color(black) size(medium)) 								///	
ylabel(0 1 2 3 4 5, nogrid labsize(small))												///
xlabel(0.25 "0.25" 0.5 "0.5" 0.75 "0.75" 1 "1", nogrid labsize(small))					///
title("Class 6: Normal weight increasing to obesity")																			///
addplot(hist cprob6 if c==6, /// adding and overlaying distribution of length
freq blcolor(black) fcolor(black) /// bar line and fill colors
discrete /// tells stata to graph actual distribution of length
yaxis(2) /// calls for 2nd y-axis, which we'll suppress
yscale(lcolor() axis(2)) /// 2nd y-axis scaling
ylabel(0 "0" 10 "10" 20 "20" 30 "30" , /// minimizing the height of histogram
labcolor() axis(2) tlcolor(black) tlwidth(thin) labsize(small) tl(0)) /// label options for 2nd axis
ytitle("Frequency", color(black) size(medium) axis(2)) /// no title on 2nd axis
plotregion(lcolor(none))															///
graphregion(margin(small))															///
legend(off))	///
saving(class6_c6prob , replace) 

graph export class6_c6prob.tif, replace width(1000)

*Class 1 BMI figure

import excel "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\one_traj.xlsx", sheet("one_traj") clear

rename A age
rename B c1_50
rename C c1_5
rename D c1_95

replace age = age + 12.9

append using zbmicat2.dta

count 

se obs 195 

replace iotfage = 25 in 195 
replace thin = 18.5 in 195 
replace over = 25 in 195 
replace obes = 30 in 195 

set scheme s1color

gen high = 37
gen low = 12.5

twoway	/// 
(rarea high obes iotfage, fcolor(red) lcolor(white) lwidth(none) fintensity(10))				///
(rarea obes over iotfage, fcolor(orange) lcolor(white) lwidth(none) fintensity(10))				///	
(rarea over thin iotfage, fcolor(green) lcolor(white) lwidth(none) fintensity(10))				///		
(rarea thin low iotfage, fcolor(red) lcolor(white) lwidth(none) fintensity(10))					///
(line c1_50 age, sort legend(label(5 "C1: N=3549 (100%)")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
, ytitle("BMI (kg/m{superscript:2})", color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(15 "15" 20 "20" 25 "25" 30 "30" 35 "35", nogrid labsize(small))			///
xlabel(7 9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
ytick(37, notick)																///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
text(32.5 25.26 "Obesity", size(small) color(red) orient(rvertical))			///	
text(27.5 25.26 "Overweight", size(small) color(orange) orient(rvertical))		///
text(21.7 25.26 "Normal", size(small) color(green) orient(rvertical))			///
text(15.8 25.26 "Thinness", size(small) color(red) orient(rvertical))			///
legend(ring(0) bplacement(nwest) order(5) cols(1) color(black) size(small) region(lcolor(none) fcolor(none)))	///	
saving(class1 , replace) 

graph export class1.tif, replace width(1000)


*Class 2 BMI figure

import excel "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\two_traj.xlsx", sheet("two_traj") clear

rename A age
rename B c1_50
rename C c1_5
rename D c1_95
rename E c2_50
rename F c2_5
rename G c2_95

replace age = age + 12.9

append using zbmicat2.dta

count 

se obs 195 

replace iotfage = 25 in 195 
replace thin = 18.5 in 195 
replace over = 25 in 195 
replace obes = 30 in 195 

set scheme s1color

gen high = 37
gen low = 12.5

twoway	/// 
(rarea high obes iotfage, fcolor(red) lcolor(white) lwidth(none) fintensity(10))				///
(rarea obes over iotfage, fcolor(orange) lcolor(white) lwidth(none) fintensity(10))				///	
(rarea over thin iotfage, fcolor(green) lcolor(white) lwidth(none) fintensity(10))				///		
(rarea thin low iotfage, fcolor(red) lcolor(white) lwidth(none) fintensity(10))					///
(line c1_50 age, sort legend(label(5 "C1: N=1083 (30.5%)")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line c2_50 age, sort legend(label(6 "C2: N=2466 (69.5%)")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
, ytitle("BMI (kg/m{superscript:2})", color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(15 "15" 20 "20" 25 "25" 30 "30" 35 "35", nogrid labsize(small))			///
xlabel(7 9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
ytick(37, notick)																///
text(32.5 25.26 "Obesity", size(small) color(red) orient(rvertical))			///	
text(27.5 25.26 "Overweight", size(small) color(orange) orient(rvertical))		///
text(21.7 25.26 "Normal", size(small) color(green) orient(rvertical))			///
text(15.8 25.26 "Thinness", size(small) color(red) orient(rvertical))			///
legend(ring(0) bplacement(nwest) order(5 6) cols(1) color(black) size(small) region(lcolor(none) fcolor(none)))	///
saving(class2 , replace) 

graph export class2.tif, replace width(1000)

*Class 3 BMI figure

import excel "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\three_traj.xlsx", sheet("three_traj") clear

rename A age
rename B c1_50
rename C c1_5
rename D c1_95
rename E c2_50
rename F c2_5
rename G c2_95
rename H c3_50
rename I c3_5
rename J c3_95

replace age = age + 12.9

append using zbmicat2.dta

count 

se obs 195 

replace iotfage = 25 in 195 
replace thin = 18.5 in 195 
replace over = 25 in 195 
replace obes = 30 in 195 

set scheme s1color

gen high = 37
gen low = 12.5

twoway	/// 
(rarea high obes iotfage, fcolor(red) lcolor(white) lwidth(none) fintensity(10))				///
(rarea obes over iotfage, fcolor(orange) lcolor(white) lwidth(none) fintensity(10))				///	
(rarea over thin iotfage, fcolor(green) lcolor(white) lwidth(none) fintensity(10))				///		
(rarea thin low iotfage, fcolor(red) lcolor(white) lwidth(none) fintensity(10))					///
(line c1_50 age, sort legend(label(5 "C1: N=1830 (51.6%)")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
(line c2_50 age, sort legend(label(6 "C2: N=1275 (35.9%)")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line c3_50 age, sort legend(label(7 "C3: N=444 (12.5%)")) lcolor(red) lwidth(thick) lstyle(solid))	///
, ytitle("BMI (kg/m{superscript:2})", color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(15 "15" 20 "20" 25 "25" 30 "30" 35 "35", nogrid labsize(small))			///
xlabel(7 9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
ytick(37, notick)																///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
text(32.5 25.26 "Obesity", size(small) color(red) orient(rvertical))			///	
text(27.5 25.26 "Overweight", size(small) color(orange) orient(rvertical))		///
text(21.7 25.26 "Normal", size(small) color(green) orient(rvertical))			///
text(15.8 25.26 "Thinness", size(small) color(red) orient(rvertical))			///
legend(ring(0) bplacement(nwest) order(7 6 5) cols(1) color(black) size(small) region(lcolor(none) fcolor(none)))	///
saving(class3 , replace) 

graph export class3.tif, replace width(1000)

*Class 4 BMI figure

import excel "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\four_traj.xlsx", sheet("four_traj") clear

rename A age
rename B c1_50
rename C c1_5
rename D c1_95
rename E c2_50
rename F c2_5
rename G c2_95
rename H c3_50
rename I c3_5
rename J c3_95
rename K c4_50
rename L c4_5
rename M c4_95

replace age = age + 12.9

append using zbmicat2.dta

count 

se obs 195 

replace iotfage = 25 in 195 
replace thin = 18.5 in 195 
replace over = 25 in 195 
replace obes = 30 in 195 

set scheme s1color

gen high = 37
gen low = 12.5

twoway	/// 
(rarea high obes iotfage, fcolor(red) lcolor(white) lwidth(none) fintensity(10))				///
(rarea obes over iotfage, fcolor(orange) lcolor(white) lwidth(none) fintensity(10))				///	
(rarea over thin iotfage, fcolor(green) lcolor(white) lwidth(none) fintensity(10))				///		
(rarea thin low iotfage, fcolor(red) lcolor(white) lwidth(none) fintensity(10))					///
(line c1_50 age, sort legend(label(5 "C1: N=378 (10.7%)")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line c2_50 age, sort legend(label(6 "C2: N=812 (22.9%)")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line c3_50 age, sort legend(label(7 "C3: N=508 (14.3%)")) lcolor(red) lwidth(thick) lstyle(solid))	///
(line c4_50 age, sort legend(label(8 "C4: N=1851 (52.1%)")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
, ytitle("BMI (kg/m{superscript:2})", color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(15 "15" 20 "20" 25 "25" 30 "30" 35 "35", nogrid labsize(small))			///
ytick(37, notick)																///
xlabel(7 9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
text(32.5 25.26 "Obesity", size(small) color(red) orient(rvertical))			///	
text(27.5 25.26 "Overweight", size(small) color(orange) orient(rvertical))		///
text(21.7 25.26 "Normal", size(small) color(green) orient(rvertical))			///
text(15.8 25.26 "Thinness", size(small) color(red) orient(rvertical))			///
legend(ring(0) bplacement(nwest) order(5 7 6 8) cols(1) color(black) size(small) region(lcolor(none) fcolor(none)))	///
saving(class4 , replace) 

graph export class4.tif, replace width(1000)

*Class 5 BMI figure

import excel "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\five_traj.xlsx", sheet("five_traj") clear

rename A age
rename B c1_50
rename C c1_5
rename D c1_95
rename E c2_50
rename F c2_5
rename G c2_95
rename H c3_50
rename I c3_5
rename J c3_95
rename K c4_50
rename L c4_5
rename M c4_95
rename N c5_50
rename O c5_5
rename P c5_95

replace age = age + 12.9

append using zbmicat2.dta

count 

se obs 195 

replace iotfage = 25 in 195 
replace thin = 18.5 in 195 
replace over = 25 in 195 
replace obes = 30 in 195 

set scheme s1color

gen high = 37
gen low = 12.5

twoway	/// 
(rarea high obes iotfage, fcolor(red) lcolor(white) lwidth(none) fintensity(10))				///
(rarea obes over iotfage, fcolor(orange) lcolor(white) lwidth(none) fintensity(10))				///	
(rarea over thin iotfage, fcolor(green) lcolor(white) lwidth(none) fintensity(10))				///		
(rarea thin low iotfage, fcolor(red) lcolor(white) lwidth(none) fintensity(10))					///
(line c1_50 age, sort legend(label(5 "C1: N=837 (23.6%)")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line c2_50 age, sort legend(label(6 "C2: N=1546 (43.6%)")) lcolor(green) lwidth(thick) lstyle(solid))	///
(line c3_50 age, sort legend(label(7 "C3: N=278 (7.8%)")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line c4_50 age, sort legend(label(8 "C4: N=280 (7.9%)")) lcolor(red) lwidth(thick) lstyle(solid))	///
(line c5_50 age, sort legend(label(9 "C5: N=608 (17.1%)")) lcolor(orange) lwidth(thick) lstyle(solid))	///
, ytitle("BMI (kg/m{superscript:2})", color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(15 "15" 20 "20" 25 "25" 30 "30" 35 "35", nogrid labsize(small))			///
xlabel(7 9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
ytick(37, notick)																///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
text(32.5 25.26 "Obesity", size(small) color(red) orient(rvertical))			///	
text(27.5 25.26 "Overweight", size(small) color(orange) orient(rvertical))		///
text(21.7 25.26 "Normal", size(small) color(green) orient(rvertical))			///
text(15.8 25.26 "Thinness", size(small) color(red) orient(rvertical))			///
legend(ring(0) bplacement(nwest) order(7 8 9 5 6 ) cols(1) color(black) size(small) region(lcolor(none) fcolor(none)))	///
saving(class5 , replace) 

graph export class5.tif, replace width(1000)

*Class 6 BMI figure

import excel "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\six_traj.xlsx", sheet("six_traj") clear

rename A age
rename B c1_50
rename C c1_5
rename D c1_95
rename E c2_50
rename F c2_5
rename G c2_95
rename H c3_50
rename I c3_5
rename J c3_95
rename K c4_50
rename L c4_5
rename M c4_95
rename N c5_50
rename O c5_5
rename P c5_95
rename Q c6_50
rename R c6_5
rename S c6_95

replace age = age + 12.9

save six_curves.dta, replace 

append using zbmicat2.dta

count 

se obs 195 

replace iotfage = 25 in 195 
replace thin = 18.5 in 195 
replace over = 25 in 195 
replace obes = 30 in 195 

set scheme s1color

gen high = 38
gen low = 12.5

twoway	/// 
(rarea high obes iotfage, fcolor(red) lcolor(white) lwidth(none) fintensity(10))				///
(rarea obes over iotfage, fcolor(orange) lcolor(white) lwidth(none) fintensity(10))				///	
(rarea over thin iotfage, fcolor(green) lcolor(white) lwidth(none) fintensity(10))				///		
(rarea thin low iotfage, fcolor(red) lcolor(white) lwidth(none) fintensity(10))					///
(line c1_50 age, sort legend(label(5 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line c2_50 age, sort legend(label(6 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line c3_50 age, sort legend(label(7 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line c4_50 age, sort legend(label(8 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line c5_50 age, sort legend(label(9 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
(line c6_50 age, sort legend(label(10 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
, ytitle("BMI (kg/m{superscript:2})", color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(15 "15" 20 "20" 25 "25" 30 "30" 35 "35", nogrid labsize(small))			///
xlabel(7 9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
plotregion(lcolor(none))														///
ytick(38, notick)																///
graphregion(margin(small))														///
text(32.5 25.26 "Obesity", size(small) color(red) orient(rvertical))			///	
text(27.5 25.26 "Overweight", size(small) color(orange) orient(rvertical))		///
text(21.7 25.26 "Normal", size(small) color(green) orient(rvertical))			///
text(15.8 25.26 "Thinness", size(small) color(red) orient(rvertical))			///
legend(ring(0) bplacement(nwest) order(8 10 5 7 6 9) cols(1) color(black) size(small) region(lcolor(none) fcolor(none)))	///
saving(class6 , replace) 

graph export class6.tif, replace width(1000)

*Class 7 BMI figure

import excel "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis\seven_traj.xlsx", sheet("seven_traj") clear

rename A age
rename B c1_50
rename C c1_5
rename D c1_95
rename E c2_50
rename F c2_5
rename G c2_95
rename H c3_50
rename I c3_5
rename J c3_95
rename K c4_50
rename L c4_5
rename M c4_95
rename N c5_50
rename O c5_5
rename P c5_95
rename Q c6_50
rename R c6_5
rename S c6_95
rename T c7_50
rename U c7_5
rename V c7_95

replace age = age + 12.9

append using zbmicat2.dta

count 

se obs 195 

replace iotfage = 25 in 195 
replace thin = 18.5 in 195 
replace over = 25 in 195 
replace obes = 30 in 195 

set scheme s1color

gen high = 37
gen low = 12.5

twoway	/// 
(rarea high obes iotfage, fcolor(red) lcolor(white) lwidth(none) fintensity(10))				///
(rarea obes over iotfage, fcolor(orange) lcolor(white) lwidth(none) fintensity(10))				///	
(rarea over thin iotfage, fcolor(green) lcolor(white) lwidth(none) fintensity(10))				///		
(rarea thin low iotfage, fcolor(red) lcolor(white) lwidth(none) fintensity(10))					///
(line c1_50 age, sort legend(label(5 "C1: N=534 (15.0%)")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line c2_50 age, sort legend(label(6 "C2: N=151 (4.3%)")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line c3_50 age, sort legend(label(7 "C3: N=214 (6.0%)")) lcolor(red) lwidth(thick) lstyle(solid))	///
(line c4_50 age, sort legend(label(8 "C4: N=679 (19.1%)")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line c5_50 age, sort legend(label(9 "C5: N=511 (14.4%)")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line c6_50 age, sort legend(label(10 "C6: N=1212 (34.2%)")) lcolor(navy) lwidth(thick) lstyle(solid))	///
(line c7_50 age, sort legend(label(11 "C7: N=248 (7.0%)")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
, ytitle("BMI (kg/m{superscript:2})", color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(15 "15" 20 "20" 25 "25" 30 "30" 35 "35", nogrid labsize(small))			///
xlabel(7 9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
ytick(37, notick)																///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
text(32.5 25.26 "Obesity", size(small) color(red) orient(rvertical))			///	
text(27.5 25.26 "Overweight", size(small) color(orange) orient(rvertical))		///
text(21.7 25.26 "Normal", size(small) color(green) orient(rvertical))			///
text(15.8 25.26 "Thinness", size(small) color(red) orient(rvertical))			///
legend(ring(0) bplacement(nwest) order(6 7 5 9 8 11 10) cols(1) color(black) size(small) region(lcolor(none) fcolor(none)))	///
saving(class7 , replace) 

graph export class7.tif, replace width(1000)

*individual curve figure for 6-class solution 

use finalsample.dta, clear 

keep id age* bmi*
drop age agerange bmi

reshape long age bmi, i(id) j(visit)

merge m:1 id using six.dta 

append using six_curves.dta

set scheme s1color

twoway	///
(line bmi age if c ==1 & bmi<45, c(L) lcolor(sienna*0.8) lwidth(vvvthin) lstyle(solid))	///
(line c1_50 age, sort legend(label(2 "Class 1: N=554 (15.6%)")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(line c1_5 age, sort lcolor(sienna) lwidth(medthick) lpattern(dash) lstyle(solid))	///
(line c1_95 age, sort lcolor(sienna) lwidth(medthick) lpattern(dash) lstyle(solid))	///
, ytitle("BMI (kg/m{superscript:2})", color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(10 "10" 15 "15" 20 "20" 25 "25" 30 "30" 35 "35" 40 "40" 45 "45" , nogrid labsize(small))			///
xlabel(7 9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
ytick(37, notick)																///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
legend(ring(0) bplacement(nwest) order(2) cols(1) color(black) size(small) region(lcolor(none) fcolor(none)))	

graph export class6_c1.tif, replace width(1000)

twoway	///
(line bmi age if c ==2 & bmi<45, c(L) lcolor(dkgreen*0.8) lwidth(vvvthin) lstyle(solid))	///
(line c2_50 age, sort legend(label(2 "Class 2: N=755 (21.3%)")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(line c2_5 age, sort lcolor(dkgreen) lwidth(medthick) lpattern(dash) lstyle(solid))	///
(line c2_95 age, sort lcolor(dkgreen) lwidth(medthick) lpattern(dash) lstyle(solid))	///
, ytitle("BMI (kg/m{superscript:2})", color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(10 "10" 15 "15" 20 "20" 25 "25" 30 "30" 35 "35" 40 "40" 45 "45" , nogrid labsize(small))			///
xlabel(7 9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
ytick(37, notick)																///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
legend(ring(0) bplacement(nwest) order(2) cols(1) color(black) size(small) region(lcolor(none) fcolor(none)))	

graph export class6_c2.tif, replace width(1000)

twoway	///
(line bmi age if c ==3 & bmi<45, c(L) lcolor(orange*0.8) lwidth(vvvthin) lstyle(solid))	///
(line c3_50 age, sort legend(label(2 "Class 3: N=645 (18.2%)")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(line c3_5 age, sort lcolor(orange) lwidth(medthick) lpattern(dash) lstyle(solid))	///
(line c3_95 age, sort lcolor(orange) lwidth(medthick) lpattern(dash) lstyle(solid))	///
, ytitle("BMI (kg/m{superscript:2})", color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(10 "10" 15 "15" 20 "20" 25 "25" 30 "30" 35 "35" 40 "40" 45 "45" , nogrid labsize(small))			///
xlabel(7 9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
ytick(37, notick)																///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
legend(ring(0) bplacement(nwest) order(2) cols(1) color(black) size(small) region(lcolor(none) fcolor(none)))	

graph export class6_c3.tif, replace width(1000)

twoway	///
(line bmi age if c ==4 & bmi<45, c(L) lcolor(cranberry*0.8) lwidth(vvvthin) lstyle(solid))		///
(line c4_50 age, sort legend(label(2 "Class 4: N=136 (3.8%)")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(line c4_5 age, sort lcolor(cranberry) lwidth(medthick) lpattern(dash) lstyle(solid))	///
(line c4_95 age, sort lcolor(cranberry) lwidth(medthick) lpattern(dash) lstyle(solid))	///
, ytitle("BMI (kg/m{superscript:2})", color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(10 "10" 15 "15" 20 "20" 25 "25" 30 "30" 35 "35" 40 "40" 45 "45" , nogrid labsize(small))			///
xlabel(7 9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
ytick(37, notick)																///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
legend(ring(0) bplacement(nwest) order(2) cols(1) color(black) size(small) region(lcolor(none) fcolor(none)))	

graph export class6_c4.tif, replace width(1000)

twoway	///
(line bmi age if c ==5 & bmi<45 , c(L) lcolor(midgreen*0.8) lwidth(vvvthin) lstyle(solid))	///
(line c5_50 age, sort legend(label(2 "Class 5: N=1248 (35.2%)")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
(line c5_5 age, sort lcolor(midgreen) lwidth(medthick) lpattern(dash) lstyle(solid))	///
(line c5_95 age, sort lcolor(midgreen) lwidth(medthick) lpattern(dash) lstyle(solid))	///
, ytitle("BMI (kg/m{superscript:2})", color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(10 "10" 15 "15" 20 "20" 25 "25" 30 "30" 35 "35" 40 "40" 45 "45" , nogrid labsize(small))			///
xlabel(7 9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
ytick(37, notick)																///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
legend(ring(0) bplacement(nwest) order(2) cols(1) color(black) size(small) region(lcolor(none) fcolor(none)))	

graph export class6_c5.tif, replace width(1000)

twoway	///
(line bmi age if c ==6 & bmi<45, c(L) lcolor(red*0.8) lwidth(vvvthin) lstyle(solid)) ///
(line c6_50 age, sort legend(label(2 "Class 6: N=211 (5.9%)")) lcolor(red) lwidth(thick) lstyle(solid))	///
(line c6_5 age, sort lcolor(red) lwidth(medthick) lpattern(dash) lstyle(solid))	///
(line c6_95 age, sort lcolor(red) lwidth(medthick) lpattern(dash) lstyle(solid))	///
, ytitle("BMI (kg/m{superscript:2})", color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 								///	
ylabel(10 "10" 15 "15" 20 "20" 25 "25" 30 "30" 35 "35" 40 "40" 45 "45" , nogrid labsize(small))			///
xlabel(7 9 11 13 15 17 19 21 23 25, nogrid labsize(small))						///
ytick(37, notick)																///
plotregion(lcolor(none))														///
graphregion(margin(small))														///
legend(ring(0) bplacement(nwest) order(2) cols(1) color(black) size(small) region(lcolor(none) fcolor(none)))	

graph export class6_c6.tif, replace width(1000)

/*
use zbmicat.dta, clear  
keep __IOTFsex __IOTFage __IOTF18_5 __IOTF25 __IOTF30

rename __IOTFsex iotfsex
rename __IOTFage iotfage
rename __IOTF18_5 thin
rename  __IOTF25 over
rename __IOTF30 obes

drop if iotfage < 7

sort iotfsex iotfage 		

reshape wide thin over obes, i( iotfage  ) j(iotfsex)

gen thin = (thin1 + thin2) / 2
gen over = (over1 + over2) / 2
gen obes = (obes1 + obes2) / 2

keep iotfage thin over obes

save zbmicat2.dta, replace
*/
