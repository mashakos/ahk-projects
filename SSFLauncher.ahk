; <COMPILER: v1.1.05.04>
#NoEnv
#SingleInstance force
#Persistent
#NoTrayIcon
#WinActivateForce
OnExit, ExitLauncher
SetTitleMatchMode 2
IniRead, Type, SSFLauncher.ini, Settings, DriveType, scsi, 0
IniRead, Letter, SSFLauncher.ini, Settings, DriveLetter, V:\
IniRead, Path, SSFLauncher.ini, Settings, DTPath, C:\Program Files\DAEMON Tools Lite\DTLite.exe
unmount = "%Path%" -unmount %Type%
mount = ""%Path%" -mount %Type%, "%1%""
if 0 < 1
{
MsgBox Usage: SSFLauncher.exe "[Imagepath]\[Imagefile]"
ExitApp
}
Blockinput on
loadingtextWidth := A_ScreenWidth
loadingtextLeft := (A_ScreenWidth / 2) - ( loadingtextWidth / 2)
loadingtextTop := (A_ScreenHeight / 2)
Gui +AlwaysOnTop -Caption +ToolWindow
Gui Color, 0
Gui Show, x0 y0 h%A_ScreenHeight% w%A_ScreenWidth% Center, HSHIDE
WinSet Transparent, 200, A
Gui, Font, S38 CWhite Wbold, Calibri
Gui, Add, Text, w%loadingtextWidth% x%loadingtextLeft% y%loadingtextTop% Center, MOUNTING DISC IMAGE... PLEASE WAIT
MouseGetPos X, Y
MouseMove %A_ScreenWidth%,%A_ScreenHeight%
Run %comspec% /c %unmount%, , Hide
Sleep, 1000
Loop
{
IfExist, %Letter%*.*
Sleep, 200
IfNotExist, %Letter%*.*
break
}
Run %comspec% /c %mount%, , Hide
Sleep, 1000
Loop
{
IfNotExist, %Letter%*.*
Sleep, 200
IfExist, %Letter%*.*
break
}
Run, SSF.exe
Gui Destroy
Blockinput off
WinWaitActive, SSF, , 2
WinWaitClose, ahk_exe SSF.exe
{
Run %comspec% /c %unmount%, , Hide
; Sleep, 1000
; Loop
; {
; IfExist, %Letter%*.*
; Sleep, 200
; IfNotExist, %Letter%*.*
; break
; }
ExitApp
}

ExitLauncher:
Run %comspec% /c %unmount%, , Hide
ExitApp