--Caroline aboleil , 26/6/23
--This dataset reflects incidents of crime in the City of Los Angeles dating back to 2020
/*the data was obtained from  Data.gov which is a website launched by the United States government
to provide easy access to a wide range of datasets and information collected by various federal agencies
here's a link :(https://catalog.data.gov/dataset/crime-data-from-2020-to-present )*/
use master
create database crime
use crime

select * from CrimeData
-------------------------------------------------------------------------------------------------------
--Displaying the percentage of cases for each status:
DECLARE @total INT
SELECT @total = COUNT(*) FROM crimedata
SELECT 
    CASE 
        WHEN status = 'CC' THEN 'Closed Case'
        WHEN status = 'IC' THEN 'In Custody'
        WHEN status = 'AO' THEN 'Arrested, Outstanding'
        WHEN status = 'JO' THEN 'Juvenile Offender'
        WHEN status = 'JA' THEN 'Juvenile Arrest'
        WHEN status = 'AA' THEN 'Active Case'
        ELSE status
    END AS status,
    concat(COUNT(*) * 100.0 / @total , '%')  AS Percentage
FROM crimedata
GROUP BY status
ORDER BY 2 DESC
----------------------------------------------------------------------------------------------------
-- the top 10 areas with the highest crime rate:
select Top 10 c.area_name as Area , count(c.DR_NO) as CrimeCount
from crimedata as c
group by c.area_name
order by CrimeCount DESC
--------------------------------------------------------------------------------------------------------
--displaying the number of crimes committed each year, highest to lowes:
select year(c.date_occ) as year , count(c.DR_NO) as CrimeCount
from crimedata as c
group by year(c.date_occ)
order by CrimeCount DESC
------------------------------------------------------------------------------------------------------
--the time it took to report each crime(measered in days), orderd from highest to lowest:
select c.DR_NO as FileID , c.Date_OCC as CrimeDate, c.Date_Rptd as ReportDate , 
DATEDIFF(dd,Date_OCC,Date_Rptd) as DaysDiff from crimedata as c
order by DaysDiff desc
-----------------------------------------------------------------------------------------------------
--Crime Types and Frequencies:
select top 10 crm_cd_desc as Crime ,count(dr_no) as Count
from crimedata
group by  crm_cd_desc
order by 2 desc
--------------------------------------------------------
-- the top 3 crimes each year:
SELECT Year , Crime , Count
FROM (
  SELECT crm_cd_desc AS Crime, YEAR(date_occ) AS Year, COUNT(dr_no) AS Count,
         ROW_NUMBER() OVER (PARTITION BY YEAR(date_occ) ORDER BY COUNT(dr_no) DESC) AS Rank
  FROM crimedata
  GROUP BY crm_cd_desc, YEAR(date_occ)
) ranked
WHERE Rank <= 3
ORDER BY Year, Count DESC
-------------------------------------------------------------------------------------------------
-- the top 10 most common weapons:
select top 10 weapon_desc as Weapon, COUNT(dr_no) as CrimeCount
from crimedata
where weapon_desc is not null
group by weapon_desc
order by 2 desc
----------------------------------------------------------------------------------------------
--count of crimes per day of the week, sorted from highest to lowest:
select DATENAME(WEEKDAY, date_occ) AS DayOfWeek , count(c.DR_NO) as CrimeCount
from crimedata as c
group by DATENAME(WEEKDAY, date_occ)
order by CrimeCount DESC
--------------------------------------------------------------------------------------------
