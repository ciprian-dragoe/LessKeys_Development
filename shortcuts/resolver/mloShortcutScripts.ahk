global MLO_LAST_VIEW := ""
global MLO_CLASS_NAME := "TfrmMyLifeMain"
global MLO_DASHBOARD_CLASS_NAME := "TfrmMLODashboard"
global MLO_TASK_WINDOWS_NAME :="TVirtualStringTree4_"
global MLO_FILTER_WINDOWS_NAME :="TEdit2_"
global MLO_NAME := "MyLifeOrganized"
global MLO_WINDOW_NAME := "MLO_"
global MLO_WINDOW_TASK_NAME := "MLO_TASKS"
global MLO_WINDOW_JOURNAL_NAME := "MLO_JURNAL"
global MLO_WINDOW_PLAN_MORNING_NAME := "MLO_PLANIFIC_DIMINEATA"
global MLO_WINDOW_PLAN_EVENING_NAME := "MLO_PLANIFIC_SEARA"
global SHOULD_SYNC_AFTER_MLO_MINIMIZED := 0
global MLO_DARK_MODE_TOP_HEIGHT := 0
global MLO_DARK_MODE_BOTTOM_HEIGHT := 0
global MLO_DARK_MODE_RIGHT_WIDTH := 0
global MLO_DARK_MODE_LEFT_WIDTH := 0
global MLO_LAST_TIME_SYNC := 0
global MLO_POSITION_Y_RAPID_TASK_ENTRY := 0
global IS_SORTING_VIEW_ACTIVE := 0
global IS_SET_MLO_ORDER_ACTIVE := 0

global MLO_KEYBOARD_SHORTCUT_MLO_SYNC := "^{F9}"
global MLO_KEYBOARD_SHORTCUT_SYNC_MLO_CALENDAR := "^{F10}"
global MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK := "^d"
global MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK := "^+n"
global MLO_KEYBOARD_SHORTCUT_NEW_TASK := "^n"
global MLO_KEYBOARD_SHORTCUT_FOLDER := "^+a"
global MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_EXCEPT_SELECTION := "^+{F12}"
global MLO_KEYBOARD_SHORTCUT_EXPAND_ALL_TASKS := "^o"
global MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS := "^+o"
global MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_SHOW_LEVEL_1 := "^+;"
global MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_SHOW_LEVEL_2 := "^+'"
global MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_TOGGLE_COLLAPSE_ALL_CHILDREN := "!q"
global MLO_KEYBOARD_SHORTCUT_TO_DO_MANUAL_SORTING := "^;" 
global MLO_KEYBOARD_SHORTCUT_RAPID_TASK_ENTRY := "^+!m"
global MLO_KEYBOARD_SHORTCUT_TOGGLE_TASK_PROPERTIES_VIEW := "!1"
global MLO_KEYBOARD_SHORTCUT_NEXT_DAY_START_DATE := "^+/"



setLaptopDependentMloVariables(isMloDashboardActive = 0)
{
    if (A_ComputerName = ACTIVE_COMPUTER_X230)
    {
    }
    else if (A_ComputerName = ACTIVE_COMPUTER_X1_YOGA_G3)
    {
        wobblyKeyTimeout := 300
        
        MLO_POSITION_Y_RAPID_TASK_ENTRY := 70
        MLO_DARK_MODE_TOP_HEIGHT := 115
        MLO_DARK_MODE_RIGHT_WIDTH := 45
        MLO_DARK_MODE_LEFT_WIDTH := 14
        MLO_DARK_MODE_BOTTOM_HEIGHT := 125
        
        if (isMloDashboardActive)
        {
            MLO_DARK_MODE_TOP_HEIGHT := 55
            MLO_DARK_MODE_BOTTOM_HEIGHT := 113
        }
    }
    else if (A_ComputerName = ACTIVE_COMPUTER_IRIS_T15)
    {
    }
    else if (A_ComputerName = ACTIVE_COMPUTER_X1_EXTREME)
    {
        MLO_POSITION_Y_RAPID_TASK_ENTRY := 111
        MLO_DARK_MODE_TOP_HEIGHT := 115
        MLO_DARK_MODE_RIGHT_WIDTH := 73
        
        ;MLO_DARK_MODE_BOTTOM_HEIGHT := 208 ; when taskbar not hidden 4k
        MLO_DARK_MODE_BOTTOM_HEIGHT := 123 ; when taskbar not hidden 2560
        ;MLO_DARK_MODE_BOTTOM_HEIGHT := 100 ; when taskbar hidden
        
        MLO_DARK_MODE_LEFT_WIDTH := 13
        
        if (isMloDashboardActive)
        {
            MLO_DARK_MODE_TOP_HEIGHT := 56
            MLO_DARK_MODE_BOTTOM_HEIGHT := 122 ; resolution 2560
        }
    }
}

setLaptopDependentMloVariables()

processMloEnhancements()
{
    If (inStr(lastActiveAppName, MLO_WINDOW_NAME, true) || inStr(lastActiveAppName, A_ScriptName, true)) ; needed because of overlay dark mode appearing 
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
            debugMloSync("IS_CONDITION_FOR_MLO_SYNC_FULFILLED")
            TimerSyncMloStep1_launchPing()
        }
    }
    else if (A_TickCount - MLO_LAST_TIME_SYNC > 6000000)
    {
        MLO_LAST_TIME_SYNC := A_TickCount
        debugMloSync("MLO_LAST_TIME_SYNC")
        SetTimer TimerSyncMloStep1_launchPing, 20000
    }
}

changeViewMlo(viewCombination, extraInstructions)
{
    sendKeyCombinationIndependentActiveModifiers("!/") ; unzoom
    sendKeyCombinationIndependentActiveModifiers("^+!-") ; schimb workspace taskuri focus
    sleep 50
    sendKeyCombinationIndependentActiveModifiers(viewCombination)
    sleep 400
    for index , instruction in extraInstructions
    {
        index := keyboardShortcuts[instruction]
        if (index)
        {
            processShortcut(index, instruction)
        }
        else 
        {
            If InStr(instruction, "sleep")
            {
                time := StrSplit(instruction, "_")[2]
                sleep %time%
            }
            else
            {
                sendKeyCombinationIndependentActiveModifiers(instruction)
            }
        }
        sleep 100
    }
}

mloCloseFind()
{
    sendKeyCombinationIndependentActiveModifiers("^+!-") ; schimb workspace taskuri focus
}

mloShowFind()
{
    sendKeyCombinationIndependentActiveModifiers("^+!=") ; schimb workspace all tasks
    sendKeyCombinationIndependentActiveModifiers("^+=") ; schimb view search
    sleep 1000
    sendKeyCombinationIndependentActiveModifiers("^+l") ; clear previous filter
    sleep 500
    ControlClick, TEdit1, A,,,, NA
    sleep 400
    if (!A_CaretX)
    {
        ControlClick, TEdit2, A,,,, NA
    }
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_EXPAND_ALL_TASKS)
    sendKeyCombinationIndependentActiveModifiers("{space}{space}")
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
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_TOGGLE_TASK_PROPERTIES_VIEW)
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
    send {ctrl down}
    setWinState(0)
    send {ctrl up}
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_RAPID_TASK_ENTRY)
    SetTimer TimerActivateMloRapidTaskWindow, 100
}

global TimeoutRapidTaskWindow := 0
timerActivateMloRapidTaskWindow()
{
    resetMloEnterMode(0)
    if (TimeoutRapidTaskWindow > 1000)
    {
        SetTimer TimerActivateMloRapidTaskWindow, OFF
        TimeoutRapidTaskWindow := 0
        return
    }
    If WinExist("Rapid Task Entry")
    {
        SetTimer TimerActivateMloRapidTaskWindow, OFF
        WinActivate ahk_class TfrmQuickAddMLOTask, , 2
        TimeoutRapidTaskWindow := 0
        WinMove, A,, 0, %MLO_POSITION_Y_RAPID_TASK_ENTRY%, (A_ScreenWidth), 500
    }
    else
    {
        TimeoutRapidTaskWindow := TimeoutRapidTaskWindow + 200
    }
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
        
        ; reselect mlo because overlay is not selected
        WinActivate ahk_class %MLO_CLASS_NAME%, , 1 
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
    setTimer TimerMloSendKeys, OFF
    IS_SORTING_VIEW_ACTIVE := 0
    if (IS_SET_MLO_ORDER_ACTIVE)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_TO_DO_MANUAL_SORTING)
        IS_SET_MLO_ORDER_ACTIVE := 0
    }

;   if (A_Hour > 19)
;   if (A_WDay = 1) ; sunday 
    if (number = 1 && modifiers = "^")
    {
        extraInstructions := ["{end}"]
    } 
    else if (number = 1 && modifiers = "^+")
    {
        extraInstructions := [MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS, "{home}", "{down}", "{down}"]
    }
    else if (number = 2 && modifiers = "^")
    {
        extraInstructions := [MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS, "{home}", "^a", MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_SHOW_LEVEL_1, "{end}"]
    }
    else if (number = 2 && modifiers = "^+")
    {
        IS_SORTING_VIEW_ACTIVE := 1
        extraInstructions := [MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS, "0", "+{end}", MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_SHOW_LEVEL_1, "{home}", MLO_KEYBOARD_SHORTCUT_MLO_SYNC]
    }
    else if (number = 2 && modifiers = "!^")
    {
        extraInstructions := [MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS, "{home}"]
    }
    else if (number = 5)
    {
        extraInstructions := ["{F12}"]
    }
    
    ; close dashboard windows if navigating away from it 
    if (number && modifiers)
    {
        setMloDarkMode(0)
        if (!inStr(lastActiveAppName, MLO_WINDOW_TASK_NAME, true))
        {
            WinClose A
        }
        setLaptopDependentMloVariables()
        setMloDarkMode(1)
    }
    
    MLO_LAST_VIEW := modifiers . number
    changeViewMlo(modifiers . number, extraInstructions)
}