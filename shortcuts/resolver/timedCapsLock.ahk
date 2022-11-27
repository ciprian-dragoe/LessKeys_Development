global appNameWhereTimedCapsActive



timedCapsLock()
{
    if (GetKeyState("CapsLock", "T"))
    {
        SetTimer, TimerDisableCapsLock, OFF
        SetCapsLockState, OFF
        tooltip

        return
    }

    CoordMode, ToolTip, Screen
    tooltip CAPS LOCK ACTIVE, 0, 0
    SetCapsLockState, On
    appNameWhereTimedCapsActive := lastActiveAppName
    otherKeyPressedWhileWobblyKeyDown := 0
    SetTimer, TimerDisableCapsLock, 600
}

TimerDisableCapsLock()
{
    if (layoutKeyPressed)
    {
        return
    }
    if (appNameWhereTimedCapsActive != lastActiveAppName || !otherKeyPressedWhileWobblyKeyDown)
    {
        SetTimer, TimerDisableCapsLock, OFF
        SetCapsLockState, OFF
        tooltip
    }
    otherKeyPressedWhileWobblyKeyDown := 0
}
