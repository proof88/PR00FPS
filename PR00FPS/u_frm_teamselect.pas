unit u_frm_teamselect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Buttons, ExtCtrls;

type
  Tfrm_teamselect = class(TForm)
    gbox_teamselect: TGroupBox;
    clb_allies: TCheckListBox;
    pnl_playbg: TPanel;
    spbtn_ok: TSpeedButton;
    procedure spbtn_okClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    alliedlist: string;
  end;

var
  frm_teamselect: Tfrm_teamselect;

implementation

{$R *.dfm}

procedure Tfrm_teamselect.spbtn_okClick(Sender: TObject);
var
  i: integer;
begin
  alliedlist := '';
  for i := 0 to clb_allies.Items.Count-1 do
    if ( clb_allies.Checked[i] ) then
      alliedlist := alliedlist + clb_allies.Items[i];
  frm_teamselect.ModalResult := mrOk;
end;

procedure Tfrm_teamselect.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ( key = VK_RETURN ) then spbtn_ok.Click
    else if ( key = VK_ESCAPE ) then frm_teamselect.ModalResult := mrCancel;
end;

end.
