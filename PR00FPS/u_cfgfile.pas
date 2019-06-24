unit u_cfgfile;

interface

uses
  windows, sysutils, dialogs;

type
  TGameMode = (gmDeathMatch,gmTeamDeathMatch,gmGaussElimination);
  TGameGoal = (ggTimeLimit,ggFragLimit,ggTillTheEndOfTime);
  PCfgData = ^TCfgData;
  TCfgData = record
               game_firstrun: boolean;  // elõször indul-e a játék az adott gépen
               reserved1: byte;  // mutassa-e az FPS-t
               reserved2: byte;  // füst mértéke rakétánál
               game_name: string[20];  // játékos neve
               game_autoswitchwpn: boolean;  // automatikus fegyverváltás
               game_showxhair: boolean;  // célkereszt megjelenítése
               game_showhud: boolean;  // HUD megjelenítése
               game_hudisblue: boolean;  // kék színû-e a HUD
               game_showblood: boolean;  // vér megjelenítése
               game_ODDinteract: boolean;  // optikai meghajtó interaktivitása
               game_keybdLEDsinteract: boolean;  // bazooka automatikus újratöltése
               game_screensaveroff: boolean;  // játék közben képernyõkímélõ tiltása
               game_monitorpowersave: boolean;  // játék közben mehet-e monitor zöld-módba
               game_stealthmode: boolean;  // bekapcsolható-e a lopakodó mód
               input_mousesens: byte;  // egér érzékenysége
               input_mousereverse: boolean;  // függõegesen fordított egérmozgás
               audio_sfx: boolean;  // hangeffektek
               audio_sfxvol: byte;  // hangeffektek erõssége
               audio_music: boolean;  // zene (N/A)
               audio_musicvol: byte;  // zene erõssége (N/A)
               video_lastvideocard: string[128];  // legutóbbi videokártya neve
               video_gamma: shortint;  // gamma-korrekció
               video_renderq: byte;  // megjelenítés minõsége
               video_debug: boolean;  // graf. motor debug ablaka
               video_res_w: word;  // felbontás vízszintesen
               video_res_h: word;  // felbontás függõlegesen
               video_colordepth: byte;  // színmélység
               video_fullscreen: boolean;  // teljes képernyõ
               video_refreshrate: byte;  // frissítési frekvencia
               video_vsync: boolean;  // vertikális szinkronizáció
               video_zbuffer16bit: boolean;  // 16 bites zbuffer
               video_shading_smooth: boolean;  // GL_SMOOTH árnyalási mód
               video_mipmaps: boolean;  // mipmap-ek generálása
               video_filtering: byte;  // textúraszûrés
               video_simpleitems: boolean;  // mutassa-e a skyboxot
               video_marksonwalls: boolean;  // lövedéknyomok
               video_motionblur: byte;   // motion blur
               video_lightmaps: boolean;   // fénytérképek
             end;

function cfgFileExists(): boolean;
function cfgLoaded(): boolean;
function cfgGetPointerToBuffer(): PCfgData;
procedure cfgAllocBuffer;
procedure cfgReadIntoBuffer;
procedure cfgWriteFromBuffer;
procedure cfgFlushBuffer;
function cfgGetGameMode(): TGameMode;
procedure cfgSetGameMode(gm: TGameMode);
function cfgGetGameGoal(): TGameGoal;
procedure cfgSetGameGoal(gg: TGameGoal);
function cfgGetGameGoalValue(): integer;
procedure cfgSetGameGoalValue(ggvalue: integer);

implementation

const
  CONST_CFG_FILENAME = 'settings.dat';

var
  cfgdata: pcfgdata = nil;
  gamemode: TGameMode;
  gamegoal: TGameGoal;
  gamegoalvalue: integer;


function cfgFileExists(): boolean;
begin
  result := fileExists(CONST_CFG_FILENAME);
end;

function cfgLoaded(): boolean;
begin
  result := assigned(cfgdata);
end;

function cfgGetPointerToBuffer(): PCfgData;
begin
  result := cfgdata;
end;

procedure cfgAllocBuffer;
begin
  if ( not(assigned(cfgdata)) ) then
    begin
      new(cfgdata);
      zeromemory(cfgdata,sizeof(tcfgdata));
    end;
end;

procedure cfgReadIntoBuffer;
var
  filehandle: cardinal;
  bytesread: cardinal;
begin
  if ( not(assigned(cfgdata)) ) then
    begin
      new(cfgdata);
      zeromemory(cfgdata,sizeof(tcfgdata));
    end;
  if ( cfgFileExists() ) then
    begin
      filehandle := createfile(CONST_CFG_FILENAME,GENERIC_READ,0,nil,
                               OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
      readfile(filehandle,cfgdata^,sizeof(TCfgData),bytesread,nil);
      closehandle(filehandle);
    end
   else cfgdata^.game_firstrun := TRUE;
end;

procedure cfgWriteFromBuffer;
var
  filehandle: cardinal;
  byteswritten: cardinal;
begin
  if ( assigned(cfgdata) ) then
    begin
      filehandle := createfile(CONST_CFG_FILENAME,GENERIC_WRITE,0,nil,
                               CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0);
      writefile(filehandle,cfgdata^,sizeof(TCfgData),byteswritten,nil);
      closehandle(filehandle);
    end;
end;

procedure cfgFlushBuffer;
begin
  if ( assigned(cfgdata) ) then dispose(cfgdata);
end;

function cfgGetGameMode(): TGameMode;
begin
  result := gamemode;
end;

procedure cfgSetGameMode(gm: TGameMode);
begin
  gamemode := gm;
end;

function cfgGetGameGoal(): TGameGoal;
begin
  result := gamegoal;
end;

procedure cfgSetGameGoal(gg: TGameGoal);
begin
  gamegoal := gg;
end;

function cfgGetGameGoalValue(): integer;
begin
  result := gamegoalvalue;
end;

procedure cfgSetGameGoalValue(ggvalue: integer);
begin
  gamegoalvalue := ggvalue;
end;

end.
