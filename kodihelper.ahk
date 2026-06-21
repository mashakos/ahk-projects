#Requires AutoHotkey v2.0
#SingleInstance force

executablePath := 'C:\Program Files\Kodi\kodi.exe'

RunWait executablePath

; Set DSX controller profile for HTPC
; if WinExist("ahk_exe DSX.exe")
;{
  SetWorkingDir "R:\SteamLibrary\steamapps\common\DSX\Main_v3_Beta\Console"
  Run 'DSX_Console.exe /silent /changeProfile 90:B6:85:D6:6C:6E HTPC'
  Run 'DSX_Console.exe /silent /changeProfile 10:18:49:D7:55:47 HTPC'
;}
Exit
