global MLO_CLASS_NAME := "TfrmMyLifeMain"
global MLO_TASK_WINDOWS_NAME :="TVirtualStringTree5_"
global MLO_FILTER_WINDOWS_NAME :="TEdit2_"
global MLO_NAME := "MyLifeOrganized"
global MLO_MOVE_UP_PIXELS
global MLO_WINDOW_NAME := "01-MY-LIST"
global MLO_ENTER_MODE := 0
global MLO_REMINDER_TIMER_STANDING := 900000
global MLO_REMINDER_TIMER_SITTING := 1500000
global MLO_REMINDER_TIMER_WALKING := 180000
global MLO_REMINDER_TIMER := 0

global MLO_ENTER_MODE_SET_AS_JOURNALING := 1
global MLO_ENTER_MODE_SET_AS_JORNAL_NEW_TOPIC := 2

global MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK := "!e" 
global MLO_KEYBOARD_SHORTCUT_NEW_TASK := "!w" 

if (A_ComputerName = ACTIVE_COMPUTER_1) {
    MLO_MOVE_UP_PIXELS := -115
}
else if (A_ComputerName = ACTIVE_COMPUTER_2) {
    MLO_MOVE_UP_PIXELS := -115
}
else if (A_ComputerName = ACTIVE_COMPUTER_3) {
    MLO_MOVE_UP_PIXELS := -115
}

changeViewMlo(viewCombination, extraInstructions)
{
;    sendKeyCombinationIndependentActiveModifiers("{enter}{escape}") ; in caz ca editam un task
;    sleep 150
;    If (!isTaskWindowInFocus())
;    {
;        hideNotesAndFocusTasks()
;    }
    
    sendKeyCombinationIndependentActiveModifiers("!/") ; unzoom
    sendKeyCombinationIndependentActiveModifiers("^+!-") ; schimb workspace taskuri focus
    sleep 50
    sendKeyCombinationIndependentActiveModifiers(viewCombination)
    for index , instruction in extraInstructions
    {
        sleep 50
        sendKeyCombinationIndependentActiveModifiers(instruction)
    }
}

mloCloseFind()
{
    sendKeyCombinationIndependentActiveModifiers("^+!-") ; schimb workspace taskuri focus
}

mloShowFind()
{
    SetTimer TimerStickyFailBack, off
    sendKeyCombinationIndependentActiveModifiers("^+!=") ; schimb workspace all tasks
    sendKeyCombinationIndependentActiveModifiers("^+=") ; schimb view search
    sleep 500
    sendKeyCombinationIndependentActiveModifiers("{home}") ; unfold all tasks
    ControlClick, TEdit3, A,,,, NA
    ControlClick, TEdit2, A,,,, NA
    sendKeyCombinationIndependentActiveModifiers("^a")
    sendKeyCombinationIndependentActiveModifiers("{backspace}")
    sendKeyCombinationIndependentActiveModifiers("{F12}") ; unfold all tasks
    sleep 700
    sendKeyCombinationIndependentActiveModifiers("{F12}") ; unfold all tasks
    SetTimer TimerStickyFailBack, %timerTimeoutStickyKeys%
}

moveNoteWindowAndSetCursorEnd(direction)
{
    if (!isTaskWindowInFocus())
    {
        send ^{%direction%}
        sleep 200
        send ^{end}
    }
    else
    {
        send ^{%direction%}
    }
}

hideShowMLOnotes()
{
    If (isTaskWindowInFocus())
    {
        openNotesAssociatedWithTask()
    }
    else
    {
        hideNotesAndFocusTasks()
    }
}

isTaskWindowInFocus()
{
    ControlGetFocus, activeWindowNow, A
    activeWindowNow := activeWindowNow . "_"  ; transform into a string so that comparison can work
    IfInString, MLO_TASK_WINDOWS_NAME, %activeWindowNow%
    {
        return 1
    }
    else
    {
        return 0
    }
}

openNotesAssociatedWithTask()
{
    failSafeCounter := 20
    sendKeyCombinationIndependentActiveModifiers("!1")
    Loop, %failSafeCounter%
    {
        failSafeCounter--
        if (!isTaskWindowInFocus())
        {
            sendKeyCombinationIndependentActiveModifiers("^{end}")
            break
        }
        sleep 100
    }
}

hideNotesAndFocusTasks()
{
    sendKeyCombinationIndependentActiveModifiers("!{F2}") ; shortcut MLO hide properties window
}

synthesisTemplateMLO()
{
    openNotesAssociatedWithTask()
    sendKeyCombinationIndependentActiveModifiers("^a")
    sendKeyCombinationIndependentActiveModifiers("+{left}")
    sendKeyCombinationIndependentActiveModifiers("^c")
    hideNotesAndFocusTasks()
    sendKeyCombinationIndependentActiveModifiers("!w")
    sleep 100
    sendKeyCombinationIndependentActiveModifiers("%A_DD%.%A_MM%.%A_YYYY% [%A_Hour%]-[%A_Min%] | ^v")
    sendKeyCombinationIndependentActiveModifiers("{enter}")
    sleep 100
}

journalTemplateMLO()
{
    time = 100
    openNotesAssociatedWithTask()
    sendKeyCombinationIndependentActiveModifiers("^a")
    sendKeyCombinationIndependentActiveModifiers("+{left 2}")
    sendKeyCombinationIndependentActiveModifiers("^c")
    hideNotesAndFocusTasks()
    sleep %time%
    sendKeyCombinationIndependentActiveModifiers("^d")
    sleep %time%
    sendKeyCombinationIndependentActiveModifiers("{down}")
    sleep %time%
    sendKeyCombinationIndependentActiveModifiers("{enter}")
    sleep %time%
    sendKeyCombinationIndependentActiveModifiers("%A_DD%.%A_MM%.%A_YYYY% [%A_Hour%]-[%A_Min%] | ^v")
    sendKeyCombinationIndependentActiveModifiers("{enter}")
    sleep %time%
    sendKeyCombinationIndependentActiveModifiers("^+a") ; toggle folder
    sleep %time%
    sendKeyCombinationIndependentActiveModifiers("{right}")
}

rapidTaskEntry()
{
    sendKeyCombinationIndependentActiveModifiers("#!]") ; shortcut MLO for rapid task entry
    SetTimer TimerActivateMloRapidTaskWindow, 200
}

timerActivateMloRapidTaskWindow()
{
    If WinExist("Rapid Task Entry")
    {
        SetTimer TimerActivateMloRapidTaskWindow, OFF
        WinActivate ahk_class TfrmQuickAddMLOTask, , 2

        WinMove, A,, 0, 0, (A_ScreenWidth), 500
    }
    resetModifierWithoutTriggerUpState("lwin", winActive)
}

; reduce scroll bar width in windows https://www.thewindowsclub.com/windows-8-scroll-bar-hard-see-change-windows-8-scrollbar-width
setMloDarkMode(enabled)
{
    if (enabled)
    {
        topWidth := A_ScreenWidth + 10
        topHeight := 120
        topX := -10
        topY := -10
        Gui, top:new
        Gui, +toolwindow -caption +alwaysontop
        Gui, color , 000000  ; set color value RGB
        Gui, top:show, w%topWidth% h%topHeight% x%topX% y%topY%

        bottomWidth := A_ScreenWidth + 10
        bottomHeight := 130
        bottomX := -10
        bottomY := A_ScreenHeight - bottomHeight
        Gui, bottom:new
        Gui, +toolwindow -caption +alwaysontop
        Gui, color , 000000  ; set color value RGB
        Gui, bottom:show, w%bottomWidth% h%bottomHeight% x%bottomX% y%bottomY%

        leftWidth := 14
        leftHeight := A_ScreenHeight + 20
        leftX := 0
        leftY := 0
        Gui, left:new
        Gui, +toolwindow -caption +alwaysontop
        Gui, color , 000000  ; set color value RGB
        Gui, left:show, w%leftWidth% h%leftHeight% x%leftX% y%leftY%

        rightWidth := 45
        rightHeight := A_ScreenHeight + 20
        rightX := A_ScreenWidth - rightWidth
        rightY := 0
        Gui, right:new
        Gui, +toolwindow -caption +alwaysontop
        Gui, color , 000000  ; set color value RGB
        Gui, right:show, w%rightWidth% h%rightHeight% x%rightX% y%rightY%

        WinActivate ahk_class TfrmMyLifeMain, , 2 ; reselect mlo because overlay is not selected
    }
    else
    {
        Gui, top:destroy
        Gui, bottom:destroy
        Gui, left:destroy
        Gui, right:destroy
    }
}

timerFlashMinutesUp()
{
    setTimer TimerFlashMinutesUp, OFF
    if (MLO_REMINDER_TIMER = MLO_REMINDER_TIMER_STANDING)
    {
        MLO_REMINDER_TIMER := MLO_REMINDER_TIMER_SITTING
    }
    else if (MLO_REMINDER_TIMER = MLO_REMINDER_TIMER_SITTING)
    {
        MLO_REMINDER_TIMER := MLO_REMINDER_TIMER_WALKING
    }
    else if (MLO_REMINDER_TIMER = MLO_REMINDER_TIMER_WALKING)
    {
        MLO_REMINDER_TIMER := MLO_REMINDER_TIMER_STANDING
    }

    IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
    {
        SetTimer TimerStickyFailBack, off

        setTimer TimerFlashMinutesUp, %MLO_REMINDER_TIMER%
        enters := "`n`n`n`n`n`n`n`n`n`n"
        spacing := "                        "
        showtooltip(enters . spacing . "Timer UP" . spacing . enters, 60000, A_CaretX, A_CaretY)

        SetTimer TimerStickyFailBack, %timerTimeoutStickyKeys%
    }
}

stopMloEnhancements(deactivateDarkMode = 0, deactivateReminderTime = 0)
{
    MLO_ENTER_MODE := 0
    if (deactivateReminderTime)
    {
        MLO_REMINDER_TIMER := 0
    }
    if (deactivateDarkMode)
    {
        setMloDarkMode(0)
        SetTimer TimerMloEnhancements, off
    }

    setTimer TimerFlashMinutesUp, off
}

timerMloEnhancements()
{
    If (!inStr(lastActiveAppName, MLO_WINDOW_NAME, true))
    {
        stopMloEnhancements(1)
        timerSyncMlo()
    }
}

goToTaskAndWriteNotes(key)
{
    taskNumber := SubStr(key, 2, StrLen(key))
    if (taskNumber > 4)
    {
        taskNumber := taskNumber - 4
    } 
    else
    {
        taskNumber := taskNumber + 2
    }
    taskNumber := taskNumber + 2 ; because bookmarks start from 3, not 1
    bookmark := "+{F" . taskNumber . "}"   
    send %bookmark% ; go to bookmark associated with task number
    send ^{F11} ; collapse other subtasks
    sleep 50
    send !q ; open sub-tasks if any
    sleep 50
    taskNumber := taskNumber + 1
    bookmark := "+{F" . taskNumber . "}"
    send %bookmark% ; go to bookmark associated with task number
    sleep 50
    send {up}
    sendKeyCombinationIndependentActiveModifiers("!w")
}

changeViewMloFactory(number, modifiers)
{
    extraInstructions := ["{home}", "{F11}"]
    stopMloEnhancements(0, 1)
    if (number = 9)
    {
        extraInstructions := []
    }
    else if (number = 1 || number = 2 || number = 3)
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_JOURNALING
    }

    changeViewMlo(modifiers . number, extraInstructions)
}

