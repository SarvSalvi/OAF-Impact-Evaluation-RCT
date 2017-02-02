*List of missing surveys from the forms data and the master data set.
*No need to clear since this file is executed only when the master data set is executed.
*In the future it may be best to keep them independent but cooperative.

local path "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Baseline Data\Baseline Survey\29-01-2017"
local roster "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Baseline Data\Final Roster"

******Importing Teso Roster.
*Only update this 
*Updated to include the qualifiers only
do "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Case List\Roster for Qualifiers\Teso Qualifiers.do"
use "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Case List\Roster for Qualifiers\Teso Qualifiers.dta", clear

	keep if insample_tag == 1
	tostring oafid, replace
	gen unique_id = oafid + site

save "`roster'\Final Roster.dta", replace
******Merging in the Commcare Forms minus the majority of duplicates
merge 1:1 unique_id using "`path'\Master Data Set.dta", force

preserve 
keep if _merge == 3
save "`path'\Master Data Set.dta", replace
restore

*_merge ==2 is names not matched to anyone on roster and have been incorporated onto the coding sheet errors and or the duplicates database.
*After checking _merge == 2 at this point are all surveys that are not complete so its ok to let them go.
*Now to check how many of the 235 _merge == 1 (roster but no associated survey) are attrition
keep if _merge == 1
drop _merge
merge 1:1 unique_id using "`path'\Incompletes.dta", update
***Creating database of the households that have not yet been completed.
*Are they even on the case list?  Where did they come from or go?
keep if _merge != 2

*Generating idicator variable
gen Status = "Attempted" if _merge == 4
replace Status = "Not Attempted" if _merge == 1
drop _merge
save "`path'\Remaining_Surveys.dta", replace


*Exporting the file to excel
export excel Status site SectorName GroupName LastName FirstName oafid phone_no reason_no_substitute decision_taker final_decision using ///
		"`path'\Remaining_Surveys.xlsx", first(var) replace
		
	*Cleaning up the dataset
	*tostring OAFID, replace

*save "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Case List\TESO TRIAL CONTROL SHEET 2017 SITES FINAL.dta", replace

/*
*Importing Data from week 1 and then addending it to the case list for the rest of the weeks
import excel "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Case List\Week 1\TESO TRIAL CONTROL SHEET 2017.xls", firstrow clear

	*Cleaning up the dataset
	tostring OAFID, replace
	
	*Appending the previous dataset 
	append using "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Case List\TESO TRIAL CONTROL SHEET 2017 SITES FINAL.dta", gen(source)

	*Saving new complete caselist in the final's folder
save "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Case List\TESO TRIAL CONTROL SHEET 2017 SITES FINAL.dta", replace
wddwdw


*Merging master and caselist forms to capture the week sites
****UPDATE THE FILE NAME****
use "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Baseline Data\Baseline Survey\11-12-2016\Master Data Set.dta", clear

drop if baseline_survey != "Complete"
duplicates drop unique_id, force

merge 1:1 unique_id using "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Case List\TESO TRIAL CONTROL SHEET 2017 SITES FINAL.dta"

*Cleaning don't want to keep the people we havent done
gen source = "caselist not yet done" if _merge == 2 
replace source = "done not in caselist on comp but online" if _merge == 1
replace source = "done and on comp caselist" if _merge == 3  
drop _merge
save "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Case List\TESO TRIAL CONTROL SHEET 2017 SITES FINAL.dta", replace
*/



/*
*Finding the surveys that are not in the caselist.
merge 1:1 unique_id using "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Case List\TESO TRIAL CONTROL SHEET 2017 SITES FINAL.dta"


*getting list of farmers that are _merge 1 which means they are not 
preserve
drop if _merge != 1
export excel "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Baseline Data\Cases to Add.xlsx", firstrow(var) replace
restore
