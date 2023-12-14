-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/xLERwD
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR(250)   NOT NULL,
    "birth_date" VARCHAR(250)   NOT NULL,
    "first_name" VARCHAR(250)   NOT NULL,
    "last_name" VARCHAR(250)   NOT NULL,
    "sex" VARCHAR(250)   NOT NULL,
    "hire_date" VARCHAR(250)   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR(250)   NOT NULL,
    "title" VARCHAR(250)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR(250)   NOT NULL,
    "dept_name" VARCHAR(250)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR(250)   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(250)   NOT NULL,
    "emp_no" INT   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "dept_no","emp_no"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");





-- Query 1: List the employee number, last name, first name, sex, and salary of each employee. 

SELECT
    e.emp_no AS "Employee Number",
    e.last_name AS "Last Name",
    e.first_name AS "First Name",
    e.sex AS "Sex",
    s.salary AS "Salary"
FROM
    employees e
JOIN
    salaries s ON e.emp_no = s.emp_no;


-- Query 2: List the first name, last name, and hire date for the employees who were hired in 1986.

SELECT
    first_name AS "First Name",
    last_name AS "Last Name",
    hire_date AS "Hire Date"
FROM
    employees
WHERE
    EXTRACT(YEAR FROM TO_DATE(hire_date, 'MM/DD/YYYY')) = 1986;


-- Query 3: List the manager of each department along with their department number, department name, employee number, last name, and first name.

SELECT
    dm.dept_no AS "Department Number",
    d.dept_name AS "Department Name",
    dm.emp_no AS "Employee Number",
    e.last_name AS "Last Name",
    e.first_name AS "First Name"
FROM
    dept_manager dm
JOIN
    departments d ON dm.dept_no = d.dept_no
JOIN
    employees e ON dm.emp_no = e.emp_no;


-- Query 4: List the department number for each employee along with that employee’s employee number, last name, first name, and department name.

SELECT
    de.dept_no AS "Department Number",
	e.emp_no AS "Employee Number",
	e.last_name AS "Last Name",
    e.first_name AS "First Name",
    d.dept_name AS "Department Name"
FROM
    dept_emp de
JOIN
    employees e ON e.emp_no = de.emp_no
JOIN
    departments d ON de.dept_no = d.dept_no;


-- Query 5: List first name, last name, and sex of each employee whose first name is Hercules and whose last name begins with the letter B

SELECT
    first_name AS "First Name",
    last_name AS "Last Name",
    sex AS "Sex"
FROM
    employees
WHERE
    first_name = 'Hercules' AND last_name LIKE 'B%';


-- QUery 6: List each employee in the Sales department, including their employee number, last name, and first name.

SELECT
    e.emp_no AS "Employee Number",
    e.last_name AS "Last Name",
    e.first_name AS "First Name"
FROM
    employees e
JOIN
    dept_emp de ON e.emp_no = de.emp_no
JOIN
    departments d ON de.dept_no = d.dept_no
WHERE
    d.dept_name = 'Sales';


-- Query 7: List each employee in the Sales and Development departments, including their employee number, last name, first name, and department name (4 points)

SELECT
    e.emp_no AS "Employee Number",
    e.last_name AS "Last Name",
    e.first_name AS "First Name",
    d.dept_name AS "Department Name"
FROM
    employees e
JOIN
    dept_emp de ON e.emp_no = de.emp_no
JOIN
    departments d ON de.dept_no = d.dept_no
WHERE
    d.dept_name IN ('Sales', 'Development');
    

-- Query 8: List the frequency counts, in descending order, of all the employee last names (that is, how many employees share each last name) (4 points)

SELECT
    last_name AS "Last Name",
    COUNT(*) AS "Frequency"
FROM
    employees
GROUP BY
    last_name
ORDER BY
    "Frequency" DESC;


