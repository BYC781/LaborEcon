
import delimited using acs_2015.csv,clear encoding("utf-8")

replace year=2015 if _n>=20000 & _n<40000
replace year=2016 if _n>=40000 

save acs_2015.dta,replace

export delimited using acs_2015.csv,replace

stata2mplus using acs_2015
