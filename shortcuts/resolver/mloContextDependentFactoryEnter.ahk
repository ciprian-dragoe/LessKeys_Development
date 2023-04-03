mloContextDependentEnter()
{
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_JURNAL)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        sendKeyCombinationIndependentActiveModifiers("<" . MLO_JOURNAL . ">{space}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_DUAL)
    {
        continueJournalTask("_DIALOG> =====================")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_DUAL_ACTIVE)
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}{F5}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{home}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ)
    {
        continueJournalTask("_BUCLA> =====================")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ_CONTINUE)
    {
        continueJournalTask("_BUCLA> =====================", "{END}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_DUAL_CONTINUE)
    {
        continueJournalTask("_DIALOG> =====================", "{END}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ESCAPE_AS_ENTER || MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DOUBLE_ESCAPE_GO_TO)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_DEZVOLT_JURNAL)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        writeNextQuestion()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_OPEN_NOTES)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}")
        openNotesAssociatedWithTask()
        MLO_ENTER_MODE := 0
    }
    
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)    
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_PARTE_INCARCA)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
        sleep 150
        sendKeyCombinationIndependentActiveModifiers("{DOWN}{F2}")
        sleep 150
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . " <PARTE>{SPACE}RESURSA^+{LEFT}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_PARTE_CONSUMA
        INTREBARI_JURNAL_INDEX := 1
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_PARTE_CONSUMA)
    {
        createConsuma()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_DUAL_PARTI_DEFINESC)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{tab}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{home}")
        sleep 200
        currentTask := getCurrentTask()
        if (!currentTask)
        {
            currentTask := "<|> PARTE" ; strange bug in MLO where sometimes view is not changed
        }
        if (inStr(currentTask, "<|>"))
        {
            mloNewContextDependentTask(currentTask)    
        }
        else
        {
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
            MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_JURNAL_DUAL_ACTIVE
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DIALOG)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}")
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . "" . INTREBARI_JURNAL_INDEX)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_CHANGE_VIEW)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)    
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_KEYS_AFTER)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_COPY_GO_AFTER)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            DOUBLE_PRESS_KEY_ACTIVE := 0
            setTimer TimerCopyMloTaskPhase1, off
            setTimer TimerCopyMloTaskPhase2, off
            setTimer TimerCopyMloTaskPhase3, off
            setTimer TimerCopyMloTaskClear, off
            setTimer TimerDoubleKeyPressInterval, off
            resetMloEnterMode()
        }
        else
        {
            DOUBLE_PRESS_KEY_ACTIVE := 1
            setTimer TimerCopyMloTaskClear, off
            setTimer TimerCopyMloTaskClear, 10000
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerDoubleKeyPressInterval, 1000
            TimerCopyMloTaskPhase1()
        }
    }
    else
    {
        send {blind}{enter}
    }
}