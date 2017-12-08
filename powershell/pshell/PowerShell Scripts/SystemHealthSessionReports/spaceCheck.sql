DECLARE @svrName VARCHAR(255)
DECLARE @sql varchar(400)
--by default it will take the current server name, we can the set the server name as well
SET @svrName = @@SERVERNAME
SET @sql = 'powershell.exe -c "Get-WmiObject -ComputerName ' + QUOTENAME(@svrName,'''') + ' -Class Win32_Volume -Filter ''DriveType = 3'' | select name,capacity,freespace | foreach{$_.name+''|''+$_.capacity/1048576+''%''+$_.freespace/1048576+''*''}"'
--creating a temporary table
CREATE TABLE #output (line varchar(255))
--inserting disk name, total space and free space value in to temporary table
INSERT #output EXEC xp_cmdshell @sql
--script to retrieve the values in GB from PS Script output
SELECT rtrim(ltrim(SUBSTRING(line,1,CHARINDEX('|',line) -1))) as drivename
      ,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('|',line)+1,(CHARINDEX('%',line) -1)-CHARINDEX('|',line)) ))as Float)/1024,0) as 'capacity(GB)'
      ,round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('%',line)+1,(CHARINDEX('*',line) -1)-CHARINDEX('%',line)) ))as Float) /1024 ,0)as 'freespace(GB)'
      ,cast(round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('|',line)+1,(CHARINDEX('%',line) -1)-CHARINDEX('|',line)) )) as Float)/1024,0) /
      round(cast(rtrim(ltrim(SUBSTRING(line,CHARINDEX('%',line)+1,(CHARINDEX('*',line) -1)-CHARINDEX('%',line)) )) as Float) /1024 ,0) as decimal(5,2)) as '%Free'
FROM #output
WHERE line like '[A-Z][:]%'
ORDER by drivename
--script to drop the temporary table
DROP TABLE #output