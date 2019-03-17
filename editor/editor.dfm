object feditor: Tfeditor
  Left = 267
  Top = 130
  Caption = 'Stage Editor - New Stage'
  ClientHeight = 818
  ClientWidth = 1544
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel3: TPanel
    Left = 1359
    Top = 0
    Width = 185
    Height = 818
    Align = alRight
    TabOrder = 0
    ExplicitHeight = 799
    object Image2: TImage
      Left = 1
      Top = 1
      Width = 183
      Height = 816
      Align = alClient
      Picture.Data = {
        0A544A504547496D61676584020000FFD8FFE000104A46494600010200006400
        640000FFEC00114475636B79000100040000003C0000FFEE002641646F626500
        64C0000000010300150403060A0D000001C8000001E90000023D00000282FFDB
        0084000604040405040605050609060506090B080606080B0C0A0A0B0A0A0C10
        0C0C0C0C0C0C100C0E0F100F0E0C1313141413131C1B1B1B1C1F1F1F1F1F1F1F
        1F1F1F010707070D0C0D181010181A1511151A1F1F1F1F1F1F1F1F1F1F1F1F1F
        1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F1F
        1F1F1F1FFFC2001108002C002A03011100021101031101FFC400800001010101
        0100000000000000000000000004010306010100030101000000000000000000
        0000000102030405100101010101000000000000000000000000121150201101
        0000000000000000000000000000005012010000000000000000000000000000
        00501301010101010100000000000000000000001120715051FFDA000C030100
        02110311000001F57E97380069467600014E7600014E7200029CEC00D074AC80
        00FFDA000801010001050294A529625294B1894A5294A5294A5294A5294FBFFF
        DA0008010200010502E27FFFDA0008010300010502E27FFFDA0008010202063F
        0213FFDA0008010302063F0213FFDA0008010101063F0213FFDA000801010301
        3F21F1010C0000FFDA0008010203013F21AAAAAAAAAAAAAAAAAAAAAAAAAAAAAB
        BFFFDA0008010303013F21F13FFFDA000C030100021103110000107FFEFF00FF
        00F4B699FF00FD494024924FFFDA0008010103013F10872A5297F331CB9421CA
        94ADA10843952B7FFFDA0008010203013F10F13CE0872CFFDA0008010303013F
        10888888888888888888888888888889BFFFD9}
      Stretch = True
      ExplicitLeft = -7
      ExplicitTop = -49
      ExplicitHeight = 777
    end
    object Label5: TLabel
      Left = 49
      Top = 25
      Width = 93
      Height = 13
      Alignment = taRightJustify
      Caption = 'Solid on the left: No'
      Transparent = True
    end
    object Label6: TLabel
      Left = 43
      Top = 44
      Width = 99
      Height = 13
      Alignment = taRightJustify
      Caption = 'Solid on the right: No'
      Transparent = True
    end
    object Label7: TLabel
      Left = 66
      Top = 73
      Width = 76
      Height = 13
      Alignment = taRightJustify
      Caption = 'Solid on top: No'
      Transparent = True
    end
    object Label8: TLabel
      Left = 49
      Top = 92
      Width = 93
      Height = 13
      Alignment = taRightJustify
      Caption = 'Solid on bottom: No'
      Transparent = True
    end
    object imgBackgroundPreview: TImage
      Left = 16
      Top = 207
      Width = 153
      Height = 148
      Stretch = True
    end
    object imgpreview: TImage
      Left = 62
      Top = 402
      Width = 65
      Height = 65
    end
    object lblSelRowE: TLabel
      Left = 56
      Top = 122
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = 'Selected row:'
      Transparent = True
    end
    object lblSelRowEv: TLabel
      Left = 127
      Top = 122
      Width = 6
      Height = 13
      Caption = '0'
      Transparent = True
    end
    object lblSelColEv: TLabel
      Left = 127
      Top = 141
      Width = 6
      Height = 13
      Caption = '0'
      Transparent = True
    end
    object lblSelColE: TLabel
      Left = 39
      Top = 141
      Width = 82
      Height = 13
      Alignment = taRightJustify
      Caption = 'Selected column:'
      Transparent = True
    end
    object Label2: TLabel
      Left = 56
      Top = 489
      Width = 65
      Height = 13
      Alignment = taRightJustify
      Caption = 'Selected row:'
      Transparent = True
    end
    object Label3: TLabel
      Left = 127
      Top = 489
      Width = 6
      Height = 13
      Caption = '0'
      Transparent = True
    end
    object Label4: TLabel
      Left = 127
      Top = 508
      Width = 6
      Height = 13
      Caption = '0'
      Transparent = True
    end
    object Label1: TLabel
      Left = 39
      Top = 508
      Width = 82
      Height = 13
      Alignment = taRightJustify
      Caption = 'Selected column:'
      Transparent = True
    end
    object Bevel1: TBevel
      Left = 16
      Top = 207
      Width = 153
      Height = 148
    end
    object Bevel2: TBevel
      Left = 62
      Top = 402
      Width = 65
      Height = 65
    end
    object Label9: TLabel
      Left = 64
      Top = 383
      Width = 58
      Height = 13
      Caption = 'Selected tile'
      Transparent = True
    end
    object Button1: TButton
      Left = 16
      Top = 176
      Width = 153
      Height = 25
      Caption = 'Background image...'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1359
    Height = 818
    Align = alClient
    TabOrder = 1
    ExplicitHeight = 799
    object Splitter1: TSplitter
      Left = 1
      Top = 452
      Width = 1357
      Height = 10
      Cursor = crVSplit
      Align = alBottom
      Color = clBtnFace
      ParentColor = False
      ResizeStyle = rsUpdate
      ExplicitTop = 325
    end
    object geditor: TDrawGrid
      Left = 1
      Top = 1
      Width = 1357
      Height = 451
      Align = alClient
      BorderStyle = bsNone
      ColCount = 100
      Ctl3D = False
      DefaultColWidth = 32
      DefaultRowHeight = 32
      FixedCols = 0
      RowCount = 15
      FixedRows = 0
      GridLineWidth = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goAlwaysShowEditor]
      ParentCtl3D = False
      PopupMenu = tilesetMenu
      TabOrder = 0
      OnDrawCell = geditorDrawCell
      OnKeyDown = geditorKeyDown
      OnSelectCell = geditorSelectCell
      ExplicitHeight = 432
    end
    object gtileset: TDrawGrid
      Left = 1
      Top = 462
      Width = 1357
      Height = 355
      Align = alBottom
      BorderStyle = bsNone
      ColCount = 30
      Ctl3D = False
      DefaultColWidth = 32
      DefaultRowHeight = 32
      FixedCols = 0
      RowCount = 20
      FixedRows = 0
      GridLineWidth = 0
      ParentCtl3D = False
      PopupMenu = tilesetMenu
      TabOrder = 1
      OnDrawCell = gtilesetDrawCell
      OnSelectCell = gtilesetSelectCell
      ExplicitTop = 443
    end
  end
  object MainMenu1: TMainMenu
    Left = 64
    Top = 16
    object File1: TMenuItem
      Caption = 'File'
      object Newstage1: TMenuItem
        Caption = 'New stage'
        ShortCut = 16462
        OnClick = Newstage1Click
      end
      object Loadstage1: TMenuItem
        Caption = 'Open'
        ShortCut = 16463
        OnClick = Loadstage1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Savestage1: TMenuItem
        Caption = 'Save'
        ShortCut = 16467
        OnClick = Savestage1Click
      end
      object Saveas1: TMenuItem
        Caption = 'Save as'
        OnClick = Saveas1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Exit1: TMenuItem
        Caption = 'Exit'
        OnClick = Exit1Click
      end
    end
    object About1: TMenuItem
      Caption = 'About'
    end
  end
  object tilesetMenu: TPopupMenu
    Left = 96
    Top = 16
    object Drawinselectedarea1: TMenuItem
      Caption = 'Fill selected area (solid)'
      OnClick = Drawinselectedarea1Click
    end
    object Fillselectedareaonsolid1: TMenuItem
      Caption = 'Fill selected area (non solid)'
      OnClick = Fillselectedareaonsolid1Click
    end
    object N6: TMenuItem
      Caption = '-'
    end
    object Clearselectedarea1: TMenuItem
      Caption = 'Clear selected area'
      OnClick = Clearselectedarea1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Makeallsurfacessolid1: TMenuItem
      Caption = 'Make all surfaces solid'
      OnClick = Makeallsurfacessolid1Click
    end
    object Makeallsurfacesnonsolid1: TMenuItem
      Caption = 'Make all surfaces non solid'
      OnClick = Makeallsurfacesnonsolid1Click
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object Makethisareasolid1: TMenuItem
      Caption = 'Make only left surface solid'
      OnClick = Makethisareasolid1Click
    end
    object Makethisareanonsolid1: TMenuItem
      Caption = 'Make only right surface solid'
      OnClick = Makethisareanonsolid1Click
    end
    object Makethisareasolidontop1: TMenuItem
      Caption = 'Make only top surface solid'
      OnClick = Makethisareasolidontop1Click
    end
    object Makebottomsolid1: TMenuItem
      Caption = 'Make only bottom surface solid'
      OnClick = Makebottomsolid1Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object Front1: TMenuItem
      Caption = 'Front'
      OnClick = Front1Click
    end
    object Back1: TMenuItem
      Caption = 'Back'
      OnClick = Back1Click
    end
    object N11: TMenuItem
      Caption = '-'
    end
    object Pipeleadingintostage1: TMenuItem
      Caption = 'Pipe leading into stage...'
      OnClick = Pipeleadingintostage1Click
    end
    object Coinblock1: TMenuItem
      Caption = 'Toggle coin block'
      OnClick = Coinblock1Click
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object Breakable1: TMenuItem
      Caption = 'Breakable'
      OnClick = Breakable1Click
    end
    object Unbreakable1: TMenuItem
      Caption = 'Unbreakable'
      OnClick = Unbreakable1Click
    end
    object N9: TMenuItem
      Caption = '-'
    end
    object Quicksand1: TMenuItem
      Caption = 'Quicksand'
      object High1: TMenuItem
        Caption = 'Fast sinking'
        OnClick = High1Click
      end
      object Normal2: TMenuItem
        Caption = 'Average sinking'
        OnClick = Normal2Click
      end
      object Slowsinking1: TMenuItem
        Caption = 'Slow sinking'
        OnClick = Slowsinking1Click
      end
    end
    object Water1: TMenuItem
      Caption = 'Water'
      OnClick = Water1Click
    end
    object Normal1: TMenuItem
      Caption = 'Normal'
      OnClick = Normal1Click
    end
    object N8: TMenuItem
      Caption = '-'
    end
    object Slopefromtheleft1: TMenuItem
      Caption = 'Slope from the left'
      OnClick = Slopefromtheleft1Click
    end
    object Slopefromtheright1: TMenuItem
      Caption = 'Slope from the right'
      OnClick = Slopefromtheright1Click
    end
    object Straight1: TMenuItem
      Caption = 'Straight'
      OnClick = Straight1Click
    end
    object N7: TMenuItem
      Caption = '-'
    end
    object Pasteselection1: TMenuItem
      Caption = 'Paste selection (solid)'
      OnClick = Pasteselection1Click
    end
    object Pasteselectionnonsolid1: TMenuItem
      Caption = 'Paste selection (non solid)'
      OnClick = Pasteselectionnonsolid1Click
    end
  end
  object dlgopen: TOpenDialog
    DefaultExt = 'stg'
    Filter = 'Stages (*.stg)|*.stg|All files (*.*)|*.*'
    InitialDir = '..\stages'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Title = 'Open stage'
    Left = 64
    Top = 48
  end
  object dlgsave: TSaveDialog
    DefaultExt = 'stg'
    Filter = 'Stages (*.stg)|*.stg|All files (*.*)|*.*'
    InitialDir = '..\stages'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Title = 'Save stage'
    Left = 96
    Top = 48
  end
  object dlgopenpic: TOpenPictureDialog
    DefaultExt = 'bmp'
    Filter = 'Bitmaps (*.bmp)|*.bmp'
    InitialDir = '..\bitmaps'
    Title = 'Choose a bitmap file'
    Left = 64
    Top = 80
  end
end
