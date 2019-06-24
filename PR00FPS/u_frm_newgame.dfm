object frm_newgame: Tfrm_newgame
  Left = 194
  Top = 108
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  Caption = #218'j j'#225't'#233'k'
  ClientHeight = 473
  ClientWidth = 401
  Color = 8209982
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWhite
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gbox_map: TGroupBox
    Left = 8
    Top = 8
    Width = 385
    Height = 145
    Caption = '[ P'#225'lya kiv'#225'laszt'#225'sa ]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object img_map: TImage
      Left = 166
      Top = 24
      Width = 140
      Height = 105
      Center = True
      Stretch = True
    end
    object lbox_maps: TListBox
      Left = 16
      Top = 24
      Width = 145
      Height = 105
      Cursor = crHandPoint
      AutoComplete = False
      Color = 11627619
      Ctl3D = False
      ExtendedSelect = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      OnClick = lbox_mapsClick
      OnDblClick = lbox_mapsDblClick
    end
    object pnl_infobg: TPanel
      Left = 316
      Top = 24
      Width = 58
      Height = 106
      BevelInner = bvLowered
      Color = 11231060
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 1
      object spbtn_info: TSpeedButton
        Left = 0
        Top = 0
        Width = 57
        Height = 105
        Cursor = crHandPoint
        Hint = 
          'A kiv'#225'lasztott p'#225'ly'#225'hoz tartoz'#243' opcion'#225'lis sz'#246'vegf'#225'jl megtekint'#233 +
          'se'
        Caption = 'i'
        Flat = True
        Font.Charset = EASTEUROPE_CHARSET
        Font.Color = clWhite
        Font.Height = -64
        Font.Name = 'Garamond'
        Font.Style = [fsBold]
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = spbtn_infoClick
      end
    end
  end
  object gbox_gamemode: TGroupBox
    Left = 8
    Top = 160
    Width = 201
    Height = 97
    Caption = '[ J'#225't'#233'km'#243'd ]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 1
    object rbtn_dm: TRadioButton
      Left = 16
      Top = 24
      Width = 177
      Height = 17
      Cursor = crHandPoint
      Hint = 'No comment'
      Caption = 'Mindenki mindenki ellen'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
    end
    object rbtn_tdm: TRadioButton
      Left = 16
      Top = 45
      Width = 177
      Height = 17
      Cursor = crHandPoint
      Hint = 'K'#233't csapat - pirosak '#233's k'#233'kek egym'#225's ellen'
      Caption = 'Csapat csapat ellen'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
    end
    object rbtn_gauss: TRadioButton
      Left = 16
      Top = 66
      Width = 177
      Height = 17
      Cursor = crHandPoint
      Hint = 'Egy megjel'#246'lt j'#225't'#233'kos (Gauss) az '#246'sszes t'#246'bbi ellen'
      Caption = 'Gauss - elimin'#225'ci'#243
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
    end
  end
  object gbox_gamelimit: TGroupBox
    Left = 216
    Top = 160
    Width = 177
    Height = 97
    Caption = '[ J'#225't'#233'k v'#233'ge ]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 2
    object rbtn_time: TRadioButton
      Left = 16
      Top = 24
      Width = 97
      Height = 17
      Cursor = crHandPoint
      Hint = 'Megadott perc lej'#225'rta ut'#225'n '#250'jraindul a j'#225't'#233'k'
      Caption = 'Id'#337'limit (perc):'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      OnClick = rbtn_timeClick
    end
    object rbtn_frag: TRadioButton
      Left = 16
      Top = 45
      Width = 97
      Height = 17
      Cursor = crHandPoint
      Hint = 'Megadott frag el'#233'r'#233'se ut'#225'n '#250'jraindul a j'#225't'#233'k'
      Caption = 'Fraglimit:'
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TabStop = True
      OnClick = rbtn_fragClick
    end
    object rbtn_never: TRadioButton
      Left = 16
      Top = 66
      Width = 97
      Height = 17
      Cursor = crHandPoint
      Hint = 'Addig megy a j'#225't'#233'k, am'#237'g ki nem l'#233'p'#252'nk bel'#337'le'
      Caption = 'Am'#237'g tart'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      OnClick = rbtn_neverClick
    end
    object sped_timelimit: TSpinEdit
      Left = 117
      Top = 21
      Width = 44
      Height = 22
      AutoSelect = False
      AutoSize = False
      Color = 11627619
      Ctl3D = False
      EditorEnabled = False
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxValue = 999
      MinValue = 1
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 3
      Value = 10
    end
    object sped_fraglimit: TSpinEdit
      Left = 117
      Top = 43
      Width = 44
      Height = 22
      AutoSelect = False
      AutoSize = False
      Color = 11627619
      Ctl3D = False
      EditorEnabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      MaxValue = 999
      MinValue = 1
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 4
      Value = 10
    end
  end
  object gbox_players: TGroupBox
    Left = 8
    Top = 264
    Width = 313
    Height = 201
    Caption = '[ J'#225't'#233'kosok ]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 3
    object lbl_chosen: TLabel
      Left = 18
      Top = 68
      Width = 69
      Height = 13
      Caption = 'Kiv'#225'lasztottak:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lbl_selectable: TLabel
      Left = 178
      Top = 68
      Width = 73
      Height = 13
      Caption = 'Nem j'#225'tszanak:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lbl_info: TLabel
      Left = 16
      Top = 24
      Width = 271
      Height = 39
      Caption = 
        'B'#225'rmennyit '#225't lehet rakni bal oldalra, de nem biztos, hogy minde' +
        'nki j'#225'tszhat. Ez a p'#225'ly'#225'n l'#233'v'#337' start pontok sz'#225'm'#225't'#243'l f'#252'gg.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object lbox_chosen: TListBox
      Left = 16
      Top = 101
      Width = 121
      Height = 89
      Cursor = crHandPoint
      AutoComplete = False
      BorderStyle = bsNone
      Color = 11627619
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      MultiSelect = True
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      OnDblClick = lbox_chosenDblClick
    end
    object lbox_selectable: TListBox
      Left = 176
      Top = 86
      Width = 121
      Height = 105
      Cursor = crHandPoint
      AutoComplete = False
      BorderStyle = bsNone
      Color = 11627619
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      MultiSelect = True
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 1
      OnDblClick = lbox_selectableDblClick
    end
    object ed_playername: TEdit
      Left = 16
      Top = 86
      Width = 121
      Height = 15
      Hint = 'A g'#233'p el'#337'tt '#252'l'#337' j'#225't'#233'kos neve'
      AutoSelect = False
      AutoSize = False
      Color = 11627619
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      HideSelection = False
      MaxLength = 20
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 2
      Text = 'N'#233'vtelen J'#225't'#233'kos'
    end
    object pnl_copytoleftbg: TPanel
      Left = 143
      Top = 87
      Width = 23
      Height = 23
      BevelInner = bvLowered
      Color = 11231060
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 3
      object spbtn_copytoleft: TSpeedButton
        Left = 0
        Top = 0
        Width = 22
        Height = 22
        Cursor = crHandPoint
        Hint = 'Kiv'#225'lasztott bot hozz'#225'ad'#225'sa a j'#225't'#233'khoz'
        Caption = '<'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = spbtn_copytoleftClick
      end
    end
    object pnl_copytorightbg: TPanel
      Left = 143
      Top = 112
      Width = 23
      Height = 23
      BevelInner = bvLowered
      Color = 11231060
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 4
      object spbtn_copytoright: TSpeedButton
        Left = 0
        Top = 0
        Width = 23
        Height = 22
        Cursor = crHandPoint
        Hint = 'Kiv'#225'lasztott bot elt'#225'vol'#237't'#225'sa a j'#225't'#233'kb'#243'l'
        Caption = '>'
        Flat = True
        ParentShowHint = False
        ShowHint = True
        OnClick = spbtn_copytorightClick
      end
    end
    object pnl_copyalltoleftbg: TPanel
      Left = 143
      Top = 141
      Width = 23
      Height = 23
      BevelInner = bvLowered
      Color = 11231060
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 5
      object spbtn_copyalltoleft: TSpeedButton
        Left = 0
        Top = 0
        Width = 23
        Height = 22
        Cursor = crHandPoint
        Hint = 'Az '#246'sszes bot hozz'#225'ad'#225'sa a j'#225't'#233'khoz'
        Caption = '<<'
        Flat = True
        OnClick = spbtn_copyalltoleftClick
      end
    end
    object pnl_copyalltorightbg: TPanel
      Left = 143
      Top = 166
      Width = 23
      Height = 23
      BevelInner = bvLowered
      Color = 11231060
      Ctl3D = True
      ParentCtl3D = False
      TabOrder = 6
      object spbtn_copyalltoright: TSpeedButton
        Left = 0
        Top = 0
        Width = 23
        Height = 22
        Cursor = crHandPoint
        Hint = 'Az '#246'sszes bot elt'#225'vol'#237't'#225'sa a j'#225't'#233'kb'#243'l'
        Caption = '>>'
        Flat = True
        OnClick = spbtn_copyalltorightClick
      end
    end
  end
  object pnl_playbg: TPanel
    Left = 328
    Top = 269
    Width = 66
    Height = 196
    BevelInner = bvLowered
    Color = 11231060
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 4
    object spbtn_play: TSpeedButton
      Left = 0
      Top = 0
      Width = 65
      Height = 196
      Cursor = crHandPoint
      Hint = 'J'#225't'#233'k ind'#237't'#225'sa'
      Caption = 'OK'
      Flat = True
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWhite
      Font.Height = -32
      Font.Name = 'Garamond'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = spbtn_playClick
    end
  end
end
