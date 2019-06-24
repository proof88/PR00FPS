object frm_teamselect: Tfrm_teamselect
  Left = 650
  Top = 114
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsToolWindow
  Caption = 'Eloszt'#225's'
  ClientHeight = 281
  ClientWidth = 224
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
    Left = 8
    Top = 8
    Width = 209
    Height = 225
    Caption = '[ V'#225'laszd ki a csapatt'#225'rsaidat! ]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object clb_allies: TCheckListBox
      Left = 16
      Top = 24
      Width = 177
      Height = 185
      Cursor = crHandPoint
      Hint = 'A megjel'#246'lt j'#225't'#233'kosok lesznek a csapatodban'
      Color = 12089712
      Ctl3D = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentCtl3D = False
      ParentFont = False
      ParentShowHint = False
      ShowHint = True
      TabOrder = 0
    end
  end
  object pnl_playbg: TPanel
    Left = 35
    Top = 240
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
