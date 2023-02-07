global SYNC_MLO := 0
global INTERNET_ACCESS := 1

timerCancelTooltip()
{
    tooltip
}

timerCheckReminder()
{
    SetTimer TimerCheckReminder, OFF
    timerSyncMloStep1_launchPing()
    SetTimer TimerCheckAfterSyncReminders, 20000    
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

timerSyncMloStep1_launchPing()
{
    resetTimerSyncMlo()
    Run,%comspec% /c ping -n 2 -w 200 bing.com > %A_Temp%\ping.log,,hide
    SetTimer TimerSyncMloStep2_readPing, OFF
    SetTimer TimerSyncMloStep2_readPing, 3000
}

timerSyncMloStep2_readPing()
{
    SYNC_MLO := 0
    SetTimer TimerSyncMloStep2_readPing, OFF

    fileread , StrTemp, %A_Temp%\ping.log
    StrTemp := trim(StrTemp)
    stringsplit , TempArr, StrTemp, =
    ifinstring, TempArr%TempArr0%, ms
    {
        IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
        {
            return
        }
        
        INTERNET_ACCESS := 1
        
        ControlSend, , %MLO_KEYBOARD_SHORTCUT_SYNC_MLO_TASKS%, ahk_class %MLO_CLASS_NAME%
        SetTimer TimerSyncMloStep3_recheckInternet, OFF
        SetTimer TimerSyncMloStep3_recheckInternet, 10000
    }
    else
    {
        INTERNET_ACCESS := 0
        ControlSend, , ^s, ahk_class %MLO_CLASS_NAME%
    }
}

TimerSyncMloStep3_recheckInternet()
{
    Run,%comspec% /c ping -n 2 -w 200 bing.com > %A_Temp%\ping.log,,hide
    SetTimer TimerSyncMloStep4_syncCalendar, OFF
    SetTimer TimerSyncMloStep4_syncCalendar, 3000
}

TimerSyncMloStep4_syncCalendar()
{
    SetTimer TimerSyncMloStep4_syncCalendar, OFF
    SYNC_MLO := 0

    fileread , StrTemp, %A_Temp%\ping.log
    StrTemp := trim(StrTemp)
    stringsplit , TempArr, StrTemp, =
    ifinstring, TempArr%TempArr0%, ms
    {
        IfInString, lastActiveAppName, %MLO_WINDOW_NAME%
        {
            return
        }
        
        ControlSend, , %MLO_KEYBOARD_SHORTCUT_SYNC_MLO_CALENDAR%, ahk_class %MLO_CLASS_NAME%
    }
}

resetTimerSyncMlo()
{
    SetTimer TimerSyncMloStep2_readPing, OFF
    SetTimer TimerSyncMloStep3_recheckInternet, OFF
    SetTimer TimerSyncMloStep4_syncCalendar, OFF
}
