clear all
set more off

cd "/Users/bychen/Documents/LaborEcon/term"

use work/timeuse.dta, clear

// Set X, D
global X i.statefip age female hh_numkids i.ind2  earnweek uhrsworkt famincome hh_size i.clwkr i.race

global X1 i.statefip age female hh_numkids i.ind2 i.occ2 i.fullpart earnweek uhrsworkt famincome hh_size hh_child i.clwkr i.race 

global X2 i.statefip age female hh_numkids i.ind2 i.occ2 i.fullpart earnweek uhrsworkt famincome hh_size hh_child i.clwkr i.race bls_leis_soccom bls_leis_sport bls_pcare_health bls_pcare_sleep bls_work_working painmed rested

global D distance_work
pdslasso wbladder $D ($X2), rob
qddml wbladder $D ($X2), kfolds(2) model(partial) cmd(rlasso) reps(5)
xpopoisson wbladder $D, controls($X2)
psmatch2 $D $X2, out(wbladder) logit n(2)
reg wbladder $D $X2, r
set seed 42

// pdslasso
foreach Y in painmed wbladder bls_leis_sport bls_leis_soccom rested bls_pcare_sleep bls_pcare_health bls_work_working bls_work_travel{
	pdslasso `Y' $D ($X1), rob
}

// DDML
foreach Y in painmed wbladder bls_leis_sport bls_leis_soccom rested bls_pcare_sleep bls_pcare_health bls_work_working{
	qddml `Y' $D ($X), kfolds(2) model(partial) cmd(rlasso) reps(5)
}


// matching
foreach Y in painmed wbladder bls_leis_sport bls_leis_soccom rested bls_pcare_sleep bls_pcare_health bls_work_working{
	psmatch2 $D $X, out(`Y') logit n(2)
}

// xpopoisson 
foreach Y in painmed wbladder bls_leis_sport bls_leis_soccom rested bls_pcare_sleep  bls_work_working{
	xpopoisson `Y' $D, controls($X)
}
