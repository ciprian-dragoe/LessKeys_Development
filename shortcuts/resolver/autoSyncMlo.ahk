global IS_CONDITION_FOR_MLO_SYNC_FULFILLED := 0
global INTERNET_ACCESS := 1

timerCancelTooltip()
{
    tooltip
}

debugMloSync(label)
{
    syncLog = %A_Hour%-%A_Min%-%A_Sec%-%A_MSec%-%label%`n
    FileAppend, %syncLog%, D:\syncLog.txt
}

timerCheckReminder()
{
    SetTimer TimerCheckReminder, OFF
    debugMloSync("timerCheckReminder")
    DetectHiddenWindows Off
    if (WinExist("MyLifeOrganized - Reminders"))
    {
        debugMloSync("timerCheckReminder - reminder window on")
        SetTimer TimerSyncMloStep1_launchPing, 10000
        SetTimer TimerCheckAfterSyncReminders, 30000
    }
    else
    {
        debugMloSync("timerCheckReminder - reminder window off")
        SetTimer TimerCheckReminder, %TimeoutCheckReminder%
    }    
}

timerCheckAfterSyncReminders()
{
    SetTimer TimerCheckAfterSyncReminders, OFF
    DetectHiddenWindows Off
    if (WinExist("MyLifeOrganized - Reminders"))
    {
        DetectHiddenWindows On
        tooltip, `n`n`n`n`n========= CHECK REMINDERS =========`n`n`n`n`n
        SetTimer TimerCancelTooltip, OFF
        SetTimer TimerCancelTooltip, 1000
    }
    SetTimer TimerCheckReminder, %TimeoutCheckReminder%
}

TimerSyncMloStep1_launchPing()
{    
    resetTimerSyncMlo()
    debugMloSync("ping-started")
    Run,%comspec% /c ping -n 2 -w 200 bing.com > %A_Temp%\ping.log,,hide
    SetTimer TimerSyncMloStep2_readPing, OFF
    SetTimer TimerSyncMloStep2_readPing, 3000
}

timerSyncMloStep2_readPing()
{
    SetTimer TimerSyncMloStep2_readPing, OFF

    fileread , StrTemp, %A_Temp%\ping.log
    StrTemp := trim(StrTemp)
    stringsplit , TempArr, StrTemp, =
    ifinstring, TempArr%TempArr0%, ms
    {
        IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
        {
            debugMloSync("mlo-forground-not-task-sync")
            return
        }
        
        INTERNET_ACCESS := 1
        ControlSend, , %MLO_KEYBOARD_SHORTCUT_MLO_SYNC%, ahk_class %MLO_CLASS_NAME%
        debugMloSync("tasks-synced")
        SetTimer TimerSyncMloStep3_recheckInternet, OFF
        SetTimer TimerSyncMloStep3_recheckInternet, 15000
    }
    else
    {
        INTERNET_ACCESS := 0
        debugMloSync("no-internet-no-task-sync")
        ControlSend, , ^s, ahk_class %MLO_CLASS_NAME%
    }
}

TimerSyncMloStep3_recheckInternet()
{
    SetTimer TimerSyncMloStep3_recheckInternet, OFF
    Run,%comspec% /c ping -n 2 -w 200 bing.com > %A_Temp%\ping.log,,hide
    workComp := A_ComputerName = ACTIVE_COMPUTER_IRIS_T15 && (A_WDay = 2 || A_WDay = 3 || A_WDay = 4 || A_WDay = 5 || A_WDay = 6) && (A_Hour >= 9 && A_Hour < 18)
    personalComp := A_ComputerName = ACTIVE_COMPUTER_X1_EXTREME && ((A_WDay = 1 || A_WDay = 2 || A_WDay = 3 || A_WDay = 4 || A_WDay = 5) && (A_Hour < 9 || A_Hour >= 18) || (A_WDay = 7 || A_WDay = 1))
    if (workComp || personalComp)
    {
        SetTimer TimerSyncMloStep4_syncCalendar, OFF
        SetTimer TimerSyncMloStep4_syncCalendar, 3000
    }
}

TimerSyncMloStep4_syncCalendar()
{
    SetTimer TimerSyncMloStep4_syncCalendar, OFF

    fileread , StrTemp, %A_Temp%\ping.log
    StrTemp := trim(StrTemp)
    stringsplit , TempArr, StrTemp, =
    ifinstring, TempArr%TempArr0%, ms
    {
        IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
        {
            debugMloSync("mlo-forground-not-calendar-sync")
            return
        }
        ControlSend, , %MLO_KEYBOARD_SHORTCUT_SYNC_MLO_CALENDAR%, ahk_class %MLO_CLASS_NAME%
        debugMloSync("calendar-synced")
        return
    }
    message = %A_Hour%-%A_Min%-%A_Sec%-%A_MSec%-no-internet-no-calendar-sync`n
    debugMloSync(message)    
}

resetTimerSyncMlo()
{
    SetTimer TimerSyncMloStep1_launchPing, OFF
    SetTimer TimerSyncMloStep2_readPing, OFF
    SetTimer TimerSyncMloStep3_recheckInternet, OFF
    SetTimer TimerSyncMloStep4_syncCalendar, OFF
}
