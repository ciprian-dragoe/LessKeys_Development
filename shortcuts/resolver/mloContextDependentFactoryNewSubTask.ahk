mloNewContextDependentSubTask(currentTask)
{
    if (inStr(currentTask, "<TIMER_SEND_KEYS_", true))
    {
        timerTimeout := extractDestinationAfter(currentTask, 1) * 1000
        TIMEOUT_KEYS_TO_SEND := extractDestinationAfter(currentTask)
        SetTimer TimerMloSendKeys, OFF
        SetTimer TimerMloSendKeys, %timerTimeout%
        
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_COLLAPSE_ALL_TASKS)
        sleep 150
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_TOGGLE_COLLAPSE_ALL_CHILDREN)
        sleep 150
        sendKeyCombinationIndependentActiveModifiers("{DOWN}")
        sleep 300
        currentTask := getCurrentTask()
        mloNewContextDependentSubTask(currentTask)
    }
    else if (inStr(currentTask, "<GO_TO_", true))
    {
        
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        if (MLO_ENTER_MODE != 0)
        {
            sleep 1200
        }
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_GO_TO
        sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
        sleep 100
        nextTask := getCurrentTask()
        if (nextTask = currentTask)
        {
            sleep 1000
        }
        mloNewContextDependentSubTask(nextTask)
    }
    else if (inStr(currentTask, "<ENTER_GO_AFTER_", true))
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_ENTER_GO_AFTER
    }
    else if (inStr(currentTask, "_BUCLA>", true))
    {
        StringGetPos, newLinePosition, currentTask, `r
        topic := SubStr(currentTask, InStr(currentTask, "_BUCLA>") + 8, newLinePosition-9)
        currentTask := SubStr(currentTask, 1, InStr(currentTask, "_BUCLA>") + 7)
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask, 1)
        INTREBARI_JURNAL_INDEX := 0
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_SHOW_LEVEL_1)
        sendKeyCombinationIndependentActiveModifiers("{DOWN}{F2}")
        sleep 150
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . " <PARTE>{SPACE}" . topic . "{HOME}^{RIGHT 2}+{END}")
        INTREBARI_JURNAL_INDEX := 1
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_PARTE_INCARCA
    }
    else if (inStr(currentTask, "<PARTE>", true))
    {
        TASK_GO_AFTER_TO := SubStr(currentTask, 1, 1)
        INTREBARI_JURNAL_INDEX := SubStr(currentTask, 2, 1)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DIALOG
    }
    else if (inStr(currentTask, "<CANCEL>", true))
    {
        if (MLO_ENTER_MODE > 0) 
        {
            MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_CANCEL
            resetMloEnterMode()    
        }
        else
        {
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        }
    }
    else if (inStr(currentTask, "<GANDURI_EXPLOREZ>", true))
    {
        INTREBARI_JURNAL_INDEX := 1
        createJournalTask("_BUCLA> ")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ
    }
    else if (inStr(currentTask, "<NEW_TASK>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<JURNAL_", true))
    {
        positionStart := InStr(currentTask, "<") + 1
        positionEnd := InStr(currentTask, ">")
        result := SubStr(currentTask, positionStart, positionEnd - positionStart)
        splits := StrSplit(result, "_")
        if (splits.Count() = 4)
        {
            MLO_JOURNAL := extractDestinationAfter(currentTask, 2)
            PREVIOUS_TASK := extractDestinationAfter(currentTask, 1)
            TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)    
        }
        else
        {
            MLO_JOURNAL := extractDestinationAfter(currentTask, 1)
            PREVIOUS_TASK := extractDestinationAfter(currentTask)
            TASK_GO_AFTER_TO := "{DOWN}"
        }
        
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)    
        sendKeyCombinationIndependentActiveModifiers("<" . MLO_JOURNAL . ">{space}")    
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_JURNAL
    }
    else if (inStr(currentTask, "<NEW_TASK_GO_AFTER", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<NEW_TASK_KEYS_AFTER_", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_KEYS_AFTER
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<SEND_KEYS_", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_SEND_KEYS
        keys := extractDestinationAfter(currentTask)
        processKeysAfter(keys)
    }
    else if (inStr(currentTask, "<COPY_GO_AFTER", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_COPY_GO_AFTER
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<ESCAPE_AS_ENTER>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_ESCAPE_AS_ENTER
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else
    {
        MLO_ENTER_MODE := 0
        debug("*** mloNewContextDependentTask: " . currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
}
