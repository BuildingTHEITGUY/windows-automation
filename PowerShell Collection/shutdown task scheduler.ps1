@echo off

rem Set the time to 10:00 PM
set shutdownTime=22:00

rem Create a temporary VBScript file to set up Task Scheduler
echo Set objShell = WScript.CreateObject("Schedule.Service") > TempTask.vbs
echo objShell.Connect >> TempTask.vbs
echo Set rootFolder = objShell.GetFolder("\"") >> TempTask.vbs
echo Set taskDef = objShell.NewTask(0) >> TempTask.vbs
echo taskDef.RegistrationInfo.Description = "Shutdown at 10:00 PM" >> TempTask.vbs
echo taskDef.Principal.UserId = "NT AUTHORITY\SYSTEM" >> TempTask.vbs
echo taskDef.Principal.LogonType = 3 >> TempTask.vbs
echo Set execAction = taskDef.Actions.Create(1,"shutdown", "/s /t 1 /c ""Scheduled shutdown at 10:00 PM""") >> TempTask.vbs
echo execAction.Id = "ShutdownAction" >> TempTask.vbs
echo execAction.WorkingDirectory = "C:\" >> TempTask.vbs
echo Set trigger = taskDef.Triggers.Create(1) >> TempTask.vbs
echo trigger.StartBoundary = "2024-01-01T%shutdownTime%" >> TempTask.vbs
echo trigger.EndBoundary = "2024-12-31T%shutdownTime%" >> TempTask.vbs
echo trigger.ExecutionTimeLimit = "PT5M" >> TempTask.vbs
echo trigger.Id = "DailyTriggerId" >> TempTask.vbs
echo trigger.Repetition.Duration = "PT24H" >> TempTask.vbs
echo trigger.Repetition.Interval = "PT24H" >> TempTask.vbs
echo rootFolder.RegisterTaskDefinition "ShutdownTask", taskDef, 6, , , 3 >> TempTask.vbs

rem Run the temporary VBScript file to create the Task Scheduler job
cscript //nologo TempTask.vbs

rem Clean up the temporary VBScript file
del TempTask.vbs

echo Task and shutdown scheduled successfully!

