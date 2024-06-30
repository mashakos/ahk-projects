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
NiohWidth := 2560
NiohHeight := 1440
NioX := Floor( (A_screenWidth / 2) - (NiohWidth / 2) )
NioY := Floor( (A_screenHeight / 2) - (NiohHeight / 2) )

Run nioh.exe

WinWaitActive, ahk_class NIOH, , 2

sleep, 1500
Gui -Caption +ToolWindow
Gui Color, 0
Gui Show, x0 y0 h%A_ScreenHeight% w%A_ScreenWidth% Center

WinActivate, ahk_class NIOH

WinGetPos, , , NiohWidth, NiohHeight, ahk_class NIOH

global NioX = Floor( (A_screenWidth / 2) - (NiohWidth / 2) )
global NioY = Floor( (A_screenHeight / 2) - (NiohHeight / 2) )

WinSet, Style, -0xC40000, ahk_class NIOH
WinMove, ahk_class NIOH,, NioX, NioY
WinMove, ahk_class NIOH,, NioX, NioY, NiohWidth, NiohHeight

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
ws_ID := WinExist("ahk_class NIOH")
DllCall("SetWindowPos",UInt,ws_ID,Int,0,Int,NioX,Int,NioY,Int,NiohWidth,Int,NiohHeight,UInt,0x416)

SetFormat, float, 03  ; Omit decimal point from axis position percentages.

Loop
{


        ScreenCheck_Tick ++

        IfWinNotExist, ahk_class NIOH
        {
            ExitApp
        }

        if( ScreenCheck_Init == 0)
        {
            ScreenCheck_Tick = 2000
            ScreenCheck_Init = 1
        }
        if( ScreenCheck_Tick >= 2000)
        WinGet MMX, MinMax, ahk_class NIOH
        IfWinActive, ahk_class NIOH
        {
            ScreenCheck_Tick = 0;
        WinGetPos, WinX, WinY, Width, Height, ahk_class NIOH
            if( MMX != -1)
            {
                if(Width != NiohWidth || Height != NiohHeight || WinX != 0 || WinY != 0) 
                {
                    WinSet, Style, -0xC40000, ahk_class NIOH
                    WinMove, ahk_class NIOH,, NioX, NioY
                    WinMove, ahk_class NIOH,, NioX, NioY, NiohWidth, NiohHeight
                    ws_ID := WinExist("ahk_class NIOH")
                    DllCall("SetWindowPos",UInt,ws_ID,Int,0,Int,NioX,Int,NioY,Int,NiohWidth,Int,NiohHeight,UInt,0x416)
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




