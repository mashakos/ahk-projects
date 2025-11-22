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
RedAlert3hWidth := Number(A_screenWidth)
RedAlert3Height := Number(A_screenWidth * 0.5625)
RedAlert3X := Number(Floor( (A_screenWidth / 2) - (RedAlert3hWidth / 2) ))
RedAlert3Y := Number(Floor( (A_screenHeight / 2) - (RedAlert3Height / 2) ))

; Omit decimal point from axis position percentages.
Format("{:d}", RedAlert3X)  
Format("{:d}", RedAlert3Y)  
Format("{:d}", RedAlert3hWidth)  
Format("{:d}", RedAlert3Height)  

Run "RA3.exe -win"


WinWaitActive("ahk_exe ra3_1.12.game", , 60) 

MyGui := Gui()
MyGui.Opt("-Caption +ToolWindow")
MyGui.BackColor := "000000"
MyGui.Show("x0 y0 h" . A_ScreenHeight . " w" . A_ScreenWidth . " Center")

sleep 1000

global RedAlert3X := Number(Floor( (A_screenWidth / 2) - (RedAlert3hWidth / 2) ))
global RedAlert3Y := Number(Floor( (A_screenHeight / 2) - (RedAlert3Height / 2) ))


WinSetStyle -0xC40000, "ahk_exe ra3_1.12.game"
WinMove(RedAlert3X, RedAlert3Y,,, "ahk_exe ra3_1.12.game")
WinMove(RedAlert3X, RedAlert3Y, RedAlert3hWidth, RedAlert3Height, "ahk_exe ra3_1.12.game")

WinActivate("ahk_exe ra3_1.12.game")

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
ws_ID := WinExist("ahk_exe ra3_1.12.game")
DllCall("SetWindowPos","UInt",ws_ID,"Int",0,"Int",RedAlert3X,"Int",RedAlert3Y,"Int",RedAlert3hWidth,"Int",RedAlert3Height,"UInt",0x416)
WinActivate("ahk_exe ra3_1.12.game")



Loop
{


        ScreenCheck_Tick++

        if not WinExist("ahk_exe ra3_1.12.game")
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
            MMX := WinGetMinMax("ahk_exe ra3_1.12.game")
            if WinActive("ahk_exe ra3_1.12.game")
            {
                ScreenCheck_Tick := 0
            WinGetPos(&WinX, &WinY, &Width, &Height, "ahk_exe ra3_1.12.game")
                if( MMX != -1)
                {
                    if(Width != RedAlert3hWidth || Height != RedAlert3Height || WinX != RedAlert3X || WinY != RedAlert3Y) 
                    {
                        MyGui.Destroy()
                        MyGui := Gui()
                        MyGui.Opt("-Caption +ToolWindow")
                        MyGui.BackColor := "000000"
                        MyGui.Show("x0 y0 h" . A_ScreenHeight . " w" . A_ScreenWidth . " Center")
                        WinSetStyle -0xC40000, "ahk_exe ra3_1.12.game"
                        WinMove(RedAlert3X, RedAlert3Y,,, "ahk_exe ra3_1.12.game")
                        WinMove(RedAlert3X, RedAlert3Y, RedAlert3hWidth, RedAlert3Height, "ahk_exe ra3_1.12.game")
                        ws_ID := WinExist("ahk_exe ra3_1.12.game")
                        DllCall("SetWindowPos","UInt",ws_ID,"Int",0,"Int",RedAlert3X,"Int",RedAlert3Y,"Int",RedAlert3hWidth,"Int",RedAlert3Height,"UInt",0x416)
                    }
                }
            }

        }


        Sleep 100
}





