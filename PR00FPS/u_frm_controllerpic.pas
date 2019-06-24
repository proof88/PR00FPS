unit u_frm_controllerpic;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls;

type
  Tfrm_controllerpic = class(TForm)
    img: TImage;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_controllerpic: Tfrm_controllerpic;

implementation

{$R *.dfm}

procedure Tfrm_controllerpic.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ( key in [VK_ESCAPE,VK_RETURN] ) then
    frm_controllerpic.Close;
end;

end.
