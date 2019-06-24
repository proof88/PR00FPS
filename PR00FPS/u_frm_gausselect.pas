unit u_frm_gausselect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls;

type
  Tfrm_gausselect = class(TForm)
    gbox_teamselect: TGroupBox;
    cbox_gauss: TComboBox;
    pnl_playbg: TPanel;
    spbtn_ok: TSpeedButton;
    procedure spbtn_okClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_gausselect: Tfrm_gausselect;

implementation

{$R *.dfm}

procedure Tfrm_gausselect.spbtn_okClick(Sender: TObject);
begin
  frm_gausselect.ModalResult := mrOk;
end;

procedure Tfrm_gausselect.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ( key = VK_RETURN ) then spbtn_ok.Click
    else if  ( key = VK_ESCAPE ) then frm_gausselect.ModalResult := mrCancel;
end;

end.
