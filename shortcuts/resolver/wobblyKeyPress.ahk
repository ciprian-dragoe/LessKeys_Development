global otherKeyPressedWhileWobblyKeyDown := false
global isWobblyTimeoutActive := false
global selectedWobblyKey := "MButton"
global isWobblyKeyPressed := 0

wobblyKeyPress(combination, index)
{
    if (isWobblyKeyPressed)
    {
        return
    }

    isWobblyKeyPressed := 1
    SetTimer, TimerWobblyKey, OFF
    SetTimer, TimerCancelWobblyKey, OFF
    removeFromActivePressedKeys("wobblyWinKey")
    isWobblyTimeoutActive := false
    otherKeyPressedWhileWobblyKeyDown := false
    setWinState(1)
    SetTimer, TimerWobblyKey, 50
}

timerWobblyKey()
{
    setTimer TimerCheckAgainIfTimerTriggeredBeforeKeyLift, off
    SetTimer TimerStickyFailBack, off
    SetTimer TimerStickyFailBack, %timerTimeoutStickyKeys%
    if (isWobblyTimeoutActive)
    {
        isNonModifierKeyPress := true
        for index, key in monitoredStickyKeys
        {
            if (A_PriorKey == key)
            {
                isNonModifierKeyPress := false
                break
            }
        }
        if (isNonModifierKeyPress)
        {
            SetTimer, TimerCancelWobblyKey, OFF
            SetTimer, TimerWobblyKey, OFF
            isWobblyTimeoutActive := false
            resetModifierWithoutTriggerUpState("lwin", winActive)
        }
        return
    }

    if (GetKeyState(selectedWobblyKey, "P"))
    {
        if (activePressedKeys.length() > 0)
        {
            otherKeyPressedWhileWobblyKeyDown := true
        }
    }
    else
    {
        isWobblyKeyPressed := 0
        if (otherKeyPressedWhileWobblyKeyDown)
        {
            SetTimer, TimerWobblyKey, OFF
            resetModifierWithoutTriggerUpState("lwin", winActive)
        }
        else
        {
            isWobblyTimeoutActive := true
            justBefore := min(timerTimeoutStickyKeys - 100, 500)
            SetTimer, TimerCancelWobblyKey, %justBefore%
        }
    }
}

timerCancelWobblyKey()
{
    SetTimer, TimerWobblyKey, OFF
    SetTimer, TimerCancelWobblyKey, OFF
    resetModifierWithoutTriggerUpState("lwin", winActive)
    isWobblyTimeoutActive := false
}
