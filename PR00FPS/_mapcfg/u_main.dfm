object frm_main: Tfrm_main
  Left = 204
  Top = 108
  ActiveControl = ed_skybox
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'MapCfg'
  ClientHeight = 120
  ClientWidth = 338
  Color = clAppWorkSpace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mm
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object gbox_main: TGroupBox
    Left = 8
    Top = 8
    Width = 321
    Height = 105
    Caption = '[ Map be'#225'll'#237't'#225'sai ]'
    Color = clAppWorkSpace
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 0
    object lbl_a: TLabel
      Left = 13
      Top = 26
      Width = 76
      Height = 13
      Caption = 'Skybox ('#233'gbolt):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object spbtn_browse: TSpeedButton
      Left = 292
      Top = 24
      Width = 24
      Height = 22
      Cursor = crHandPoint
      Hint = 'Keres'#233's...'
      Caption = '...'
      Flat = True
      ParentShowHint = False
      ShowHint = True
      OnClick = spbtn_browseClick
    end
    object shp_color: TShape
      Left = 96
      Top = 48
      Width = 33
      Height = 17
      Cursor = crHandPoint
      Hint = 'Sz'#237'n megad'#225'sa...'
      ParentShowHint = False
      ShowHint = True
      OnMouseDown = shp_colorMouseDown
    end
    object lbl_b: TLabel
      Left = 13
      Top = 50
      Width = 76
      Height = 13
      Caption = 'Skycolor (RGB):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lbl_c: TLabel
      Left = 13
      Top = 74
      Width = 63
      Height = 13
      Caption = 'Sk'#225'l'#225'z'#225's (%):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object ed_skybox: TEdit
      Left = 96
      Top = 24
      Width = 193
      Height = 19
      Color = clSilver
      Ctl3D = False
      MaxLength = 40
      ParentCtl3D = False
      TabOrder = 0
    end
    object sped_scale: TSpinEdit
      Left = 96
      Top = 71
      Width = 57
      Height = 22
      AutoSize = False
      Color = clSilver
      Ctl3D = False
      Increment = 10
      MaxValue = 65535
      MinValue = 1
      ParentCtl3D = False
      TabOrder = 1
      Value = 100
    end
  end
  object mm: TMainMenu
    Top = 1
    object Fjl1: TMenuItem
      Caption = 'F'#225'jl'
      object j1: TMenuItem
        Caption = #218'j'
        ShortCut = 16462
        OnClick = j1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Megnyits1: TMenuItem
        Caption = 'Megnyit'#225's...'
        ShortCut = 16460
        OnClick = Megnyits1Click
      end
      object Ments1: TMenuItem
        Caption = 'Ment'#233's...'
        ShortCut = 16467
        OnClick = Ments1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Kilps1: TMenuItem
        Caption = 'Kil'#233'p'#233's'
        ShortCut = 32883
        OnClick = Kilps1Click
      end
    end
    object Segtsg1: TMenuItem
      Caption = 'Seg'#237'ts'#233'g'
      object Nvjegy1: TMenuItem
        Caption = 'N'#233'vjegy'
        OnClick = Nvjegy1Click
      end
    end
  end
  object dlg_openskybox: TOpenDialog
    Filter = 'WaveFront OBJ f'#225'jl (*.obj)|*.obj|Minden f'#225'jl (*.*)|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing, ofDontAddToRecent]
    Title = 'Skybox megnyit'#225'sa...'
    Left = 65535
    Top = 29
  end
  object dlg_color: TColorDialog
    Ctl3D = True
    Options = [cdFullOpen]
    Left = 65535
    Top = 57
  end
  object dlg_save: TSaveDialog
    Filter = 'Map Cfg f'#225'jl (*.dat)|*.dat|Minden f'#225'jl (*.*)|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing, ofDontAddToRecent]
    Title = 'Map Cfg f'#225'jl ment'#233'se...'
    Left = 56
  end
  object dlg_open: TOpenDialog
    Filter = 'Map Cfg f'#225'jl (*.dat)|*.dat|Minden f'#225'jl (*.*)|*.*'
    Options = [ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Title = 'Map Cfg f'#225'jl megnyit'#225'sa...'
    Left = 28
  end
end
