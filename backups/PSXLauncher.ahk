; <COMPILER: v1.1.05.04>
#NoTrayIcon
#Persistent
#SingleInstance Force
DetectHiddenWindows, ON
iniFile=config\settings.ini
regFileCache=""
regFile_epsxe=""
regFile_pcsxr=""
IfNotExist, %A_ScriptDir%\config\*.*
{
RunWait, cmd /c (md "%A_ScriptDir%\config"), , Hide
}
IfNotExist,%iniFile%
{
MsgBox, 0, Setup, Not so fast! We need to set the app up first.`n -Mashakos.
FileAppend, `n, %iniFile%
FileAppend, [Configs]`n, %iniFile%
FileAppend, `n, %iniFile%
FileAppend, Path=%A_ScriptDir%\config`n, %iniFile%
IfExist, %A_ScriptDir%\config\default.reg
{
MsgBox, 4, Default Config File Already Exists, A default config file already exists in the config folder. Overwrite?
IfMsgBox Yes
{
RunWait, cmd /c (del "%A_ScriptDir%\config\default.reg"), , Hide
RunWait, cmd /c (reg export "HKEY_CURRENT_USER\Software\Vision Thing\PSEmu Pro" "%A_ScriptDir%\config\default.reg"), , Hide
FileRead, regFileCache, %A_ScriptDir%\config\default.reg
regFileCache = %regFileCache%`r`n 
RunWait, cmd /c (del "%A_ScriptDir%\config\default.reg"), , Hide

RunWait, cmd /c (reg export "HKEY_CURRENT_USER\Software\epsxe\config" "%A_ScriptDir%\config\default.reg"), , Hide
FileRead, regFile_epsxe, %A_ScriptDir%\config\default.reg
StringReplace, regFile_epsxe, regFile_epsxe, Windows Registry Editor Version 5.00, , All
regFileCache = %regFileCache%%regFile_epsxe%
regFileCache = %regFileCache%`r`n 
RunWait, cmd /c (del "%A_ScriptDir%\config\default.reg"), , Hide

RunWait, cmd /c (reg export "HKEY_CURRENT_USER\Software\Pcsxr" "%A_ScriptDir%\config\default.reg"), , Hide
FileRead, regFile_pcsxr, %A_ScriptDir%\config\default.reg
StringReplace, regFile_pcsxr, regFile_pcsxr, Windows Registry Editor Version 5.00, , All
regFileCache = %regFileCache%%regFile_pcsxr%
regFileCache = %regFileCache%`r`n 
RunWait, cmd /c (del "%A_ScriptDir%\config\default.reg"), , Hide


FileAppend, %regFileCache%, %A_ScriptDir%\config\default.reg

}
}
else
{
RunWait, cmd /c (reg export "HKEY_CURRENT_USER\Software\Vision Thing\PSEmu Pro" "%A_ScriptDir%\config\default.reg"), , Hide
FileRead, regFileCache, %A_ScriptDir%\config\default.reg
regFileCache = %regFileCache%`r`n 
RunWait, cmd /c (del "%A_ScriptDir%\config\default.reg"), , Hide

RunWait, cmd /c (reg export "HKEY_CURRENT_USER\Software\epsxe\config" "%A_ScriptDir%\config\default.reg"), , Hide
FileRead, regFile_epsxe, %A_ScriptDir%\config\default.reg
StringReplace, regFile_epsxe, regFile_epsxe, Windows Registry Editor Version 5.00, , All
regFileCache = %regFileCache%%regFile_epsxe%
regFileCache = %regFileCache%`r`n 
RunWait, cmd /c (del "%A_ScriptDir%\config\default.reg"), , Hide

RunWait, cmd /c (reg export "HKEY_CURRENT_USER\Software\Pcsxr" "%A_ScriptDir%\config\default.reg"), , Hide
FileRead, regFile_pcsxr, %A_ScriptDir%\config\default.reg
StringReplace, regFile_pcsxr, regFile_pcsxr, Windows Registry Editor Version 5.00, , All
regFileCache = %regFileCache%%regFile_pcsxr%
regFileCache = %regFileCache%`r`n 
RunWait, cmd /c (del "%A_ScriptDir%\config\default.reg"), , Hide


FileAppend, %regFileCache%, %A_ScriptDir%\config\default.reg
}
FileSelectFolder, drivePath, , 3, Where is ePSXe located?
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
FileAppend, [ePSXe]`n, %iniFile%
FileAppend, `n, %iniFile%
FileAppend, Path=%drivePath%`n, %iniFile%
MsgBox, 4, PCSXr, Do you have PCSXr on your system?
IfMsgBox Yes
{
FileSelectFolder, drivePath, , 3, Where is PCSXr located?
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
FileAppend, [PCSXr]`n, %iniFile%
FileAppend, `n, %iniFile%
FileAppend, Path=%drivePath%`n, %iniFile%
}
MsgBox, 4, psxMAME, Do you have psxMAME on your system?
IfMsgBox Yes
{
FileSelectFolder, drivePath, , 3, Where is psxMAME located?
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
FileAppend, [psxMAME]`n, %iniFile%
FileAppend, `n, %iniFile%
FileAppend, Path=%drivePath%`n, %iniFile%
}
MsgBox, 4, Pinnacle Game Profiler, Do you have a Pinnacle Game Profiler config you would like to use?
IfMsgBox Yes
{
FileSelectFolder, drivePath, , 3, Where is Pinnacle Game Profiler located?
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
FileAppend, [PGP]`n, %iniFile%
FileAppend, `n, %iniFile%
FileAppend, Path=%drivePath%`n, %iniFile%
InputBox, UserInput, Pinnacle Game Profiler, What is the Profile name you want to use?
if ErrorLevel
{
ExitApp
}
else
{
ProfileName=%UserInput%
}
FileAppend, `n, %iniFile%
FileAppend, Profile=%ProfileName%`n, %iniFile%
InputBox, UserInput, Pinnacle Game Profiler, What is the Config name you want to use?
if ErrorLevel
{
ExitApp
}
else
{
ConfigName=%UserInput%
}
FileAppend, `n, %iniFile%
FileAppend, Config=%ConfigName%`n, %iniFile%
MsgBox, 0, Done,
			(
	You are Done!
	You can always manually edit your settings in the settings.ini file, found in the config folder.
	Please check out the readme file for instructions on how to use this app. Have fun!
	-Mashakos
)
ExitApp
}
else
{
MsgBox, 0, Done,
			(
	You are Done!
	You can always manually edit your settings in the settings.ini file, found in the config folder.
	Please check out the readme file for instructions on how to use this app. Have fun!
	-Mashakos
)
ExitApp
}
}
else
{
if 0 < 1
{
MsgBox Usage: PSXLauncher.exe <-epsxe / -epsxemouse / -pcsxr / -psxmame> <-pgp> "[config reg file]" "[Imagepath]\[Imagefile]"
ExitApp
}
IniRead, configsPath, %iniFile%, Configs, Path
IniRead, ePSXePath, %iniFile%, ePSXe, Path
IniRead, pcsxrPath, %iniFile%, PCSXr, Path
IniRead, psxmamePath, %iniFile%, psxMAME, Path
IniRead, pgpPath, %iniFile%, PGP, Path
IniRead, pgpProfile, %iniFile%, PGP, Profile
IniRead, pgpConfig, %iniFile%, PGP, Config
input1 = %1%
input2 = %2%
inputiso = %3%
pgpenabled = 0
If InStr(input2, "-pgp") > 0
{
input2 = %3%
inputiso = %4%
pgpenabled = 1
}
StringReplace, input1, input1, `-, , All
paramMatch := InStr(input1, "epsxe")
if (input1 == "epsxe")
{
SetWorkingDir %ePSXePath%
If InStr(input2, ".reg") > 0
{
RunWait, regedit /s "%configsPath%\%input2%"
Run %ePSXePath%\ePSXe.exe `-slowboot `-nogui `-loadbin "%inputiso%"
}
else
{
RunWait, regedit /s "%configsPath%\default.reg"
Run %ePSXePath%\ePSXe.exe `-slowboot `-nogui `-loadbin "%input2%"
}
WinWaitActive, ePSXe, , 2
WinWaitClose
ExitApp
}
else
if (input1 == "epsxemouse")
{
SetWorkingDir %ePSXePath%
If InStr(input2, ".reg") > 0
{
RunWait, regedit /s "%configsPath%\%input2%"
Run %ePSXePath%\ePSXe.exe `-slowboot `-nogui `-mouse `-loadbin "%inputiso%"
}
else
{
RunWait, regedit /s "%configsPath%\default.reg"
Run %ePSXePath%\ePSXe.exe `-slowboot `-nogui `-mouse `-loadbin "%input2%"
}
Sleep, 5000
Send {F5 down}
Sleep, 50
Send {F5 up}
WinWaitActive, ePSXe, , 2
WinWaitClose
ExitApp
}
else
if (input1 == "pcsxr")
{
SetWorkingDir %pcsxrPath%
If InStr(input2, ".reg") > 0
{
RunWait, regedit /s "%configsPath%\%input2%"
Run %pcsxrPath%\pcsxr.exe `-nogui `-cdfile "%inputiso%"
}
else
{
RunWait, regedit /s "%configsPath%\default.reg"
Run %pcsxrPath%\pcsxr.exe `-nogui `-cdfile "%input2%"
}
WinWaitActive, pcsxr, , 2
WinWaitClose
ExitApp
}
else
if (input1 == "psxmame")
{
SetWorkingDir %psxmamePath%
If pgpenabled > 0
{
If InStr(input2, ".reg") > 0
{
RunWait, regedit /s "%configsPath%\%input2%"
Run %psxmamePath%\mame.exe "%inputiso%"
}
else
{
RunWait, regedit /s "%configsPath%\default.reg"
Run %psxmamePath%\mame.exe "%input2%"
}
WinWaitActive, MAME:, , 2
Run "%pgpPath%\pinnacle.exe" -launch[%pgpProfile%:%pgpConfig%]
WinWaitClose
Run "%pgpPath%\pinnacle.exe" -stopprofile
ExitApp
}
else
{
If InStr(input2, ".reg") > 0
{
RunWait, regedit /s "%configsPath%\%input2%"
Run %psxmamePath%\mame.exe "%inputiso%"
}
else
{
RunWait, regedit /s "%configsPath%\default.reg"
Run %psxmamePath%\mame.exe "%input2%"
}
WinWaitActive, MAME:, , 2
WinWaitClose
ExitApp
}
}

}
