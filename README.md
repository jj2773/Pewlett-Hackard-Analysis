# Pewlett Hackard Retirement Planning Analysis

## Overview
The purpose of the analysis is to determine the number of employees retiring per title.  Additionally it is desired to identify employees eligible to participate in a mentorship program. The retirement criteria was employees who were born between January 1, 1952 and December 31, 1955.  While the mentorship program requires employees who were born between January 1, 1965 and December 31, 1965.

## Results
Retirement titles was found by creating a query with the criteria of birth dates between January 1, 1952 and December 31, 1955 from the employees table and joining it with the latest title from the titles table.

* The titles query below was interesting in that the ORDER BY to_date DESC statement was applied prior to the SELECT DISTINCT ON (emp_no).  This enabled the query to return the latest title.
![alt text](https://github.com/jj2773/PEWLETT-HACKARD-ANALYSIS/blob/main/UNIQUE_TITLES_QUERY.PNG)

* This unique titles table could then be leveraged by a GROUP BY query as seen below to produce the employees retiring per title.  The total number of titles impacted were 7 with 90,398 people retiring.
![alt text](https://github.com/jj2773/PEWLETT-HACKARD-ANALYSIS/blob/main/RETIRING_TITLES_QUERY.PNG)

![alt text](https://github.com/jj2773/PEWLETT-HACKARD-ANALYSIS/blob/main/RETIRING_TITLES.PNG)

* Additionally, a query to determine the eligibility in the mentorship program was written.  This query has a sub-query to first get the latest departement of the employee.  Then using that result a join with the employees and the latest titles tables was done to get the name, birth date, from_date for the department start, and the to_date when they left the department.

![alt text](https://github.com/jj2773/PEWLETT-HACKARD-ANALYSIS/blob/main/MENTORSHIP_QUERY.PNG)

![alt text](https://github.com/jj2773/PEWLETT-HACKARD-ANALYSIS/blob/main/MENTORSHIP_TABLE.PNG)

* There were 1,550 people eligible for the mentorship program versus the 90,398 retiring.

## Summary
In summary it appears that our analysis for title counts did not consider if the person was still employed and how many years of service.  These two questions can be answered by adding this information to the query for titles retiring for a more accurate count of 33,118. 

![alt text](https://github.com/jj2773/PEWLETT-HACKARD-ANALYSIS/blob/main/RETIRING_TITLES_QUERY-2.PNG)

![alt text](https://github.com/jj2773/PEWLETT-HACKARD-ANALYSIS/blob/main/RETIRING_TITLES-2.PNG)

Another question is what is the count of titles mentoring as a comparison to those retiring.

![alt text](https://github.com/jj2773/PEWLETT-HACKARD-ANALYSIS/blob/main/MENTORSHIP_TITLES_QUERY.PNG)

![alt text](https://github.com/jj2773/PEWLETT-HACKARD-ANALYSIS/blob/main/MENTORSHIP_TITLES.PNG)

