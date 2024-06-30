; <COMPILER: v1.1.05.04>
InputBox, UserInput, PSX Plugin config, Enter the name of the PSX config file you want to create. The current PSX pluging settings will be exported and saved to the named config file, to be used by PSXLauncher. Please enter a file name for the exported config.
if ErrorLevel
{
ExitApp
}
else
{
regFile=%UserInput%
regFileCache=""
regFile_epsxe=""
regFile_pcsxr=""
stdin  := FileOpen("*", "r `n")  ; Requires v1.1.17+
stdout := FileOpen("*", "w `n")
IfNotExist, %A_ScriptDir%\config\*.*
{
RunWait, cmd /c (md "%A_ScriptDir%\config"), , Hide
}
IfExist, %A_ScriptDir%\config\%regFile%.reg
{
MsgBox, 4, Config File Already Exists, %regFile%.reg already exists. Overwrite?
IfMsgBox Yes
{
RunWait, cmd /c (del "%A_ScriptDir%\config\%regFile%.reg"), , Hide
}
else
{
ExitApp
}
}
RunWait, cmd /c (reg export "HKEY_CURRENT_USER\Software\Vision Thing\PSEmu Pro" "%A_ScriptDir%\config\%regFile%.reg"), , Hide
FileRead, regFileCache, %A_ScriptDir%\config\%regFile%.reg
regFileCache = %regFileCache%`r`n 
RunWait, cmd /c (del "%A_ScriptDir%\config\%regFile%.reg"), , Hide

RunWait, cmd /c (reg export "HKEY_CURRENT_USER\Software\epsxe\config" "%A_ScriptDir%\config\%regFile%.reg"), , Hide
FileRead, regFile_epsxe, %A_ScriptDir%\config\%regFile%.reg
StringReplace, regFile_epsxe, regFile_epsxe, Windows Registry Editor Version 5.00, , All
regFileCache = %regFileCache%%regFile_epsxe%
regFileCache = %regFileCache%`r`n 
RunWait, cmd /c (del "%A_ScriptDir%\config\%regFile%.reg"), , Hide

RunWait, cmd /c (reg export "HKEY_CURRENT_USER\Software\Pcsxr" "%A_ScriptDir%\config\%regFile%.reg"), , Hide
FileRead, regFile_pcsxr, %A_ScriptDir%\config\%regFile%.reg
StringReplace, regFile_pcsxr, regFile_pcsxr, Windows Registry Editor Version 5.00, , All
regFileCache = %regFileCache%%regFile_pcsxr%
regFileCache = %regFileCache%`r`n 
RunWait, cmd /c (del "%A_ScriptDir%\config\%regFile%.reg"), , Hide


FileAppend, %regFileCache%, %A_ScriptDir%\config\%regFile%.reg

MsgBox Config file saved in:`n %A_ScriptDir%\config\%regFile%.reg
ExitApp
}
