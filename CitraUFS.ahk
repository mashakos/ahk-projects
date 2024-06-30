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
CitraUWidth := 2560
CitraUHeight := 1440
CitraUX := 0 ;Floor( (A_screenWidth / 2) - (CitraUWidth / 2) )
CitraUY := -26 ;Floor( (A_screenHeight / 2) - (CitraUHeight / 2) )

If 0 < 1
{
    Run citra-qt.exe
}
Else
{
    Run citra-qt.exe "%1%"
}

WinWaitActive, Citra |, , 2

; sleep, 500
; Gui -Caption +ToolWindow
; Gui Color, 0
; Gui Show, x0 y0 h%A_ScreenHeight% w%A_ScreenWidth% Center

; WinActivate, Citra |

WinGetPos, , , CitraUWidth, CitraUHeight, Citra |

global CitraUWidth = CitraUWidth - 6
global CitraUHeight = CitraUHeight + 26
;global CitraUX = Floor( (A_screenWidth / 2) - (CitraUWidth / 2) )
;global CitraUY = Floor( (A_screenHeight / 2) - (CitraUHeight / 2) )

WinSet, Style, -0xC40000, Citra |
WinMove, Citra |,, CitraUX, CitraUY
WinMove, Citra |,, CitraUX, CitraUY, CitraUWidth, CitraUHeight

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
ws_ID := WinExist("Citra |")
DllCall("SetWindowPos",UInt,ws_ID,Int,0,Int,CitraUX,Int,CitraUY,Int,CitraUWidth,Int,CitraUHeight,UInt,0x416)

SetFormat, float, 03  ; Omit decimal point from axis position percentages.

Loop
{


        ScreenCheck_Tick ++

        IfWinNotExist, Citra
        {
            ExitApp
        }

        if( ScreenCheck_Init == 0)
        {
            ScreenCheck_Tick = 2000
            ScreenCheck_Init = 1
        }
        if( ScreenCheck_Tick >= 2000)
        WinGet MMX, MinMax, Citra |
        IfWinActive, Citra |
        {
            ScreenCheck_Tick = 0;
        WinGetPos, WinX, WinY, Width, Height, Citra |
            if( MMX != -1)
            {
                if(Width != CitraUWidth || Height != CitraUHeight || WinX != 0 || WinY != 0) 
                {
                    WinSet, Style, -0xC40000, Citra |
                    WinMove, Citra |,, CitraUX, CitraUY
                    WinMove, Citra |,, CitraUX, CitraUY, CitraUWidth, CitraUHeight
                    ws_ID := WinExist("Citra |")
                    DllCall("SetWindowPos",UInt,ws_ID,Int,0,Int,CitraUX,Int,CitraUY,Int,CitraUWidth,Int,CitraUHeight,UInt,0x416)
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




