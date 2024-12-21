Use project;
select *  from projects limit  200 ;
select count(*) from Projects ;
#------------- Epoch to human (date) -----------------# 
select projectID, state, name, country, creator_id,location_id,  
date(from_unixtime(created_at) )as Created_at_con,
date( from_unixtime(deadline)) as deadline_con,
date (from_unixtime(updated_at)) as Updated_at_con,
date (from_unixtime(state_changed_at) )as state_changed_at_Con,
date (from_unixtime(successful_at) )as sucessful_at_con,
date (from_unixtime(launched_at)) as launched_at_con,
goal, pledged, currency
from projects;
#---------------------------Epoch to Human Time and Date
 select projectID, state, name, country, creator_id,location_id,  
from_unixtime(created_at) as Created_at_con,
from_unixtime(deadline) as deadline_con,
from_unixtime(updated_at) as Updated_at_con,
from_unixtime(state_changed_at) as state_changed_at_Con,
from_unixtime(successful_at) as sucessful_at_con,
from_unixtime(launched_at) as launched_at_con,
goal, pledged, currency
from projects;
#------------------------- calander 
SELECT 
    YEAR(created_at_con) AS Year,
    MONTH(created_at_con) AS MonthNo,
    MONTHNAME(created_at_con) AS MonthFullName,
    CASE 
        WHEN MONTH(created_at_con) IN (1, 2, 3) THEN 'Q1'
        WHEN MONTH(created_at_con) IN (4, 5, 6) THEN 'Q2'
        WHEN MONTH(created_at_con) IN (7, 8, 9) THEN 'Q3'
        WHEN MONTH(created_at_con) IN (10, 11, 12) THEN 'Q4'
    END AS Quarter,
    DATE_FORMAT(created_at_con, '%Y-%b') AS YearMonth,
    DAYOFWEEK(created_at_con) AS WeekdayNo,
    DAYNAME(created_at_con) AS WeekdayName,
    CASE 
        WHEN MONTH(created_at_con) = 4 THEN 'FM1'
        WHEN MONTH(created_at_con) = 5 THEN 'FM2'
        WHEN MONTH(created_at_con) = 6 THEN 'FM3'
        WHEN MONTH(created_at_con) = 7 THEN 'FM4'
        WHEN MONTH(created_at_con) = 8 THEN 'FM5'
        WHEN MONTH(created_at_con) = 9 THEN 'FM6'
        WHEN MONTH(created_at_con) = 10 THEN 'FM7'
        WHEN MONTH(created_at_con) = 11 THEN 'FM8'
        WHEN MONTH(created_at_con) = 12 THEN 'FM9'
        WHEN MONTH(created_at_con) = 1 THEN 'FM10'
        WHEN MONTH(created_at_con) = 2 THEN 'FM11'
        WHEN MONTH(created_at_con) = 3 THEN 'FM12'
    END AS FinancialMonth,
    CASE 
        WHEN MONTH(created_at_con) IN (4, 5, 6) THEN 'FQ1'
        WHEN MONTH(created_at_con) IN (7, 8, 9) THEN 'FQ2'
        WHEN MONTH(created_at_con) IN (10, 11, 12) THEN 'FQ3'
        WHEN MONTH(created_at_con) IN (1, 2, 3) THEN 'FQ4'
    END AS FinancialQuarter
FROM p1;

#----------------------------------- Q 4
select projectID, goal , static_usd_rate,
goal * static_usd_rate as Goal_USD   from projects order by static_usd_rate desc;

#--------------------------Q 7 ------------
select projectID, state, name , country , backers_count from projects order by backers_count desc limit 10;
select projectID, state, name , country , pledged from projects order by pledged desc limit 10;


#----------------------------------- Q 6 
Select  sum(pledged) as Total_amt_raised , sum(backers_count) as total_Backers   from projects where state= 'successful';
    
    SELECT 
    AVG(DATEDIFF(FROM_UNIXTIME(successful_at), FROM_UNIXTIME(created_at))) AS AvgNumberOfDays
FROM 
    projects
WHERE 
    state = 'successful';
#-----------------------------Percentage of Successful Projects  by Category

 SELECT 
    
    projects.category_ID,
    crowdfunding_category_sql.name,
    (COUNT(CASE WHEN projects.state = 'successful' THEN 1 END) * 100.0 / COUNT(*)) AS SuccessRate
FROM
    projects 
JOIN 
     crowdfunding_category_sql ON projects.category_ID = crowdfunding_category_sql.ID
GROUP BY 
   projects.category_ID,  crowdfunding_category_sql.Name
    order by projects.category_ID;
    
    #-----------------------------Percentage of Successful Projects by Year..
     SELECT 
    YEAR(FROM_UNIXTIME(created_at)) AS Year,
    (COUNT(CASE WHEN state = 'successful' THEN 1 END) * 100.0 / COUNT(*)) AS SuccessRate
FROM 
    projects
GROUP BY 
    Year;
     #-----------------------------Percentage of Successful Projects by Month etc..
    SELECT 
    DATE_FORMAT(FROM_UNIXTIME(created_at), '%Y-%m') AS YearMonth,
    (COUNT(CASE WHEN state = 'successful' THEN 1 END) * 100.0 / COUNT(*)) AS SuccessRate
FROM 
    projects
GROUP BY 
    YearMonth
    order by yearmonth;
    
    #--------------------------------- Percentage of Successful projects by Goal Range 
     SELECT 
    CASE 
        WHEN goal < 1000 THEN 'Less than 1,000'
        WHEN goal BETWEEN 1000 AND 10000 THEN '1,000 - 10000'
        WHEN goal BETWEEN 10001 AND 20000 THEN '10,0001 - 20,000'
        WHEN goal BETWEEN 20001 AND 100000 THEN '20,0001 - 100,000'
        WHEN goal BETWEEN 100001 AND 1000000 THEN '100,0001 - 1000,000'
        ELSE 'Above 1000,000'
    END AS GoalRange,
    (COUNT(CASE WHEN state = 'successful' THEN 1 END) * 100.0 / COUNT(*)) AS SuccessRate
FROM 
    projects
GROUP BY 
    GoalRange;
    
    #-------------------------Project Overview KPI 
    #--------------------------Total Number of Projects based on outcome
    SELECT 
    state AS Outcome,
    COUNT(*) AS TotalProjects
FROM 
    projects
GROUP BY 
    state;
    
#------------------------Total Number of Projects based on Locations
create table location 
    SELECT 
    location_id,
    COUNT(*) AS TotalProjects
FROM 
    projects
GROUP BY 
    location_id;
    
    SELECT 
    crowdfunding_location_sql.name AS location_name,
    location.TotalProjects
FROM 
    location
JOIN 
    crowdfunding_location_sql ON location.location_ID = crowdfunding_location_sql.ID;
    
    SELECT 
    country,
    COUNT(*) AS TotalProjects
FROM 
    projects
GROUP BY 
    country;
    
#---------------------Total Number of Projects based on  Category
SELECT 
    crowdfunding_category_sql.Name,
    COUNT(*) AS TotalProjects
FROM 
    projects 
JOIN 
    crowdfunding_category_sql ON projects.category_ID = crowdfunding_category_sql.ID
GROUP BY 
    crowdfunding_category_sql.Name;
    
    #-----------------------------------Total Number of Projects created by Year , Quarter , Month
    #-----------------------------------Total Number of Projects created by Year 
    SELECT 
    YEAR(FROM_UNIXTIME(created_at)) AS Year,
    COUNT(*) AS TotalProjects
FROM 
    projects
GROUP BY 
    Year;
    #-----------------------------------Total Number of Projects created by Quarter
    SELECT 
    QUARTER(FROM_UNIXTIME(created_at)) AS Quarter,
    COUNT(*) AS TotalProjects
FROM 
    projects
GROUP BY 
    Quarter;
    
       SELECT 
    YEAR(FROM_UNIXTIME(created_at)) AS Year,
    QUARTER(FROM_UNIXTIME(created_at)) AS Quarter,
    COUNT(*) AS TotalProjects
FROM 
    projects
GROUP BY 
    Year, Quarter
ORDER BY 
    Year, Quarter;
    #-----------------------------------Total Number of Projects created by  Month
    SELECT 
    DATE_FORMAT(FROM_UNIXTIME(created_at), '%Y-%m') AS YearMonth,
    COUNT(*) AS TotalProjects
FROM 
    projects
GROUP BY 
    YearMonth;
    
#--------------------------
    
