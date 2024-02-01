$Action = ShutdownAction -Execute "shutdown" -Argument "/s /f"
$Trigger = ShutdownTrigger -Daily -At 10pm
Register-ScheduledTask -Action $Action -Trigger $Trigger -TaskName "ShutdownTask" -Description "Enegry Saving shutdown at 10 PM"
