USE MASTER;
GO

IF EXISTS (SELECT [name] FROM sys.databases WHERE [name] = 'TesterDB' )
DROP DATABASE TesterDB
GO

USE TesterDB
GO

IF EXISTS (SELECT [name] FROM sys.tables WHERE [name] = 'new_employees' )
DROP TABLE new_employees
GO

CREATE TABLE new_employees (
	Ticket VARCHAR(10) PRIMARY KEY,
	Agent_Type VARCHAR(10),
	Hire_Type VARCHAR(10),
	Template VARCHAR(10),
	Path VARCHAR(10),
	StartDate VARCHAR(10),
	Username VARCHAR(10),
	FirstName VARCHAR(10),
  LastName VARCHAR(10),
	Display_Name VARCHAR(10),
	Extension VARCHAR(10),
	Telephone VARCHAR(10),
	Password VARCHAR(10),
	Title VARCHAR(10),
	Department VARCHAR(10),
	E_mail VARCHAR(10),
	City VARCHAR(10),
	State VARCHAR(10),
	Campus VARCHAR(10),
	I3_Alias VARCHAR(10),
	SYStaff_ID VARCHAR(10),
	Network_ID VARCHAR(10),
	MailBox_Roles VARCHAR(10),
	Workgroups VARCHAR(10)
)
GO
