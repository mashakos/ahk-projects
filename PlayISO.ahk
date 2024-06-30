#NoEnv
#SingleInstance force 
#Persistent
#NoTrayIcon
#WinActivateForce
SetTitleMatchMode 2

SetWorkingDir %A_ScriptDir%

IniRead, Type, PlayISO.ini, Settings, DriveType, scsi, 0
IniRead, Letter, PlayISO.ini, Settings, DriveLetter, J:\
IniRead, Path, PlayISO.ini, Settings, DTPath, C:\Program Files\DAEMON Tools Lite\DTLite.exe
IniRead, PlayerPath, PlayISO.ini, Settings, TMTPath, C:\Program Files (x86)\ArcSoft\TotalMedia Theatre 6\uTotalMediaTheatre6.exe
unmount = "%Path%" -unmount %Type%
mount = "%Path%" -mount %Type%, "%1%"

;CHECKING FOR 1 PARAMS, IF NOT THEN EXIT
if 0 < 1
{
    MsgBox Usage: PlayISO.exe "[Imagepath]\[Imagefile]"
    ExitApp
}

;Blockinput on ; Keeps users from messing up loader my pressing buttons and moving mouse
;rom = "%1%" ; error level (rompath romfile) gives friendly name as ROM



   ; Gui +AlwaysOnTop -Caption +ToolWindow  ; No title, No taskbar icon
   ; Gui Color, 0                           ; Color Black
   ; Gui Show, x0 y0 h%A_ScreenHeight% w%A_ScreenWidth%, HSHIDE
   ; WinSet Transparent, 200, A             ; Can be semi-transparent
   ; MouseGetPos X, Y                       ; Remember pos to return
   ; MouseMove %A_ScreenWidth%,%A_ScreenHeight% ; Move pointer off screen


Run %unmount%
Sleep, 1000

Loop
{
IfExist, %Letter%*.*
	Sleep, 200

IfNotExist, %Letter%*.*
	break
}


Run %mount%
Sleep, 1000

Loop
{
IfNotExist, %Letter%*.*
	Sleep, 200

IfExist, %Letter%*.*
	break
}

RunWait "%PlayerPath%" %Letter%
Run %unmount%
ExitApp


;Gui Destroy                            ; Remove blinds from desktop


;Blockinput off ; Allows user to send inputs so games can be played
Return
