unit u_frm_newgame;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, Spin, StdCtrls, ExtCtrls, u_cfgfile, u_map, u_bots,
  u_frm_teamselect, u_frm_gausselect;

type
  Tfrm_newgame = class(TForm)
    gbox_map: TGroupBox;
    lbox_maps: TListBox;
    img_map: TImage;
    gbox_gamemode: TGroupBox;
    rbtn_dm: TRadioButton;
    rbtn_tdm: TRadioButton;
    rbtn_gauss: TRadioButton;
    gbox_gamelimit: TGroupBox;
    rbtn_time: TRadioButton;
    rbtn_frag: TRadioButton;
    rbtn_never: TRadioButton;
    sped_timelimit: TSpinEdit;
    sped_fraglimit: TSpinEdit;
    gbox_players: TGroupBox;
    lbox_chosen: TListBox;
    lbl_chosen: TLabel;
    lbl_selectable: TLabel;
    lbox_selectable: TListBox;
    ed_playername: TEdit;
    pnl_playbg: TPanel;
    spbtn_play: TSpeedButton;
    pnl_infobg: TPanel;
    spbtn_info: TSpeedButton;
    pnl_copytoleftbg: TPanel;
    pnl_copytorightbg: TPanel;
    pnl_copyalltoleftbg: TPanel;
    pnl_copyalltorightbg: TPanel;
    spbtn_copytoleft: TSpeedButton;
    spbtn_copytoright: TSpeedButton;
    spbtn_copyalltoleft: TSpeedButton;
    spbtn_copyalltoright: TSpeedButton;
    lbl_info: TLabel;
    procedure spbtn_copytoleftClick(Sender: TObject);
    procedure spbtn_copytorightClick(Sender: TObject);
    procedure spbtn_copyalltoleftClick(Sender: TObject);
    procedure spbtn_copyalltorightClick(Sender: TObject);
    procedure spbtn_infoClick(Sender: TObject);
    procedure rbtn_timeClick(Sender: TObject);
    procedure rbtn_fragClick(Sender: TObject);
    procedure rbtn_neverClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lbox_mapsClick(Sender: TObject);
    procedure spbtn_playClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lbox_mapsDblClick(Sender: TObject);
    procedure lbox_selectableDblClick(Sender: TObject);
    procedure lbox_chosenDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    settings: pcfgdata;
  public
    { Public declarations }
    alliedlist: string;
  end;

var
  frm_newgame: Tfrm_newgame;

implementation

uses u_frm_showmapinfo;

{$R *.dfm}

procedure Tfrm_newgame.spbtn_copytoleftClick(Sender: TObject);
var
  i,numcopied: integer;
begin
  numcopied := 0;
  for i := lbox_selectable.Count-1 downto 0 do
    if ( lbox_selectable.Selected[i] ) then
      begin
        numcopied := numcopied + 1;
        lbox_chosen.Items.Add(lbox_selectable.Items[i]);
        lbox_selectable.Items.Delete(i);
      end;
  if ( (numcopied = 0) and (lbox_selectable.Items.Count > 0) ) then
    begin
      lbox_chosen.Items.Add(lbox_selectable.Items[lbox_selectable.ItemIndex]);
      lbox_selectable.Items.Delete(lbox_selectable.ItemIndex);
    end;
end;

procedure Tfrm_newgame.spbtn_copytorightClick(Sender: TObject);
var
  i,numcopied: integer;
begin
  numcopied := 0;
  for i := lbox_chosen.Count-1 downto 0 do
    if ( lbox_chosen.Selected[i] ) then
      begin
        numcopied := numcopied + 1;
        lbox_selectable.Items.Add(lbox_chosen.Items[i]);
        lbox_chosen.Items.Delete(i);
      end;
  if ( (numcopied = 0) and ((lbox_chosen.Items.Count > 0)) ) then
    begin
      lbox_selectable.Items.Add(lbox_chosen.Items[lbox_chosen.ItemIndex]);
      lbox_chosen.Items.Delete(lbox_chosen.ItemIndex);
    end;
end;

procedure Tfrm_newgame.spbtn_copyalltoleftClick(Sender: TObject);
begin
  lbox_chosen.Items.AddStrings(lbox_selectable.Items);
  lbox_selectable.Clear;
end;

procedure Tfrm_newgame.spbtn_copyalltorightClick(Sender: TObject);
begin
  lbox_selectable.Items.AddStrings(lbox_chosen.Items);
  lbox_chosen.Clear;
end;

procedure Tfrm_newgame.spbtn_infoClick(Sender: TObject);
var
  mapname: string;
begin
  if ( lbox_maps.Items.Count > 0 ) then
    begin
      mapname := lbox_maps.items[lbox_maps.itemindex];
      if ( fileExists(getCurrentDir()+'\data\maps\'+mapname+'\'+mapname+'.txt') ) then
        begin
          frm_showmapinfo := tfrm_showmapinfo.create(self);
          frm_showmapinfo.setfilename(getCurrentDir()+'\data\maps\'+mapname+'\'+mapname+'.txt');
          frm_showmapinfo.showmodal;
        end;
    end;
end;

procedure Tfrm_newgame.rbtn_timeClick(Sender: TObject);
begin
  sped_timelimit.Enabled := TRUE;
  sped_fraglimit.Enabled := FALSE;
end;

procedure Tfrm_newgame.rbtn_fragClick(Sender: TObject);
begin
  sped_fraglimit.Enabled := TRUE;
  sped_timelimit.Enabled := FALSE;
end;

procedure Tfrm_newgame.rbtn_neverClick(Sender: TObject);
begin
  sped_timelimit.Enabled := FALSE;
  sped_fraglimit.Enabled := FALSE;
end;

procedure Tfrm_newgame.FormCreate(Sender: TObject);
var
  srec: TSearchRec;
begin
  cfgReadIntoBuffer;
  settings := cfgGetPointerToBuffer();
  ed_playername.Text := settings^.game_name;
  
  lbox_maps.Items.Clear;
  if ( directoryExists('data') ) then
    begin
      if ( fileExists('data\botnames.txt') ) then
        lbox_selectable.Items.LoadFromFile('data\botnames.txt');
      if ( directoryExists('data\maps') ) then
        begin
          if ( findfirst(getCurrentDir()+'\data\maps\*.*',faDirectory,srec) = 0 ) then
            begin
              repeat
                if ( (srec.Name <> '.') and (srec.Name <> '..') and ((srec.Attr and faDirectory) = faDirectory) ) then
                  lbox_maps.Items.Add(srec.Name);
              until ( findnext(srec) <> 0 );
              findclose(srec);
            end;
        end;
    end;
  if ( lbox_maps.Items.Count > 0 ) then
     begin
       lbox_maps.ItemIndex := 0;
       lbox_maps.OnClick(sender);
     end
    else
     begin
     end;
end;

procedure Tfrm_newgame.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  settings^.game_name := ed_playername.Text;
  cfgWriteFromBuffer;
end;

procedure Tfrm_newgame.lbox_mapsClick(Sender: TObject);
var
  mapname: string;
begin
  if ( lbox_maps.Items.Count > 0 ) then
    begin
      mapname := lbox_maps.items[lbox_maps.itemindex];
      if ( fileExists(getCurrentDir()+'\data\maps\'+mapname+'\'+mapname+'.bmp') ) then
        img_map.Picture.LoadFromFile(getCurrentDir()+'\data\maps\'+mapname+'\'+mapname+'.bmp')
       else img_map.Picture.Bitmap.Assign(nil);
      mapSetMapName(mapname);
    end;
end;

procedure Tfrm_newgame.spbtn_playClick(Sender: TObject);
var
  i: integer;
begin
  if ( rbtn_tdm.Checked ) then
    begin
      cfgSetGameMode(gmTeamDeathMatch);
      if ( lbox_chosen.Items.Count > 0 ) then
        begin
          frm_teamselect := Tfrm_teamselect.Create(self);
          for i := 0 to lbox_chosen.Items.Count-1 do
            frm_teamselect.clb_allies.Items.Add( lbox_chosen.Items[i] );
          frm_teamselect.showmodal;
          if ( frm_teamselect.ModalResult = mrOk ) then
            begin
              // felszabadítás elõtt elkérjük a kiválasztott csapattársak neveit
              alliedlist := frm_teamselect.alliedlist;
              frm_teamselect.Free;
              frm_newgame.ModalResult := mrOk;
            end;
        end
       else
        begin
          alliedlist := '';
          frm_newgame.ModalResult := mrOk;
        end;
    end
   else if ( rbtn_gauss.Checked ) then
    begin
      cfgSetGameMode(gmGaussElimination);
      frm_gausselect := Tfrm_gausselect.Create(self);
      frm_gausselect.cbox_gauss.Items.Add(ed_playername.Text);
      for i := 0 to lbox_chosen.Items.Count-1 do
        frm_gausselect.cbox_gauss.Items.Add( lbox_chosen.Items[i] );
      frm_gausselect.cbox_gauss.ItemIndex := 0;
      frm_gausselect.showmodal;
      if ( frm_gausselect.ModalResult = mrOk ) then
        begin
          alliedlist := frm_gausselect.cbox_gauss.Text;
          frm_gausselect.Free;
          frm_newgame.ModalResult := mrOk;
        end;
    end
   else
    begin
      cfgSetGameMode(gmDeathMatch);
      frm_newgame.ModalResult := mrOk;
    end;
  if ( rbtn_time.Checked ) then
    begin
      cfgSetGameGoal(ggTimeLimit);
      cfgSetGameGoalValue(sped_timelimit.Value);
    end
   else if ( rbtn_frag.Checked ) then
    begin
      cfgSetGameGoal(ggFragLimit);
      cfgSetGameGoalValue(sped_fraglimit.Value);
    end
   else
    begin
      cfgSetGameGoal(ggTillTheEndOfTime);
    end;
end;

procedure Tfrm_newgame.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case key of
    VK_ESCAPE: close;
    VK_RETURN: spbtn_playclick(sender);
  end;
end;

procedure Tfrm_newgame.lbox_mapsDblClick(Sender: TObject);
begin
  if ( lbox_maps.ItemIndex > -1 ) then spbtn_playclick(sender);
end;

procedure Tfrm_newgame.lbox_selectableDblClick(Sender: TObject);
begin
  if ( lbox_selectable.Itemindex > -1 ) then spbtn_copytoleft.Click;
end;

procedure Tfrm_newgame.lbox_chosenDblClick(Sender: TObject);
begin
  if ( lbox_chosen.ItemIndex > -1 ) then spbtn_copytoright.Click;
end;

procedure Tfrm_newgame.FormShow(Sender: TObject);
begin
  while ( showcursor(TRUE) < 0 ) do ;
end;

end.
