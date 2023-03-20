mloNewContextDependentSubTask(currentTask)
{
    if (inStr(currentTask, "<GO_TO_", true))
    {
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        if (MLO_ENTER_MODE != 0)
        {
            sleep 1200
        }
        sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
        sleep 100
        nextTask := getCurrentTask()
        if (nextTask = currentTask)
        {
            showtooltip("match")
            sleep 1000
        }
        mloNewContextDependentSubTask(nextTask)
    }
    else if (inStr(currentTask, "<CER_AJUTOR_", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DOUBLE_ESCAPE_GO_TO
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        newBrainStormTask(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<TOPIC_DELIMITER>", true))
    {
        mloAddJournalDelimiterSubTask()
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_OPEN_NOTES
    }
    else if (inStr(currentTask, "<NEW_TASK_DO_AFTER_", true))
    {
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask, 1)
        BUFFER := extractDestinationAfter(currentTask)
        newBrainStormTask(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_CHANGE_VIEW
    }
    else if (inStr(currentTask, "_BUCLA>", true))
    {
        currentTask := SubStr(currentTask, 1, InStr(currentTask, "_BUCLA>") + 7)
        
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask, 1)
        INTREBARI_JURNAL_INDEX := 0
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_SHOW_FIRST_LEVEL)
        sendKeyCombinationIndependentActiveModifiers("{DOWN}{F2}")
        sleep 150
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . " <PARTE>{SPACE}CONFUZA^+{LEFT}")
        INTREBARI_JURNAL_INDEX := 1
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_PARTE_INCARCA
    }
    else if (inStr(currentTask, "_DIALOG>", true))
    {
        index := SubStr(currentTask, 1, 1) + 4
        setMloDarkMode(0)
        setLaptopDependentMloVariables("dashboardActive")
        sendKeyCombinationIndependentActiveModifiers("^+{F" . index . "}")
        WinWaitActive, %MLO_WINDOW_JOURNAL_NAME%, ,2
        setMloDarkMode(1, MLO_DASHBOARD_CLASS_NAME)
        sendKeyCombinationIndependentActiveModifiers("{home}{down}")
        sleep 200
        currentTask := getCurrentTask()
        if (inStr(currentTask, "<|>", true))
        {
            definePartsDualJournal(currentTask)
        }
        else
        {
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
            MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_JURNAL_DUAL_ACTIVE
        }
    }
    else if (inStr(currentTask, "<|>"))
    {
        definePartsDualJournal(currentTask)
    }
    else if (inStr(currentTask, "<PARTE>", true))
    {
        newPart(currentTask)
    }
    else if (inStr(currentTask, "<ESCAPE>", true))
    {
        resetMloEnterMode()
    }
    else if (inStr(currentTask, "<DIALOG_GANDURI>", true))
    {
        INTREBARI_JURNAL_INDEX := 1
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_JURNAL_DUAL
        createJournalTask("_DIALOG>")
    }
    else if (inStr(currentTask, "<GANDURI_EXPLOREZ>", true))
    {
        INTREBARI_JURNAL_INDEX := 1
        createJournalTask("_BUCLA>")
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
