clear all
cd "C:\Users\jagal\OneDrive\Escritorio\PhD\2_Second year\Empirical\HW2\Data"
set maxvar 10000
*Household id matrices*
mat hh_id1 = (3, 442, 1102, 1802, 2402, 3002, 3402, 3802, 4302, 5202, 5702, 6302, 6902, 7502, 8202, 8802, 10002, 11102, 12502, 13702, 14802, 16302, 17702, 19002, 20302, 21602) // "V" matrices
mat hh_id2 = (2002, 5002, 7002, 10002, 13002, 17002, 21002, 25002, 36002, 42002, 47302, 53002, 60002, 66002, 72002, 78002) // "ER" matrices

*Household head wages matrices*
mat hh_wage1 = (251, 699, 1191, 1892, 2493, 3046, 3458, 3858, 4373, 5283, 5782, 6391, 6981, 7573, 8265, 8873, 10256, 11397, 12796, 13898, 14913, 16413, 17829, 19129, 20429, 21739) //  "V" matrices
mat hh_wage2 = (3139, 6139, 9213, 12196, 16493, 18561, 21929, 25910, 40903, 46811, 52219, 58020, 65200, 71277, 77299, 81626) // "ER" matrices

*Household head total labor income (from 1994 excludes farm and business income)
mat hh_total_labor1 = (74, 514, 1196, 1897, 2498, 3051, 3463, 3863, 5031, 5627, 6174, 6767, 7413, 8066, 8690, 9376, 11023,12372, 13624, 14671, 16145, 17534, 18878, 20178, 21484, 23323) //  "V" matrices
mat hh_total_labor2 = (4140, 6980, 9231, 12080, 16463, 20443, 24116, 27931, 40921, 46826, 52237, 58038, 65216, 71293, 77315, 81642) // "ER" matrices

*Farm income (from 1977)
mat hh_farm1 = (5281, 5780, 6389, 6979, 7571, 8263, 8871, 10254, 11395, 12974, 13896, 14911, 16411, 17827, 19127, 20427, 21733)
mat hh_farm2 = (4117, 6957, 9208, 12065, 16448, 20420, 24105, 27908, 40898, 46806, 52214, 58015, 65195, 71272, 77294, 81621)

*Business income (from 1977)
mat hh_bus1  = (5282, 5781, 6390, 6980, 7572, 8264, 8872, 10255, 11396, 12795, 13897, 14912, 16412, 17828, 19128, 20428, 21738)
mat hh_bus2  = (4119, 6959, 9210, 12067, 16450, 20422, 24109, 27910, 40900, 46808, 52216, 58017, 65197, 71274, 77296, 81623)

/*
*Household head total labor income
mat hh_wage1 = (., 515, 1196, 1898, 2499, 3052, 3464, 3864, 5059, 5638, 6185, 6778, 8076, 8700, 9386, 11033, 12391, 13637, 14684) //  "V" matrices
mat hh_wage2 = () // "ER" matrices
*/

*Household head wages accuracy matrices*
mat hh_wage_acc1 = (252, 700, 1192, 1893, 2494, 3047, 3459, 3859, 4374, 5284, 5783, 6392, 6982, 7574, 8266, 8874, 10257, 11398, 12797, 13899, 14914, 16414, 17830, 19130, 20430, 21740) //  "V" matrices
mat hh_wage_acc2 = (4123, 6963, 9214, 12197, 16494, 20426, 24118, 27914, 40904, 46812, 52220, 58021, 65201, 71278, 77300, 81627) // "ER" matrices


forvalues y = 1970/1976 {
	use FAM`y'.dta, replace
	local id = hh_id1[1,`y'-1967]
	local wage = hh_wage1[1,`y'-1967]
	local wage_acc = hh_wage_acc1[1,`y'-1967]
	local total_labor = hh_total_labor1[1,`y'-1967]
	keep V`id' V`wage' V`wage_acc' V`total_labor'
	rename (V`id' V`wage' V`wage_acc' V`total_labor') (household_id HH_wage HH_wage_acc HH_total_labor_inc)
	gen year = `y'
	tempfile HH_`y'
	save `HH_`y''
}
forvalues y = 1977/1993 {
	use FAM`y'.dta, replace
	local id = hh_id1[1,`y'-1967]
	local wage = hh_wage1[1,`y'-1967]
	local wage_acc = hh_wage_acc1[1,`y'-1967]
	local total_labor = hh_total_labor1[1,`y'-1967]
	local farm_inc = hh_farm1[1,`y'- 1976]
	local bus_inc = hh_bus1[1,`y'- 1976]
	keep V`id' V`wage' V`wage_acc' V`total_labor' V`farm_inc' V`bus_inc'
	rename (V`id' V`wage' V`wage_acc' V`total_labor' V`farm_inc' V`bus_inc') (household_id HH_wage HH_wage_acc HH_total_labor_inc HH_farm_inc HH_bus_inc)
	gen HH_total_exc_farm_bus = HH_total_labor_inc - HH_farm_inc - HH_bus_inc
	drop HH_farm_inc HH_bus_inc
	gen year = `y'
	tempfile HH_`y'
	save `HH_`y''
}

forvalues y = 1994/1997 {
	use FAM`y'.dta, replace
	local id = hh_id2[1,`y'-1993]
	local wage = hh_wage2[1,`y'-1993]
	local wage_acc = hh_wage_acc2[1,`y'-1993]
	local total_exc_farm_bus = hh_total_labor2[1,`y'- 1993]
	local farm_inc = hh_farm2[1,`y'- 1993]
	local bus_inc = hh_bus2[1,`y'- 1993]
	keep ER`id' ER`wage' ER`wage_acc' ER`total_exc_farm_bus' ER`farm_inc' ER`bus_inc'
	rename (ER`id' ER`wage' ER`wage_acc' ER`total_exc_farm_bus' ER`farm_inc' ER`bus_inc') (household_id HH_wage HH_wage_acc HH_total_exc_farm_bus HH_farm_inc HH_bus_inc)
	gen HH_total_labor_inc = HH_total_exc_farm_bus + HH_farm_inc + HH_bus_inc
	drop HH_farm_inc HH_bus_inc
	gen year = `y'
	tempfile HH_`y'
	save `HH_`y''	
}
forvalues j = 1/12 {
	local y = 1997 + 2*`j'
	use FAM`y'.dta, replace
	local id = hh_id2[1,`j'+4]
	local wage = hh_wage2[1,`j'+4]
	local wage_acc = hh_wage_acc2[1,`j'+4]
	local total_exc_farm_bus = hh_total_labor2[1,`j' + 4]
	local farm_inc = hh_farm2[1,`j' + 4]
	local bus_inc = hh_bus2[1,`j' + 4]
	keep ER`id' ER`wage' ER`wage_acc' ER`total_exc_farm_bus' ER`farm_inc' ER`bus_inc'
	rename (ER`id' ER`wage' ER`wage_acc' ER`total_exc_farm_bus' ER`farm_inc' ER`bus_inc') (household_id HH_wage HH_wage_acc HH_total_exc_farm_bus HH_farm_inc HH_bus_inc)
	gen HH_total_labor_inc = HH_total_exc_farm_bus + HH_farm_inc + HH_bus_inc
	drop HH_farm_inc HH_bus_inc
	gen year = `y'
	tempfile HH_`y'
	save `HH_`y''	
}
clear all 
forvalues y = 1970/1997 {
	append using `HH_`y''
}
forvalues j = 1/12 {
	local y = 1997 + 2*`j'
	append using `HH_`y''
}

compress
save HH_wage.dta, replace