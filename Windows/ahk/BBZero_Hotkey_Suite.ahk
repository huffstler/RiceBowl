#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

    ^+NumpadSub::
        run, "%comspec%" /c powercfg.exe /S a1841308-3541-4fab-bc81-f71556f20b4a,, Hide
        MsgBox, "Power Mode changed to Battery Saver"
    return

    ^+NumpadAdd::
        run, "%comspec%" /c powercfg.exe /S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c,, Hide
        MsgBox, "Power Mode Changed to High Performance"
    return

    ^NumpadSub::
        SoundSet, -10
    return

    ^NumpadAdd::
        SoundSet, +10
    return

;Removes title bars from windows.
    #h::
      WinSet, Style, -0xc00000, A
    return

;Adds the title bars back
    #s::
      WinSet, Style, +0xc00000, A
    return
