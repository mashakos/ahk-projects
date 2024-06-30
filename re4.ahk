#Requires AutoHotkey v2.0
#SingleInstance force

SetWorkingDir A_ScriptDir

Run 're4.exe'

NewPID := ProcessWait("re4.exe")
WaitPID := ProcessWaitClose(NewPID)
if not WaitPID
{
    Exit
}