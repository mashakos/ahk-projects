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
TheQuarryhWidth := 2560
TheQuarryhHeight := 1440
TheQuarryX := Floor( (A_screenWidth / 2) - (TheQuarryhWidth / 2) )
TheQuarryY := Floor( (A_screenHeight / 2) - (TheQuarryhHeight / 2) )

Run steamclient_loader.exe

WinWaitActive, ahk_class UnrealWindow, , 2

sleep, 1500
Gui -Caption +ToolWindow
Gui Color, 0
Gui Show, x0 y0 h%A_ScreenHeight% w%A_ScreenWidth% Center

WinActivate, ahk_class UnrealWindow

;WinGetPos, , , TheQuarryhWidth, TheQuarryhHeight, ahk_class UnrealWindow

global TheQuarryX = Floor( (A_screenWidth / 2) - (TheQuarryhWidth / 2) )
global TheQuarryY = Floor( (A_screenHeight / 2) - (TheQuarryhHeight / 2) )

WinSet, Style, -0xC40000, ahk_class UnrealWindow
WinMove, ahk_class UnrealWindow,, TheQuarryX, TheQuarryY
WinMove, ahk_class UnrealWindow,, TheQuarryX, TheQuarryY, TheQuarryhWidth, TheQuarryhHeight
ws_ID := WinExist("ahk_class UnrealWindow")
DllCall("SetWindowPos",UInt,ws_ID,Int,0,Int,TheQuarryX,Int,TheQuarryY,Int,TheQuarryhWidth,Int,TheQuarryhHeight,UInt,0x416)

; Use "SetWindowPos" to override stubborn windows who insist on a
; minimum size
; (in Win7, these include: explorer.exe, iexplore.exe, cmd.exe)
;
; args = hWnd,hWndAfter,x,y,cy,cy,flags
; 0x416 =
; 0x002 = SWP_NOMOVE ignore x,y
; 0x004 = SWP_NOZORDER
; 0x010 = SWP_NOACTIVE
; 0x400 = SWP_NOSENDCHANGING don't tell window
ws_ID := WinExist("ahk_class UnrealWindow")
DllCall("SetWindowPos",UInt,ws_ID,Int,0,Int,TheQuarryX,Int,TheQuarryY,Int,TheQuarryhWidth,Int,TheQuarryhHeight,UInt,0x416)

SetFormat, float, 03  ; Omit decimal point from axis position percentages.

Loop
{


        ScreenCheck_Tick ++

        IfWinNotExist, ahk_class UnrealWindow
        {
            ExitApp
        }

        if( ScreenCheck_Init == 0)
        {
            ScreenCheck_Tick = 2000
            ScreenCheck_Init = 1
        }
        if( ScreenCheck_Tick >= 2000)
        WinGet MMX, MinMax, ahk_class UnrealWindow
        IfWinActive, ahk_class UnrealWindow
        {
            ScreenCheck_Tick = 0;
        WinGetPos, WinX, WinY, Width, Height, ahk_class UnrealWindow
            if( MMX != -1)
            {
                if(Width != TheQuarryhWidth || Height != TheQuarryhHeight || WinX != 0 || WinY != 0)
                {
                    WinSet, Style, -0xC40000, ahk_class UnrealWindow
                    WinMove, ahk_class UnrealWindow,, TheQuarryX, TheQuarryY
                    WinMove, ahk_class UnrealWindow,, TheQuarryX, TheQuarryY, TheQuarryhWidth, TheQuarryhHeight
                    ws_ID := WinExist("ahk_class UnrealWindow")
                    DllCall("SetWindowPos",UInt,ws_ID,Int,0,Int,TheQuarryX,Int,TheQuarryY,Int,TheQuarryhWidth,Int,TheQuarryhHeight,UInt,0x416)
                }
            }
        }


        Sleep, 100
}


IsFullscreen() {
    stop=0
    WinGet, IEControlList, ControlList, ahk_class eHome Render Window
    Loop, Parse,IEControlList, `n
    {
        if (A_LoopField = "eHome FlipEx Host Window1")
        {
            Return False
            stop=1
        }

    }
    if(stop = 0)
        Return True
}




