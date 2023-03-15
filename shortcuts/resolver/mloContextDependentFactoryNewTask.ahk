mloNewContextDependentTask(currentTask = "")
{
    focusArea := getFocusArea(currentTask)
    if (focusArea)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        sleep 100
        sendKeyCombinationIndependentActiveModifiers(focusArea . " ")
        return
    }
    else if (inStr(currentTask, "<JURNAL_DUAL>", true))
    {
        startJournalTask(MLO_ENTER_MODE_SET_AS_JURNAL_DUAL)
    }
    else if (inStr(currentTask, "<JURNAL_", true))
    {
        MLO_JOURNAL := extractDestinationAfter(currentTask, 2)
        PREVIOUS_TASK := extractDestinationAfter(currentTask, 1)
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)    
        sendKeyCombinationIndependentActiveModifiers("<" . MLO_JOURNAL . ">{space}")    
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_JURNAL
    }
    else if (inStr(currentTask, "_BUCLA>", true))
    {
        INTREBARI_JURNAL_INDEX := SubStr(currentTask, 1, 1) + 1
        PREVIOUS_TASK := INTREBARI_JURNAL_INDEX
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS)
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{HOME}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{DOWN}")
        sleep 200
        Loop %INTREBARI_JURNAL_INDEX%
        {
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEXT_DAY_START_DATE)
        }
        sendKeyCombinationIndependentActiveModifiers("{F2}")
        sleep 50
        sendKeyCombinationIndependentActiveModifiers(INTREBARI_JURNAL_INDEX . "_BUCLA>" . "{SPACE}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ_CONTINUE
    }
    else if (inStr(currentTask, "<S>", true))
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<PARTE>", true))
    {
        newPart(currentTask)
    }
    else if (inStr(currentTask, "<GANDURI_EXPLOREZ>", true))
    {
        startJournalTask(MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ)
    }
    else if (MLO_ENTER_MODE > 0)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else
    {
        MLO_ENTER_MODE := 0
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
}
