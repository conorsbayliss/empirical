clear all 

cd "C:\Users\jagal\OneDrive\Escritorio\PhD\2_Second year\Empirical\HW2"

use individual_psid_cleaned.dta, replace

merge m:1 household_id year using  Data/HH_wage.dta, nogen keep(3)

*Male head of HHs between the age of 25 and 59 with no imputed wages
keep if age>24 & age<60 & sex==1 & ((head==10 & year>1982) | (head==1 & year<=1982)) & HH_wage_acc ==0 & HH_wage>0 & HH_total_labor_inc>0 & HH_total_exc_farm_bus>0

winsor2 HH_wage, by(year) cuts(1 99) trim
winsor2 HH_total_labor_inc, by(year) cuts(1 99) trim
winsor2 HH_total_exc_farm_bus, by(year) cuts(1 99) trim
gen age2 = age^2
gen double log_wage = ln(HH_wage_tr)
gen double log_labor_inc = ln(HH_total_labor_inc)
gen double log_labor_inc_exc_farm_bus = ln(HH_total_exc_farm_bus)

xtset person_ID year
gen double d2_log_wage1 = log_wage - l2.log_wage
gen double d2_log_wage2 = log_wage - l2.log_wage if age > 29 & age < 55 
gen double d2_log_labor_inc = log_labor_inc - l2.log_labor_inc
gen double d2_log_labor_inc_exc_farm_bus = log_labor_inc_exc_farm_bus - l2.log_labor_inc_exc_farm_bus

reg d2_log_wage1 age age2 
predict d2_log_wage1_hat 

reg d2_log_wage2 age age2 
predict d2_log_wage2_hat 

reg d2_log_labor_inc age age2
predict d2_log_labor_inc_hat

reg d2_log_labor_inc_exc_farm_bus age age2
predict d2_log_labor_exc_farm_bus_hat

gen double residuals1 = d2_log_wage1_hat - d2_log_wage1
gen double residuals2 = d2_log_wage2_hat - d2_log_wage2
gen double residuals3 = d2_log_labor_inc_hat - d2_log_labor_inc
gen double residuals4 = d2_log_labor_exc_farm_bus_hat - d2_log_labor_inc_exc_farm_bus

*Figure 2: Standard deviation of age-adjusted change in log earnings with various earning measures*
preserve
collapse (sd) residuals* d2_log_wage1, by(year) 
replace year = year - 2
tsset year
label var residuals1 	"Wages & salaries"
label var residuals2 	"Wages & salaries with ages 30-54"
label var residuals3 	"Total labor income (Dynan et al.)"
label var residuals4 	"Total labor income excluding farm & business income"
label var d2_log_wage1 	"Wages & salaries without controlling for age"

tsline residuals* d2_log_wage1 if year <2008
graph export Output\b_Figure2.pdf, as(pdf) name("Graph") replace
restore

*Figure 3: Quantiles of age-adjusted change in log earnings* 
preserve

collapse (p10) p10_residuals1 = residuals1 (p25) p25_residuals1 = residuals1 (p50) p50_residuals1 = residuals1 (p75) p75_residuals1 = residuals1 (p90) p90_residuals1 = residuals1, by(year)

label var p10_residuals1 "P10"
label var p25_residuals1 "P25"
label var p50_residuals1 "Median"
label var p75_residuals1 "P75"
label var p90_residuals1 "P90"

replace year = year - 2
tsset year 

tsline p* if year < 2008
graph export Output\b_Figure3.pdf, as(pdf) name("Graph")  replace
restore

*Figure 4: 90-10 differences in various measures of earnings change
use individual_psid_cleaned.dta, replace
merge m:1 household_id year using  Data/HH_wage.dta, nogen keep(3)

gen in_sample = (age>24 & age<60 & sex==1 & ((head==10 & year>1982) | (head==1 & year<=1982)) & HH_wage_acc ==0 & HH_wage>0 & HH_total_labor_inc>0 & HH_total_exc_farm_bus>0)

merge m:1 year using Data/cpi_u_rs.dta, keep(3) nogen

gen double real_wage_inc = HH_wage/CPI
gen double real_wage_exc = HH_wage/CPI if in_sample == 1
gen double log_wage = ln(HH_wage) if in_sample == 1

xtset person_ID year

gen double d2_log_wage = log_wage - l2.log_wage
gen double d2_real_wage_inc = (real_wage_inc - l2.real_wage_inc)
gen double d2_real_wage_exc = (real_wage_exc - l2.real_wage_exc)
gen double age2 = age^2

gen double d2_log_wage_hat = .
gen double d2_real_wage_inc_hat = .
gen double d2_real_wage_exc_hat = .

forvalues y = 1970/2019 {
	cap noi reg d2_log_wage age age2 if year==`y'
	cap noi predict d2_log_wage_hat`y'
	cap noi replace d2_log_wage_hat = d2_log_wage_hat`y' if year == `y'
	cap noi drop d2_log_wage_hat`y'

	cap noi reg d2_real_wage_inc age age2 if year == `y'
	cap noi predict d2_real_wage_inc_hat`y'
	cap noi replace d2_real_wage_inc_hat = d2_real_wage_inc_hat`y' if year== `y'
	cap noi drop d2_real_wage_inc_hat`y'

	cap noi reg d2_real_wage_exc age age2 if year == `y'
	cap noi predict d2_real_wage_exc_hat`y'
	cap noi replace d2_real_wage_exc_hat = d2_real_wage_exc_hat`y' if year== `y'
	cap noi drop d2_real_wage_exc_hat`y'
}

gen double residuals_log = d2_log_wage_hat - d2_log_wage
gen double residuals_exc = (d2_real_wage_exc_hat - d2_real_wage_exc)*2/(l2.real_wage_exc + real_wage_exc)
gen double residuals_inc = (d2_real_wage_inc_hat - d2_real_wage_inc)*2/(l2.real_wage_inc + real_wage_inc)

collapse (p10) p10_log_wage = residuals_log p10_real_inc = residuals_inc p10_real_exc = residuals_exc (p25) p25_real_inc = residuals_inc p25_real_exc = residuals_exc (p50) p50_real_inc = residuals_inc p50_real_exc = residuals_exc (p75) p75_real_inc = residuals_inc p75_real_exc = residuals_exc (p90) p90_log_wage = residuals_log p90_real_inc = residuals_inc p90_real_exc = residuals_exc , by(year)

tsset year
replace year = year - 2

gen double p9010_log_wage = p90_log_wage-p10_log_wage
gen double p9010_real_inc = p90_real_inc-p10_real_inc
gen double p9010_real_exc = p90_real_exc-p10_real_exc
 
tsline p9010_log_wage p9010_real_exc p9010_real_inc if year < 2008
graph export Output\b_Figure4.pdf, replace  as(pdf) name("Graph") 

*Figure 5: Quantiles of relative age-adjusted change in real earning (zeros and outliers excluded)
tsline p10_real_exc p25_real_exc p50_real_exc p75_real_exc p90_real_exc if year < 2008
graph export Output\b_Figure5.pdf, replace  as(pdf) name("Graph") 

*Figure 6: Quantiles of relative age-adjusted change in real earning (zeros and outliers included)
tsline p10_real_inc p25_real_inc p50_real_inc p75_real_inc p90_real_inc if year < 2008
graph export Output\b_Figure6.pdf, replace  as(pdf) name("Graph") 

*(c)*
use individual_psid_cleaned.dta, replace

merge m:1 household_id year using  Data/HH_wage.dta, nogen keep(3)

*Male head of HHs between the age of 25 and 59 with no imputed wages
keep if age>24 & age<60 & sex==1 & ((head==10 & year>1982) | (head==1 & year<=1982)) & HH_wage_acc ==0 & HH_wage>0 & HH_total_labor_inc>0 & HH_total_exc_farm_bus>0

winsor2 HH_wage, by(year) cuts(1 99) trim
winsor2 HH_total_labor_inc, by(year) cuts(1 99) trim

gen age2 = age^2

gen double log_wage = ln(HH_wage_tr)
gen double log_labor_inc = ln(HH_total_labor_inc_tr)
gen double log_wage_30_54 = ln(HH_wage_tr) if age > 29 & age < 55

xtset person_ID year

gen double d2_log_wage = log_wage - l2.log_wage
gen double d2_log_wage_30_54 = log_wage_30_54 - l2.log_wage_30_54 
gen double d2_log_labor_inc = log_labor_inc - l2.log_labor_inc

reg d2_log_wage age age2 
predict d2_log_wage_hat 

reg d2_log_wage_30_54 age age2 
predict d2_log_wage_30_54_hat 

reg d2_log_labor_inc age age2
predict d2_log_labor_inc_hat

gen double residuals1 = d2_log_wage_hat - d2_log_wage
gen double residuals2 = d2_log_wage_30_54_hat - d2_log_wage_30_54
gen double residuals3 = d2_log_labor_inc_hat - d2_log_labor_inc

preserve
gcollapse (skewness) sk_residuals1 = residuals1 sk_residuals2 = residuals2 sk_residuals3 = residuals3 (kurtosis) kur_residuals1 = residuals1 kur_residuals2 = residuals2 kur_residuals3 = residuals3, by(year)

label var sk_residuals1 "Wages and salaries"
label var sk_residuals2 "Wages and salaries with ages 30-54"
label var sk_residuals3 "Total labor income"

label var kur_residuals1 "Wages and salaries"
label var kur_residuals2 "Wages and salaries with ages 30-54"
label var kur_residuals3 "Total labor income"

replace year = year - 2
tsset year

tsline sk* if year < 2008, title("Skewness") 
graph export Output\c_Skewness.pdf, replace as(pdf) name("Graph") 
tsline kur* if year < 2008, title("Kurtosis") 
graph export Output\c_Kurtosis.pdf, replace as(pdf) name("Graph") 
restore

*(d)*
use individual_psid_cleaned.dta, replace

merge m:1 household_id year using  Data/HH_wage.dta, nogen keep(3)

*Male head of HHs between the age of 25 and 59 with no imputed wages
keep if age>24 & age<60 & sex==1 & ((head==10 & year>1982) | (head==1 & year<=1982)) & HH_wage_acc ==0 & HH_wage>0 & HH_total_labor_inc>0 & HH_total_exc_farm_bus>0


gen age2 = age^2

gen double log_wage = ln(HH_wage)
gen double log_labor_inc = ln(HH_total_labor_inc)
gen double log_wage_30_54 = ln(HH_wage) if age > 29 & age < 55

xtset person_ID year

gen double d2_log_wage = log_wage - l2.log_wage
gen double d2_log_wage_30_54 = log_wage_30_54 - l2.log_wage_30_54 
gen double d2_log_labor_inc = log_labor_inc - l2.log_labor_inc

winsor2 d2_log_wage, by(year) cuts(2 98) trim
winsor2 d2_log_wage_30_54, by(year) cuts(2 98) trim
winsor2 d2_log_labor_inc, by(year) cuts(2 98) trim

reg d2_log_wage_tr age age2 
predict d2_log_wage_hat 

reg d2_log_wage_30_54_tr age age2 
predict d2_log_wage_30_54_hat 

reg d2_log_labor_inc_tr age age2
predict d2_log_labor_inc_hat

gen double residuals1 = d2_log_wage_hat - d2_log_wage
gen double residuals2 = d2_log_wage_30_54_hat - d2_log_wage_30_54
gen double residuals3 = d2_log_labor_inc_hat - d2_log_labor_inc

preserve
gcollapse (skewness) sk_residuals1 = residuals1 sk_residuals2 = residuals2 sk_residuals3 = residuals3 (kurtosis) kur_residuals1 = residuals1 kur_residuals2 = residuals2 kur_residuals3 = residuals3, by(year)

label var sk_residuals1 "Wages and salaries"
label var sk_residuals2 "Wages and salaries with ages 30-54"
label var sk_residuals3 "Total labor income"

label var kur_residuals1 "Wages and salaries"
label var kur_residuals2 "Wages and salaries with ages 30-54"
label var kur_residuals3 "Total labor income"

replace year = year - 2
tsset year
tsline sk* if year < 2008, title("Skewness") 
graph export Output\d_Skewness.pdf, replace as(pdf) name("Graph") 
tsline kur* if year < 2008, title("Kurtosis") 
graph export Output\d_Kurtosis.pdf, replace as(pdf) name("Graph") 
restore