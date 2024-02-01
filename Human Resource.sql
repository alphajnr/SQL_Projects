SELECT *
FROM Projectz.dbo.hrm

-- gender breakdown of employees 

SELECT gender, COUNT(*) AS gender_count
FROM Projectz.dbo.hrm
GROUP BY gender;

-- gender breakdown by percentage

SELECT
    gender,
    COUNT(*) AS gender_count,
    CAST(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS DECIMAL(5, 2)) AS percentage
FROM Projectz.dbo.hrm
GROUP BY gender
ORDER BY gender_count DESC;

-- race breakdown of employees in the company

SELECT race,
    COUNT(*) as race_count
FROM Projectz.dbo.hrm
GROUP BY race
ORDER BY race_count DESC

--  age distribution of employees 

SELECT
    FLOOR(DATEDIFF(DAY, birthdate, GETDATE()) / 365.25) AS age,
    COUNT(*) AS employee_count
FROM Projectz.dbo.hrm
GROUP BY
    FLOOR(DATEDIFF(DAY, birthdate, GETDATE()) / 365.25)
ORDER BY age;

-- How many employees work at headquarters vs remote 

SELECT location,
    COUNT(*) AS employee_count
FROM Projectz.dbo.hrm
GROUP BY location;

-- jobtitles distribution across the company

SELECT department, jobtitle, COUNT(*) AS title_count
FROM Projectz.dbo.hrm
GROUP BY department, jobtitle
ORDER BY title_count DESC;

-- total employees per department

SELECT DISTINCT(department), COUNT(*) AS title_count
FROM Projectz.dbo.hrm
GROUP BY department
ORDER BY title_count DESC;

-- department that has the highest turnover rate

SELECT 
    department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN termdate IS NOT NULL THEN 1 ELSE 0 END) AS terminated_employees, 100.0 * 
	SUM(CASE WHEN termdate IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) AS turnover_rate
FROM Projectz.dbo.hrm
GROUP BY department
ORDER BY turnover_rate DESC;

-- gender distribution across departments 

SELECT 
    department, gender,
    COUNT(*) AS employee_count, 100.0 * COUNT(*) / SUM(COUNT(*)) 
	OVER (PARTITION BY department) AS percentage
FROM Projectz.dbo.hrm
GROUP BY department, gender
ORDER BY department ASC
