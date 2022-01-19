global MLO_OVERLAY_ACTIVE := 0


activateWin1()
{
    send {blind}^{left}
    send {blind}1
    SetTimer, TimerMloDarkMode, 500
    if (MLO_TIMER_FLASH_ARE_YOU_WORKING)
    {
        setTimer timerFlashMinutesUp, %MLO_TIMER_FLASH_ARE_YOU_WORKING%
    }
}

activateWin2()
{
    send {blind}^{left}
    send {blind}2
}

activateWin3()
{
    send {blind}^{left}
    send {blind}3
}

activateWin4()
{
    send {blind}^{left}
    send {blind}4
}

activateWin5()
{
    send {blind}^{left}
    send {blind}5
}

activateWin6()
{
    send {blind}^{left}
    send {blind}6
}

activateWin7()
{
    send {blind}^{left}
    send {blind}7
}

activateWin8()
{
    send {blind}8
}

activateWin9()
{
    send {blind}^{left}
    send {blind}9
}

activateWin0()
{
    send {blind}^{left}
    send {blind}0
}
