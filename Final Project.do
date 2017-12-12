/***********************//////////Gabby Mora////////////***********************/

                         /////////*Final Project*//////
                         ////////*Data Management*/////
                         //////////*Fall 2017*/////////

/*------------------------------------------------------------------------------
Research Questions
1- Does socio-economic status affect the number of animal abuse incidents in NYC?
2- Is there a connection between socio-economic status and other demographic items
and the number of animal abuse incidents in NYC?
3- Is there a difference between male and female when it comes to the severity
of animal abuse incidents in NYC?
4- What are the main factors affecting the severity of animal abuse incidents
in NYC?
------------------------------------------------------------------------------*/


/******************************************************************************
--------------------------------HYPOTHESIS-------------------------------------
********************************************************************************
As research in animal abuse points to an increase in incidents in areas of low
income and low education, this analysis of data from New York City should show
that socio-economic status is the main predictor for animal abuse.
With the exception of the Demographics and Animal Abuse datasets, the datasets
used in this research were selected as proxys for low socio-economic status as
areas with access to gardens and farmers markets tend to be areas of higher
socio-economic status. Furthermore, the variables connected to available financial
options found in the HIV Testing Centers dataset serve as a proxy income as it 
is expected that HIV Testing Centers found in areas of lower socio-economic status
will offer more financial options.
For this PS, I only used the Demographics dataset because it was the merge that
worked the best and it provided me with a socio-economic related variable as it 
included the nummber of people who received government assistance, which is an
indicator of socio-economic status.
*******************************************************************************/


/*******************************************************************************
----------------------------------DATASETS--------------------------------------
Please note that all my datasets for this research came from the NYC Open Data
website https://opendata.cityofnewyork.us/
*******************************************************************************/


/*------------------------------------------------------------------------------
********************************************************************************
--------------------------------------------------------------------------------
                       CLEAN UP AND RESHAPING MY DATASETS
--------------------------------------------------------------------------------
********************************************************************************
------------------------------------------------------------------------------*/

import excel "https://docs.google.com/uc?id=0BywXSn44t-HlS19LS0Z1cnVoQkE&export=download", firstrow clear
 
/*______________________________________________________________________________
                            ANIMAL CRUELTY DATASET
______________________________________________________________________________*/

drop UniqueKey CreatedDate ClosedDate Agency IncidentAddress StreetName CrossStreet1 CrossStreet2 IntersectionStreet1 IntersectionStreet2 AddressType Landmark Status DueDate ResolutionActionUpdatedDate CommunityBoard Borough XCoordinateStatePlane YCoordinateStatePlane ParkFacilityName ParkBorough SchoolName SchoolNumber SchoolRegion SchoolCode SchoolPhoneNumber SchoolAddress SchoolCity SchoolState SchoolZip SchoolNotFound SchoolorCitywideComplaint VehicleType TaxiCompanyBorough TaxiPickUpLocation BridgeHighwayName BridgeHighwayDirection RoadRamp BridgeHighwaySegment GarageLotName FerryDirection FerryTerminalName Latitude Longitude Location

edit 
 
tab Descriptor

/*This helped me see the number of animal abuse incidents per severity, which I
will use later to collapse into 3 categories according to the level of severity

               Descriptor |      Freq.     Percent        Cum.
--------------------------+-----------------------------------
                  Chained |         40        6.31        6.31
                   In Car |         38        5.99       12.30
                Neglected |        292       46.06       58.36
               No Shelter |         23        3.63       61.99
Other (complaint details) |        149       23.50       85.49
                 Tortured |         92       14.51      100.00
--------------------------+-----------------------------------
                    Total |        634      100.00
*/


encode Descriptor, generate(Descriptor_n)

move Descriptor_n Descriptor

drop Descriptor

rename Descriptor_n Descriptor

tab LocationType

/*This helped me see how many different types of locations were included in the 
dataset ad lead me to combine all residential areas

             Location Type |      Freq.     Percent        Cum.
---------------------------+-----------------------------------
                Commercial |          2        0.32        0.32
           House and Store |          3        0.47        0.79
           Park/Playground |         14        2.21        3.00
      Residential Building |         18        2.84        5.84
Residential Building/House |        379       59.78       65.62
          Store/Commercial |         52        8.20       73.82
           Street/Sidewalk |        166       26.18      100.00
---------------------------+-----------------------------------
                     Total |        634      100.00

*/

describe LocationType

replace LocationType = subinstr(LocationType, "/", "",.)

generate Location=0
//ResPrivate=1, Public=2, NonResidential=0//

replace Location=0 if LocationType=="StoreCommercial" | LocationType=="House and Store" | LocationType=="Commercial" 

replace Location=1 if LocationType=="Residential Building" | LocationType=="Residential BuildingHouse"

replace Location=2 if LocationType=="StreetSidewalk" | LocationType=="ParkPlayground"

encode LocationType, generate(LocationType_n)

move LocationType_n LocationType

drop LocationType

rename LocationType_n LocationType

rename IncidentZip ZipCode

save Animal_Abuse_COMPLETE, replace

/*______________________________________________________________________________
                          HIV TESTING CENTERS DATASET
______________________________________________________________________________*/
clear

import excel "https://docs.google.com/uc?id=0BywXSn44t-HlSmdVS2swdU4ycVE&export=download", firstrow clear

drop SiteID AgencyID Address City Borough State BriefDescription AgesServed GendersServed RequiredDocuments Website PhoneNumber BuildingFloorSuite AdditionalInformation

drop HoursMonday HoursTuesday HoursWednesday HoursThursday HoursFriday HoursSaturday HoursSunday Intake OtherInsurances SiteLanguages

encode ZipCode, generate(ZipCode_n)

drop ZipCode

rename ZipCode_n ZipCode

replace ZipCode=0 if ZipCode==.

save HIV_Testing_Centers_Clean, replace

/*______________________________________________________________________________
                          DEMOGRAPHICS DATASET
______________________________________________________________________________*/

clear

import excel "https://docs.google.com/uc?id=0BywXSn44t-HlMURzMmVjUExDRjg&export=download", firstrow clear

rename JURISDICTIONNAME ZipCode

drop COUNTGENDERUNKNOWN PERCENTGENDERUNKNOWN PERCENTFEMALE PERCENTMALE COUNTGENDERTOTAL PERCENTGENDERTOTAL PERCENTPACIFICISLANDER PERCENTHISPANICLATINO PERCENTAMERICANINDIAN PERCENTASIANNONHISPANIC PERCENTWHITENONHISPANIC PERCENTBLACKNONHISPANIC PERCENTOTHERETHNICITY PERCENTETHNICITYUNKNOWN COUNTETHNICITYTOTAL PERCENTETHNICITYTOTAL COUNTPERMANENTRESIDENT PERCENTPERMANENTRESIDENT COUNTUSCITIZEN PERCENTUSCITIZEN COUNTOTHERCITIZENSTATUS PERCENTOTHERCITIZENSTATUS COUNTCITIZENSTATUSUNKNOWN PERCENTCITIZENSTATUSUNKNOWN COUNTCITIZENSTATUSTOTAL PERCENTCITIZENSTATUSTOTAL PERCENTRECEIVESPUBLICASSISTAN PERCENTNRECEIVESPUBLICASSISTA PERCENTPUBLICASSISTANCEUNKNOW PERCENTPUBLICASSISTANCETOTAL

rename(COUNTPARTICIPANTS COUNTFEMALE COUNTMALE COUNTPACIFICISLANDER COUNTHISPANICLATINO COUNTAMERICANINDIAN COUNTASIANNONHISPANIC COUNTWHITENONHISPANIC COUNTBLACKNONHISPANIC COUNTOTHERETHNICITY COUNTETHNICITYUNKNOWN COUNTRECEIVESPUBLICASSISTANCE COUNTNRECEIVESPUBLICASSISTANC COUNTPUBLICASSISTANCEUNKNOWN) (TotalParticipants Female Male PacificIslander HispanicLatino AmericanIndian Asian White AfricanAmerican OtherEthnicity EthnicityUnknown PublicAssistance NoPublicAssistance PublicAssistanceUnknown)

save Demographics_Clean, replace

/*______________________________________________________________________________
                           FILMING PERMITS DATASET
______________________________________________________________________________*/

clear

import excel "https://docs.google.com/uc?id=0BywXSn44t-HlWnhZVkFzN1pNZ28&export=download", firstrow clear

drop EventID StartDateTime EndDateTime EnteredOn CommunityBoards Country ParkingHeld EventAgency SubCategoryName 

rename ZipCodes ZipCode

gen newzip=substr(ZipCode, 1, 5)

gen newzip2=substr(ZipCode, -5, 5) 

drop ZipCode

rename newzip ZipCode

drop newzip2

encode ZipCode, generate(ZipCode_n)

drop ZipCode

rename ZipCode_n ZipCode

save Filming_Permits_Clean, replace

/*______________________________________________________________________________
                              GARDENS DATASET
______________________________________________________________________________*/

clear

import excel "https://docs.google.com/uc?id=0BywXSn44t-HlRGQ5ZC1aYW9nYzA&export=download", firstrow clear

drop PropID Boro CommunityBoard CouncilDistrict CrossStreets Latitude Longitude CensusTract BIN BBL NTA

rename Postcode ZipCode

encode ZipCode, generate(ZipCode_n)

drop ZipCode

rename ZipCode_n ZipCode

replace ZipCode=0 if ZipCode==.

save Gardens_Clean, replace

/*______________________________________________________________________________
                          FARMERS MARKET DATASET
________________________________________________________________________________*/

clear

import excel "https://docs.google.com/uc?id=0BywXSn44t-HlTUhfR3ZQQ3hyZlE&export=download", firstrow clear

drop AdditionalInformation Latitude Longitude

save Farmers_Markets_Clean, replace

/*------------------------------------------------------------------------------
********************************************************************************
--------------------------------------------------------------------------------
                GETTING MY DATA READY FOR CROSS DATASET ANALYSIS
--------------------------------------------------------------------------------
********************************************************************************
------------------------------------------------------------------------------*/

clear

use "Demographics_Clean"

merge 1:m ZipCode using "Animal_Abuse_Complete" 

drop if Descriptor==.

drop _merge


recode Descriptor (6=6) (1=5) (2=4) (3=2) (4=3) (5=1), gen (Severity) 
/*I recoded so I could analyze the level of abuse (Descriptor) according to the
severity of the issue with 1 being the least severe and 6 the most: Other, 
Neglected, No Shelter, In Car, Chained, Torture).*/


save "Animal_Abuse_COMPLETE", replace


/*------------------------------------------------------------------------------
********************************************************************************
--------------------------------------------------------------------------------
                        ANALIZING MY DATA WITH GRAPHS
--------------------------------------------------------------------------------
********************************************************************************
------------------------------------------------------------------------------*/

hist Location, freq

/*This graph helped me quickly see that the majority of the animal abuse incidents
in the dataset ocurred in private/residential locations. I had previously recoded
all residential locations to be represented by 1 because I believe that abuse in
residential locations would mean that people are doing it in private while abuse
in the street or sidewalks would be done in public*/

hist Severity, freq

/*This graph showed me that Other is the most common incident of animal
abuse in NYC, with Neglected being the second most common. Unfortunately, no data
was found in reference to what "Other" applied to. The third most common incident
was Torture, which was surprising as I did not expect that many people to still
engage in torture of dogs. This lead me to want to look more into the level of
education and socio-economic status associated with these cases but I did not 
have the data on educational level so I will only focus on socio-economic status*/


/*------------------------------------------------------------------------------
********************************************************************************
--------------------------------------------------------------------------------
                          DESCRIPTIVE STATISTICS
--------------------------------------------------------------------------------
********************************************************************************
------------------------------------------------------------------------------*/

clear

/*I became interested in looking at what are of NYC had the largest amount of
animal abuse incidents, so I did a tabulation to quickly see the number.*/

use "Animal_Abuse_COMPLETE"

/*Based on earlier findings of the commonality of each animal abuse incident by
severity, I did a regression between socio-economic status (where I used Public
Assistance as a proxy)*/

tab Severity

tab PublicAssistance

regress Severity PublicAssistance

est sto SPA

/*Since the t value is below p=0.05 and positive, Public Assistance does not have a 
significant impact on the increase of severity of the animal abuse incident*/


/*I went back to my research questions and did a regression between the descriptor
and Public Assistance and Race. I will then crosstabulate race and
socio-economic status to see if there is a correlation*/

tab PacificIslander

tab HispanicLatino

tab AmericanIndian

tab Asian

tab White

tab AfricanAmerican

recode PublicAssistance (1 2 3 = 1), gen (ReceivesPA)

tab ReceivesPA

est sto SR

save "Animal_Abuse_COMPLETE", replace

table Descriptor PublicAssistance

table White Asian HispanicLatino AmericanIndian AfricanAmerican PublicAssistance

table ZipCode ReceivesPA

table ReceivesPA Severity
/*This table actually helped me see that the amount of people receiving public
assistance had less cases of animal abuse than those receiving public
assitance, which completely went against my hypothesis*/

ssc install outreg

/*I decided to try a couple more statistical tests to make sure there was no 
relationship between the variables*/

corr ReceivesPA Descriptor

corr ReceivesPA Severity

corr ZipCode ReceivesPA 

corr White Severity

corr HispanicLatino Severity

/*Since I got the same results with no significance, I decided
to not run any other correlations because I expected the same results as the 
regressions*/

/*------------------------------------------------------------------------------
********************************************************************************
--------------------------------------------------------------------------------
                               USING CENSUS DATA
--------------------------------------------------------------------------------
********************************************************************************
------------------------------------------------------------------------------*/

import excel "https://docs.google.com/uc?id=124icDrRZdWboi-kkbeBlguUeVaR-N7KP&export=download", firstrow clear

edit

keep B F H J R X AM

rename B ZipCode

rename F BelowPovertyLevelSingle

rename H BelowPovertyLevelMarried

rename J BelowPovertyLevelMarriedWSS

rename R BelowPovertyLevelMarriedWSSICASH

rename X BelowPovertyLevelMale

rename AM BelowPovertyLevelFemale

drop in 1/2

tab ZipCode

save "Census_Data", replace

use "Animal_Abuse_COMPLETE", clear

tab ZipCode

use "Census_Data", clear

destring ZipCode, replace

merge 1:m ZipCode using "Animal_Abuse_COMPLETE"

drop if Descriptor==.

destring BelowPovertyLevelSingle, replace

destring BelowPovertyLevelMarried, replace

destring BelowPovertyLevelMarriedWSS, replace

destring BelowPovertyLevelMarriedWSSICASH, replace

destring BelowPovertyLevelMale, replace

destring BelowPovertyLevelFemale, replace

tab BelowPovertyLevelSingle 

tab BelowPovertyLevelMale 

tab BelowPovertyLevelFemale

corr BelowPovertyLevelSingle BelowPovertyLevelMale BelowPovertyLevelFemale

est sto BPLSMF

save "Animal_Abuse_COMPLETE", replace

corr BelowPovertyLevelSingle Descriptor

corr BelowPovertyLevelMale Descriptor

corr BelowPovertyLevelFemale Descriptor

/*I was very surprised to find that these correlations showed that the
BelowPovertyLineLevelFemale variable had the most positive correlation with
the Descriptor variable*/

corr BelowPovertyLevelSingle Severity

corr BelowPovertyLevelMale Severity

corr BelowPovertyLevelFemale Severity

/*The result of these correations showed the same as with the Descriptor
variable: females had the highest correlation*/

table Severity BelowPovertyLevelMale BelowPovertyLevelFemale 
/*This showed that the number of Male and Female per level of severity of the
animal abuse did not vary as much as I expected from the previous stats*/

corr BelowPovertyLevelMarried Descriptor
//I got the error that this variable was ambiguous//

set varabbrev off
//After looking for a solution to the ambiguous abbreviation error, I found//
//this command as a solution and it worked//

corr BelowPovertyLevelMarried Descriptor

corr BelowPovertyLevelMarriedWSS Descriptor

corr BelowPovertyLevelMarriedWSSICASH Descriptor

/*These correlations showed a negative and insignificant correlation between
the Descriptor variable and all the Married variables*/

corr BelowPovertyLevelMarried Severity

corr BelowPovertyLevelMarriedWSS Severity

corr BelowPovertyLevelMarriedWSSICASH Severity

/*The same results were found with the Severity variable*/

table Severity BelowPovertyLevelMarried BelowPovertyLevelSingle

/*This table showed more frequencies per severity of abuse, especially in the 
worst types of abuse, for single people. However, the differences were not that
much so I am surprised that the correlations showed such difference*/

/*I wanted to see if now that I had better data I could run interesting graphs,
so I ran a couple and the results show what I found in the correlations*/

twoway (rarea BelowPovertyLevelSingle BelowPoveryLevelMarried Severity)

twoway (rarea BelowPovertyLevelSingle BelowPoveryLevelMarried Severity) (mband BelowPovertyLevelSingle Severity) (contour BelowPovertyLevelSingle Severity LocationType)
/*I was hoping this graph would allow me to bring the location into the mix
but it was confusing to read*/

/*------------------------------------------------------------------------------
********************************************************************************
--------------------------------------------------------------------------------
                                  CONCLUSIONS
--------------------------------------------------------------------------------
********************************************************************************
--------------------------------------------------------------------------------
The dataset Animal Abuse showed a significant number of animal abuse cases in NYC.
The variables offered in that database did not offer explanations or reasons why
the number of cases was distributed in such way. In attempting to find the possible
reasons for the number of animal abuse cases as well as the severity of the cases,
I tried to look at the correlation of different demographic data points and the
animal abuse cases.
In PS6, I tried to get a better understanding of each demographic group (that is
the reason I ran a tab before every regression) so I could see the individual 
numbers before looking at the statistical analysis. This did not provide any
further clues regarding the issue of animal abuse incidents and severity according
to demographic group.
For the final project, I looked at poverty data from the 2016 Census in NYC.
I ran several correlations between different demographic groups that included
marital status, gender, and socio-economic status with the type of abuse and severity 
of the abuse and found that across the correlations, single females seem to show
the greater amount of cases of animal abuse. In regards to the single people, I
found that single people showed more cases of abuse than did married people.
After running several types of descriptive statistics and looking at a few different
datasets, I still believe that further research in this matter should be conducted.
Though I am able to gather data regarding location, I would like to find out
which groups of people and under which circumstances are more-likely to abuse
animals.*/





