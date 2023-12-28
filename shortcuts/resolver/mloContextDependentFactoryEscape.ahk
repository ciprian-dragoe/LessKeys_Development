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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JOURNAL || MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JOURNAL_ASK_QUESTIONS)
    {
        if (DOUBLE_PRESS_KEY_ACTIVE)
        {
            DOUBLE_PRESS_KEY_ACTIVE := 0
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerNextJournalQuestion, off
            sendKeyCombinationIndependentActiveModifiers("{ESCAPE}")
            sleep 100
            sendKeyCombinationIndependentActiveModifiers(PREVIOUS_TASK)
            resetMloEnterMode(0)
        }
        else
        {
            DOUBLE_PRESS_KEY_ACTIVE := 1
            JOURNAL_QUESTION_INDEX := 1
            setTimer TimerDoubleKeyPressInterval, off
            setTimer TimerDoubleKeyPressInterval, 800
            setTimer TimerNextJournalQuestion, off
            setTimer TimerNextJournalQuestion, 600
            sendKeyCombinationIndependentActiveModifiers("{ENTER}")
            MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_JOURNAL_ASK_QUESTIONS
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
            JOURNAL_QUESTION_INDEX := Mod(JOURNAL_QUESTION_INDEX + 1, 2)
            sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . JOURNAL_QUESTION_INDEX . "" . JOURNAL_QUESTION_INDEX . "{DOWN}")
            DOUBLE_PRESS_KEY_ACTIVE := 0
            resetMloEnterMode()
            return
        }
        setTimer TimerDoubleKeyPressInterval, 600
        DOUBLE_PRESS_KEY_ACTIVE := 1
        sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}^+.")
        sleep 100
        JOURNAL_QUESTION_INDEX := Mod(JOURNAL_QUESTION_INDEX + 1, 2)
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . JOURNAL_QUESTION_INDEX . "" . JOURNAL_QUESTION_INDEX)
        
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_KEYS_AFTER || MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ONE_NEW_TASK_KEYS_AFTER)
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