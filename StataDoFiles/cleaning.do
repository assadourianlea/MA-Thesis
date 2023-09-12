*Title: UCC: How Are Mental Health & Decisions Affected?
*Author: Lea Assadourian
*Last Updated: 6 July 2022

*Cleaning the data set



use "/Users/lea/Desktop/master_w1_w2_w3.dta", clear


**Keep only respondent observations
drop if dem2!=1
**then drop male respondents because decision making only asked for female
drop if sexres==1


**Drop all the observations that are not from wave 3
*It is only wave 3 that asks about the module
drop if wave1==1 | wave2==1 




**New score with centralized cutoff at 0
gen newscore=score2018-57.1 if region==1 
replace newscore=score2018-57.2 if region==2 
replace newscore=score2018-66.1 if region==3 




/*Generating the wave-region specific cutoffs and standardized scores 

	forval y=2017/2018 {
		gen nscore`y' = .
		gen cut`y' = .
		forval w=1/3 {
			forval g=1/3 {
				di "`y'; wave=`w'; region=`g'"
				if `y'==2018 & `w'==1 local bla "bla"
				else {
					preserve
						collapse (mean) mpc`y' if hoh==1 & wave==`w' & region==`g', by(score`y')
						egen t = seq()
						qui regress mpc`y' score`y'
						qui tsset t
						qui estat sbsingle
						local r = r(breakdate)
						qui sum score`y' if t==`r'
						local cut`y'`w'`g' = r(mean)
					restore
					replace nscore`y' = score`y' - `cut`y'`w'`g'' if wave==`w' & region==`g' & nscore`y'==.
					replace cut`y' = (nscore`y'<0) if wave==`w' & region==`g' & cut`y'==.
					*******************************************************************************************
				}
			}
		}
	}
*/






/* MENTAL HEALTH INDEX
foreach x of varlist hea22 hea23 hea24 hea25 hea26 srh	{
replace `x'=. if `x'==88 | `x'==99
}

foreach x of varlist hea22 hea23 	{
gen `x'_rev = 7-`x'
}

gen MHI5= hea22_rev + hea23_rev + hea24 + hea25 + hea26 if  dem2==1
replace MHI5=. if MHI5<5

* MHI5_19 Score [5 - 30]: 19 cut-off point for poor health, score of respondent <19/30
gen mhi5_19=0 if MHI5<20 
replace mhi5_19=1 if MHI5>19 
replace mhi5_19=. if MHI5==.
label define goodpoor 0 "Poor" 1 "Good"
label val mhi5_19 goodpoor

* Normalizing range (min 5 : max: 30 as per data) 
gen mhi_n=(MHI5-5)*100/(30-5)

* MHI5_52 Score [0 - 100]: 52 cut-off point for depressive symptoms, score of respondent(Yes/no)
gen mhi5_52=0 if mhi_n<53
replace mhi5_52=1 if mhi_n>52
replace mhi5_52=. if mhi_n==. 
label val mhi5_52 goodpoor

** Respondent's self-rated health **
*srh_cat: Combining SRH into 2 categories: 0-Very good/good/ Fair , 1-Not good/very bad 

gen srh_cat= srh if  dem2==1
recode srh_cat (1=2)(2=2) (3=1) (4=0) (5=0) 

label define goodpoor2 0 "Poor" 1"Fair" 2 "Good"

label val srh_cat goodpoor2 

global mhi "srh mhi5_19 mhi5_52 mhi_n"
*/ 









	
	
	



/*DECISION MAKING

*Explanation of decision making 
**DM4: dummy variable takes on the value:
                 1 Decision is made mainly by the woman OR Decision is made jointly by wife/ or female but she is capable of making a decision to a meduim or high extent
				 0 otherwise
*/
				 
*fix r02 variables
foreach var in r02a r02b r02c r02d r02e r02f r02g r02h {
replace `var'=. if `var'==77
}

foreach var in r01a_pooled r01a_pooled r01b_pooled r01c_pooled r01d_pooled r01e_pooled r01f_pooled r01g_pooled {
replace `var'=. if `var'==77
}


** a.	About if you should work to earn money or not and the acceptable wage?
gen women_work_dm4=1 if r01a_pooled==2 | (r01a_pooled==3 & r02a==3) | (r01a_pooled==3 & r02a==4) | (r01a_pooled==50 & r02a==3) | (r01a_pooled==50 & r02a==4)
replace women_work_dm4=0 if r01a_pooled==1  |r01a_pooled==40 | r01a_pooled==8 | (r01a_pooled==3 & r02a==1) | (r01a_pooled==3 & r02a==2) | (r01a_pooled==50 & r02a==1) | (r01a_pooled==50 & r02a==2) | (r01a_pooled==3 & r02a==77) | (r01a_pooled==50 & r02a==77)  | (r01a_pooled==3 & r02a==1) | (r01a_pooled==3 & r02a==2) | (r01a_pooled==50 & r02a==1) | (r01a_pooled==50 & r02a==2)| (r01a_pooled!=. & r02a==.) | (r01a_pooled==50 & r02a==.)


** b.	About what to prepare for daily meals?
gen daily_meals_dm4=1 if r01b_pooled==2 | (r01b_pooled==3 & r02b==3) | (r01b_pooled==3 & r02b==4) | (r01b_pooled==50 & r02b==3) | (r01b_pooled==50 & r02b==4)
replace daily_meals_dm4=0 if r01b_pooled==1  |r01b_pooled==40 | r01b_pooled==8 | (r01b_pooled==3 & r02b==1) | (r01b_pooled==3 & r02b==2) | (r01b_pooled==50 & r02b==1) | (r01b_pooled==50 & r02b==2) | (r01b_pooled==3 & r02b==1) | (r01b_pooled==3 & r02b==2) | (r01b_pooled==50 & r02b==1) | (r01b_pooled==50 & r02b==2) | (r01b_pooled==3 & r02b==77) | (r01b_pooled==50 & r02b==77)| (r01b_pooled!=. & r02b==.) | (r01b_pooled==50 & r02b==.)

** c.	About visiting family/relatives or friends?
gen visiting_ff_dm4=1 if r01c_pooled==2 | (r01c_pooled==3 & r02c==3) | (r01c_pooled==3 & r02c==4) | (r01c_pooled==50 & r02c==3) | (r01c_pooled==50 & r02c==4)
replace visiting_ff_dm4=0 if r01c_pooled==1  |r01c_pooled==40 | r01c_pooled==8 | (r01c_pooled==3 & r02c==1) | (r01c_pooled==3 & r02c==2) | (r01c_pooled==50 & r02c==1) | (r01c_pooled==50 & r02c==2)| (r01c_pooled==3 & r02c==1) | (r01c_pooled==3 & r02c==2) | (r01c_pooled==50 & r02c==1) | (r01c_pooled==50 & r02c==2)| (r01c_pooled==3 & r02c==77) | (r01c_pooled==50 & r02c==77)| (r01c_pooled!=. & r02c==.) | (r01c_pooled==50 & r02c==.)

** d.	About major household expenditures? (Such as a large appliance for the house like a refrigerator)
gen major_HH_dm4=1 if r01d_pooled==2 | (r01d_pooled==3 & r02d==3) | (r01d_pooled==3 & r02d==4) | (r01d_pooled==50 & r02d==3) | (r01d_pooled==50 & r02d==4)
replace major_HH_dm4=0 if r01d_pooled==1  |r01d_pooled==40 | r01d_pooled==8 | (r01d_pooled==3 & r02d==1) | (r01d_pooled==3 & r02d==2) | (r01d_pooled==50 & r02d==1) | (r01d_pooled==50 & r02d==2)| (r01d_pooled==3 & r02d==1) | (r01d_pooled==3 & r02d==2) | (r01d_pooled==50 & r02d==1) | (r01d_pooled==50 & r02d==2)| (r01d_pooled==3 & r02d==77) | (r01d_pooled==50 & r02d==77)| (r01d_pooled!=. & r02d==.) | (r01d_pooled==50 & r02d==.)

** e.	About minor household expenditures? (Such as food for daily consumption or other household needs like toiletries)
gen minor_HH_dm4=1 if r01e_pooled==2 | (r01e_pooled==3 & r02e==3) | (r01e_pooled==3 & r02e==4) | (r01e_pooled==50 & r02e==3) | (r01e_pooled==50 & r02e==4)
replace minor_HH_dm4=0 if r01e_pooled==1  |r01e_pooled==40 | r01e_pooled==8 | (r01e_pooled==3 & r02e==1) | (r01e_pooled==3 & r02e==2) | (r01e_pooled==50 & r02e==1) | (r01e_pooled==50 & r02e==2)| (r01e_pooled==3 & r02e==1) | (r01e_pooled==3 & r02e==2) | (r01e_pooled==50 & r02e==1) | (r01e_pooled==50 & r02e==2)| (r01e_pooled==3 & r02e==77) | (r01e_pooled==50 & r02e==77)| (r01e_pooled!=. & r02e==.) | (r01e_pooled==50 & r02e==.)

** f.	About whether or not to use family planning (contraceptives/birth control) to space or limit births?
gen contra_dm4=1 if r01f_pooled==2 | (r01f_pooled==3 & r02f==3) | (r01f_pooled==3 & r02f==4) | (r01f_pooled==50 & r02f==3) | (r01f_pooled==50 & r02f==4)
replace contra_dm4=0 if r01f_pooled==1  |r01f_pooled==40 | r01f_pooled==8 | (r01f_pooled==3 & r02f==1) | (r01f_pooled==3 & r02f==2) | (r01f_pooled==50 & r02f==1) | (r01f_pooled==50 & r02f==2) | (r01f_pooled==3 & r02f==1) | (r01f_pooled==3 & r02f==2) | (r01f_pooled==50 & r02f==1) | (r01f_pooled==50 & r02f==2)| (r01f_pooled==3 & r02f==77) | (r01f_pooled==50 & r02f==77)| (r01f_pooled!=. & r02f==.) | (r01f_pooled==50 & r02f==.)

** g.	About the education of your children
gen edu_dm4=1 if r01g_pooled==2 | (r01g_pooled==3 & r02g==3) | (r01g_pooled==3 & r02g==4) | (r01g_pooled==50 & r02g==3) | (r01g_pooled==50 & r02g==4)
replace edu_dm4=0 if r01g_pooled==1  |r01g_pooled==40 | r01g_pooled==8 | (r01g_pooled==3 & r02g==1) | (r01g_pooled==3 & r02g==2) | (r01g_pooled==50 & r02g==1) | (r01g_pooled==50 & r02g==2)| (r01g_pooled==3 & r02g==1) | (r01g_pooled==3 & r02g==2) | (r01g_pooled==50 & r02g==1) | (r01g_pooled==50 & r02g==2)| (r01g_pooled==3 & r02g==77) | (r01g_pooled==50 & r02g==77)| (r01g_pooled!=. & r02g==.) | (r01g_pooled==50 & r02g==.)

** h.	About where to obtain health care/advice?
gen health_dm4=1 if r01h_pooled==2 | (r01h_pooled==3 & r02h==3) | (r01h_pooled==3 & r02h==4) | (r01h_pooled==50 & r02h==3) | (r01h_pooled==50 & r02h==4)
replace health_dm4=0 if r01h_pooled==1  |r01h_pooled==40 | r01h_pooled==8 | (r01h_pooled==3 & r02h==1) | (r01h_pooled==3 & r02h==2) | (r01h_pooled==50 & r02h==1) | (r01h_pooled==50 & r02h==2)| (r01h_pooled==3 & r02h==1) | (r01h_pooled==3 & r02h==2) | (r01h_pooled==50 & r02h==1) | (r01h_pooled==50 & r02h==2)| (r01h_pooled==3 & r02h==77) | (r01h_pooled==50 & r02h==77)| (r01h_pooled!=. & r02h==.) | (r01h_pooled==50 & r02h==.)





/*
**DM8: dummy variable takes on the value:
Mainly wife=1
Mainly wife with another=1
Mainly both=1
mainly husband=0
husband with another=0
someone outside=0
decision not made=missing
*/

** a.	About if you should work to earn money or not and the acceptable wage?
gen women_work_dm8=1 if r01a_pooled==2 | r01a_pooled==50 | r01a_pooled==3
replace women_work_dm8=0 if r01a_pooled==1 | r01a_pooled==8 | r01a_pooled==40
replace women_work_dm8=. if r01a_pooled==9

** b.	About what to prepare for daily meals?
gen daily_meals_dm8=1 if r01b_pooled==2 | r01b_pooled==50 | r01b_pooled==3
replace daily_meals_dm8=0 if r01b_pooled==1 | r01b_pooled==8 | r01b_pooled==40
replace daily_meals_dm8=. if r01b_pooled==9
** c.	About visiting family/relatives or friends?
gen visiting_ff_dm8=1 if r01c_pooled==2 | r01c_pooled==50 | r01c_pooled==3
replace visiting_ff_dm8=0 if r01c_pooled==1 | r01c_pooled==8 | r01c_pooled==40
replace visiting_ff_dm8=. if r01c_pooled==9
** d.	About major household expenditures? (Such as a large appliance for the house like a refrigerator)
gen major_HH_dm8=1 if r01d_pooled==2 | r01d_pooled==50 | r01d_pooled==3
replace major_HH_dm8=0 if r01d_pooled==1 | r01d_pooled==8 | r01d_pooled==40
replace major_HH_dm8=. if r01d_pooled==9
** e.	About minor household expenditures? (Such as food for daily consumption or other household needs like toiletries)
gen minor_HH_dm8=1 if r01e_pooled==2 | r01e_pooled==50 | r01e_pooled==3
replace minor_HH_dm8=0 if r01e_pooled==1 | r01e_pooled==8 | r01e_pooled==40
replace minor_HH_dm8=. if r01e_pooled==9
** f.	About whether or not to use family planning (contraceptives/birth control) to space or limit births?
gen contra_dm8=1 if r01f_pooled==2 | r01f_pooled==50 | r01f_pooled==3
replace contra_dm8=0 if r01f_pooled==1 | r01f_pooled==8 | r01f_pooled==40
replace contra_dm8=. if r01f_pooled==9
** g.	About the education of your children
gen edu_dm8=1 if r01g_pooled==2 | r01g_pooled==50 | r01g_pooled==3
replace edu_dm8=0 if r01g_pooled==1 | r01g_pooled==8 | r01g_pooled==40
replace edu_dm8=. if r01g_pooled==9

** h.	About where to obtain health care/advice?
gen health_dm8=1 if r01h_pooled==2 | r01h_pooled==50 | r01h_pooled==3
replace health_dm8=0 if r01h_pooled==1 | r01h_pooled==8 | r01h_pooled==40
replace health_dm8=. if r01h_pooled==9










*negative outcome fix
gen povertyIndex=-newscore 
tab region, gen(region_dummy)

foreach v of varlist women_work_ext2 daily_meals_ext2 visiting_ff_ext2 major_HH_ext2 minor_HH_ext2 contra_ext2 edu_ext2 health_ext2 contra_dm5 daily_meals_dm5 edu_dm5 health_dm5 major_HH_dm5 minor_HH_dm5 visiting_ff_dm5 women_work_dm5{
label var `v' `v'
}




*HH receives cash for food or food vouchers assumed to be equivalent (there are 62 HHs that receive both possibly due to data entry error)
	gen foodassist2018=cff_period3+voucher_period3
	replace foodassist2018=1 if foodassist2018==2
	replace foodassist2018=0 if foodassist2018==.
	label var foodassist2018 "HH receives cash for food or food vouchers between November 2018 and October 2019"





*deconstruct the estimates into first-stage and reduced form 
*reg dpass 1.win vote vote2 1.win#c.vote 1.win#c.vote2 i.school_type, robust
*reg gm_school 1.win vote vote2 1.win#c.vote 1.win#c.vote2 i.school_type, robust


/*
**New score with centralized cutoff at 0
gen newscore2=score2018-57.1 if region==1 & wave2==1
replace newscore2=score2018-57.1 if region==2 & wave2==1
replace newscore2=score2018-66.2 if region==3 & wave2==1
replace newscore2=score2018-57.1 if region==1 & wave3==1
replace newscore2=score2018-57.2 if region==2 & wave3==1
replace newscore2=score2018-66.1 if region==3 & wave3==1
*/




**Creating the empowerment index




foreach v of varlist r01a_pooled r01b_pooled r01c_pooled r01d_pooled r01e_pooled r01f_pooled r01g_pooled r01h_pooled {
recode `v' (2=2) (50=1)  (3=1) (40=1) (1=1) (8=1) (9=.), gen (new_`v')
}

local n=1
foreach v of varlist new_r01a_pooled new_r01b_pooled new_r01c_pooled new_r01d_pooled new_r01e_pooled new_r01f_pooled new_r01g_pooled new_r01h_pooled {
	
egen m_`v'=mean(`v') if mpc2018==0
egen sd_`v'=sd(`v') if mpc2018==0

egen m2_`v'=mean(`v') if mpc2018==1

replace `v'=m_`v' if `v'==. & mpc2018==0
replace `v'=m2_`v' if `v'==. & mpc2018==1


gen Z`n'=(`v'-m_`v')/sd_`v'
local n `++n'
}



gen Z_avg = (Z1+Z2+Z3+Z4+Z5+Z6+Z8)/8






