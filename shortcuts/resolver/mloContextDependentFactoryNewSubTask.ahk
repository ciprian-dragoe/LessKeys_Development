mloNewContextDependentSubTask(currentTask)
{
    ;writeNowLogFile("mloNewContextDependentSubTask=" . currentTask)
    focusArea := getFocusArea(currentTask)
    if (inStr(currentTask, "<TIMER_SEND_KEYS_", true))
    {
        startTimerSendKeys(currentTask, MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<GO_TO_", true))
    {
        
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        if (MLO_ENTER_MODE != 0)
        {
            sleep 1200
        }
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_GO_TO
        sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
        sleep 100
        nextTask := getCurrentTask()
        if (nextTask = currentTask)
        {
            sleep 1000
        }
        mloNewContextDependentSubTask(nextTask)
    }
    else if (inStr(currentTask, "NEW_TASK_COMPLETE_PREVIOUS", true))
    {
        NUMBER_TASKS_COMPLETE := extractDestinationAfter(currentTask)
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_COMPLETE_PREVIOUS
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "0 DAU DRUMUL", true))
    {
        NUMBER_TASKS_COMPLETE := 1
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_COMPLETE_PREVIOUS
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<COPY_TEMPLATE", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_COPY_TEMPLATE
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
        sleep 100
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_FOLDER)
        sendKeyCombinationIndependentActiveModifiers("{F2}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{delete}")
    }
    else if (inStr(currentTask, "<ENTER_GO_AFTER_", true))
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_ENTER_GO_AFTER
    }
    else if (inStr(currentTask, "_BUCLA>", true))
    {
        ; old way kept if needed to come back
        /*
        StringGetPos, newLinePosition, currentTask, `r
        topic := SubStr(currentTask, InStr(currentTask, "_BUCLA>") + 8, newLinePosition-9)
        currentTask := SubStr(currentTask, 1, InStr(currentTask, "_BUCLA>") + 7)
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask, 1)
        INTREBARI_JURNAL_INDEX := 0
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_SHOW_LEVEL_1)
        sendKeyCombinationIndependentActiveModifiers("{DOWN}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
        sendKeyCombinationIndependentActiveModifiers("{F2}")
        sleep 150
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . " <PARTE>" . topic . "{HOME}^{RIGHT 2}+{END}")
        INTREBARI_JURNAL_INDEX := 1
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_PARTE_INCARCA
        */
        
        lines := StrSplit(currentTask, "`n")
        if (lines.MaxIndex() = 3) ; because last line in empty string based on how split works  
        {
            StringGetPos, newLinePosition, currentTask, `r
            topic := SubStr(currentTask, InStr(currentTask, "_BUCLA>") + 8, newLinePosition-9)
            currentTask := SubStr(currentTask, 1, InStr(currentTask, "_BUCLA>") + 7)
            TASK_GO_AFTER_TO := extractDestinationAfter(currentTask, 1)
            INTREBARI_JURNAL_INDEX := 0
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_SHOW_LEVEL_1)
            sendKeyCombinationIndependentActiveModifiers("{DOWN}")
            sleep 100
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
            sendKeyCombinationIndependentActiveModifiers("{F2}")
            sleep 150
            sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . " <PARTE>" . topic . "{HOME}^{RIGHT 2}+{END}")
            INTREBARI_JURNAL_INDEX := 1
            sendKeyCombinationIndependentActiveModifiers("{enter}")
            sleep 100 
            sendKeyCombinationIndependentActiveModifiers("{down}{F2}")
            sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . " <PARTE>" . topic . "{HOME}^{RIGHT 2}+{END}")
            sleep 150
            sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}")
            sleep 150
            sendKeyCombinationIndependentActiveModifiers("{up}")
            sleep 150
            INTREBARI_JURNAL_INDEX := 0
            MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DIALOG
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        }
        else
        {
            sendKeyCombinationIndependentActiveModifiers("{right}")
            sleep 700
            currentTask := getCurrentTask()
            sleep 100
            mloNewContextDependentSubTask(currentTask)
        }
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
        startJurnalMode(currentTask)
    }
    else if (inStr(currentTask, "<1JURNAL_", true))
    {
        startJurnalMode(currentTask)
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_1JURNAL
    }
    else if (inStr(currentTask, "<NEW_TASK_GO_AFTER", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<NEW_TASK_KEYS_AFTER_", true))
    {
        ;writeNowLogFile("NEW_TASK_KEYS_AFTER_")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_KEYS_AFTER
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<ONE_NEW_TASK_KEYS_AFTER_", true))
    {
        ;writeNowLogFile("ONE_NEW_TASK_KEYS_AFTER_")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_ONE_NEW_TASK_KEYS_AFTER
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<SEND_KEYS_", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_SEND_KEYS
        keys := extractDestinationAfter(currentTask)
        processKeysAfter(keys)
    }
    else if (inStr(currentTask, "<ESCAPE_AS_ENTER>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_ESCAPE_AS_ENTER
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_REVIN)
    {
        if (!inStr(currentTask, "==="))
        {
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
            questions := INTREBARI_JURNAL["JURNAL_REVIN"]
            INTREBARI_JURNAL_INDEX := 1
            sendKeyCombinationIndependentActiveModifiers(questions[INTREBARI_JURNAL_INDEX])
            INTREBARI_JURNAL_INDEX += 1
            MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_JURNAL_REVIN_ACTIVE
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_VIEW_LEVEL_NEW_TASK)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_VIEW_PLANIFIC_ZI && (focusArea = "61" || focusArea = "62" || focusArea = "63" || focusArea = "64" || focusArea = "65" || focusArea = "66"))
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        LESSON_COMPLETE_AMOUNT := focusArea - 60
    }
    else
    {
        MLO_ENTER_MODE := 0
        debug("*** mloNewContextDependentTask: " . currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
}
