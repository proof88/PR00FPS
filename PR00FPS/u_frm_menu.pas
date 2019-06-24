unit u_frm_menu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ImgList;

type
  Tfrm_menu = class(TForm)
    img_bg: TImage;
    il_20px: TImageList;
    img_btn_close: TImage;
    img_btn_min: TImage;
    tmr_ui: TTimer;
    il_196px: TImageList;
    img_btn_start: TImage;
    img_btn_settings: TImage;
    img_btn_about: TImage;
    img_btn_exit: TImage;
    img_movearea: TImage;
    procedure FormCreate(Sender: TObject);
    procedure img_bgMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure img_bgMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure img_bgMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tmr_uiTimer(Sender: TObject);
    procedure img_btn_closeClick(Sender: TObject);
    procedure img_btn_minClick(Sender: TObject);
    procedure img_btn_settingsClick(Sender: TObject);
    procedure img_btn_startClick(Sender: TObject);
    procedure img_btn_aboutClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    mousedown: boolean;
    oldx,oldy: integer;
    statesready: boolean;
    currentbtn: byte;
    function cursorOverControl(cp: tpoint; ctrl: tcontrol): boolean;
    procedure setControlBMP(ctrl: tcontrol; hctx: integer);
    procedure presetContolStates;
  public
    { Public declarations }
    botslist: string;
    alliedlist: string;
  end;

var
  frm_menu: Tfrm_menu;

implementation

uses u_frm_settings, u_frm_newgame, u_frm_about;

{$R *.dfm}

procedure Tfrm_menu.FormCreate(Sender: TObject);
begin
  mousedown := FALSE;
  statesready := FALSE;
  currentbtn := 0;
end;

procedure Tfrm_menu.presetContolStates;
var i: integer;
    curpos: tpoint;
begin
  getcursorpos(curpos);
  for i := 0 to frm_menu.Controlcount-1 do
    if ( pos('img_btn',frm_menu.Controls[i].Name) > 0 ) then
      begin
        if ( cursorOverControl(curpos,frm_menu.Controls[i]) ) then
          begin
            frm_menu.Controls[i].HelpContext := 1;
          end;
      end;
  statesready := TRUE;
end;

procedure Tfrm_menu.img_bgMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mousedown := TRUE;
  oldx := x;
  oldy := y;
  screen.Cursor := crsizeall;
end;

procedure Tfrm_menu.img_bgMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if ( mousedown ) then
    begin
      frm_menu.Left := frm_menu.Left + x - oldx;
      frm_menu.Top  := frm_menu.Top  + y - oldy;
    end;
end;

procedure Tfrm_menu.img_bgMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mousedown := FALSE;
  screen.Cursor := crdefault;
end;

function Tfrm_menu.cursorOverControl(cp: tpoint; ctrl: tcontrol): boolean;
begin
  result :=
  (
    ( cp.X >= frm_menu.left + ctrl.Left ) and ( cp.X <= frm_menu.left + ctrl.Left + ctrl.Width )
                                          and
    ( cp.y >= frm_menu.top + ctrl.top )   and   ( cp.y <= frm_menu.top + ctrl.top + ctrl.height )
  )
end;

procedure Tfrm_menu.setControlBMP(ctrl: tcontrol; hctx: integer);
var
  bmp: TBitmap;
begin
  bmp := tbitmap.Create;
  if ( ctrl.Width = 20 ) then il_20px.GetBitmap(ctrl.Tag+hctx,bmp)
    else il_196px.GetBitmap(ctrl.Tag+hctx,bmp);
  (ctrl as timage).Picture.Bitmap := bmp;
  bmp.Free;
  ctrl.HelpContext := hctx;
end;

procedure Tfrm_menu.tmr_uiTimer(Sender: TObject);
var
  i: integer;
  curpos: tpoint;
begin
  if ( statesready ) then
  begin
  getcursorpos(curpos);
  for i := 0 to frm_menu.ControlCount-1 do
    begin
      if ( pos('img_btn',frm_menu.Controls[i].Name) > 0 ) then
        begin
          if ( cursorOverControl(curpos,frm_menu.Controls[i]) ) then
            begin
              if ( frm_menu.Controls[i].HelpContext = 1 ) then
                setcontrolbmp(frm_menu.Controls[i],0);
            end
           else
            begin
              if ( frm_menu.Controls[i].HelpContext = 0 ) then
                begin
                  setcontrolbmp(frm_menu.Controls[i],1);
                end;
            end;
        end;
    end;
  end
  else
  begin
    setcursorpos(frm_menu.Left + frm_menu.Width div 2 - 20,frm_menu.Top+40);
    presetContolStates;
  end;
end;

procedure Tfrm_menu.img_btn_closeClick(Sender: TObject);
begin
  frm_menu.Close;
end;

procedure Tfrm_menu.img_btn_minClick(Sender: TObject);
begin
  application.Minimize;
end;

procedure Tfrm_menu.img_btn_settingsClick(Sender: TObject);
begin
  tmr_ui.Enabled := FALSE;
  frm_settings := tfrm_settings.Create(self);
  frm_settings.DoubleBuffered := TRUE;
  frm_settings.showmodal;
  frm_settings.Free;
  tmr_ui.Enabled := TRUE;
end;

procedure Tfrm_menu.img_btn_startClick(Sender: TObject);
begin
  tmr_ui.Enabled := FALSE;
  frm_newgame := tfrm_newgame.create(self);
  if ( frm_newgame.showmodal = mrOk ) then
    frm_menu.ModalResult := mrOk
   else
    tmr_ui.Enabled := TRUE;
  // felszabadítás elõtt eltároljuk a kiválasztott botokat, ezt fogja
  // elkérni a fõprogi is innen
  botslist := frm_newgame.lbox_chosen.Items.Text;
  alliedlist := frm_newgame.alliedlist;
  frm_newgame.Free;
end;

procedure Tfrm_menu.img_btn_aboutClick(Sender: TObject);
begin
  tmr_ui.Enabled := FALSE;
  frm_about := Tfrm_about.create(self);
  frm_about.showmodal;
  frm_about.Free;
  tmr_ui.Enabled := TRUE;
end;

procedure Tfrm_menu.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
procedure movecursor;
begin
  case currentbtn of
    1: setcursorpos(frm_menu.Left+img_btn_start.Left+img_btn_start.width div 2,frm_menu.Top+img_btn_start.top+img_btn_start.Height div 2);
    2: setcursorpos(frm_menu.Left+img_btn_settings.Left+img_btn_settings.width div 2,frm_menu.Top+img_btn_settings.top+img_btn_settings.Height div 2);
    //3: setcursorpos(frm_menu.Left+img_btn_hiscores.Left+img_btn_hiscores.width div 2,frm_menu.Top+img_btn_hiscores.top+img_btn_hiscores.Height div 2);
    4: setcursorpos(frm_menu.Left+img_btn_about.Left+img_btn_about.width div 2,frm_menu.Top+img_btn_about.top+img_btn_about.Height div 2);
    5: setcursorpos(frm_menu.Left+img_btn_exit.Left+img_btn_exit.width div 2,frm_menu.Top+img_btn_exit.top+img_btn_exit.Height div 2);
  end;
end;
begin
  case key of
    VK_ESCAPE: begin
                 img_btn_closeclick(sender);
               end;
    VK_UP    : begin
                 if ( currentbtn > 1 ) then currentbtn := currentbtn - 1
                   else currentbtn := 5;
                 movecursor;
               end;
    VK_DOWN  : begin
                 if ( currentbtn < 5 ) then currentbtn := currentbtn + 1
                   else currentbtn := 1;
                 movecursor;
               end;
    VK_RETURN: begin
                 case currentbtn of
                   1: begin
                        img_btn_startclick(sender);
                      end;
                   2: begin
                        img_btn_settingsclick(sender);
                      end;
                   3: begin

                      end;
                   4: begin
                        img_btn_aboutclick(sender);
                      end;
                   5: begin
                        img_btn_closeclick(sender);
                      end;
                 end;
               end;
  end;
end;

procedure Tfrm_menu.FormShow(Sender: TObject);
begin
  windows.SetForegroundWindow(handle);
end;

end.
