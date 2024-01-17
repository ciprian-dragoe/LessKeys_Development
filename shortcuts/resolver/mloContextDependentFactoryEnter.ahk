mloContextDependentEnter()
{
    ;writeNowLogFile("mloContextDependentEnter")
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JOURNAL)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
        sendKeyCombinationIndependentActiveModifiers("<" . MLO_JOURNAL . ">{space}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_AFTER_TIMER_ENTER_AND_ESCAPE_SENDS_KEYS)
    {
        ;writeNowLogFile("MLO_ENTER_MODE_SET_AS_AFTER_TIMER_ENTER_AND_ESCAPE_SENDS_KEYS")
        ; to stop infinite recursion
        MLO_ENTER_MODE := 0
        sendKeyCombinationIndependentActiveModifiers("{enter}")
        ; to enable processKeysAfter 
        MLO_ENTER_MODE := 10000
        ;showtooltip(TIMEOUT_KEYS_TO_SEND)
        processKeysAfter(TIMEOUT_KEYS_TO_SEND)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JURNAL_DUAL_ACTIVE)
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}{F5}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{home}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_POMODORO)
    {
        describePomodoroStep("{enter}" . MLO_KEYBOARD_SHORTCUT_FOLDER . MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_POMODORO)
    {
        describePomodoroStep("{enter}" . MLO_KEYBOARD_SHORTCUT_FOLDER . MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_POMODORO_START)
    {
        startPomodoroTimer()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_POMODORO_FOLLOW_UP)
    {
        describePomodoroFollowUpStep(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_POMODORO_FOLLOW_UP_FINISH)
    {
        finishPomodoro()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ)
    {
        continueJournalTask("_BUCLA> ")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ_CONTINUE)
    {
        continueJournalTask("_BUCLA> ", "{END}")
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_ESCAPE_AS_ENTER)
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_JOURNAL_ASK_QUESTIONS)
    {
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
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . JOURNAL_QUESTION_INDEX . " <PARTE>" . "{HOME}^{RIGHT 2}+{END}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_PARTE_CONSUMA
        JOURNAL_QUESTION_INDEX := 1
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_PARTE_CONSUMA)
    {
        createConsuma()
    }
    else if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_DIALOG)
    {
        sendKeyCombinationIndependentActiveModifiers("{ENTER}{F5}")
        sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . JOURNAL_QUESTION_INDEX . "" . JOURNAL_QUESTION_INDEX)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
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