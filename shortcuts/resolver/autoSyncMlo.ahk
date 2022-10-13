global SYNC_MLO := 0
global INTERNET_ACCESS := 1

timerCancelTooltip()
{
    tooltip
}

timerCheckReminder()
{
    timerSyncMloStep1_launchPing()
    SetTimer TimerCheckAfterSyncReminders, 8000    
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
}

timerSyncMloStep1_launchPing()
{
    Run,%comspec% /c ping -n 2 -w 200 bing.com > %A_Temp%\ping.log,,hide
    SetTimer TimerSyncMloStep2_readPing, OFF
    SetTimer TimerSyncMloStep2_readPing, 4000
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
        INTERNET_ACCESS := 1
        ControlSend, , {F9}, ahk_class %MLO_CLASS_NAME%
        
        SetTimer TimerSyncMloStep3_syncCalendar, OFF
        SetTimer TimerSyncMloStep3_syncCalendar, 100000
    }
    else
    {
        INTERNET_ACCESS := 0
        ControlSend, , ^s, ahk_class %MLO_CLASS_NAME%
    }
}

timerSyncMloStep3_syncCalendar()
{
    SetTimer TimerSyncMloStep3_syncCalendar, OFF
    if (!inStr(lastActiveAppName, ".ml - MyLifeOrganized", true))
    {
        ControlSend, , {F10}, ahk_class %MLO_CLASS_NAME%
    }
}

resetTimerSyncMlo()
{
    SetTimer TimerSyncMloStep2_readPing, OFF
}
