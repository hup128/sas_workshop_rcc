http://support.sas.com/documentation/cdl/en/lrcon/65287/HTML/default/viewer.htm#p13nid2jwm0dq7n105fqdwy3mpwb.htm

or SAS 9, certain procedures such as SORT and MEANS have been modified so that they can thread the processing through multiple CPUs, if they are available. In addition, threaded processing is being integrated into a variety of other SAS features in order to improve performance. For example, when you create an index, if sorting is required, SAS attempts to sort the data using the thread-enabled sort.

Consult:
http://support.sas.com
Support for Parallel Processing


Running R from SAS

As a SAS user, the easiest way to run R is through SAS/IML Studio. The command ExportDatasetToR sends your data set to R. Then to execute R code, you bracket it between a \u201csubmit /R;\u201d and an \u201cendsubmit;\u201d statement. The following is an example. The R code is indented only to differentiate the R code from the surrounding SAS code:

run ExportDatasetToR(\u201cmyLib.mydata\u201d);
submit/r;
attach(mydata)   # the first R statement
install.packages(\u201cRcmdr\u201d)  # do this one time
library(\u201cRcmdr\u201d)  # do this every time
rcorr.adjust( data.frame(q1,q2,q3,q4)) # the last R statement
endsubmit;

For details regarding transferring data or results back and forth between SAS and R, see the SAS/IML Studio 3.4 for SAS/STAT Users
consult http://support.sas.com/documentation/onlinedoc/imlstudio/index.html for
more information.

Another way to run R programs from within SAS is to use Philip Rack\u2019s A Bridge to R, available from MineQuest, LLC (http://www.minequest.com/). That program adds the ability to run R programs from either Base SAS, or the compatible World Programming System software.  It sends your data from SAS or WPS to R using a SAS transport format data set, which only allows for 8-charater variable names. To use it, simply place your R programming statements where our indented example is below and submit your program as usual.

%Rstart(dataformat=XPT,data=mydata,rGraphicsViewer=NOGRAPHWINDOW);datalines4;
attach(mydata)   # the first R statement
install.packages(\u201cRcmdr\u201d)  # do this one time
library(\u201cRcmdr\u201d)  # do this every time
rcorr.adjust( data.frame(q1,q2,q3,q4)) # the last R statement

;;;;

%Rstop(import=);

Finally, if you don\u2019t have either SAS/IML Studio or A Bridge to R, the easiest way to get your data to R is through a transport data set. Save only the variables you need to send to R in their own data set, and eliminate observations with missing values to avoid learning that topic in R. Then write a transport format data set. Here is an example:

LIBNAME myLib \u2018C:\myRfolder\u2019;
LIBNAME To_R xport \u2018\myRfolder\mydata.xpt\u2019;
DATA To_R.mydata;
SET  myLib.mydata;
KEEP Q1-Q4;
*Keep those with no missing values;
IF N(OF q1-q4)=4;
RUN;

Then in R, you can read the transport SAS data set. This requires the foreign package, which is built into R, and the Hmisc package, which you must install the first time you use it with the install.packages function:

setwd(\u201c/myRfolder\u201d)
library(\u201cforeign\u201d)
attach(mydata)
install.packages(\u201cRcmdr\u201d)  # do this one time
library(\u201cRcmdr\u201d)  # do this every time
rcorr.adjust( data.frame(q1,q2,q3,q4)) # the last R statement

The X command in SAS can execute any operating system command. You can use it to automatically run R programs that pass data and results back and forth between SAS and R. See (4) for details.


ref.
http://r4stats.com/articles/calling-r/


