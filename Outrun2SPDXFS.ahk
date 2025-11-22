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
Outrun2SPDXhWidth := Number(A_screenWidth)
Outrun2SPDXHeight := Number(A_screenWidth * 0.5625)
Outrun2SPDXX := Number(Floor( (A_screenWidth / 2) - (Outrun2SPDXhWidth / 2) ))
Outrun2SPDXY := Number(Floor( (A_screenHeight / 2) - (Outrun2SPDXHeight / 2) ))

; Omit decimal point from axis position percentages.
Format("{:d}", Outrun2SPDXX)  
Format("{:d}", Outrun2SPDXY)  
Format("{:d}", Outrun2SPDXhWidth)  
Format("{:d}", Outrun2SPDXHeight)  

Run "TeknoParrotUi.exe --profile=or2spdlx.xml --startMinimized"

WinWaitActive("ahk_class ConsoleWindowClass", , 32) 

MyGui := Gui()
MyGui.Opt("-Caption +ToolWindow")
MyGui.BackColor := "000000"
MyGui.Show("x0 y0 h" . A_ScreenHeight . " w" . A_ScreenWidth . " Center")

WinWaitActive("ahk_class FREEGLUT", , 60) 

sleep 1000

global Outrun2SPDXX := Number(Floor( (A_screenWidth / 2) - (Outrun2SPDXhWidth / 2) ))
global Outrun2SPDXY := Number(Floor( (A_screenHeight / 2) - (Outrun2SPDXHeight / 2) ))


WinSetStyle -0xC40000, "ahk_class FREEGLUT"
WinMove(Outrun2SPDXX, Outrun2SPDXY,,, "ahk_class FREEGLUT")
WinMove(Outrun2SPDXX, Outrun2SPDXY, Outrun2SPDXhWidth, Outrun2SPDXHeight, "ahk_class FREEGLUT")

sleep 1000

WinActivate("ahk_class FREEGLUT")

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
ws_ID := WinExist("ahk_class FREEGLUT")
DllCall("SetWindowPos","UInt",ws_ID,"Int",0,"Int",Outrun2SPDXX,"Int",Outrun2SPDXY,"Int",Outrun2SPDXhWidth,"Int",Outrun2SPDXHeight,"UInt",0x416)



Loop
{


        ScreenCheck_Tick++

        if not WinExist("ahk_class FREEGLUT")
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
            MMX := WinGetMinMax("ahk_class FREEGLUT")
            if WinActive("ahk_class FREEGLUT")
            {
                ScreenCheck_Tick := 0
            WinGetPos(&WinX, &WinY, &Width, &Height, "ahk_class FREEGLUT")
                if( MMX != -1)
                {
                    if(Width != Outrun2SPDXhWidth || Height != Outrun2SPDXHeight || WinX != Outrun2SPDXX || WinY != Outrun2SPDXY) 
                    {
                        MyGui.Destroy()
                        MyGui := Gui()
                        MyGui.Opt("-Caption +ToolWindow")
                        MyGui.BackColor := "000000"
                        MyGui.Show("x0 y0 h" . A_ScreenHeight . " w" . A_ScreenWidth . " Center")
                        WinSetStyle -0xC40000, "ahk_class FREEGLUT"
                        WinMove(Outrun2SPDXX, Outrun2SPDXY,,, "ahk_class FREEGLUT")
                        WinMove(Outrun2SPDXX, Outrun2SPDXY, Outrun2SPDXhWidth, Outrun2SPDXHeight, "ahk_class FREEGLUT")
                        ws_ID := WinExist("ahk_class FREEGLUT")
                        DllCall("SetWindowPos","UInt",ws_ID,"Int",0,"Int",Outrun2SPDXX,"Int",Outrun2SPDXY,"Int",Outrun2SPDXhWidth,"Int",Outrun2SPDXHeight,"UInt",0x416)
                        #WinActivateForce
                        WinActivate("ahk_exe BudgieLoader.exe")
                    }
                }
            }

        }


        Sleep 100
}





