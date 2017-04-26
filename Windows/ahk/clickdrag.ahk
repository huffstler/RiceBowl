/***************************************************************************************************
	Window Dragging and resizing script by sqblak


	Based on: 
		- Easy Window Dragging -- KDE style by Jonny 
			http://www.autohotkey.com/docs/scripts/EasyWindowDrag_(KDE).htm
		- Detect mouse move 
			http://www.autohotkey.com/forum/post-44100.html
		- XPSnap Drag window to edges
			http://www.autohotkey.com/forum/topic65756.html
		- Nifty windows (9 cells idea)
			http://www.enovatic.org/products/niftywindows/features/

	Thanks to:
		Jonny, Chris, Serenity, DataLife

**************************************************************************************************
	Settings section
*/

; If window is maximized dragging and resizing can be disabled
WD_DragMaximizedWindows := 1			; 1-Enabled, 0 - Disabled

; If window is maximized and WD_DragMaximizedWindows is enabled window can be resized first
WD_ResizeMaximizedBeforeDragging := 1	; 1-Enabled, 0 - Disabled

; If above enabled set new window dimension (evry maximized window will be resized to these dimension
; before dragging.
WD_NewWidth := 1024		; pixels
WD_NewHeight := 640		; pixels

; This setting prevents unexpected moves. It ignores small moves but causes small jump after dragging start.
; Change to 0 to disable (after that window will be dragged or resized immideately
WD_StartDragClerance := 20	; pixels

; Snap windows to screen edges
WD_SnapToEdges := 1			; 1-Enabled, 0 - Disabled
WD_EdgeSnapClerance := 12	; pixels

; If enabled after window is resized to desktop width and heigth it's maximized
WD_AutoSetMaximized := 1	; 1-Enabled, 0 - Disabled

; Specify number of zones in each direction.
; Window is divided into WD_WindowZoneXCount columns and WD_WindowZoneYCount rows.
; Dragging first or last row/column (one of border zones) couses window resizing.
; Dragging central zone couses window dragging
; This settings determines width and height of those zones
WD_WindowZoneXCount := 5	; number of columns
WD_WindowZoneYCount := 5	; number of rows

; Dividers
; When mouse is close to edge preview window is shown (like in aero snap).
; When you move mouse out and then move it close to edge again next window size will be set.
; Digits below are screen dividers 
; 2-sets width (height) to screen width (height) divided by 2
; 3-sets width (height) to screen width (height) divided by 3 and so on
; 1-maximizes the window (screen width (height) divided by 1 is still screen width (height))
; On next 'edge touch' next divider is taken and values are cycled
; IMPORTANT: Actions for left and right edges can only change window width and actions for top 
;            and bottom edges can only change window height
WD_ActionsLeftEdge	 := [2,3,4,1.5]
WD_ActionsRightEdge  := [2,3,4]
WD_ActionsTopEdge    := [2,1,3]
WD_ActionsBottomEdge := [2,3]

; Preview window color and transparency
WD_WindowColor := "56686E"		; in hex format
WD_WindowTransparency := 120	; ( 1 - 255 )


/*	End of settings section
**************************************************************************************************
	Script
*/

;. Autoexecute section
#NoEnv
#SingleInstance, force

SetWinDelay, 2
CoordMode, Mouse

;. constants
WD_ZONES_W := A_ScreenWidth // 3
WD_ZONES_H := A_ScreenHeight // 3

; Analyze settings
WD_Actions := [ WD_ActionsLeftEdge, WD_ActionsTopEdge, WD_ActionsRightEdge, WD_ActionsBottomEdge ]

WD_WindowZoneXCount := ( WD_WindowZoneXCount < 3 ) ? 3 : ( WD_WindowZoneXCount > 10 ) ? 10 : WD_WindowZoneXCount
WD_WindowZoneYCount := ( WD_WindowZoneYCount < 3 ) ? 3 : ( WD_WindowZoneYCount > 10 ) ? 10 : WD_WindowZoneYCount

;Invisible Gui with border
Gui 2:  +ToolWindow +Alwaysontop +resize -border ;-0xC00000 ;+0x400000 ;  +0x40000000 +0x40000
Gui 2: Color, %WD_WindowColor%
Gui 2: +LastFound
Gui 2: show, x5000 w1 h1 , GuiOutline ;show off the Screen, then hide
WinGet, GuiOutline, id, GuiOutline
WinSet, Transparent, %WD_WindowTransparency%, ahk_id %GuiOutline%
WinHide, ahk_id %GuiOutline%
return

; Label that runs the timer. Everything starts here
!LButton::
	MouseGetPos, WD_MouseX, WD_MouseY, WD_id 	;. Get the initial mouse position and window id
	settimer, WD_Check, 100						; Start timer that checks if there was movement
return 

;. Timer: If mouse is not moving do not do anything
WD_Check: 
	if !GetKeyState( "LButton", "P" )							; Don't check if button is relased
		SetTimer, WD_Check, Off

	MouseGetPos, WD_MouseCurX, WD_MouseCurY						; Current mouse position
	
	if (WD_MouseCurX != WD_MouseX or WD_MouseCurY != WD_MouseY) 	; To prevent accidental movements
	{ 																; timer checks mouse position.
		if   ( WD_MouseCurX > ( WD_MouseX + WD_StartDragClerance ) 	; If it is bigger then 'Clerance'	
			or WD_MouseCurX < ( WD_MouseX - WD_StartDragClerance ) 	; script continues, else it still	
			or WD_MouseCurY > ( WD_MouseY + WD_StartDragClerance ) 	; waits
			or WD_MouseCurY < ( WD_MouseY - WD_StartDragClerance )) ; It causes litle jump after 
		{ 															; dragging start but can be disabled
			SetTimer, WD_Check, Off 
	
			SysGet, WD_MonitorWorkArea, MonitorWorkArea, 1	; Size is relative to workarea
			
																	; Reset to default all variables
			WD_ActionsIndexes := [1,1,1,1]	; Left, Top, Right, Bottom
			WD_IsOnEdge := 0
			
			WD_CurZoneWidth := WD_MonitorWorkAreaRight
			WD_CurZoneHeight := WD_MonitorWorkAreaBottom
			
			WD_CurZoneDividH := 1
			WD_CurZoneDividV := 1

			WinGetPos, WD_WinX, WD_WinY, WD_WinW, WD_WinH, ahk_id %WD_id% ;. Initial window position
			
			WD_MarginW := WD_WinW // WD_WindowZoneXCount 	;. Define dimensions of 9 zones
			WD_MarginH := WD_WinH // WD_WindowZoneYCount
	
			WinGet, WD_WinStyle, Style, ahk_id %WD_id%  ; If window is not resizable make it		; Set current zone numbers
			if !(WD_WinStyle & 0x40000)					; impossible to resize it by script by		; (-1,-1) | (0,-1) | (1,-1)
			{											; forcing window draging					; -------------------------
				WD_WindowZoneY := 0																	; (-1, 0) | (0, 0) | (1, 0)
				WD_WindowZoneX := 0						; Else get correct zone numbers				; -------------------------
			} 																						; (-1, 1) | (0, 1) | (1, 1)
			else										
			{
				WD_WindowZoneX := WD_GetZoneNum( WD_MouseX, WD_WinX, WD_WinW, WD_MarginW )
				WD_WindowZoneY := WD_GetZoneNum( WD_MouseY, WD_WinY, WD_WinH, WD_MarginH )
				; Alternative way to get number of zones but it's too complicated and it seems to takes much more time
				; WD_WindowZoneX := (( WD_MouseCurX - WD_WinX + WD_WinW * ( 1 - 3 / WD_WindowZoneXCount ) ) / ( WD_WindowZoneXCount - 2 ) ) // ( WD_WinW // WD_WindowZoneXCount ) - 1
				; WD_WindowZoneY := (( WD_MouseCurY - WD_WinY + WD_WinH * ( 1 - 3 / WD_WindowZoneYCount ) ) / ( WD_WindowZoneYCount - 2 ) ) // ( WD_WinH // WD_WindowZoneYCount ) - 1
			}
			
			WinGet, WD_WinState, MinMax, ahk_id %WD_id%	; Save initial window state
			if WD_WinState = 1
				if !WD_DragMaximizedWindows
					return
			
			WinSet, Style, -0x1000000, ahk_id %WD_id% 	; Set as restored (not maximized)
			
			WD_IsCentralZone := !(WD_WindowZoneX | WD_WindowZoneY)					; Zone in center
			WD_IsEdgeZone := !(WD_WindowZoneX&WD_WindowZoneY) - WD_IsCentralZone	; Zone not in center and not in corner
			
			if WD_IsCentralZone  			; It's central zone so window should be dragged
			{								; but if its maximized resize it before dragging
				if (WD_WinState)			
				{
					if WD_ResizeMaximizedBeforeDragging
					{
						WD_WinW := WD_NewWidth		
						WD_WinH := WD_NewHeight
						WD_WinX := WD_MouseCurX * ( 1 - WD_WinW / WD_MonitorWorkAreaRight )
						WD_WinY := WD_MouseCurY * ( 1 - WD_WinH / WD_MonitorWorkAreaBottom )
					}
					else
					{
						WD_WinW := WD_MonitorWorkAreaRight			
						WD_WinH := WD_MonitorWorkAreaBottom
					}
					
					WD_WinX := WD_MouseCurX * ( 1 - WD_WinW / WD_MonitorWorkAreaRight )
					WD_WinY := WD_MouseCurY * ( 1 - WD_WinH / WD_MonitorWorkAreaBottom )
					
					WinMove, ahk_id %WD_id%,, WD_WinX, WD_WinY, WD_WinW, WD_WinH ; Reposition window
				}
			}

			Loop          ;. Loop checks new mouse position and repositions (and resizes) a window
			{
				MouseGetPos, WD_MouseCurX, WD_MouseCurY 	; Get the current mouse position.
				
				if   ( WD_MouseCurX < 10 or WD_MouseCurX > A_ScreenWidth - 10 
				    or WD_MouseCurY < 10 or WD_MouseCurY > A_ScreenHeight - 10 )
				{
					WD_IsOnEdge := 1
				
					WD_ScreenZoneX := ( WD_MouseCurX - 1) // WD_ZONES_W -1	; Set screen zone numbers
					WD_ScreenZoneY := ( WD_MouseCurY - 1) // WD_ZONES_H -1
					
					WD_CurrentEdge := GetEdgeNumber(WD_MouseCurX, WD_MouseCurY)
					if !(WD_WinStyle & 0x40000)				; Window is not resizable so don't resize
						return								; and don't even show preview

					if WD_IsCentralZone						; Window is dragged
					{
						if ( 1 & ( WD_CurrentEdge - 2) )	; it's a one of horizontal zone
						{
							WD_CurZoneDividV := WD_Actions[WD_CurrentEdge][WD_ActionsIndexes[WD_CurrentEdge]]
							WD_CurZoneWidth := WD_MonitorWorkAreaRight // WD_CurZoneDividV
						}
						if ( 1 & ( WD_CurrentEdge - 3) )	; it's a one of vertical zone
						{
							
							WD_CurZoneDividH := WD_Actions[WD_CurrentEdge][WD_ActionsIndexes[WD_CurrentEdge]]
							WD_CurZoneHeight := WD_MonitorWorkAreaBottom // WD_CurZoneDividH
						}
						
						WD_NewWinX := !(1 ^ WD_ScreenZoneX) * WD_CurZoneWidth * ( WD_CurZoneDividV - 1 )
						WD_NewWinY := !(1 ^ WD_ScreenZoneY) * WD_CurZoneHeight * ( WD_CurZoneDividH - 1 )
						WD_NewWinW := (1 & WD_ScreenZoneX) * WD_CurZoneWidth + !(1 & WD_ScreenZoneX) * WD_MonitorWorkAreaRight 
						WD_NewWinH := (1 & WD_ScreenZoneY) * WD_CurZoneHeight + !(1 & WD_ScreenZoneY) * WD_MonitorWorkAreaBottom
					}
					else if (WD_IsEdgeZone)					; It's one non corner and not central zone
					{
						WD_NewWinX := WD_NewWinX * !(1&WD_CurrentEdge)
						WD_NewWinY := WD_NewWinY * !(1&(WD_CurrentEdge-1))
						WD_NewWinW := WD_NewWinW * !(1&(WD_CurrentEdge)) + WD_MonitorWorkAreaRight * !(1&WD_CurrentEdge-1)
						WD_NewWinH := WD_NewWinH* !(1&WD_CurrentEdge-1)+ WD_MonitorWorkAreaBottom * !(1&(WD_CurrentEdge))
					}
					else
					{
						; its a corner. No idea what action perform
					}
					WD_LastEdge := WD_CurrentEdge
					
					WinMove, ahk_id %GuiOutline%,, WD_NewWinX		; Move preview window
												 , WD_NewWinY
												 , WD_NewWinW
												 , WD_NewWinH
												 
					Gui 2: Show, NoActivate							; Show preview
				}
				else 
				{
					if WD_IsOnEdge ;. it just has left the edge 
					{
						WinHide,ahk_id %GuiOutline% ;hide GuiOutline when Mouse is not on any edge
						WinMove,ahk_id %GuiOutline%,,-2000,-2000, ;move Hidden window offScreen

						if WD_ActionsIndexes[WD_LastEdge] < WD_Actions[WD_LastEdge].MaxIndex()
							WD_ActionsIndexes[WD_LastEdge]++			; If it was last item from actions
						else											; Set indes on first action
							WD_ActionsIndexes[WD_LastEdge] := 1
							
						WD_IsOnEdge := 0
					}
				}
				
				if !GetKeyState( "LButton", "P" )				;. Break if button relased
				{
					WinHide,ahk_id %GuiOutline% ;hide GuiOutline when Mouse is not on any edge
					WinMove,ahk_id %GuiOutline%,,-2000,-2000, ;move Hidden window offScreen, 
					
					WinMove, ahk_id %WD_id%,, WD_NewWinX
											, WD_NewWinY
											, WD_NewWinW
											, WD_NewWinH
					
					if WD_AutoSetMaximized						; If dimensions are same as 
						if ((WD_NewWinX = 0) 					; desktop dimensions and position  
						and (WD_NewWinY = 0)					; is (0,0) maximize window
						and (WD_NewWinW = WD_MonitorWorkAreaRight)
						and (WD_NewWinH = WD_MonitorWorkAreaBottom))
							WinSet, Style, +0x1000000, ahk_id %WD_id%
					
					WD_IsOnEdge := 0
					Loop, 4									; Reset action indexes to their defaults
						WD_ActionsIndexes[A_Index] := 1

					break
				}
				
				WD_MouseCurX -= WD_MouseX		; Get the movement, calculate new position and
				WD_MouseCurY -= WD_MouseY		; size of window and finally move it
				
				WD_NewWinX := WD_WinX + WD_MouseCurX * ( !(-1 ^ WD_WindowZoneX) | WD_IsCentralZone )
				WD_NewWinY := WD_WinY + WD_MouseCurY * ( !(-1 ^ WD_WindowZoneY) | WD_IsCentralZone )
				WD_NewWinW := WD_WinW + WD_MouseCurX * WD_WindowZoneX * !WD_IsCentralZone
				WD_NewWinH := WD_WinH + WD_MouseCurY * WD_WindowZoneY * !WD_IsCentralZone

				if WD_SnapToEdges												;. Snapping to edges
				{				
					if (abs(WD_NewWinX) < WD_EdgeSnapClerance)					; Checks the clerance
					{															; and sets new position
						WD_NewWinW := WD_NewWinW + WD_NewWinX * !WD_IsCentralZone
						WD_NewWinX := 0
					}
					if (abs(WD_NewWinY) < WD_EdgeSnapClerance)
					{
						WD_NewWinH := WD_NewWinH + WD_NewWinY * !WD_IsCentralZone
						WD_NewWinY := 0
					}
					if (abs(WD_MonitorWorkAreaRight - WD_NewWinX - WD_NewWinW) < WD_EdgeSnapClerance)
					{
						WD_NewWinW := WD_NewWinW + (WD_MonitorWorkAreaRight - WD_NewWinX - WD_NewWinW)* !WD_IsCentralZone
						WD_NewWinX := WD_MonitorWorkAreaRight-WD_NewWinW 
					}
					if (abs(WD_MonitorWorkAreaBottom - WD_NewWinY - WD_NewWinH) < WD_EdgeSnapClerance)
					{
						WD_NewWinH := WD_NewWinH + (WD_MonitorWorkAreaBottom - WD_NewWinY - WD_NewWinH)* !WD_IsCentralZone
						WD_NewWinY := WD_MonitorWorkAreaBottom -WD_NewWinH
					}
				}

				WinMove, ahk_id %WD_id%,, WD_NewWinX, WD_NewWinY, WD_NewWinW, WD_NewWinH	; Finally move the window
			}
		}  
	}      
return	


; Returns -1, 0 or 1 depending on mouse and window position.
WD_GetZoneNum( MousePos, WindowPos = 0, WindowSize = 0, Margin = 0 ) {
	if ( MousePos < WindowPos + Margin )
		return -1
	else if ( MousePos > WindowPos + WindowSize - Margin )
		return 1
	else
		return 0
}


; Returns number of screen edge that mouse is closest to
;  2
; 1 3
;  4
GetEdgeNumber( MouseX, MouseY ) {
	; Function searches for the lowest distans
	Deltas := [MouseX
             , MouseY
			 , A_ScreenWidth - MouseX
			 , A_ScreenHeight - MouseY]
				
	Edge := 1

	Loop, 4 {
		if Deltas[1] > Deltas[A_Index] {
			Deltas[1] := Deltas[A_Index]
			Edge := A_Index
		}
	}
	return Edge
}