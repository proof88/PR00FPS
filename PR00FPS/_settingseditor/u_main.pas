unit u_main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Spin, Menus, u_cfgfile;

type
  Tfrm_main = class(TForm)
    game_firstrun: TCheckBox;
    reserved1: TEdit;
    reserved2: TEdit;
    game_name: TEdit;
    game_autoswitchwpn: TCheckBox;
    game_showxhair: TCheckBox;
    game_showhud: TCheckBox;
    game_showblood: TCheckBox;
    game_oddinteract: TCheckBox;
    game_keybdledsinteract: TCheckBox;
    game_screensaveroff: TCheckBox;
    game_monitorpowersave: TCheckBox;
    game_stealthmode: TCheckBox;
    tbar_mouse: TTrackBar;
    input_mousesens: TLabel;
    lbl_mouse: TLabel;
    audio_sfx: TCheckBox;
    tbar_sfxvol: TTrackBar;
    audio_sfxvol: TLabel;
    lbl_sfxvol: TLabel;
    audio_music: TCheckBox;
    tbar_musicvol: TTrackBar;
    audio_musicvol: TLabel;
    lbl_musicvol: TLabel;
    video_lastvideocard: TEdit;
    video_gamma: TSpinEdit;
    lbl_video_gamma: TLabel;
    tbar_renderq: TTrackBar;
    video_renderq: TLabel;
    lbl_renderq: TLabel;
    video_debug: TCheckBox;
    video_res_h: TEdit;
    video_res_w: TEdit;
    video_colordepth: TEdit;
    video_refreshrate: TEdit;
    video_fullscreen: TCheckBox;
    lbl_bpp: TLabel;
    lbl_hz: TLabel;
    video_vsync: TCheckBox;
    video_shading_smooth: TCheckBox;
    video_mipmaps: TCheckBox;
    video_filtering: TEdit;
    video_simpleitems: TCheckBox;
    video_marksonwalls: TCheckBox;
    video_lightmaps: TCheckBox;
    mm: TMainMenu;
    Fjl1: TMenuItem;
    Betlts1: TMenuItem;
    Ments1: TMenuItem;
    N1: TMenuItem;
    Kilps1: TMenuItem;
    input_mousereverse: TCheckBox;
    video_zbuffer16bit: TCheckBox;
    tbar_motionblur: TTrackBar;
    lbl_mblur: TLabel;
    video_motionblur: TLabel;
    game_hudisblue: TCheckBox;
    procedure Kilps1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Betlts1Click(Sender: TObject);
    procedure Ments1Click(Sender: TObject);
    procedure tbar_mouseChange(Sender: TObject);
    procedure tbar_sfxvolChange(Sender: TObject);
    procedure tbar_musicvolChange(Sender: TObject);
    procedure tbar_renderqChange(Sender: TObject);
    procedure tbar_motionblurChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    cfgdata: pcfgdata;
  end;

var
  frm_main: Tfrm_main;

implementation

{$R *.dfm}

procedure Tfrm_main.Kilps1Click(Sender: TObject);
begin
  frm_main.Close;
end;

procedure Tfrm_main.FormCreate(Sender: TObject);
begin
  cfgallocbuffer();
  cfgdata := cfggetpointertobuffer();
end;

procedure Tfrm_main.Betlts1Click(Sender: TObject);
begin
  cfgreadintobuffer();
  game_firstrun.Checked := cfgdata^.game_firstrun;
  game_autoswitchwpn.Checked := cfgdata^.game_autoswitchwpn;
  game_showxhair.Checked := cfgdata^.game_showxhair;
  game_showhud.Checked := cfgdata^.game_showhud;
  game_hudisblue.Checked := cfgdata^.game_hudisblue;
  game_showblood.Checked := cfgdata^.game_showblood;
  game_oddinteract.Checked := cfgdata^.game_ODDinteract;
  game_keybdledsinteract.Checked := cfgdata^.game_keybdLEDsinteract;
  game_screensaveroff.Checked := cfgdata^.game_screensaveroff;
  game_monitorpowersave.Checked := cfgdata^.game_monitorpowersave;
  game_stealthmode.Checked := cfgdata^.game_stealthmode;
  audio_sfx.Checked := cfgdata^.audio_sfx;
  audio_music.Checked := cfgdata^.audio_music;
  video_debug.Checked := cfgdata^.video_debug;
  video_fullscreen.Checked := cfgdata^.video_fullscreen;
  video_vsync.Checked := cfgdata^.video_vsync;
  video_shading_smooth.Checked := cfgdata^.video_shading_smooth;
  video_mipmaps.Checked := cfgdata^.video_mipmaps;
  video_simpleitems.Checked := cfgdata^.video_simpleitems;
  video_marksonwalls.Checked := cfgdata^.video_marksonwalls;
  tbar_motionblur.Position := cfgdata^.video_motionblur;
  video_lightmaps.Checked := cfgdata^.video_lightmaps;
  reserved1.Text := inttostr(cfgdata^.reserved1);
  reserved2.Text := inttostr(cfgdata^.reserved2);
  game_name.Text := cfgdata^.game_name;
  video_lastvideocard.Text := cfgdata^.video_lastvideocard;
  video_res_w.Text := inttostr(cfgdata^.video_res_w);
  video_res_h.Text := inttostr(cfgdata^.video_res_h);
  video_colordepth.Text := inttostr(cfgdata^.video_colordepth);
  video_refreshrate.Text := inttostr(cfgdata^.video_refreshrate);
  video_filtering.Text := inttostr(cfgdata^.video_filtering);
  video_zbuffer16bit.Checked := cfgdata^.video_zbuffer16bit;
  tbar_mouse.Position := cfgdata^.input_mousesens;
  input_mousereverse.Checked := cfgdata^.input_mousereverse;
  tbar_sfxvol.Position := cfgdata^.audio_sfxvol;
  tbar_musicvol.Position := cfgdata^.audio_musicvol;
  tbar_renderq.Position := cfgdata^.video_renderq;
  video_gamma.Value := cfgdata^.video_gamma;
end;

procedure Tfrm_main.Ments1Click(Sender: TObject);
begin
  cfgdata^.game_firstrun := game_firstrun.Checked;
  cfgdata^.game_autoswitchwpn := game_autoswitchwpn.Checked;
  cfgdata^.game_showxhair := game_showxhair.Checked;
  cfgdata^.game_showhud := game_showhud.Checked;
  cfgdata^.game_hudisblue := game_hudisblue.Checked;
  cfgdata^.game_showblood := game_showblood.Checked;
  cfgdata^.game_ODDinteract := game_oddinteract.Checked;
  cfgdata^.game_keybdLEDsinteract := game_keybdledsinteract.Checked;
  cfgdata^.game_screensaveroff := game_screensaveroff.Checked;
  cfgdata^.game_monitorpowersave := game_monitorpowersave.Checked;
  cfgdata^.game_stealthmode := game_stealthmode.Checked;
  cfgdata^.audio_sfx := audio_sfx.Checked;
  cfgdata^.audio_music := audio_music.Checked;
  cfgdata^.video_debug := video_debug.Checked;
  cfgdata^.video_fullscreen := video_fullscreen.Checked;
  cfgdata^.video_vsync := video_vsync.Checked;
  cfgdata^.video_shading_smooth := video_shading_smooth.Checked;
  cfgdata^.video_mipmaps := video_mipmaps.Checked;
  cfgdata^.video_simpleitems := video_simpleitems.Checked;
  cfgdata^.video_marksonwalls := video_marksonwalls.Checked;
  cfgdata^.video_motionblur := tbar_motionblur.Position;
  cfgdata^.video_lightmaps := video_lightmaps.Checked;
  cfgdata^.reserved1 := strtoint(reserved1.Text);
  cfgdata^.reserved2 := strtoint(reserved2.Text);
  cfgdata^.game_name := game_name.Text;
  cfgdata^.video_lastvideocard := video_lastvideocard.Text;
  cfgdata^.video_res_w := strtoint(video_res_w.Text);
  cfgdata^.video_res_h := strtoint(video_res_h.Text);
  cfgdata^.video_colordepth := strtoint(video_colordepth.Text);
  cfgdata^.video_refreshrate := strtoint(video_refreshrate.Text);
  cfgdata^.video_filtering := strtoint(video_filtering.Text);
  cfgdata^.video_zbuffer16bit := video_zbuffer16bit.Checked;
  cfgdata^.input_mousesens := tbar_mouse.Position;
  cfgdata^.input_mousereverse := input_mousereverse.Checked;
  cfgdata^.audio_sfxvol := tbar_sfxvol.Position;
  cfgdata^.audio_musicvol := tbar_musicvol.Position;
  cfgdata^.video_renderq := tbar_renderq.Position;
  cfgdata^.video_gamma := video_gamma.Value;
  cfgwritefrombuffer();
end;

procedure Tfrm_main.tbar_mouseChange(Sender: TObject);
begin
  lbl_mouse.Caption := inttostr(tbar_mouse.Position);
end;

procedure Tfrm_main.tbar_sfxvolChange(Sender: TObject);
begin
  lbl_sfxvol.Caption := inttostr(tbar_sfxvol.Position);
end;

procedure Tfrm_main.tbar_musicvolChange(Sender: TObject);
begin
  lbl_musicvol.Caption := inttostr(tbar_musicvol.Position);
end;

procedure Tfrm_main.tbar_renderqChange(Sender: TObject);
begin
  lbl_renderq.Caption := inttostr(tbar_renderq.Position);
end;

procedure Tfrm_main.tbar_motionblurChange(Sender: TObject);
begin
  lbl_mblur.Caption := inttostr(tbar_motionblur.position);
end;

end.
