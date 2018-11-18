/**
 * Windows Tiling
 * Flexible window tiling in Windows
 */

TileActiveWindow(columnTotal, columnStart, columnEnd, rowTotal, rowStart, rowEnd) {
    WinGet activeWin, ID, A
    activeMon := GetMonitorIndexFromWindow(activeWin)
    SysGet, MonitorWorkArea, MonitorWorkArea, %activeMon%

    ; Determine scope
    availableWidth := (MonitorWorkAreaRight - MonitorWorkAreaLeft)
    availableHeight := (MonitorWorkAreaBottom - MonitorWorkAreaTop)
    oneColumnWidth := availableWidth / columnTotal
    oneRowHeight := availableHeight / rowTotal

    oneColumnWidth := Round(oneColumnWidth)
    oneRowHeight := Round(oneRowHeight)

    adj := 8 ; Adjust for spacing (not sure why this occurs)
    ; Determine X info
    posX := ( oneColumnWidth * columnStart )
    endPosX := ( oneColumnWidth * columnEnd )
    width := ( endPosX - posX )
    posX := ( posX - adj )          ; Adjust for spacing (not sure why this occurs)
    width := ( width + ( adj * 2) ) ; Adjust for spacing (not sure why this occurs)

    ; Determin Y info
    posY := ( oneRowHeight * rowStart )
    endPosY := ( oneRowHeight * rowEnd )
    height := ( endPosY - posY )
    height := ( height + adj) ; Adjust for spacing (not sure why this occurs)

Debugging MsgBox to display numbers
    message_title=Dimension_Info
    message_info=
(
message_title Width
MonitorWorkAreaRight = %MonitorWorkAreaRight%
MonitorWorkAreaLeft    = %MonitorWorkAreaLeft%
availableWidth                = %availableWidth%

message_title Height
MonitorWorkAreaBottom = %MonitorWorkAreaBottom%
MonitorWorkAreaTop        = %MonitorWorkAreaTop%
availableHeight                   = %availableHeight%

message_title Calculations
oneColumnWidth = %oneColumnWidth%
oneRowHeight      = %oneRowHeight%

message_title Calculations
posX     = %posX%
endPosX = %endPosX%
width    = %width%
)
MsgBox, , %message_title%, %message_info%

    ; Move the window
    ; WinMove,A,,%posX%,%posY%,%width%,%height%
}

/**
 * GetMonitorIndexFromWindow retrieves the HWND (unique ID) of a given window.
 * @param {Uint} windowHandle
 * @author shinywong
 * @link http://www.autohotkey.com/board/topic/69464-how-to-determine-a-window-is-in-which-monitor/?p=440355
 */
GetMonitorIndexFromWindow(windowHandle) {
    ; Starts with 1.
    monitorIndex := 1

    VarSetCapacity(monitorInfo, 40)
    NumPut(40, monitorInfo)

    if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2))
        && DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo) {
        monitorLeft   := NumGet(monitorInfo,  4, "Int")
        monitorTop    := NumGet(monitorInfo,  8, "Int")
        monitorRight  := NumGet(monitorInfo, 12, "Int")
        monitorBottom := NumGet(monitorInfo, 16, "Int")
        workLeft      := NumGet(monitorInfo, 20, "Int")
        workTop       := NumGet(monitorInfo, 24, "Int")
        workRight     := NumGet(monitorInfo, 28, "Int")
        workBottom    := NumGet(monitorInfo, 32, "Int")
        isPrimary     := NumGet(monitorInfo, 36, "Int") & 1

        SysGet, monitorCount, MonitorCount

        Loop, %monitorCount% {
            SysGet, tempMon, Monitor, %A_Index%

            ; Compare location to determine the monitor index.
            if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
                and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom)) {
                monitorIndex := A_Index
                break
            }
        }
    }

    return %monitorIndex%
}


