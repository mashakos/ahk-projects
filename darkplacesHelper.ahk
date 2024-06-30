#Requires AutoHotkey v2.0
#SingleInstance force

SetWorkingDir A_InitialWorkingDir

args := ""
if A_Args.Length > 0
{
    argc := A_Args.Length
    for n, param in A_Args
    {
        args .= "`"" . param . "`"" . " "
    }
}

full_command_line := DllCall("GetCommandLine", "str")

if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run '*RunAs "' A_ScriptFullPath '" /restart' . " " . args
        else
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"' . " " . args
    }
    ExitApp
}

; MsgBox "this" . args

SetWorkingDir "D:\DS4Windows"
Run 'DS4Windows.exe -command LoadTempProfile.1.M+KB'
Run 'DS4Windows.exe -command LoadProfile.1.M+KB'
Run 'DS4Windows.exe -command LoadTempProfile.2.M+KB'
Run 'DS4Windows.exe -command LoadProfile.2.M+KB'

SetWorkingDir A_InitialWorkingDir
Run "darkplaces.exe " . args

NewPID := ProcessWait("darkplaces.exe")
WaitPID := ProcessWaitClose(NewPID)
if not WaitPID
{
    SetWorkingDir "D:\DS4Windows"
    Run 'DS4Windows.exe -command LoadTempProfile.1.playnite'
    Run 'DS4Windows.exe -command LoadProfile.1.playnite'
    Run 'DS4Windows.exe -command LoadTempProfile.2.playnite'
    Run 'DS4Windows.exe -command LoadProfile.2.playnite'
    Exit
}