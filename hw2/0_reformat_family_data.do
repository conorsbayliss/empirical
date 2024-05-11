
/* This codes works after deleting all "[path]" in the PSID do-files for each family version*/
clear all
set maxvar 10000
cd "C:\Users\jagal\OneDrive\Escritorio\PhD\2_Second year\Empirical\HW2\Data"

forvalues y = 1968/1997 {
	do FAM`y'.do 
	compress
	save "C:\Users\jagal\OneDrive\Escritorio\PhD\2_Second year\Empirical\HW2\Data\FAM`y'.dta", replace
}

forvalues y = 1/12 {
	local year = 1997 + 2*`y'
	do FAM`year'.do 
	compress
	save "C:\Users\jagal\OneDrive\Escritorio\PhD\2_Second year\Empirical\HW2\Data\FAM`year'.dta", replace
}


