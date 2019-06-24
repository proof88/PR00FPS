object frm_gausselect: Tfrm_gausselect
  Left = 248
  Top = 129
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  Caption = 'Ki legyen Gauss?'
  ClientHeight = 117
  ClientWidth = 222
  Color = 9523784
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object gbox_teamselect: TGroupBox
    Left = 6
    Top = 6
    Width = 209
    Height = 59
    Caption = '[ V'#225'laszd ki Gauss szem'#233'ly'#233't! ]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object cbox_gauss: TComboBox
      Left = 16
      Top = 24
      Width = 177
      Height = 21
      Cursor = crHandPoint
      BevelInner = bvNone
      BevelKind = bkFlat
      BevelOuter = bvRaised
      Style = csDropDownList
      Color = 12089712
      Ctl3D = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
    end
  end
  object pnl_playbg: TPanel
    Left = 35
    Top = 75
    Width = 154
    Height = 36
    BevelInner = bvLowered
    Color = 11231060
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 1
    object spbtn_ok: TSpeedButton
      Left = 0
      Top = 0
      Width = 153
      Height = 36
      Cursor = crHandPoint
      Hint = 'J'#225't'#233'k ind'#237't'#225'sa'
      Caption = 'OK'
      Flat = True
      Font.Charset = EASTEUROPE_CHARSET
      Font.Color = clWhite
      Font.Height = -21
      Font.Name = 'Garamond'
      Font.Style = [fsBold]
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      OnClick = spbtn_okClick
    end
  end
end
