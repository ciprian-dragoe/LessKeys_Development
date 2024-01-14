mloNewContextDependentTask(currentTask = "")
{
    focusArea := getFocusArea(currentTask)
    if (inStr(currentTask, "<TIMER_SEND_KEYS_", true))
    {
        startTimerSendKeys(currentTask, MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<POMODORO", true) || getPomodoroTimeFrom(currentTask))
    {
        SetTimer TimerDisplayPomodoroMessageReminders, off
        SetTimer TimerDisplayRemainingTime, off
        tooltip, , 0, 0, 5
        showtooltip("Stop Pomodoro Timer")
    }
    else if (inStr(currentTask, "_BUCLA>", true))
    {
        JOURNAL_QUESTION_INDEX := SubStr(currentTask, 1, 1) + 1
        PREVIOUS_TASK := JOURNAL_QUESTION_INDEX
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS)
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{HOME}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{DOWN}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_FOLDER)
        sleep 200
        Loop %JOURNAL_QUESTION_INDEX%
        {
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEXT_DAY_START_DATE)
        }
        sendKeyCombinationIndependentActiveModifiers("{F2}")
        sleep 50
        sendKeyCombinationIndependentActiveModifiers(JOURNAL_QUESTION_INDEX . "_BUCLA>  ")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ_CONTINUE
    }
    else if (inStr(currentTask, "<PARTE>", true))
    {
        index := SubStr(currentTask, 1, 1) + 4
        setMloDarkMode(0)
        setLaptopDependentMloVariables("dashboardActive")
        sleep 200
        setMloDarkMode(1)
        sleep 200
        sendKeyCombinationIndependentActiveModifiers("^+{F" . index . "}")
        WinWaitActive, %MLO_WINDOW_JOURNAL_NAME%, ,8
        WinMaximize, %MLO_WINDOW_JOURNAL_NAME%
        sleep 200
        sendKeyCombinationIndependentActiveModifiers("{home}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_JURNAL_DUAL_ACTIVE
    }
    else if (inStr(currentTask, "<GANDURI_EXPLOREZ>", true))
    {
        JOURNAL_QUESTION_INDEX := 1
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
        sendKeyCombinationIndependentActiveModifiers("{DOWN}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_FOLDER)
        sendKeyCombinationIndependentActiveModifiers("{F2}")
        sleep 50
        sendKeyCombinationIndependentActiveModifiers(JOURNAL_QUESTION_INDEX . "_BUCLA> " . "{space}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ
    }
    else if (MLO_ENTER_MODE > 0 && MLO_ENTER_MODE != MLO_ENTER_MODE_SET_AS_VIEW_PLANIFIC_ZI)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (focusArea)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        sleep 100
        if (focusArea - 70 >= 1 && focusArea - 70 <= 7)
        {
            focusArea := focusArea - 1
        }
        sendKeyCombinationIndependentActiveModifiers(focusArea . " ")
    }
    else
    {
        MLO_ENTER_MODE := 0
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
}
