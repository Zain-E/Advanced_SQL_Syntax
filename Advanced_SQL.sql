/****** Script for SelectTopNRows command from SSMS  ******/


with CTE_TEST as

(

SELECT count(*) over() as 'Count of rows',

ROW_NUMBER() OVER (PARTITION BY Provider ORDER BY Provider ASC) AS Provider_Rank,
DENSE_RANK() OVER ( ORDER BY Reporting_Month DESC) AS Month_Rank,
*

FROM [NHS ENGLAND].[dbo].[Recosted_2021_v2]

) select  Provider, sum([2020/21 TOTAL COST FINAL]) as 'Total Cost' from CTE_TEST

  group by Provider

  having SUM([2020/21 TOTAL COST FINAL]) > 30000000


------------------------------------------NEW QUERY--------------------------------------------
  
with CTE_TEST as

(

SELECT count(*) over() as 'Count of rows',

ROW_NUMBER() OVER (PARTITION BY Provider ORDER BY Provider ASC) AS Provider_Rank,
DENSE_RANK() OVER ( ORDER BY Reporting_Month DESC) AS Month_Rank,
*

FROM [NHS ENGLAND].[dbo].[Recosted_2021_v2]

) select [Actual Cost], lag([Actual Cost],1) over(order by Reporting_Month) as 'Actual cost +1' from CTE_TEST

------------------------------------------NEW QUERY--------------------------------------------
  

with CTE_TEST_2 as

(

SELECT FORMAT(count(*) over(), 'n','en-UK') as 'Count of rows',

ROW_NUMBER() OVER (PARTITION BY Provider ORDER BY Provider ASC) AS Provider_ID,
DENSE_RANK() OVER ( ORDER BY Reporting_Month DESC) AS Month_Rank,
DENSE_RANK() OVER ( ORDER BY Provider DESC) AS Provider_Rank,
*

FROM [NHS ENGLAND].[dbo].[Recosted_2021_v2]

) select  * from CTE_TEST_2 where Provider =

(select Provider from Recosted_2021_v2 where [2020/21 TOTAL COST FINAL] = '3873.293124000')


------------------------------------- 10TH HIGHEST COST -----------------------------------------------------------------------
SELECT TOP 1 COST

FROM 

(

SELECT TOP 10
      format([2020/21 TOTAL COST FINAL],'###,###.##') as 'COST'
  FROM [NHS ENGLAND].[dbo].[Recosted_2021_v2]

  order by [2020/21 TOTAL COST FINAL] DESC

) as Recost


select top 2 [2020/21 TOTAL COST FINAL]

from [NHS ENGLAND].[dbo].[Recosted_2021_v2]

order by [2020/21 TOTAL COST FINAL] DESC

------------------------------------- SECOND HIGHEST COST -----------------------------------------------------------------------

select max([2020/21 TOTAL COST FINAL])

from [NHS ENGLAND].[dbo].[Recosted_2021_v2]

where [2020/21 TOTAL COST FINAL] <> (select max([2020/21 TOTAL COST FINAL]) from [NHS ENGLAND].[dbo].[Recosted_2021_v2])


---------------------------------- SUM BASED ON CONDITIONS -----------------------------------------------------------------------

select top (1000)
 
 [Provider],
 sum((case when [2020/21 TOTAL COST FINAL]>0 then [2020/21 TOTAL COST FINAL] else 0 end)) as 'Positive SUM',
 sum((case when [2020/21 TOTAL COST FINAL] <0 then [2020/21 TOTAL COST FINAL] else 0 end)) as 'Negative SUM'
 from [NHS ENGLAND].[dbo].[Recosted_2021_v2]

group by Provider

------------------------------- NO OF ROWS GROUPED --------------------------------------------------------------------------------

select Provider, count(*) as 'no of rows' from [NHS ENGLAND].[dbo].[Recosted_2021_v2] group by Provider order by count(*) DESC

------------------------------CONCAT FIELDS---------------------------------------------------------------------------------------

SELECT DISTINCT Provider + ', ' AS 'data()' 
FROM [NHS ENGLAND].[dbo].[Recosted_2021_v2]
FOR XML PATH('')

-------------------------------------- FASTER WAY OF DOING OR OPERATOR--------------------------------------------------------------
SELECT TOP 10 Provider
  FROM [NHS ENGLAND].[dbo].[Recosted_2021_v2]

  where Provider_Code = 'RYJ'

  UNION ALL

  SELECT TOP 10 Provider
  FROM [NHS ENGLAND].[dbo].[Recosted_2021_v2]

  where Provider_Code = 'RT3'

    UNION ALL

  SELECT TOP 10 Provider
  FROM [NHS ENGLAND].[dbo].[Recosted_2021_v2]

  where Provider_Code = 'RQM'

  -------------------------------------- WINDOWED FUNCTIONS ----------------------------------------------------------------------------

  with cte as 

  (

  select (([2020/21 TOTAL COST FINAL]/sum([2020/21 TOTAL COST FINAL]) over())*100) as '% cost per row', * from [NHS ENGLAND].[dbo].[Recosted_2021_v2]

  ) select 
  
  
  format(sum([% cost per row]) over(),'##.##') as 'check',
  DENSE_RANK() OVER ( ORDER BY Provider DESC) AS Provider_Rank,
  *  
  
  from cte

  order by [% cost per row] DESC

  ----------------------------------------- CHEAT SHEET STUFF ------------------------------------------------------------------------------

  with CTE as 

  (

  select Reporting_Month,
         format(sum([2020/21 TOTAL COST FINAL]),'##,##') as 'Cost', 
		 Provider,
		 DENSE_RANK() OVER(ORDER BY Provider) as 'Dense Rank',
		 ROW_NUMBER() OVER(PARTITION BY Provider ORDER BY Provider) as 'Row Number'

		 from Recosted_2021_v2
         group by Reporting_Month, Provider

  )

  Select *, 
         FIRST_VALUE(Cost) OVER(PARTITION BY Provider ORDER BY Reporting_Month) as 'first value',
		 LAST_VALUE(Cost) OVER(PARTITION BY Provider ORDER BY Provider) as 'last value',
		 PERCENT_RANK() OVER(ORDER BY Cost) as 'Percent Rank',
		 MAX(Cost) OVER(PARTITION BY Provider ORDER BY PRovider) as 'Max',
		 MIN(Cost) OVER(PARTITION BY Provider ORDER BY PRovider) as 'Min',
		 lead([Row Number],1) OVER(PARTITION BY Provider ORDER BY Provider) as 'Lead + 1',
		 lag([Row Number],1) OVER(PARTITION BY Provider ORDER BY Provider) as 'Lag - 1'
  from CTE
  order by Provider, Reporting_Month


  ----------------------------------------- POSTGRESQL ------------------------------------------------------------------------------
	
with CTE as (
SELECT *,cast("Timestamp" as date) as Timestamp_date

FROM public."Paediatric_Surgery"
	
order by "Timestamp"
)
SELECT *, 
       DENSE_RANK() OVER ( ORDER BY Timestamp_date DESC) AS Month_Rank,
	    CASE WHEN Timestamp_date >= (max(Timestamp_date) - INTERVAL '14 days') THEN 'BI WEEKLY'
	         WHEN Timestamp_date >= (max(Timestamp_date) - INTERVAL '7 days')  THEN 'WEEKLY'
	   END AS Download_Filter
	   
FROM CTE;

