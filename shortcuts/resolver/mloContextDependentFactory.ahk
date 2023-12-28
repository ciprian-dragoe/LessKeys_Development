﻿#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\mloContextDependentFactoryEscape.ahk
#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\mloContextDependentFactoryEnter.ahk
#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\mloContextDependentFactoryNewTask.ahk
#include %A_ScriptDir%\..\environmentDependent\_development\shortcuts\resolver\mloContextDependentFactoryNewSubTask.ahk

global MLO_ENTER_MODE := 0
global MLO_ENTER_MODE_SET_AS_NEW_TASK := 1
global MLO_ENTER_MODE_SET_AS_POMODORO := 2
global MLO_ENTER_MODE_SET_AS_POMODORO_START := 3
global POMODORO_MESSAGE := ""
global IS_MLO_REMINDER_WINDOWS_TO_BE_MINIMIZED := 0
global MLO_ENTER_MODE_SET_AS_ESCAPE_AS_ENTER := 5
global MLO_ENTER_MODE_SET_AS_NEW_TASK_KEYS_AFTER := 6
global MLO_ENTER_MODE_SET_AS_ONE_NEW_TASK_KEYS_AFTER := 4
global MLO_ENTER_MODE_SET_AS_SEND_KEYS := 9
global MLO_ENTER_MODE_SET_AS_AFTER_TIMER_ENTER_AND_ESCAPE_SENDS_KEYS := 11
global MLO_ENTER_MODE_SET_AS_TIMER_SEND_KEYS := 12 ; only for documentation, not used as variable => search for <TIMER_SEND_KEYS_
global MLO_ENTER_MODE_SET_AS_VIEW_LEVEL_NEW_TASK := 19
global MLO_ENTER_MODE_SET_AS_VIEW_PLANIFIC_ZI := 20
global LESSON_COMPLETE_AMOUNT := 0

global MLO_ENTER_MODE_SET_AS_DIALOG := 50
global MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ := 51
global MLO_ENTER_MODE_SET_AS_PARTE_CONSUMA := 53
global MLO_ENTER_MODE_SET_AS_GANDURI_EXPLOREZ_CONTINUE := 54
global MLO_ENTER_MODE_SET_AS_JURNAL_DUAL_ACTIVE := 57

global MLO_ENTER_MODE_SET_AS_JOURNAL := 91
global MLO_ENTER_MODE_SET_AS_JOURNAL_ASK_QUESTIONS := 92
global JOURNAL_QUESTIONS := {}

global JOURNAL_GROUP_INDEX := 1
global JOURNAL_QUESTION_INDEX := 1
global JOURNAL_LAST_INDEX := 1
global MLO_JOURNAL := ""
global TASK_GO_AFTER_TO := ""
global PREVIOUS_TASK := ""
global TIMEOUT_KEYS_TO_SEND := ""
global TIMEOUT_REMAINING_TIME := ""
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
    JOURNAL_LAST_INDEX += 1 ; because the 1st task is "==="
    sendKeyCombinationIndependentActiveModifiers("{F5}{down " . JOURNAL_LAST_INDEX . "}")
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
        sendKeyCombinationIndependentActiveModifiers("{enter}")    
        return
    }
    if (JOURNAL_QUESTION_INDEX = 1) 
    {
        sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEW_SUB_TASK)
    }
    else
    {
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
        if (TASK_GO_AFTER_TO = "{DOWN}")
        {
            mloNewContextDependentSubTask(currentTask)
        }
        else if (inStr(TASK_GO_AFTER_TO, "cancel"))
        {
            resetMloEnterMode(0)
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
    if (TIMEOUT_REMAINING_TIME > 0 && InStr(lastActiveAppName, MLO_WINDOW_NAME))
    {
        SetFormat, float, 02
        minutes1 := (TIMEOUT_REMAINING_TIME // 1000) // 60
        seconds1 := ((TIMEOUT_REMAINING_TIME // 1000) - minutes1 * 60)
        minutes1+=0.00
        seconds1+=0.00
        timeToDisplay=%minutes1%:%seconds1%
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
    POMODORO_MESSAGE := ""
    IS_MLO_REMINDER_WINDOWS_TO_BE_MINIMIZED := 0
}

describePomodoroStep(newTaskType)
{
    sendKeyCombinationIndependentActiveModifiers(newTaskType)
    sendKeyCombinationIndependentActiveModifiers("PAS INTENTIONEZ FAC: ")
}

startPomodoroTimer()
{
    sendKeyCombinationIndependentActiveModifiers("{enter}")
    sleep 100
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_NEXT_SET_REMINDER_IN_10_MINUTES)
    resetMloEnterMode()
    sleep 100
    hideNotesAndFocusTasks()
    sendKeyCombinationIndependentActiveModifiers(MLO_KEYBOARD_SHORTCUT_MLO_SYNC)
    POMODORO_MESSAGE := getCurrentTask()
    oneHour := 1000 * 60 * 60
    SetTimer TimerResetPomodoroMessage, %oneHour%
    IS_MLO_REMINDER_WINDOWS_TO_BE_MINIMIZED := 1
}