unit u_frm_botmanager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, CheckLst;

type
  Tfrm_botmanager = class(TForm)
    gbox_main: TGroupBox;
    clb_bots: TCheckListBox;
    lbl_info: TLabel;
    pnl_playbg: TPanel;
    spbtn_ok: TSpeedButton;
    procedure spbtn_okClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_botmanager: Tfrm_botmanager;

implementation

{$R *.dfm}

procedure Tfrm_botmanager.spbtn_okClick(Sender: TObject);
begin
  frm_botmanager.ModalResult := mrOk;
end;

procedure Tfrm_botmanager.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ( key = VK_ESCAPE ) then frm_botmanager.ModalResult := mrCancel
    else if ( key = VK_RETURN ) then spbtn_ok.Click;
end;

procedure Tfrm_botmanager.FormShow(Sender: TObject);
begin
  while ( showcursor(TRUE) < 0 ) do ;
end;

end.
