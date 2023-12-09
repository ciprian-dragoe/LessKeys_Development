mloNewContextDependentEscape()
{
    ;writeNowLogFile("mloNewContextDependentEscape")
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK)
    {
        send {blind}{enter}{escape}
        MLO_ENTER_MODE := 0
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_AFTER_TIMER_ENTER_AND_ESCAPE_SENDS_KEYS)
    {
        ;writeNowLogFile("MLO_ENTER_MODE_SET_AS_AFTER_TIMER_ENTER_AND_ESCAPE_SENDS_KEYS")
        ; to stop infinite recursion
        MLO_ENTER_MODE := 0
        sendKeyCombinationIndependentActiveModifiers("{enter}")
        sendKeyCombinationIndependentActiveModifiers("{escape}")
        ; to enable processKeysAfter 
        MLO_ENTER_MODE := 10000
        processKeysAfter(TIMEOUT_KEYS_TO_SEND)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JOURNAL || MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DEZVOLT_JURNAL || MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_1JOURNAL)
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
            INTREBARI_JURNAL_INDEX := 1
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerDoubleKeyPressInterval, 800
            setTimer TimerGoToNextQuestion, off
            setTimer TimerGoToNextQuestion, 600
            sendKeyCombinationIndependentActiveModifiers("{ENTER}")
            MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DEZVOLT_JURNAL
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_COMPLETE_PREVIOUS)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            DOUBLE_PRESS_KEY_ACTIVE := 0
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerCompletePrevious, off
            resetMloEnterMode(0)
        }
        else
        {
            DOUBLE_PRESS_KEY_ACTIVE := 1
            setTimer TimerDoubleKeyPressInterval, 800
            setTimer TimerCompletePrevious, 600
            sendKeyCombinationIndependentActiveModifiers("{ENTER}")
        }
    }
    else if (LESSON_COMPLETE_AMOUNT > 0)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            DOUBLE_PRESS_KEY_ACTIVE := 0
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerCompleteLesson, off
            resetMloEnterMode(0)
        }
        else
        {
            DOUBLE_PRESS_KEY_ACTIVE := 1
            setTimer TimerDoubleKeyPressInterval, 800
            setTimer TimerCompleteLesson, 600
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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_COPY_TEMPLATE)
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_EXPAND_ALL_TASKS)
        resetMloEnterMode()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_DUAL_ACTIVE)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            setTimer TimerDoubleKeyPressInterval, off
            DOUBLE_PRESS_KEY_ACTIVE := 0
            sendKeyCombinationIndependentActiveModifiers("{backspace}{enter}")
            sleep 100
            sendKeyCombinationIndependentActiveModifiers("{tab}")
            sleep 200
            sendKeyCombinationIndependentActiveModifiers("{down}{home}{F5}")
            resetMloEnterMode()
            return
        }
        setTimer TimerDoubleKeyPressInterval, 600
        DOUBLE_PRESS_KEY_ACTIVE := 1
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{backspace}{enter}{tab}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{home}{F5}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ)
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEXT_DAY_START_DATE)
        sleep 500
        
        sendKeyCombinationIndependentActiveModifiers("1")
        sleep 1000
        currentTask := getCurrentTask()
        mloNewContextDependentSubTask(currentTask)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ_CONTINUE)
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEXT_DAY_START_DATE)
        sleep 500
        sendKeyCombinationIndependentActiveModifiers("{end}")
        sleep 1000
        currentTask := getCurrentTask()
        mloNewContextDependentSubTask(currentTask)
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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_FOCUS)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}")
        sleep 400
        sendKeyCombinationIndependentActiveModifiers("{end}")
        
        /*
        currentTask := getCurrentTask()
        area := getFocusArea(currentTask)
        if (area = "66")
        {
            mloNewContextDependentSubTask(currentTask)
            return
        }
        */
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
            setTimer TimerDoubleKeyPressInterval, 900
            setTimer TimerGoToMloTask, off
            setTimer TimerGoToMloTask, 800
            sendKeyCombinationIndependentActiveModifiers("{enter}{f5}{escape}")
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_KEYS_AFTER)
    {
        ;writeNowLogFile("MLO_ENTER_MODE_SET_AS_NEW_TASK_KEYS_AFTER")
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            DOUBLE_PRESS_KEY_ACTIVE := 0
            setTimer TimerDoubleKeyPressInterval, off
            resetMloEnterMode(0)
            sendKeyCombinationIndependentActiveModifiers("{enter}")
        } 
        else if (A_CaretX)
        {
            sendKeyCombinationIndependentActiveModifiers("{enter}")
            DOUBLE_PRESS_KEY_ACTIVE := 1
            setTimer TimerDoubleKeyPressInterval, 1500
            processKeysAfter(TASK_GO_AFTER_TO)
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ONE_NEW_TASK_KEYS_AFTER)
    {
        ;writeNowLogFile("MLO_ENTER_MODE_SET_AS_ONE_NEW_TASK_KEYS_AFTER")
        if (A_CaretX)
        {
            sendKeyCombinationIndependentActiveModifiers("{enter}")
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_EVENIMENTE_REFLECT)
    {
        if (A_CaretX)
        {
            sendKeyCombinationIndependentActiveModifiers("{enter}")
            sleep 600
            sendKeyCombinationIndependentActiveModifiers("{home}{down 5}")
            mloNewContextDependentSubTask("")
        }
        else
        {
            sendKeyCombinationIndependentActiveModifiers("{escape}")
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_EVENIMENTE_REFLECT_ACTIVE)
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}{F5}")
        sleep 150
        sendKeyCombinationIndependentActiveModifiers("{home}{down 5}")
        resetMloEnterMode()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_VIEW_LEVEL_NEW_TASK)
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_VIEW_PLANIFIC_ZI)
    {
        sendKeyCombinationIndependentActiveModifiers("{escape}")
    }
    else
    {
        resetMloEnterMode()
    }
}