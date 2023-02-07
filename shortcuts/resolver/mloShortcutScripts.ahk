global MLO_LAST_VIEW := ""
global MLO_CLASS_NAME := "TfrmMyLifeMain"
global MLO_TASK_WINDOWS_NAME :="TVirtualStringTree5_"
global MLO_FILTER_WINDOWS_NAME :="TEdit2_"
global MLO_NAME := "MyLifeOrganized"
global MLO_WINDOW_NAME := "01-MY-LIST"
global SHOULD_SYNC_AFTER_MLO_MINIMIZED := 0
global MLO_DARK_MODE_TOP_HEIGHT := 0
global MLO_DARK_MODE_BOTTOM_HEIGHT := 0
global MLO_DARK_MODE_RIGHT_WIDTH := 0
global MLO_DARK_MODE_LEFT_WIDTH := 0
global MLO_LAST_TIME_SYNC := 0
global MLO_POSITION_Y_RAPID_TASK_ENTRY := 0
global IS_DAY_SORTING_VIEW_ACTIVE := 0
global IS_SET_MLO_ORDER_ACTIVE := 0

global MLO_KEYBOARD_SHORTCUT_MLO_SYNC := "^{F9}" 
global MLO_KEYBOARD_SHORTCUT_SYNC_MLO_CALENDAR := "^{F10}" 
global MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK := "^d" 
global MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK := "!e" 
global MLO_KEYBOARD_SHORTCUT_NEW_TASK := "!w" 
global MLO_KEYBOARD_SHORTCUT_FOLDER := "^+a"
global MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_EXCEPT_SELECTION := "^+{F12}" 
global MLO_KEYBOARD_SHORTCUT_EXPAND_ALL_TASKS := "^o" 
global MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS := "^+o" 
global MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_SHOW_FIRST_LEVEL := "^+;" 
global MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_TOGGLE_COLLAPSE_ALL_CHILDREN := "!q" 
global MLO_KEYBOARD_SHORTCUT_TO_DO_MANUAL_SORTING := "^;" 



if (A_ComputerName = ACTIVE_COMPUTER_X230)
{
}
else if (A_ComputerName = ACTIVE_COMPUTER_X1_YOGA_G3)
{
    MLO_POSITION_Y_RAPID_TASK_ENTRY := 70
    MLO_DARK_MODE_TOP_HEIGHT := 120
    MLO_DARK_MODE_RIGHT_WIDTH := 45
    MLO_DARK_MODE_LEFT_WIDTH := 14
    MLO_DARK_MODE_BOTTOM_HEIGHT := 130
}
else if (A_ComputerName = ACTIVE_COMPUTER_X1_EXTREME)
{
    MLO_POSITION_Y_RAPID_TASK_ENTRY := 111
    MLO_DARK_MODE_TOP_HEIGHT := 114
    MLO_DARK_MODE_RIGHT_WIDTH := 73
    MLO_DARK_MODE_BOTTOM_HEIGHT := 214 ; when taskbar not hidden
    ;MLO_DARK_MODE_BOTTOM_HEIGHT := 100 ; when taskbar hidden
    MLO_DARK_MODE_LEFT_WIDTH := 13
}

processMloEnhancements()
{
    If (inStr(lastActiveAppName, MLO_WINDOW_NAME, true))
    {
        SHOULD_SYNC_AFTER_MLO_MINIMIZED := 1
        if (inStr(lastActiveAppName, " *", true) || inStr(lastActiveAppName, "Rapid Task Entry", true) || inStr(lastActiveAppName, "MyLifeOrganized - Reminders", true))
        {
            IS_CONDITION_FOR_MLO_SYNC_FULFILLED := 1
            resetTimerSyncMlo()
        }
    }
    else if (SHOULD_SYNC_AFTER_MLO_MINIMIZED)
    {
        SHOULD_SYNC_AFTER_MLO_MINIMIZED := 0
        setMloDarkMode(0)
        if (IS_CONDITION_FOR_MLO_SYNC_FULFILLED)
        {
            IS_CONDITION_FOR_MLO_SYNC_FULFILLED := 0
            timerSyncMloStep1_launchPing()
        }
    }
    else if (A_TickCount - MLO_LAST_TIME_SYNC > 6000000)
    {
        timerSyncMloStep1_launchPing()
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
    sendKeyCombinationIndependentActiveModifiers("{home}")
    ControlClick, TEdit3, A,,,, NA
    ControlClick, TEdit2, A,,,, NA
    sendKeyCombinationIndependentActiveModifiers("^a")
    sendKeyCombinationIndependentActiveModifiers("{backspace}")
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_EXPAND_ALL_TASKS)
    sleep 700
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_EXPAND_ALL_TASKS)
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
    taskNumber := taskNumber - 4
    
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
    if (StrSplit(currentTask, "`n").MaxIndex() = 3) ; has only the template 
    {
        mloNewContextDependentSubTask(currentTask)
    }
    else
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_TOGGLE_COLLAPSE_ALL_CHILDREN)
        sendKeyCombinationIndependentActiveModifiers("{DOWN}")
        currentTask := getCurrentTask()
        mloNewContextDependentSubTask(currentTask)
    }
}

goToTask(key)
{
    taskNumber := getTaskNumber(key)
    addTaskToEndOf(taskNumber)
}

changeViewMloFactory(number, modifiers) ; modifier order: ^ ! + # 
{
    sendKeyCombinationIndependentActiveModifiers("{escape}")
    extraInstructions := ["{home}", MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS]
    resetMloEnterMode(0)
    IS_DAY_SORTING_VIEW_ACTIVE := 0
    if (IS_SET_MLO_ORDER_ACTIVE)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_TO_DO_MANUAL_SORTING)
        IS_SET_MLO_ORDER_ACTIVE := 0
    }

;   if (A_Hour > 19)
;   if (A_WDay = 1) ; sunday 
    if (number = 1 && modifiers = "^")
    {
        extraInstructions := ["{home}", MLO_KEYBOARD_SHORTCUT_EXPAND_ALL_TASKS, "{DOWN}"]
    }
    else if (number = 2 && modifiers = "^")
    {
        extraInstructions := ["{home}", MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS, "{DOWN}"]
    }
    else if (number = 5)
    {
        extraInstructions := ["{F12}"]
    }
    
    MLO_LAST_VIEW := modifiers . number
    changeViewMlo(modifiers . number, extraInstructions)
}