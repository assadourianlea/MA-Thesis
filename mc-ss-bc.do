*Title: UCC: How Are Mental Health & Decisions Affected?
*Author: Lea Assadourian
*Last Updated: 6 July 2022


**MPC probabiliy, mccrary, balance checks, and summary stats.

*falsificaiton test and badwidths

do "/Users/lea/Desktop/Final Summer Paper/do files/cleaning.do"

cd "/Users/lea/Desktop/Final Summer Paper/results/mc-ss-bc"



*MPC probability

preserve
collapse (mean) mpc2018 [pw=weights], by(score2018 region)
	
twoway (lowess mpc2018 score2018 if score2018<=57.1) (lowess mpc2018 score2018 if score2018>57.1) if inrange(score2018,47,67) & region==1, xline(57.1, lcolor(black) lpattern(dash)) xtitle("2018 desk formula score") ytitle("Probability of getting MPC") title("Bekaa") xsize(16) ysize(9) graphregion(color(white)) saving(mpc_bekaa, replace)
graph export mpc_bekaa3.png, replace
	
twoway (lowess mpc2018 score2018 if score2018<=57.2) (lowess mpc2018 score2018 if score2018>57.2) if inrange(score2018,47,67) & region==2, xline(57.2, lcolor(black) lpattern(dash)) xtitle("2018 desk formula score") ytitle("Probability of getting MPC") title("North") xsize(16) ysize(9) graphregion(color(white)) saving(mpc_north, replace)
graph export mpc_north3.png, replace
	
twoway (lowess mpc2018 score2018 if score2018<=66.1) (lowess mpc2018 score2018 if score2018>66.1) if inrange(score2018,56,76) & region==3, xline(66.1, lcolor(black) lpattern(dash)) xtitle("2018 desk formula score") ytitle("Probability of getting MPC") title("Mount Lebanon") xsize(16) ysize(9) graphregion(color(white)) saving(mpc_ml, replace)
graph export mpc_ml3.png, replace
restore

graph combine mpc_bekaa.gph mpc_north.gph mpc_ml.gph, rows(1) imargin(small) xsize(15) ysize(5) saving(mpc_combined3, replace)
graph export mpc_combined3.png, replace width(1080)	






cd "/Users/lea/Desktop/balance"





*McCrary and Balance Checks:

*mpc_period3 is treatment

local X "agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind"
local Z1 "hoh_above60 hoh_disabled hoh_has_medcond" 
local Z2 "multcase arrival_year hhsize dependency_ratio" 
local Z3 "u5_share b1850_mshare b1850_fshare b610_share"
local Z4 "b1117_share above60_share disabled_share above60_medcon1"
local Z5 "hhmem_noedu dependents3" 



/* IF WE DECIDE TO REDUCE THE CONTROL VARIABLES 
	local X "agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind"
	local Z1 "arrival_year hhsize dependency_ratio disabled_share " 
	local Z2 "above60_medcon1 hoh_disabled hoh_has_medcond hhmem_noedu"
	local Z3 "mpc_period1 cff_period2 voucher_period2 foodassist2018"
	*/	

	
preserve

foreach x in `X' `Z1' `Z2' `Z3' `Z4' `Z5' {
local lab`x': var lab `x'
}

egen n = sum(1) if nscore2018!=., by(nscore2018 wave)
egen x = sum(1) if nscore2018!=., by(wave)
gen p = n/x


	foreach x in p `X' `Z1' `Z2' `Z3' `Z4' `Z5' {
		if "`x'"=="p" {
			local ytit "Density"
			local lab`x' "McCrary Density Test"
		}
		else local ytit "Mean"
		
		lpoly `x' nscore2018 if nscore2018<0 [aw=weights], gen(x0 y0) se(se0) k(tri) nodraw
		lpoly `x' nscore2018 if nscore2018>0 [aw=weights], gen(x1 y1) se(se1) k(tri) nodraw
	
		qui sum y0 if x0>=-.2
		local l = r(mean)
		qui sum se0 if x0>=-.2
		local lse = r(mean)
		
		qui sum y1 if x1<=.2
		local r = r(mean)
		qui sum se1 if x1<=.2
		local rse = r(mean)
		
		local t: display %3.2f (`r'-`l')/sqrt(`rse'^2+`lse'^2)
		local p: display %3.2f 2*(1-normal(abs(`t')))
		drop x0-se1
		
		di "`t' `p'"
		
		two (lpolyci `x' nscore2018 if nscore2018<0, k(tri) color(gs12))	///
			(lpolyci `x' nscore2018 if nscore2018>=0, k(tri) color(gs12))	///
			(lpoly `x' nscore2018 if nscore2018<0, k(tri) lcolor(black))	///
			(lpoly `x' nscore2018 if nscore2018>0, k(tri) lcolor(black)) 	///
			if inrange(nscore2018,-12,12) & nscore2018!=0, xlab(-12(2)12) 	///
		xline(0,lcolor(black)) ytitle(`ytit') xtitle(MPC score) xscale(titlegap(4)) legend(order(1) pos(1) ring(0)) ///
		ylab(,angle(0)) title(`lab`x'') subtitle("t-stat = `t'; p-value = `p'") name(`x', replace) nodraw graphregion(color(white)) bgcolor(white) 
	}
	
	

	foreach x in X Z1 Z2 Z3 Z4 Z5 {
		local ys = 4.25
	
		grc1leg ``x'', col(2) name(`x',replace) graphregion(color(white)) saving(`x', replace)
		graph display `x', xsize(6.5) ysize(`ys') 
		graph export `x'.png, replace width(1080)
	}
	
	graph display p, xsize(16) ysize(9)
	graph export mccrary_test.png, replace width(1080)
	window manage close graph
restore	



* McCrary density test // test for manipulation
rddensity newscore, c(0) plot kernel(uniform)


collapse (mean) newscore [pw=weights], by(score2018 region)
*collapse (mean) newscore [pw=weights], by(edsid) 
rddensity newscore, c(0) plot kernel(uniform)


*binned scatter plot of the data
rdplot mpc2018 newscore, c(0) graph_options(xtitle("MPC Score") ytitle("Probability of Receiving CT") legend(off)) nbins(20) 





/*
asdoc reg hhsize score2018 dummy if sample0 & hoh == 1, replace nest save(validity_reg0)
asdoc reg agehoh score2018 dummy if sample0, nest save(validity_reg0)
asdoc reg dependency_ratio score2018 dummy if sample0 & hoh == 1, nest save(validity_reg0)
asdoc reg hhmem_noedu score2018 dummy if sample0 & hoh == 1, nest save(validity_reg0)
asdoc reg residency score2018 dummy if sample0 & hoh == 1, nest save(validity_reg0)
asdoc reg hoh_married score2018 dummy if sample0, nest save(validity_reg0)
asdoc reg femalehoh score2018 dummy if sample0 & hoh == 1, nest save(validity_reg0)
*/





********************************************************************************

						*SUMMARY STATISTICS*

********************************************************************************



lab var score2018    "\hspace{0.25cm} PMT score (USD)"
lab var mpc2018   "\hspace{0.25cm} Treatment  (\%)"

lab var agehoh_ind        "\hspace{0.25cm} HoH age (years)"
lab var hoh_intermediate "\hspace{0.25cm} HoH has intermediate education (\%)"
lab var femalehoh_ind   "\hspace{0.25cm} Female HoH (\%)"
lab var marriedhoh_ind  "\hspace{0.25cm} Married HoH (\%)"
lab var arrival_year "\hspace{0.25cm} Arrival year (Year)"
lab var u5_share "\hspace{0.25cm} Member $<$5 (\%)"
lab var hhsize     "\hspace{0.25cm} Household size (ind)"
lab var dependency_ratio     "\hspace{0.25cm} Dependence ratio (ind)"
lab var disabled_share "\hspace{0.25cm} Member with disability (\%)"
lab var hhmem_noedu "\hspace{0.25cm} Members who never attended school (\%)"

lab var itss "\hspace{0.25cm} Living in ITS (\%)"
lab var region_dummy1 "\hspace{0.25cm} Bekaa (\%)"
lab var region_dummy2    "\hspace{0.25cm} North (\%)"
lab var region_dummy3  "\hspace{0.25cm} Mount Lebanon (\%)"


est clear


estpost summarize ///
 score2018 mpc2018 ///
 agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind ///
 arrival_year hhsize u5_share dependency_ratio disabled_share hhmem_noedu ///
 itss region_dummy1 region_dummy2 region_dummy3 [aweight = weights]
  
  esttab using FINALSTAT.tex, replace ////
refcat(score2018 "\emph{Treatment indicators}" agehoh_ind "\vspace{0.1em} \\ \emph{HoH socio-economic indicators}" arrival_year "\vspace{0.1em} \\ \emph{Household indicators}" itss "\vspace{0.1em} \\ \emph{Geographic indicators}", nolabel) ///
 cells("mean(fmt(2)) sd(fmt(2)) min(fmt(0)) max(fmt(0)) count(fmt(0))") nostar unstack nonumber ///
  compress nomtitle nonote noobs gap label booktabs f ///
  collabels("Mean" "SD" "Min" "Max" "N")
  
  

********************************************************************************

						*SUMMARY STATISTICS BY TREATMENT CONTROL*

********************************************************************************


  
est clear
eststo grp1: estpost summ ///
score2018 mpc2018 ///
 agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind ///
  arrival_year hhsize u5_share dependency_ratio disabled_share hhmem_noedu ///
 itss region_dummy1 region_dummy2 region_dummy3 [aweight = weights]
 
eststo grp2: estpost summ ///
score2018 mpc2018 ///
 agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind ///
  arrival_year hhsize u5_share dependency_ratio disabled_share hhmem_noedu ///
 itss region_dummy1 region_dummy2 region_dummy3 [aweight = weights] if mpc2018==1
 
eststo grp3: estpost summ ///
score2018 mpc2018 ///
 agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind ///
  arrival_year hhsize u5_share dependency_ratio disabled_share hhmem_noedu ///
 itss region_dummy1 region_dummy2 region_dummy3 [aweight = weights] if mpc2018==0
 

esttab grp* using sumstat.tex, replace ///
  main(mean %15.2fc) aux(sd %15.2fc) nostar nonumber unstack ///
  refcat(agehoh_ind "\vspace{0.1em} \\ \emph{HoH socio-economic indicators}" arrival_year "\vspace{0.1em} \\ \emph{Household indicators}" itss "\vspace{0.1em} \\ \emph{Geographic indicators}", nolabel) ///
   compress nonote noobs gap label booktabs f   ///
   collabels(none) mtitle("All" "Treated" "Control")



   
   
   
   
********************************************************************************

						*FALSIFICATION TEST*

********************************************************************************



eststo model_f1: rdrobust mhi_n povertyIndex, c(2) bwselect(mserd) weights(weights) all kernel(uniform)
eststo model_f2: rdrobust mhi_n povertyIndex, c(-2) bwselect(mserd) weights(weights) all kernel(uniform)
eststo model_f3: rdrobust mhi_n povertyIndex, c(4) bwselect(mserd) weights(weights) all kernel(uniform)
eststo model_f4: rdrobust mhi_n povertyIndex, c(-4) bwselect(mserd) weights(weights) all kernel(uniform)
eststo model_f5: rdrobust mhi_n povertyIndex, c(6) bwselect(mserd) weights(weights) all kernel(uniform)
eststo model_f6: rdrobust mhi_n povertyIndex, c(-6) bwselect(mserd) weights(weights) all kernel(uniform)



esttab model_f1 model_f2 model_f3 model_f4 model_f5 model_f6 using falsitest3.tex, ar2 se label title("Impact of MPC on mental health") star(* 0.10 ** 0.05 *** 0.01) replace 





********************************************************************************

						*DIFFERENT BADNWIDHT SELECTION*

********************************************************************************


eststo model_b1: rdrobust mhi_n povertyIndex, c(0) bwselect(mserd) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu)

eststo model_b2: rdrobust mhi_n povertyIndex, c(0) bwselect(msetwo) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu)

eststo model_b3: rdrobust mhi_n povertyIndex, c(0) bwselect(msesum) weights(weights) all kernel(uniform) covs(agehoh_ind hoh_intermediate femalehoh_ind marriedhoh_ind multcase arrival_year hhsize dependency_ratio u5_share b1850_mshare b1850_fshare b610_share b1117_share above60_share disabled_share above60_medcon1 dependents3 hoh_above60 hoh_disabled hoh_has_medcond hhmem_noedu)


esttab model_b1 model_b2 model_b3 using bandwidth.tex, ar2 se label title("Impact of MPC on mental health with controls different bandwidth selection") star(* 0.10 ** 0.05 *** 0.01) replace 








