unit u_frm_firstrun;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tfrm_firstrun = class(TForm)
    mm: TMemo;
    btn_ok: TButton;
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_firstrun: Tfrm_firstrun;

implementation

{$R *.dfm}

procedure Tfrm_firstrun.btn_okClick(Sender: TObject);
begin
  close;
end;

end.
