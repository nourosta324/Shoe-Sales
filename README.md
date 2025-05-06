# Sales and Stores Data Analysis

## Project Overview

This project involves analyzing a dataset from SASHELP.SHOES to explore the relationship between sales and the number of stores across different regions. The analysis includes data cleaning, descriptive statistics, and data visualization, as well as statistical analysis to examine the correlation between sales and store counts.

## Steps Taken

 Loading the Data
The dataset used for this project is `SASHELP.SHOES`. The data is loaded and named as `shoes`.

```sas
/* Loading the data and calling it 'shoes' */
data shoes; 
	set SASHELP.SHOES;
run;


Next, duplicates are removed based on the following columns: Region, Product, Subsidiary, Stores, Sales, Inventory, and Returns.

/* Removing any duplicates */
proc sort data=shoes nodupkey out=shoes1;
	by Region Product Subsidiary Stores Sales Inventory Returns; 
run;

I kept only the Region, Sales, and Stores columns to focus on these variables for further analysis.

/* Keeping only the following columns: Region, Sales, and Stores */
data shoes2; 
	set shoes1(keep= Region Sales Stores);
run;


A table is created to summarize total sales and total stores for each region, sorted by descending total stores.
/* Creating a table on sales and the number of stores for each region */
proc means data=shoes2 sum noprint;
  class Region;
  var Stores Sales;
  output out=region_summary(drop=_type_ _freq_) sum=SumStores SumSales;
  proc sort data=region_summary;
  by descending SumStores;
run;

** Creating the Visuals ** 


1. Total Sales by Region

A bar chart is created to show total sales by region.
/* Creating a bar chart of sales by region */
proc sgplot data=region_summary;
   vbar Region / response=SumSales stat=sum datalabel;
   title 'Total Sales by Region';
run;

2. Total Stores by Region

Another bar chart shows the total number of stores by region.
/* Creating a bar chart of stores by region */
proc sgplot data=region_summary;
   vbar Region / response=SumStores stat=sum datalabel;
   title 'Total Stores by Region';
run;

3. Sales Distribution by Region

A pie chart visualizes the distribution of sales across regions.
/* Creating a Pie Chart of Sales Distribution by Region */
proc gchart data=region_summary;
   pie Region / sumvar=SumSales value=inside percent=outside;
   title 'Sales Distribution by Region';
run;

4. Average Sales per Store by Region

This bar chart shows the average sales per store by region.
/* Showing the average sales per store by region */
data region_summary;
   set region_summary;
   SalesPerStore = SumSales / SumStores;
run;

proc sgplot data=region_summary;
   vbar Region / response=SalesPerStore datalabel;
   title 'Average Sales per Store by Region';
run;

Statistical Analysis

5. Correlation between Sales and Stores

The CORR procedure is used to test if there is a correlation between the number of stores and total sales.
/* Showing if there's a correlation between the number of stores and sales */
proc corr data=region_summary;
   var SumSales SumStores;
run;
6. Visualization of the Relationship

A scatter plot with a regression line is created to visualize the relationship between the log-transformed sales and stores.
/* Visualizing the relationship with log-transformation */
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


# **Conclusion**

This project demonstrates the process of cleaning, analyzing, and visualizing sales data from a shoes dataset using SAS. The key steps included:

- **Loading and cleaning the data** by removing duplicates and selecting relevant columns.
- **Creating summary tables** to understand sales and store distribution by region.
- **Visualizing total sales and stores by region** through bar charts and a pie chart.
- **Exploring the relationship** between the number of stores and total sales using the CORR procedure.
- **Visualizing the relationship** between stores and sales using a log-transformed scatter plot with a regression line.

### **Key Insight:**
The results of the analysis show a **positive correlation** between the number of stores and the total sales in each region. This implies that more stores tend to lead to higher sales, which can guide regional sales strategies.
