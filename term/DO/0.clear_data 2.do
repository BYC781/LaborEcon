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
//drop spouse related variables(a lot missing, maybe add them later)

drop if year == 2020  
gen female = sex == 2 
gen distance_work = 1 if covid == 2
replace distance_work = 0 if covid == 1
replace fullpart = 0 if fullpart == 2
drop covidtelew
drop sex
drop bls*

order caseid wbladder statefip distance_work age female race marst hh_child hh_size  empstat  occ ind earnweek uhrsworkt
sort caseid 
format caseid %18.0g


compress

save work/timeuse.dta, replace
