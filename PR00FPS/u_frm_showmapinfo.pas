unit u_frm_showmapinfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tfrm_showmapinfo = class(TForm)
    mm: TMemo;
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    fname: string;
  public
    { Public declarations }
    procedure SetFileName(filename: string);
  end;

var
  frm_showmapinfo: Tfrm_showmapinfo;

implementation

{$R *.dfm}

procedure Tfrm_showmapinfo.SetFileName(filename: string);
begin
  fname := filename;
end;

procedure Tfrm_showmapinfo.FormShow(Sender: TObject);
begin
  mm.Lines.LoadFromFile(fname);
end;

procedure Tfrm_showmapinfo.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case key of
    VK_RETURN, VK_ESCAPE: frm_showmapinfo.Close;
  end;
end;

end.
