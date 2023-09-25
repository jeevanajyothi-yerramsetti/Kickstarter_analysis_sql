create database Crowdfunding;
use Crowdfunding; 

#Total Number of Projects based on outcome
SELECT state, COUNT(ProjectID) AS total_projects
FROM projects
GROUP BY state;

#Total Number of Projects based on Locations
SELECT l.name, COUNT(p.ProjectID) AS total_projects
FROM crowdfunding_location as l
LEFT JOIN projects as p ON l.id = p.location_id
GROUP BY l.name
order by total_projects desc
limit 5;

#Total Number of Projects based on  Category
SELECT c.name, COUNT(p.ProjectID) AS total_projects
FROM crowdfunding_category as c
LEFT JOIN projects as p ON c.id = p.category_id
GROUP BY c.name
order by total_projects desc
limit 5;

#Total Number of Projects created by Year , Quarter , Month
select count(p.ProjectID) AS total_projects, b.year, b.`Quarter`, b.`Month fullname` from projects p
LEFT JOIN `calender table` as b on p.created_at= b.created_at
group by Year, Quarter, `Month fullname`
order by Year asc;

#Amount Raised for successful projects
select sum(goal*static_usd_rate) as goal_usd from projects
where state ="Successful";

#Number of backers for successful projects
select count(backers_count) no_of_backers from projects 
where state = "successful";

#Top Successful Projects Based on Amount Raised
select `name`, sum(goal*static_usd_rate) as goal_usd from projects
where state ="Successful"
group by `name`
order by goal_usd desc
limit 5;

#Top Successful Projects Based on No. of backers
select `name`, count(backers_count) no_of_backers from projects 
where state = "successful"
group by `name`
order by no_of_backers desc
limit 5;

#Percentage of Successful Projects overall
SELECT 
    COUNT(ProjectID) AS total_projects,
    SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
    (SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) / COUNT(ProjectID)) * 100 AS success_percentage
FROM 
    projects;
    
#Percentage of Successful Projects  by Category
SELECT
    c.name,
    COUNT(p.ProjectID) AS total_projects,
    SUM(CASE WHEN p.state = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
    (SUM(CASE WHEN p.state = 'successful' THEN 1 ELSE 0 END) / COUNT(p.ProjectID)) * 100 AS success_percentage
FROM
    projects p
INNER JOIN
    crowdfunding_category c ON p.category_id = c.id
GROUP BY c.name
order by c.name desc
limit 5;

#Percentage of Successful Projects by Year , Month
SELECT b.Year, b.`Month fullname`, COUNT(p.ProjectID) AS total_projects,
    SUM(CASE WHEN p.state = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
    (SUM(CASE WHEN p.state = 'successful' THEN 1 ELSE 0 END) / COUNT(p.ProjectID)) * 100 AS success_percentage
FROM `calender table` b
LEFT JOIN
    projects p ON b.created_at = p.created_at
GROUP BY b.Year, b.`Month fullname`
ORDER BY b.Year, b.`Month fullname`;
    

#Percentage of Successful projects by Goal Range
select goal_range, COUNT(*) AS total_projects,
    SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) AS successful_projects,
    (SUM(CASE WHEN state = 'successful' THEN 1 ELSE 0 END) / COUNT(*)) * 100 AS success_percentage
FROM (
    SELECT
        CASE
            WHEN goal < 10000 THEN '0-9999'
            WHEN goal between 10000 AND 20000 THEN '10000-20000'
            WHEN goal between 20001 AND 30000 THEN '20000-30000'
            WHEN goal between 30001 AND 40000 THEN '30000-40000'
            WHEN goal between 40001 AND 50000 THEN '40000-50000'
            ELSE '50000+'
        END AS goal_range,
        state
    FROM projects
) AS goal_range
GROUP BY goal_range
ORDER BY goal_range;




