clear all

cd "C:\Users\bayli024\DriveFS\My Drive\Economics\Empirical\HW3"

use cps_00003.dta

drop if inlist(qincwage,1,2,3)

keep if (age>=16&age<=64)

drop if inlist(classwkr,0,10,13,14,22,23,25,26,27,28,29,99)

drop if ahrsworkt == 999

drop if inlist(educ,2,999)

gen hs_dropout = ( educ == 10 | educ == 11 | educ == 12 | educ == 13 | educ == 14 | educ == 20 | educ == 21 | educ == 22 | educ == 30 | educ == 31 | educ == 32 | educ == 40 | educ == 50 | educ == 60 )

gen hs = ( educ == 71 | educ == 72 | educ == 73 )

gen some_college = ( educ == 80 | educ == 81 | educ == 90 | educ == 91 | educ == 92 | educ == 100 )

gen college = ( educ == 110 | educ == 111 | educ == 121)

gen post_college = ( educ == 122 | educ == 123 | educ == 124 | educ == 125 )

drop if year<1976

drop if inlist(wkstat,12,14,15,20,21,22,40,41,99)

gen full_time = ( wkswork1>=40 & wkstat==10 | wkswork1>=40 & wkstat==11 )

drop if full_time == 0

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gen educ_years = 1 if year<1992 & educ == 11 

replace educ_years = 2 if year<1992 & educ == 12

replace educ_years = 3 if year<1992 & educ == 13 | year>=1992 & educ == 10 

replace educ_years = 4 if year<1992 & educ == 14

replace educ_years = 5 if year<1992 & educ == 21

replace educ_years = 6 if year<1992 & educ == 22

replace educ_years = 7 if year<1992 & educ == 31 | year >= 1992 & educ == 20 | year>=1992 & educ == 30 

replace educ_years = 8 if year<1992 & educ == 32

replace educ_years = 9 if year<1992 & educ == 40 | year >=1992 & educ == 40 

replace educ_years = 10 if year<1992 & educ == 50 | year >= 1992 & educ == 50 

replace educ_years = 11 if year<1992 & educ == 60 | year>=1992 & educ == 60 

replace educ_years = 12 if year<1992 & educ == 72 | year<1992 & educ == 73 | year>=1992 & educ == 71 | year>=1992 & 73 

replace educ_years = 13 if year<1992 & educ == 80

replace educ_years = 13.5 if year >= 1992 & educ == 81

replace educ_years = 14 if year<1992 & educ == 90 | year >= 1992 & educ == 91 | year >= 1992 & educ == 92 

replace educ_years = 15 if year<1992 & educ == 100

replace educ_years = 16 if year<1992 & educ == 110 | year>=1992 & educ == 111 

replace educ_years = 17 if year<1992 & educ == 121

replace educ_years = 17.5 if year >= 1992 & educ == 123 | year >=1992 & educ == 124 

replace educ_years = 18 if year<1992 & educ == 122

replace educ_years = 19 if year>=1992 & educ == 125

gen exp = round(age - educ_years - 6)

keep if exp >= 0 & exp < 39

gen exp_bracket_0_2 = (exp<=2)

gen exp_bracket_3_5 = (exp == 3 | exp == 4 | exp == 5) 

gen exp_bracket_6_8 = (exp == 6 | exp == 7 | exp == 8)

gen exp_bracket_9_11 = (exp == 9 | exp == 10 | exp == 11)

gen exp_bracket_12_14 = (exp == 12 | exp == 13 | exp == 14) 

gen exp_bracket_15_17 = (exp == 15 | exp == 16 | exp == 17)

gen exp_bracket_18_20 = (exp == 18 | exp == 19 | exp == 20) 

gen exp_bracket_21_23 = (exp == 21 | exp == 22 | exp == 23)

gen exp_bracket_24_26 = (exp == 24 | exp == 25 | exp == 26)

gen exp_bracket_27_29 = (exp == 27 | exp == 28 | exp == 29) 

gen exp_bracket_30_32 = (exp == 30 | exp == 31 | exp == 32) 

gen exp_bracket_33_35 = (exp == 33 | exp == 34 | exp == 35) 

gen dropped_exp_bracket_36_38 = (exp == 36 | exp == 37 | exp == 38)

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

forvalues y = 1976/1981 {
	replace incwage = 1.5*incwage if year == `y' & incwage == 50000
}

forvalues y = 1982/1984 {
	replace incwage = 1.5*incwage if year == `y' & incwage == 75000
}

forvalues y = 1985/1987 {
	replace incwage = 1.5*incwage if year == `y' & incwage == 99999
}

forvalues y = 1988/1995{
	replace inclongj = 1.5*inclongj if year ==`y' & inclongj==99999
	replace oincwage = 1.5*oincwage if year ==`y' & oincwage==99999
	replace incwage = inclongj + oincwage if year ==`y'
}


forvalues y = 1996/2002{
	replace inclongj = 1.5*inclongj if year ==`y' & inclongj==150000
	replace oincwage = 1.5*oincwage if year ==`y' & oincwage==25000
	replace incwage = inclongj + oincwage if year ==`y'
}


forvalues y = 2003/2010{
	replace inclongj = 1.5*inclongj if year ==`y' & inclongj==200000
	replace oincwage = 1.5*oincwage if year ==`y' & oincwage==35000
	replace incwage = inclongj + oincwage if year ==`y'
}

forvalues y = 2011/2014{
	replace inclongj = 1.5*250000 if year==`y' & tinclongj==1
	replace oincwage = 1.5*47000 if year==`y' & toincwage==1
	replace incwage = inclongj + oincwage if year ==`y'
}

forvalues y = 2015/2015{
	replace inclongj = 1.5*280000 if year==`y' & tinclongj==1
	replace oincwage = 1.5*56000 if year==`y' & toincwage==1
	replace incwage = inclongj + oincwage if year ==`y'
}

forvalues y = 2016/2016{
	replace inclongj = 1.5*300000 if year==`y' & tinclongj==1
	replace oincwage = 1.5*55000 if year==`y' & toincwage==1
	replace incwage = inclongj + oincwage if year ==`y'
}

forvalues y = 2017/2017{
	replace inclongj = 1.5*300000 if year==`y' & tinclongj==1
	replace oincwage = 1.5*55000 if year==`y' & toincwage==1
	replace incwage = inclongj + oincwage if year ==`y'
}

forvalues y = 2018/2018{
	replace inclongj = 1.5*300000 if year==`y' & tinclongj==1
	replace oincwage = 1.5*56000 if year==`y' & toincwage==1
	replace incwage = inclongj + oincwage if year ==`y'
}

forvalues y = 2019/2019{
	replace inclongj = 1.5*310000 if year==`y' & tinclongj==1
	replace oincwage = 1.5*60000 if year==`y' & toincwage==1
	replace incwage = inclongj + oincwage if year ==`y'
}

forvalues y = 2020/2020{
	replace inclongj = 1.5*360000 if year==`y' & tinclongj==1
	replace oincwage = 1.5*70000 if year==`y' & toincwage==1
	replace incwage = inclongj + oincwage if year ==`y'
}

forvalues y = 2021/2021{
	replace inclongj = 1.5*350000 if year==`y' & tinclongj==1
	replace oincwage = 1.5*65000 if year==`y' & toincwage==1
	replace incwage = inclongj + oincwage if year ==`y'
}

forvalues y = 2022/2022{
	replace inclongj = 1.5*400000 if year==`y' & tinclongj==1
	replace oincwage = 1.5*75000 if year==`y' & toincwage==1
	replace incwage = inclongj + oincwage if year ==`y'
}

forvalues y = 2023/2023{
	replace inclongj = 1.5*400000 if year==`y' & tinclongj==1
	replace oincwage = 1.5*83991 if year==`y' & toincwage==1
	replace incwage = inclongj + oincwage if year ==`y'
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gen hourly_earnings = ( incwage / (wkswork1 * uhrsworkly ))

gen weekly_earnings = ( incwage / wkswork1 )

gen real_weekly = weekly_earnings * cpi99

gen real_hourly = hourly_earnings * cpi99

//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

drop if real_weekly <= 112

drop if real_hourly <= 2.80

forvalues y = 1976/1981 {
	gen topcode_weekly_earnings`y' = 50000/(50)
	drop if hourly_earnings >= topcode_weekly_earnings`y'/35 & year == `y'
}

forvalues y = 1982/1984 {
	gen topcode_weekly_earnings`y' = 75000/50
	drop if hourly_earnings >= topcode_weekly_earnings`y'/35 & year == `y'
}

forvalues y = 1985/1987 {
	gen topcode_weekly_earnings`y' = 99999/50
	drop if hourly_earnings >= topcode_weekly_earnings`y'/35 & year == `y'
}

forvalues y = 1988/1995{
	gen topcode_weekly_earnings`y' = 99999/50
	drop if hourly_earnings >= topcode_weekly_earnings`y'/35 & year == `y'
}


forvalues y = 1996/2002{
	gen topcode_weekly_earnings`y' = 175000/50
	drop if hourly_earnings >= topcode_weekly_earnings`y'/35 & year == `y'
}


forvalues y = 2003/2010{
	gen topcode_weekly_earnings`y' = 235000/50
	drop if hourly_earnings >= topcode_weekly_earnings`y'/35 & year == `y'
}

forvalues y = 2011/2014{
	gen topcode_weekly_earnings`y' = 297000/50
	drop if hourly_earnings >= topcode_weekly_earnings`y'/35 & year == `y'
}

forvalues y = 2015/2015{
	gen topcode_weekly_earnings`y' = 336000/50
	drop if hourly_earnings >= topcode_weekly_earnings`y'/35 & year == `y'
}

forvalues y = 2016/2016{
	gen topcode_weekly_earnings`y' = 355000/50
	drop if hourly_earnings >= topcode_weekly_earnings`y'/35 & year == `y'
}

forvalues y = 2017/2017{
	gen topcode_weekly_earnings`y' = 355000/50
	drop if hourly_earnings >= topcode_weekly_earnings`y'/35 & year == `y'
}

forvalues y = 2018/2018{
	gen topcode_weekly_earnings`y' = 356000/50
	drop if hourly_earnings >= topcode_weekly_earnings`y'/35 & year == `y'
}

forvalues y = 2019/2019{
	gen topcode_weekly_earnings`y' = 370000/50
	drop if hourly_earnings >= topcode_weekly_earnings`y'/35 & year == `y'
}

forvalues y = 2020/2020{
	gen topcode_weekly_earnings`y' = 430000/50
	drop if hourly_earnings >= topcode_weekly_earnings`y'/35 & year == `y'
}

forvalues y = 2021/2021{
	gen topcode_weekly_earnings`y' = 420000/50
	drop if hourly_earnings >= topcode_weekly_earnings`y'/35 & year == `y'
}

forvalues y = 2022/2022{
	gen topcode_weekly_earnings`y' = 475000/50
	drop if hourly_earnings >= topcode_weekly_earnings`y'/35 & year == `y'
}

forvalues y = 2023/2023{
	gen topcode_weekly_earnings`y' = 483991/50
	drop if hourly_earnings >= topcode_weekly_earnings`y'/35 & year == `y'
}

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gen log_inc = log(real_hourly)

gen hourly_weights = asecwt*uhrsworkly*wkswork1

preserve

collapse (p90) p90_log_inc = log_inc (p50) p50_log_inc = log_inc (p10) p10_log_inc = log_inc [iw = hourly_weight], by(year sex)

tsset sex year

gen p_90_10 = p90_log_inc - p10_log_inc 

gen p_90_50 = p90_log_inc - p50_log_inc 

gen p_50_10 = p50_log_inc - p10_log_inc 

/////%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tsline p_90_10 if sex == 1 & year < 2004, title("male p_90_10 AKK") xtitle("year") ytitle("male 90 10 wage difference, AKK") saving(90_10_male_AKK, replace) as(pdf)

tsline p_90_10 if sex == 2 & year < 2004, title("female p_90_10 AKK")  xtitle("year") ytitle("female 90 10 wage difference, AKK") saving(90_10_female_AKK, replace) as(pdf)

tsline p_90_10 if sex == 1, title("male p_90_10") xtitle("year") ytitle("male 90 10 wage difference") saving(90_10_male, replace) as(pdf)

tsline p_90_10 if sex == 2, title("female p_90_10") xtitle("year") ytitle("female 90 10 wage difference") saving(90_10_female, replace) as(pdf)

/////%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tsline p_90_50 if sex == 1 & year < 2004, title("male p_90_50 AKK") xtitle("year") ytitle("male 90 50 wage difference, AKK") saving(90_50_male_AKK, replace) as(pdf)

tsline p_90_50 if sex == 2 & year < 2004, title("female p_90_50 AKK")  xtitle("year") ytitle("female 90 50 wage difference, AKK") saving(90_50_female_AKK, replace) as(pdf)

tsline p_90_50 if sex == 1, title("male p_90_50") xtitle("year") ytitle("male 90 50 wage difference") saving(90_50_male, replace) as(pdf)

tsline p_90_50 if sex == 2, title("female p_90_50") xtitle("year") ytitle("female 90 50 wage difference") saving(90_50_female, replace) as(pdf)

/////%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tsline p_50_10 if sex == 1 & year < 2004, title("male p_50_10 AKK") xtitle("year") ytitle("male 50 10 wage difference, AKK") saving(50_10_male_AKK, replace) as(pdf)

tsline p_50_10 if sex == 2 & year < 2004, title("female p_50_10 AKK")  xtitle("year") ytitle("female 50 10 wage difference, AKK") saving(50_10_female_AKK, replace) as(pdf)

tsline p_50_10 if sex == 1, title("male p_50_10") xtitle("year") ytitle("male 50 10 wage difference") saving(50_10_male, replace) as(pdf)

tsline p_50_10 if sex == 2, title("female p_50_10") xtitle("year") ytitle("female 50 10 wage difference") saving(50_10_female, replace) as(pdf)

/////%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

graph combine "90_10_male_AKK" "90_10_female_AKK" "90_50_male_AKK" "90_50_female_AKK" "50_10_male_AKK" "50_10_female_AKK", cols(2) saving(figure1_AKK, replace) as(pdf)

graph combine "90_10_male" "90_10_female" "90_50_male" "90_50_female" "50_10_male" "50_10_female", cols(2) saving(figure1, replace) as(pdf)

restore

////%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%&&&&&&&&&&&&&&

gen residuals = .
forvalues y = 1976/2023 {
	forvalues s = 1/2{
		reg log_inc hs_dropout##exp_bracket_* hs##exp_bracket_* some_college##exp_bracket_* college##exp_bracket_* post_college##exp_bracket_* if sex == `s' & year == `y'
		predict aux, residuals
		replace residuals = aux if year == `y' & sex == `s'
		drop aux
	}
}

preserve

collapse (p90) p90_resid = residuals (p50) p50_resid = residuals (p10) p10_resid = residuals [iw = hourly_weight], by(year sex) 

tsset sex year

gen p_90_10_diff = p90_resid - p10_resid

gen p_90_50_diff = p90_resid - p50_resid

gen p_50_10_diff = p50_resid - p10_resid

gen p_90_10_r =  p_90_10_diff

gen p_90_50_r =  p_90_50_diff

gen p_50_10_r =  p_50_10_diff

/////%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tsline p_90_10_r if sex == 1 & year < 2004, title("male p_90_10 resid AKK") xtitle("year") ytitle("male 90 10 resid wage difference, AKK") saving(90_10_male_AKK_resid, replace) as(pdf)

tsline p_90_10_r if sex == 2 & year < 2004, title("female p_90_10 resid AKK")  xtitle("year") ytitle("female 90 10 resid wage difference, AKK") saving(90_10_female_AKK_resid, replace) as(pdf)

tsline p_90_10_r if sex == 1, title("male p_90_10 resid") xtitle("year") ytitle("male 90 10 resid wage difference") saving(90_10_male_resid, replace) as(pdf)

tsline p_90_10_r if sex == 2, title("female p_90_10 resid") xtitle("year") ytitle("female 90 10 resid wage difference") saving(90_10_female_resid, replace) as(pdf)

/////%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tsline p_90_50_r if sex == 1 & year < 2004, title("male p_90_50 resid AKK") xtitle("year") ytitle("male 90 50 resid wage difference, AKK") saving(90_50_male_AKK_resid, replace) as(pdf)

tsline p_90_50_r if sex == 2 & year < 2004, title("female p_90_50 resid AKK")  xtitle("year") ytitle("female 90 50 resid wage difference, AKK") saving(90_50_female_AKK_resid, replace) as(pdf)

tsline p_90_50_r if sex == 1, title("male p_90_50 resid") xtitle("year") ytitle("male 90 50 resid wage difference") saving(90_50_male_resid, replace) as(pdf)

tsline p_90_50_r if sex == 2, title("female p_90_50 resid") xtitle("year") ytitle("female 90 50 resid wage difference") saving(90_50_female_resid, replace) as(pdf)

/////%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tsline p_50_10_r if sex == 1 & year < 2004, title("male p_50_10 resid AKK") xtitle("year") ytitle("male 50 10 resid wage difference, AKK") saving(50_10_male_AKK_resid, replace) as(pdf)

tsline p_50_10_r if sex == 2 & year < 2004, title("female p_50_10 resid AKK")  xtitle("year") ytitle("female 50 10 resid wage difference, AKK") saving(50_10_female_AKK_resid, replace) as(pdf)

tsline p_50_10_r if sex == 1, title("male p_50_10 resid") xtitle("year") ytitle("male 50 10 resid wage difference") saving(50_10_male_resid, replace) as(pdf)

tsline p_50_10_r if sex == 2, title("female p_50_10 resid") xtitle("year") ytitle("female 50 10 resid wage difference") saving(50_10_female_resid, replace) as(pdf)

/////%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

graph combine "90_10_male_AKK_resid" "90_10_female_AKK_resid" "90_50_male_AKK_resid" "90_50_female_AKK_resid" "50_10_male_AKK_resid" "50_10_female_AKK_resid", cols(2) saving(figure2_AKK, replace) as(pdf)

graph combine "90_10_male_resid" "90_10_female_resid" "90_50_male_resid" "90_50_female_resid" "50_10_male_resid" "50_10_female_resid", cols(2) saving(figure2, replace) as(pdf)

restore

/////%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

////1976/////
forvalues quantiles = 0.1(0.4)1.3 {
    forvalues s = 1/2 {
        di "`quantiles'"
        di "`s'"
        if `quantiles' == 0.1 & `s' == 1 {
            matrix betas_1976_1 = J(1, 225, .)
        }
        if `quantiles' == 0.1 & `s' == 2 {
            matrix betas_1976_2 = J(1, 225, .)
        }
        cap qui qreg log_inc i.hs_dropout##i.exp_bracket_* i.hs##i.exp_bracket_* i.some_college##i.exp_bracket_* i.college##i.exp_bracket_* if sex == `s' & year == 1976, quantile(`quantiles')
        mat betas = e(b)
        if `s' == 1 {
            matrix betas_1976_1 = betas_1976_1 \ betas
        }
        if `s' == 2 {
            matrix betas_1976_2 = betas_1976_2 \ betas
        }
    }
}

forvalues percentiles = 0.501(0.002)1.001{
	forvalues s=1/2{
		disp `percentiles'
		disp `s'
		cap noi iqreg log_inc hs_dropout##exp_bracket_* hs##exp_bracket_* some_college##exp_bracket_* college##exp_bracket_* if sex == `s' & year ==1976, q(0.5 `percentiles') reps(2)
		}
		mat betas = e(b)
		matrix betas_1976_`s' =  betas_1976_`s'\betas
	}	
}

////1989/////
forvalues percentiles = 0.001(0.002)0.501{
	forvalues s=1/2{
		disp `percentiles'
		disp `s'
		*disp `y'
		if percentiles == 0.001{
			matrix define betas_1989_`s' = J(1,126,.)
		}
		cap noi iqreg log_inc hs_dropout##exp_bracket_* hs##exp_bracket_* some_college##exp_bracket_* college##exp_bracket_* if sex == `s' & year ==1989, q(`percentiles' 0.5) reps(2)
		}
		mat betas = e(b)
		matrix betas_1989_`s' =  betas_1989_`s'\betas
	}	
}

forvalues percentiles = 0.501(0.002)1.001{
	forvalues s=1/2{
		disp `percentiles'
		disp `s'
		cap noi iqreg log_inc hs_dropout##exp_bracket_* hs##exp_bracket_* some_college##exp_bracket_* college##exp_bracket_* if sex == `s' & year ==1989, q(0.5 `percentiles') reps(2)
		}
		mat betas = e(b)
		matrix betas_1989_`s' =  betas_1989_`s'\betas
	}	
}
////2004/////  
forvalues percentiles = 0.001(0.002)0.501{
	forvalues s=1/2{
		disp `percentiles'
		disp `s'
		*disp `y'
				if percentiles == 0.001{
			matrix define betas_2004_`s' = J(1,126,.)
		}
		cap noi iqreg log_inc hs_dropout##exp_bracket_* hs##exp_bracket_* some_college##exp_bracket_* college##exp_bracket_* if sex == `s' & year ==2004, q(`percentiles' 0.5) reps(2)
		}
		mat betas = e(b)
		matrix betas_2004_`s' =  betas_2004_`s'\betas
	}	
}

forvalues percentiles = 0.501(0.002)1.001{
	forvalues s=1/2{
		disp `percentiles'
		disp `s'
		cap noi iqreg log_inc hs_dropout##exp_bracket_* hs##exp_bracket_* some_college##exp_bracket_* college##exp_bracket_* if sex == `s' & year ==2004, q(0.5 `percentiles') reps(2)
		}
		mat betas = e(b)
		matrix betas_2004_`s' =  betas_2004_`s'\betas
	}	
}
////2012/////  
forvalues percentiles = 0.001(0.002)0.501{
	forvalues s=1/2{
		disp `percentiles'
		disp `s'
		if percentiles == 0.001 & s == 1{
			matrix define betas_2012_1 = J(1,126,.)
		}
		if percentiles == 0.001 & s == 2{
			matrix define betas_2012_2 = J(1,126,.)
		}
		cap noi iqreg log_inc hs_dropout##exp_bracket_* hs##exp_bracket_* some_college##exp_bracket_* college##exp_bracket_* if sex == `s' & year ==2012, q(`percentiles' 0.5) reps(2)
		}
		mat betas = e(b)
		matrix betas_2012_`s' =  betas_2012_`s'\betas
	}	
}

forvalues percentiles = 0.501(0.002)1.001{
	forvalues s=1/2{
		disp `percentiles'
		disp `s'
		*disp `y'
		cap noi iqreg log_inc hs_dropout##exp_bracket_* hs##exp_bracket_* some_college##exp_bracket_* college##exp_bracket_* if sex == `s' & year ==2012, q(0.5 `percentiles') reps(2)
		}
		mat betas = e(b)
		matrix betas_2012_`s' =  betas_2012_`s'\betas
	}	
}

////2021/////  
forvalues percentiles = 0.001(0.002)0.501{
	forvalues s=1/2{
		disp `percentiles'
		disp `s'
		*disp `y'
				if percentiles == 0.001{
			matrix define betas_`y'_`s' = J(1,126,.)
		}
		cap noi iqreg log_inc hs_dropout##exp_bracket_* hs##exp_bracket_* some_college##exp_bracket_* college##exp_bracket_* if sex == `s' & year ==2021, q(`percentiles' 0.5) reps(2)
		}
		mat betas = e(b)
		matrix betas_2021_`s' =  betas_2021_`s'\betas
	}	
}

forvalues percentiles = 0.501(0.002)1.001{
	forvalues s=1/2{
		disp `percentiles'
		disp `s'
		cap noi iqreg log_inc hs_dropout##exp_bracket_* hs##exp_bracket_* some_college##exp_bracket_* college##exp_bracket_* if sex == `s' & year ==2021, q(0.5 `percentiles') reps(2)
		}
		mat betas = e(b)
		matrix betas_2021_`s' =  betas_2021_`s'\betas
	}	
}

