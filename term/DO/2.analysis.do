clear all
set more off

cd "/Users/bychen/Documents/LaborEcon/term"

use work/timeuse.dta, clear

// Set X, D, Y
global X i.statefip age female hh_child hh_size i.famincome i.occ2 earnweek i.race fullpart
global D distance_work
global Y wbladder


// Step 1: pre-test
ttest $Y, by($D)

// Step 2: Test Differences in Covariates in Pre-matching Data
foreach cov in age female hh_child hh_size earnweek fullpart{
	ttest `cov', by ($D)
}


// Step 3: PSM Estimation – psmatch2 (Main result)
psmatch2 $D $X, out($Y) logit n(3) ai(3) ate
gen pscore = _pscore


// Step 4: Post Matching Analysis – psmatch2
pstest _pscore, density both
pstest age female hh_child hh_size earnweek fullpart wbladder, both


sum age female hh_child hh_size earnweek fullpart wbladder if _treated == 0 & _support == 1

// pscore hist
twoway (hist _pscore if distance_work == 1, frac lcolor(gs12) fcolor(gs12)) ///
(hist _pscore if distance_work == 0, frac fcolor(none) lcolor(red)), ///
legend(order(1 "Remote worker" 2 "commuter" )) 


// sub-group
psmatch2 $D $X if female ==1, out($Y) logit n(3) ai(3) ate
psmatch2 $D $X if female ==0, out($Y) logit n(3) ai(3) ate
psmatch2 $D $X if hh_child ==1, out($Y) logit n(3) ai(3) ate
psmatch2 $D $X if hh_child ==0, out($Y) logit n(3) ai(3) ate
psmatch2 $D $X if female ==1 & hh_child ==1, out($Y) logit n(3) ai(3) ate
psmatch2 $D $X if female ==0 & hh_child ==1, out($Y) logit n(3) ai(3) ate
psmatch2 $D $X if female ==1 & hh_child ==0, out($Y) logit n(3) ai(3) ate
psmatch2 $D $X if female ==0 & hh_child ==0, out($Y) logit n(3) ai(3) ate


// Robustness checks
psmatch2 $D $X, out($Y) logit n(1) ai(1) ate
psmatch2 $D $X, out($Y) logit n(2) ai(2) ate
psmatch2 $D $X, out($Y) logit n(4) ai(4) ate
psmatch2 $D $X, out($Y) logit n(5) ai(5) ate

psmatch2 $D $X if pscore >= 0.2 & pscore<=0.4, out($Y) logit n(3) ai(3)
