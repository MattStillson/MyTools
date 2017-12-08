# Service Watcher and forces it to turn back on and logs the error.

action={
 $previous = $Event.SourceEventArgs.NewEvent.PreviousInstance
 $target = $Event.SourceEventArgs.NewEvent.TargetInstance
 if ($previous.state -ne $target.state) {
  #log the change
  $msg="{0} Service: {1} has changed state from {2} to {3}" -f (Get-Date),$Target.Name,$Previous.State,$Target.State
  Write $msg | Out-File -filepath "c:work\ServiceLog.txt" -append
 }
}

$action = {
 $previous = $Event.SourceEventArgs.NewEvent.PreviousInstance
 $target = $Event.SourceEventArgs.NewEvent.TargetInstance
 if ($previous.state -ne $target.state) {
    $wshell = new-object -COM "Wscript.Shell"
    $msg="{0} Service: {1} has changed state from {2} to {3}" -f (Get-Date),$Target.Name,$Previous.State,$Target.State
    #display a message box for 15 seconds. Use -1 to force user to click OK.
    $wshell.Popup($msg,15,"Service Alert",64) | Out-Null
 }
}
Register-WMIEvent -Query $query -sourceIdentifier "ServiceAlert" -Action $action -computername $ENV:COMPUTERNAME