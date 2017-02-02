*Constructing master data set

*****Initializing and setting paths.
clear all

local path "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Baseline Data\Baseline Survey\29-01-2017"

******Loading Repeat groups individually reshaping and saving

	*Beans Intercrop Group
	insheet using "`path'\Repeat- Baseline_Survey.Input_Use_2016.Maize_Questions.Beans_Intercrop.Beans_Commercial_Names.csv", names comma clear
			
	rename beans_commerical_seed beans_commercial_seed
	gen identifier = floor(rownumber)
	bysort identifier: generate number = _n
	keep beans_commercial_variety beans_commercial_seed number identifier

	reshape wide beans_commercial_variety beans_commercial_seed, i(identifier) j(number)
	save "`path'\Beans Intercrop Repeat.dta", replace

	*Maize Commercial Varieties
	insheet using "`path'\Repeat- Baseline_Survey.Input_Use_2016.Maize_Questions.Commercial_Varieties_Data.csv", names comma clear

	gen identifier = floor(rownumber)
	bysort identifier: generate number = _n
	drop rownumber rownumber__0	rownumber__1
	
	reshape wide commercial_maize_seed commercial_maize_series commercial_maize_variety commerical_variety other_seed_series seed_other source_of_seed, i(identifier) j(number)

	save "`path'\Maize Commercial Varieties.dta", replace

	*Maize Harvest Group
	insheet using "`path'\Repeat- Baseline_Survey.Input_Use_2016.Maize_Questions.Harvest_Unit_Group.csv", names comma clear

	gen identifier = floor(rownumber)
	bysort identifier: generate number = _n
	drop rownumber rownumber__0	rownumber__1

	reshape wide maize_harvest maize_harvest_unit_other unit_of_maize, i(identifier) j(number)

	save "`path'\Maize Harvest.dta", replace

	*Maize Other Fertilizer
	insheet using "`path'\Repeat- Baseline_Survey.Input_Use_2016.Maize_Questions.Other_Fertilizer.csv", names comma clear

	gen identifier = floor(rownumber)
	bysort identifier: generate number = _n
	drop rownumber rownumber__0	rownumber__1
	reshape wide fertilizer_other maize_other_fertilizer maize_other_fertilizer_kgs other_fertilizer other_fertilizer_purchase, i(identifier) j(number)

	save "`path'\Maize Other Fertilizer.dta", replace

	*Other Crops Group
	insheet using "`path'\Repeat- Baseline_Survey.Input_Use_2016.Other_Crops.Common_Crops.csv", names comma clear

	gen identifier = floor(rownumber)
	bysort identifier: generate number = _n
	drop rownumber rownumber__0	rownumber__1
	reshape wide other_commercial_variety other_crop_acres other_crop_commerical other_crop_fertilizer other_crop_name other_local_variety, i(identifier) j(number)

	save "`path'\Other Crops.dta", replace

	*2015 Maize Harvest Group
	insheet using "`path'\Repeat- Baseline_Survey.Long_Rains_2015.Maize_2015.Unit_Repeat.csv", names comma clear

	rename unit_of_maize unit_maize_2015_ 
	rename maize_harvest maize_harvest_2015_
	rename maize_harvest_unit_other unit_maize_other_2015_
	
	gen identifier = floor(rownumber)
	bysort identifier: generate number = _n
	drop rownumber rownumber__0	rownumber__1
	reshape wide maize_harvest_2015_ unit_maize_other_2015_ unit_maize_2015_ , i(identifier) j(number)

	save "`path'\Maize Harvest 2015.dta", replace

	*Major Expenses repeat
	insheet using "`path'\Repeat- Baseline_Survey.Major_Expenses_and_Investments.Major_Expenses_Repeat.csv", names comma clear

	gen identifier = floor(rownumber)
	bysort identifier: generate number = _n
	drop rownumber rownumber__0	rownumber__1
	reshape wide amount_of_expenses major_expense month, i(identifier) j(number)

	save "`path'\Major Expenses.dta", replace

	*Major Expenses repeat number 2
	*where is this coming from?
	insheet using "`path'\Repeat- Baseline_Survey.Major_Expenses_Repeat.csv", names comma clear

	gen identifier = floor(rownumber)
	bysort identifier: generate number = _n
	drop rownumber rownumber__0	rownumber__1
	reshape wide amount_of_expenses major_expense month, i(identifier) j(number)

	save "`path'\Major Expenses p2.dta", replace

	*OAF Members from other groups
	insheet using "`path'\Repeat- Baseline_Survey.OAF_Exposure.Other_Farmers.csv", names comma clear

	gen identifier = floor(rownumber)
	bysort identifier: generate number = _n
	drop rownumber rownumber__0	rownumber__1
	reshape wide group_name name_of_other_farmer name_of_village, i(identifier) j(number)

	save "`path'\Other OAF Members.dta", replace

	*Additional Contact Info
	insheet using "`path'\Repeat- Respondent_Additionl_Info.Contact_Information.csv", names comma clear

	gen identifier = floor(rownumber)
	duplicates drop farmer_contact, force
	keep farmer_contact identifier
	bysort identifier: generate number = _n
	reshape wide farmer_contact, i(identifier) j(number)

	save "`path'\Contact Info Repeat.dta", replace
	
	*Merging in the completed Back-check Forms
	*do "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Baseline Data\Back-Check Data Set.do"

*****Loading Forms Data Merging and Cleaning
insheet using "`path'\Forms.csv", comma names clear

rename rownumber identifier

*Prepping for merging

*****Merging in all files
*I should come back and check out the replace options I have added here.
merge 1:1 identifier using "`path'\Beans Intercrop Repeat.dta", nogenerate replace update
merge 1:1 identifier using "`path'\Maize Commercial Varieties.dta", nogenerate replace update
merge 1:1 identifier using "`path'\Maize Harvest.dta", nogenerate replace update
merge 1:1 identifier using "`path'\Maize Other Fertilizer.dta", nogenerate 
merge 1:1 identifier using "`path'\Other Crops.dta", nogenerate replace update
merge 1:1 identifier using "`path'\Maize Harvest 2015.dta", nogenerate replace update
merge 1:1 identifier using "`path'\Major Expenses.dta", nogenerate replace update
merge 1:1 identifier using "`path'\Major Expenses p2.dta", nogenerate replace update
merge 1:1 identifier using "`path'\Other OAF Members.dta", nogenerate replace update // something to do with the reshape variable treated group_name == group_name1
merge 1:1 identifier using "`path'\Contact Info Repeat.dta", nogenerate replace update
*merge 1:1 oafid phone_no using "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Baseline Data\Back-check\Data\06-12-2016\BC Data Set.dta" 

****DATA CLEANING
*Dropping practice forms from piloting/training 
*Purposely not using the date on which surveys started which might have some error.
drop if site == "---"
drop if infousername == "samora.m"

*Cleaning Site Name Errors
replace site = "Achit" if site == "achit"
replace site = "Adanya" if site == "Adanya A" | site == "A" | site == "2" // checked all cases with these issues in roster.
replace site = "Akolong" if site == "Akolongo"
replace site = "Chelelemuk" if site == "Chelelemuku" | site == "Katelepai"  |site == "chelelemuk" // This is potentially wrong
replace site = "Emukhuyu" if site == "Emukhuyhu" | site == "Kisoko" | site == "emukhuyu" | site == "Emukhuy" | site == "ouma" // kisoko and ouma( name) checked in roster as well.
replace site = "Katelenyang" if site == "Ketelenyang" |  site == "katelenyang" 
replace site = "Namamali" if site == "Nanamali" | site == "namamali"
replace site = "Osasame" if site == "asasame" | site == "osasame"
replace site = "Kakurkit" if site == "kakurikit" | site == "kakurkit"
replace site = "Kekalet" if site == "kekalet"
replace site = "Khasoko" if site == "khasoko"
replace site = "Khelela" if site == "khelela"
replace site = "Kidera" if site == "kidera"
replace site = "Okook" if site == "okook" | site == "Okok"
*Fixing special -99's - All seem to be from Chelelemuk in roster using oafid and cross checking names though two need to be called different names for the same ID
replace site = "Chelelemuk" if site == "-99"
*Dropping surveys from Apokor
drop if site == "Apokor"

*Cleaning Errors in Incorrectly Re-Entered IDs and Sites
replace site = "Osasame" if oafid == "30167" |  oafid == "30174"
replace site = "Chelelemuk" if oafid == "45180"
*Two remain.

*Generating unique_ids
*This is supposed to be the equivalent of the infocaseid but I need to make sure its 1:1 at the end.
gen unique_id = oafid + site	

*saving before checking duplicates
save "`path'\Master Data Set.dta", replace

*Checking duplciates by runing Duplicates.do
do "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Baseline Data\Duplicates.do"

*Loading the Master Data Set again after the Duplicates analysis.
use "`path'\Master Data Set.dta"

******Generating Complete List of Attempted but Incomplete Surveys minus the Duplicates
preserve 
*They will become either attrition if there is no match among the completes or we will know who has at least been attempted.
keep if baseline_survey != "Complete"
drop if oafid == ""
duplicates tag oafid, gen(dup_incomplete)

*Removing the duplicates among the incompletes
duplicates tag unique_id, gen(dups_unique_id)
duplicates drop unique_id, force

save "`path'\Incompletes.dta", replace
restore

****Dropping all the Incomplete Surveys 
drop if baseline_survey != "Complete"
save "`path'\Master Data Set.dta", replace

*temporarily dropping the unresolved duplicates in order to at least merge with the roster and incompletes!
duplicates drop unique_id, force
save "`path'\Master Data Set.dta", replace
*****Making sure there is a 1:1 macth between infocaseid, unique_id and infoformid

****Checking against Roster
do "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Baseline Data\Missing Cases.do"

*Loading the master data set again
use "`path'\Master Data Set.dta", clear

*********Cleaning
*Formating the Date
*Changing into seconds adjusting for leap seconds
gen double timestart = Clock(infostarted_time, "YMDhms")
gen double timeend = Clock(infocompleted_time, "YMDhms")
gen diffms = timeend-timestart
*Claculate the number of minutes that pass between start and end.
gen diffmin = diffms/(60000)

gen datestart = dofc(timestart)
gen dateend = dofc(timeend)

*Parsing Date
gen yearstart = year(datestart)
gen monthstart = month(datestart)
gen daystart = day(datestart)
gen hourstart = hh(timestart)
gen minutestart = mm(timestart)
gen secondstart = ss(timestart)

gen yearend = year(dateend)
gen monthend = month(dateend)
gen dayend = day(dateend)
gen hourend = hh(timestart)
gen minuteend = mm(timestart)
gen secondend = ss(timestart)

*Formating time so it is readable but it is already readable no?
format timestart %tC
format timeend %tC

*recode --- as missing across all variables.
ds, has(type string) 

quietly foreach v in `r(varlist)' { 
    replace `v' = "" if inlist(`v', "---") 
}

*Destringing various integer variables
destring acre_owned_2017 planned_acres_2017 planted_acres_2016 acre_owned_2016 maize_acres beans_acres other_crop_acres maize_acres_2015 acres_sr2016 ///
		 kgs_beans_commerical kgs_beans_local_seeds maize_other_fertilizer_kgs kgs_local_maize maize_other_fertilizer_kgs1 maize_other_fertilizer_kgs2 ///
		 crops_besides_maize contact_numbers number_of_units number_of_farmers beans_harvest maize_harvest maize_harvest_2015 household_size household_18 ///
		 birth_year mother_education_specified father_education_specified beans_commercial_seeds maize_dap maize_can maize_commercial_varieties harvest_units_2015 ///
		 dap_2015 can_2015 first_hear first_year seasons household_joined household_seasons other_groups row_width plant_spacing ploughing_frequency applying_top_dress ///
		 extension_officer_visits farming_orgs household_farm_work primary_farmer_experience maize_income total_income months_of_labor irons mosquito_nets towels frying_pans ///
		 habitable_rooms size_of_loans major_expenses planned_expenses_non age other_oafid spacing_beans, replace /// check which ones are successful


*Relabelling all variables

*Creating condensed variables measuring size of harvest
*Still need to consider if the other option was used.

*Cleaning unit of maize for all columns in 2015 and 2016 
*Turning strings into things that can be destringed
ds, has(type string) 

quietly foreach v in `r(varlist)' {
    replace `v' = "90" if inlist(`v', "90_kg_bag") | inlist(`v', "45 goro bag") | inlist(`v', "90 kg bag") | inlist(`v', "45 goro bag") | inlist(`v', "45 goros bag") ///
	| inlist(`v', "45 Goro bag") 
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "2" if inlist(`v', "Goros") 
}	


quietly foreach v in `r(varlist)' { 
    replace `v' = "100" if inlist(`v', "100_kg") | inlist(`v', "50 goro bag") | inlist(`v', "50 goros bag") 
}


quietly foreach v in `r(varlist)' { 
    replace `v' = "50" if inlist(`v', "50_kg_bag") | inlist(`v', "25 goros bag") 
}


quietly foreach v in `r(varlist)' { 
    replace `v' = "" if inlist(`v', "Other") 
} 

quietly foreach v in `r(varlist)' { 
    replace `v' = "80" if inlist(`v', "40 goro bag") | inlist(`v', "40 goros bag") | inlist(`v', "40 goros  bag") | inlist(`v', "40 goro  bag") ///
					| inlist(`v', "40goros bag") | inlist(`v', "40 goro") |  inlist(`v', "40 goros")  | inlist(`v', "40 Goros bag") | inlist(`v', "80 kg bag") ///
					| inlist(`v', "40 goros bag") | inlist(`v', "40 Goro bag") | inlist(`v', "40 GORO BAG") | inlist(`v', "40 goros bag.")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "160" if inlist(`v', "80 goro bag") | inlist(`v', "80 goros bag") | inlist(`v', "80 goros  bag") | inlist(`v', "80 goro  bag") ///
					| inlist(`v', "80 goros bag") | inlist(`v', "80 Goro bag") | inlist(`v', "160 kg bag") | inlist(`v', "80goro bag") ///
					| inlist(`v', "160 Kg bag") | inlist(`v', "80 Goro Bag") | inlist(`v', "80goro bag")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "180" if inlist(`v', "90 goro bag") | inlist(`v', "90 goros bag") | inlist(`v', "90 goros  bag") | inlist(`v', "90 goro  bag") ///
					| inlist(`v', "90 goros bag") | inlist(`v', "90 Goro bag") | inlist(`v', "90 GORO BAG") | inlist(`v', "bags carrying 90 goros")  ///
				    | inlist(`v', "180 kg  bag") 
}


quietly foreach v in `r(varlist)' { 
    replace `v' = "86" if inlist(`v', "43 goro bag") | inlist(`v', "90 goros bag") | inlist(`v', "43 goros  bag") | inlist(`v', "43 goro  bag") ///
					| inlist(`v', "43 goros bag") | inlist(`v', "90 Goro bag") | inlist(`v', "43 GORO BAG") | inlist(`v', "43goros bag") 
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "74" if inlist(`v', "37 goro bag") | inlist(`v', "37 goros bag") | inlist(`v', "37 goros  bag") | inlist(`v', "37 goro  bag") ///
					| inlist(`v', "37 goros bag") | inlist(`v', "37 Goro bag") | inlist(`v', "37 GORO BAG") | inlist(`v', "3 7 goros")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "120" if inlist(`v', "60 goro bag") | inlist(`v', "60 goros bag") | inlist(`v', "60 goros  bag") | inlist(`v', "60 goro  bag") ///
					| inlist(`v', "60 goros bag") | inlist(`v', "60 Goro bag") | inlist(`v', "60 GORO BAG") | inlist(`v', "120 kg bag") | inlist(`v', "120 Kg bag")  ///
					| inlist(`v', "60goros bag") | inlist(`v', "120kg bag") | inlist(`v', "120 kg bag.")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "70" if inlist(`v', "35 goro bag") | inlist(`v', "35 goros bag") | inlist(`v', "35 goros  bag") | inlist(`v', "35 goro  bag") ///
					| inlist(`v', "35 goros bag") | inlist(`v', "35 Goro bag") | inlist(`v', "35 GORO BAG") 
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "82" if inlist(`v', "42 goro bag") | inlist(`v', "42 goros bag") | inlist(`v', "42 goros  bag") | inlist(`v', "42 goro  bag") ///
					| inlist(`v', "42 goros bag") | inlist(`v', "42 Goro bag") | inlist(`v', "42 GORO BAG") 
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "60" if inlist(`v', "30 goro bag") | inlist(`v', "30 goros bag") | inlist(`v', "30 goros  bag") | inlist(`v', "30 goro  bag") ///
					| inlist(`v', "30 goros bag") | inlist(`v', "30 Goro bag") | inlist(`v', "30 GORO BAG") | inlist(`v', "60kg bag.") | inlist(`v', "60 Kg bag") ///
					| inlist(`v', "30  goro bag")	
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "140" if inlist(`v', "70 goro bag") | inlist(`v', "70 goros bag") | inlist(`v', "70goros bag") | inlist(`v', "70 goros  bag") | inlist(`v', "70 goro  bag") ///
					| inlist(`v', "70 goros bag") | inlist(`v', "70 Goro bag") | inlist(`v', "70 GORO BAG") 
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "200" if inlist(`v', "100 goro bag") | inlist(`v', "100 goros bag") | inlist(`v', "100 goros  bag") | inlist(`v', "100 goro  bag") ///
					| inlist(`v', "100 goros bag") | inlist(`v', "100 Goro bag") | inlist(`v', "100 GORO BAG") | inlist(`v', "200  kg  bag") | inlist(`v', "200 kgs bag") ///
					| inlist(`v', "100 bag goros") | inlist(`v', "2000  kg  bag") | inlist(`v', "200 KG BAG") | inlist(`v', "100goro bag")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "94" if inlist(`v', "47 Goros bag") | inlist(`v', "47 goros bag") | inlist(`v', "47 goros  bag") | inlist(`v', "47 goro  bag") ///
					| inlist(`v', "47 goros bag") | inlist(`v', "47 Goro bag") | inlist(`v', "47 GORO BAG") | inlist(`v', "94  kg  bag") | inlist(`v', "94 kgs bag") ///
					| inlist(`v', "47goros bag") | inlist(`v', "47 Goros  bag.") | inlist(`v', "47 goro bag")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "110" if inlist(`v', "55 Goros bag") | inlist(`v', "55 goros bag") | inlist(`v', "55 goros  bag") | inlist(`v', "55 goro  bag") ///
					| inlist(`v', "55 goros bag") | inlist(`v', "55 Goro bag") | inlist(`v', "55 GORO BAG") | inlist(`v', "110  kg  bag") | inlist(`v', "110 kgs bag") 
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "40" if inlist(`v', "20 goros bag") | inlist(`v', "20 goros bag") | inlist(`v', "20 goros  bag") | inlist(`v', "20 goro  bag") ///
					| inlist(`v', "40  kg  bag") | inlist(`v', "40kgs bag") | inlist(`v', "40kg bag") | inlist(`v', "20goro  bag") | inlist(`v', "40 Kg bag") ///
					| inlist(`v', "40 kg bag") | inlist(`v', "40kg bag") | inlist(`v', "40 kgs bag") | inlist(`v', "20 goros") | inlist(`v', "20 goros") | inlist(`v', "40kg  bag")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "76" if inlist(`v', "38 goro bag") | inlist(`v', "38 goros bag")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "112" if inlist(`v', "56 goros bag") 
}
quietly foreach v in `r(varlist)' { 
    replace `v' = "104" if inlist(`v', "52 goro bag") 
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "150" if inlist(`v', "75 goro bag") | inlist(`v', "75 goros bag")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "72" if inlist(`v', "36 goro bag") | inlist(`v', "72 kg bag") | inlist(`v', "72kg bag")  
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "70" if inlist(`v', "70 Kg bag") | inlist(`v', "70 kg bag") | inlist(`v', "70kg bag")  
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "91" if inlist(`v', "91 Kg bag") | inlist(`v', "91 kg bag") | inlist(`v', "91kg bag")  | inlist(`v', "91kgs bag")  
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "92" if inlist(`v', "46 goro bag") 	
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "96" if inlist(`v', "48 goro bag") 	
}
quietly foreach v in `r(varlist)' { 
    replace `v' = "88" if inlist(`v', "44 goro bag") | inlist(`v', "4 4 goros bag")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "68" if inlist(`v', "34 Goros bag.")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "46" if inlist(`v', "23 goro bag") 
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "55" if inlist(`v', "55 KG Bag") 
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "190" if inlist(`v', "190  kg bag") | inlist(`v', "190 kg bag") | inlist(`v', "190kg bag")  | inlist(`v', "190kgs bag")  | inlist(`v', "95 goros bag")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "170" if inlist(`v', "170 Kg bag") | inlist(`v', "170 kg bag") | inlist(`v', "170kg bag")  | inlist(`v', "170kgs bag") | inlist(`v', "85 goro bag")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "45" if inlist(`v', "45 Kg bag") | inlist(`v', "45 kg bag") | inlist(`v', "45kg bag")  | inlist(`v', "45kgs bag") | inlist(`v', "hakf of 90 goros bag")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "30" if inlist(`v', "15 goro bag")
}
quietly foreach v in `r(varlist)' { 
    replace `v' = "300" if inlist(`v', "300 kg bag")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "20" if inlist(`v', "10 goros bag")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "16" if inlist(`v', "8 goro can")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "16" if inlist(`v', "8 goro can")
}

quietly foreach v in `r(varlist)' { 
    replace `v' = "38" if inlist(`v', "19 goro bag")
}

*Accidental entry.
quietly foreach v in `r(varlist)' { 
    replace `v' = "" if inlist(`v', "na") | inlist(`v', "NA") | inlist(`v', "N/A")  | inlist(`v', "n/a") | inlist(`v', "N/a") | inlist(`v', "none")
}
*I should have done this cleaning in the section where I reshaped and then merged.
*how did others get selected and the regular option?

*merging cleaned 'other' units with the standard units.
*This is for the 2016 data
foreach v of numlist 1 2 3 4 5 6 7 8 {
	replace unit_of_maize`v' = maize_harvest_unit_other`v' if unit_of_maize`v' == "" & maize_harvest_unit_other`v' != ""	
}

*For the 2015 data
foreach v of numlist 1 2 3 4 5 6 {
	replace unit_maize_2015_`v' = unit_maize_other_2015_`v' if unit_maize_2015_`v' == "" & unit_maize_other_2015_`v' != ""	
}

*Prepping for adding up the 2016 harvest data.
rename maize_harvest maize_harvest_2016
destring unit_of_maize1 unit_of_maize2 unit_of_maize3 unit_of_maize3 unit_of_maize4 unit_of_maize5 unit_of_maize6 unit_of_maize7 unit_of_maize8, force replace

replace maize_harvest_2016 = unit_of_maize1*maize_harvest1 if maize_harvest1 != . 
	replace  maize_harvest_2016 = maize_harvest_2016 + unit_of_maize2*maize_harvest2 if maize_harvest2 != . 
	replace  maize_harvest_2016 = maize_harvest_2016 + unit_of_maize3*maize_harvest3 if maize_harvest3 != . 
	replace  maize_harvest_2016 = maize_harvest_2016 + unit_of_maize4*maize_harvest4 if maize_harvest4 != . 
	replace  maize_harvest_2016 = maize_harvest_2016 + unit_of_maize5*maize_harvest5 if maize_harvest5 != . 
	replace  maize_harvest_2016 = maize_harvest_2016 + unit_of_maize6*maize_harvest6 if maize_harvest6 != . 
	replace  maize_harvest_2016 = maize_harvest_2016 + unit_of_maize7*maize_harvest7 if maize_harvest7 != . 
	replace  maize_harvest_2016 = maize_harvest_2016 + unit_of_maize8*maize_harvest8 if maize_harvest8 != . 


*Generating the total value of the maize harvest of 2015
destring unit_maize_2015_1 unit_maize_2015_2 unit_maize_2015_3 unit_maize_2015_4 unit_maize_2015_5 unit_maize_2015_6, force replace 

replace maize_harvest_2015 = unit_maize_2015_1*maize_harvest_2015_1 if maize_harvest_2015_1 != .
replace  maize_harvest_2015 = maize_harvest_2015 + unit_maize_2015_2*maize_harvest_2015_2 if maize_harvest_2015_2 != . 
replace  maize_harvest_2015 = maize_harvest_2015 + unit_maize_2015_3*maize_harvest_2015_3 if maize_harvest_2015_3 != .
replace  maize_harvest_2015 = maize_harvest_2015 + unit_maize_2015_4*maize_harvest_2015_4 if maize_harvest_2015_4 != .
replace  maize_harvest_2015 = maize_harvest_2015 + unit_maize_2015_5*maize_harvest_2015_5 if maize_harvest_2015_5 != .
replace  maize_harvest_2015 = maize_harvest_2015 + unit_maize_2015_6*maize_harvest_2015_6 if maize_harvest_2015_6 != .

*****Checking the maize harvests for 2016 an 2015 that are missing despite claiming a harvest.
*What is a debe

*Parsing the GPS location data
*There are fours parts in the string lat, long, altitude, accuracy - all seperated by a single space.
split gps1, parse()
rename gps11 lat1
rename gps12 long1
rename gps13 alt1
rename gps14 acc1
destring lat1 long1 alt1 acc1, replace
*Save data into excel file with Site Name, Age of Parent Site, % of new farmers in that site.
*Then we upload the data set to google maps like the last map that was made!
*This will be done in the below section becuase that is where the calculations for site ratio are.

****General Cleaning
replace household_size = 7 if identifier == 1856
replace household_18 = 5 if identifier == 1856
replace birth_year = 1978 if identifier == 1856
replace birth_year = 1976 if site == "Emukhuyu" & oafid == "45383"
replace household_size = 6 if site == "Emukhuyu" & oafid == "45383"
replace birth_year = 1976 if site == "Emukhuyu" & oafid == "45383"
replace household_size = 6 if site == "Kakurkit" & oafid == "29771"

*Cleaning Education:
replace father_education_specified = . if father_education_specified > 8 
replace mother_education_specified = . if mother_education_specified > 8 

*Cleaning Loan Size
replace size_of_loans = . if size_of_loans <= 0

****Creating Dummies
*infousername dummies for regression

*Half Income from Farm Labor
replace half_income_farm_labor = "1" if half_income_farm_labor == "Yes"
replace half_income_farm_labor = "0" if half_income_farm_labor == "No"
destring half_income_farm_labor, replace

*Credit Access
gen credit_access = received_loan == "Yes" | loan_accessability == "Yes"

gen age_parent_site = .

replace age_parent_site = 2013 if site == "Achit"
replace age_parent_site = 2012 if site == "Adanya"	
replace age_parent_site = 2010 if site == "Akolong"	
replace age_parent_site = 2012 if site == "Apatit"	
replace age_parent_site = 2012 if site == "Chelelemuk"
replace age_parent_site = 2012 if site == "Emukhuyu"
replace age_parent_site = 2012 if site == "Kakurkit"
replace age_parent_site = 2014 if site == "Katelenyang"
replace age_parent_site = 2012 if site == "Kekalet"
replace age_parent_site = 2012 if site == "Khasoko"
replace age_parent_site = 2011 if site == "Khelela"
replace age_parent_site = 2013 if site == "Kidera"
replace age_parent_site = 2014 if site == "Namamali"
replace age_parent_site = 2014 if site == "Okook"
replace age_parent_site = 2013 if site == "Osasame"

	
*Saving Master Data Set
drop _merge
save "`path'\Master Data Set.dta", replace

****Clusters and Dropped Groups
do "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Teso Trial Drops\Dropped Clients.do"

*Loading master data set again before cleaning.
use "`path'\Master Data Set.dta", clear

****Summary Stats and Sense Checks
do "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Baseline Data\High Frequency Checks.do"

save "`path'\Master Data Set.dta", replace
