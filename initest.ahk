#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include Ini.ahk

EscExitWhitelist := []
AltExitWhitelist := []


FileRead, ini, launchmb.ini

EscAppKeys := ini_getAllKeyNames(ini, "EscApps")
AltExitAppKeys := ini_getAllKeyNames(ini, "AltExitApps")

StringSplit, EscAppArray, EscAppKeys, `,
StringSplit, AltExitAppArray, EscAppKeys, `,


Loop, % EscAppArray0
{
	EscExitWhitelist%A_Index% := ini_getValue(ini, "EscApps", EscAppArray%A_Index%)
	EscExitWhitelist0 ++
}
Loop, % AltExitAppArray0
{
	AltExitWhitelist%A_Index% := ini_getValue(ini, "AltExitApps", AltExitAppArray%A_index%)
	AltExitAppArray0 ++
}

MsgBox, % EscExitWhitelist1