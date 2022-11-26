global MLO_LAST_VIEW := ""
global MLO_CLASS_NAME := "TfrmMyLifeMain"
global MLO_TASK_WINDOWS_NAME :="TVirtualStringTree5_"
global MLO_FILTER_WINDOWS_NAME :="TEdit2_"
global MLO_NAME := "MyLifeOrganized"
global MLO_MOVE_UP_PIXELS
global MLO_WINDOW_NAME := "01-MY-LIST"
global MLO_WINDOW_ACTIVE := 0
global MLO_DARK_MODE_TOP_HEIGHT := 0
global MLO_DARK_MODE_BOTTOM_HEIGHT := 0
global MLO_DARK_MODE_RIGHT_WIDTH := 0
global MLO_DARK_MODE_LEFT_WIDTH := 0
global MLO_LAST_TIME_FOREGROUND := 0
global MLO_POSITION_Y_RAPID_TASK_ENTRY := 0
global IS_DAY_SORTING_VIEW_ACTIVE := 0
global IS_SET_MLO_ORDER_ACTIVE := 0

global MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK := "!e" 
global MLO_KEYBOARD_SHORTCUT_NEW_TASK := "!w" 
global MLO_KEYBOARD_SHORTCUT_FOLDER := "^+a" 
global MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_EXCEPT_SELECTION := "^{F11}" 
global MLO_KEYBOARD_SHORTCUT_EXPAND_ALL_TASKS := "{F12}" 
global MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS := "{F11}" 
global MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_SHOW_FIRST_LEVEL := "^+;" 
global MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_TOGGLE_COLLAPSE_ALL_CHILDREN := "!q" 
global MLO_KEYBOARD_SHORTCUT_TO_DO_MANUAL_SORTING := "^;" 



if (A_ComputerName = ACTIVE_COMPUTER_X230)
{
    MLO_MOVE_UP_PIXELS := -115
}
else if (A_ComputerName = ACTIVE_COMPUTER_X1_YOGA_G3)
{
    MLO_MOVE_UP_PIXELS := -115
    MLO_POSITION_Y_RAPID_TASK_ENTRY := 70
    MLO_DARK_MODE_TOP_HEIGHT := 120
    MLO_DARK_MODE_RIGHT_WIDTH := 40
    MLO_DARK_MODE_LEFT_WIDTH := 14
    MLO_DARK_MODE_BOTTOM_HEIGHT := 230
}
else if (A_ComputerName = ACTIVE_COMPUTER_X1_EXTREME)
{
    MLO_MOVE_UP_PIXELS := -90
    MLO_POSITION_Y_RAPID_TASK_ENTRY := 105
    MLO_DARK_MODE_TOP_HEIGHT := 115
    MLO_DARK_MODE_RIGHT_WIDTH := 73
    MLO_DARK_MODE_BOTTOM_HEIGHT := 215 ; when taskbar not hidden
    ;MLO_DARK_MODE_BOTTOM_HEIGHT := 100 ; when taskbar hidden
    MLO_DARK_MODE_LEFT_WIDTH := 13
}

processMloEnhancements()
{
    If (inStr(lastActiveAppName, MLO_WINDOW_NAME, true))
    {
        if (!MLO_WINDOW_ACTIVE && A_TickCount - MLO_LAST_TIME_FOREGROUND > 6000000)
        {
            resetTimerSyncMlo()
            timerSyncMloStep1_launchPing()
        }
        
        MLO_WINDOW_ACTIVE := 1
        if (inStr(lastActiveAppName, " *", true) || inStr(lastActiveAppName, "Rapid Task Entry", true) || inStr(lastActiveAppName, "MyLifeOrganized - Reminders", true))
        {
            SYNC_MLO := 1
            resetTimerSyncMlo()
        }
    }
    else if (MLO_WINDOW_ACTIVE)
    {
        MLO_LAST_TIME_FOREGROUND := A_TickCount
        MLO_WINDOW_ACTIVE := 0
        setMloDarkMode(0)
        if (SYNC_MLO)
        {
            resetTimerSyncMlo()
            SYNC_MLO := 0
            timerSyncMloStep1_launchPing()
        }
    }
}

changeViewMlo(viewCombination, extraInstructions)
{
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

        WinMove, A,, 0, %MLO_POSITION_Y_RAPID_TASK_ENTRY%, (A_ScreenWidth), 500
    }
    resetModifierWithoutTriggerUpState("lwin", winActive)
}

; reduce scroll bar width in windows https://www.thewindowsclub.com/windows-8-scroll-bar-hard-see-change-windows-8-scrollbar-width
setMloDarkMode(enabled)
{
    if (enabled)
    {
        topWidth := A_ScreenWidth + 10
        topHeight := MLO_DARK_MODE_TOP_HEIGHT
        topX := -10
        topY := -10
        Gui, top:new
        Gui, +toolwindow -caption +alwaysontop
        Gui, color , 000000  ; set color value RGB
        Gui, top:show, w%topWidth% h%topHeight% x%topX% y%topY%

        bottomWidth := A_ScreenWidth + 10
        bottomHeight := MLO_DARK_MODE_BOTTOM_HEIGHT
        bottomX := -10
        bottomY := A_ScreenHeight - bottomHeight
        Gui, bottom:new
        Gui, +toolwindow -caption +alwaysontop
        Gui, color , 000000  ; set color value RGB
        Gui, bottom:show, w%bottomWidth% h%bottomHeight% x%bottomX% y%bottomY%

        leftWidth := MLO_DARK_MODE_LEFT_WIDTH
        leftHeight := A_ScreenHeight + 20
        leftX := 0
        leftY := 0
        Gui, left:new
        Gui, +toolwindow -caption +alwaysontop
        Gui, color , 000000  ; set color value RGB
        Gui, left:show, w%leftWidth% h%leftHeight% x%leftX% y%leftY%

        rightWidth := MLO_DARK_MODE_RIGHT_WIDTH
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

getTaskNumber(key)
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
    return taskNumber
}

addTaskToEndOf(taskNumber)
{
    if (A_CaretX)
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}")
    }
    
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS)
    send %taskNumber%
    sleep 150
    currentTask := getCurrentTask()
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_TOGGLE_COLLAPSE_ALL_CHILDREN)
    lines := StrSplit(currentTask, "`n")
    if (lines.MaxIndex() = 2) ; because last line in empty string based on how split works 
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else
    {
        lastSubtaskPosition := 0
        for key, val in lines
        {
            if (val && SubStr(val, 3, 1) != " ")
            {
                lastSubtaskPosition := key
            }
            
        }
        lastSubtaskPosition := lastSubtaskPosition - 1 ; because the parent is also considered in the split
        sendKeyCombinationIndependentActiveModifiers("{DOWN " . lastSubtaskPosition . "}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
}

goToTaskAndOpenNotes(taskNumber)
{
    if (!isTaskWindowInFocus())
    {
        hideNotesAndFocusTasks()
    }
    
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS)
    sendKeyCombinationIndependentActiveModifiers(taskNumber)
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_TOGGLE_COLLAPSE_ALL_CHILDREN)
    sendKeyCombinationIndependentActiveModifiers("{DOWN}")
    sleep 150
    openNotesAssociatedWithTask()
}

goToTask(key)
{
    taskNumber := getTaskNumber(key)
    if (MLO_LAST_VIEW = "!^1")
    {
        addTaskToEndOf(taskNumber)
    } 
    else if (MLO_LAST_VIEW = "^+1")
    {
        goToTaskAndOpenNotes(taskNumber)
    }
    
}

timerChangeMloTaskOrder()
{
    SetTimer TimerChangeMloTaskOrder, off
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_TO_DO_MANUAL_SORTING)
}

changeViewMloFactory(number, modifiers) ; modifier order: ^ ! + # 
{
    sendKeyCombinationIndependentActiveModifiers("{escape}")
    extraInstructions := ["{home}", MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS]
    MLO_ENTER_MODE := 0
    IS_DAY_SORTING_VIEW_ACTIVE := 0
    if (number = 1 && modifiers = "^")
    {
        if (A_WDay = 1) ; sunday
        {
            MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_ADD_SPACES
            modifiers := "!+"
            extraInstructions := ["{home}", "{F12}"]
        }
        else
        {
            modifiers := "!^"
            extraInstructions := ["{home}", MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS]
            MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH
        }
    }
    else if (number = 2 && modifiers = "^")
    {
        if (A_Hour < 10) ; sunday
        {
            modifiers := "^+"
        }
        else
        {
            modifiers := "!^"
        }
    }
    else if (number = 3 && modifiers = "^")
    {
        extraInstructions := ["{home}", "{F12}"]
        if (A_WDay = 1) ; sunday
        {
            modifiers := "!^"
            extraInstructions := ["{home}", MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS]
        }
        else
        {
            if (IS_SET_MLO_ORDER_ACTIVE)
            {
                SetTimer TimerChangeMloTaskOrder, off
                SetTimer TimerChangeMloTaskOrder, 400
                IS_SET_MLO_ORDER_ACTIVE := 0
            }
            modifiers := "^+"
            IS_DAY_SORTING_VIEW_ACTIVE := 1
        }
    }
    else if (number = 5)
    {
        extraInstructions := ["{F12}"]
    }
    
    MLO_LAST_VIEW := modifiers . number
    changeViewMlo(modifiers . number, extraInstructions)
}