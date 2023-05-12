clear all
set more off

cd "/Users/bychen/Documents/LaborEcon/term"


use raw/atus_00009.dta, clear

**************************clear data**************************
drop  covidunaw  pernum lineno
drop if covidtelew == 99 
//first stage outcome:whether recipiant can worked remotely, 10527 obs. deleted
drop if empstat~=1 & empstat~=2 //keep those who are employed 340 obs. deleted
drop if earnweek == 99999.99 // 693 obs. deleted
drop if uhrsworkt == 9995 // 187 obs. deleted
drop if wb_resp == 0 // 1014 obs. deleted
drop if wbladder == 999 // 0 obs. deleted
/*
**spouse related variables

foreach x in spage spsex sprace spempnot spempstat spusualhrs spearnweek{
replace `x' = . if spousepres == 3
}
*/
drop sp*  
//drop spouse related variables(a lot missing, maybe 之後再加入)

order year caseid statefip age sex race marst hh_numkids covidtelew bls_pcare_sleep painmed wbladder bls_leis_sport bls_leis_soc empstat  occ ind earnweek uhrsworkt
sort caseid 
format caseid %18.0g

gen female = sex == 2 
gen distance_work = 1 if covid == 2
replace distance_work = 0 if covid == 1

compress

save work/timeuse.dta, replace
