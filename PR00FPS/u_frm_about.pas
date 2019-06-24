unit u_frm_about;

interface

uses
  Windows, Messages, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  Tfrm_about = class(TForm)
    lbl_info01: TLabel;
    lbl_info02: TLabel;
    lbl_info03: TLabel;
    lbl_info05: TLabel;
    lbl_info04: TLabel;
    mm: TMemo;
    pnl_okbg: TPanel;
    spbtn_ok: TSpeedButton;
    Image1: TImage;
    Image2: TImage;
    procedure spbtn_okClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_about: Tfrm_about;

implementation

{$R *.dfm}

procedure Tfrm_about.spbtn_okClick(Sender: TObject);
begin
  frm_about.Close;
end;

procedure Tfrm_about.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ( key in [VK_RETURN,VK_ESCAPE] ) then spbtn_ok.Click;
end;

procedure Tfrm_about.FormCreate(Sender: TObject);
begin
  lbl_info01.Caption := application.Title;
  caption := application.Title + ' névjegye';
end;

end.
