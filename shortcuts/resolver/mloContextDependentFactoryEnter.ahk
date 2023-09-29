mloContextDependentEnter()
{
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        sendKeyCombinationIndependentActiveModifiers("<" . MLO_JOURNAL . ">{space}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_1JURNAL)
    {
        mloNewContextDependentEscape()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ENTER_AND_ESCAPE_SENDS_KEYS)
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}")
        processKeysAfter(TIMEOUT_KEYS_TO_SEND)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ENTER_GO_AFTER)
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}{F5}")
        sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
        sleep 400
        currentTask := getCurrentTask()
        mloNewContextDependentSubTask(currentTask)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_COPY_TEMPLATE)
    {
        duplicateCurrentTask()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_FOCUS_AREA)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        sleep 100
        sendKeyCombinationIndependentActiveModifiers(FOCUS_AREA . " ")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_DUAL_ACTIVE)
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}{F5}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{home}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ)
    {
        continueJournalTask("_BUCLA>")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ_CONTINUE)
    {
        continueJournalTask("_BUCLA>", "{END}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_FOCUS)
    {
        questions := INTREBARI_JURNAL[MLO_JOURNAL]
        if (INTREBARI_JURNAL_INDEX > questions.length())
        {
            INTREBARI_JURNAL_INDEX := 1
            sendKeyCombinationIndependentActiveModifiers("{enter}{F5}")
            sleep 400
            sendKeyCombinationIndependentActiveModifiers("{end}")
            resetMloEnterMode(0)
            currentTask := getCurrentTask()
            focusArea := getFocusArea(currentTask)
            if (focusArea = "66" && !inStr(currentTask, "<CANCEL>"))
            {
                mloNewContextDependentSubTask(currentTask)
            }
            return
        }
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        sendKeyCombinationIndependentActiveModifiers(questions[INTREBARI_JURNAL_INDEX])
        INTREBARI_JURNAL_INDEX += 1
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ESCAPE_AS_ENTER)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DEZVOLT_JURNAL)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        writeNextQuestion()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)    
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_PARTE_INCARCA)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}")
        sleep 150
        sendKeyCombinationIndependentActiveModifiers("{DOWN}{F2}{home}")
        sleep 150
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . " <PARTE>{SPACE}{SPACE}" . "{HOME}^{RIGHT 2}+{END}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_PARTE_CONSUMA
        INTREBARI_JURNAL_INDEX := 1
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_PARTE_CONSUMA)
    {
        createConsuma()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DIALOG)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}")
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . "" . INTREBARI_JURNAL_INDEX)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_COMPLETE_PREVIOUS)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_KEYS_AFTER)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_REVIN)
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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_REVIN_ACTIVE)
    {
        questions := INTREBARI_JURNAL["JURNAL_REVIN"]
        if (INTREBARI_JURNAL_INDEX > questions.length())
        {
            sendKeyCombinationIndependentActiveModifiers("{enter}{F5}")
            sleep 150
            sendKeyCombinationIndependentActiveModifiers("{home}{down}")
            sleep 300
            currentTask := getCurrentTask()
            MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_JURNAL_REVIN
            if (!inStr(currentTask, "==="))
            {
                mloNewContextDependentSubTask("")
            }
        }
        else
        {
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
            sendKeyCombinationIndependentActiveModifiers(questions[INTREBARI_JURNAL_INDEX])
            INTREBARI_JURNAL_INDEX += 1
        }
    }
    else
    {
        send {blind}{enter}
    }
}