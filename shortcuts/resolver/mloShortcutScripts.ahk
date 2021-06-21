global MLO_CLASS_NAME := "TfrmMyLifeMain"
global MLO_TASK_WINDOWS_NAME :="TVirtualStringTree5_"
global MLO_FILTER_WINDOWS_NAME :="TEdit2_"
global MLO_NAME := "MyLifeOrganized"
global MLO_MOVE_UP_PIXELS
global MLO_WINDOW_NAME := "MyLifeOrganized"



if (A_ComputerName = ACTIVE_COMPUTER_1) {
    MLO_MOVE_UP_PIXELS := -115
}
else if (A_ComputerName = ACTIVE_COMPUTER_2) {
    MLO_MOVE_UP_PIXELS := -115
}
else if (A_ComputerName = ACTIVE_COMPUTER_3) {
    MLO_MOVE_UP_PIXELS := -115
}

setContextMlo(number)
{
    send !l ; context window
    sleep 100
    send %number%
    send {space}
    send {enter}
    hideNotesAndFocusTasks()
}

changeViewMlo(viewCombination, extraInstructions)
{
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
    send {ctrl up}
    send {shift up}
    send ^+!- ; schimb workspace taskuri focus
}

mloShowFind()
{
    send ^+!= ; schimb workspace all tasks
    send ^+=  ; schimb view search
    sleep 50
    send {F7}
    send ^+l ; clear task filter
    sleep 500
    ControlClick, TEdit3, A,,,, NA
    ControlClick, TEdit2, A,,,, NA
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

toggleMaximizeMloWindow()
{
    WinGetClass, activeProgramWindowClass, A
    if (activeProgramWindowClass = MLO_CLASS_NAME)
    {
        WinMinimize, A
    }
    else
    {
        SetTitleMatchMode, 2
        WinActivate, %MLO_NAME%, , 2
        WinWait, %MLO_NAME%, , 2
        setMloWindowPosition()
    }
}

setMloWindowPosition()
{
    WinMove, , %MLO_MOVE_UP_PIXELS%
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
    WinWait ahk_class TfrmQuickAddMLOTask, , 2
    WinActivate ahk_class TfrmQuickAddMLOTask, , 2
}
