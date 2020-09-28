clear all
set more off

// Change this to your path!
cd "/Users/jocel/OneDrive/Documents/1433shortproject/"

import excel "Voting.xlsx", sheet("Voting") first case(lower)

// create a difference in precip variable using all existing data
gen prcpmm_n = real(prcpmm)
gen prcpmm1015_n = real(prcpmm1015)
gen prcpmmdiff = prcpmm_n - prcpmm1015_n

// turns below variables into purely numbers for analyzing (deletes NA columns)
gen voted_n = real(voted)
gen democrat_n = real(democrat)
gen votedphysical_n = real(votedphysical)

// what % of people who needed to vote physical did of total population
// excludes people who voted another way besides in person on the day
gen official_turnout = votedphysical_n / (real(registered) - voted_n + votedphysical_n)

// // collect descriptive data on key catagories
summarize voted_n votedphysical_n official_turnout medianincome prcpmmdiff if official_turnout > 0

// regressions
ivregress 2sls official_turnout prcpmmdiff sharewhite shareblack eductillhs educsomecollege if official_turnout > 0

// first check @ larger splits, 50k and 60k
ivregress 2sls official_turnout prcpmmdiff sharewhite shareblack eductillhs educsomecollege if medianincome <= 50 & official_turnout > 0
ivregress 2sls official_turnout prcpmmdiff sharewhite shareblack eductillhs educsomecollege if medianincome > 50 & official_turnout > 0
ivregress 2sls official_turnout prcpmmdiff sharewhite shareblack eductillhs educsomecollege if medianincome <= 60 & official_turnout > 0
ivregress 2sls official_turnout prcpmmdiff sharewhite shareblack eductillhs educsomecollege if medianincome > 60 & official_turnout > 0


// check using subsets of 10k each
ivregress 2sls official_turnout prcpmmdiff sharewhite shareblack eductillhs educsomecollege if medianincome > 50 & medianincome <= 60 & official_turnout > 0
ivregress 2sls official_turnout prcpmmdiff sharewhite shareblack eductillhs educsomecollege if medianincome > 60 & medianincome <= 70 & official_turnout > 0
ivregress 2sls official_turnout prcpmmdiff sharewhite shareblack eductillhs educsomecollege if medianincome > 70 & medianincome <= 80 & official_turnout > 0

// find total to determine impact 
total voted_n if medianincome > 60 & medianincome <= 70

