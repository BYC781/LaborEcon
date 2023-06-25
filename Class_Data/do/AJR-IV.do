** The original files are from Prof. Daron Acemoglu
** They can be downloaded from http://economics.mit.edu/faculty/acemoglu/data/ajr2001

****************************************************************************************
clear

/** please change your path
global do = "D:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\do"
global log = "D:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\log"
global rawdata = "D:\nest\Dropbox\causal_data_course\2020_spring\Class_Data\rawdata\AJR_data_forIV"
*/


/*
** please change your path
global do = "C:\nest\Dropbox\causal_data_course\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_course\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_course\Class_Data\AJR_data_forIV"
*/

/*
** please change your path
global do = "C:\nest\Dropbox\causal_data_working\Class_Data\do"
global log = "C:\nest\Dropbox\causal_data_working\Class_Data\log"
global rawdata = "C:\nest\Dropbox\causal_data_working\Class_Data"
*/


set more off


** Table 2

***********************
*---Column 1
***********************

*Note: there are 111 countries in the world sample that have all the necessary data to run the below regressions, though the paper only reports 110 observations. I'm not sure which of the 111 observations is not used in the paper, so the regressions below will use all 111 obs. and won't quite match the results reported in the paper. 

use "$rawdata\AJR_table2", clear

regress logpgp95 avexpr, robust


***********************
*---Column 2
***********************

regress logpgp95 avexpr if baseco==1, robust


***********************
*--Column 3
***********************

regress logpgp95 avexpr lat_abst, robust

***********************
*--Column 4
***********************
	
regress logpgp95 avexpr lat_abst africa asia other, robust

***********************
*--Column 5
***********************

regress logpgp95 avexpr lat_abst if baseco==1, robust

***********************
*--Column 6
***********************

regress logpgp95 avexpr lat_abst africa asia other if baseco==1, robust

***********************
*---Column 7
***********************

regress loghjypl avexpr, robust


***********************
*---Column 8
***********************

regress loghjypl avexpr if baseco==1, robust

*********************************************************************************************************

** Table 4

use "$rawdata\AJR_table4", clear
keep if baseco==1

**********************************
*--Panels A and B, IV Regressions
**********************************
*Columns 1 - 2 (Base Sample)

ivregress 2sls logpgp95 (avexpr=logem4), first
ivregress 2sls logpgp95 lat_abst (avexpr=logem4), first


*Columns 3 - 4 (Base Sample w/o Neo-Europes)

ivregress 2sls logpgp95 (avexpr=logem4) if rich4!=1, first
ivregress 2sls logpgp95 lat_abst (avexpr=logem4) if rich4!=1, first


*Columns 5 - 6 (Base Sample w/o Africa)

ivregress 2sls logpgp95 (avexpr=logem4) if africa!=1, first
ivregress 2sls logpgp95 lat_abst (avexpr=logem4) if africa!=1, first


*Columns 7 - 8 (Base Sample with continent dummies)

gen other_cont=.
replace other_cont=1 if (shortnam=="AUS" | shortnam=="MLT" | shortnam=="NZL")
recode other_cont (.=0)
tab other_cont

ivregress 2sls logpgp95 (avexpr=logem4) africa asia other_cont, first
ivregress 2sls logpgp95 lat_abst (avexpr=logem4) africa asia other_cont, first


*Column 9 (Base Sample, log GDP per worker)

ivregress 2sls loghjypl (avexpr=logem4), first




**********************************
*--Panel C, OLS Regressions
**********************************

*Columns 1 - 2 (Base Sample)

reg logpgp95 avexpr
reg logpgp95 lat_abst avexpr


*Columns 3 - 4 (Base Sample w/o Neo-Europes)

reg logpgp95 avexpr if rich4!=1
reg logpgp95 lat_abst avexpr if rich4!=1


*Columns 5 - 6 (Base Sample w/o Africa)

reg logpgp95 avexpr if africa!=1
reg logpgp95 lat_abst avexpr if africa!=1


*Columns 7 - 8 (Base Sample with continent dummies)

reg logpgp95 avexpr africa asia other_cont
reg logpgp95 lat_abst avexpr africa asia other_cont


*Column 9 (Base Sample, log GDP per worker)

reg loghjypl avexpr



*******************************************************************************************

*** Table 5

use "$rawdata\AJR_table5", clear
keep if baseco==1

**********************************
*--Panels A and B, IV Regressions
**********************************

*--Columns 1 and 2 (British and French colony dummies)

ivregress 2sls logpgp95 (avexpr=logem4) f_brit f_french, first
ivregress 2sls logpgp95 lat_abst (avexpr=logem4) f_brit f_french, first

*--Columns 3 and 4 (British colonies only)

ivregress 2sls logpgp95 (avexpr=logem4) if f_brit==1, first
ivregress 2sls logpgp95 lat_abst (avexpr=logem4) if f_brit==1, first

*--Columns 5 and 6 (Control for French legel origin)

ivregress 2sls logpgp95 (avexpr=logem4) sjlofr, first
ivregress 2sls logpgp95 lat_abst (avexpr=logem4) sjlofr, first

*--Columns 7 and 8 (Religion dummies)

ivregress 2sls logpgp95 (avexpr=logem4) catho80 muslim80 no_cpm80, first
ivregress 2sls logpgp95 lat_abst (avexpr=logem4) catho80 muslim80 no_cpm80, first

*--Columns 9 (Multiple controls)

ivregress 2sls logpgp95 (avexpr=logem4) f_french sjlofr catho80 muslim80 no_cpm80, first
ivregress 2sls logpgp95 lat_abst (avexpr=logem4) f_french sjlofr catho80 muslim80 no_cpm80, first


**********************************
*--Panel C, OLS Regressions
**********************************


*--Columns 1 and 2 (British and French colony dummies)

reg logpgp95 avexpr f_brit f_french
reg logpgp95 lat_abst avexpr f_brit f_french

*--Columns 3 and 4 (British colonies only)

reg logpgp95 avexpr if f_brit==1
reg logpgp95 lat_abst avexpr if f_brit==1

*--Columns 5 and 6 (Control for French legel origin)

reg logpgp95 avexpr sjlofr
reg logpgp95 lat_abst avexpr sjlofr

*--Columns 7 and 8 (Religion dummies)

reg logpgp95 avexpr catho80 muslim80 no_cpm80
reg logpgp95 lat_abst avexpr catho80 muslim80 no_cpm80

*--Columns 9 (Multiple controls)

reg logpgp95 lat_abst avexpr f_french sjlofr catho80 muslim80 no_cpm80


*******************************************************************************************


** Table 6

use "$rawdata\AJR_table6", clear
keep if baseco==1


**********************************
*--Panels A and B, IV Regressions
**********************************

*--Columns 1 and 2 (Temperature and humidity controls)

ivregress 2sls logpgp95 (avexpr=logem4) temp* humid*, first
ivregress 2sls logpgp95 lat_abst (avexpr=logem4) temp* humid*, first

*--Columns 3 and 4 (Control for percent of European descent in 1975)

ivregress 2sls logpgp95 (avexpr=logem4) edes1975, first
ivregress 2sls logpgp95 lat_abst (avexpr=logem4) edes1975, first

*--Columns 5 and 6 (Controls for soil quality, natural resources, and landlocked)

ivregress 2sls logpgp95 (avexpr=logem4)  steplow deslow stepmid desmid drystep drywint goldm iron silv zinc oilres landlock, first
ivregress 2sls logpgp95 lat_abst (avexpr=logem4)  steplow deslow stepmid desmid drystep  drywint goldm iron silv zinc oilres landlock, first

*--Columns 7 and 8 (Control for ethnolinguistic fragmentation)

ivregress 2sls logpgp95 (avexpr=logem4) avelf, first
ivregress 2sls logpgp95 lat_abst (avexpr=logem4) avelf, first

*--Column 9 (All Controls)
ivregress 2sls logpgp95 lat_abst (avexpr=logem4) temp* humid* edes1975 avelf steplow deslow stepmid desmid drystep  drywint goldm iron silv zinc oilres landlock, first


**********************************
*--Panel C, OLS Regressions
**********************************


*--Columns 1 and 2 (Temperature and humidity controls)

reg logpgp95 avexpr temp* humid*
reg logpgp95 lat_abst avexpr temp* humid*

*--Columns 3 and 4 (Control for percent of European descent in 1975)

reg logpgp95 avexpr edes1975
reg logpgp95 lat_abst avexpr edes1975

*--Columns 5 and 6 (Controls for soil quality, natural resources, and landlocked)

reg logpgp95 avexpr  steplow deslow stepmid desmid drystep drywint goldm iron silv zinc oilres landlock
reg logpgp95 lat_abst avexpr  steplow deslow stepmid desmid drystep  drywint goldm iron silv zinc oilres landlock

*--Columns 7 and 8 (Control for ethnolinguistic fragmentation)

reg logpgp95 avexpr avelf
reg logpgp95 lat_abst avexpr avelf

*--Column 9 (All Controls)
reg logpgp95 lat_abst avexpr temp* humid* edes1975 avelf steplow deslow stepmid desmid drystep  drywint goldm iron silv zinc oilres landlock


*******************************************************************************************************

** Table 8

use "$rawdata\AJR_table8", clear
keep if baseco==1


**********************************
*--Panels A and B, IV Regressions
**********************************

*Columns 1 - 2 (European settlements in 1900 as instrument)

ivregress 2sls logpgp95 (avexpr=euro1900), first
ivregress 2sls logpgp95 lat_abst (avexpr=euro1900), first

*Columns 3 - 4 (Constraint on executive in 1900 as instrument)

ivregress 2sls logpgp95 (avexpr=cons00a), first
ivregress 2sls logpgp95 lat_abst (avexpr=cons00a), first

*Columns 5 - 6 (Democracy in 1900)

ivregress 2sls logpgp95 (avexpr=democ00a), first
ivregress 2sls logpgp95 lat_abst (avexpr=democ00a), first

*Columns 7 - 8 (Constraint on executive in first year of independence)

ivregress 2sls logpgp95 (avexpr=cons1) indtime, first
ivregress 2sls logpgp95 lat_abst (avexpr=cons1) indtime, first

*Columns 9 - 10 (Democracy in first year of independence)

ivregress 2sls logpgp95 (avexpr=democ1) indtime, first
ivregress 2sls logpgp95 lat_abst (avexpr=democ1) indtime, first

***********************************************************************
*--Panel C, Overidentification Tests
***********************************************************************

*Columns 1 - 2 (European settlements in 1900 as instrument)

ivregress 2sls logpgp95 (avexpr=euro1900 logem4), first
estimates store efficient
ivregress 2sls logpgp95 (avexpr=euro1900), first
estimates store consistent
hausman consistent efficient

ivregress 2sls logpgp95 lat_abst (avexpr=euro1900 logem4), first
estimates store efficient
ivregress 2sls logpgp95 lat_abst (avexpr=euro1900), first
estimates store consistent
hausman consistent efficient

*Columns 3 - 4 (Constraint on executive in 1900 as instrument)

ivregress 2sls logpgp95 (avexpr=cons00a logem4), first
estimates store efficient
ivregress 2sls logpgp95 (avexpr=cons00a), first
estimates store consistent
hausman consistent efficient

ivregress 2sls logpgp95 lat_abst (avexpr=cons00a logem4), first
estimates store efficient
ivregress 2sls logpgp95 lat_abst (avexpr=cons00a), first
estimates store consistent
hausman consistent efficient

*Columns 5 - 6 (Democracy in 1900)

ivregress 2sls logpgp95 (avexpr=democ00a logem4), first
estimates store efficient
ivregress 2sls logpgp95 (avexpr=democ00a), first
estimates store consistent
hausman consistent efficient

ivregress 2sls logpgp95 lat_abst (avexpr=democ00a logem4), first
estimates store efficient
ivregress 2sls logpgp95 lat_abst (avexpr=democ00a), first
estimates store consistent
hausman consistent efficient

*Columns 7 - 8 (Constraint on executive in first year of independence)

ivregress 2sls logpgp95 (avexpr=cons1 logem4) indtime, first
estimates store efficient
ivregress 2sls logpgp95 (avexpr=cons1) indtime, first
estimates store consistent
hausman consistent efficient

ivregress 2sls logpgp95 lat_abst (avexpr=cons1 logem4) indtime, first
estimates store efficient
ivregress 2sls logpgp95 lat_abst (avexpr=cons1) indtime, first
estimates store consistent
hausman consistent efficient

*Columns 9 - 10 (Democracy in first year of independence)

ivregress 2sls logpgp95 (avexpr=democ1 logem4) indtime, first
estimates store efficient
ivregress 2sls logpgp95 (avexpr=democ1) indtime, first
estimates store consistent
hausman consistent efficient

ivregress 2sls logpgp95 lat_abst (avexpr=democ1 logem4) indtime, first
estimates store efficient
ivregress 2sls logpgp95 lat_abst (avexpr=democ1) indtime, first
estimates store consistent
hausman consistent efficient


***********************************************************************
*--Panel D, Second Stage with Log Mortality as Exogenous Variable
***********************************************************************

*Columns 1 - 2 (European settlements in 1900 as instrument)

ivregress 2sls logpgp95 (avexpr=euro1900) logem4
ivregress 2sls logpgp95 lat_abst (avexpr=euro1900) logem4

*Columns 3 - 4 (Constraint on executive in 1900 as instrument)

ivregress 2sls logpgp95 (avexpr=cons00a) logem4
ivregress 2sls logpgp95 lat_abst (avexpr=cons00a) logem4

*Columns 5 - 6 (Democracy in 1900)

ivregress 2sls logpgp95 (avexpr=democ00a) logem4
ivregress 2sls logpgp95 lat_abst (avexpr=democ00a) logem4

*Columns 7 - 8 (Constraint on executive in first year of independence)

ivregress 2sls logpgp95 (avexpr=cons1) indtime logem4
ivregress 2sls logpgp95 lat_abst (avexpr=cons1) indtime logem4

*Columns 9 - 10 (Democracy in first year of independence)

ivregress 2sls logpgp95 (avexpr=democ1) indtime logem4
ivregress 2sls logpgp95 lat_abst (avexpr=democ1) indtime logem4

