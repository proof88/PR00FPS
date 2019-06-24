object frm_newhardware: Tfrm_newhardware
  Left = 372
  Top = 104
  ActiveControl = btn_cancel
  BorderStyle = bsDialog
  Caption = #218'j hardver'
  ClientHeight = 113
  ClientWidth = 429
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
  object mm: TMemo
    Left = 8
    Top = 8
    Width = 417
    Height = 57
    Cursor = crArrow
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      #218'j videok'#225'rty'#225't tal'#225'ltam. Mit k'#237'v'#225'n tenni?'
      
        'Haszn'#225'lja a programot az eddigi grafikai be'#225'll'#237't'#225'sokkal, vagy '#250'j' +
        'raszabja a be'#225'll'#237't'#225'sokat?')
    ReadOnly = True
    TabOrder = 0
  end
  object btn_autocfg: TButton
    Left = 8
    Top = 80
    Width = 201
    Height = 25
    Cursor = crHandPoint
    Caption = '>>> Be'#225'll'#237't'#225'sok megv'#225'ltoztat'#225'sa <<<'
    ModalResult = 1
    TabOrder = 1
  end
  object btn_cancel: TButton
    Left = 224
    Top = 80
    Width = 201
    Height = 25
    Cursor = crHandPoint
    Caption = '>>> Eredeti be'#225'll'#237't'#225'sok haszn'#225'lata <<<'
    ModalResult = 2
    TabOrder = 2
  end
end
