; ^ ctrl, + shift, !alt, 

^!e::
FormatTime, CurrentDateTime,, yyyy-MM-dd HH:mm:ss
SendInput, %CurrentDateTime%
return


$CapsLock::Enter
LAlt & Capslock::SetCapsLockState, % GetKeyState("CapsLock", "T") ? "Off" : "On"
return


^!d:: ; Duplicate
	send {Home}  ; brings the cursor to the starting of the line
	Sleep 10
	send +{End}  ; selects the entire line
	Sleep 10
	send ^c  ; copies the text
	Sleep 10
	send {End}  ; goes to the end of line
	Sleep 10
	send {Enter}  ; creates a new line
	Sleep 10
	send ^v     ; pastes the text at next line
	return




; Initialize variables
mouseX := 0
mouseY := 0
isPositionSaved := false

; When Ctrl + Right Alt + O is pressed
RAlt & o:: 
    ; Record the current mouse position
    MouseGetPos, mouseX, mouseY
	

    isPositionSaved := true
    ;MsgBox, Mouse position recorded: (%mouseX%, %mouseY%)
    return

; When Ctrl + Right Alt + P is pressed
RAlt & p:: 
    if isPositionSaved
    {
        ; Move to the recorded mouse position
		Click, %mouseX%, %mouseY%
        ;MouseMove, mouseX, mouseY
        ;MsgBox, Mouse moved to recorded position: (%mouseX%, %mouseY%)
    }
    else
    {
        ;MsgBox, No recorded mouse position!
    }
    return



;^p:: ; 当按下 Ctrl + P 时
    ;KeyWait, p ; 等待 P 键释放
    ;if GetKeyState("c", "C") ; 检查 C 键是否被按下
    ;{
    ;    ; 在这里添加你想要执行的操作
    ;    MsgBox, 你按下了 Ctrl + P 和 Ctrl + C!
    ;}
    ;return










;---------------


;^!m:: ; 定义快捷键为 Ctrl + Alt + M explain 只用于minimize window, 
;不是软件的window 比如 A(主控) B(被连接) 则快捷键用于在两者之间切换

;^MButton::
^XButton1:: ; Ctrl + 鼠标后退键 (Back Button)
    ;Sleep, 50
    IfWinActive, ahk_class TscShellContainerClass
        WinMinimize, A
    Else
        WinActivate, ahk_class TscShellContainerClass
    return



;---------------

; CopyFilePath.ahk
; This script allows you to quickly copy the path of selected files in Windows Explorer
; Hotkey: Ctrl+Shift+C

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases
#SingleInstance Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability

; Ctrl+Shift+C to copy file path
^+c::
    ; Get the selected file(s) in Explorer
    WinGetClass, CurrWinClass, A
    if (CurrWinClass = "CabinetWClass" or CurrWinClass = "ExploreWClass") ; If in Explorer
    {
        Send, ^c
        Sleep, 100
        ClipPath := Explorer_GetSelected()
        if (ClipPath != "")
        {
            Clipboard := ClipPath
            ToolTip, Path copied to clipboard:`n%ClipPath%
            SetTimer, RemoveToolTip, 2000
        }
    }
Return

RemoveToolTip:
    ToolTip
    SetTimer, RemoveToolTip, Off
Return

; Function to get the path of selected items in Explorer
Explorer_GetSelected() {
    WinGetClass, class, A
    if (class != "CabinetWClass" and class != "ExploreWClass")
        return ""
    
    ; Get the Explorer's object
    for window in ComObjCreate("Shell.Application").Windows
    {
        if (window.HWND = WinExist("A"))
        {
            selectedItems := window.Document.SelectedItems
            break
        }
    }
    
    ; Prepare the result
    result := ""
    for item in selectedItems
        result .= (result ? "`n" : "") . item.Path
    
    return result
}
