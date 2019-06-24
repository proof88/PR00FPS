object Form1: TForm1
  Left = 305
  Top = 378
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Forma1'
  ClientHeight = 543
  ClientWidth = 772
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 9
    Top = 52
    Width = 31
    Height = 13
    Caption = 'num x:'
  end
  object Label2: TLabel
    Left = 9
    Top = 76
    Width = 31
    Height = 13
    Caption = 'num z:'
  end
  object Label3: TLabel
    Left = 129
    Top = 52
    Width = 31
    Height = 13
    Caption = 'basey:'
  end
  object Label4: TLabel
    Left = 129
    Top = 76
    Width = 53
    Height = 13
    Caption = 'range: from'
  end
  object Label5: TLabel
    Left = 261
    Top = 76
    Width = 9
    Height = 13
    Caption = 'to'
  end
  object Label6: TLabel
    Left = 361
    Top = 52
    Width = 28
    Height = 13
    Caption = 'basex'
  end
  object Label7: TLabel
    Left = 361
    Top = 76
    Width = 28
    Height = 13
    Caption = 'basez'
  end
  object btn_loadobj: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'btn_loadobj'
    TabOrder = 0
    OnClick = btn_loadobjClick
  end
  object SpinEdit1: TSpinEdit
    Left = 48
    Top = 48
    Width = 57
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
  object SpinEdit2: TSpinEdit
    Left = 48
    Top = 72
    Width = 57
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 2
    Value = 0
  end
  object ScrollBox1: TScrollBox
    Left = 8
    Top = 96
    Width = 441
    Height = 441
    HorzScrollBar.Smooth = True
    HorzScrollBar.Style = ssHotTrack
    HorzScrollBar.Tracking = True
    VertScrollBar.Smooth = True
    VertScrollBar.Style = ssHotTrack
    VertScrollBar.Tracking = True
    TabOrder = 3
    object pnl: TPanel
      Left = 0
      Top = 0
      Width = 425
      Height = 433
      BevelInner = bvRaised
      BevelOuter = bvLowered
      TabOrder = 0
    end
  end
  object SpinEdit3: TSpinEdit
    Left = 166
    Top = 49
    Width = 91
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 4
    Value = 0
    OnChange = SpinEdit3Change
  end
  object btn_savenav: TButton
    Left = 128
    Top = 8
    Width = 75
    Height = 25
    Caption = 'btn_savenav'
    TabOrder = 5
    OnClick = btn_savenavClick
  end
  object SpinEdit4: TSpinEdit
    Left = 190
    Top = 73
    Width = 67
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 6
    Value = 0
  end
  object SpinEdit5: TSpinEdit
    Left = 274
    Top = 73
    Width = 67
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 7
    Value = 0
  end
  object SpinEdit6: TSpinEdit
    Left = 400
    Top = 48
    Width = 57
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 8
    Value = 0
    OnChange = SpinEdit6Change
  end
  object SpinEdit7: TSpinEdit
    Left = 400
    Top = 72
    Width = 57
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 9
    Value = 0
    OnChange = SpinEdit7Change
  end
  object dlg_open: TOpenDialog
    Filter = 'obj files|*.obj|all files|*.*'
    Title = 'load map'
    Left = 88
    Top = 8
  end
  object dlg_save: TSaveDialog
    Filter = 'nav files|*.nav|all files|*.*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'save nav'
    Left = 208
    Top = 8
  end
end
