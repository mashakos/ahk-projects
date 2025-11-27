#Requires AutoHotkey v2.0
#SingleInstance force

; Simple ahk script for Kodi to launch Playnite fullscreen. Meant to be used as a System.Exec shortcut in Kodi. Example:
; System.Exec(D:\\Programs\\Kodi\\playniteCommand.exe)
; Creates a solid black background to hide the desktop while playnite loads
; Notes
; There is a code block below which is meant to be a workaround for DS4Windows, in case you have a specific kodi gamepad profile (DS4Windows can't switch out of the kodi profile when Kodi is minimised). You can delete it if you don't use DS4Windows. 
; Directory locations are hardcoded so change accordingly in lines 9, 25


if WinExist("ahk_exe DS4Windows.exe")
{
	SetWorkingDir "D:\DS4Windows"
    Run 'DS4Windows.exe -command LoadTempProfile.1.Playnite'
    Run 'DS4Windows.exe -command LoadProfile.1.Playnite'
    Run 'DS4Windows.exe -command LoadProfile.2.Playnite'
}

; Ensures a consistent starting directory.
SetWorkingDir A_ScriptDir

myGui := Gui()
myGui.Opt("-Caption +ToolWindow")
myGui.BackColor := 0
myGui.Show("x0 y0 h" . A_ScreenHeight . " w" . A_ScreenWidth . " Center")

executablePath := 'D:\Playnite\Playnite.FullscreenApp.exe --hidesplashscreen'

RunWait executablePath

ExitApp