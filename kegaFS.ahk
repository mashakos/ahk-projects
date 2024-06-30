; <COMPILER: v1.1.05.04>
#NoTrayIcon
#Persistent
#SingleInstance Force
DetectHiddenWindows, ON

if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"  ; Requires v1.0.92.01+
   ExitApp
}


iniFile=config.ini
regFileCache=""
regFile_epsxe=""
regFile_pcsxr=""
IfNotExist,%iniFile%
{
	MsgBox, 0, Setup, Not so fast! We need to set the app up first.`n -Mashakos.
	FileSelectFolder, drivePath, , 3, Where is Citra located?
	if drivePath =
	{
		Filedelete,%iniFile%
		MsgBox, 0, Setup,
					(
			Oh well, you don't want to use this app. Fine!
			-Mashakos.
		)
		ExitApp
	}
	driveLetter := SubStr(drivePath, 1, 1)
	FileAppend, `n, %iniFile%
	FileAppend, [Citra]`n, %iniFile%
	FileAppend, `n, %iniFile%
	FileAppend, Path=%drivePath%`n, %iniFile%
	{
		MsgBox, 0, Done,
		(
			You are Done!`nYou can always manually edit your settings in the config.ini file. Have fun!`n -Mashakos
		)
		ExitApp
	}
}
else
{
	IniRead, CitraPath, %iniFile%, Citra, Path
	input1 = %1%
	input2 = %2%
	inputiso = %3%
	pgpenabled = 0



	SetWorkingDir %CitraPath%
	Run %CitraPath%\Fusion.exe

	WinWaitActive, ahk_exe Fusion.exe, , 2
	WinWaitClose
	ExitApp

	F12::ToggleFakeFullscreen()
}



;;; Known issues:
;;;
;;; - Weird results for windows with custom decorations such as
;;; Chrome, or programs with a Ribbon interface.
;;; - Emacs will be maximized behind instead of in front of
;;; the taskbar. Workaround: WinHide ahk_class Shell_TrayWnd
ToggleFakeFullscreen()
{
	CoordMode Screen, Window
	static WINDOW_STYLE_UNDECORATED := -0xC40000
	static savedInfo := Object() ;; Associative array!
	WinGet, id, ID, A
	if (savedInfo[id])
	{
	inf := savedInfo[id]
	WinSet, Style, % inf["style"], ahk_id %id%
	WinMove, ahk_id %id%,, % inf["x"], % inf["y"], % inf["width"], % inf["height"]
	savedInfo[id] := ""
	}
	else
	{
	savedInfo[id] := inf := Object()
	WinGet, ltmp, Style, A
	inf["style"] := ltmp
	WinGetPos, ltmpX, ltmpY, ltmpWidth, ltmpHeight, ahk_id %id%
	inf["x"] := ltmpX
	inf["y"] := ltmpY
	inf["width"] := ltmpWidth
	inf["height"] := ltmpHeight
	WinSet, Style, %WINDOW_STYLE_UNDECORATED%, ahk_id %id%
	mon := GetMonitorActiveWindow()
	SysGet, mon, Monitor, %mon%
	WinMove, A,, %monLeft%, %monTop%, % monRight-monLeft+16, % monBottom-monTop+40
	}
}

GetMonitorAtPos(x,y)
{
	;; Monitor number at position x,y or -1 if x,y outside monitors.
	SysGet monitorCount, MonitorCount
	i := 0
	while(i < monitorCount)
	{
	SysGet area, Monitor, %i%
	if ( areaLeft <= x && x <= areaRight && areaTop <= y && y <= areaBottom )
	{
	return i
	}
	i := i+1
	}
	return -1
}

GetMonitorActiveWindow(){
	;; Get Monitor number at the center position of the Active window.
	WinGetPos x,y,width,height, A
	return GetMonitorAtPos(x+width/2, y+height/2)
}



