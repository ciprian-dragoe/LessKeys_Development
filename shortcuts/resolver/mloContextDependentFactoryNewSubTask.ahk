mloNewContextDependentSubTask(currentTask)
{
    ;writeNowLogFile("mloNewContextDependentSubTask=" . currentTask)
    focusArea := getFocusArea(currentTask)
    if (inStr(currentTask, "<TIMER_SEND_KEYS_", true))
    {
        startTimerSendKeys(currentTask, MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "_BUCLA>", true))
    {
        ; old way kept if needed to come back
        /*
        StringGetPos, newLinePosition, currentTask, `r
        topic := SubStr(currentTask, InStr(currentTask, "_BUCLA>") + 8, newLinePosition-9)
        currentTask := SubStr(currentTask, 1, InStr(currentTask, "_BUCLA>") + 7)
        TASK_GO_AFTER_TO := extractDestinationAfter(currentTask, 1)
        JOURNAL_QUESTION_INDEX := 0
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_SHOW_LEVEL_1)
        sendKeyCombinationIndependentActiveModifiers("{DOWN}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
        sendKeyCombinationIndependentActiveModifiers("{F2}")
        sleep 150
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . JOURNAL_QUESTION_INDEX . " <PARTE>" . topic . "{HOME}^{RIGHT 2}+{END}")
        JOURNAL_QUESTION_INDEX := 1
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_PARTE_INCARCA
        */
        
        lines := StrSplit(currentTask, "`n")
        if (lines.MaxIndex() = 3) ; because last line in empty string based on how split works  
        {
            StringGetPos, newLinePosition, currentTask, `r
            topic := SubStr(currentTask, InStr(currentTask, "_BUCLA>") + 8, newLinePosition-9)
            currentTask := SubStr(currentTask, 1, InStr(currentTask, "_BUCLA>") + 7)
            TASK_GO_AFTER_TO := extractDestinationAfter(currentTask, 1)
            JOURNAL_QUESTION_INDEX := 0
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_SHOW_LEVEL_1)
            sendKeyCombinationIndependentActiveModifiers("{DOWN}")
            sleep 100
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
            sendKeyCombinationIndependentActiveModifiers("{F2}")
            sleep 150
            sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . JOURNAL_QUESTION_INDEX . " <PARTE>" . topic . "{HOME}^{RIGHT 2}+{END}")
            JOURNAL_QUESTION_INDEX := 1
            sendKeyCombinationIndependentActiveModifiers("{enter}")
            sleep 100 
            sendKeyCombinationIndependentActiveModifiers("{down}{F2}")
            sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . JOURNAL_QUESTION_INDEX . " <PARTE>" . topic . "{HOME}^{RIGHT 2}+{END}")
            sleep 150
            sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}")
            sleep 150
            sendKeyCombinationIndependentActiveModifiers("{up}")
            sleep 150
            JOURNAL_QUESTION_INDEX := 0
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
        JOURNAL_QUESTION_INDEX := SubStr(currentTask, 2, 1)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DIALOG
    }
    else if (inStr(currentTask, "<CANCEL>", true))
    {
        resetMloEnterMode()
    }
    else if (inStr(currentTask, "<GANDURI_EXPLOREZ>", true))
    {
        JOURNAL_QUESTION_INDEX := 1
        createJournalTask("_BUCLA> ")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ
    }
    else if (inStr(currentTask, "<NEW_TASK>", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (inStr(currentTask, "<JOURNAL_", true))
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_SHOW_LEVEL_1)
        positionStart := InStr(currentTask, "<") + 1
        positionEnd := InStr(currentTask, ">")
        journal := SubStr(currentTask, positionStart, positionEnd - positionStart)
        splits := StrSplit(journal, "_")
        if (splits.Count() = 3)
        {
            MLO_JOURNAL := extractDestinationAfter(currentTask, 1)
            TASK_GO_AFTER_TO := extractDestinationAfter(currentTask)
        }
        else
        {
            MLO_JOURNAL := extractDestinationAfter(currentTask)
            TASK_GO_AFTER_TO := 0
        }
        PREVIOUS_TASK := SubStr(currentTask, 1, InStr(currentTask, " ") - 1)
        openNotesAssociatedWithTask()
        sendKeyCombinationIndependentActiveModifiers("^a")
        sendKeyCombinationIndependentActiveModifiers("^c")
        sleep 200
        hideNotesAndFocusTasks()
        questions := CLIPBOARD
        ;showtooltip(questions, 2000)
        setJournalTopics(questions, MLO_JOURNAL)
        JOURNAL_QUESTION_INDEX := 1
        JOURNAL_GROUP_INDEX := 1
        JOURNAL_LAST_INDEX := 0
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)    
        sendKeyCombinationIndependentActiveModifiers("<" . MLO_JOURNAL . ">{space}")    
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_JOURNAL
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
    else if (inStr(currentTask, "<POMODORO", true))
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_POMODORO
        MLO_ENTER_MODE_SET_AS_POMODORO_INDEX := 0
        describePomodoroStep(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_VIEW_LEVEL_NEW_TASK)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_VIEW_PLANIFIC_ZI && (focusArea = "71" || focusArea = "72" || focusArea = "73" || focusArea = "74" || focusArea = "75" || focusArea = "76" || focusArea = "77"))
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        LESSON_COMPLETE_AMOUNT := focusArea - 70
    }
    else if (focusArea && focusArea != "71" && focusArea != "72" && focusArea != "73" && focusArea != "74" && focusArea != "75" && focusArea != "76" && focusArea != "77" && focusArea != "66" && focusArea != "65" && focusArea != "64" && focusArea != "63" && focusArea != "62" && focusArea != "61")
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_POMODORO
        MLO_ENTER_MODE_SET_AS_POMODORO_INDEX := 0
        describePomodoroStep(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else
    {
        MLO_ENTER_MODE := 0
        debug("*** mloNewContextDependentTask: " . currentTask)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
}
