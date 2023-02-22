global IS_CONDITION_FOR_MLO_SYNC_FULFILLED := 0
global INTERNET_ACCESS := 1

timerCancelTooltip()
{
    tooltip
}

debugMloSync(label)
{
    syncLog = %A_Hour%-%A_Min%-%A_Sec%-%A_MSec%-%label%`n
    FileAppend, %syncLog%, %A_Desktop%\syncLog.txt
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
    SetTimer TimerSyncMloStep4_syncCalendar, OFF
    SetTimer TimerSyncMloStep4_syncCalendar, 3000
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
        
        debugMloSync("calendar-synced")
        return
    }
    syncLog = %A_Hour%-%A_Min%-%A_Sec%-%A_MSec%-no-internet-no-calendar-sync`n
    FileAppend, %syncLog%, %A_Desktop%\syncLog.txt
    
}

resetTimerSyncMlo()
{
    SetTimer TimerSyncMloStep1_launchPing, OFF
    SetTimer TimerSyncMloStep2_readPing, OFF
    SetTimer TimerSyncMloStep3_recheckInternet, OFF
    SetTimer TimerSyncMloStep4_syncCalendar, OFF
}
