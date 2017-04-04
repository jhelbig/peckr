;~ 			Copyright (c) 2013, Jacob(Jake) Helbig
;~ 			All rights reserved.

;~ 			Redistribution and use in source and binary forms, with or without
;~ 			modification, are permitted provided that the following conditions are met:
;~ 			1. Redistributions of source code must retain the above copyright
;~ 			   notice, this list of conditions and the following disclaimer.
;~ 			2. Redistributions in binary form must reproduce the above copyright
;~ 			   notice, this list of conditions and the following disclaimer in the
;~ 			   documentation and/or other materials provided with the distribution.
;~ 			3. All advertising materials mentioning features or use of this software
;~ 			   must display the following acknowledgement:
;~ 			   This product includes software developed by Jake Helbig.
;~ 			4. Neither the name of Jake Helbig nor the
;~ 			   names of its contributors may be used to endorse or promote products
;~ 			   derived from this software without specific prior written permission.

;~ 			THIS SOFTWARE IS PROVIDED BY JAKE HELBIG ''AS IS'' AND ANY
;~ 			EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;~ 			WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;~ 			DISCLAIMED. IN NO EVENT SHALL JAKE HELBIG BE LIABLE FOR ANY
;~ 			DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
;~ 			(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
;~ 			LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
;~ 			ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;~ 			(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
;~ 			SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=peckr_icon.ico
#AutoIt3Wrapper_Outfile=Peckr.exe
#AutoIt3Wrapper_Res_Description=easy to use keycombo app to copy and paste raw color codes in Hex or RGB format
#AutoIt3Wrapper_Res_Fileversion=1.0.0.3
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=2013 Jake Helbig
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Color.au3>
#include <Clipboard.au3>
#Region ### START Koda GUI section ### Form=
$peckr_ui = GUICreate("Peckr", 117, 20, @DesktopWidth-300, 0, BitOR($WS_POPUP,$WS_BORDER), $WS_EX_TOPMOST)
$color_lbl = GUICtrlCreateLabel("Peckr", 8, 3, 100, 17)
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
	GUICtrlSetData($color_lbl, "#" & Hex($pix_color, 6))


	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

Func safety()
	HotKeySet("{F1}", "copyHex")
	HotKeySet("{F2}", "copyRGB")
	HotKeySet("x", "exitprog")
	Sleep(500)
	HotKeySet("{F1}")
	HotKeySet("{F2}")
	HotKeySet("x")
EndFunc


Func copyHex()
	$color = Hex($pix_color, 6)
	_ClipBoard_SetData("#" & $color)
	HotKeySet("{F1}")
EndFunc

Func copyRGB()
	$rgb = _ColorGetRGB($pix_color)
	_ClipBoard_SetData("rgb(" & $rgb[0] & ", " & $rgb[1] & ", " & $rgb[2]& ")")
	HotKeySet("{F2}")
EndFunc

Func exitprog()
	Exit
EndFunc
