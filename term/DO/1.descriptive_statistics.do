clear all
set more off

cd "/Users/bychen/Documents/LaborEcon/term"

use work/timeuse.dta, clear



// summary statistic
sort distance_work
by distance_work: sum wbladder

sort female distance_work
by female distance_work: sum wbladder

sort hh_child distance_work
by hh_child distance_work: sum wbladder

sort female hh_child distance_work
by female hh_child distance_work: sum wbladder
