object frm_about: Tfrm_about
  Left = 545
  Top = 434
  ActiveControl = btn_ok
  BorderStyle = bsDialog
  Caption = 'N'#233'vjegy'
  ClientHeight = 90
  ClientWidth = 186
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbl_a: TLabel
    Left = 8
    Top = 8
    Width = 170
    Height = 16
    Caption = 'MapCfg 1.0 for PR00FPS'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lbl_b: TLabel
    Left = 16
    Top = 32
    Width = 155
    Height = 13
    Caption = 'K'#233'sz'#237'tette: Szab'#243' '#193'd'#225'm (PR00F)'
  end
  object btn_ok: TButton
    Left = 56
    Top = 56
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Ok'
    TabOrder = 0
    OnClick = btn_okClick
  end
end
