activateWin1()
{
    otherKeyPressedWhileWobblyKeyDown := 2
    send {blind}^{left}

    mloActive := WinActive(MLO_WINDOW_NAME)
    if (!mloActive)
    {
        setMloDarkMode(1)
    }
    else
    {
        send {blind}1
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
    otherKeyPressedWhileWobblyKeyDown := 2
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
