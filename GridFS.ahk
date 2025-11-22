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
GRIDWidth := Number(A_screenWidth)
GRIDeight := Number(A_screenWidth * 0.5625)
GRIDX := Number(Floor( (A_screenWidth / 2) - (GRIDWidth / 2) ))
GRIDY := Number(Floor( (A_screenHeight / 2) - (GRIDeight / 2) ))

; Omit decimal point from axis position percentages.
Format("{:d}", GRIDX)  
Format("{:d}", GRIDY)  
Format("{:d}", GRIDWidth)  
Format("{:d}", GRIDeight)  

Run "TeknoParrotUi.exe --profile=GRID.xml --startMinimized"

WinWaitActive("ahk_class ConsoleWindowClass", , 32) 

MyGui := Gui()
MyGui.Opt("-Caption +ToolWindow")
MyGui.BackColor := "000000"
MyGui.Show("x0 y0 h" . A_ScreenHeight . " w" . A_ScreenWidth . " Center")

WinWaitActive("ahk_class NeonClass_41", , 32) 

sleep 1000

global GRIDX := Number(Floor( (A_screenWidth / 2) - (GRIDWidth / 2) ))
global GRIDY := Number(Floor( (A_screenHeight / 2) - (GRIDeight / 2) ))


WinSetStyle -0xC40000, "ahk_class NeonClass_41"
WinMove(GRIDX, GRIDY,,, "ahk_class NeonClass_41")
WinMove(GRIDX, GRIDY, GRIDWidth, GRIDeight, "ahk_class NeonClass_41")

sleep 1000

WinActivate("ahk_class NeonClass_41")

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
ws_ID := WinExist("ahk_class NeonClass_41")
DllCall("SetWindowPos","UInt",ws_ID,"Int",0,"Int",GRIDX,"Int",GRIDY,"Int",GRIDWidth,"Int",GRIDeight,"UInt",0x416)



Loop
{


        ScreenCheck_Tick++

        if not WinExist("ahk_class NeonClass_41")
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
            MMX := WinGetMinMax("ahk_class NeonClass_41")
            if WinActive("ahk_class NeonClass_41")
            {
                ScreenCheck_Tick := 0
            WinGetPos(&WinX, &WinY, &Width, &Height, "ahk_class NeonClass_41")
                if( MMX != -1)
                {
                    if(Width != GRIDWidth || Height != GRIDeight || WinX != GRIDX || WinY != GRIDY) 
                    {
                        MyGui.Destroy()
                        MyGui := Gui()
                        MyGui.Opt("-Caption +ToolWindow")
                        MyGui.BackColor := "000000"
                        MyGui.Show("x0 y0 h" . A_ScreenHeight . " w" . A_ScreenWidth . " Center")
                        WinSetStyle -0xC40000, "ahk_class NeonClass_41"
                        WinMove(GRIDX, GRIDY,,, "ahk_class NeonClass_41")
                        WinMove(GRIDX, GRIDY, GRIDWidth, GRIDeight, "ahk_class NeonClass_41")
                        ws_ID := WinExist("ahk_class NeonClass_41")
                        DllCall("SetWindowPos","UInt",ws_ID,"Int",0,"Int",GRIDX,"Int",GRIDY,"Int",GRIDWidth,"Int",GRIDeight,"UInt",0x416)
                        #WinActivateForce
                        WinActivate("ahk_exe BudgieLoader.exe")
                    }
                }
            }

        }


        Sleep 100
}





