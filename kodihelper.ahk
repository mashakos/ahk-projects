#Requires AutoHotkey v2.0
#SingleInstance force

SetWorkingDir "D:\DS4Windows"

NewPID := ProcessWait("kodi.exe")
WaitPID := ProcessWaitClose(NewPID)
if not WaitPID
{
    Run 'DS4Windows.exe -command LoadTempProfile.1.HTPC'
    Run 'DS4Windows.exe -command LoadProfile.1.HTPC'
    Run 'DS4Windows.exe -command LoadTempProfile.2.HTPC'
    Run 'DS4Windows.exe -command LoadProfile.2.HTPC'
    Exit
}