#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

    ^ & + & NumpadSub::
        run, %comspec% /k powercfg.exe /S a1841308-3541-4fab-bc81-f71556f20b4a
    return

    ^ & + % NumpadAdd::
        run, %comspec% /k powercfg.exe /S 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    return