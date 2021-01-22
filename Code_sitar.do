clear
clear mata
clear matrix
set mem 1000m
set more off
cd "C:\Users\pswoj\OneDrive - Loughborough University\5 LBORO\Research\MRC NIRG\ALSPAC\Analysis"
set maxvar 10000

*output data

use anthro.dta, clear 

merge m:1 id using six.dta 

drop if _merge ==1

drop cprob1-_merge in_core in_phase2 in_phase3 in_phase4 cidB3164 qlet order wt* bmi*

reshape long age ht, i(id) j(visit)

drop if ht ==.
drop if age ==.

drop if visit ==10 

bysort id: gen n = _N

tab n 

bysort id: gen first= 1  if _n == 1 
bysort id: gen last= 1  if _n == _N

bysort id: gen firstage = age if first ==1
by id: carryforward firstage, replace

by id: gen lastage = age if last ==1
bysort id (lastage): carryforward lastage, replace

gen agerange = lastage - firstage

egen pickone = tag(id)

sort id visit 

save sitar.dta, replace

*create figures

use sitar_ALSPAC_new.dta, clear

drop in 1/106

rename fixed_dist dist
rename fixed_vel vel

mkspline s = age if c==1, cubic nknots(7) 
regress dist s1 s2 s3 s4 s5 s6 if c==1
predict r if c==1, resid
scatter r age if c==1
drop if r > 0.5 & c==1
drop if r < -0.5 & c==1
drop s1 s2 s3 s4 s5 s6 r

mkspline s = age if c==2, cubic nknots(7) 
regress dist s1 s2 s3 s4 s5 s6 if c==2
predict r if c==2, resid
scatter r age if c==2
drop if r > 0.2 & age < 12 & c==2
drop if r < -0.2 & age < 12 & c==2
drop s1 s2 s3 s4 s5 s6 r

mkspline s = age if c==3, cubic nknots(7) 
regress dist s1 s2 s3 s4 s5 s6 if c==3
predict r if c==3, resid
scatter r age if c==3
drop if r > 0.5 & c==3
drop if r < -0.5 & c==3
drop if r > 0.05 & age < 10 & c==3
drop if r < -0.05 &age < 10 & c==3
drop s1 s2 s3 s4 s5 s6 r

mkspline s = age if c==5, cubic nknots(7) 
regress dist s1 s2 s3 s4 s5 s6 if c==5
predict r if c==5, resid
scatter r age if c==5
drop if r > 0.5 & age <15 & c==5
drop if r < -0.5 & age <15 & c==5
drop if r > 0.3 & age <11 & c==5
drop if r < -0.2 & age <11 & c==5
drop if r > 0.375 & age <13.75 & c==5
drop if r < 0.15 & age >13.7 & age <13.8 & c==5
drop s1 s2 s3 s4 s5 s6 r

mkspline s = age if c==6, cubic nknots(7) 
regress dist s1 s2 s3 s4 s5 s6 if c==6
predict r if c==6, resid
scatter r age if c==6
drop if r > 0.2 & age < 12 & c==6
drop if r < -1 & c==6
drop if age > 9.6 & age < 9.8 & r < 0.05 & c==6
drop s1 s2 s3 s4 s5 s6 r

drop if age > 17.5
drop if age < 7.5

set scheme s1color

twoway	/// 
(mspline dist age if c==5, sort legend(label(1 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thick) lstyle(solid))	///
(mspline vel age if c==5, yaxis(2) sort lcolor(midgreen) lwidth(thick) lstyle(solid))													///
(scatteri 8.54 12.79 8.54 17.5, c(l) yaxis(2) msym(none) lcolor(black) lwidth(thin) lpattern(dash))							///	
(scatteri 8.54 12.79 0 12.79, c(l) yaxis(2) msym(none) lcolor(black) lwidth(thin) lpattern(dash))							///	
, ytitle("Height (cm)", color(black) size(medium)) 									///
ytitle("Height velocity (cm/year)", axis(2) color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 									///	
ylabel(120 175, nogrid labsize(small))												///
ylabel(0 8.54 10, axis(2) nogrid labsize(small))									///
xlabel(7.5 12.79 17.5, nogrid labsize(small))										///
ytick(8.54, axis(2) tposition(inside))												///
xtick(12.79, tposition(inside))														///
plotregion(lcolor(none))															///
graphregion(margin(small))															///
legend(ring(0) bplacement(nwest) order(1) cols(1) color(black) size(small) region(lcolor(white) fcolor(white)))

graph export class5_ht.tif, replace width(1000)

twoway	///
(mspline dist age if c==2, sort legend(label(1 "Class 2: Normal weight [linear]")) lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(mspline vel age if c==2, yaxis(2) sort lcolor(dkgreen) lwidth(thick) lstyle(solid))	///
(mspline dist age if c==5, sort legend(label(2 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thin) lstyle(solid))	///
(mspline vel age if c==5, yaxis(2) sort lcolor(midgreen) lwidth(thin) lstyle(solid))	///
(scatteri 8.28 12.39 8.28 17.5, c(l) yaxis(2) msym(none) lcolor(black) lwidth(thin) lpattern(dash))							///	
(scatteri 8.28 12.39 0 12.39, c(l) yaxis(2) msym(none) lcolor(black) lwidth(thin) lpattern(dash))							///	
, ytitle("Height (cm)", color(black) size(medium)) 									///
ytitle("Height velocity (cm/year)", axis(2) color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 									///	
ylabel(120 175, nogrid labsize(small))												///
ylabel(0 8.28 10, axis(2) nogrid labsize(small))									///
xlabel(7.5 12.39 17.5, nogrid labsize(small))										///
ytick(8.28, axis(2) tposition(inside))												///
xtick(12.39, tposition(inside))														///
plotregion(lcolor(none))															///
graphregion(margin(small))															///
legend(ring(0) bplacement(nwest) order(1 2) cols(1) color(black) size(small) region(lcolor(white) fcolor(white)))

graph export class2_ht.tif, replace width(1000)

twoway	///
(mspline dist age if c==1, sort legend(label(1 "Class 1: Normal weight or overweight")) lcolor(sienna) lwidth(thick) lstyle(solid))	///
(mspline vel age if c==1, yaxis(2) sort lcolor(sienna) lwidth(thick) lstyle(solid))	///
(mspline dist age if c==5, sort legend(label(2 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thin) lstyle(solid))	///
(mspline vel age if c==5, yaxis(2) sort lcolor(midgreen) lwidth(thin) lstyle(solid))	///
(scatteri 8.12 12.03 8.12 17.5, c(l) yaxis(2) msym(none) lcolor(black) lwidth(thin) lpattern(dash))							///	
(scatteri 8.12 12.03 0 12.03, c(l) yaxis(2) msym(none) lcolor(black) lwidth(thin) lpattern(dash))							///	
, ytitle("Height (cm)", color(black) size(medium)) 									///
ytitle("Height velocity (cm/year)", axis(2) color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 									///	
ylabel(120 175, nogrid labsize(small))												///
ylabel(0 8.12 10, axis(2) nogrid labsize(small))											///
xlabel(7.5 12.03 17.5, nogrid labsize(small))													///
ytick(8.12, axis(2) tposition(inside))												///
xtick(12.03, tposition(inside))														///
plotregion(lcolor(none))															///
graphregion(margin(small))															///
legend(ring(0) bplacement(nwest) order(1 2) cols(1) color(black) size(small) region(lcolor(white) fcolor(white)))

graph export class1_ht.tif, replace width(1000)

twoway	///
(mspline dist age if c==3, sort legend(label(1 "Class 3: Normal weight increasing to overweight")) lcolor(orange) lwidth(thick) lstyle(solid))	///
(mspline vel age if c==3, yaxis(2) sort lcolor(orange) lwidth(thick) lstyle(solid))	///
(mspline dist age if c==5, sort legend(label(2 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thin) lstyle(solid))	///
(mspline vel age if c==5, yaxis(2) sort lcolor(midgreen) lwidth(thin) lstyle(solid))	///
(scatteri 8.52 12.32 8.52 17.5, c(l) yaxis(2) msym(none) lcolor(black) lwidth(thin) lpattern(dash))							///	
(scatteri 8.52 12.32 0 12.32, c(l) yaxis(2) msym(none) lcolor(black) lwidth(thin) lpattern(dash))							///	
, ytitle("Height (cm)", color(black) size(medium)) 									///
ytitle("Height velocity (cm/year)", axis(2) color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 									///	
ylabel(120 175, nogrid labsize(small))												///
ylabel(0 8.52 10, axis(2) nogrid labsize(small))											///
xlabel(7.5 12.32 17.5, nogrid labsize(small))													///
ytick(8.52, axis(2) tposition(inside))												///
xtick(12.32, tposition(inside))														///
plotregion(lcolor(none))															///
graphregion(margin(small))															///
legend(ring(0) bplacement(nwest) order(1 2) cols(1) color(black) size(small) region(lcolor(white) fcolor(white)))

graph export class3_ht.tif, replace width(1000)

twoway	///
(mspline dist age if c==4, sort legend(label(1 "Class 4: Overweight or obesity")) lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(mspline vel age if c==4, yaxis(2) sort  lcolor(cranberry) lwidth(thick) lstyle(solid))	///
(mspline dist age if c==5, sort legend(label(2 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thin) lstyle(solid))	///
(mspline vel age if c==5, yaxis(2) sort lcolor(midgreen) lwidth(thin) lstyle(solid))	///
(scatteri 7.53 12.07 7.53 17.5, c(l) yaxis(2) msym(none) lcolor(black) lwidth(thin) lpattern(dash))							///	
(scatteri 7.53 12.07 0 12.07, c(l) yaxis(2) msym(none) lcolor(black) lwidth(thin) lpattern(dash))							///	
, ytitle("Height (cm)", color(black) size(medium)) 									///
ytitle("Height velocity (cm/year)", axis(2) color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 									///	
ylabel(120 175, nogrid labsize(small))												///
ylabel(0 7.53 10, axis(2) nogrid labsize(small))											///
xlabel(7.5 12.07 17.5, nogrid labsize(small))													///
ytick(7.53, axis(2) tposition(inside))												///
xtick(12.07, tposition(inside))														///
plotregion(lcolor(none))															///
graphregion(margin(small))															///
legend(ring(0) bplacement(nwest) order(1 2) cols(1) color(black) size(small) region(lcolor(white) fcolor(white)))

graph export class4_ht.tif, replace width(1000)

twoway	///
(mspline dist age if c==6, sort legend(label(1 "Class 6: Normal weight increasing to obesity")) lcolor(red) lwidth(thick) lstyle(solid))	///
(mspline vel age if c==6, yaxis(2) sort  lcolor(red) lwidth(thick) lstyle(solid))	///
(mspline dist age if c==5, sort legend(label(2 "Class 5: Normal weight [non-linear]")) lcolor(midgreen) lwidth(thin) lstyle(solid))	///
(mspline vel age if c==5, yaxis(2) sort lcolor(midgreen) lwidth(thin) lstyle(solid))	///
(scatteri 7.81 11.92 7.81 17.5, c(l) yaxis(2) msym(none) lcolor(black) lwidth(thin) lpattern(dash))							///	
(scatteri 7.81 11.92 0 11.92, c(l) yaxis(2) msym(none) lcolor(black) lwidth(thin) lpattern(dash))							///	
, ytitle("Height (cm)", color(black) size(medium)) 									///
ytitle("Height velocity (cm/year)", axis(2) color(black) size(medium)) 				///
xtitle("Age (years)", color(black) size(medium)) 									///	
ylabel(120 175, nogrid labsize(small))												///
ylabel(0 7.81 10, axis(2) nogrid labsize(small))											///
xlabel(7.5 11.92 17.5, nogrid labsize(small))													///
ytick(7.81, axis(2) tposition(inside))												///
xtick(11.92, tposition(inside))														///
plotregion(lcolor(none))															///
graphregion(margin(small))															///
legend(ring(0) bplacement(nwest) order(1 2) cols(1) color(black) size(small) region(lcolor(white) fcolor(white)))

graph export class6_ht.tif, replace width(1000)
