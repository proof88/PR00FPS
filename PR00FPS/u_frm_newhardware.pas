unit u_frm_newhardware;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tfrm_newhardware = class(TForm)
    mm: TMemo;
    btn_autocfg: TButton;
    btn_cancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_newhardware: Tfrm_newhardware;

implementation

{$R *.dfm}

end.
