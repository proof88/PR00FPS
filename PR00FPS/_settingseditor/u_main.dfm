object frm_main: Tfrm_main
  Left = 193
  Top = 109
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'SettingsEditor for PR00FPS'
  ClientHeight = 444
  ClientWidth = 497
  Color = clBtnFace
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
  object input_mousesens: TLabel
    Left = 16
    Top = 368
    Width = 82
    Height = 13
    Caption = 'input_mousesens'
  end
  object lbl_mouse: TLabel
    Left = 104
    Top = 368
    Width = 47
    Height = 13
    Caption = 'lbl_mouse'
  end
  object audio_sfxvol: TLabel
    Left = 176
    Top = 56
    Width = 59
    Height = 13
    Caption = 'audio_sfxvol'
  end
  object lbl_sfxvol: TLabel
    Left = 256
    Top = 56
    Width = 43
    Height = 13
    Caption = 'lbl_sfxvol'
  end
  object audio_musicvol: TLabel
    Left = 176
    Top = 128
    Width = 73
    Height = 13
    Caption = 'audio_musicvol'
  end
  object lbl_musicvol: TLabel
    Left = 256
    Top = 128
    Width = 57
    Height = 13
    Caption = 'lbl_musicvol'
  end
  object lbl_video_gamma: TLabel
    Left = 176
    Top = 188
    Width = 66
    Height = 13
    Caption = 'video_gamma'
  end
  object video_renderq: TLabel
    Left = 176
    Top = 248
    Width = 68
    Height = 13
    Caption = 'video_renderq'
  end
  object lbl_renderq: TLabel
    Left = 256
    Top = 248
    Width = 52
    Height = 13
    Caption = 'lbl_renderq'
  end
  object lbl_bpp: TLabel
    Left = 392
    Top = 43
    Width = 18
    Height = 13
    Caption = 'bpp'
  end
  object lbl_hz: TLabel
    Left = 472
    Top = 43
    Width = 13
    Height = 13
    Caption = 'Hz'
  end
  object lbl_mblur: TLabel
    Left = 448
    Top = 296
    Width = 41
    Height = 13
    Caption = 'lbl_mblur'
  end
  object video_motionblur: TLabel
    Left = 352
    Top = 296
    Width = 80
    Height = 13
    Caption = 'video_motionblur'
  end
  object game_firstrun: TCheckBox
    Left = 8
    Top = 8
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'game_firstrun'
    TabOrder = 0
  end
  object reserved1: TEdit
    Left = 8
    Top = 32
    Width = 65
    Height = 19
    Ctl3D = False
    MaxLength = 3
    ParentCtl3D = False
    TabOrder = 1
    Text = 'reserved1'
  end
  object reserved2: TEdit
    Left = 88
    Top = 32
    Width = 65
    Height = 19
    Ctl3D = False
    MaxLength = 3
    ParentCtl3D = False
    TabOrder = 2
    Text = 'reserved2'
  end
  object game_name: TEdit
    Left = 8
    Top = 64
    Width = 145
    Height = 19
    Ctl3D = False
    MaxLength = 20
    ParentCtl3D = False
    TabOrder = 3
    Text = 'game_name'
  end
  object game_autoswitchwpn: TCheckBox
    Left = 8
    Top = 96
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'game_autoswitchwpn'
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 4
  end
  object game_showxhair: TCheckBox
    Left = 8
    Top = 120
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'game_showxhair'
    TabOrder = 5
  end
  object game_showhud: TCheckBox
    Left = 8
    Top = 144
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'game_showhud'
    TabOrder = 6
  end
  object game_showblood: TCheckBox
    Left = 8
    Top = 192
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'game_showblood'
    TabOrder = 7
  end
  object game_oddinteract: TCheckBox
    Left = 8
    Top = 216
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'game_oddinteract'
    TabOrder = 8
  end
  object game_keybdledsinteract: TCheckBox
    Left = 8
    Top = 240
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'game_keybdledsinteract'
    TabOrder = 9
  end
  object game_screensaveroff: TCheckBox
    Left = 8
    Top = 264
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'game_screensaveroff'
    TabOrder = 10
  end
  object game_monitorpowersave: TCheckBox
    Left = 8
    Top = 288
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'game_monitorpowersave'
    TabOrder = 11
  end
  object game_stealthmode: TCheckBox
    Left = 8
    Top = 312
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'game_stealthmode'
    TabOrder = 12
  end
  object tbar_mouse: TTrackBar
    Left = 8
    Top = 336
    Width = 145
    Height = 25
    Cursor = crHandPoint
    Max = 255
    Orientation = trHorizontal
    Frequency = 1
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 13
    TickMarks = tmBottomRight
    TickStyle = tsNone
    OnChange = tbar_mouseChange
  end
  object audio_sfx: TCheckBox
    Left = 176
    Top = 8
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'audio_sfx'
    TabOrder = 14
  end
  object tbar_sfxvol: TTrackBar
    Left = 176
    Top = 32
    Width = 145
    Height = 25
    Cursor = crHandPoint
    Max = 100
    Orientation = trHorizontal
    Frequency = 1
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 15
    TickMarks = tmBottomRight
    TickStyle = tsNone
    OnChange = tbar_sfxvolChange
  end
  object audio_music: TCheckBox
    Left = 176
    Top = 80
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'audio_music'
    TabOrder = 16
  end
  object tbar_musicvol: TTrackBar
    Left = 176
    Top = 104
    Width = 145
    Height = 25
    Cursor = crHandPoint
    Max = 100
    Orientation = trHorizontal
    Frequency = 1
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 17
    TickMarks = tmBottomRight
    TickStyle = tsNone
    OnChange = tbar_musicvolChange
  end
  object video_lastvideocard: TEdit
    Left = 176
    Top = 152
    Width = 145
    Height = 19
    Ctl3D = False
    MaxLength = 128
    ParentCtl3D = False
    TabOrder = 18
    Text = 'video_lastvideocard'
  end
  object video_gamma: TSpinEdit
    Left = 256
    Top = 184
    Width = 57
    Height = 22
    MaxValue = 80
    MinValue = -40
    TabOrder = 19
    Value = 0
  end
  object tbar_renderq: TTrackBar
    Left = 176
    Top = 216
    Width = 145
    Height = 25
    Cursor = crHandPoint
    Max = 5
    Orientation = trHorizontal
    Frequency = 1
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 20
    TickMarks = tmBottomRight
    TickStyle = tsAuto
    OnChange = tbar_renderqChange
  end
  object video_debug: TCheckBox
    Left = 176
    Top = 272
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'video_debug'
    TabOrder = 21
  end
  object video_res_h: TEdit
    Left = 424
    Top = 8
    Width = 65
    Height = 19
    Ctl3D = False
    MaxLength = 4
    ParentCtl3D = False
    TabOrder = 22
    Text = 'video_res_h'
  end
  object video_res_w: TEdit
    Left = 344
    Top = 8
    Width = 65
    Height = 19
    Ctl3D = False
    MaxLength = 4
    ParentCtl3D = False
    TabOrder = 23
    Text = 'video_res_w'
  end
  object video_colordepth: TEdit
    Left = 344
    Top = 40
    Width = 41
    Height = 19
    Ctl3D = False
    MaxLength = 2
    ParentCtl3D = False
    TabOrder = 24
    Text = 'video_colordepth'
  end
  object video_refreshrate: TEdit
    Left = 424
    Top = 40
    Width = 41
    Height = 19
    Ctl3D = False
    MaxLength = 2
    ParentCtl3D = False
    TabOrder = 25
    Text = 'video_refreshrate'
  end
  object video_fullscreen: TCheckBox
    Left = 344
    Top = 72
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'video_fullscreen'
    TabOrder = 26
  end
  object video_vsync: TCheckBox
    Left = 344
    Top = 96
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'video_vsync'
    TabOrder = 27
  end
  object video_shading_smooth: TCheckBox
    Left = 344
    Top = 120
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'video_shading_smooth'
    TabOrder = 28
  end
  object video_mipmaps: TCheckBox
    Left = 344
    Top = 144
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'video_mipmaps'
    TabOrder = 29
  end
  object video_filtering: TEdit
    Left = 344
    Top = 168
    Width = 65
    Height = 19
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 30
    Text = 'video_filtering'
  end
  object video_simpleitems: TCheckBox
    Left = 344
    Top = 224
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'video_simpleitems'
    TabOrder = 31
  end
  object video_marksonwalls: TCheckBox
    Left = 344
    Top = 248
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'video_marksonwalls'
    TabOrder = 32
  end
  object video_lightmaps: TCheckBox
    Left = 344
    Top = 328
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'video_lightmaps'
    TabOrder = 33
  end
  object input_mousereverse: TCheckBox
    Left = 8
    Top = 384
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'input_mousereverse'
    TabOrder = 34
  end
  object video_zbuffer16bit: TCheckBox
    Left = 344
    Top = 200
    Width = 153
    Height = 17
    Caption = 'video_zbuffer16bit'
    TabOrder = 35
  end
  object tbar_motionblur: TTrackBar
    Left = 344
    Top = 272
    Width = 145
    Height = 25
    Cursor = crHandPoint
    Max = 2
    Orientation = trHorizontal
    Frequency = 1
    Position = 0
    SelEnd = 0
    SelStart = 0
    TabOrder = 36
    TickMarks = tmBottomRight
    TickStyle = tsNone
    OnChange = tbar_motionblurChange
  end
  object game_hudisblue: TCheckBox
    Left = 8
    Top = 168
    Width = 145
    Height = 17
    Cursor = crHandPoint
    Caption = 'game_hudisblue'
    TabOrder = 37
  end
  object mm: TMainMenu
    Left = 96
    object Fjl1: TMenuItem
      Caption = 'F'#225'jl'
      object Betlts1: TMenuItem
        Caption = 'Bet'#246'lt'#233's'
        ShortCut = 16460
        OnClick = Betlts1Click
      end
      object Ments1: TMenuItem
        Caption = 'Ment'#233's'
        ShortCut = 16467
        OnClick = Ments1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Kilps1: TMenuItem
        Caption = 'Kil'#233'p'#233's'
        ShortCut = 32883
        OnClick = Kilps1Click
      end
    end
  end
end
