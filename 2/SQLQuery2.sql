-- Build the Schema
-----------------------------------------

CREATE TABLE Departments (
  Code INTEGER PRIMARY KEY,
  Name varchar(255) NOT NULL ,
  Budget decimal NOT NULL 
);

CREATE TABLE Employees (
  SSN INTEGER PRIMARY KEY,
  Name varchar(255) NOT NULL ,
  LastName varchar(255) NOT NULL ,
  Department INTEGER NOT NULL , 
  foreign key (department) references Departments(Code) 
);

INSERT INTO Departments(Code,Name,Budget) VALUES(14,'IT',65000);
INSERT INTO Departments(Code,Name,Budget) VALUES(37,'Accounting',15000);
INSERT INTO Departments(Code,Name,Budget) VALUES(59,'Human Resources',240000);
INSERT INTO Departments(Code,Name,Budget) VALUES(77,'Research',55000);

INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('123234877','Michael','Rogers',14);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('152934485','Anand','Manikutty',14);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('222364883','Carol','Smith',37);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('326587417','Joe','Stevens',37);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('332154719','Mary-Anne','Foster',14);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('332569843','George','ODonnell',77);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('546523478','John','Doe',59);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('631231482','David','Smith',77);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('654873219','Zacary','Efron',59);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('745685214','Eric','Goldsmith',59);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('845657245','Elizabeth','Doe',14);
INSERT INTO Employees(SSN,Name,LastName,Department) VALUES('845657246','Kumar','Swamy',14);
---------------------------------------------------------------------------------------------------------
--- 2.1 Select the last name of all employees.
select name from Employees

--------------------------------------------------------------------------------------------------------
---- 2.2 Select the last name of all employees, without duplicates.
select distinct name from Employees
-------------------------------------------------------------------------------------------------------
-- 2.3 Select all the data of employees whose last name is "Smith".
select * from Employees
select * from Employees where LastName = 'smith'
-------------------------------------------------------------------------------------------------------
-- 2.4 Select all the data of employees whose last name is "Smith" or "Doe".
select * from Employees where LastName = 'Smith' or LastName = 'Doe'
-------------------------------------------------------------------------------------------------------
-- 2.5 Select all the data of employees that work in department 14.

select * from Employees where Department = 14
-------------------------------------------------------------------------------------------------------
---- 2.6 Select all the data of employees that work in department 37 or department 77.
select * from Employees where Department = 14 or Department = 77
-------------------------------------------------------------------------------------------------------
-- 2.7 Select all the data of employees whose last name begins with an "S".
select * from Employees where LastName like 's%'
-------------------------------------------------------------------------------------------------------
-- 2.8 Select the sum of all the departments' budgets.
select sum(Budget) from Departments
-------------------------------------------------------------------------------------------------------
--- 2.9 Select the number of employees in each department 
--(you only need to show the department code and the number of employees).
select count(*) as Number_of_employess,Departments.Code
from Employees inner Join Departments
on Employees.Department = Departments.Code
group by Departments.Code
-------------------------------------------------------------------------------------------------------
---- 2.10 Select all the data of employees, including each employee's department's data.
select *,Departments.Code,Departments.Name
from Employees inner Join Departments
on Employees.Department = Departments.Code
--------------------------------------------------------------------------
--- 2.11 Select the name and last name of each employee, 
--along with the name and budget of the employee's department.

select Employees.Name + ' ' + Employees.LastName as Fullname,
       Departments.Name,Departments.Budget
FROM Employees inner Join Departments
on Departments.Code = Employees.Department
-----------------------------------------------------------------------------------------------
--- 2.12 Select the name and last name of employees working for departments 
--with a budget greater than $60,000.

select Employees.Name + ' ' + Employees.LastName as Fullname,
       Departments.Name,Departments.Budget
FROM Employees inner Join Departments
on Departments.Code = Employees.Department
where Departments.Budget > 60000

select name, lastname
from employees 
where department in (
select code from departments where Budget>60000
);
-----------------------------------------------------------------------------------------------------
--- 2.13 Select the departments with 
--a budget larger than the average budget of all the departments.

select Employees.Name + ' ' + Employees.LastName as Fullname,
       Departments.Name,Departments.Budget
FROM Employees inner Join Departments
on Departments.Code = Employees.Department
where Departments.Budget > (select avg(Budget) from Departments)

select *
from departments 
where budget > (
select avg(budget) from departments
);

SELECT *
  FROM Departments
  WHERE Budget >
  (
    SELECT AVG(Budget)
    FROM Departments
  );

  --------------------------------------------------------------------------------------
  -- 2.14 Select the names of departments with more than two employees.
  select Departments.Name from Departments
  where Departments.Code in (select Employees.Department from Employees group by Employees.Department having count(*) >2 )


  select * from Departments
  ----------------------------------------------------------------------------------------------------
  ---- 2.15 Very Important - Select the name and last name of employees working for departments 
  --with second lowest budget.
  --PARTITION BY Departments.code 
  select * from (
  select Employees.Name,
         LastName,
		 Departments.Code,
		 budget,
		 DENSE_RANK() over(order by budget asc) as DR 
  from Employees
  inner join Departments
  on Employees.Department = Departments.Code) as SUB
  where DR =2

  select * from Departments
  -------------------------------------------------------------------------------------------------------------
  -- 2.16  Add a new department called "Quality Assurance", 
  --with a budget of $40,000 and departmental code 11. 

  insert into Departments
  values(11,'Quality Assurance',40000)
  --------------------------------------------------------------------------------------------------------
  -- And Add an employee called "Mary Moore" in that department, with SSN 847-21-9811.
  select * from Employees
  insert into Employees
  values(847219811,'Mary','Moore',11)
  ----------------------------------------------------------------------------------------------------
  ----- 2.17 Reduce the budget of all departments by 10%.
  update Departments set Budget = Budget * .9

  ---------------------------------------------------------------------------------------------------
  ---- 2.19 Delete from the table all employees in the IT department (code 14).
  delete from Employees where Employees.Department=14
  -----------------------------------------------------------------------------------------------------
  ---- 2.20 Delete from the table all employees who work in departments with a budget 
  ---- greater than or equal to $60,000.
  delete from Employees 
  where Employees.Department in (select Departments.Code from Departments where Budget >= 60000)



