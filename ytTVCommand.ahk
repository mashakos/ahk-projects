#Requires AutoHotkey v2.0
; Ensures a consistent starting directory.
SetWorkingDir A_ScriptDir

; Script to run Youtube TV via a sandboxed chrome instance. Also auto hides mouse cursor after 1 second of inactivity.
; Notes
; Change the following locations as per your setup:
; executablePath
; path to chrome

; --user-data-dir 
; This is a folder which you create, that houses the sesion/cookie data for youtube tv

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

executablePath := '"C:\Program Files\Google\Chrome\Application\chrome.exe" --start-fullscreen --user-data-dir="D:\Programs\Kodi\chromProfile" --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64; Xbox; Xbox Series X) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/48.0.2564.82 Safari/537.36 Edge/20.02"  --disable-features=ExtensionManifestV2Unsupported,ExtensionManifestV2Disabled https://youtube.com/tv'

Run executablePath

SetTitleMatchMode(3)
WinWaitActive("YouTube on TV - Google Chrome", , 10)

Loop
{
        MouseGetPos(&Mouse_X, &Mouse_Y)
        If(Mouse_X != Last_X || Mouse_Y != Last_Y)
        {
            If(MouseState == False)
                RestoreCursor()
            MouseState := True
            Last_Move := A_TickCount
        }
        If(A_TickCount > Last_Move + 1000 && MouseState == True) 
        {
            SetSystemCursor()
            MouseState := False
        }
        Last_X := Mouse_X, Last_Y := Mouse_Y


        if !WinExist("YouTube on TV - Google Chrome")
        {
            RestoreCursor()
            ExitApp()
        }

        Sleep(200)
}


Return

; Source:   Serenity - https://autohotkey.com/board/topic/32608-changing-the-system-cursor/
; Modified: iseahound - https://www.autohotkey.com/boards/viewtopic.php?t=75867

SetSystemCursor(Cursor := "", cx := 0, cy := 0) {

   static SystemCursors := Map("APPSTARTING", 32650, "ARROW", 32512, "CROSS", 32515, "HAND", 32649, "HELP", 32651, "IBEAM", 32513, "NO", 32648,
                           "SIZEALL", 32646, "SIZENESW", 32643, "SIZENS", 32645, "SIZENWSE", 32642, "SIZEWE", 32644, "UPARROW", 32516, "WAIT", 32514)

   if (Cursor = "") {
      AndMask := Buffer(128, 0xFF), XorMask := Buffer(128, 0)

      for CursorName, CursorID in SystemCursors {
         CursorHandle := DllCall("CreateCursor", "ptr", 0, "int", 0, "int", 0, "int", 32, "int", 32, "ptr", AndMask, "ptr", XorMask, "ptr")
         DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
      }
      return
   }

   if (Cursor ~= "^(IDC_)?(?i:AppStarting|Arrow|Cross|Hand|Help|IBeam|No|SizeAll|SizeNESW|SizeNS|SizeNWSE|SizeWE|UpArrow|Wait)$") {
      Cursor := RegExReplace(Cursor, "^IDC_")

      if !(CursorShared := DllCall("LoadCursor", "ptr", 0, "ptr", SystemCursors[StrUpper(Cursor)], "ptr"))
         throw Error("Error: Invalid cursor name")

      for CursorName, CursorID in SystemCursors {
         CursorHandle := DllCall("CopyImage", "ptr", CursorShared, "uint", 2, "int", cx, "int", cy, "uint", 0, "ptr")
         DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
      }
      return
   }

   if FileExist(Cursor) {
      SplitPath Cursor,,, &Ext:="" ; auto-detect type
      if !(uType := (Ext = "ani" || Ext = "cur") ? 2 : (Ext = "ico") ? 1 : 0)
         throw Error("Error: Invalid file type")

      if (Ext = "ani") {
         for CursorName, CursorID in SystemCursors {
            CursorHandle := DllCall("LoadImage", "ptr", 0, "str", Cursor, "uint", uType, "int", cx, "int", cy, "uint", 0x10, "ptr")
            DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
         }
      } else {
         if !(CursorShared := DllCall("LoadImage", "ptr", 0, "str", Cursor, "uint", uType, "int", cx, "int", cy, "uint", 0x8010, "ptr"))
            throw Error("Error: Corrupted file")

         for CursorName, CursorID in SystemCursors {
            CursorHandle := DllCall("CopyImage", "ptr", CursorShared, "uint", 2, "int", 0, "int", 0, "uint", 0, "ptr")
            DllCall("SetSystemCursor", "ptr", CursorHandle, "int", CursorID) ; calls DestroyCursor
         }
      }
      return
   }

   throw Error("Error: Invalid file path or cursor name")
}

RestoreCursor() {
   return DllCall("SystemParametersInfo", "uint", SPI_SETCURSORS := 0x57, "uint", 0, "ptr", 0, "uint", 0)
}