
$ServerName = "ServerName"
$SQLDBName = "test"
$UserID = "sa"
$Password = "88888888"
$SqlConnection = New-Object System.Data.SqlClient.SqlConnection
$SqlConnection.ConnectionString = "Server = $ServerName; Database = $SQLDBName; User ID= $UserID; Password= $Password"
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.CommandText = "
IF NOT EXISTS(SELECT 1 FROM sys.objects WHERE object_id = OBJECT_ID('dbo.SystemPerforman'))
BEGIN
	CREATE TABLE [dbo].[SystemPerforman]
	(
		[Id] INT Identity NOT NULL PRIMARY KEY,
		[Timestamp] DATETIME NOT NULL,
		[ServerName] NVARCHAR(100) NOT NULL,
		[ProcessorTime(%)] DECIMAL(8, 2) NOT NULL,
		[ProcessorPTime(%)] DECIMAL(8, 2) NOT NULL,
		[ProcessorUTime(%)] DECIMAL(8, 2) NOT NULL,
		[ProcessorQueueLength] INT NOT NULL,
		[AvailableMBytes(MB)] INT NOT NULL,
		[PageFaults] INT NOT NULL,
		[DiskIdleTime(%)] DECIMAL(8, 2) NOT NULL,
		[DiskReadsSec] INT NOT NULL,
		[DiskWritesSec] INT NOT NULL,
		[AvgDiskReadQuenLength] INT NOT NULL,
		[AvgDiskWriteQuenLength] INT NOT NULL,
		[Transactions] INT NULL,
		[LockAvgWaitTime(ms)] INT NULL,
		[BatchRequests] INT NULL,
		[PhysicalReadsSec] INT NULL
	)
END "
$SqlCmd.Connection = $SqlConnection
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet) | Out-Null

$Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

$ProcessorTime = (Get-Counter -Counter "\Processor(_total)\% Processor Time").CounterSamples | Select -ExpandProperty CookedValue
$ProcessorPTime = (Get-Counter -Counter "\Processor(_total)\% Privileged Time").CounterSamples | Select -ExpandProperty CookedValue
$ProcessorUTime = (Get-Counter -Counter "\Processor(_total)\% User Time").CounterSamples | Select -ExpandProperty CookedValue
[int]$ProcessorQueueLength = (Get-Counter -Counter "\System\Processor Queue Length").CounterSamples | Select -ExpandProperty CookedValue
$AvailableMBytes = (Get-Counter -Counter "\Memory\Available MBytes").CounterSamples | Select -ExpandProperty CookedValue
[int]$PageFaults = (Get-Counter -Counter "\Memory\Page Faults/sec").CounterSamples | Select -ExpandProperty CookedValue
$DiskIdleTime = (Get-Counter -Counter "\PhysicalDisk(_total)\% Idle Time").CounterSamples | Select -ExpandProperty CookedValue
[int]$DiskReadsSec = (Get-Counter -Counter "\PhysicalDisk(_total)\Disk Reads/sec" ).CounterSamples | Select -ExpandProperty CookedValue
[int]$DiskWritesSec = (Get-Counter -Counter "\PhysicalDisk(_total)\Disk Writes/sec"  ).CounterSamples | Select -ExpandProperty CookedValue
[int]$AvgDiskReadQuenLength = (Get-Counter -Counter "\PhysicalDisk(_total)\Avg. Disk Read Queue Length").CounterSamples | Select -ExpandProperty CookedValue
[int]$AvgDiskWriteQuenLength = (Get-Counter -Counter "\PhysicalDisk(_total)\Avg. Disk Write Queue Length").CounterSamples | Select -ExpandProperty CookedValue
[int]$Transactions = (Get-Counter -Counter "\SQLServer:Transactions\Transactions").CounterSamples | Select -ExpandProperty CookedValue
[int]$LockAvgWaitTime = (Get-Counter -Counter "\SQLServer:Locks(_total)\Average Wait Time (ms)").CounterSamples | Select -ExpandProperty CookedValue
[int]$BatchRequests = (Get-Counter -Counter "\SQLServer:SQL Statistics\Batch Requests/sec").CounterSamples | Select -ExpandProperty CookedValue
[int]$PhysicalReadsSec = (Get-Counter -Counter "\SQLServer:Buffer Manager\Page reads/sec").CounterSamples | Select -ExpandProperty CookedValue

$ProcessorTime = [math]::round($ProcessorTime,2)
$ProcessorPTime = [math]::round($ProcessorPTime,2)
$ProcessorUTime = [math]::round($ProcessorUTime,2)
$DiskIdleTime = [math]::round($DiskIdleTime,2)

$SqlCmd.CommandText = "
INSERT INTO dbo.SystemPerforman VALUES('$Timestamp','$ServerName','$ProcessorTime','$ProcessorPTime',
'$ProcessorUTime','$ProcessorQueueLength','$AvailableMBytes','$PageFaults','$DiskIdleTime','$DiskReadsSec',
'$DiskWritesSec','$AvgDiskReadQuenLength','$AvgDiskWriteQuenLength','$Transactions','$LockAvgWaitTime',
'$BatchRequests','$PhysicalReadsSec')"

$SqlAdapter.Fill($DataSet) | Out-Null
$SqlConnection.Close()