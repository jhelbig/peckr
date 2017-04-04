#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=peckr_icon.ico
#AutoIt3Wrapper_Outfile=Peckr.exe
#AutoIt3Wrapper_Res_Description=easy to use keycombo app to copy and paste raw color codes in Hex or RGB format
#AutoIt3Wrapper_Res_Fileversion=1.0.0.4
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=2017 Jake Helbig
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Color.au3>
#include <Clipboard.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>
#Region ### START Koda GUI section ### Form=
$peckr_ui = GUICreate("Peckr", 135, 20, @DesktopWidth-300, 0, BitOR($WS_POPUP,$WS_BORDER), $WS_EX_TOPMOST)
$color_lbl = GUICtrlCreateLabel("Peckr", 8, 3, 130, 17)
Global $state = 1
Global $history = [0]
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1

	HotKeySet("`", "safety")

	;change background color to what mouse is hovering over
	$mousepos = MouseGetPos();get mouse position
	$pix_color = PixelGetColor($mousepos[0], $mousepos[1])
	$hex_color = ("0x" & Hex($pix_color, 6))
	$brightness_checker = _ColorGetRGB($pix_color)

	if((($brightness_checker[0] > 170) AND ($brightness_checker[1] > 170)) OR (($brightness_checker[1] > 170) AND ($brightness_checker[2] > 170)) OR (($brightness_checker[0] > 170) AND ($brightness_checker[2] > 170))) Then
		GUICtrlSetColor($color_lbl, 0x000000)
	Else
		GUICtrlSetColor($color_lbl, 0xFFFFFF)
	EndIf
	GUISetBkColor($hex_color, $peckr_ui)
	if($state == 1) Then
		GUICtrlSetData($color_lbl, "#" & Hex($pix_color, 6))
	Else
		$rgb = _ColorGetRGB($pix_color)
		GUICtrlSetData($color_lbl, ("RGB:  " & $rgb[0] & "   " & $rgb[1] & "   " & $rgb[2]))
	EndIf


	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

Func safety()
	HotKeySet("{F1}", "viewHistory")
	HotKeySet("3", "copyHex")
	HotKeySet("2", "copyRGB")
	HotKeySet("1", "state")
	HotKeySet("{esc}", "exitprog")
	Sleep(500)
	HotKeySet("{F1}")
	HotKeySet("3")
	HotKeySet("2")
	HotKeySet("1")
	HotKeySet("{esc}")
EndFunc


Func copyHex()
	addToHistory()
	$color = Hex($pix_color, 6)
	if ( $state == 1 ) Then
		_ClipBoard_SetData("#" & $color)
	Else
		_ClipBoard_SetData($color)
	EndIf
	HotKeySet("3")
EndFunc

Func copyRGB()
	addToHistory()
	$rgb = _ColorGetRGB($pix_color)
	if ( $state == 1 ) Then
		_ClipBoard_SetData("rgb(" & $rgb[0] & ", " & $rgb[1] & ", " & $rgb[2]& ")")
	Else
		_ClipBoard_SetData("rgba(" & $rgb[0] & ", " & $rgb[1] & ", " & $rgb[2]& ", 1)")
	EndIf
	HotKeySet("2")
EndFunc

Func addToHistory()
	if ( UBound($history) == 1 And $history[0] == 0 ) Then
		$history[0] = $pix_color
	Else
		_ArrayAdd($history, $pix_color)
	EndIf
EndFunc

Func viewHistory()
	HotKeySet("{F1}")
	HotKeySet("{esc}")
	if ( UBound($history) == 1 And $history[0] == 0 ) Then
		MsgBox(16, "Error", "History could not be found, please copy a few colors before attempting to review history.")
	Else
		$history_gui = GUICreate("Peckr History", 230, 200, @DesktopWidth-300, 25, BitOR($WS_POPUP,$WS_BORDER), $WS_EX_TOPMOST)
		GUISetState()

		Local $idListview = GUICtrlCreateListView("  HEX         |  RGB         |   raw", 10, 10, 210, 150) ;,$LVS_SORTDESCENDING)
		Local $closeBtn = GUICtrlCreateButton("Close", 10, 170, 210, 20)
		Local $itemList = [0]
		For $pixel in $history
			$color = Hex($pixel, 6)
			$rgb = _ColorGetRGB("0x" & $color)
			_ArrayAdd($itemList, GUICtrlCreateListViewItem("#" & $color & "|" & $rgb[0] & ", " & $rgb[1] & ", " & $rgb[2] & "|0x" & $color, $idListview))
		Next
		_ArrayDelete($itemList, 0)
		GUISetState(@SW_SHOW)

		; Loop until the user exits.
		While 1
			$guiMsg = GUIGetMsg()
			Switch $guiMsg
				Case $closeBtn
					GUISetState(@SW_HIDE, $history_gui)
					GUISetState($GUI_ENABLE, $peckr_ui)
					ExitLoop
				Case $itemList[0] To $itemList[UBound($itemList)-1]
					$rowData = StringSplit(GUICtrlRead($guiMsg), "|")
	 				GUISetBkColor($rowData[3])
			EndSwitch
		WEnd
	EndIf
EndFunc

Func state()
	if ( $state == 1 ) Then
		$state = 0
	Else
		$state = 1
	EndIf
EndFunc

Func exitprog()
	Exit
EndFunc