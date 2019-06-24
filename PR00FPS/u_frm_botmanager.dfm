object frm_botmanager: Tfrm_botmanager
  Left = 199
  Top = 110
  BorderStyle = bsSingle
  Caption = 'Botok'
  ClientHeight = 385
  ClientWidth = 241
  Color = 8209982
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poDesktopCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gbox_main: TGroupBox
    Left = 8
    Top = 8
    Width = 225
    Height = 369
    Caption = '[ Botok hozz'#225'ad'#225'sa / t'#246'rl'#233'se ]'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    object lbl_info: TLabel
      Left = 16
      Top = 24
      Width = 193
      Height = 49
      AutoSize = False
      Caption = 
        'Itt lehet ut'#243'lag szerkeszteni a botokat. Azok lesznek a j'#225't'#233'kban' +
        ', akik be vannak jel'#246'lve.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
    object clb_bots: TCheckListBox
      Left = 16
      Top = 80
      Width = 193
      Height = 225
      Cursor = crHandPoint
      Color = 12089712
      Ctl3D = False
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 0
    end
    object pnl_playbg: TPanel
      Left = 35
      Top = 320
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
        Hint = 'V'#225'ltoztat'#225'sok '#233'rv'#233'nyes'#237't'#233'se'
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
end
