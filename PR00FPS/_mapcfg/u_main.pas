unit u_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Buttons, ExtCtrls, Spin;

type
  TSTR40 = string[40];
  TRGB = record
           red: byte;
           green: byte;
           blue: byte;
         end;
  TMapCfgData = record
                  scale: word;
                  skycolor: TRGB;
                  skyboxfname: TSTR40;
                end;
  Tfrm_main = class(TForm)
    mm: TMainMenu;
    Fjl1: TMenuItem;
    Segtsg1: TMenuItem;
    Nvjegy1: TMenuItem;
    j1: TMenuItem;
    N1: TMenuItem;
    Megnyits1: TMenuItem;
    Ments1: TMenuItem;
    N2: TMenuItem;
    Kilps1: TMenuItem;
    gbox_main: TGroupBox;
    ed_skybox: TEdit;
    lbl_a: TLabel;
    spbtn_browse: TSpeedButton;
    shp_color: TShape;
    lbl_b: TLabel;
    dlg_openskybox: TOpenDialog;
    dlg_color: TColorDialog;
    lbl_c: TLabel;
    sped_scale: TSpinEdit;
    dlg_save: TSaveDialog;
    dlg_open: TOpenDialog;
    procedure shp_colorMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure spbtn_browseClick(Sender: TObject);
    procedure Nvjegy1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure j1Click(Sender: TObject);
    procedure Ments1Click(Sender: TObject);
    procedure Megnyits1Click(Sender: TObject);
    procedure Kilps1Click(Sender: TObject);
  private
    { Private declarations }
    mapcfgdata: TMapCfgData;
    fname: string;
  public
    { Public declarations }
  end;

var
  frm_main: Tfrm_main;

implementation

uses u_about;

{$R *.dfm}

procedure Tfrm_main.shp_colorMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  dlg_color.Color := shp_color.Brush.Color;
  if ( dlg_color.Execute ) then shp_color.Brush.Color := dlg_color.Color;
end;

procedure Tfrm_main.spbtn_browseClick(Sender: TObject);
begin
  if ( dlg_openskybox.Execute ) then
    ed_skybox.Text := extractfilename(dlg_openskybox.FileName);
end;

procedure Tfrm_main.Nvjegy1Click(Sender: TObject);
begin
  frm_about.showmodal;
end;

procedure Tfrm_main.FormCreate(Sender: TObject);
begin
  fname := 'Névtelen';
  caption := fname+' - MapCfg';
  application.Title := caption;
end;

procedure Tfrm_main.j1Click(Sender: TObject);
begin
  fname := 'Névtelen';
  caption := fname+' - MapCfg';
  application.Title := caption;
  ed_skybox.Text := '';
  shp_color.Brush.Color := clWhite;
  sped_scale.Value := 100;
end;

procedure Tfrm_main.Ments1Click(Sender: TObject);
var
  filehandle: cardinal;
  byteswritten: cardinal;
begin
  if ( (fname = 'Névtelen') or not(fileexists(fname)) ) then
    begin  // ha még nincs fájl se, vagy fájl már nem létezik, savedialog kell
      if ( dlg_save.Execute ) then
        begin
          fname := dlg_save.FileName;
          if ( dlg_save.filterindex = 1 ) then
            fname := fname + '.dat';
          caption := extractfilename(fname)+' - MapCfg';
          application.Title := caption;
          with mapcfgdata do
            begin
              skycolor.red := getrvalue(shp_color.Brush.Color);
              skycolor.green := getgvalue(shp_color.Brush.Color);
              skycolor.blue := getbvalue(shp_color.Brush.Color);
              scale := sped_scale.Value;
              skyboxfname := ed_skybox.Text;
            end;
          filehandle := createfile(pchar(fname),GENERIC_WRITE,0,nil,
                                   CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0);
          writefile(filehandle,mapcfgdata,sizeof(TMapCfgData),byteswritten,nil);
          closehandle(filehandle);
        end;
    end
   else
    begin  // ha már van fájl és felülírjuk
      with mapcfgdata do
        begin
          skycolor.red := getrvalue(shp_color.Brush.Color);
          skycolor.green := getgvalue(shp_color.Brush.Color);
          skycolor.blue := getbvalue(shp_color.Brush.Color);
          scale := sped_scale.Value;
          skyboxfname := ed_skybox.Text;
          filehandle := createfile(pchar(fname),GENERIC_WRITE,0,nil,
                                   CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0);
          writefile(filehandle,mapcfgdata,sizeof(TMapCfgData),byteswritten,nil);
          closehandle(filehandle);
        end;
    end;
end;

procedure Tfrm_main.Megnyits1Click(Sender: TObject);
var
  filehandle: cardinal;
  bytesread: cardinal;
begin
  if ( dlg_open.Execute ) then
    begin
      fname := dlg_open.FileName;
      caption := extractfilename(fname)+' - MapCfg';
      application.Title := caption;
      filehandle := createfile(pchar(fname),GENERIC_READ,FILE_SHARE_READ,nil,
                               OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
      readfile(filehandle,mapcfgdata,sizeof(TMapCfgData),bytesread,nil);
      closehandle(filehandle);
      shp_color.Brush.Color := rgb(mapcfgdata.skycolor.red,mapcfgdata.skycolor.green,
                                   mapcfgdata.skycolor.blue);
      ed_skybox.Text := mapcfgdata.skyboxfname;
      sped_scale.Value := mapcfgdata.scale;                             
    end;
end;

procedure Tfrm_main.Kilps1Click(Sender: TObject);
begin
  frm_main.Close;
end;

end.
