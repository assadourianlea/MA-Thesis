*Title: UCC: How Are Mental Health & Decisions Affected?
*Author: Lea Assadourian
*Last Updated: 6 July 2022
clear

do "/Users/lea/Desktop/Final Summer Paper/do files/cleaning.do"

cd "/Users/lea/Desktop/Final Summer Paper/results/heterogeneity"

*heterogeneity 

********************************************************************************

					   *HETEROGENOUS EFFECT MENTAL HEALTH*

********************************************************************************




eststo model_a1: rdrobust mhi_n povertyIndex if femalehoh_ind==1, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) 


eststo model_a2: rdrobust mhi_n povertyIndex if femalehoh_ind==0, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) 

esttab model_a1 model_a2 using heteroa.tex, ar2 se label title("Impact of MPC on MH if femalehoh") star(* 0.10 ** 0.05 *** 0.01) replace mtitle("yes" "no")




eststo model_b1: rdrobust mhi_n povertyIndex if hoh_intermediate==1, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) 

eststo model_b2: rdrobust mhi_n povertyIndex if hoh_intermediate==0, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind  femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) 

esttab model_b1 model_b2 using heterob.tex, ar2 se label title("Impact of MPC on MH if inter edu") star(* 0.10 ** 0.05 *** 0.01) replace mtitle("yes" "no")




eststo model_c1: rdrobust mhi_n povertyIndex if hoh_has_medcond==1, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(hoh_intermediate agehoh_ind hoh_intermediate femalehoh_ind multcase marriedhoh_ind arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) 

eststo model_c2:rdrobust mhi_n povertyIndex if hoh_has_medcond==0, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(hoh_intermediate agehoh_ind  femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) 

esttab model_c1 model_c2 using heteroc.tex, ar2 se label title("Impact of MPC on MH if mecond") star(* 0.10 ** 0.05 *** 0.01) replace mtitle("yes" "no")















eststo model_d1: rdrobust Z_avg povertyIndex if femalehoh_ind==1, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) 
dis `e(tau_cl_l)'



eststo model_d2: rdrobust Z_avg povertyIndex if femalehoh_ind==0, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) 
dis `e(tau_cl_l)'

esttab model_d1 model_d2 using heterod.tex, ar2 se label title("Impact of MPC on empowerment index if femalehoh") star(* 0.10 ** 0.05 *** 0.01) replace mtitle("yes" "no")





eststo model_f1: rdrobust Z_avg povertyIndex if hoh_has_medcond==1, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(hoh_intermediate agehoh_ind hoh_intermediate femalehoh_ind multcase marriedhoh_ind arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) 
dis `e(tau_cl_l)'

eststo model_f2:rdrobust Z_avg povertyIndex if hoh_has_medcond==0, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(hoh_intermediate agehoh_ind  femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) 
dis `e(tau_cl_l)'

esttab model_f1 model_f2 using heterof.tex, ar2 se label title("Impact of MPC on empowerment index if mecond") star(* 0.10 ** 0.05 *** 0.01) replace mtitle("yes" "no")




eststo model_het1: rdrobust femalehoh_ind povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) 

eststo model_het2: rdrobust hoh_has_medcond povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu) 


esttab model_het1 model_het2 using heteromodel.tex, ar2 se label title("Impact of MPC on the variables for heterogenous effect") star(* 0.10 ** 0.05 *** 0.01) replace mtitle("Female HoH" "HoH has MedCon")







