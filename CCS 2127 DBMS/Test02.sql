/*
Multi
line
comment
*/

-- Single line comment

/*
Database - Test02
Department (Dept_id (pk), dept_name)
Staff (stf_id (pk), stf_lname, stf_onames, stf_addr, stf_town, Dept_ID (fk))
*/

--CREATE <Object_type> <Object_name> <Object_deinition>

--select @@version

-- CReating the Database
IF(db_id('Test02') IS NULL)
	CREATE DATABASE Test02;
GO

--Open the Database to enable us to create the Objects (tables)
USE Test02;
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
		CONSTRAINT PK_STAFF PRIMARY KEY(stf_id),
		CONSTRAINT FK_STAFF_DEPT FOREIGN KEY(dept_id)
					REFERENCES Department(dept_id)
	)
GO

--Load Data (Department)
INSERT INTO Department(dept_name)
VALUES ('Human Resources'),('Finance'),('Information Technology'),('Procurement');

--Load Data (staff)
INSERT INTO Staff(stf_lname,stf_onames,stf_addr,stf_town,dept_ID)
VALUES('Otieno','Victor','345, Kisumu','Kisumu',1000),
('Wanjiru','Anne','113, Mombasa','Voi',1001),
('Mohamed','Abdi','245, Garissa','Garissa',1003),
('Wafula','Moses','34567, Kitale','Bungoma',1002),
('Mutai','Arnold','7863, Matuu','Machakos',1000);

--drop table if exists staff;
--truncate table staff
select * from staff
select stf_id,stf_lname,stf_town from staff
select * from staff where stf_town = 'Kisumu' OR stf_town = 'Bungoma'
select * from staff where stf_town IN ('Kisumu','Bungoma')

select * from staff
select stf_id,stf_lname,stf_town from staff
where stf_town IN ('Kisumu','Bungoma')

