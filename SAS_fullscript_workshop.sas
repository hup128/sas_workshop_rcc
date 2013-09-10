/* read the data */
libname rccsas '/gpfs/home/hup128/work/packs/SAS/sas_test';
data rccsas.complete;
  infile '/gpfs/home/hup128/work/packs/SAS/sas_test/Complete.csv'
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
ods html file = '/gpfs/home/hup128/work/packs/SAS/sas_test/partone_complete.html';
proc print data = rccsas.complete (obs=20);
run;
ods html close; /* close the ods */
ods listing;
run;

proc contents data= rccsas.complete; /* check the data set*/
run;

/*p_2_i*/
proc gchart data= rccsas.complete;
pie hometwn /  value= inside;
title 'Students Hometown';
run;


/*p_2_ii*/
proc gchart data= rccsas.complete;
hbar race / type = pct  inside=mean;
title 'Students Race';
run;

/*p_2_iii*/
proc gchart data= rccsas.complete;
vbar gender /  outside=pct ;
title 'Students Gender';
run;

/*p_2_iv*/
proc gchart data= rccsas.complete;
vbar gender / Group= greek   outside=pct ;
title 'Students Gender for each Greek';
run;

/*p_3_i*/
proc freq data = rccsas.complete;
tables longfing*gender /chisq nocol norow;
run;
/*p_3_ii*/
data rccsas.complete_p3(keep=shoesize longfing gender);
set rccsas.complete;
where longfing <> 'same';
run;
ods html file='/gpfs/home/hup128/work/packs/SAS/sas_test/print_prob3.htm';
proc print data=rccsas.complete_p3 (obs=20);
run;
ods html close;


/*p_3_iii*/
/* paired t-test (two-sided) */
data rccsas.complete_p4;
set rccsas.complete_p3;
length shoesizering 8;
length shoesizeindex 8;
if  (longfing = 'ring')  then shoesizering = shoesize ;
if (longfing = 'index') then shoesizeindex = shoesize ;
run;



/*p_4_i*/
/*Note: check for the number of non missing values*/
ods html file='/gpfs/home/hup128/work/packs/SAS/sas_test/print_4_means.htm';
proc means data=rccsas.complete n  mean std median min max ; /*mean, std, median, min & max */
var GPA HrsStudy;
run;
ods html close;




/*4_ii: Plot a scatter plot of GPA vs HsrStudy.
Use the symboln statement as above.*/
proc format;
	value Genderfmt 0='male' 1='female';
run;
proc gplot data=rccsas.complete;
	plot GPA*HrsStudy=Gender;
	symbol1 value=plus i=r width=3 ci=green cv=black; /*for female*/
	symbol2 value=diamond i=r width=3 ci=red cv=blue; /*for male*/
	title 'scatter plot of GPA by Hours of Study for male and female'; 	/*the type of the point is dot*/;
	format Gender Genderfmt.;
run;


/*p_4_iii*/
data rccsas.complete_p5 (keep=GPA HrsStudy Gender Shr);
set rccsas.complete;
if HrsStudy > 10 then shr='>10hrs';
if HrsStudy <= 10 then shr='<=10hrs';
run;
	
proc print data= rccsas.complete_p5 (obs=20);
run; 


/*problem iv:*/
PROC FREQ DATA = rccsas.complete_p5 ;
TABLES Gender*shr/chisq;
RUN;

/*problem v:*/	
PROC UNIVARIATE DATA = rccsas.complete_p5 NOPRINT ;
class shr;
histogram GPA / normal;
title "Descriptive Statistics";
RUN;


proc sort data =rccsas.complete_p5;
by shr; 
run;
/*Boxplot for a subsets of data*/
proc boxplot data=rccsas.complete_p5;
plot GPA*shr/
boxstyle =schematic boxwidth=10;
run;


/*4_vi */
/* two-sample(independent) t-test (two-sided) */
proc ttest data=rccsas.complete_p5;
	class shr;
	var GPA;
	title 'two sample t-test for GPA';
run;

/*4_vii*/
proc npar1way data=rccsas.complete wilcoxon ;
class shr;
var GPA;
title 'wilcoxon rank-sum test';
exact;
run;



/*Part II*/

/* exercise five: weekly US regular Gas price from 1990 to 2011 in csv format */
data usagas;
infile '/gpfs/home/hup128/work/packs/SAS/sas_test/gas.csv' delimiter
=',' firstobs=2; /* read the data into SAS */
input Price Time; /* Price (weekly price) and Time. */
run;
/*sort the data by time before plotting.) */
proc sort data= usagas;
by Time;
run;
/* plot the trend of the daily open price of IBM for last year. */
proc gplot data=usagas;
plot Price*Time;
title 'Trend of the weekly open price of Gas in the US for years 1990 to 2011';
 
/* In details, specify that the type of point is none, the type of
interpolation is needle
(connect points by straight lines) ,
the color of lines is blue. */
symbol value = none i=needle cv=red ci = blue width =3;
run;


/*part 6*/

data gas2;
  set usagas;
  year=1990+36/52+Time/52;  /* decode week back to year */
  price_range=int(Price/.50); /* (1) */
run;
proc print data=gas2;
run;

goption reset=symbol;  
symbol1 value=none interpol=needle color=cxFFFFCC; 
symbol2 value=none interpol=needle color=cxFFEDA0; 
symbol3 value=none interpol=needle color=cxFED976; 
symbol4 value=none interpol=needle color=cxFEB24C; 
symbol5 value=none interpol=needle color=cxFD8D3C; 
symbol6 value=none interpol=needle color=cxFC4E2A; 
symbol7 value=none interpol=needle color=cxE31A1C; 
symbol8 value=none interpol=needle color=cxBD0026; 
symbol9 value=none interpol=needle color=cx800026; 
axis1 c=blue label=('Price($/gal)') order=(0 to 4.5 by .5) offset=(0,0); /* (2) */
axis2 c=blue label=('Year')  value=(angle=90) order=(1991 to 2012 by 1) offset=(0,0);


proc gplot data=gas2;
  plot Price*Year=price_range /  
  autovref                  /*     (3)     */
  nolegend                  /*     (4)     */
  vaxis=axis1  haxis=axis2; /*     (5)     */
  title 'US Regular Gasoline Price (avg weekly price per gallon)';
run;
