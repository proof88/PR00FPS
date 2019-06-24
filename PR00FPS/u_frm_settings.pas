unit u_frm_settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, Buttons, u_cfgfile, mmsystem;

const
  renderqualitystr: array[0..5] of string = ('-> Minimum','-> Alacsony','-> Közepes',
                                              '-> Magas','-> Maximum','-> Egyéni');

type
  PRGBArray = ^TRGBArray;
  TRGBArray = array[0..4095] of TRGBTriple;
  Tfrm_settings = class(TForm)
    gbox_game: TGroupBox;
    cbox_autoswitch: TCheckBox;
    cbox_xhair: TCheckBox;
    gbox_mousekeyboard: TGroupBox;
    tbar_mouse: TTrackBar;
    gbox_gfx: TGroupBox;
    gbox_gamma: TGroupBox;
    tbar_gamma: TTrackBar;
    img_gammasample: TImage;
    gbox_render: TGroupBox;
    tbar_renderq: TTrackBar;
    lbl_renderq: TLabel;
    cbox_opticaldrive: TCheckBox;
    gbox_audio: TGroupBox;
    tbar_audioeffect: TTrackBar;
    cbox_audioeffect: TCheckBox;
    cbox_screensaver: TCheckBox;
    cbox_monitorpwrsave: TCheckBox;
    lbl_mousesens: TLabel;
    lbl_audioeffectsvol: TLabel;
    cbox_stealth: TCheckBox;
    lbl_gamma: TLabel;
    cbox_hud: TCheckBox;
    lbl_hudcolor: TLabel;
    rbtn_hudblue: TRadioButton;
    rbtn_hudmagenta: TRadioButton;
    cbox_blood: TCheckBox;
    cbox_renderdebug: TCheckBox;
    cbox_mousereverse: TCheckBox;
    lbl_mouseinfo: TLabel;
    gbox_controller: TGroupBox;
    tbar_music: TTrackBar;
    lbl_musicvol: TLabel;
    cbox_music: TCheckBox;
    pnl_detailsbg: TPanel;
    spbtn_details: TSpeedButton;
    pnl_controllerbg: TPanel;
    spbtn_controller: TSpeedButton;
    pnl_defaultsbg: TPanel;
    spbtn_defaults: TSpeedButton;
    cbox_keybd_leds: TCheckBox;
    pnl_autosetbg: TPanel;
    spbtn_autoset: TSpeedButton;
    procedure btn_renderdetailsClick(Sender: TObject);
    procedure tbar_gammaChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure tbar_mouseChange(Sender: TObject);
    procedure tbar_audioeffectChange(Sender: TObject);
    procedure tbar_musicChange(Sender: TObject);
    procedure tbar_renderqChange(Sender: TObject);
    procedure cbox_hudClick(Sender: TObject);
    procedure spbtn_defaultsClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure spbtn_controllerClick(Sender: TObject);
    procedure cbox_audioeffectClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    cachedbmp: tbitmap;
    settings: pcfgdata;
    function rangeByte(value: integer): byte;
  public
    { Public declarations }
  end;

var
  frm_settings: Tfrm_settings;

implementation

uses u_frm_gfxsettings, u_frm_controllerpic;

{$R *.dfm}

procedure Tfrm_settings.btn_renderdetailsClick(Sender: TObject);
begin
  frm_gfxsettings := tfrm_gfxsettings.Create(self);
  frm_gfxsettings.showmodal;
  cfgReadIntoBuffer;
  if ( (settings^.video_res_w = 320) and (settings^.video_res_h = 240) and
       (settings^.video_colordepth = 16) and (settings^.video_fullscreen) and
       not(settings^.video_vsync) and not(settings^.video_shading_smooth) and
       not(settings^.video_mipmaps) and (settings^.video_filtering = 0) and
       not(settings^.video_simpleitems) and not(settings^.video_marksonwalls)
       and (settings^.video_motionblur = 0) and not(settings^.video_lightmaps)
       and (settings^.video_zbuffer16bit) and (settings^.reserved2 = 0) )
   then tbar_renderq.Position := 0 else
    if ( (settings^.video_res_w = 640) and (settings^.video_res_h = 480) and
         (settings^.video_colordepth = 16) and (settings^.video_fullscreen) and
         not(settings^.video_vsync) and not(settings^.video_shading_smooth) and
         (settings^.video_mipmaps) and (settings^.video_filtering = 0) and
         (settings^.video_simpleitems) and not(settings^.video_marksonwalls)
         and (settings^.video_motionblur = 0) and not(settings^.video_lightmaps)
         and not(settings^.video_zbuffer16bit) and (settings^.reserved2 = 1) )
     then tbar_renderq.Position := 1 else
      if ( (settings^.video_res_w = 800) and (settings^.video_res_h = 600) and
           (settings^.video_colordepth = 16) and (settings^.video_fullscreen) and
           (settings^.video_vsync) and (settings^.video_shading_smooth) and
           (settings^.video_mipmaps) and (settings^.video_filtering = 0) and
           (settings^.video_simpleitems) and not(settings^.video_marksonwalls)
           and (settings^.video_motionblur = 0) and (settings^.video_lightmaps)
           and not(settings^.video_zbuffer16bit) and (settings^.reserved2 = 2) )
       then tbar_renderq.Position := 2 else
        if ( (settings^.video_res_w = 1024) and (settings^.video_res_h = 768) and
             (settings^.video_colordepth = 16) and (settings^.video_fullscreen) and
             (settings^.video_vsync) and (settings^.video_shading_smooth) and
             (settings^.video_mipmaps) and (settings^.video_filtering = 1) and
             (settings^.video_simpleitems) and (settings^.video_marksonwalls)
             and (settings^.video_motionblur = 2) and (settings^.video_lightmaps)
             and not(settings^.video_zbuffer16bit) and (settings^.reserved2 = 2) )
         then tbar_renderq.Position := 3 else
          if ( (settings^.video_res_w = 1280) and (settings^.video_res_h = 1024) and
               (settings^.video_colordepth = 32) and (settings^.video_fullscreen) and
               (settings^.video_vsync) and (settings^.video_shading_smooth) and
               (settings^.video_mipmaps) and (settings^.video_filtering = 1) and
               (settings^.video_simpleitems) and (settings^.video_marksonwalls)
               and (settings^.video_motionblur = 2) and (settings^.video_lightmaps)
               and not(settings^.video_zbuffer16bit) and (settings^.reserved2 = 3) )
           then tbar_renderq.Position := 4 else
            tbar_renderq.Position := 5;
end;

function Tfrm_settings.rangeByte(value: integer): byte;
begin
  if ( value > 255 ) then result := 255
    else if ( value < 0 ) then result := 0
      else result := byte(value);
end;

procedure Tfrm_settings.tbar_gammaChange(Sender: TObject);
var bmp: tbitmap;
    i,j: integer;
    scanline: prgbarray;
begin
  bmp := tbitmap.Create;
  bmp.Width := cachedbmp.Width;
  bmp.Height := cachedbmp.Height;
  bmp.PixelFormat := pf24bit;
  bmp.Assign(cachedbmp);
  for j := 0 to bmp.Height-1 do
    begin
      scanline := bmp.ScanLine[j];
      for i := 0 to bmp.Width-1 do
        begin
          scanline[i].rgbtRed := rangeByte(scanline[i].rgbtRed + tbar_gamma.Position);
          scanline[i].rgbtGreen := rangeByte(scanline[i].rgbtGreen + tbar_gamma.Position);
          scanline[i].rgbtBlue := rangeByte(scanline[i].rgbtBlue + tbar_gamma.Position);
        end;
    end;
  img_gammasample.picture.Assign(bmp);
  bmp.Free;
  lbl_gamma.Caption := inttostr(tbar_gamma.position+100)+' %';
end;

procedure Tfrm_settings.FormCreate(Sender: TObject);
begin
  cachedbmp := tbitmap.Create;
  cachedbmp.Assign(img_gammasample.Picture.Bitmap);

  cfgReadIntoBuffer;
  settings := cfgGetPointerToBuffer;
  cbox_autoswitch.Checked := settings^.game_autoswitchwpn;
  cbox_xhair.Checked := settings^.game_showxhair;
  cbox_hud.Checked := settings^.game_showhud;
  rbtn_hudblue.Checked := settings^.game_hudisblue;
  rbtn_hudmagenta.Checked := not(settings^.game_hudisblue);
  cbox_blood.checked := settings^.game_showblood;
  cbox_opticaldrive.Checked := settings^.game_ODDinteract;
  cbox_keybd_leds.Checked := settings^.game_keybdLEDsinteract;
  cbox_screensaver.Checked := settings^.game_screensaveroff;
  cbox_monitorpwrsave.Checked := settings^.game_monitorpowersave;
  cbox_stealth.Checked := settings^.game_stealthmode;
  tbar_mouse.Position := settings^.input_mousesens;
  cbox_mousereverse.Checked := settings^.input_mousereverse;
  cbox_audioeffect.Checked := settings^.audio_sfx;
  tbar_audioeffect.Position := settings^.audio_sfxvol;
  //cbox_music.Checked := settings^.audio_music;
  //tbar_music.Position := settings^.audio_musicvol;
  tbar_gamma.Position := settings^.video_gamma;
  tbar_renderq.Position := settings^.video_renderq;
  cbox_renderdebug.checked := settings^.video_debug;
end;

procedure Tfrm_settings.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  cachedbmp.Free;
  settings^.game_autoswitchwpn := cbox_autoswitch.Checked;
  settings^.game_showxhair := cbox_xhair.Checked;
  settings^.game_showhud := cbox_hud.Checked;
  settings^.game_hudisblue := rbtn_hudblue.Checked;
  settings^.game_showblood := cbox_blood.checked;
  settings^.game_ODDinteract := cbox_opticaldrive.Checked;
  settings^.game_keybdLEDsinteract := cbox_keybd_leds.Checked;
  settings^.game_screensaveroff := cbox_screensaver.Checked;
  settings^.game_monitorpowersave := cbox_monitorpwrsave.Checked;
  settings^.game_stealthmode := cbox_stealth.Checked;
  settings^.input_mousesens := tbar_mouse.Position;
  settings^.input_mousereverse := cbox_mousereverse.Checked;
  settings^.audio_sfx := cbox_audioeffect.Checked;
  settings^.audio_sfxvol := tbar_audioeffect.Position;
  //settings^.audio_music := cbox_music.Checked;
  //settings^.audio_musicvol := tbar_music.Position;
  settings^.video_gamma := tbar_gamma.Position;
  settings^.video_renderq := tbar_renderq.Position;
  settings^.video_debug := cbox_renderdebug.checked;
  cfgWriteFromBuffer;
end;

procedure Tfrm_settings.tbar_mouseChange(Sender: TObject);
begin
  lbl_mousesens.Caption := inttostr(tbar_mouse.position*10)+' %';
end;

procedure Tfrm_settings.tbar_audioeffectChange(Sender: TObject);
begin
  lbl_audioeffectsvol.Caption := inttostr(tbar_audioeffect.position)+' %';
end;

procedure Tfrm_settings.tbar_musicChange(Sender: TObject);
begin
  lbl_musicvol.Caption := inttostr(tbar_music.Position)+' %';
end;

procedure Tfrm_settings.tbar_renderqChange(Sender: TObject);
begin
  lbl_renderq.Caption := renderqualitystr[tbar_renderq.position];
  case tbar_renderq.Position of
    0: begin  // minimum
         settings^.video_res_w := 320;
         settings^.video_res_h := 240;
         settings^.video_colordepth := 16;
         settings^.video_fullscreen := TRUE;
         settings^.video_refreshrate := 255;
         settings^.video_vsync := FALSE;
         settings^.video_shading_smooth := FALSE;
         settings^.video_mipmaps := FALSE;
         settings^.video_filtering := 0;
         settings^.video_simpleitems := FALSE;
         settings^.video_marksonwalls := FALSE;
         settings^.video_motionblur := 0;
         settings^.video_lightmaps := FALSE;
         settings^.video_zbuffer16bit := TRUE;
         settings^.reserved2 := 0;
       end;
    1: begin  // alacsony
         settings^.video_res_w := 640;
         settings^.video_res_h := 480;
         settings^.video_colordepth := 16;
         settings^.video_fullscreen := TRUE;
         settings^.video_refreshrate := 255;
         settings^.video_vsync := FALSE;
         settings^.video_shading_smooth := FALSE;
         settings^.video_mipmaps := TRUE;
         settings^.video_filtering := 0;
         settings^.video_simpleitems := TRUE;
         settings^.video_marksonwalls := FALSE;
         settings^.video_motionblur := 0;
         settings^.video_lightmaps := FALSE;
         settings^.video_zbuffer16bit := FALSE;
         settings^.reserved2 := 1;
       end;
    2: begin  // közepes
         settings^.video_res_w := 800;
         settings^.video_res_h := 600;
         settings^.video_colordepth := 16;
         settings^.video_fullscreen := TRUE;
         settings^.video_refreshrate := 255;
         settings^.video_vsync := TRUE;
         settings^.video_shading_smooth := TRUE;
         settings^.video_mipmaps := TRUE;
         settings^.video_filtering := 0;
         settings^.video_simpleitems := TRUE;
         settings^.video_marksonwalls := FALSE;
         settings^.video_motionblur := 0;
         settings^.video_lightmaps := TRUE;
         settings^.video_zbuffer16bit := FALSE;
         settings^.reserved2 := 2;
       end;
    3: begin  // magas
         settings^.video_res_w := 1024;
         settings^.video_res_h := 768;
         settings^.video_colordepth := 16;
         settings^.video_fullscreen := TRUE;
         settings^.video_refreshrate := 255;
         settings^.video_vsync := TRUE;
         settings^.video_shading_smooth := TRUE;
         settings^.video_mipmaps := TRUE;
         settings^.video_filtering := 1;
         settings^.video_simpleitems := TRUE;
         settings^.video_marksonwalls := TRUE;
         settings^.video_motionblur := 2;
         settings^.video_lightmaps := TRUE;
         settings^.video_zbuffer16bit := FALSE;
         settings^.reserved2 := 2;
       end;
    4: begin  // maximum
         settings^.video_res_w := 1280;
         settings^.video_res_h := 1024;
         settings^.video_colordepth := 32;
         settings^.video_fullscreen := TRUE;
         settings^.video_refreshrate := 255;
         settings^.video_vsync := TRUE;
         settings^.video_shading_smooth := TRUE;
         settings^.video_mipmaps := TRUE;
         settings^.video_filtering := 1;
         settings^.video_simpleitems := TRUE;
         settings^.video_marksonwalls := TRUE;
         settings^.video_motionblur := 2;
         settings^.video_lightmaps := TRUE;
         settings^.video_zbuffer16bit := FALSE;
         settings^.reserved2 := 3;
       end;
  end;
end;

procedure Tfrm_settings.cbox_hudClick(Sender: TObject);
begin
  rbtn_hudblue.Enabled := cbox_hud.Checked;
  rbtn_hudmagenta.Enabled := rbtn_hudblue.Enabled;
end;

procedure Tfrm_settings.spbtn_defaultsClick(Sender: TObject);
begin
  cbox_autoswitch.Checked := TRUE;
  cbox_xhair.Checked := TRUE;
  cbox_hud.Checked := TRUE;
  rbtn_hudblue.Checked := TRUE;
  cbox_blood.Checked := TRUE;
  cbox_opticaldrive.Checked := FALSE;
  cbox_keybd_leds.Checked := TRUE;
  cbox_screensaver.Checked := TRUE;
  cbox_monitorpwrsave.Checked := TRUE;
  cbox_stealth.Checked := TRUE;
  tbar_mouse.Position := 10;
  cbox_mousereverse.Checked := FALSE;
  cbox_audioeffect.Checked := TRUE;
  tbar_audioeffect.Position := 80;
  //cbox_music.Checked := TRUE;
  //tbar_music.Position := 60;
  tbar_gamma.Position := 0;
  cbox_renderdebug.Checked := FALSE;
  tbar_renderq.Position := 5;
  settings^.video_res_w := 800;
  settings^.video_res_h := 600;
  settings^.video_colordepth := 32;
  settings^.video_fullscreen := TRUE;
  settings^.video_refreshrate := 255;
  settings^.video_vsync := TRUE;
  settings^.video_shading_smooth := TRUE;
  settings^.video_mipmaps := TRUE;
  settings^.video_filtering := 1;
  settings^.video_simpleitems := TRUE;
  settings^.video_marksonwalls := TRUE;
  settings^.video_motionblur := 2;
  settings^.video_lightmaps := TRUE;
  settings^.video_zbuffer16bit := FALSE;
  settings^.reserved1 := 1;
  settings^.reserved2 := 2;
end;

procedure Tfrm_settings.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case key of
    VK_RETURN,VK_ESCAPE: frm_settings.Close;
  end;
end;

procedure Tfrm_settings.spbtn_controllerClick(Sender: TObject);
begin
  frm_controllerpic := Tfrm_controllerpic.Create(self);
  frm_controllerpic.showmodal;
end;

procedure Tfrm_settings.cbox_audioeffectClick(Sender: TObject);
begin
  if ( cbox_audioeffect.Checked ) then
    tbar_audioeffect.Enabled := TRUE
   else
    tbar_audioeffect.Enabled := FALSE;
end;

procedure Tfrm_settings.FormShow(Sender: TObject);
begin
  while ( showcursor(TRUE) < 0 ) do ;
end;

end.
