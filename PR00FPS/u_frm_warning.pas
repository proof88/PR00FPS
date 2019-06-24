unit u_frm_warning;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tfrm_warning = class(TForm)
    mm: TMemo;
    btn: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_warning: Tfrm_warning;

implementation

{$R *.dfm}

end.
