clear
cd /Users/bychen/Documents/LaborEcon/term/raw/110manpower
use "mu110.dta", clear
drop if b1_a == 0
tab b1_c1
inspect id a2 a5_3 a21_2 a22 b1_a b1_c1
duplicates report
duplicates drop id, force
gen year = 2021
egen median_inc = pctile(b1_a), p(50)
label var median_inc `"The median of monthly income of all observations."'
recode b1_c1 (0 = .)(1 = 1) (2 = 0), generate(wfh)
save "/Users/bychen/Documents/LaborEcon/term/work/mu110_edit.dta", replace


clear
cd /Users/bychen/Documents/LaborEcon/term/raw/109manpower
use "mu109.dta", clear
drop if b1_a == 0
gen year = 2020
save "/Users/bychen/Documents/LaborEcon/term/work/mu109_edit.dta", replace



clear
cd /Users/bychen/Documents/LaborEcon/term/work
use "mu110_edit.dta", replace
append using "mu109_edit.dta"
duplicates report id
drop wfh
recode b1_c1 (0 = .)(1 = 1) (2 = 0)(. = 0), generate(wfh)
histogram b2_b
twoway scatter b1_a wfh if wfh !=.
regress b1_a wfh if wfh !=.
regress b1_a wfh i.a5_3 i.a21_2 i.a22 i.year i.county if wfh!=., r
regress b1_a wfh##i.year i.a5_3 i.a21_2 i.a22 i.county if wfh!=., r

global Y b2_b
global X i.a2 a3 i.a5_3 i.a21_2 i.a21_3 i.a22 i.a23 i.b2_a b3_y i.county no i.a5_1 i.a5_4 i.a8
global D wfh
probit $D $X
predict wfh_hat
inspect wfh_hat
pdslasso $Y $D ($X), rob
qddml $Y $D ($X), kfolds(2) model(partial) cmd(rlasso) reps(5)
psmatch2 $D $X i.year, out($Y) logit n(1)
set seed 42

