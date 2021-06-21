global NAME_MLO_SYNC_FILE := ".ml - MyLifeOrganized"
global SYNC_MLO := 0
global INTERNET_ACCESS := 1


timerCheckMloChange()
{
    if (inStr(lastActiveAppName, NAME_MLO_SYNC_FILE . " *") || inStr(lastActiveAppName, "Rapid Task Entry"))
    {
        SYNC_MLO := 1
    }
    else if (SYNC_MLO)
    {
        resetTimerSyncMlo()
        SYNC_MLO := 0
        timerSyncMlo()
    }
}

timerSyncMlo()
{


    SetTimer TimerSyncMloStep1_launchPing, 500
}

timerSyncMloStep1_launchPing()
{

    if (A_TimeIdleKeyboard > 2000)
    {
        SetTimer TimerSyncMloStep1_launchPing, OFF
        Run,%comspec% /c ping -n 2 -w 200 bing.com > %A_Temp%\ping.log,,hide

        SetTimer TimerSyncMloStep2_readPing, 2000
    }
}

timerSyncMloStep2_readPing()
{
    SetTimer TimerSyncMloStep2_readPing, OFF
    fileread , StrTemp, %A_Temp%\ping.log
    StrTemp := trim(StrTemp)
    stringsplit , TempArr, StrTemp, =
    ifinstring, TempArr%TempArr0%, ms
    {
        INTERNET_ACCESS := 1
        ControlSend, , {F9}, ahk_class %MLO_CLASS_NAME%
    }
    else
    {
        INTERNET_ACCESS := 0
        ControlSend, , ^s, ahk_class %MLO_CLASS_NAME%
    }
}

resetTimerSyncMlo()
{
    SetTimer TimerSyncMlo, OFF
    SetTimer TimerSyncMloStep1_launchPing, OFF
    SetTimer TimerSyncMloStep2_readPing, OFF
    SetTimer TimerSyncMlo, 3600000
}
