object frm_gfxsettings: Tfrm_gfxsettings
  Left = 785
  Top = 189
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  Caption = 'R'#233'szletes grafika be'#225'll'#237't'#225'sok'
  ClientHeight = 512
  ClientWidth = 233
  Color = 9523784
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
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_resolution: TLabel
    Left = 8
    Top = 6
    Width = 104
    Height = 13
    Caption = 'K'#233'pfelbont'#225's (px x px)'
  end
  object lbl_freq: TLabel
    Left = 8
    Top = 119
    Width = 131
    Height = 13
    Caption = 'K'#233'pfriss'#237't'#233'si frekvencia (Hz)'
  end
  object lbl_infomblur: TLabel
    Left = 8
    Top = 378
    Width = 173
    Height = 13
    Caption = 'Bemozdul'#225's - elmos'#225's ( motion blur ):'
  end
  object lbl_resinfo: TLabel
    Left = 56
    Top = 21
    Width = 57
    Height = 13
    Caption = '( resolution )'
  end
  object lbl_refreshrateinfo: TLabel
    Left = 74
    Top = 134
    Width = 65
    Height = 13
    Caption = '( refresh rate )'
  end
  object lbl_infosmokes: TLabel
    Left = 8
    Top = 424
    Width = 107
    Height = 13
    Caption = 'F'#252'st m'#233'rt'#233'ke ( smoke )'
  end
  object lbl_smoketext: TLabel
    Left = 138
    Top = 442
    Width = 87
    Height = 13
    AutoSize = False
    Caption = '-> Kev'#233's f'#252'st'
    Color = 9523784
    ParentColor = False
  end
  object combox_resolution: TComboBox
    Left = 120
    Top = 9
    Width = 104
    Height = 21
    Cursor = crHandPoint
    Hint = 'T'#225'mogatott k'#233'pfelbont'#225'sok list'#225'ja'
    AutoComplete = False
    BevelInner = bvNone
    BevelKind = bkFlat
    BevelOuter = bvRaised
    Style = csDropDownList
    Color = 12089712
    Ctl3D = True
    ItemHeight = 13
    ParentCtl3D = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    OnChange = combox_resolutionChange
  end
  object combox_freq: TComboBox
    Left = 149
    Top = 123
    Width = 76
    Height = 21
    Cursor = crHandPoint
    Hint = 'T'#225'mogatott k'#233'pfriss'#237't'#233'si frekvenci'#225'k list'#225'ja'
    AutoComplete = False
    BevelInner = bvNone
    BevelKind = bkFlat
    BevelOuter = bvRaised
    Style = csDropDownList
    Color = 12089712
    Enabled = False
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
  end
  object cbox_vsync: TCheckBox
    Left = 8
    Top = 151
    Width = 217
    Height = 17
    Cursor = crHandPoint
    Hint = 'Hat'#225's'#225'ra megsz'#252'ntethet'#337' a j'#225't'#233'k k'#246'zben fellelhet'#337' k'#233'pt'#246'r'#233's'
    Caption = 'V'#225'rakoz'#225's k'#233'pfriss'#237't'#233'sre ( v-sync )'
    Checked = True
    Color = 9523784
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 2
  end
  object cbox_fullscreen: TCheckBox
    Left = 8
    Top = 99
    Width = 217
    Height = 17
    Cursor = crHandPoint
    Hint = 
      'A be'#225'll'#237'tott k'#233'pfelbont'#225's, sz'#237'nm'#233'lys'#233'g '#233's k'#233'pfriss'#237't'#233'si frekvenc' +
      'ia alkalmaz'#225'sa j'#225't'#233'k k'#246'zben'
    Caption = 'Teljes k'#233'perny'#337' ( fullscreen )'
    Color = 9523784
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = cbox_fullscreenClick
  end
  object gbox_filtering: TGroupBox
    Left = 8
    Top = 236
    Width = 217
    Height = 76
    Caption = '[ Text'#250'rasz'#369'r'#233's ( filtering ) ]'
    Ctl3D = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentCtl3D = False
    ParentFont = False
    TabOrder = 4
    object cbox_mipmaps: TCheckBox
      Left = 8
      Top = 22
      Width = 201
      Height = 17
      Cursor = crHandPoint
      Hint = 
        'Hat'#225's'#225'ra a t'#225'voli text'#250'r'#225'kat kisebb felbont'#225'sban rajzolja, ez ja' +
        'v'#237'tja a k'#233'pmin'#337's'#233'get '#233's n'#246'veli a sebess'#233'get'
      Caption = 'V'#225'ltoz'#243' m'#233'ret'#369' text'#250'r'#225'k ( MIP maps )'
      Checked = True
      Color = 9523784
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 0
    end
    object combox_filtering: TComboBox
      Left = 8
      Top = 45
      Width = 201
      Height = 21
      Cursor = crHandPoint
      Hint = 'Text'#250'r'#225'k elmos'#225's'#225'nak m'#243'dja'
      AutoComplete = False
      BevelInner = bvNone
      BevelKind = bkFlat
      BevelOuter = bvRaised
      Style = csDropDownList
      Color = 12089712
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ItemIndex = 0
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      Text = 'Alap ( bilinear )'
      Items.Strings = (
        'Alap ( bilinear )'
        'Min'#337's'#233'gi ( trilinear )')
    end
  end
  object cbox_simpleitems: TCheckBox
    Left = 8
    Top = 318
    Width = 217
    Height = 17
    Cursor = crHandPoint
    Hint = 'Mutassa-e az '#233'gboltot'
    Caption = #201'gbolt ( skybox )'
    Checked = True
    Color = 9523784
    Ctl3D = True
    ParentColor = False
    ParentCtl3D = False
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 5
  end
  object cbox_marksonwalls: TCheckBox
    Left = 8
    Top = 337
    Width = 217
    Height = 17
    Cursor = crHandPoint
    Hint = 'L'#225'tsz'#243'djanak-e a falakon a l'#246'ved'#233'knyomok'
    Caption = 'L'#246'ved'#233'knyomok ( marks on walls )'
    Checked = True
    Color = 9523784
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 6
  end
  object cbox_lightmaps: TCheckBox
    Left = 8
    Top = 356
    Width = 217
    Height = 17
    Cursor = crHandPoint
    Hint = 'Alkalmazzon el'#337're gener'#225'lt f'#233'ny- '#233's '#225'rny'#233'k text'#250'r'#225'kat'
    Caption = 'F'#233'nyt'#233'rk'#233'pek ( lightmaps )'
    Checked = True
    Color = 9523784
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 7
  end
  object gbox_colordepth: TGroupBox
    Left = 8
    Top = 37
    Width = 217
    Height = 57
    Cursor = crHandPoint
    Caption = '[ Sz'#237'nm'#233'lys'#233'g ( color depth ) ]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 8
    object rbtn_16bit: TRadioButton
      Left = 8
      Top = 16
      Width = 201
      Height = 17
      Cursor = crHandPoint
      Hint = 'J'#243' k'#233'pmin'#337's'#233'get eredm'#233'nyez'
      Caption = '16 bites (t'#246'bb, mint 65 ezer sz'#237'n)'
      Checked = True
      Color = 9523784
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
      TabStop = True
      OnClick = rbtn_16bitClick
    end
    object rbtn_32bit: TRadioButton
      Left = 8
      Top = 35
      Width = 201
      Height = 17
      Cursor = crHandPoint
      Hint = 'Kiv'#225'l'#243' k'#233'pmin'#337's'#233'get eredm'#233'nyez'
      Caption = '32 bites (t'#246'bb, mint 4 milli'#225'rd sz'#237'n)'
      Color = 9523784
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      OnClick = rbtn_32bitClick
    end
  end
  object gbox_shading: TGroupBox
    Left = 8
    Top = 189
    Width = 217
    Height = 43
    Cursor = crHandPoint
    Caption = '[ '#193'rnyal'#225's ( shading ) ]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 9
    object rbtn_gl_flat: TRadioButton
      Left = 8
      Top = 16
      Width = 65
      Height = 17
      Cursor = crHandPoint
      Hint = 'A megvil'#225'g'#237'tott testeken egyszer'#369' f'#233'nyhat'#225'st kelt'
      Caption = 'S'#237'k (flat)'
      Color = 9523784
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object rbtn_gl_smooth: TRadioButton
      Left = 88
      Top = 16
      Width = 121
      Height = 17
      Cursor = crHandPoint
      Hint = 'A megvil'#225'g'#237'tott testeken '#246'sszetettebb f'#233'nyhat'#225'st kelt'
      Caption = 'Egyenletes (smooth)'
      Checked = True
      Color = 9523784
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TabStop = True
    end
  end
  object combox_motionblur: TComboBox
    Left = 24
    Top = 396
    Width = 201
    Height = 21
    Cursor = crHandPoint
    Hint = 'Milyen esetekben mos'#243'djon el a j'#225't'#233'kos '#225'ltal l'#225'tott k'#233'p'
    AutoComplete = False
    BevelInner = bvNone
    BevelKind = bkFlat
    BevelOuter = bvRaised
    Style = csDropDownList
    Color = 12089712
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ItemHeight = 13
    ItemIndex = 0
    ParentFont = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 10
    Text = 'Soha'
    Items.Strings = (
      'Soha'
      'Mindig'
      'Csak s'#233'r'#252'l'#233's eset'#233'n')
  end
  object gbox_zbuffer: TGroupBox
    Left = 8
    Top = 463
    Width = 217
    Height = 39
    Cursor = crHandPoint
    Caption = '[ Z - buffer m'#233'lys'#233'ge ( Z - depth ) ]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    object rbtn_z16bit: TRadioButton
      Left = 18
      Top = 17
      Width = 73
      Height = 17
      Cursor = crHandPoint
      Hint = 'Fel'#252'letes takar'#225's - vizsg'#225'lat alkalmaz'#225'sa'
      Caption = '16 bites'
      Color = 9523784
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
    object rbtn_z24bit: TRadioButton
      Left = 98
      Top = 17
      Width = 73
      Height = 17
      Cursor = crHandPoint
      Hint = 'Hat'#233'konyabb takar'#225's - vizsg'#225'lat alkalmaz'#225'sa'
      Caption = '24 bites'
      Checked = True
      Color = 9523784
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 1
      TabStop = True
    end
  end
  object cbox_showfps: TCheckBox
    Left = 8
    Top = 170
    Width = 217
    Height = 17
    Cursor = crHandPoint
    Hint = 
      'Hat'#225's'#225'ra j'#225't'#233'k k'#246'zben a jobb fels'#337' sarokban mutatja a m'#225'sodperce' +
      'nk'#233'nt kirajzolt k'#233'pkock'#225'k sz'#225'm'#225't'
    Caption = 'FPS kijelz'#233'se ( show fps )'
    Checked = True
    Color = 9523784
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    State = cbChecked
    TabOrder = 12
  end
  object tbar_smoke: TTrackBar
    Left = 18
    Top = 440
    Width = 111
    Height = 20
    Cursor = crHSplit
    Hint = 'F'#252'st effektek gyakoris'#225'g'#225't hat'#225'rozza meg'
    Ctl3D = True
    Max = 3
    Orientation = trHorizontal
    ParentCtl3D = False
    ParentShowHint = False
    Frequency = 1
    Position = 1
    SelEnd = 0
    SelStart = 0
    ShowHint = True
    TabOrder = 13
    ThumbLength = 15
    TickMarks = tmBottomRight
    TickStyle = tsNone
    OnChange = tbar_smokeChange
  end
end
