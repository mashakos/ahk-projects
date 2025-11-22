#Requires AutoHotkey v2.0
#NoTrayIcon
#SingleInstance Force
; Ensures a consistent starting directory.
SetWorkingDir A_ScriptDir

args := ""
if A_Args.Length > 0
{
    argc := A_Args.Length
    for n, param in A_Args
    {
        args .= "`"" . param . "`"" . " "
    }
}

full_command_line := DllCall("GetCommandLine", "str")

if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
{
    try
    {
        if A_IsCompiled
            Run '*RunAs "' A_ScriptFullPath '" /restart' . " " . args
        else
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"' . " " . args
    }
    ExitApp
}

ScreenCheck_Init := Number(0)
ScreenCheck_Tick := Number(0)
SegaRallyThreehWidth := Number(A_screenWidth)
SegaRallyThreeHeight := Number(A_screenWidth * 0.5625)
SegaRallyThreeX := Number(Floor( (A_screenWidth / 2) - (SegaRallyThreehWidth / 2) ))
SegaRallyThreeY := Number(Floor( (A_screenHeight / 2) - (SegaRallyThreeHeight / 2) ))

; Omit decimal point from axis position percentages.
Format("{:d}", SegaRallyThreeX)  
Format("{:d}", SegaRallyThreeY)  
Format("{:d}", SegaRallyThreehWidth)  
Format("{:d}", SegaRallyThreeHeight)  

Run "TeknoParrotUi.exe --profile=SR3.xml --startMinimized"

WinWaitActive("ahk_exe OpenParrotLoader.exe", , 32) 

MyGui := Gui()
MyGui.Opt("-Caption +ToolWindow")
MyGui.BackColor := "000000"
MyGui.Show("x0 y0 h" . A_ScreenHeight . " w" . A_ScreenWidth . " Center")

WinWaitActive("ahk_class RacingClass", , 32) 

sleep 1000

global SegaRallyThreeX := Number(Floor( (A_screenWidth / 2) - (SegaRallyThreehWidth / 2) ))
global SegaRallyThreeY := Number(Floor( (A_screenHeight / 2) - (SegaRallyThreeHeight / 2) ))


WinSetStyle -0xC40000, "ahk_class RacingClass"
WinMove(SegaRallyThreeX, SegaRallyThreeY,,, "ahk_class RacingClass")
WinMove(SegaRallyThreeX, SegaRallyThreeY, SegaRallyThreehWidth, SegaRallyThreeHeight, "ahk_class RacingClass")

sleep 1000

WinActivate("ahk_class RacingClass")

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
ws_ID := WinExist("ahk_class RacingClass")
DllCall("SetWindowPos","UInt",ws_ID,"Int",0,"Int",SegaRallyThreeX,"Int",SegaRallyThreeY,"Int",SegaRallyThreehWidth,"Int",SegaRallyThreeHeight,"UInt",0x416)



Loop
{


        ScreenCheck_Tick++

        if not WinExist("ahk_class RacingClass")
        {
            ExitApp
        }

        if( ScreenCheck_Init == 0)
        {
            ScreenCheck_Tick := 50
            ScreenCheck_Init := 1
        }
        if( ScreenCheck_Tick >= 50)
        {
            MMX := WinGetMinMax("ahk_class RacingClass")
            if WinActive("ahk_class RacingClass")
            {
                ScreenCheck_Tick := 0
            WinGetPos(&WinX, &WinY, &Width, &Height, "ahk_class RacingClass")
                if( MMX != -1)
                {
                    if(Width != SegaRallyThreehWidth || Height != SegaRallyThreeHeight || WinX != SegaRallyThreeX || WinY != SegaRallyThreeY) 
                    {
                        MyGui.Destroy()
                        MyGui := Gui()
                        MyGui.Opt("-Caption +ToolWindow")
                        MyGui.BackColor := "000000"
                        MyGui.Show("x0 y0 h" . A_ScreenHeight . " w" . A_ScreenWidth . " Center")
                        WinSetStyle -0xC40000, "ahk_class RacingClass"
                        WinMove(SegaRallyThreeX, SegaRallyThreeY,,, "ahk_class RacingClass")
                        WinMove(SegaRallyThreeX, SegaRallyThreeY, SegaRallyThreehWidth, SegaRallyThreeHeight, "ahk_class RacingClass")
                        ws_ID := WinExist("ahk_class RacingClass")
                        DllCall("SetWindowPos","UInt",ws_ID,"Int",0,"Int",SegaRallyThreeX,"Int",SegaRallyThreeY,"Int",SegaRallyThreehWidth,"Int",SegaRallyThreeHeight,"UInt",0x416)
                        #WinActivateForce
                        WinActivate("ahk_exe Rally.exe")
                    }
                }
            }

        }


        Sleep 100
}





