unit u_frm_gfxsettings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, u_cfgfile, ComCtrls;

const
  smokequalitystr: array[0..3] of string = ('-> Nincs füst','-> Kevés füst','-> Sok füst',
                                              '-> Extrém füst');

type
  Tfrm_gfxsettings = class(TForm)
    combox_resolution: TComboBox;
    lbl_resolution: TLabel;
    combox_freq: TComboBox;
    lbl_freq: TLabel;
    cbox_vsync: TCheckBox;
    cbox_fullscreen: TCheckBox;
    gbox_filtering: TGroupBox;
    cbox_mipmaps: TCheckBox;
    combox_filtering: TComboBox;
    cbox_simpleitems: TCheckBox;
    cbox_marksonwalls: TCheckBox;
    cbox_lightmaps: TCheckBox;
    gbox_colordepth: TGroupBox;
    rbtn_16bit: TRadioButton;
    rbtn_32bit: TRadioButton;
    gbox_shading: TGroupBox;
    rbtn_gl_flat: TRadioButton;
    rbtn_gl_smooth: TRadioButton;
    lbl_infomblur: TLabel;
    combox_motionblur: TComboBox;
    gbox_zbuffer: TGroupBox;
    rbtn_z16bit: TRadioButton;
    rbtn_z24bit: TRadioButton;
    lbl_resinfo: TLabel;
    lbl_refreshrateinfo: TLabel;
    cbox_showfps: TCheckBox;
    tbar_smoke: TTrackBar;
    lbl_infosmokes: TLabel;
    lbl_smoketext: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure combox_resolutionChange(Sender: TObject);
    procedure rbtn_16bitClick(Sender: TObject);
    procedure rbtn_32bitClick(Sender: TObject);
    procedure cbox_fullscreenClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tbar_smokeChange(Sender: TObject);
  private
    { Private declarations }
    tizenhatbiteslista,harmincketbiteslista: tlist;
    settings: pcfgdata;
  public
    { Public declarations }
  end;

var
  frm_gfxsettings: Tfrm_gfxsettings;

implementation

{$R *.dfm}

procedure Tfrm_gfxsettings.FormCreate(Sender: TObject);
var
  i,j,ind: integer;      
  dm: devmode;
  l: boolean;
  p: pdevmode;
begin
  settings := cfgGetPointerToBuffer();
  cbox_fullscreen.Checked := settings^.video_fullscreen;
  cbox_vsync.Checked := settings^.video_vsync;
  if ( settings^.reserved1 = 1 ) then cbox_showfps.Checked := TRUE
    else cbox_showfps.Checked := FALSE;
  rbtn_gl_smooth.Checked := settings^.video_shading_smooth;
  rbtn_gl_flat.Checked := not(settings^.video_shading_smooth);
  rbtn_z16bit.Checked := settings^.video_zbuffer16bit;
  rbtn_z24bit.Checked := not(settings^.video_zbuffer16bit);
  cbox_mipmaps.Checked := settings^.video_mipmaps;
  combox_filtering.ItemIndex := settings^.video_filtering;
  cbox_simpleitems.Checked := settings^.video_simpleitems;
  cbox_marksonwalls.Checked := settings^.video_marksonwalls;
  combox_motionblur.ItemIndex := settings^.video_motionblur;
  cbox_lightmaps.Checked := settings^.video_lightmaps;
  tbar_smoke.Position := settings^.reserved2;
  tizenhatbiteslista := tlist.create;
  harmincketbiteslista := tlist.Create;
  enumdisplaysettings(nil,0,dm);
  i := 0;
  j := -1;
  ind := -1;
  repeat
    i := i+1;
    l := enumdisplaysettings(nil,i,dm);
    if ( (dm.dmBitsPerPel in [16,32]) and ( dm.dmPelsWidth > dm.dmPelsHeight ) ) then
      begin
        new(p);
        p^ := dm;
        case dm.dmBitsPerPel of
          16: tizenhatbiteslista.Add(p);
          32: harmincketbiteslista.Add(p);
        end;
        if ( pos(inttostr(dm.dmPelsWidth)+' x '+inttostr(dm.dmPelsHeight),combox_resolution.Items.GetText) = 0 ) then
          begin
            j := j+1;
            combox_resolution.Items.Add(inttostr(dm.dmPelsWidth)+' x '+inttostr(dm.dmPelsHeight));
            if ( (pos(inttostr(settings^.video_res_w)+' x '+inttostr(settings^.video_res_h),combox_resolution.Items.GetText) > 0) and (ind = -1) ) then
              ind := j;
          end;
      end;
  until (not(l));
  if ( ind = -1 ) then combox_resolution.ItemIndex := 0
    else combox_resolution.ItemIndex := ind;
  combox_resolution.OnChange(sender);
end;

procedure Tfrm_gfxsettings.combox_resolutionChange(Sender: TObject);
var blah,blah2,i: cardinal;
    p: pdevmode;
begin
  blah := strtoint(copy(combox_resolution.Text,1,pos('x',combox_resolution.Text)-2));
  blah2 := strtoint(copy(combox_resolution.Text,pos('x',combox_resolution.Text)+2,length(combox_resolution.Text)-(pos('x',combox_resolution.Text)+1)));
  rbtn_32bit.Enabled := FALSE;
  for i := 0 to harmincketbiteslista.Count-1 do
    begin
      p := harmincketbiteslista.Items[i];
      if ( (p^.dmPelsWidth = blah) and (p^.dmPelsHeight = blah2) ) then
        begin
          rbtn_32bit.Enabled := TRUE;
          break;
        end;
    end;
  if ( (settings^.video_colordepth = 32) and (rbtn_32bit.Enabled) ) then
    begin
      rbtn_32bit.Checked := TRUE;
      rbtn_32bit.OnClick(sender);
    end
   else
    begin
      rbtn_16bit.Checked := TRUE;
      rbtn_16bit.OnClick(sender);
    end;
end;

procedure Tfrm_gfxsettings.rbtn_16bitClick(Sender: TObject);
var blah,blah2,i: cardinal;
    ind,j: integer;
    p: pdevmode;
begin
  combox_freq.Clear;
  blah := strtoint(copy(combox_resolution.Text,1,pos('x',combox_resolution.Text)-2));
  blah2 := strtoint(copy(combox_resolution.Text,pos('x',combox_resolution.Text)+2,length(combox_resolution.Text)-(pos('x',combox_resolution.Text)+1)));
  ind := -1;
  j := -1;
  for i := 0 to tizenhatbiteslista.Count-1 do
    begin
      p := tizenhatbiteslista.Items[i];
      if ( (p^.dmPelsWidth = blah) and (p^.dmPelsHeight = blah2) ) then
        begin
          if ( (pos(inttostr(p^.dmDisplayFrequency),combox_freq.Items.GetText) = 0) and (p^.dmDisplayFrequency >= 60) ) then
            begin
              j := j+1;
              combox_freq.Items.Add(inttostr(p^.dmDisplayFrequency));
              if ( (p^.dmDisplayFrequency = settings^.video_refreshrate) and (ind = -1) ) then
                ind := j;
            end;
        end;
    end;
  if ( pos(inttostr(settings^.video_refreshrate),combox_freq.Items.GetText) = 0 ) then
    combox_freq.ItemIndex := combox_freq.Items.Count-1
   else combox_freq.ItemIndex := ind;
end;

procedure Tfrm_gfxsettings.rbtn_32bitClick(Sender: TObject);
var blah,blah2,i: cardinal;
    ind,j: integer;
    p: pdevmode;
begin
  combox_freq.Clear;
  blah := strtoint(copy(combox_resolution.Text,1,pos('x',combox_resolution.Text)-2));
  blah2 := strtoint(copy(combox_resolution.Text,pos('x',combox_resolution.Text)+2,length(combox_resolution.Text)-(pos('x',combox_resolution.Text)+1)));
  ind := -1;
  j := -1;
  for i := 0 to harmincketbiteslista.Count-1 do
      begin
        p := harmincketbiteslista.Items[i];
        if ( (p^.dmPelsWidth = blah) and (p^.dmPelsHeight = blah2) ) then
          begin
            if ( (pos(inttostr(p^.dmDisplayFrequency),combox_freq.Items.GetText) = 0) and (p^.dmDisplayFrequency >= 60) ) then
              begin
                j := j+1;
                combox_freq.Items.Add(inttostr(p^.dmDisplayFrequency));
                if ( (p^.dmDisplayFrequency = settings^.video_refreshrate) and (ind = -1) ) then
                  ind := j;
              end;
          end;
      end;
  if ( pos(inttostr(settings^.video_refreshrate),combox_freq.Items.GetText) = 0 ) then
    combox_freq.ItemIndex := combox_freq.Items.Count-1
   else combox_freq.ItemIndex := ind;
end;

procedure Tfrm_gfxsettings.cbox_fullscreenClick(Sender: TObject);
begin
  combox_freq.Enabled := cbox_fullscreen.Checked;
end;

procedure Tfrm_gfxsettings.FormClose(Sender: TObject; var Action: TCloseAction);
var blah,blah2: cardinal;
begin
  blah := strtoint(copy(combox_resolution.Text,1,pos('x',combox_resolution.Text)-2));
  blah2 := strtoint(copy(combox_resolution.Text,pos('x',combox_resolution.Text)+2,length(combox_resolution.Text)-(pos('x',combox_resolution.Text)+1)));
  settings^.video_res_w := blah;
  settings^.video_res_h := blah2;
  if ( rbtn_16bit.Checked ) then settings^.video_colordepth := 16
    else settings^.video_colordepth := 32;
  settings^.video_refreshrate := strtoint(combox_freq.text);
  settings^.video_fullscreen := cbox_fullscreen.Checked;
  settings^.video_vsync := cbox_vsync.Checked;
  if ( cbox_showfps.Checked ) then settings^.reserved1 := 1
    else settings^.reserved1 := 0;
  settings^.reserved2 := tbar_smoke.Position;
  settings^.video_shading_smooth := rbtn_gl_smooth.Checked;
  settings^.video_mipmaps := cbox_mipmaps.Checked;
  settings^.video_filtering := combox_filtering.ItemIndex;
  settings^.video_motionblur := combox_motionblur.ItemIndex;
  settings^.video_simpleitems := cbox_simpleitems.Checked;
  settings^.video_marksonwalls := cbox_marksonwalls.Checked;
  settings^.video_motionblur := combox_motionblur.ItemIndex;
  settings^.video_lightmaps := cbox_lightmaps.Checked;
  settings^.video_zbuffer16bit := rbtn_z16bit.Checked;
  cfgWriteFromBuffer;
end;

procedure Tfrm_gfxsettings.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case key of
    VK_ESCAPE,VK_RETURN: frm_gfxsettings.Close;
  end;
end;

procedure Tfrm_gfxsettings.tbar_smokeChange(Sender: TObject);
begin
  lbl_smoketext.Caption := smokequalitystr[tbar_smoke.Position];
end;

end.
