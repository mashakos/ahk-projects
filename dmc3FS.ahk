; <COMPILER: v1.1.05.04>
#NoTrayIcon
#Persistent
#SingleInstance Force
DetectHiddenWindows, ON
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"  ; Requires v1.0.92.01+
   ExitApp
}

ScreenCheck_Init := 0
ScreenCheck_Tick := 0
dmcWidth := 2560
dmcHeight := 1440
dmcX := Floor( (A_screenWidth / 2) - (dmcWidth / 2) )
dmcY := Floor( (A_screenHeight / 2) - (dmcHeight / 2) )

Run dmc3.exe

WinWaitActive, ahk_class Devil May Cry 3, , 2

sleep, 1500
Gui -Caption +ToolWindow
Gui Color, 0
Gui Show, x0 y0 h%A_ScreenHeight% w%A_ScreenWidth% Center

WinActivate, ahk_class Devil May Cry 3

WinGetPos, , , dmcWidth, dmcHeight, ahk_class Devil May Cry 3

global dmcX = Floor( (A_screenWidth / 2) - (dmcWidth / 2) )
global dmcY = Floor( (A_screenHeight / 2) - (dmcHeight / 2) )

WinMove, ahk_class Devil May Cry 3,, dmcX, dmcY
WinMove, ahk_class Devil May Cry 3,, dmcX, dmcY, dmcWidth, dmcHeight

SetFormat, float, 03  ; Omit decimal point from axis position percentages.

WinWaitActive, ahk_class Devil May Cry 3, , 2
WinWaitClose
ExitApp