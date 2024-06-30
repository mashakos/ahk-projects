#Requires AutoHotkey v2.0
#SingleInstance force

SetWorkingDir "D:\DS4Windows"

{
    Run 'DS4Windows.exe -command LoadTempProfile.1.Playnite'
    Run 'DS4Windows.exe -command LoadProfile.1.Playnite'
    Run 'DS4Windows.exe -command LoadProfile.2.Playnite'
    Exit
}