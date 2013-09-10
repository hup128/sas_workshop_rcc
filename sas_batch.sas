/* read the data */
libname rccsas '\\winhpc\winfs\home\hup128\Downloads';
data rccsas.complete;
  infile '\\winhpc\winfs\home\hup128\Downloads\complete.csv'
		  firstobs=2 delimiter=',' lrecl=2056 dsd;
	Input Gender $ Race : $10. HomeTwn : $12. Live : $10. Greek $ Parents $ GPA SkipCl
		  TextSpd SitArea $ HrsStudy FornTeach $ HrsCompu PayEduc : $20. GetEduc $
		  HrsWork : $8. HubFood : $20. Relimport $ ReadBibl : $15. RelPref : $12. God $
		  Weight Height IdlWt IdlHt ViewWt : $12. Handed $ LongFing $ EyeSight : $15.
		  SelfAttr : $12. ShoeSize LooksImp MakeFrnds : $20. DateRace $ InstMsgr
		  PeopKiss : $20. DatePerly $ AgeDiff : $25. FutSpous : $20. HowComm : $20.
		  DateSpnd LongRels UseFaceBk $ AgeMarry CDsOwn Parties CellPhn $ MinTalk
		  FavMusic : $12. EntrPref : $12. CDsBurnd OwnIPod : $12. MP3Playr : $25.
		  MovyGenr : $10. Book_Movy $ SpendTVA : $12. HrsExer SmokeCig $ HrsSleep
Abortion $ ExerPref : $14. WtTry $ FastDrvn SameSex : $20. IceTerm $ CitedOff 
DrvnInfl $  BevPref : $10. DaysAlco SmokedMj $ Ecstasy $ LegalMj $ DrnksUsl $ 
SpndAlco : $14.  DrvnDrnk DrnkIntox DrnkPref $ Shroomed $ LiteBeer : $20. 
Cocaine $ MjBrowny $  MostBeer RolldMj $ Age1stDrk BushJob : $12. AttkIraq $ 
PolAffln : $16. JoepaQuit $ TVSport : $14. HSSports $ Virgin $ SexNoRel $ 
SexB4Mar $ CheatdSO $ CheatTel $  SexPartns DatesB4Sex AgeLostIt 
SexPerWeek : $10. SameSex_1 $ UseProtn : $10. HrsPorn : $10. MinDatesB4 : $20.
OKSameSex $ SpeedDating : $12. SexUnsure $  PreMarSex $;

	weightKG = weight / 2.2;
	heightM  = height * 0.0254;
	bmi = weightKG / (heightM * heightM);


	if (PeopKiss = "n/r") then PeopKiss=' ';

	/*  Recode DatesB4Sex because it has too many categories  */
	length DatesBeforeSex $ 12;
	if ( DatesB4Sex <= 5 ) then DatesBeforeSex = put(DatesB4Sex, 3. );
	if ((DatesB4Sex >  5) & (DatesB4Sex <= 10)) then DatesBeforeSex='5 to 10';
	if ((DatesB4Sex > 10) & (DatesB4Sex <= 20)) then DatesBeforeSex='11 to 20';
	if ((DatesB4Sex > 20) & (DatesB4Sex <= 50)) then DatesBeforeSex='21 to 50';
	if ( DatesB4Sex > 50 ) then DatesBeforeSex='More Than 50';

	/*  Recode Religious Preference  */
	length ReligiousPref $ 12;
	/*  Code Everyone who isn't Catholic or Protestant
	 	  (who did answer the question) to Other  */
	if ( ~missing(RelPref) ) then ReligiousPref = "Other";
	/*  Keep the Catholic & Protestant Groups  */
	if ( RelPref = "Catholic"   ) then ReligiousPref = "Catholic";
	if ( RelPref = "Protestant" ) then ReligiousPref = "Protestant";

	/*  Recode Frequency of Sexual Activity to Yes/No Indicator  */
	if ( ~missing(SexPerWeek)      ) then SexuallyActive = "Yes";
	if ( SexPerWeek = "Not active" ) then SexuallyActive = "No";

	/*  Recode MinDatesB4 to reduce number of Categories  */
	length MinDatesBeforeSex $ 12;
	if ( MinDatesB4 = "First"   ) then MinDatesBeforeSex = "1 to 3";
	if ( MinDatesB4 = "Second"  ) then MinDatesBeforeSex = "1 to 3";
	if ( MinDatesB4 = "Third"   ) then MinDatesBeforeSex = "1 to 3";
	if ( MinDatesB4 = "Fourth"  ) then MinDatesBeforeSex = "4 to 6";
	if ( MinDatesB4 = "Fifth"   ) then MinDatesBeforeSex = "4 to 6";
	if ( MinDatesB4 = "Sixth"   ) then MinDatesBeforeSex = "4 to 6";
	if ( MinDatesB4 = "Seventh" )            then MinDatesBeforeSex = "7 to 9";
	if ( MinDatesB4 = "8 (on eighth date)" ) then MinDatesBeforeSex = "7 to 9";
	if ( MinDatesB4 = "9 (on ninth date)" )  then MinDatesBeforeSex = "7 to 9";
	if ( MinDatesB4 = "Tenth or later" )      then MinDatesBeforeSex = "10 or later";
	if ( MinDatesB4 = "Not sexually active" ) then MinDatesBeforeSex = "Not Active";

	/*  Coded Min Dates Before Sex  */
	if ( MinDatesB4 = "First"   ) then MinDatesB4Code = 1;
	if ( MinDatesB4 = "Second"  ) then MinDatesB4Code = 1;
	if ( MinDatesB4 = "Third"   ) then MinDatesB4Code = 1;
	if ( MinDatesB4 = "Fourth"  ) then MinDatesB4Code = 2;
	if ( MinDatesB4 = "Fifth"   ) then MinDatesB4Code = 2;
	if ( MinDatesB4 = "Sixth"   ) then MinDatesB4Code = 2;
	if ( MinDatesB4 = "Seventh" )            then MinDatesB4Code = 3;
	if ( MinDatesB4 = "8 (on eighth date)" ) then MinDatesB4Code = 3;
	if ( MinDatesB4 = "9 (on ninth date)"  ) then MinDatesB4Code = 3;
	if ( MinDatesB4 = "Tenth or later"      ) then MinDatesB4Code = 4;
	if ( MinDatesB4 = "Not sexually active" ) then MinDatesB4Code = 5;

	/*  Recode AgeLostIt to Exclude Virgins  */
	AgeLostVirginity = AgeLostIt;
	if ( AgeLostIt = 0 ) then AgeLostVirginity=.;
	if ( AgeLostIt = 3 ) then AgeLostVirginity=.;
	if ( AgeLostIt = 6 ) then AgeLostVirginity=.;
	if ( AgeLostIt = 8 ) then AgeLostVirginity=.;

	/*  Recode Use Protection to Exclude Non-Active Individuals  */
	useProtection = useProtn;
	if ( useProtn = "Not active" ) then useProtection=' ';

	/*  Recode Number of Sexual Partners Variable  */
	nSexualPartners = SexPartns;
	if ( nSexualPartners = 1027 ) then nSexualPartners =.;

	/*  Recode Live to get Frat or Not Frat  */
	if ( ~missing(live) ) then liveAtFrat = "No ";
	if ( live = "Frat"  ) then liveAtFrat = "Yes";

run;
/* produce html report using ods*/
ods html file = '\\winhpc\winfs\home\hup128\Downloads\partone_complete.html';
proc print data = rccsas.complete (obs=20);
run;
ods html close; /* close the ods */
ods listing;
run;

proc UNIVARIATE data= rccsas.complete; /* check the data set*/
run;
