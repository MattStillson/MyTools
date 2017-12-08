function checkFilestatus {
    Param($k)
    try {
        [IO.File]::OpenRead($k).Close()
        Copy-Item -Path "$k\" -Destination "\\ServerName\D$\Temp\MyFolder" -Recurse -Force
    } catch {
        Start-Sleep -Seconds 120
        Copy-Item -Path "$k\" -Destination "\\ServerName\D$\Temp\MyFolder" -Recurse -Force
    }
}
$filewatcher = New-Object System.IO.FileSystemWatcher
$filewatcher.Path = "D:\MyFolder\Folder2"
$filewatcher.IncludeSubdirectories = $true
$filewatcher.EnableRaisingEvents = $true

Register-ObjectEvent $filewatcher "Created" -SourceIdentifier FileCreated -Action { checkFilestatus($($EventArgs.FullPath)) }
Register-ObjectEvent $filewatcher "Changed" -SourceIdentifier FileChanged -Action { checkFilestatus($($EventArgs.FullPath)) }