mloContextDependentEnter()
{
    ;writeNowLogFile("mloContextDependentEnter")
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        sendKeyCombinationIndependentActiveModifiers("<" . MLO_JOURNAL . ">{space}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_1JURNAL)
    {
        mloNewContextDependentEscape()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_AFTER_TIMER_ENTER_AND_ESCAPE_SENDS_KEYS)
    {
        ;writeNowLogFile("MLO_ENTER_MODE_SET_AS_AFTER_TIMER_ENTER_AND_ESCAPE_SENDS_KEYS")
        ; to stop infinite recursion
        MLO_ENTER_MODE := 0
        sendKeyCombinationIndependentActiveModifiers("{enter}")
        ; to enable processKeysAfter 
        MLO_ENTER_MODE := 10000
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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_DUAL_ACTIVE)
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}{F5}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{home}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ)
    {
        continueJournalTask("_BUCLA> ")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ_CONTINUE)
    {
        continueJournalTask("_BUCLA> ", "{END}")
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
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX . " <PARTE>" . "{HOME}^{RIGHT 2}+{END}")
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
        ;writeNowLogFile("MLO_ENTER_MODE_SET_AS_NEW_TASK_KEYS_AFTER")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ONE_NEW_TASK_KEYS_AFTER)
    {
        ;writeNowLogFile("MLO_ENTER_MODE_SET_AS_ONE_NEW_TASK_KEYS_AFTER")
        if (A_CaretX)
        {
            sendKeyCombinationIndependentActiveModifiers("{enter}")
            processKeysAfter(TASK_GO_AFTER_TO)
        }
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_REVIN)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_REVIN_ACTIVE)
    {
        questions := INTREBARI_JURNAL["JURNAL_REVIN"]
        if (INTREBARI_JURNAL_INDEX > questions.length())
        {
            sendKeyCombinationIndependentActiveModifiers("{enter}{F5}")
            sleep 500
            sendKeyCombinationIndependentActiveModifiers("{home}{down 3}")
            sleep 500
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
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_VIEW_LEVEL_NEW_TASK)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_VIEW_PLANIFIC_ZI && LESSON_COMPLETE_AMOUNT > 0)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else
    {
        send {blind}{enter}
    }
}