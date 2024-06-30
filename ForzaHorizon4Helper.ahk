#Requires AutoHotkey v2.0
#SingleInstance force

SetWorkingDir A_InitialWorkingDir

full_command_line := DllCall("GetCommandLine", "str")

if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run '*RunAs "' A_ScriptFullPath '" /restart'
        else
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
    }
    ExitApp
}

killScript := "
(
net stop "Winmgmt" /yes
Set-Service -Name "Winmgmt" -Status stopped -StartupType disabled
)"
startScript := "
(
net start "Winmgmt"
Set-Service -Name "Winmgmt" -StartupType automatic
net start "iphlpsvc"
net start "jhi_service"
)"


RunWait 'PowerShell.exe -windowstyle hidden -ExecutionPolicy Bypass -Command &{' killScript '}'
Run "ForzaHorizon4.exe"

NewPID := ProcessWait("ForzaHorizon4.exe")
WaitPID := ProcessWaitClose(NewPID)
if not WaitPID
{
	RunWait 'PowerShell.exe -windowstyle hidden -ExecutionPolicy Bypass -Command &{' startScript '}'
    Exit
}