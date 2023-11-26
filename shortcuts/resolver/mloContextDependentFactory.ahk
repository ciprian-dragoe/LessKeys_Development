#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\mloContextDependentFactoryEscape.ahk
#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\mloContextDependentFactoryEnter.ahk
#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\mloContextDependentFactoryNewTask.ahk
#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\mloContextDependentFactoryNewSubTask.ahk

global MLO_ENTER_MODE := 0
global MLO_ENTER_MODE_SET_AS_NEW_TASK := 1
global MLO_ENTER_MODE_SET_AS_NEW_TASK_GO_AFTER := 3
global MLO_ENTER_MODE_SET_AS_ESCAPE_AS_ENTER := 5
global MLO_ENTER_MODE_SET_AS_NEW_TASK_KEYS_AFTER := 6
global MLO_ENTER_MODE_SET_AS_ONE_NEW_TASK_KEYS_AFTER := 4
global MLO_ENTER_MODE_SET_AS_ENTER_GO_AFTER := 7
global MLO_ENTER_MODE_SET_AS_SEND_KEYS := 9
global MLO_ENTER_MODE_SET_AS_GO_TO := 10
global MLO_ENTER_MODE_SET_AS_AFTER_TIMER_ENTER_AND_ESCAPE_SENDS_KEYS := 11
global MLO_ENTER_MODE_SET_AS_TIMER_SEND_KEYS := 12 ; only for documentation, not used as variable => search for <TIMER_SEND_KEYS_
global MLO_ENTER_MODE_SET_AS_COPY_TEMPLATE := 13
global MLO_ENTER_MODE_SET_AS_JURNAL_FOCUS := 15
global MLO_ENTER_MODE_SET_AS_NEW_TASK_COMPLETE_PREVIOUS := 16
global NUMBER_TASKS_COMPLETE := 0
global MLO_ENTER_MODE_SET_AS_VIEW_LEVEL_NEW_TASK := 19
global MLO_ENTER_MODE_SET_AS_VIEW_PLANIFIC_ZI := 20
global LESSON_COMPLETE_AMOUNT := 0
global MLO_ENTER_MODE_SET_AS_EVENIMENTE_REFLECT := 21
global MLO_ENTER_MODE_SET_AS_EVENIMENTE_REFLECT_ACTIVE := 22

global MLO_ENTER_MODE_SET_AS_DIALOG := 50
global MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ := 51
global MLO_ENTER_MODE_SET_AS_PARTE_CONSUMA := 53
global MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ_CONTINUE := 54
global MLO_ENTER_MODE_SET_AS_JURNAL_DUAL_ACTIVE := 57
global MLO_ENTER_MODE_SET_AS_JURNAL := 80
global MLO_ENTER_MODE_SET_AS_1JURNAL := 82
global MLO_ENTER_MODE_SET_AS_DEZVOLT_JURNAL := 81
global INTREBARI_JURNAL := {}
INTREBARI_JURNAL.EVENIMENT := ["CE SIMT IN ACEST SPATIU: ", "CE AR FACE UN PARINTE CARE MA IUBESTE: "]
INTREBARI_JURNAL.LIMITA := ["E IN CONTROLUL MEU: "]
INTREBARI_JURNAL.DISTRAGE := ["E IN CONTROLUL MEU: "]
INTREBARI_JURNAL.NEVOIE := ["POT SA INGRIJESC CU CEEA CE AM: "]
INTREBARI_JURNAL.INTENTIE := ["POT SA FAC SA FIU IMPACAT IN ACEST SPATIU: "]
INTREBARI_JURNAL.DAUᵒDRUMUL := ["EFECT TERMEN LUNG CONTINUI IGNOR LIMITA: "]
INTREBARI_JURNAL.CERᵒAJUTOR := ["SPRIJIN POT SA OFER: "]

global INTREBARI_JURNAL_INDEX := 1
global MLO_JOURNAL := ""
global TASK_GO_AFTER_TO := ""
global PREVIOUS_TASK := ""
global BUFFER := ""
global TIMEOUT_KEYS_TO_SEND := ""
global LAST_TIME_COPIED_TASK := A_TickCount

mloContextDependentKeyFactory(originalAction)
{
    if (originalAction = MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    {
        currentTask := getCurrentTask()
        mloNewContextDependentSubTask(currentTask)
    }
    else if (originalAction = MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    {
        currentTask := getCurrentTask()
        mloNewContextDependentTask(currentTask)
    } 
    else if (originalAction = "enter")
    {
        mloContextDependentEnter()
    }
    else if (originalAction = "escape")
    {
        mloNewContextDependentEscape()
    }
}

continueJournalTask(template, selectDifferentTemplateKeys = "")
{
    sendKeyCombinationIndependentActiveModifiers("{enter}")
    ;Loop %INTREBARI_JURNAL_INDEX%
    ;{
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEXT_DAY_START_DATE)
    ;}
    INTREBARI_JURNAL_INDEX := INTREBARI_JURNAL_INDEX + 1
    sendKeyCombinationIndependentActiveModifiers("{F5}")
    sleep 100
    if (selectDifferentTemplateKeys)
    {
        sendKeyCombinationIndependentActiveModifiers(selectDifferentTemplateKeys)
    }
    createJournalTask(template)
}

createConsuma()
{
    sendKeyCombinationIndependentActiveModifiers("{ENTER}")
    INTREBARI_JURNAL_INDEX := Mod(INTREBARI_JURNAL_INDEX + 1, 2)
    sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . INTREBARI_JURNAL_INDEX)
    sendKeyCombinationIndependentActiveModifiers("{F5}")
    sleep 100
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_DIALOG
}

resetMloEnterMode(alsoPressEscape = 1)
{
    MLO_ENTER_MODE := 0
    LESSON_COMPLETE_AMOUNT := 0
    TASK_GO_AFTER_TO := ""
    INTREBARI_JURNAL_INDEX := 1
    PREVIOUS_TASK := "" 
    if (alsoPressEscape)
    {
        send {blind}{escape}
    }
}

newBrainStormTask(originalAction)
{
    sendKeyCombinationIndependentActiveModifiers("{enter}{F5}{LEFT}")
    sendKeyCombinationIndependentActiveModifiers(originalAction)
}

extractDestinationAfter(input, indexPositionFromRight = 0)
{
    positionStart := InStr(input, "<") + 1
    positionEnd := InStr(input, ">")
    result := SubStr(input, positionStart, positionEnd - positionStart)
    splits := StrSplit(result, "_")
    return splits[splits.Count() - indexPositionFromRight]
}

mloAddJournalDelimiterSubTask()
{
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    sendKeyCombinationIndependentActiveModifiers("======{space}{space}======{space}{space}{left 9}")
    MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_NEW_TASK_WITH_REFRESH
}

TimerCopyMloTaskClear()
{
    setTimer TimerCopyMloTaskClear, off
    PREVIOUS_TASK := ""
}

TimerGoToMloTask()
{
    setTimer TimerGoToMloTask, off
    if (DOUBLE_PRESS_KEY_ACTIVE)
    {
        sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
        nextTaskToGoAfter := getCurrentTask()
        mloNewContextDependentSubTask(nextTaskToGoAfter)
    }
}

writeNextQuestion()
{
    questions := INTREBARI_JURNAL[MLO_JOURNAL]
    if (!questions)
    {
        showtooltip("INVALID JOURNAL TOPIC", 1000)
        return
    }
    if (questions.length() = 0)
    {
        sendKeyCombinationIndependentActiveModifiers("{escape}")
        finishQuestions()
        return
    }
    if (INTREBARI_JURNAL_INDEX > questions.length())
    {
        INTREBARI_JURNAL_INDEX := 1
        setTimer TimerGoToNextQuestion, off
        setTimer TimerGoToNextQuestion, 800
        sendKeyCombinationIndependentActiveModifiers("{enter}")    
        return
    }
    sendKeyCombinationIndependentActiveModifiers(questions[INTREBARI_JURNAL_INDEX])
    INTREBARI_JURNAL_INDEX += 1
}

TimerCopyMloTaskPhase1()
{
    setTimer TimerCopyMloTaskPhase1, off
    setTimer TimerCopyMloTaskPhase2, 250
    sendKeyCombinationIndependentActiveModifiers("{right}{space}^a^c")
}

TimerCopyMloTaskPhase2()
{
    setTimer TimerCopyMloTaskPhase2, off
    setTimer TimerCopyMloTaskPhase3, 250
    if (Clipboard = "New Task " || Clipboard = " ")
    {
        send %PREVIOUS_TASK%
    }
    else
    {
        PREVIOUS_TASK := Clipboard
    }
    sendKeyCombinationIndependentActiveModifiers("{enter}{f5}")
}

TimerCopyMloTaskPhase3()
{
    setTimer TimerCopyMloTaskPhase3, off
    sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
    sleep 250
    goAfter := getCurrentTask(600)
    mloNewContextDependentSubTask(goAfter)
}

TimerGoToNextQuestion()
{
    setTimer TimerGoToNextQuestion, off
    sendKeyCombinationIndependentActiveModifiers(PREVIOUS_TASK)
    sleep 100
    sendKeyCombinationIndependentActiveModifiers("{down}{F5}")
    sleep 800
    currentTask := getCurrentTask(300) 
    if (!inStr(currentTask, "<" . MLO_JOURNAL . ">", true))
    {
        if (TASK_GO_AFTER_TO = "{DOWN}")
        {
            mloNewContextDependentSubTask(currentTask)
        }
        else
        {
            finishQuestions()
        }
        return
    }
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    writeNextQuestion()
}

timerGoToNextDialoguePhase()
{
    SetTimer TimerGoToNextDialoguePhase, off
    TASK_GO_AFTER_TO := Mod(TASK_GO_AFTER_TO + 1, 2)
    sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
    sendKeyCombinationIndependentActiveModifiers("{DOWN}")
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
}

createJournalTask(template)
{
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
    sendKeyCombinationIndependentActiveModifiers("{DOWN}")
    sendKeyCombinationIndependentActiveModifiers("{F2}")
    sleep 50
    sendKeyCombinationIndependentActiveModifiers(INTREBARI_JURNAL_INDEX . template . "{space}")
}

getCurrentTask(waitTimeAfterCopy = 300)
{
    ; copy current task so that it can be parsed without loosing clipboard
    temp := Clipboard
    sendKeyCombinationIndependentActiveModifiers("^c")
    if (waitTimeAfterCopy)
    {
        if (A_TickCount - LAST_TIME_COPIED_TASK < 200)
        {
            ;writeNowLogFile("A_TickCount - LAST_TIME_COPIED_TASK=" . A_TickCount - LAST_TIME_COPIED_TASK)
            sleep 400
        }
        LAST_TIME_COPIED_TASK := A_TickCount
        sleep %waitTimeAfterCopy% ; wait for the os to register the command, smaller time causes mlo process errors
    }
    currentTask := Clipboard
    debug("=== getCurrentTask: " . currentTask)
    Clipboard := temp
    return currentTask
}

getFocusArea(input)
{
    positionSpace := InStr(input, " ")
    if (positionSpace = 0) {
        return 0
    }
    
    focusArea := SubStr(input, 1, positionSpace)
    allowedFocusAreas := ["11", "111", "12", "121", "13", "131", "22", "221", "23", "231", "24", "241", "33", "331", "34", "341", "35", "351", "44", "441", "45", "451", "46", "461", "51", "52", "53", "54", "55", "551", "56", "561", "57", "571", "61" ,"62" ,"63" ,"64", "65", "66", "661", "67", "671", "71", "72", "73", "74", "75", "76", "77"]
    for key, allowedArea in allowedFocusAreas
    {
        if (focusArea = allowedArea) {
            return allowedArea
        }
    } 
}

lastJournalTask(lastTaskName)
{
    sendKeyCombinationIndependentActiveModifiers("^a")
    currentTask := getCurrentTask()
    if (SubStr(currentTask,0,1) = " ")
    {
        sendKeyCombinationIndependentActiveModifiers("{BackSpace}{BackSpace}{BackSpace}l")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{enter}")
    }
    else
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}")
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEXT_DAY_START_DATE)
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{F2}{down}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("^a")
        sleep 250
        sendKeyCombinationIndependentActiveModifiers(lastTaskName)
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{enter}{F5}")
    }
}

finishQuestions()
{
    sleep 1000
    sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
    sleep 150
    currentTask := getCurrentTask()
    resetMloEnterMode(0)
    MLO_ENTER_MODE := 99999 ; a value that for sure is not linked to task but might trigger a <CANCEL> action 
    mloNewContextDependentSubTask(currentTask)
}

processKeysAfter(keys)
{
    ;showtooltip("processKeysAfter", 2000)
    isMloEnterModeResetRequired = 1
    keys := StrSplit(keys, "|")
    for index, key in keys
    {
        ; in case triggering a shortcut has reset the enter mode stop processing further
        ;showtooltip("MLO_ENTER_MODE=" . MLO_ENTER_MODE, 2000)
        ;showtooltip("key=" . key, 2000)
        if (MLO_ENTER_MODE != 0) 
        {
            if (key = "^e" || key = "^r") ; ^e is used for the new task shortcut, ^r is used for the new sub task shortcut
            {
                ;showtooltip("isMloEnterModeResetRequired=" . isMloEnterModeResetRequired, 2000)
                ; add an extra time to be sure getCurrentTask works
                sleep 150
                isMloEnterModeResetRequired := 0
            }
            
            index := keyboardShortcuts[key]
            if (index)
            {
                ;showtooltip("processShortcut=" . key, 2000)
                processShortcut(index, key)
            }
            else 
            {
                If InStr(key, "sleep")
                {
                    time := StrSplit(key, "sleep")[2]
                    ;showtooltip(time)
                    sleep %time%
                }
                else
                {
                    ;showtooltip("sendKey=" . key, 2000)
                    sendKeyCombinationIndependentActiveModifiers(key)
                }
            }
            sleep 150
        }
    }
    
    ; reset to normal mlo mode after processing the shortcuts
    if (isMloEnterModeResetRequired)
    {
        ;showtooltip("resetMloEnterMode", 2000)
        resetMloEnterMode(0)
    }
}

timerMloSendKeys()
{
    setTimer TimerMloSendKeys, OFF
    If (inStr(lastActiveAppName, MLO_WINDOW_NAME, true))
    {
        showtooltip("======== TIMER EXPIRED =========", 1500)
        ;showtooltip(TIMEOUT_KEYS_TO_SEND)
        if (TIMEOUT_KEYS_TO_SEND)
        {
            MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_AFTER_TIMER_ENTER_AND_ESCAPE_SENDS_KEYS
        }
    }
    else
    {
        resetMloEnterMode(0)
    }
}

duplicateCurrentTask(keyAfter = "")
{
    sendKeyCombinationIndependentActiveModifiers("{enter}{end}{F5}")
    sleep 400
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
    sleep 100
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_FOLDER)
    sendKeyCombinationIndependentActiveModifiers("{F2}")
    sleep 100
    sendKeyCombinationIndependentActiveModifiers("{delete}")
    if (keyAfter)
    {
        sendKeyCombinationIndependentActiveModifiers(keyAfter)
    }
}

startTimerSendKeys(currentTask, nextTaskMode)
{
    timerTimeout := extractDestinationAfter(currentTask, 1) * 1000
    if timerTimeout is not Number
    {
        timerTimeout := extractDestinationAfter(currentTask) * 1000
        TIMEOUT_KEYS_TO_SEND := 0
    }
    else
    {
        TIMEOUT_KEYS_TO_SEND := extractDestinationAfter(currentTask)
    }
    ;showtooltip("TIMEOUT_KEYS_TO_SEND=" . TIMEOUT_KEYS_TO_SEND, 1000)
    ;showtooltip("timerTimeout=" . timerTimeout, 1000)
    
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_CURRENT_TASK_SHOW_LEVEL_1)
    sleep 150
    sendKeyCombinationIndependentActiveModifiers("{DOWN}")
    sleep 300
    currentTask := getCurrentTask()
    if (nextTaskMode = MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    {
        mloNewContextDependentSubTask(currentTask)
    }
    else
    {
        mloNewContextDependentTask(currentTask)
    }
    
    SetTimer TimerMloSendKeys, OFF
    SetTimer TimerMloSendKeys, %timerTimeout%
}

startJurnalMode(currentTask)
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
    MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_JURNAL
}

timerCompletePrevious() 
{
    setTimer TimerCompletePrevious, OFF
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_NEW_TASK_COMPLETE_PREVIOUS)
    {
        sleep 150
        sendKeyCombinationIndependentActiveModifiers("{left}")
        sleep 150
        sendKeyCombinationIndependentActiveModifiers("{space}")
        NUMBER_TASKS_COMPLETE--
        Loop %NUMBER_TASKS_COMPLETE%,
        {
            sendKeyCombinationIndependentActiveModifiers("{up}")
            sleep 150
            sendKeyCombinationIndependentActiveModifiers("{space}")
            sleep 150
        }
        resetMloEnterMode(0)
    }
}

timerCompleteLesson() 
{
    setTimer TimerCompleteLesson, OFF
    if (MLO_ENTER_MODE = MLO_ENTER_MODE_SET_AS_VIEW_PLANIFIC_ZI)
    {
        sendKeyCombinationIndependentActiveModifiers("{left}")
        sleep 150
        sendKeyCombinationIndependentActiveModifiers("{space}")
        
        Loop 7,
        {
            LESSON_COMPLETE_AMOUNT := LESSON_COMPLETE_AMOUNT - 1
            sleep 800
            currentTask := getCurrentTask()
            focusArea := getFocusArea(currentTask)
            ;showtooltip(focusArea . "|" . focusArea - 60 . "|" . LESSON_COMPLETE_AMOUNT, 1500)
            if (!(focusArea - 60 = LESSON_COMPLETE_AMOUNT))
            {
                LESSON_COMPLETE_AMOUNT := 0
                break
            }
            sendKeyCombinationIndependentActiveModifiers("{space}")
            sleep 150
        }
    }
}

timerTaskOrderChanged()
{
    SetTimer TimerTaskOrderChanged, off
    if (IS_SET_MLO_ORDER_ACTIVE)
    {
        If (inStr(lastActiveAppName, MLO_WINDOW_NAME, true))
        {
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_TO_DO_MANUAL_SORTING)
        }
        IS_SET_MLO_ORDER_ACTIVE := 0
    }
}