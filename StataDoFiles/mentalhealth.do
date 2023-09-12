*Title: UCC: How Are Mental Health & Decisions Affected?
*Author: Lea Assadourian
*Last Updated: 6 July 2022

clear

*mental health outcomes 


*If necessary
*ssc install rdrobust, replace
*net install grc1leg,from( http://www.stata.com/users/vwiggins/) 

*run the cleaning first
do "/Users/lea/Desktop/Final Summer Paper/do files/cleaning.do"


   
********************************************************************************

						*MENTAL HEALTH OUTCOMES*

********************************************************************************

*MHI5_19 Score [5 - 30]: 19 cut-off point for poor health, score of respondent <19/30
*dummy good poor: mhi5_19


*MHI5_52 Score [0 - 100]: 52 cut-off point for depressive symptoms, score of respondent(Yes/no)
*dummy good poor: mhi5_52


*Normalizing range (min 5 : max: 30 as per data) 
*Continuos var: mhi_n


*MANUALLY
*control for x but also put interaction btwn x and treat
*all option shows bias correct or not 
*uses triangular by default


			

*The point of RD is local randomization - when you go close enough to the cutoff, wether you ended up above or below it is as good as randomly assigned. And any time you randomized something, it is by necessity independent of any predetermined variables. It follows that controlling for predetermined covariates should not affect the point estimate in an RD (but it can increase precision by reducing residual noise).


cd "/Users/lea/Desktop/Final Summer Paper/results/mental_health"


*manually rdd
foreach v of varlist mhi5_19 mhi5_52 mhi_n {
reg `v' mpc2018 newscore agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu mpc_period1 cff_period2 voucher_period2 mpc_period2 winter_period2 winter_period3 foodassist2018 c.mpc2018#c.newscore [aw=weights] if abs(newscore)<3.5, vce(robust)
}





*here starts the real shit


est clear
local n=1
foreach v of varlist mhi5_19 mhi5_52 mhi_n {
eststo model_`n': rdrobust `v' povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform)
local n `++n'
 
esttab model_* using mentalhealthno`n'.tex, ar2 se label title("Impact of MPC on mental health") star(* 0.10 ** 0.05 *** 0.01) replace 
}



est clear
local n=1
foreach v of varlist mhi5_19 mhi5_52 mhi_n {
eststo model_`n': rdrobust `v' povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu)
local n `++n'

esttab model_* using mentalhealthcontrol`n'.tex, ar2 se label title("Impact of MPC on mental health with controls") star(* 0.10 ** 0.05 *** 0.01) replace 
}




est clear
local n=1
foreach v of varlist mhi5_19 mhi5_52 mhi_n {
eststo model_`n': rdrobust `v' povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) p(2)
local n `++n'

esttab model_* using quadmentalhealthcontrol`n'.tex, ar2 se label title("Quadratic Impact of MPC on mental health with controls") star(* 0.10 ** 0.05 *** 0.01) replace 
}

est clear
local n=1
foreach v of varlist mhi5_19 mhi5_52 mhi_n {
eststo model_`n': rdrobust `v' povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) p(2)
local n `++n'
 
esttab model_* using quadmentalhealthno`n'.tex, ar2 se label title("Quadratic Impact of MPC on mental health") star(* 0.10 ** 0.05 *** 0.01) replace 
}


est clear
local n=1
foreach v of varlist mhi5_19 mhi5_52 mhi_n {
eststo model_`n': rdrobust `v' povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) p(3)
local n `++n'

esttab model_* using cubicmentalhealthcontrol_`n'.tex, ar2 se label title("Cubic Impact of MPC on mental health with controls") star(* 0.10 ** 0.05 *** 0.01) replace 
}

est clear
local n=1
foreach v of varlist mhi5_19 mhi5_52 mhi_n {
eststo model_`n': rdrobust `v' povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) p(3)
local n `++n'
 
esttab model_* using cubicmentalhealthno_`n'.tex, ar2 se label title("Cubic Impact of MPC on mental health") star(* 0.10 ** 0.05 *** 0.01) replace 
}




/*
*rdplot mhi5_52 newscore if abs(newscore)<=0.5
rdplot mhi5_52 povertyIndex if abs(povertyIndex)<=4, p(2) kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu)
rdplot mhi5_52 povertyIndex if abs(povertyIndex)<=4, p(3) kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu)
rdplot mhi5_19 povertyIndex if abs(povertyIndex)<=4, p(1) kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu)
rdplot mhi5_19 povertyIndex if abs(povertyIndex)<=4, p(2) kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu)
rdplot mhi5_19 povertyIndex if abs(povertyIndex)<=4, p(2) kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) weights(weights)
rdplot mhi5_19 povertyIndex if abs(povertyIndex)<=4, p(2) kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu)
rdplot mhi_n povertyIndex if abs(povertyIndex)<=4, p(1) kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu)
rdplot mhi_n povertyIndex if abs(povertyIndex)<=4, p(2) kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu)
rdplot mhi_n povertyIndex if abs(povertyIndex)<=4, p(3) kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu)
*/







	

















