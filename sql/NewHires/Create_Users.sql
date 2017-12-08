DECLARE @Today AS DATE
SET @Today = GETDATE()
USE TesterDB
GO

BULK INSERT new_employees
FROM 'C:\Scripts\CSV\NewHires.csv'
WITH (
  FORMAT = 'CSV'
);