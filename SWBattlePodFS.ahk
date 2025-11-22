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
SWBattlePodhWidth := Number(A_screenWidth)
SWBattlePodHeight := Number(A_screenWidth * 0.5625)
SWBattlePodX := Number(Floor( (A_screenWidth / 2) - (SWBattlePodhWidth / 2) ))
SWBattlePodY := Number(Floor( (A_screenHeight / 2) - (SWBattlePodHeight / 2) ))

; Omit decimal point from axis position percentages.
Format("{:d}", SWBattlePodX)  
Format("{:d}", SWBattlePodY)  
Format("{:d}", SWBattlePodhWidth)  
Format("{:d}", SWBattlePodHeight)  

Run "TeknoParrotUi.exe --profile=StarWars.xml --startMinimized"

WinWaitActive("ahk_exe OpenParrotLoader64.exe", , 32) 

MyGui := Gui()
MyGui.Opt("-Caption +ToolWindow")
MyGui.BackColor := "000000"
MyGui.Show("x0 y0 h" . A_ScreenHeight . " w" . A_ScreenWidth . " Center")

WinWaitActive("ahk_class LaunchUnrealUWindowsClient", , 32) 

sleep 1000

global SWBattlePodX := Number(Floor( (A_screenWidth / 2) - (SWBattlePodhWidth / 2) ))
global SWBattlePodY := Number(Floor( (A_screenHeight / 2) - (SWBattlePodHeight / 2) ))


WinSetStyle -0xC40000, "ahk_class LaunchUnrealUWindowsClient"
WinMove(SWBattlePodX, SWBattlePodY,,, "ahk_class LaunchUnrealUWindowsClient")
WinMove(SWBattlePodX, SWBattlePodY, SWBattlePodhWidth, SWBattlePodHeight, "ahk_class LaunchUnrealUWindowsClient")

sleep 1000

WinActivate("ahk_class LaunchUnrealUWindowsClient")

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
ws_ID := WinExist("ahk_class LaunchUnrealUWindowsClient")
DllCall("SetWindowPos","UInt",ws_ID,"Int",0,"Int",SWBattlePodX,"Int",SWBattlePodY,"Int",SWBattlePodhWidth,"Int",SWBattlePodHeight,"UInt",0x416)



Loop
{


        ScreenCheck_Tick++

        if not WinExist("ahk_exe ahk_exe SWArcGame-Win64-Shipping.exe")
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
            MMX := WinGetMinMax("ahk_class LaunchUnrealUWindowsClient")
            if WinActive("ahk_class LaunchUnrealUWindowsClient")
            {
                ScreenCheck_Tick := 0
            WinGetPos(&WinX, &WinY, &Width, &Height, "ahk_class LaunchUnrealUWindowsClient")
                if( MMX != -1)
                {
                    if(Width != SWBattlePodhWidth || Height != SWBattlePodHeight || WinX != SWBattlePodX || WinY != SWBattlePodY) 
                    {
                        MyGui.Destroy()
                        MyGui := Gui()
                        MyGui.Opt("-Caption +ToolWindow")
                        MyGui.BackColor := "000000"
                        MyGui.Show("x0 y0 h" . A_ScreenHeight . " w" . A_ScreenWidth . " Center")
                        WinSetStyle -0xC40000, "ahk_class LaunchUnrealUWindowsClient"
                        WinMove(SWBattlePodX, SWBattlePodY,,, "ahk_class LaunchUnrealUWindowsClient")
                        WinMove(SWBattlePodX, SWBattlePodY, SWBattlePodhWidth, SWBattlePodHeight, "ahk_class LaunchUnrealUWindowsClient")
                        ws_ID := WinExist("ahk_class LaunchUnrealUWindowsClient")
                        DllCall("SetWindowPos","UInt",ws_ID,"Int",0,"Int",SWBattlePodX,"Int",SWBattlePodY,"Int",SWBattlePodhWidth,"Int",SWBattlePodHeight,"UInt",0x416)
                        #WinActivateForce
                        WinActivate("ahk_exe SWArcGame-Win64-Shipping.exe")
                    }
                }
            }

        }


        Sleep 100
}





