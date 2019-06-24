unit u_about;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tfrm_about = class(TForm)
    lbl_a: TLabel;
    lbl_b: TLabel;
    btn_ok: TButton;
    procedure btn_okClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_about: Tfrm_about;

implementation

{$R *.dfm}

procedure Tfrm_about.btn_okClick(Sender: TObject);
begin
  close;
end;

end.
