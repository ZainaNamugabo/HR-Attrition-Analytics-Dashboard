SELECT *
FROM employee_data;

SELECT * 
FROM employee_data
WHERE ExitDate IS NULL
AND TerminationDescription IS NULL;

-------returning current date because the employees are still active----
UPDATE employee_data
SET ExitDate = CAST(GETDATE() AS DATE)
WHERE ExitDate IS NULL;

UPDATE employee_data
SET ExitDate = NULL
WHERE ExitDate = '2026-03-24';

UPDATE employee_data
SET TerminationDescription = 'Empolyment still Active'
WHERE TerminationDescription IS NULL;

UPDATE employee_data
SET TerminationDescription = NULL
WHERE TerminationDescription = 'Empolyment still Active';

-----checking for duplicates
SELECT EmpID, COUNT(*) AS duplicate_count
FROM employee_data
GROUP BY EmpID
HAVING COUNT(*) > 1;

----checking for duplicates using cte
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY EmpID ORDER BY EmpID) AS row_num
    FROM employee_data
)
DELETE FROM CTE WHERE row_num > 1;

----count number of employees---
SELECT COUNT(*) AS total_employees
FROM employee_data;

-----count number of employees by title
SELECT Title, COUNT(Title) AS no_of_employees_by_title
FROM employee_data
GROUP BY Title
ORDER BY no_of_employees_by_title;

SELECT DepartmentType, COUNT(DepartmentType) AS employees_by_department
FROM employee_data
GROUP BY DepartmentType
ORDER BY employees_by_department;

-----count number of employees by status
SELECT EmployeeStatus, COUNT(EmployeeStatus) AS employees_by_status
FROM employee_data
GROUP BY EmployeeStatus
ORDER BY employees_by_status;

SELECT *
FROM employee_data
WHERE EmployeeStatus IN ('Terminated for Cause' , 'Voluntarily Terminated');

SELECT *
FROM employee_data
WHERE EmployeeStatus IN ('Active' , 'Future Start');

SELECT *
FROM employee_data
WHERE EmployeeStatus = 'Leave of Absence';

-----count number of employees by type
SELECT EmployeeType, COUNT(EmployeeType) AS employees_by_type
FROM employee_data
GROUP BY EmployeeType
ORDER BY employees_by_type;

SELECT *
FROM employee_data
WHERE EmployeeType = 'Part-Time';

SELECT *
FROM employee_data
WHERE EmployeeType = 'Contract';

SELECT *
FROM employee_data
WHERE EmployeeType = 'Full-Time';

-----count number of employees by tremination type
SELECT TerminationType, COUNT(TerminationType) AS employees_by_termination
FROM employee_data
GROUP BY TerminationType
ORDER BY employees_by_termination;

-----count number of employees by state
SELECT [State], COUNT([State]) AS employees_by_state
FROM employee_data
GROUP BY [State]
ORDER BY employees_by_state DESC;

-----count number of employees by GenderCode
SELECT GenderCode, COUNT(GenderCode) AS employees_by_gender
FROM employee_data
GROUP BY GenderCode
ORDER BY employees_by_gender DESC;

-----count number of employees by MaritalDesc
SELECT MaritalDesc, COUNT(MaritalDesc) AS employees_by_marital
FROM employee_data
GROUP BY MaritalDesc
ORDER BY employees_by_marital DESC;

-----count number of employees by RaceDesc
SELECT RaceDesc, COUNT(RaceDesc) AS employees_by_Race
FROM employee_data
GROUP BY RaceDesc
ORDER BY employees_by_Race DESC;

-----count number of employees by Performa scorence
SELECT Performance_Score, COUNT(Performance_Score) AS employees_by_performance
FROM employee_data
GROUP BY Performance_Score
ORDER BY employees_by_performance DESC;

SELECT *
FROM employee_data
WHERE Performance_Score = 'Exceeds';

SELECT *
FROM employee_data
WHERE Current_Employee_Rating >= 3;

-----count number of employees by Performa scorence
SELECT PayZone, COUNT(PayZone) AS employees_by_PayZone
FROM employee_data
GROUP BY PayZone
ORDER BY employees_by_PayZone DESC;


-----extract employee starting years
SELECT 
    StartDate,
    YEAR(StartDate) AS StartYear
FROM employee_data;

ALTER TABLE employee_data
ADD StartYear INT;

UPDATE employee_data
SET StartYear = YEAR(StartDate);

-----Extracting Month
SELECT 
    StartDate,
    DATENAME(MONTH, StartDate) AS StartMonthName
FROM employee_data;

ALTER TABLE employee_data
ADD StartMonthName VARCHAR(50);

UPDATE employee_data
SET StartMonthName = DATENAME(MONTH, StartDate);


-----extract employee exiting years AND mONTH
SELECT 
    ExitDate,
    YEAR(ExitDate) AS ExitYear
FROM employee_data;

ALTER TABLE employee_data
ADD ExitYear INT;

UPDATE employee_data
SET ExitYear = YEAR(ExitDate);


-----Extracting Month
SELECT 
    ExitDate,
    DATENAME(MONTH, ExitDate) AS ExitMonthName
FROM employee_data;

ALTER TABLE employee_data
ADD ExitMonthName VARCHAR(50);

UPDATE employee_data
SET ExitMonthName = DATENAME(MONTH, ExitDate);

ALTER TABLE employee_data
DROP COLUMN ExitMonthName;

------Collecting age from dob
SELECT 
    DOB,
    DATEDIFF(YEAR, DOB, GETDATE()) 
      - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, DOB, GETDATE()), DOB) > GETDATE() 
             THEN 1 ELSE 0 END AS Age
FROM employee_data;

ALTER TABLE employee_data
ADD Age INT;

UPDATE employee_data
SET Age = DATEDIFF(YEAR, DOB, GETDATE()) 
      - CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, DOB, GETDATE()), DOB) > GETDATE() 
             THEN 1 ELSE 0 END;

-------describing age_froup by Age
SELECT 
    MAX(Age) AS max_age,
    MIN(Age) AS min_age
FROM employee_data;

SELECT
    IIF(Age <= 24, 'Young Adult',
	   IIF(Age BETWEEN 24 AND 45, 'Middle Age', 'Senior'
	   )) AS Age_group
FROM employee_data;

ALTER TABLE employee_data
ADD Age_group VARCHAR(50);

UPDATE employee_data
SET Age_group = IIF(Age <= 24, 'Young Adult',
	   IIF(Age BETWEEN 24 AND 45, 'Middle Age', 'Senior'
	   ));
