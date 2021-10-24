-- Deliverable 1 
-- create a Retirement Titles table that holds all the titles of 
-- current employees who were born between January 1, 1952 and December 31, 1955. 
-- 1 Retrieve the emp_no, first_name, and last_name columns from the Employees table.

SELECT e.emp_no, e.first_name, e.last_name
FROM employees as e;

-- 2 Retrieve the title, from_date, and to_date columns from the Titles table.

SELECT title, from_date, to_date
FROM titles;

-- 3 Create a new table using the INTO clause.
-- 4 Join both tables on the primary key.
-- 5 Filter the data on the birth_date column to retrieve the employees who were born between 1952 and 1955. 
--      Then, order by the employee number.

-- (note seems a bit odd that the Challenge has dropped the filtering of years of service by hire date and still employed)
-- AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
-- AND (de.to_date='9999-01-01')

-- ##############################################################################################################
-- ##############################################################################################################
-- ## A query is written and executed to create 
-- ## a Retirement Titles table for employees who are born between January 1, 1952 and December 31, 1955. (10 pt)
SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
INTO retirement_titles
FROM employees as e
LEFT JOIN titles as t
ON (e.emp_no=t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;
-- ##############################################################################################################


-- ##############################################################################################################
-- ##############################################################################################################
-- ## The Retirement Titles table is exported as retirement_titles.csv. (5 pt)
-- 6 Export the Retirement Titles table from the previous step as retirement_titles.csv and save it to 
--      your Data folder in the Pewlett-Hackard-Analysis folder.
--'\Pewlett-Hackard-Analysis\Data\retirement_titles.csv' csv header;
-- ##############################################################################################################


-- 8  Copy the query from the Employee_Challenge_starter_code.sql and add it to your Employee_Database_challenge.sql file.+
-- Use Dictinct with Orderby to remove duplicate rows
--SELECT DISTINCT ON (______) _____,
--______,
--______,
--______

--INTO nameyourtable
--FROM _______
--ORDER BY _____, _____ DESC;

-- 9  Retrieve the employee number, first and last name, and title columns from the Retirement Titles table.
--          These columns will be in the new table that will hold the most recent title of each employee.

SELECT emp_no, first_name, last_name, title
FROM retirement_titles;

-- 10 Use the DISTINCT ON statement to retrieve the first occurrence of the employee number for each set of rows 
--          defined by the ON () clause.
-- 11 Create a Unique Titles table using the INTO clause.
-- 12 Sort the Unique Titles table in ascending order by the employee number and 
--        descending order by the last date (i.e. to_date) of the most recent title.

-- ##############################################################################################################
-- ##############################################################################################################
-- ## A query is written and executed to create a Unique Titles table that contains 
-- ## the employee number, first and last name, and most recent title. (15 pt)
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name, title
INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;
-- ##############################################################################################################


-- ##############################################################################################################
-- ##############################################################################################################
-- ## ​The Unique Titles table is exported as unique_titles.csv. (5 pt)
-- 13 Export the Unique Titles table as unique_titles.csv and save it to your Data folder 
--        in the Pewlett-Hackard-Analysis folder.
-- This had to be done through the GUI in PGADMIN 
-- see below path 
--'\Pewlett-Hackard-Analysis\Data\unique_titles.csv' csv header;
-- ##############################################################################################################





-- 15 Write another query in the Employee_Database_challenge.sql file to retrieve the number of employees by their most 
--      recent job title who are about to retire.
-- 16 First, retrieve the number of titles from the Unique Titles table.

-- ##############################################################################################################
-- ##############################################################################################################
-- ## A query is written and executed to create a Retiring Titles table 
--      that contains the number of titles filled by employees who are retiring. (10 pt)
SELECT COUNT(title) as titles_count, title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY titles_count DESC;
-- ##############################################################################################################

-- 17 Then, create a Retiring Titles table to hold the required information.
-- 18 Group the table by title, then sort the count column in descending order.
-- 19 Export the Retiring Titles table as retiring_titles.csv and save it to your Data 
--      folder in the Pewlett-Hackard-Analysis folder.


-- ##############################################################################################################
-- ##############################################################################################################
-- ## The Retiring Titles table is exported as retiring_titles.csv. (5 pt)
-- This had to be done through the GUI in PGADMIN 
-- see below path 
--'\Pewlett-Hackard-Analysis\Data\retiring_titles.csv' csv header;
-- -- ##############################################################################################################


--  Just for fun adding a title query to answer the original module content of people retiring with
--  additional restrictions of hire date and still employed

SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
FROM employees as e
LEFT JOIN (
	SELECT DISTINCT ON (emp_no) emp_no, title, from_date, to_date
	FROM titles
	ORDER BY emp_no, to_date DESC
	) as t
ON (e.emp_no=t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (t.to_date='9999-01-01')

-- ## Just for fun adding a a group by on this query to get the titles with additional restrictions
-- of hire date and still employed.
-- 
SELECT COUNT(title), title FROM (
    SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
    FROM employees as e
    LEFT JOIN (
    	SELECT DISTINCT ON (emp_no) emp_no, title, from_date, to_date
    	FROM titles
    	ORDER BY emp_no, to_date DESC
    	) as t
    ON (e.emp_no=t.emp_no)
    WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
    AND (t.to_date='9999-01-01')
) AS Q1
GROUP BY title

-- Deliverable 2
-- mentorship-eligibility table that holds the current employees who were born between January 1, 1965 and December 31, 1965.


-- 1  Retrieve the emp_no, first_name, last_name, and birth_date columns from the Employees table.
SELECT emp_no, first_name, last_name, birth_date
from employees;

-- 2  Retrieve the from_date and to_date columns from the Department Employee table.
SELECT from_date, to_date
from dept_emp;
-- 3  Retrieve the title column from the Titles table.
SELECT title
from titles;

-- 4  Use a DISTINCT ON statement to retrieve the first occurrence of the employee number for each set of rows 
--		defined by the ON () clause.
SELECT DISTINCT ON (de.emp_no) emp_no, de.from_date, de.to_date
FROM dept_emp as de
ORDER BY emp_no, to_date DESC

-- 5  Create a new table using the INTO clause.
SELECT DISTINCT ON (emp_no) emp_no, title
INTO latest_titles
FROM titles
ORDER BY emp_no, to_date DESC;

-- 6  Join the Employees and the Department Employee tables on the primary key.
-- 7  Join the Employees and the Titles tables on the primary key.
-- 8  Filter the data on the to_date column to all the current employees, then filter the data on the birth_date 
--		columns to get all the employees whose birth dates are between January 1, 1965 and December 31, 1965.
-- 9  Order the table by the employee number.

-- ##############################################################################################################
-- ##############################################################################################################
-- ## A query is written and executed to create a Mentorship Eligibility table for current employees 
-- ## who were born between January 1, 1965 and December 31, 1965. (25 pt)

SELECT e.emp_no, e.last_name, e.first_name, e.birth_date, de.from_date, de.to_date, t.title
INTO mentor_eligible
FROM
	(SELECT DISTINCT ON (emp_no) emp_no, from_date, to_date 
	FROM dept_emp 
	WHERE to_date='9999-01-01'
	ORDER BY emp_no, to_date DESC) as de
LEFT JOIN employees as e
ON (e.emp_no=de.emp_no)
LEFT JOIN latest_titles as t
ON (e.emp_no=t.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY emp_no
-- ##############################################################################################################

-- 10 Export the Mentorship Eligibility table as mentorship_eligibilty.csv and save it to your Data folder 
--		in the Pewlett-Hackard-Analysis folder.
-- 11 Before you export your table, confirm that it looks like this image
-- ##############################################################################################################
-- ##############################################################################################################
-- ## The Mentorship Eligibility table is exported and saved as mentorship_eligibilty.csv. (5 pt)
-- This had to be done through the GUI in PGADMIN 
-- see below path 
--'\Pewlett-Hackard-Analysis\Data\mentorship_eligibility.csv' csv header;




