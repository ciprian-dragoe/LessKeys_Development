#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\mloContextDependentFactoryEscape.ahk
#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\mloContextDependentFactoryEnter.ahk
#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\mloContextDependentFactoryNewTask.ahk
#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\mloContextDependentFactoryNewSubTask.ahk

global MLO_ENTER_MODE := 0
global MLO_ENTER_MODE_SET_AS_NEW_TASK := 1
global MLO_ENTER_MODE_SET_AS_POMODORO := 2
global MLO_ENTER_MODE_SET_AS_POMODORO_START := 3
global MLO_ENTER_MODE_SET_AS_POMODORO_FOLLOW_UP := 4
global MLO_ENTER_MODE_SET_AS_POMODORO_FOLLOW_UP_FINISH := 5
global MLO_ENTER_MODE_SET_AS_ESCAPE_AS_ENTER := 6
global MLO_ENTER_MODE_SET_AS_NEW_TASK_KEYS_AFTER := 7
global MLO_ENTER_MODE_SET_AS_ONE_NEW_TASK_KEYS_AFTER := 8
global MLO_ENTER_MODE_SET_AS_SEND_KEYS := 9
global MLO_ENTER_MODE_SET_AS_AFTER_TIMER_ENTER_AND_ESCAPE_SENDS_KEYS := 10
global MLO_ENTER_MODE_SET_AS_TIMER_SEND_KEYS := 11 ; only for documentation, not used as variable => search for <TIMER_SEND_KEYS_

global MLO_ENTER_MODE_SET_AS_VIEW_LEVEL_NEW_TASK := 19
global MLO_ENTER_MODE_SET_AS_VIEW_PLANIFIC_ZI := 20
global MLO_ENTER_MODE_SET_AS_ALIGN_QUESTIONS := 21
global ALIGN_QUESTIONS := []
global ALIGN_QUESTIONS_INDEX := 0

global LESSON_COMPLETE_AMOUNT := 0

global MLO_ENTER_MODE_SET_AS_DIALOG := 50
global MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ := 51
global MLO_ENTER_MODE_SET_AS_PARTE_CONSUMA := 53
global MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ_CONTINUE := 54
global MLO_ENTER_MODE_SET_AS_JURNAL_DUAL_ACTIVE := 57

global MLO_ENTER_MODE_SET_AS_JOURNAL := 91
global MLO_ENTER_MODE_SET_AS_JOURNAL_ASK_QUESTIONS := 92
global JOURNAL_QUESTIONS := {}

global MLO_ENTER_MODE_SET_AS_POMODORO_INDEX := 0
global DEFAULT_POMODORO_TIME := 44
global SELECTED_POMODORO_TIME := 0
global POMODORO_QUESTIONS := ["__PASI INTENTIONEZ SA FAC: ", "__PUN PE PAUZA URMATOARELE GANDURI: ", "__PAUZA & MA INCARC DUPA: ", "__LIMITE MENTIN: "]
global POMODORO_FOLLOW_UP_QUESTIONS := ["__ACTIUNI INTENTIONEZ SA FAC MAI DEPARTE PENTRU ACEST TASK: ", "__NEVOI INCARC PRIN: ", "__DAU DRUMUL / FAC PAUZA: "]

global JOURNAL_GROUP_INDEX := 1
global JOURNAL_QUESTION_INDEX := 1
global JOURNAL_LAST_INDEX := 1
global MLO_JOURNAL := ""
global TASK_GO_AFTER_TO := ""
global PREVIOUS_TASK := ""
global TIMEOUT_KEYS_TO_SEND := ""
global TIMEOUT_REMAINING_TIME := ""
global LAST_TIME_COPIED_TASK := A_TickCount
global POMODORO_MESSAGE := ""
global IS_TIMER_SHOWN_OUTSIDE_MLO := ""

mloContextDependentKeyFactory(originalAction)
{
    if (originalAction = MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    {
        currentTask := getCurrentTask()
        ;showToolTip(currentTask)
        mloNewContextDependentSubTask(currentTask)
    }
    else if (originalAction = MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    {
        currentTask := getCurrentTask()
        ;showToolTip(currentTask)
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
    ;Loop %JOURNAL_QUESTION_INDEX%
    ;{
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEXT_DAY_START_DATE)
    ;}
    JOURNAL_QUESTION_INDEX := JOURNAL_QUESTION_INDEX + 1
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
    JOURNAL_QUESTION_INDEX := Mod(JOURNAL_QUESTION_INDEX + 1, 2)
    sendKeyCombinationIndependentActiveModifiers("" . TASK_GO_AFTER_TO . "" . JOURNAL_QUESTION_INDEX)
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
    JOURNAL_QUESTION_INDEX := 1
    JOURNAL_GROUP_INDEX := 1
    JOURNAL_LAST_INDEX := 1
    MLO_ENTER_MODE_SET_AS_POMODORO_INDEX := 1
    ALIGN_QUESTIONS_INDEX := 1
    PREVIOUS_TASK := "" 
    if (alsoPressEscape)
    {
        send {blind}{escape}
    }
}

extractDestinationAfter(input, indexPositionFromRight = 0)
{
    positionStart := InStr(input, "<") + 1
    positionEnd := InStr(input, ">")
    result := SubStr(input, positionStart, positionEnd - positionStart)
    splits := StrSplit(result, "_")
    return splits[splits.Count() - indexPositionFromRight]
}

TimerNextJournalQuestion()
{
    setTimer TimerNextJournalQuestion, off
    ;showtooltip("TimerNextJournalQuestion", 1200)
    sendKeyCombinationIndependentActiveModifiers(PREVIOUS_TASK)
    sleep 100
    if (JOURNAL_QUESTIONS[MLO_JOURNAL].length() > JOURNAL_GROUP_INDEX)
    {
        JOURNAL_LAST_INDEX += 1
        sendKeyCombinationIndependentActiveModifiers("{F5}{down " . JOURNAL_LAST_INDEX . "}")
    }
    else
    {
        sendKeyCombinationIndependentActiveModifiers("{down}")
    }
    sleep 800
    currentTask := getCurrentTask(300) 
    ;showtooltip(currentTask, 2000)
    if (!inStr(currentTask, "<" . MLO_JOURNAL . ">", true))
    {
        return nextGroupQuestions()
    }
    writeNextQuestion()
}

writeNextQuestion()
{
    questions := JOURNAL_QUESTIONS[MLO_JOURNAL][JOURNAL_GROUP_INDEX]
    if (!questions)
    {
        showtooltip("INVALID JOURNAL TOPIC", 1000)
        return nextGroupQuestions()
    }
    
    if (questions.length() = 0)
    {
        return nextGroupQuestions()
    }
    
    if (JOURNAL_QUESTION_INDEX > questions.length())
    {
        JOURNAL_QUESTION_INDEX := 1
        setTimer TimerNextJournalQuestion, off
        setTimer TimerNextJournalQuestion, 800
        if (JOURNAL_QUESTIONS[MLO_JOURNAL].length() > JOURNAL_GROUP_INDEX)
        {
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_FOLDER)
        }
        else
        {
            sendKeyCombinationIndependentActiveModifiers("{enter}")
        }
        
        return
    }
    if (JOURNAL_QUESTION_INDEX = 1) 
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else
    {
        if (JOURNAL_QUESTIONS[MLO_JOURNAL].length() > JOURNAL_GROUP_INDEX)
        {
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_FOLDER)
        }
        
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_TASK)
    }
    ;showtooltip(questions[JOURNAL_QUESTION_INDEX], 2000)
    sendKeyCombinationIndependentActiveModifiers(questions[JOURNAL_QUESTION_INDEX] . "{space}")
    JOURNAL_QUESTION_INDEX += 1
}

nextGroupQuestions()
{
    JOURNAL_GROUP_INDEX += 1
    JOURNAL_LAST_INDEX := 1
    questions := JOURNAL_QUESTIONS[MLO_JOURNAL][JOURNAL_GROUP_INDEX]
    if (questions)
    {
        TimerNextJournalQuestion()
    }
    else
    {
        currentTask := getCurrentTask()
        if (!TASK_GO_AFTER_TO)
        {
            MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_JOURNAL
            JOURNAL_QUESTION_INDEX := 1
            JOURNAL_GROUP_INDEX := 1
            JOURNAL_LAST_INDEX := 0
            sendKeyCombinationIndependentActiveModifiers(PREVIOUS_TASK)
            sleep 150
            sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)    
            sendKeyCombinationIndependentActiveModifiers("<" . MLO_JOURNAL . ">{space}")
        }
        else if (inStr(TASK_GO_AFTER_TO, "CANCEL"))
        {
            resetMloEnterMode(0)
        }
        else if (inStr(TASK_GO_AFTER_TO, "DOWN"))
        {
            mloNewContextDependentSubTask(currentTask)
        }
        else
        {
            sleep 1000
            sendKeyCombinationIndependentActiveModifiers(TASK_GO_AFTER_TO)
            sleep 150
            currentTask := getCurrentTask()
            resetMloEnterMode(0)
            MLO_ENTER_MODE := 99999 ; a value that for sure is not linked to task but might trigger a <CANCEL> action 
            mloNewContextDependentSubTask(currentTask)
        }
    }
}

createJournalTask(template)
{
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_DUPLICATE_TASK)
    sendKeyCombinationIndependentActiveModifiers("{DOWN}")
    sendKeyCombinationIndependentActiveModifiers("{F2}")
    sleep 50
    sendKeyCombinationIndependentActiveModifiers(JOURNAL_QUESTION_INDEX . template . "{space}")
}

getCurrentTask(waitTimeAfterCopy = 300, selectAllBeforeCopy = 0)
{
    ; copy current task so that it can be parsed without loosing clipboard
    temp := Clipboard
    if (selectAllBeforeCopy)
    {
        sendKeyCombinationIndependentActiveModifiers("^a")
        sleep 100
    }
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
    allowedFocusAreas := ["11", "110", "12", "120", "13", "130", "22", "220", "23", "230", "24", "240", "33", "330", "34", "340", "35", "350", "44", "440", "45", "450", "46", "460", "55", "550", "56", "560", "61" ,"62" ,"63" ,"64", "65", "66", "71", "72", "73", "74", "75", "76", "77"]
    for key, allowedArea in allowedFocusAreas
    {
        if (focusArea = allowedArea) {
            return allowedArea
        }
    } 
}

getPomodoroTimeFrom(input)
{
    positionSpace := InStr(input, " ")
    if (positionSpace = 0) {
        return 0
    }
    
    focusArea := SubStr(input, 1, positionSpace)
    isPomodoro := subStr(focusArea, 3, 1) = "8" || subStr(focusArea, 2, 1) = "8"
    ;showtooltip(subStr(focusArea, 3, 1))
    if (isPomodoro) {
        words := StrSplit(input, " ")
        lastWord := removeWhiteSpace(words[words.length()])
        lastWord := StrReplace(lastWord, "|", "")
        ;showtooltip(lastWord)
        if (isStringNumber(lastWord)) {
            return lastWord
        }
        return DEFAULT_POMODORO_TIME
    }
    
    return 0 
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

startTimerSendKeys(currentTask, nextTaskMode)
{
    TIMEOUT_REMAINING_TIME := extractDestinationAfter(currentTask, 1) * 1000
    if TIMEOUT_REMAINING_TIME is not Number
    {
        TIMEOUT_REMAINING_TIME := extractDestinationAfter(currentTask) * 1000
        TIMEOUT_KEYS_TO_SEND := 0
    }
    else
    {
        TIMEOUT_KEYS_TO_SEND := extractDestinationAfter(currentTask)
    }
    ;showtooltip("TIMEOUT_KEYS_TO_SEND=" . TIMEOUT_KEYS_TO_SEND, 1000)
    ;showtooltip("TIMEOUT_REMAINING_TIME=" . TIMEOUT_REMAINING_TIME, 1000)
    
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
    SetTimer TimerMloSendKeys, %TIMEOUT_REMAINING_TIME% 
    SetTimer TimerDisplayRemainingTime, off
    SetTimer TimerDisplayRemainingTime, 1000
}

timerDisplayRemainingTime()
{
    SetTimer TimerDisplayRemainingTime, off
    if (InStr(lastActiveAppName, MLO_WINDOW_NAME) || IS_TIMER_SHOWN_OUTSIDE_MLO)
    {
            SetFormat, float, 02
            minutes1 := (TIMEOUT_REMAINING_TIME // 1000) // 60
            seconds1 := ((TIMEOUT_REMAINING_TIME // 1000) - minutes1 * 60)
            if (seconds1 < 0)
            {
                seconds1 := -1 * seconds1
            }
            minutes1+=0.00
            seconds1+=0.00
            
            timeToDisplay=%minutes1%:%seconds1%
            if (TIMEOUT_REMAINING_TIME < 0)
            {
                timeToDisplay = ---%timeToDisplay%
            }
            TIMEOUT_REMAINING_TIME := TIMEOUT_REMAINING_TIME - 1000
            tooltip, %timeToDisplay%, 0, 0, 5 
            SetTimer TimerDisplayRemainingTime, 1000
    }
    else
    {
        tooltip, , 0, 0, 5
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
            if (!(focusArea - 70 = LESSON_COMPLETE_AMOUNT))
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

setJournalTopics(topics, journal)
{
    phases := StrSplit(topics, "===")
    groups := []
    JOURNAL_QUESTIONS[journal] := groups
    for key, phase in phases
    {
        topics := StrSplit(phase, "`n")
        if (topics.MaxIndex())
        {
            questions := []
            for index, topic in topics
            {
                if (StrLen(topic) > 2)
                {
                    ;showtooltip("key=" key . " index=" . index " topic=" . topic, 3500)
                    StringReplace,topic,topic,`n,,A
                    StringReplace,topic,topic,`r,,A
                    questions.push(topic)
                }
            }
            
            if (questions.MaxIndex() > 0)
            {
                groups.push(questions)
            }
        }
    } 
}

timerResetPomodoroMessage()
{
    SetTimer TimerResetPomodoroMessage, off
    SetTimer TimerDisplayPomodoroMessageReminders, off
    POMODORO_MESSAGE := ""
    tooltip, ===========================`nPOMODORO FINISHED`n===========================, 0, 0
    SetTimer TimerCancelTooltip, OFF
    SetTimer TimerCancelTooltip, 20000
}

describePomodoroStep(newTaskType)
{
    SetTimer TimerDisplayRemainingTime, off
    tooltip, , 0, 0, 5
    
    sendKeyCombinationIndependentActiveModifiers(newTaskType)
    MLO_ENTER_MODE_SET_AS_POMODORO_INDEX += 1
    sendKeyCombinationIndependentActiveModifiers(POMODORO_QUESTIONS[MLO_ENTER_MODE_SET_AS_POMODORO_INDEX])
    if (MLO_ENTER_MODE_SET_AS_POMODORO_INDEX >= POMODORO_QUESTIONS.length())
    {
        sendKeyCombinationIndependentActiveModifiers("{space}" . SELECTED_POMODORO_TIME . "{space}{left 4}")
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_POMODORO_START
    }
}

describePomodoroFollowUpStep(newTaskType)
{
    sendKeyCombinationIndependentActiveModifiers(newTaskType)
    MLO_ENTER_MODE_SET_AS_POMODORO_INDEX += 1
    if (MLO_ENTER_MODE_SET_AS_POMODORO_INDEX >= POMODORO_FOLLOW_UP_QUESTIONS.length())
    {
        MLO_ENTER_MODE := MLO_ENTER_MODE_SET_AS_POMODORO_FOLLOW_UP_FINISH
        MLO_ENTER_MODE_SET_AS_POMODORO_INDEX := POMODORO_FOLLOW_UP_QUESTIONS.length()
    }
    sendKeyCombinationIndependentActiveModifiers(POMODORO_FOLLOW_UP_QUESTIONS[MLO_ENTER_MODE_SET_AS_POMODORO_INDEX])
}

describeAlignStep(newTaskMode)
{
    ALIGN_QUESTIONS_INDEX += 1
    ;showtooltip(ALIGN_QUESTIONS.length())
    if (ALIGN_QUESTIONS_INDEX <= ALIGN_QUESTIONS.length())
    {
        sendKeyCombinationIndependentActiveModifiers(newTaskMode)
        sleep 100
        question := removeWhiteSpace(ALIGN_QUESTIONS[ALIGN_QUESTIONS_INDEX])
        sendKeyCombinationIndependentActiveModifiers(question . "{space}")
    }
    else
    {
        sendKeyCombinationIndependentActiveModifiers("{enter}")
        sleep 100
        sendKeyCombinationIndependentActiveModifiers("{down}")
        sleep 200
        currentTask := getCurrentTask()
        focusArea := getFocusArea(currentTask)
        ;showtooltip(subStr(currentTask, 1, 1), 2000)
        if (focusArea)
        {
            ALIGN_QUESTIONS_INDEX := 0
            describeAlignStep(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
        }
        else
        {
            resetMloEnterMode(0)
            mloNewContextDependentSubTask(currentTask)
        }
    }
}

startPomodoroTimer()
{
    POMODORO_MESSAGE := getCurrentTask(300, 1)
    sendKeyCombinationIndependentActiveModifiers("{right}")
    words := StrSplit(POMODORO_MESSAGE, " ")
    lastWord := trim(words[words.length()])
    beforeLastWord := trim(words[words.length() - 1])

    if (isStringNumber(lastWord))
    {
       ;showtooltip("lastWord " . lastWord)
       TIMEOUT_REMAINING_TIME := StrReplace(lastWord, "`r`n", "") * 60 * 1000
       spaceCount := 1
       defaultTimerCount := 2
       sendKeyCombinationIndependentActiveModifiers("{end}{backspace " . strLen(lastWord) + spaceCount + defaultTimerCount . "}")
       
    }
    else if (isStringNumber(beforeLastWord))
    {
        ;showtooltip("beforeLastWord " . beforeLastWord)
        TIMEOUT_REMAINING_TIME := StrReplace(beforeLastWord, "`r`n", "") * 60 * 1000
        spaceCount := 1
        sendKeyCombinationIndependentActiveModifiers("{end}{backspace " . strLen(beforeLastWord) + spaceCount . "}")
    }
    else
    {
        TIMEOUT_REMAINING_TIME := 50 * 60 * 1000
    }
    POMODORO_MESSAGE := getCurrentTask(300, 1)
    ;showtooltip(POMODORO_MESSAGE)
    sendKeyCombinationIndependentActiveModifiers("{enter}")
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_FOLDER)
    IS_TIMER_SHOWN_OUTSIDE_MLO := 1
    timerDisplayRemainingTime()
    SetTimer TimerResetPomodoroMessage, %TIMEOUT_REMAINING_TIME%
    time := 1000 * 60 * 10
    SetTimer TimerDisplayPomodoroMessageReminders, %time%
    resetMloEnterMode(0)
}

finishPomodoroFollowUp()
{
    sendKeyCombinationIndependentActiveModifiers("{enter}")
    ;sleep 200
    ;sendKeyCombinationIndependentActiveModifiers("{left 4}")
    ;sleep 200
    ;sendKeyCombinationIndependentActiveModifiers("{space}")
    stopPomodoroTimer()
    resetMloEnterMode(0)
}

isStringNumber(possibleNumber, ignoreWhiteSpace = 1)
{
    if (ignoreWhiteSpace)
    {
        possibleNumber := removeWhiteSpace(possibleNumber, 1)
    }
    if (strLen(possibleNumber) = 0) ; empty string
    {
        return false
    }
    possibleNumber := StrReplace(possibleNumber, "0", "")
    possibleNumber := StrReplace(possibleNumber, "1", "")
    possibleNumber := StrReplace(possibleNumber, "2", "")
    possibleNumber := StrReplace(possibleNumber, "3", "")
    possibleNumber := StrReplace(possibleNumber, "4", "")
    possibleNumber := StrReplace(possibleNumber, "5", "")
    possibleNumber := StrReplace(possibleNumber, "6", "")
    possibleNumber := StrReplace(possibleNumber, "8", "")
    possibleNumber := StrReplace(possibleNumber, "9", "")
    if (strLen(possibleNumber) = 0)
    {
        ;showtooltip(strLen(possibleNumber), 2000)
        return true
    }
    return false
}

removeWhiteSpace(input, includingSpaceBetweenWords = 0)
{
    if (includingSpaceBetweenWords)
    {
        input := StrReplace(input, " ", "")
    }
    input := RegExReplace(input, "^\s+|\s+$")
    input := StrReplace(input, "`n", "")
    input := StrReplace(input, "`r", "")
    input := StrReplace(input, "`r`n", "")
    return input
}

stopPomodoroTimer()
{
    SetTimer TimerDisplayPomodoroMessageReminders, off
    SetTimer TimerResetPomodoroMessage, off
    SetTimer TimerDisplayRemainingTime, off
    tooltip, , 0, 0, 5
    showtooltip("Stop Pomodoro Timer")
}