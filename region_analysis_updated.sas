*/Loading the data and calling it 'shoes'*///;
data shoes; 
	set SASHELP.SHOES;
run;
*///Removing any duplicates//;
proc sort data=shoes nodupkey out=shoes1;
	by Region Product Subsidiary Stores Sales Inventory Returns; 
run; 
*//Keeping only the following columns: Regions, Sales and Stores//;
data shoes2; 
	set shoes1(keep= Region Sales Stores);
run; 
*//Creating a table on sales and the number of stores for each region. Sorting the result by descending order of sales in a particular region//;
proc means data=shoes2 sum noprint;
  class Region;
  var Stores Sales;
  output out=region_summary(drop=_type_ _freq_) sum=SumStores SumSales;
  proc sort data=region_summary;
  by descending SumStores;
run;


*//Adding visuals to make sense of the cleaned data////;






*// Creating bar chart of sales by region;
proc sgplot data=region_summary;
   vbar Region / response=SumSales stat=sum datalabel;
   title 'Total Sales by Region';
run;
*//Creating bar chart of each store by region;
proc sgplot data=region_summary;
   vbar Region / response=SumStores stat=sum datalabel;
   title 'Total Stores by Region';
run;
*//Creating  Pie Chart Sales Distribution by Region;
proc gchart data=region_summary;
   pie Region / sumvar=SumSales value=inside percent=outside;
   title 'Sales Distribution by Region';
run;
*Showing the average sales per store by region;
data region_summary;
   set region_summary;
   SalesPerStore = SumSales / SumStores;
run;

proc sgplot data=region_summary;
   vbar Region / response=SalesPerStore datalabel;
   title 'Average Sales per Store by Region';
run;



*Applying statistical analysis;


*/ Showing if there's a correlation between the number of stores and the number of sales (does more stores impact the number of sales);

proc corr data=region_summary;
   var SumSales SumStores;
run;
*//Visualizing this relationship;

data region_log;
   set region_summary;
   logSales = log(SumSales);   /* Log transformation for SumSales */
   logStores = log(SumStores); /* Log transformation for SumStores */
run;

proc sgplot data=region_log;
   scatter x=logStores y=logSales / markerattrs=(symbol=circlefilled color=blue) datalabel=Region;
   reg x=logStores y=logSales / lineattrs=(color=red pattern=solid thickness=2);
   title 'Log-Scale: Sales vs. Stores by Region with Regression Line';
run;
