IF(db_id('Test03') IS NULL)
	CREATE DATABASE Test03;
GO

--Open the Database to enable us to create the Objects (tables)
USE Test03;
GO

--Department (Dept_id (pk), dept_name)
If not exists (SELECT '1' from INFORMATION_SCHEMA.TABLES 
						where TABLE_NAME = 'Department')
	CREATE TABLE Department
	( 
		dept_id int identity(1000,1),
		dept_name varchar(100),
		CONSTRAINT pk_Department PRIMARY KEY(dept_id)
	);
GO

--Staff (stf_id (pk), stf_lname, stf_onames, stf_addr, stf_town, Dept_ID (fk))
IF NOT EXISTS (SELECT '1' FROM INFORMATION_SCHEMA.TABLES 
						WHERE TABLE_NAME = 'Staff')
	CREATE TABLE Staff
	(
		stf_id INT IDENTITY,
		stf_lname nvarchar(80) NOT NULL,
		stf_onames nvarchar(100) NOT NULL,
		stf_addr varchar(100),
		stf_town varchar(100),
		dept_ID int,
		CONSTRAINT PK_STAFF PRIMARY KEY(stf_id)
	)
GO

--Load Data (Department)
INSERT INTO Department(dept_name)
VALUES ('Human Resources'),('Finance'),('Information Technology'),('Procurement');

--Load Data (staff)
INSERT INTO Staff(stf_lname,stf_onames,stf_addr,stf_town,dept_ID)
VALUES('Otieno','Victor','345, Kisumu','Kisumu',1000),
('Wanjiru','Anne','113, Mombasa','Voi',1001),
('Mohamed','Abdi','245, Garissa','Garissa',1000),
('Wafula','Moses','34567, Kitale','Bungoma',99),
('Mutai','Arnold','7863, Matuu','Machakos',99);

select * from Department
select * from staff

truncate table Department
truncate table staff

--JOINs

select stf_id,stf_lname,stf_onames,stf_addr,stf_town,dept_name
from staff, Department
where staff.dept_ID = Department.dept_id

/*
INNER JOIN - Exact matches
LEFT JOIN - Returns all rows in the left table regardless of matches in the right table
RIGHT JOIN - Returns all rows in the right table regardless of matches in the left table
FULL JOIN - Combines the LEFT and the RIGHT join

SELECT <column1>,..,<columnn>
From <table1>
JOIN <table2> ON <CRiteria>
.
.
.
JOIN <tablen> ON <Ctiteria>
*/

--INNER JOIN Exact matches
select stf_id,stf_lname,stf_onames,stf_addr,stf_town,dept_name
from staff, Department
where staff.dept_ID = Department.dept_id

--Table Aliases
select s.stf_id,s.stf_lname,s.stf_onames,s.stf_addr,s.stf_town,d.dept_name
from staff AS s
INNER JOIN Department AS d
	ON d.dept_ID = s.dept_id;

--full table qualification
select staff.stf_id,staff.stf_lname,staff.stf_onames,staff.stf_addr,staff.stf_town,Department.dept_name
from staff 
INNER JOIN Department 
	ON Department.dept_ID = staff.dept_id;


--LEFT JOIN Returns all rows in the left table regardless of matches in the right table
select s.stf_id,s.stf_lname,s.stf_onames,s.stf_addr,s.stf_town,d.dept_name 
from staff AS s 
LEFT JOIN Department AS d 	
	ON d.dept_ID = s.dept_id;

--RIGHT JOIN Returns all rows in the right table regardless of matches in the left table
select s.stf_id,s.stf_lname,s.stf_onames,s.stf_addr,s.stf_town,d.dept_name
from staff AS s
RIGHT JOIN Department AS d
	ON d.dept_ID = s.dept_id;

--FULL JOIN Combines the LEFT and the RIGHT join
select s.stf_id,s.stf_lname,s.stf_onames,s.stf_addr,s.stf_town,d.dept_name
from staff AS s
FULL JOIN Department AS d
	ON d.dept_ID = s.dept_id;

--Same effect as performing a UNION between the LEFT and RIGHT JOIN
select s.stf_id,s.stf_lname,s.stf_onames,s.stf_addr,s.stf_town,d.dept_name
from staff AS s
LEFT JOIN Department AS d
	ON d.dept_ID = s.dept_id
UNION
select s.stf_id,s.stf_lname,s.stf_onames,s.stf_addr,s.stf_town,d.dept_name
from staff AS s
RIGHT JOIN Department AS d
	ON d.dept_ID = s.dept_id;

select * from Department

--Add an extra column in staff called salary 
ALTER TABLE staff add [salary] float;

select * FROM staff

update staff set salary = 15000 where stf_id = 1;
update staff set salary = 16000 where stf_id = 2;
update staff set salary = 20000 where stf_id = 3;
update staff set salary = 25000 where stf_id = 4;
update staff set salary = 30000 where stf_id = 5;

/*
Salary update
Those earning between 10k-19k increase by 5000
Those earning between 19001-24999 increase by 6000
Those earning between 25k-29999 increase by 7000
Those earning 30k and above increase by 8000
*/

UPDATE Staff SET [salary] = CASE 
								WHEN [Salary] BETWEEN 10000 AND 19000 THEN [Salary] + 5000
								WHEN [salary] BETWEEN 19001 AND 24999 THEN [Salary] + 6000
								WHEN [salary] BETWEEN 25000 AND 29999 THEN [salary] + 7000
								WHEN [Salary] >= 30000 THEN [salary] + 8000
								ELSE	0
							END
WHERE dept_ID = (select dept_id from Department where dept_name = 'Information Technology');