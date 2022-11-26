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
    otherKeyPressedWhileWobblyKeyDown := 2
    send {blind}^{left}
    send {blind}2
}

activateWin3()
{
    otherKeyPressedWhileWobblyKeyDown := 2
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
    otherKeyPressedWhileWobblyKeyDown := 2
    send {blind}^{left}
    send {blind}5
}

activateWin6()
{
    otherKeyPressedWhileWobblyKeyDown := 2
    send {blind}^{left}
    send {blind}6
}

activateWin7()
{
    otherKeyPressedWhileWobblyKeyDown := 2
    send {blind}^{left}
    send {blind}7
}

activateWin8()
{
    otherKeyPressedWhileWobblyKeyDown := 2
    send {blind}8
}

activateWin9()
{
    otherKeyPressedWhileWobblyKeyDown := 2
    send {blind}^{left}
    send {blind}9
}

activateWin0()
{
    otherKeyPressedWhileWobblyKeyDown := 2
    send {blind}^{left}
    send {blind}0
}
