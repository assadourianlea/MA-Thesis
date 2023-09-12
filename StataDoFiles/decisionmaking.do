*Title: UCC: How Are Mental Health & Decisions Affected?
*Author: Lea Assadourian
*Last Updated: 6 July 2022


*decision making outcomes 

do "/Users/lea/Desktop/Final Summer Paper/do files/cleaning.do"

cd "/Users/lea/Desktop/Final Summer Paper/results/decision_making"

********************************************************************************

					   *DECISION MAKING OUTCOMES*

********************************************************************************
*WE HAVE 8 DIFFERENT DECISIONS BEING TAKEN
** a.	About if you should work to earn money or not and the acceptable wage?
** b.	About what to prepare for daily meals?
** c.	About visiting family/relatives or friends?
** d.	About major household expenditures? 
** e.	About minor household expenditures?
** f.	About whether or not to use family planning to space or limit births?
** g.	About the education of your children
** h.	About where to obtain health care/advice?




/*Explanation of decision making 

				 
**DM4: dummy variable takes on the value:
                 1 Decision is made mainly by the woman OR Decision is made 
				 jointly by wife/ or female but she is capable of making a 
				 decision to a meduim or high extent
				 
				 0 otherwise
				 				 
				 
**DM8: dummy variable takes on the value:
Mainly wife=1
Mainly wife with another=1
Mainly both=1
mainly husband=0
husband with another=0
someone outside=0
decision not made=missing


**dmindex:
Mainly wife=2
Mainly wife with another=1
Mainly both=1
mainly husband=0
husband with another=0
someone outside=0
decision not made=missing

*/







est clear
local n=1
foreach v of varlist contra_dm8 daily_meals_dm8 edu_dm8 health_dm8 major_HH_dm8 minor_HH_dm8 visiting_ff_dm8 women_work_dm8 {
eststo model_`n': rdrobust `v' povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) 
local n `++n'

esttab model_* using DM8_`n'.tex, ar2 se label title("Impact of MPC on dm8 with controls") star(* 0.10 ** 0.05 *** 0.01) replace 
}

est clear
local n=1
foreach v of varlist contra_dm8 daily_meals_dm8 edu_dm8 health_dm8 major_HH_dm8 minor_HH_dm8 visiting_ff_dm8 women_work_dm8 {
eststo model_`n': rdrobust `v' povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) 
local n `++n'
 
esttab model_* using DM8`n'.tex, ar2 se label title("Impact of MPC on dm8") star(* 0.10 ** 0.05 *** 0.01) replace 
}




est clear
local n=1
foreach v of varlist contra_dm4 daily_meals_dm4 edu_dm4 health_dm4 major_HH_dm4 minor_HH_dm4 visiting_ff_dm4 women_work_dm4 {
eststo model_`n': rdrobust `v' povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) 
local n `++n'

esttab model_* using DM4_`n'.tex, ar2 se label title("Impact of MPC on DM4 with controls") star(* 0.10 ** 0.05 *** 0.01) replace 
}

est clear
local n=1
foreach v of varlist contra_dm4 daily_meals_dm4 edu_dm4 health_dm4 major_HH_dm4 minor_HH_dm4 visiting_ff_dm4 women_work_dm4 {
eststo model_`n': rdrobust `v' povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) 
local n `++n'
 
esttab model_* using DM4`n'.tex, ar2 se label title("Impact of MPC on DM4") star(* 0.10 ** 0.05 *** 0.01) replace 
}











est clear

eststo avg: rdrobust Z_avg povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) 
esttab avg using index.tex, ar2 se label title("Impact of MPC on index") star(* 0.10 ** 0.05 *** 0.01) replace 

eststo avg: rdrobust Z_avg povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform)
esttab avg using indexno.tex, ar2 se label title("Impact of MPC on index no control") star(* 0.10 ** 0.05 *** 0.01) replace 



eststo avg: rdrobust Z_avg povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) p(2)
esttab avg using indexquad.tex, ar2 se label title("QUAD Impact of MPC on index") star(* 0.10 ** 0.05 *** 0.01) replace 

eststo avg: rdrobust Z_avg povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) p(2)
esttab avg using indexquadno.tex, ar2 se label title("QUAD Impact of MPC on index no control") star(* 0.10 ** 0.05 *** 0.01) replace 



eststo avg: rdrobust Z_avg povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) p(3)
esttab avg using indexcubic.tex, ar2 se label title("CUBIC Impact of MPC on index") star(* 0.10 ** 0.05 *** 0.01) replace 

eststo avg: rdrobust Z_avg povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) p(3)
esttab avg using indexcubicno.tex, ar2 se label title("CUBIC Impact of MPC on index no control") star(* 0.10 ** 0.05 *** 0.01) replace 




