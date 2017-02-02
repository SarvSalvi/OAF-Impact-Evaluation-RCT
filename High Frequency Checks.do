****High Frequency Checks

*Set-up and initializing
*Need to adjust path names before using the log
*log using "`path'\Frequency Check Log.smcl", replace 

*By Enumerator 

*By Site

*By Group

*Count if complete and after the date of Nov 7
count if consent_given != "Yes"
count if baseline_survey == "Complete" & datestart >= 20766
drop if baseline_survey != "Complete" & datestart < 20766

*Calculating the number of people surveyed in each site
sort site
by site: gen Site_Surveyed = _N 

*****Using mostly the variables listed as important (Maya's control list)

*Gender
tab respondent_gender

*experince vs. age.
list oafid last_name first_name site infousername if primary_farmer_experience > age
*This provides too much information the entire row all I want is the first line.
*problem seems to be decade if they said all their life or guessed, or if they gave year they started instead of number of years or missing

****Household Size Investigations
*# of households greater than or equal to 15
sum household_size
gen household_size_flag = 1 if household_size >= 15

*household farm work vs. household size

*Education
sum education_mother
sum mother_education_specified
sum father_education
sum father_education_specified

*Half Income from Farm Labor
sum half_income_farm_labor

*Loan and Credit Access
sum credit_access
sum size_of_loans, detail

*number of visist of extension officer
*number of farming orgs
*number of farmers with >5 and greater than 10 acres
count if acre_owned_2016 >=5 & acre_owned_2016 != .
count if acre_owned_2016 >=10 & acre_owned_2016 != .

count if acre_owned_2017 >=5 & acre_owned_2017 != .
count if acre_owned_2017 >=10 & acre_owned_2017 != .

count if maize_acres >=5 & maize_acres != .
count if maize_acres >=10 & maize_acres != .

*calculating maize yield per acre
*4100 maker is based on prior m&e data
gen per_acre_maize = maize_harvest_2016/maize_acres
gen flagged_harvest = per_acre_maize >=4100 & per_acre_maize != .
count if flagged_harvest == 1

/*
	*Creating list of farmers sorted by user where the rate is flagged
	preserve
	keep if flagged_harvest == 1
	keep site oafid last_name first_name infousername maize_harvest1 unit_of_maize1 maize_harvest2 unit_of_maize2 maize_acres maize_harvest_2016 per_acre_maize 
	sort infousername
	export excel using "C:\Users\bsalv\Documents\Work\One Acre Fund\Teso Trial\Teso Trial Docs\Baseline\Baseline Data\Baseline Survey\11-12-2016\High Harvests.xlsx", first(var) replace
	restore
*/
	
*Discrepancies between acres and harvest at the boundaries
*These are all 0 currently
count if maize_acres == 0 & maize_harvest_2016 > 0
count if maize_acres < 0
count if maize_acres > 0 & maize_harvest_2016 == 0

*Intercropping
*Percentage of farmers that already intercrop with beans
*Percentage of farmers new this season/don't know oaf planting practices but still intercrop
tab maize_intercropped
gen beans_intercrop_2016 = maize_intercropped == "Yes,_Beans"
gen beans_intercrop_knowledge = beans_intercrop_2016 == 1 & planting_method_knowledge == "Yes" 
sum beans_intercrop_knowledge

*Checking 

*acres of maize should be greater is they planted on more acres
*checking gps data by username
*Checks on group level contamination (knowing farmers from other groups)
*Score on test of OAF farmer practices
*Graphs by district graphs by enumerator
*Attrition rates
	*Broken down by source of attrition


*Creating list of poeple with incomplete surveys due to attrition (refused survey or someone from the household has already been surveyed.)
*Will have to match the observations in this sheet against the other people who claimed to have someone else in their household who are OAF.
/*
preserve 
keep if baseline_survey != "Complete"
keep last_name first_name phone_no oafid site group_name identifier infousername
export excel "`path'\CasesCheck.xlsx", firstrow(var) replace
restore
*/


*Checking number of complete surveys of unsually short length
bysort infousername: count if diffmin <= 20 & baseline_survey == "Complete"

*Checking number of incomplete surveys by enumerator
bysort infousername: count if baseline_survey != "Complete"

*Checking Productivity of surveyors
bysort infousername: count if baseline_survey == "Complete"

*Count of number of time non-main farmer was interviewed
count if main_farmer == "No"

*Checking for household sizes on the extreme:  1 and greater than 12
tab household_size

*Checking for the typos/ inplausible responses to various questions
*Number of acres
*tab acres_owned

****Pre-exposure Section:

*Number of people joining for the first time in 2017 without anyone else in their familiy having joined.
gen Not_Pre_Exposed = 1 if first_year == 2017 & other_household_oaf == "No"
count if first_year == 2017 & other_household_oaf == "No"

*Check Household Pre-exposure at the at the site level should be as a percentage right.
bysort site: gen site_obs_1 = _n == 1
bysort site: gen site_total = _N
bysort site: gen site_not_pre_exposed = sum(Not_Pre_Exposed)
egen max_site_not_exposed = max(site_not_pre_exposed), by(site)
gen site_ratio = max_site_not_exposed/site_total
*Listing Site Ratios
list site site_ratio site_total if site_obs_1 == 1

	

*Coming up with composite for quiz
/*
gen oaf_test = 0
foreach x of varlist row_width plant_spacing planting_fertilizer ploughing_frequency positioning_of_beans spacing_beans applying_top_dress top_dress_fertilizer {
	if x == row_width & row_width == 75 {
		replace oaf_test = oaf_test + 1
	}
	else if x == plant_spacing & plant_spacing == 25 {
		replace oaf_test = oaf_test + 1
	}
	else if x == planting_fertilizer & planting_fertilizer == "DAP" {
		replace oaf_test = oaf_test + 1
	}
	else if x == ploughing_frequency & ploughing_frequency == 3 | ploughing_frequency == 2 {
		replace oaf_test = oaf_test + 1
	}
	else if x == positioning_of_beans & positioning_of_beans == "Different_Row" {
		replace oaf_test = oaf_test + 1
	}
	else if x == spacing_beans & spacing_beans == 10 {
		replace oaf_test = oaf_test + 1
	}
	else if x == applying_top_dress & applying_top_dress == 2 {
		replace oaf_test = oaf_test + 1
	}
	else if x == top_dress_fertilizer & top_dress_fertilizer == "CAN" {
		replace oaf_test = oaf_test + 1
	}
}
*/
/*
gen oaf_test = 0
foreach x of varlist row_width plant_spacing planting_fertilizer ploughing_frequency positioning_of_beans spacing_beans applying_top_dress top_dress_fertilizer {
	if `x' == row_width & row_width == 75 {
		replace oaf_test = oaf_test + 1
	}
	else if `x' == "plant_spacing" & plant_spacing == 25 {
		replace oaf_test = oaf_test + 1
	}
	else if `x' == "planting_fertilizer" & planting_fertilizer == "DAP" {
		replace oaf_test = oaf_test + 1
	}
	else if `x' == "ploughing_frequency" & ploughing_frequency == 3 {
		replace oaf_test = oaf_test + 1
	}
	else if `x' == "positioning_of_beans" & positioning_of_beans == "Different_Row" {
		replace oaf_test = oaf_test + 1
	}
	else if `x' == "spacing_beans" & spacing_beans == 10 {
		replace oaf_test = oaf_test + 1
	}
	else if `x' == "applying_top_dress" & applying_top_dress == 2 {
		replace oaf_test = oaf_test + 1
	}
	else if `x' == "top_dress_fertilizer" & top_dress_fertilizer == "CAN" {
		replace oaf_test = oaf_test + 1
	}
}
*/
*Statistics of Pre-Exposure Tests:
*Preexposure score for those who said yes
*% of peeople who said no vs. yes
*% of people who said yes to knowing vs. did they use.

*****List of most important variables!  This is at the end so that all variables for analysis have been generated.
*analysis of averages by enumerator across those
*construction of composites for establishing when to redo a survey


*****Plotting GPS Data.
*Generating Excel Export to plot GPS data with other requested additions for dataset.
*Instead of adjacent sites I will have to use parent site only!  I don't have the information on all adjacent sites.  

*Calculating distance between 

*Matching households that have multiple people signing contracts
*first check is trying to match oaf id next level check might be using the name. (need to do a search that is not case-sensitive)
*From there I check whether they are in the same or different groups
/*gen household_match = .

		foreach x of oafid { 
			*local temp = oafid	
			foreach y of other_oafid {
				*local temp2 = other_oafid
				if `y' == `x' {
					replace household_match = 1
				}
			}
		}
*/

*log close 
