object frm_firstrun: Tfrm_firstrun
  Left = 530
  Top = 106
  ActiveControl = btn_ok
  BorderStyle = bsDialog
  Caption = 'Els'#337' futtat'#225's'
  ClientHeight = 169
  ClientWidth = 378
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
    Left = 9
    Top = 8
    Width = 360
    Height = 113
    Cursor = crArrow
    BorderStyle = bsNone
    Color = clBtnFace
    Lines.Strings = (
      #220'dv'#246'zli '#214'nt a PR00FPS!'
      ''
      
        'Els'#337' alkalommal futtatja a programot, ez'#233'rt a program a sz'#225'm'#237't'#243'g' +
        #233'pe '
      
        'teljes'#237'tm'#233'ny'#233'hez m'#233'rten automatikusan konfigur'#225'lja a videobe'#225'll'#237 +
        't'#225'sokat.'
      'Ez kevesebb, mint egy percet vesz ig'#233'nybe.'
      
        'Az automatikus konfigur'#225'l'#225'st k'#233's'#337'bb is b'#225'rmikor megteheti a Be'#225'l' +
        'l'#237't'#225'sokban.'
      ''
      'Ha elolvasta, nyomja meg az Ok gombot!')
    ReadOnly = True
    TabOrder = 0
  end
  object btn_ok: TButton
    Left = 152
    Top = 136
    Width = 75
    Height = 25
    Cursor = crHandPoint
    Caption = 'Ok'
    TabOrder = 1
    OnClick = btn_okClick
  end
end
