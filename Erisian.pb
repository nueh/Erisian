;@@ <key>LSUIElement</key>
;@@ <string>1</string>
;@@ CFBundleIdentifier = de.nueh.Erisian
;@@ CFBundleShortVersionString = 0.6.0
;@@ NSHumanReadableCopyright = © 2014 Niklas Hennigs
;@@ CFBundleIconFile = Erisian
;@R Erisian.icns
;@R Erisian.png
;@@ DisableDebugWindow

EnableExplicit

#Version = "0.6.0"

#NSVariableStatusItemLength = -1
#NSSquareStatusBarItemLength = -2

#ResourceFolder = "Resources/"
; #ResourceFolder = "/Users/niklas/code/Erisian/Erisian.app/Contents/Resources/"

Define ItemLength.CGFloat = 64
Define Alpha.CGFloat = 0.0
Define StatusBar.i
Global StatusItem.i
Global Title.s = "Hail Eris!"
Global Tooltip.s = "Umlaut Zebra über alles!"
Global Erisian.s
Define.i D, M, Y
Define.i x, y
Define short.b
Global AboutTitle, AboutVersion, AboutText, AboutAuthor, ErisianIcon
Define nuehde, DiscordianLink


Procedure.s Suffix(DayOfSeason)
  
  Protected.i ones, tens
  Protected.s suffix
  
  ones = DayOfSeason % 10
  tens = (DayOfSeason / 10) % 10
  
  If tens = 1
    suffix = "th"
  Else
    Select ones
      Case 1
        suffix= "st"
      Case 2
        suffix = "nd"
      Case 3
        suffix = "rd"
      Default
        suffix = "th"
    EndSelect
  EndIf
  ProcedureReturn suffix
EndProcedure


Procedure.s DiscordianDate(Y, M, D, short)
  
  Protected DoY=DayOfYear(Date(Y,M,D,0,0,0)), Yold$=Str(Y+1166), DoS.i, Season.s, Season_short.s
  
  Dim Seasons.s(4)
;   Seasons(0)="Chaos"
;   Seasons(1)="Zwietracht"
;   Seasons(2)="Verwirrung"
;   Seasons(3)="Bürokratie"
;   Seasons(4)="Der Ausklang"
  Seasons(0)="Chaos"
  Seasons(1)="Discord"
  Seasons(2)="Confusion"
  Seasons(3)="Bureaucracy"
  Seasons(4)="The Aftermath"
  
  Dim Seasons_short.s(4)
;   Seasons(0)="Chaos"
;   Seasons(1)="Zwietracht"
;   Seasons(2)="Verwirrung"
;   Seasons(3)="Bürokratie"
;   Seasons(4)="Der Ausklang"
  Seasons_short(0)="Chs"
  Seasons_short(1)="Dsc"
  Seasons_short(2)="Cnf"
  Seasons_short(3)="Bcy"
  Seasons_short(4)="Afm"
  
  Dim Weekdays.s(4)
;   Weekdays(0)="Apfelcum"
;   Weekdays(1)="Süßmorgen"
;   Weekdays(2)="Blütezeit"
;   Weekdays(3)="Beißtag"
;   Weekdays(4)="Kribbel-Kribbel"
  Weekdays(0)="Setting Orange"
  Weekdays(1)="Sweetmorn"
  Weekdays(2)="Boomtime"
  Weekdays(3)="Pungenday"
  Weekdays(4)="Prickle-Prickle"
  
  Dim Weekdays_short.s(4)
;   Weekdays(0)="Apfelcum"
;   Weekdays(1)="Süßmorgen"
;   Weekdays(2)="Blütezeit"
;   Weekdays(3)="Beißtag"
;   Weekdays(4)="Kribbel-Kribbel"
  Weekdays_short(0)="SO"
  Weekdays_short(1)="SM"
  Weekdays_short(2)="BT"
  Weekdays_short(3)="PD"
  Weekdays_short(4)="PP"
  
  If (Y%4=0 And Y%100) Or Y%400=0
    If M=2 And D=29
;       ProcedureReturn "St. Tibs Tag, JULG " + Yold$
      ProcedureReturn "St. Tib's Day, YOLD " + Yold$
    ElseIf DoY>=2*30
      DoY-1
    EndIf
  EndIf
  
  
  DoS = (DoY%73) ; DoS = Day of Season
  
  If DoY >= 365
    Season = Seasons(4)
    Season_short = Seasons_short(4)
  Else
    Season = Seasons(DoY/73)
    Season_short = Seasons_short(DoY/73)
  EndIf
  
  
  If DoS = 0
    DoS = 73
    Season       = Seasons((DoY/73)-1)
    Season_short = Seasons_short((DoY/73)-1)
  EndIf
  
  
  ;   ProcedureReturn Weekdays(DoY%5)+", der "+Str(DoY%73)+". Tag von "+Seasons(DoY/73)+" im JULG "+Yold$
  If short
    ProcedureReturn Season_short + " " + Str(DoS)
  Else
    ProcedureReturn Weekdays(DoY%5)+", the "+Str(DoS)+Suffix(DoS)+" day of "+Season+" in the YOLD "+Yold$
  EndIf
EndProcedure


Procedure SetDiscordianDate()
  Define.i ytoday, mtoday, dtoday
  
  ytoday = Year(Date())
  mtoday = Month(Date())
  dtoday = Day(Date())
  
  Erisian = DiscordianDate(ytoday, mtoday, dtoday, #False)
  Title = DiscordianDate(ytoday, mtoday, dtoday, #True)
  
  CocoaMessage(0, StatusItem, "setTitle:$", @Title)
  CocoaMessage(0, StatusItem, "setToolTip:$", @Tooltip)
  ; ----- Create menu with entries for click on SysTray icon
  CreatePopupMenu(0)
  MenuItem(0, Erisian)
  MenuBar()
  MenuItem(1, "About Erisian")
  MenuBar()
  MenuItem(2, "Quit Erisian")
  CocoaMessage(0, StatusItem, "setMenu:",
               CocoaMessage(0, MenuID(0), "firstObject"))
EndProcedure


Procedure NuehDeLinkhandler()
  RunProgram("open", "http://nueh.de", "")
EndProcedure


Procedure DiscordianLinkhandler()
  RunProgram("open", "http://en.wikipedia.org/wiki/Discordian_calendar", "")
EndProcedure 




ExamineDesktops()
x = DesktopWidth(0)/2-150
y = 150
OpenWindow(0, x, y, 300, 280, "About Erisian")
HideWindow(0, #True)

UsePNGImageDecoder()
ErisianIcon = LoadImage(#PB_Any, #ResourceFolder + "Erisian.png")
ImageGadget(#PB_Any, 86, 10, 128, 128, ImageID(ErisianIcon))
LoadFont(0, "Lucida Grande", 14, #PB_Font_Bold)
LoadFont(1,"Lucida Grande", 13)
LoadFont(2, "Lucida Grande", 11)
LoadFont(3, "Lucida Grande", 12)

AboutTitle = TextGadget(#PB_Any, 85, 145, 128, 23, "Erisian", #PB_Text_Center)
SetGadgetFont(AboutTitle, FontID(0))
AboutVersion = TextGadget(#PB_Any, 100, 168, 100, 25, #Version + " (" + #pb_editor_buildcount + ")", #PB_Text_Center)
AboutText = TextGadget(#PB_Any, 25, 195, 250, 77, "Erisian displays the current date according to the Discordian calendar.", #PB_Text_Center)
AboutAuthor = TextGadget(#PB_Any, 15, 250, 60, 25, "© 2014 Niklas Hennigs")

; nuehde = HyperLinkGadget(#PB_Any, 60, 250, 65, 25, "nueh.de", RGB(0, 0, 0))
GadgetToolTip(AboutAuthor, "http://nueh.de")
; SetGadgetFont(nuehde, FontID(1))
; BindGadgetEvent(nuehde, @NuehDeLinkhandler())

DiscordianLink = HyperLinkGadget(#PB_Any, 135, 211, 150, 25, "Discordian calendar", RGB($ED,$ED,$ED))
GadgetToolTip(DiscordianLink, "http://en.wikipedia.org/wiki/Discordian_calendar")
SetGadgetFont(DiscordianLink, FontID(3))
CocoaMessage(0, GadgetID(DiscordianLink), "setOpaque:", #NO)
CocoaMessage(0, GadgetID(DiscordianLink), "setAlphaValue:@", @Alpha)
BindGadgetEvent(DiscordianLink, @DiscordianLinkhandler())

AddWindowTimer(0, 1, 500)
BindEvent(#PB_Event_Timer, @SetDiscordianDate())

StatusBar = CocoaMessage(0, 0, "NSStatusBar systemStatusBar")

If StatusBar
  ; ----- Create icon in system status bar (SysTray)
  StatusItem = CocoaMessage(0, CocoaMessage(0, StatusBar,
                                            "statusItemWithLength:", #NSVariableStatusItemLength), "retain")
  
  If StatusItem
    CocoaMessage(0, StatusItem, "setLength:@", @ItemLength)
    CocoaMessage(0, StatusItem, "setTitle:$", @Title)
    CocoaMessage(0, StatusItem, "setToolTip:$", @Tooltip)
    CocoaMessage(0, StatusItem, "setHighlightMode:", @"YES")
        
    
    Repeat
      Select WaitWindowEvent()
        Case #PB_Event_CloseWindow
          HideWindow(0, #True)
        Case #PB_Event_Menu
          Select EventMenu()
            Case 0
              SetClipboardText(Erisian)
              Message_OSD("Date copied to clipboard")
            Case 1
              CocoaMessage(0, NSApp(), "activateIgnoringOtherApps:", @"YES")
              HideWindow(0, #False)
            Case 2
              Break
          EndSelect
      EndSelect
    ForEver
  EndIf
EndIf
; IDE Options = PureBasic 5.42 LTS (MacOS X - x64)
; CursorPosition = 18
; FirstLine = 11
; Folding = -
; EnableUnicode
; EnableXP
; Executable = ../../Desktop/Erisian.app
; EnableCompileCount = 137
; EnableBuildCount = 45
; EnableExeConstant