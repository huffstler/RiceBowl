#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Sets taskbar to transparent, but then all icons on taskbar as transparent as well. So it doesn't work for my usecase
; WinSet, Transparent, 150, ahk_class Shell_TrayWnd

; Changes laptop battery mode to Battery Saver
    ^+NumpadSub::
        run, "%comspec%" /c powercfg.exe /S a1841308-3541-4fab-bc81-f71556f20b4a,, Hide
        MsgBox, "Power Mode changed to Battery Saver"
    return
    
; Changes laptop power mode to High Performance
    ^+NumpadAdd::
        run, "%comspec%" /c powercfg.exe /S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c,, Hide
        MsgBox, "Power Mode Changed to High Performance"
    return

; Reduce Volume by 10%
    ^NumpadSub::
        SoundSet, -10
    return

; Raise Volume by 10%
    ^NumpadAdd::
        SoundSet, +10
    return

;Removes title bars from windows.
    #h::
      WinSet, Style, -0xc00000, A
    return

;Adds the title bars back
    #s::
      WinSet, Style, +0xC00000, A
    return
