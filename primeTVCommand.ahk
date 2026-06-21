#Requires AutoHotkey v2.0
#SingleInstance force

; Ensures a consistent starting directory.
SetWorkingDir A_ScriptDir

; Script to run Youtube TV via a sandboxed chrome instance. Also auto hides mouse cursor after 1 second of inactivity. DS4Windows controller profile switching feature as well.
; Notes
; Change the following locations as per your setup:
; executablePath :- path to chrome
; --user-data-dir :- This is a folder which you create, that houses the sesion/cookie data for youtube tv

; User Agents to get Youtube TV working on a desktop browser:
; PS4:
; Mozilla/5.0 (PS4; Leanback Shell) Gecko/20100101 Firefox/65.0 LeanbackShell/01.00.01.75 Sony PS4/ (PS4, , no, CH)
; Xbox Series X:
; Mozilla/5.0 (Windows NT 10.0; Win64; x64; Xbox; Xbox Series X) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.82 Safari/537.36 Edge/20.02



global Last_X := 0
global Last_Y := 0
global MouseState := False

myGui := Gui()
myGui.Opt("-Caption +ToolWindow")
myGui.BackColor := 0
myGui.Show("x0 y0 h" . A_ScreenHeight . " w" . A_ScreenWidth . " Center")

if(ProcessExist("msedge.exe"))
  {
    ProcessClose("msedge.exe")
  }

; executablePath := '"C:\Program Files\Google\Chrome\Application\chrome.exe" --start-fullscreen --user-data-dir="D:\Programs\Kodi\chromProfile"  --disable-features=ExtensionManifestV2Unsupported,ExtensionManifestV2Disabled https://www.primevideo.com/'
executablePath := '"C:\Program Files (x86)\Microsoft\Edge\Application\msedge_proxy.exe"  --start-fullscreen --profile-directory=Default --app-id=dfknihiibccbincpokjjfppofbehhbap --app-url=https://www.primevideo.com/?pwaVersion=0.0.1 --app-launch-source=4'
; executablePath := 'shell:AppsFolder\AmazonVideo.PrimeVideo_pwbj9vvecjh7j!PWA'
Run executablePath

WinWaitActive("Prime Video")

WinSetAlwaysOnTop true, "Prime Video"
MyGui.Destroy()
WinActivate("Prime Video")

; Alt + F4
!F4::WinClose("Prime Video")

; Set DS4Windows controller profile for youtube TV
if WinExist("ahk_exe DS4Windows.exe")
{
  SetWorkingDir "D:\DS4Windows"
  Run 'DS4Windows.exe -command LoadTempProfile.1.youtubeTV'
  Run 'DS4Windows.exe -command LoadProfile.1.youtubeTV'
  Run 'DS4Windows.exe -command LoadTempProfile.2.youtubeTV'
  Run 'DS4Windows.exe -command LoadProfile.2.youtubeTV'    
}

; Set DSX controller profile for youtube TV
if WinExist("ahk_exe DSX.exe")
{
  SetWorkingDir "R:\SteamLibrary\steamapps\common\DSX\Main_v3_Beta\Console"
  Run 'DSX_Console.exe /silent /changeProfile 90:B6:85:D6:6C:6E Kodi'
}

Loop
{
        if (WinExist("Prime Video") and !WinActive("Prime Video"))
        {
          WinActivate("Prime Video")
        }
        if !WinExist("Prime Video")
        {
            ; Switch DS4Windows back to kodi profile once exiting out of youtube TV
            if WinExist("ahk_exe DS4Windows.exe")
            {
              SetWorkingDir "D:\DS4Windows"
              Run 'DS4Windows.exe -command LoadTempProfile.1.HTPC'
              Run 'DS4Windows.exe -command LoadProfile.1.HTPC'
              Run 'DS4Windows.exe -command LoadTempProfile.2.HTPC'
              Run 'DS4Windows.exe -command LoadProfile.2.HTPC'
            }

            ExitApp()
        }

        Sleep(200)
}


Return