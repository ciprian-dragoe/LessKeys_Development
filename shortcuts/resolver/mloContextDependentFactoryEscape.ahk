mloNewContextDependentEscape()
{
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK)
    {
        send {blind}{enter}{escape}
        MLO_ENTER_MODE := 0
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_JURNAL || MLO_ENTER_MODE = MLO_ENTER_MODE_SET_DEZVOLT_JURNAL)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            DOUBLE_PRESS_KEY_ACTIVE := 0
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerGoToNextQuestion, off
            sendKeyCombinationIndependentActiveModifiers("{ESCAPE}")
            sleep 100
            sendKeyCombinationIndependentActiveModifiers(PREVIOUS_TASK)
            resetMloEnterMode(0)
        }
        else
        {
            DOUBLE_PRESS_KEY_ACTIVE := 1
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerDoubleKeyPressInterval, 800
            setTimer TimerGoToNextQuestion, off
            setTimer TimerGoToNextQuestion, 600
            sendKeyCombinationIndependentActiveModifiers("{ENTER}")
            MLO_ENTER_MODE := MLO_ENTER_MODE_SET_DEZVOLT_JURNAL
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DOUBLE_ESCAPE_GO_TO)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            DOUBLE_PRESS_KEY_ACTIVE := 0
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerGoToNextQuestion, off
            sendKeyCombinationIndependentActiveModifiers("{ESCAPE}")
            sleep 100
            sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
            sleep 300
            resetMloEnterMode(0)
            currentTask := getCurrentTask()
            mloNewContextDependentSubTask(currentTask)
        }
        else
        {
            DOUBLE_PRESS_KEY_ACTIVE := 1
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerDoubleKeyPressInterval, 800
            sendKeyCombinationIndependentActiveModifiers("{ENTER}")
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DIALOG)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            setTimer TimerDoubleKeyPressInterval, off
            sendKeyCombinationIndependentActiveModifiers("{escape}")
            INTREBARI_JURNAL_INDEX := Mod(INTREBARI_JURNAL_INDEX + 1, 2)
            sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . "" . INTREBARI_JURNAL_INDEX . "{DOWN}")
            DOUBLE_PRESS_KEY_ACTIVE := 0
            resetMloEnterMode()
            return
        }
        setTimer TimerDoubleKeyPressInterval, 600
        DOUBLE_PRESS_KEY_ACTIVE := 1
        sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}^+.")
        sleep 100
        INTREBARI_JURNAL_INDEX := Mod(INTREBARI_JURNAL_INDEX + 1, 2)
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . "" . INTREBARI_JURNAL_INDEX)
        
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_DUAL_ACTIVE)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            setTimer TimerDoubleKeyPressInterval, off
            sendKeyCombinationIndependentActiveModifiers("{enter}{F5}")
            sleep 100
            DOUBLE_PRESS_KEY_ACTIVE := 0
            resetMloEnterMode()
            sendKeyCombinationIndependentActiveModifiers("{home}{down}")
            return
        }
        setTimer TimerDoubleKeyPressInterval, 600
        DOUBLE_PRESS_KEY_ACTIVE := 1
        sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}{tab}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{home}{down}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ)
    {
        lastJournalTask("l")
        sleep 500
        sendKeyCombinationIndependentActiveModifiers("1")
        sleep 1000
        mloNewContextDependentSubTask("1_BUCLA>")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_DUAL || MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_DUAL_CONTINUE)
    {
        lastJournalTask("l")
        resetMloEnterMode()
        sleep 400
        sendKeyCombinationIndependentActiveModifiers("{home}{end}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ_CONTINUE)
    {
        lastJournalTask("{BackSpace}{BackSpace}{BackSpace}l{enter}")
        
        if (PREVIOUS_TASK != INTREBARI_JURNAL_INDEX)
        {
            sleep 500
            sendKeyCombinationIndependentActiveModifiers(PREVIOUS_TASK)
            sleep 1000
            mloNewContextDependentSubTask("" . PREVIOUS_TASK . "_BUCLA>")
        }
        else
        {
            sendKeyCombinationIndependentActiveModifiers("{HOME}")
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_CHANGE_VIEW)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}")
        number := SubStr(TASK_GO_AFTER_TO, 0, 1)
        modifiers := SubStr(TASK_GO_AFTER_TO, 1, StrLen(combination)-1)
        resetMloEnterMode()
        changeViewMloFactory(number, modifiers)
        if (BUFFER)
        {
            sleep 800
            sendKeyCombinationIndependentActiveModifiers(BUFFER)
            sleep 200
            currentTask := getCurrentTask()
            mloNewContextDependentSubTask(currentTask)
        }        
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_PARTE_INCARCA)
    {
        resetMloEnterMode()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_PARTE_CONSUMA)
    {
        createConsuma()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ESCAPE_AS_ENTER)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}")
        resetMloEnterMode()   
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            DOUBLE_PRESS_KEY_ACTIVE := 0
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerGoToMloTask, off
            resetMloEnterMode()
        }
        else
        {
            DOUBLE_PRESS_KEY_ACTIVE := 1
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerDoubleKeyPressInterval, 800
            setTimer TimerGoToMloTask, off
            setTimer TimerGoToMloTask, 600
            sendKeyCombinationIndependentActiveModifiers("{enter}{f5}{escape}")
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_KEYS_AFTER)
    {
        if (A_CaretX)
        {
            sendKeyCombinationIndependentActiveModifiers("{enter}")
        }
        keys := StrSplit(TASK_GO_AFTER_TO, "|")
        for index, key in keys
        {
            if (StrLen(key) > 1)
            {
                key := "{" . key . "}"
            }
            sendKeyCombinationIndependentActiveModifiers(key)
            sleep 100
        }
        resetMloEnterMode()
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
            Clipboard := "DO NOT COPY PREVIOUS TASK"
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerDoubleKeyPressInterval, 700
            setTimer TimerCopyMloTaskPhase2, off
            setTimer TimerCopyMloTaskPhase2, 250
            setTimer TimerCopyMloTaskClear, off
            setTimer TimerCopyMloTaskClear, 10000
        }
    }
    else
    {
        resetMloEnterMode()
    }
}