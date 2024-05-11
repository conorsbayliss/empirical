use "C:\Users\bayli024\DriveFS\My Drive\Economics\Empirical\cps_00002"

** generate annual_hours and huorly_wage **
gen annual_hours=uhrswork1*wkswork1
gen hourly_wage = incwage/(annual_hours)

** generate the sample **
** aged from 25 to 60 inclusive **
** drop data with missing entries, **
** income less than 2200 per year, **
** hourly wage greater than 450, **
** and annual hours less than 100 **
gen sample = (age>=25&age<=60) & !missing(incwage) & !missing(uhrswork1) & !missing(wkswork1) & !missing(age) & !missing(educ) & !missing(sex) & !missing(hourly_wage) & !missing(annual_hours) & incwage>=2200 & hourly_wage<=450 & annual_hours>=100

estimates drop _all

** generate summary statistics **
eststo: estpost tabstat age sex educ statefip incwage uhrswork1 wkswork1, statistics(n mean median sd min max skewness kurtosis iqr) columns(statistics)

estimates drop _all

** generate sample summary statistics **
eststo: estpost tabstat age sex educ statefip incwage uhrswork1 wkswork1 if sample == 1, statistics(n mean median sd min max skewness kurtosis iqr) columns(statistics)

estimates drop _all

** now create dummys for all ages **
** note that age 25 is our baseline **
summ age if sample ==1
local max_age =r(max)
forvalues i = 26/`max_age' {
	gen age_`i' = (age ==`i')
}

** generate log income **
gen loginc = ln(incwage) if sample ==1

** generate dummys for educational attainment **
gen d_educ_hs = (educ == 73) // high school
gen d_educ_sc = (educ == 81) // some college
gen d_educ_cd = (educ == 91 | educ == 92 | educ == 111 | educ == 124) // college degree
gen d_educ_ge = (educ == 123 | educ == 125) // graduate degree

** generate dummys for states **
summ statefip if sample==1
local max_state = r(max)
forvalues i = 1/`max_state' {
	gen d_state_`i' = (statefip ==`i')
}

** drop those dummys which are not associated with any states (3,7,14,43,52) **
drop d_state_3
drop d_state_7
drop d_state_14
drop d_state_43
drop d_state_52

** note: could also drop one more to act as our baseline **
** run our first regression **
estimates drop _all
reg loginc sex age_26-age_60 d_state* d_educ* if year == 2012 & sample==1

** run our second regression **
** note that i. indicates an indicator variable, and ## is used for interaction terms **
** if we use ##, then the coefficients for those variables are also computed without interaction **
estimates drop _all
reg loginc i.d_educ*##i.age_* i.sex##i.age_* i.d_educ*##i.sex d_state_* if year==2012 & sample==1