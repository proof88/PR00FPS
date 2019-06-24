unit u_frm_playermatdebug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, extctrls, u_consts, StdCtrls;

type
  Tfrm_playermatdebug = class(TForm)
    lbl_name: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    shpmat: array[1..BOTS_PATH_MAT_E_NUM_X,1..BOTS_PATH_MAT_E_NUM_Z] of tshape;
  public
    { Public declarations }
    procedure SetElementColor(x,z: integer; color: TColor);
  end;

var
  frm_playermatdebug: Tfrm_playermatdebug;

implementation

{$R *.dfm}

procedure Tfrm_playermatdebug.FormCreate(Sender: TObject);
var
  i,j: integer;
begin
  for i := 1 to BOTS_PATH_MAT_E_NUM_Z do
    for j := 1 to BOTS_PATH_MAT_E_NUM_X do
      begin
        shpmat[i,j] := TShape.create(self);
        with shpmat[i,j] do
          begin
            parent := self;
            width := 10;
            height := 10;
            top := height*i - i;
            left := width*j - j;
          end;
      end;
  clientwidth := BOTS_PATH_MAT_E_NUM_X*10+15;
  clientheight := BOTS_PATH_MAT_E_NUM_Z*10+15;
end;

procedure Tfrm_playermatdebug.SetElementColor(x, z: integer;
  color: TColor);
begin
  if ( (x > 0) and (x <= BOTS_PATH_MAT_E_NUM_X) and (z > 0) and (z <= BOTS_PATH_MAT_E_NUM_Z) ) then
    begin
      shpmat[x,z].Brush.Color := color;
    end;
end;

procedure Tfrm_playermatdebug.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i,j: integer;
begin
  for i := 1 to BOTS_PATH_MAT_E_NUM_Z do
    for j := 1 to BOTS_PATH_MAT_E_NUM_X do
      shpmat[i,j].Free;
end;

end.
