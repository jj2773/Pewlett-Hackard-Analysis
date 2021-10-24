-- Given CSVs imported as tables are:

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- departments
--     dept_no PK int
--     dept_name string
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- dept_emp
--     dept_no PK varchar fk - Departments.dept_no
--     emp_no PK int fk >- Employees.emp_no fk >- Salaries.emp_no
--     from_date date
--     to_date date
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- dept_manager
--     dept_no PK varchar fk - Departments.dept_no 
--     emp_no PK int fk >- Employees.emp_no
--     from_date date
--     to_date date
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- employees
--     emp_no PK int fk - Employees.emp_no fk
--     birth_date date
--     first_name string
--     last_name string
--     gender string
--     hire_date date
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- salaries
--     emp_no PK int fk - Employees.emp_no
--     salary int
--     from_date date
--     to_date date
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- titles
--     emp_no PK int fk - Salaries.emp_no fk - Employees.emp_no
--     title PK string
--     from_date PK date
--     to_date date
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


-- How many employees have retirement eligibility with the criteria of 
-- birth date ranges BETWEEN '1952-01-01' AND '1955-12-31' and hire date ranges BETWEEN '1985-01-01' AND '1988-12-31'
-- Retirement eligibility
SELECT count(*)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--output count from above query gives 41,380 

-- Let's now write this output list to a table retirement_info but also add emp_no key
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- retirement_info
--     emp_no PK int fk >- Employees.emp_no
--     first_name string
--     last_name string
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- Let's create a query that will return each department name from the Departments table 
-- as well as the employee numbers and the from- and to- dates from the dept_manager table. 
-- We'll use an inner join because we want all of the matching rows from both tables.

-- Joining departments and dept_manager tables
SELECT d.dept_name
     , dm.emp_no
     , dm.from_date
     , dm.to_date
FROM departments AS d
INNER JOIN dept_manager AS dm
ON d.dept_no = dm.dept_no;

--  jj note that the query returns 24 rows, but if you filter on to_date on the manager table 
--  you only get the latest 9 manager list for the 9 departments.

-- The current retirement_info table generated has listed employees who are no longer with the company
-- because we didn't check the to_date.  Make a new table current_emp that will give a list of retirement 
-- eligible employees that are still employed.
-- Strategy is to take our current retirement_info table and join on dept_emp table to get the to_date
-- Joining retirement_info and dept_emp tables
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- current_emp
--     emp_no PK int fk >- Employees.emp_no
--     first_name string
--     last_name string
--     to_date date
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
    de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

-- count is 33,118
-- now summarize the new retirement list by department and put into a new table current_emp_by_dept
-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
INTO current_emp_by_dept
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Module 7.3.5
-- Because of the number of people leaving each department, the boss has requested 
-- three lists that are more specific:

-- 1 Employee Information: A list of retiring employees containing their unique employee number, 
-- their last name, first name, gender, and salary
-- 2 Management: A list of managers for each department, including the department number, name, 
-- and the manager's employee number, last name, first name, and the starting and ending employment dates
-- 3 Department Retirees: An updated current_emp list that includes everything it currently has, 
-- but also the employee's departments

-- Item 1 Employee Information:
SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary, de.to_date
INTO emp_info
FROM employees AS e
INNER JOIN salaries as s
ON (e.emp_no=s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no=de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date='9999-01-01')

-- count of retired people is 33,118

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- emp_info
--     emp_no PK int fk >- Employees.emp_no
--     first_name string
--     last_name string
--     to_date date
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- Item 2 Management: 
-- List of managers per department retiring

SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM dept_manager AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);

-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
-- manager_info
--     dept_no PK int
--     dept_name string
--     emp_no PK int fk >- Employees.emp_no
--     first_name string
--     last_name string
--     from_date date
--     to_date date
-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

-- Item 3 Department Retirees: An updated current_emp list that includes everything it currently has, 
-- but also the employee's departments

SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

-- Skill Drill
-- Create a unique list for the Sales Department on their retirement list
SELECT *
FROM dept_info
WHERE dept_name='Sales'

-- Skill Drill
-- Create a unique list for the Sales Department and Development on their retirement list
SELECT *
FROM dept_info
WHERE dept_name IN ('Development','Sales')










