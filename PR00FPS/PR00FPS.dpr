{
        PR00FPS 1.0
        Készítette: Szabó Ádám aka PR00F
        E-mail & MSN: proof88@freemail.hu
}

{

}

program PR00FPS;

uses
  Classes,
  Windows,
  Controls,
  Sysutils,
  Forms,
  Dialogs,
  Graphics,
  CheckLst,
  MMSystem,
  FMOD,
  FMODtypes,
  FMODerrors,
  GfxCore,
  U_consts in 'u_consts.pas',
  U_cfgfile in 'u_cfgfile.pas',
  U_input in 'u_input.pas',
  U_map in 'u_map.pas',
  U_collision in 'u_collision.pas',
  U_bots in 'u_bots.pas',
  u_minimath in 'u_minimath.pas',
  U_frm_warning in 'u_frm_warning.pas' {frm_warning},
  U_frm_firstrun in 'u_frm_firstrun.pas' {frm_firstrun},
  U_frm_newhardware in 'u_frm_newhardware.pas' {frm_newhardware},
  U_frm_menu in 'u_frm_menu.pas' {frm_menu},
  U_frm_newgame in 'u_frm_newgame.pas' {frm_newgame},
  U_frm_playermatdebug in 'u_frm_playermatdebug.pas' {frm_playermatdebug},
  U_frm_showmapinfo in 'u_frm_showmapinfo.pas' {frm_showmapinfo},
  U_frm_settings in 'u_frm_settings.pas' {frm_settings},
  U_frm_controllerpic in 'u_frm_controllerpic.pas' {frm_controllerpic},
  U_frm_gfxsettings in 'u_frm_gfxsettings.pas' {frm_gfxsettings},
  U_frm_about in 'u_frm_about.pas' {frm_about},
  U_frm_teamselect in 'u_frm_teamselect.pas' {frm_teamselect},
  U_frm_gausselect in 'u_frm_gausselect.pas' {frm_gausselect},
  u_frm_botmanager in 'u_frm_botmanager.pas' {frm_botmanager},
  u_frm_botmanager_wait in 'u_frm_botmanager_wait.pas' {frm_botmanager_wait};

type
  TGameWindow = record                   // játék ablak tulajdonságai
                  wc: WNDCLASS;            // window class
                  dwStyle: DWORD;          // createwindowex()-hez
                  dwStyleEx: DWORD;        // createwindowex()-hez
                  hwindow: HWND;           // window handle
                  hdevctx: HDC;            // device context
                  hrenctx: HGLRC;          // rendering context
                  wndmsg: MSG;             // window message
                  active: boolean;         // aktív-e a window
                  cdepth: integer;         // colordepth
                  clientsize: TPoint;      // kliens mérete
                  wndrect: trect;          // ablak rectje
                end;
  PSmoke = ^TSmoke;                      // füst mutató
  TSmoke = record                        // füst
             objnum: integer;              // objektum sorszáma
             scaling: single;              // átméretezési arány
             takingoff: boolean;           // felszáll-e
             colorkey: TRGBA;              // blendinghez colorkey
           end;
  PXplosion = ^TXplosion;                // robbanás mutató
  TXplosion = record                     // robbanás
                objnum: integer;           // objektum sorszáma
                secondary: boolean;        // másodlagos-e?
                owner: integer;            // ki okozta
              end;
  PMark = ^TMark;                        // lövedéknyom mutató
  TMark = record                           // lövedéknyom
            objnum: integer;               // objektum sorszáma
            createtime: cardinal;          // mikor hoztuk létre
            repositioning: boolean;        // kell-e finomítani a pozícióján
            repax,repay: single;           // merre néz
          end;
  PBullet = ^TBullet;                    // lövedék mutató
  TBullet = record                       // lövedék
              opos,pos: TXYZ;              // elõzõ és aktuális pozíció
              ax,ay,az: single;            // forgásszögek
              ownerplayer: integer;        // tulajdonos
              ownerwpn: integer;           // milyen fegyverbõl származik
              objnum: integer;             // objektum sorszáma
              speed: single;               // sebesség
              sizex,sizey,sizez: single;   // méretek
              movecount: integer;          // mennyit léptettük elõre
              routelength: single;         // megtett út
            end;
  TWpnBulletInfo = record                // fegyverenként lövedék info
                     total,act,actmaxtotal: integer;
                     // összes, aktuális, max. mennyi lehet egyszerre a tárban
                   end;
  TWpnsInfo = record  // játékos fegyver-információi
                bulletsinfo: array[1..GAME_WPN_MAX] of TWpnBulletInfo;    // fegyverek adatai
                currentwpn: integer;                                      // aktuális fegyver
                currentwpnobjnum,currentwpnmuzzleobjnum: integer;         // aktuális fegyver objektumai
                newwpn: integer;                                          // új fegyver, amire átváltunk
                prevwpn: integer;                                         // elõzõ fegyver, amit elteszünk
                gettingout,takingaway: boolean;                           // elõveszek vagy elrakok fegyvert
                wpnchangebias_angz: single;                               // fegyver mozgásához szükséges változók
                wpnshotbias_angy,wpnshotbias_angy_max,wpnshotbias_angz: single;
                wpn_ypos_bias: single;
                wpnacc: integer;
                wpnreloadbias_angz,reloadzangle,reloadzanglechangespeed,reloadzanglechangespeedafter: single;
                shotzangle,shotzanglechangespeed,shotzanglechangespeedafter,shotyanglechangespeedafter: single;
                reloading,shooting: boolean;                              // újratöltök vagy lövök
                lastshot: cardinal;                                       // utolsó lövés ideje
                numbulletstoreload: integer;                              // mennyi lövedéket töltünk be
                lastbulletload: cardinal;                                 // mikor töltöttünk újra utoljára
              end;
  TPlayer = record                                       // játékos
              gravity: single;                             // gravitáció
              jmp: single;                                 // ugrás mértéke
              jumping: boolean;                            // ugrik-e
              frags,deaths: integer;                       // fragek, halálok száma
              injurycausedbyfalling: single;               // esés általi sérülés mértéke
              cam_yi: integer;                             // kamera rázáshoz
              cam_yai: integer;
              cam_ys: single;
              cam_yas: single;
              hasteleport: boolean;                        // van-e teleportja
              hasquaddamage: boolean;                      // 4x-es sebzése
              lastqmd: cardinal;                           // mikor vettük fel a 4xes sebzést
              qdmgrot: single;                             // 4x-es sebzés forgásához kell
              timetorevive: cardinal;                      // mikor halt meg utoljára
              health,shield: integer;                      // életerõ, pajzs
              teamnum: integer;                            // csapat sorszáma
              zoomplus: single;                            // zoomolás mértéke
              wpnsinfo: TWpnsInfo;                         // fegyvereinek adatai
              px,py,pz,opx,opy,opz: single;                // aktuális és elõzõ pozíciók
              death_yminus: single;                        // halálkor ennyivel alacsonyabb a kamera
              impulsepx,impulsepy,impulsepz: single;       // impulzus
              oimpulsepx,oimpulsepy,oimpulsepz: single;    // elõzõ impulzus
            end;
  TRGBAfloat = record              // lebegõpontos RGBA
                 red: single;
                 green: single;
                 blue: single;
                 alpha: single;
               end;
  PItemText = ^TItemText;              // item szöveg mutató
  TItemText = record                   // item szöveg
                txt: tstr255;            // szöveg
                timetaken: cardinal;     // mikor vettük fel
                color: TRGBAfloat;       // színe
              end;
  TItemsText = array[1..GAME_MAX_ITEMS_TEXT] of PItemText; // item szövegek tömbje
  TMajorText = TItemText;                                  // teleport szöveg
  PEventText = ^TEventText;                                // esemény mutató
  TEventText = record                                      // esemény
                 txt1,txt2,txt3: TItemText;
               end;
  TEventsTexts = array[1..GAME_MAX_ITEMS_TEXT] of PEventText;  // események tömbje
  TRocketLauncher = class(TThread)
  public
    procedure Execute; override;
  end;



var
  gamewindow: TGameWindow;                 // a játék ablak (WinAPI)
  settings: pcfgdata;                      // beállításokra mutató mutató
  shading: TGLConst;                       // tmcsInitGraphix()-nek átadott árnyalási mód
  zbufferbits: integer;                    // tmcsInitGraphix()-nek átadott Z-Buffer mélység
  tmcsstatus: byte;                        // tmcsInitGraphix() visszatérési értéke
  ddev: tdisplaydevice;                    // videokártya nevének megállapításához kell (WinAPI)
  spacehack: boolean;                      // bunny hopping ellen
  escapestop,tabulatorstop: boolean;
  upstop,downstop: boolean;                // menüben fel-le mozgáshoz kell, h jó legyen a navigálás
  mouseleftstop: boolean;
  mousemoved: boolean;
  rhack: boolean;
  ocur: tpoint;                            // egérkurzor akt. pozíciója
  mx,my,mmx,mmy: integer;                  // egérkurzor új pozíciója, elmozdulása
  mouselastmoved: cardinal;                // egérkurzor utolsó elmozdulásának ideje menüben
  newmap,settingchanged: boolean;          // newmap igaz, ha játék közben új mapra lépünk,
                                              // settingchanged igaz, ha játék közben újraindítást igényló beállítást változtattunk
  restarting: boolean;                     // újraindítjuk-e a játékot
  almafa: boolean;
  botslist: string;                        // ide "lopjuk" el a kiválasztott botok listáját
  alliedlist: string;                      // kiválasztott csapattársak nevei vagy maga Gauss XD
  gamestarted: cardinal;                   // mikor kezdtük el a játékot (akkor kell, ha idõlimit van beáálítva)
  soundsysinited: boolean;
  mutex: thandle;
  tmphwindow: HWND;
  mainloop: boolean;
  cdopened: boolean;
  cdthread: TRocketLauncher;
  gameended: cardinal;

// egérkurzor pozícionálása
procedure mouseToWndCenter;
begin
  mx := gamewindow.wndrect.Left + ((gamewindow.wndrect.Right-gamewindow.wndrect.Left) div 2);
  my := gamewindow.wndrect.top + ((gamewindow.wndrect.bottom-gamewindow.wndrect.top) div 2);
  setcursorpos(mx,my);
end;

// a játék ablak üzenetkezelése
function WndProc(hwindow: HWND; wndmsg: uint; wp: wparam; lp: lparam): lresult; stdcall;
var
  mwheel: smallint;
begin
  if ( wndmsg = WM_SYSCOMMAND ) then
    if ( (wp = SC_SCREENSAVE) and (settings^.game_screensaveroff) ) then
      begin
        result := 0;
        exit;
      end
     else if ( (wp = SC_MONITORPOWER) and not(settings^.game_monitorpowersave) ) then
       begin
         result := 0;
         exit;
       end;
  case wndmsg of
    WM_ACTIVATE: begin
                   gamewindow.active := loword(wp) in [WA_ACTIVE,WA_CLICKACTIVE];
                   if ( gamewindow.active ) then
                     begin
                       if ( mainloop) then tmcsrestoredisplaymode();
                       mouseToWndCenter;
                     end;
                   result := 0;
                 end;
    WM_CLOSE: begin
                PostQuitMessage(0);
                result := 0;
              end;
    WM_KEYDOWN: begin
                  inputSetKeyPressed(wp);
                  result := 0;
                end;
    WM_KEYUP: begin
                inputSetKeyReleased(wp);
                result := 0;
              end;
    WM_MOUSEMOVE: begin
                    mousemoved := TRUE;
                    result := 0;
                  end;
    WM_MOUSEWHEEL: begin
                     // a hiword fv. word típusú, tehát CSAK
                     // pozitív értékkel térhet vissza, de a wp
                     // felsõ 2 byte-ján elõjeles szám van eltárolva...
                     // A magunk felé görgetés esetén negatív értéke van,
                     // word visszatérési érték miatt túlcsordul.
                     // Ezért ideiglenesen kikapcsoljuk a range checkinget.
                     // végleges változatban nincs range checking
                     mwheel := hiword(wp);
                     inputMouseWheelRotation(mwheel);
                     result := 0;
                   end;
    WM_LBUTTONDOWN: begin
                      inputSetMouseButtonPressed(MBTN_LEFT);
                      result := 0;
                    end;
    WM_LBUTTONUP: begin
                    inputSetMouseButtonReleased(MBTN_LEFT);
                    result := 0;
                  end;
    WM_MBUTTONDOWN: begin
                      inputSetMouseButtonPressed(MBTN_MIDDLE);
                      result := 0;
                    end;
    WM_MBUTTONUP: begin
                    inputSetMouseButtonReleased(MBTN_MIDDLE);
                    result := 0;
                  end;
    WM_RBUTTONDOWN: begin
                      inputSetMouseButtonPressed(MBTN_RIGHT);
                      result := 0;
                    end;
    WM_RBUTTONUP: begin
                    inputSetMouseButtonReleased(MBTN_RIGHT);
                    result := 0;
                  end;
    WM_WINDOWPOSCHANGED: begin
                           getwindowrect(gamewindow.hwindow,gamewindow.wndrect);
                           result := 0;
                         end;
   else result := DefWindowProc(hwindow, wndmsg, wp, lp);
  end;
end;

function WinMain(hInstance: HINST; hPrevInstance: HINST; lpCmdLine: PChar; nCmdShow: integer): integer; stdcall;
var
  windmsg: TMsg;                                        // lekérdezett window message
  done: boolean;                                        // a játék fõciklusának elhagyása, ha TRUE
  inmenu: boolean;                                      // menüben vagyunk-e
  inmenu_keybdcur: boolean;                             // a billentyûleütés változtatta-e meg az egérkurzor pozícióját
  fps_ms,fps_ms2,fps_ms3,fps_ms_old: integer;           // fps méréséhez kell
  fps,fps_old: integer;                                 // detto
  firstframe: boolean;                                  // igaz, ha még nem történt meg az elsõ FPS-mérés
  obj_mapsample,tex_mapsample: integer;                 // töltõképernyõ sík és textúra
  mapname: string;                                      // map neve
  obj_map: integer;                                     // map
  obj_skybox: integer;                                  // skybox
  player: tplayer;                                      // játékos adatai
  obj_menubg,tex_menubg: integer;                       // menü háttér sík és textúra
  obj_menutitle,tex_menutitle: integer;                 // menü cím sík és textúra
  obj_menubtns_up: array[1..GAME_INGAME_MENU_BTNCOUNT] of integer;    // menü gombjai
  tex_menubtns_up: array[1..GAME_INGAME_MENU_BTNCOUNT] of integer;    // "mouseUp" gomb textúrák
  tex_menubtns_over: array[1..GAME_INGAME_MENU_BTNCOUNT] of integer;  // "mouseOver" gomb textúrák
  menubtn_px,menubtn_py: integer;
  menu_x1_bias,menu_x2_bias: integer;
  menuscalex,menuscaley: single;
  menuact: byte;
  mblurcolor: TRGBAfloat;                               // motion blur színe
  obj_framebuffer,tex_framebuffer: integer;             // menübe lépéskor ide lopom el a képet
  obj_hudbottom,tex_hudbottom: integer;                 // HUD alsó kék háttere
  obj_hudhealthicon,obj_hudshieldicon,tex_hudhealthicon,tex_hudshieldicon: integer; // HUD élet és pajzs ikonjai
  tex_hud_nums,tex_hud_bignums: array[0..9] of integer; // HUD kis és nagyobb méretû szûm textúrái
  obj_hud_health_nums,obj_hud_shield_nums: array[0..2] of integer;  // életet és pajzsot mutató síkok
  healthisred: boolean;                                 // életerõ piros villogásához kell
  healthlasttime: cardinal;                             // utolsó színváltása az életerõ piros villogásának
  obj_hud_wpn_nums: array[0..1] of integer;             // pisztoly és gépfegyver töltényeit mutató síkok
  obj_hud_wpn_rocketl_nums: array[0..2] of integer;     // rakétavetõben lévõ és tartalék rakétákat mutató síkok
  obj_hud_wpn_rocketl_slash,tex_hud_wpn_rocketl_slash: integer;  // rakétavetõnél a per jel
  obj_hud_wpn_current: integer;                         // aktuális fegyver kis képét mutató sík
  tex_hud_wpns: array[0..2] of integer;                 // a 3 fegyver 3 kis képe
  obj_hudtport,tex_hudtport: integer;                   // teleportot jelzõ sík és textúra
  obj_hudtport2: integer;                               // másik sík, azért, hogy erõsebb legyen a teleport színe
  hudvisible: boolean;
  obj_qdmg,tex_qdmg: integer;                     // 4x-es sebzés
  obj_fps: array[0..1] of integer;                      // FPS-t mutató 2 sík
  obj_xhair,tex_xhair: integer;                         // célkereszt
  xhairscale: single;                                   // célkereszt nyújtása
  obj_junk1: integer;                                   // ideiglenes azonosító (pl. fegyverek lightmappelt objektumainak töltésénél)
  obj_wpn_pistol,obj_wpn_mchgun,obj_wpn_mchgunlcd1,
  obj_wpn_mchgunlcd2,obj_wpn_mchgunlcdwarning,obj_wpn_rocketlauncher: integer;  // fegyverek
  tex_wpn_mchgun_lcdnums: array[0..9] of integer;       // gépfegyver LCD kijelzõjéhez számok
  obj_wpn_mchgun_lcdnums_alpha: integer;                // gépfegyver LCD kijelzõjén a számok átlátszósága
  obj_wpn_mchgun_lcdnums_alpha_inc: boolean;            // gépfegyver LCD kijelzõjén épp növekszik-e a számok átlátszósága
  obj_wpn_pistolmuzzle,obj_wpn_mchgunmuzzle,obj_wpn_rocketlaunchermuzzle: integer; // fegyverek torkolattüze
  obj_start_upper,tex_start_upper,obj_start_lower,tex_start_lower: integer;  // betöltés után két szétnyíló kép
  obj_fragtable,tex_fragtable: integer;
  obj_highlighter: integer;
  obj_bullet_pistol,obj_bullet_mchgun,obj_bullet_rocketl: integer;
  obj_xplosion: integer;
  obj_bloodplane: integer;
  bloodplanecolor: TRGBAfloat;
  bullets: tlist;                                       // levegõben repülõ lövedékek listája
  bullet: PBullet;                                      // egy lövedékre mutató pointer
  tex_mark: integer;                                    // lövedéknyom textúra
  marks: tlist;                                         // lövedéknyomok listája
  mark: pmark;                                          // egy lövedéknyomra mutató pointer
  xplosions: tlist;                                     // robbanások listája
  xplosion: PXplosion;                                  // egy robbanásra mutató pointer
  tex_smoke: integer;
  smokes: tlist;
  smoke: psmoke;
  lastsmoke: integer;
  itemstexts: TItemsText;
  itemstexts_h: byte;
  itemstext: pitemtext;
  eventstexts: TEventsTexts;
  eventstexts_h: byte;
  eventstext: PEventText;
  startpic_takeaway: boolean;                           // ha igaz, akkor épp távolodik betöltés után a két kép
  majortext: TMajorText;
  i,j,k,tn: integer;
  l: boolean;
  vmi: integer;
  ggg,jjj: single;
  cd: boolean;
  endgame: boolean;
  snd_pistol,snd_pistolammo,snd_mchgun,snd_mchgunammo,
  snd_rocketl,snd_rocketammo,snd_xplosion,snd_xplosion2,
  snd_change,snd_noammo,snd_health,snd_healthrespawn,snd_shield,
  snd_teleport,snd_quaddamage,snd_fall,snd_useteleport,
  snd_jump,snd_land,snd_step1,snd_step2,snd_death1,
  snd_death2,snd_dmg_quad,snd_dmg1,snd_mchgunlowammo,
  snd_dmg2,snd_dmg3,snd_splat,snd_rocketreload: PFSOUNDSample;
  snd_btnpress,snd_btnover: PFSOUNDSample;
  sndchn: integer;
  snd_pos: TFSOUNDVECTOR;
  lastrun: cardinal;
  leftleg: boolean;
  trans_x,trans_z: single;


// visszaadja adott számnál nagyobb és legközelebbi 2 hatványát,
// motion blur textúra méretének meghatározásához kell
function getNearestPowerOf2(num: integer): integer;
var
  tmp: integer;
begin
  tmp := 2;
  while ( tmp < num ) do
    tmp := tmp * 2;
  result := tmp;
end;

// adott stringben adott string elõfordulásainak számát adja meg
function numStrFound(miben, mit: string): integer;
var
  ind, s: integer;
begin
  s := 0;
  ind := 1;
  while ( ind > 0 ) do
    begin
      ind := pos(mit,miben);
      if ( ind > -1 ) then
        begin
          s := s + 1;
          miben := copy(miben,ind+length(mit)+1,length(miben));
        end;
    end;
  result := s-1;
end;

// több soros stringbõl kiveszi az adott sorban szereplõ nevet
function extractNameFromLines(s: string; i: integer): string;
var
  a: tstringlist;
begin
  a := tstringlist.Create;
  a.Text := s;
  result := copy(a.Strings[i-1],1,pos('(',a.Strings[i-1])-1);
  a.Free;
end;

{
 _____ ____  ____                          _
|  ___|  _ \/ ___|    ___ ___  _   _ _ __ | |_ ___ _ __
| |_  | |_) \___ \   / __/ _ \| | | | '_ \| __/ _ \ '__|
|  _| |  __/ ___) | | (_| (_) | |_| | | | | ||  __/ |   
|_|   |_|   |____/   \___\___/ \__,_|_| |_|\__\___|_|

}
procedure BuildFPScounter;
var
  i: integer;
begin
  for i := 0 to 1 do
    begin
      obj_fps[i] := tmcsCreatePlane(gamewindow.clientsize.X*0.04,gamewindow.clientsize.Y*0.05);
      tmcssetobjectstickedstate(obj_fps[i],TRUE);
      tmcssetobjectlit(obj_fps[i],FALSE);
      tmcssetobjectblending(obj_fps[i],TRUE);
      tmcssetobjectblendmode(obj_fps[i],gl_one,gl_one);
      tmcssetxpos(obj_fps[i],gamewindow.clientsize.X/2 - gamewindow.clientsize.X/10 + i*tmcsgetsizex(obj_fps[i]));
      tmcssetypos(obj_fps[i],gamewindow.clientsize.Y/2 - gamewindow.clientsize.Y/14);
    end;
end;

procedure FPScounter;
begin
  if ( fps > 99 ) then
    begin
      tmcstextureobject(obj_fps[0],tex_hud_nums[ 9 ]);
      tmcstextureobject(obj_fps[1],tex_hud_nums[ 9 ]);
    end
   else
    begin
      tmcstextureobject(obj_fps[0],tex_hud_nums[ fps div 10 ]);
      tmcstextureobject(obj_fps[1],tex_hud_nums[ fps mod 10 ]);
    end;
end;

procedure ShowFPScounter;
var
  i: integer;
begin
  if ( not(DEBUG_WALKTHROUGH) ) then
    begin
      for i := 0 to 1 do
        tmcsshowobject(obj_fps[i]);
    end;
end;

procedure HideFPScounter;
var
  i: integer;
begin
  for i := 0 to 1 do
    tmcshideobject(obj_fps[i]);
end;

{
__  ___   _       _
\ \/ / | | | __ _(_)_ __
 \  /| |_| |/ _` | | '__|
 /  \|  _  | (_| | | |
/_/\_\_| |_|\__,_|_|_|

}
procedure BuildXHair;
begin
  tex_xhair := tmcscreatetexturefromfile(GAME_PATH_HUD+'hud_xhair.bmp',FALSE,FALSE,TRUE,GL_LINEAR,GL_DECAL,
                                             GL_CLAMP,GL_CLAMP);
  obj_xhair := tmcsCreatePlane(gamewindow.clientsize.X*GAME_XHAIR_WIDTH,gamewindow.clientsize.Y*GAME_XHAIR_HEIGHT);
  tmcssetobjectstickedstate(obj_xhair,TRUE);
  tmcsadjustuvcoords(obj_xhair,0.02);
  tmcstextureobject(obj_xhair,tex_xhair);
  tmcssetobjectlit(obj_xhair,FALSE);
  tmcssetobjectblending(obj_xhair,TRUE);
  tmcssetobjectblendmode(obj_xhair,gl_src_alpha,gl_one);
  tmcscompileobject(obj_xhair);
end;

procedure ShowXHair;
begin
  if ( not(DEBUG_WALKTHROUGH) ) then tmcsshowobject(obj_xhair);
end;

procedure HideXHair;
begin
  tmcsHideobject(obj_xhair);
end;

procedure XHair;
var
  old_xhairscale: single;
begin
  old_xhairscale := (abs(player.opx-player.px)+abs(player.opy-player.py)+abs(player.opz-player.pz)+abs(mmx)/250+abs(mmy)/250+abs(player.wpnsinfo.wpnshotbias_angz)+1)*100;
  if ( (xhairscale < 100) or (xhairscale > GAME_XHAIR_MAX_SCALING) ) then xhairscale := 100;
  if ( old_xhairscale < xhairscale ) then xhairscale := xhairscale - GAME_XHAIR_DOWNSCALE_SPEED/fps
    else if ( old_xhairscale > xhairscale ) then xhairscale := xhairscale + GAME_XHAIR_UPSCALE_SPEED/fps;
  if ( xhairscale > GAME_XHAIR_MAX_SCALING ) then xhairscale := GAME_XHAIR_MAX_SCALING;
  tmcsScaleObjectAbsolute(obj_xhair,round(xhairscale));
  tmcsSetObjectColorkey(obj_xhair,
                        255,
                        GAME_XHAIR_MAX_SCALING+round(255-(xhairscale/GAME_XHAIR_MAX_SCALING)*255),
                        GAME_XHAIR_MAX_SCALING+round(255-(xhairscale/GAME_XHAIR_MAX_SCALING)*255),
                        GAME_XHAIR_MAX_SCALING+round(255-(xhairscale/GAME_XHAIR_MAX_SCALING)*255));
end;

{
 _   _ _   _ ____
| | | | | | |  _ \
| |_| | | | | | | |
|  _  | |_| | |_| |
|_| |_|\___/|____/

}
procedure BuildHUD;
var
  colorchar: char;
  i: integer;
begin
  if ( settings^.game_hudisblue ) then colorchar := 'b' else colorchar := 'm';

  // HUD alsó része
  obj_hudbottom := tmcsCreatePlane(gamewindow.clientsize.X,gamewindow.clientsize.Y*0.17);
  tmcssetobjectstickedstate(obj_hudbottom,TRUE);
  tex_hudbottom := tmcscreatetexturefromfile(GAME_PATH_HUD+'hud_bottom_'+colorchar+'.bmp',FALSE,FALSE,TRUE,GL_LINEAR,GL_DECAL,
                                             GL_CLAMP,GL_CLAMP);
  tmcsadjustuvcoords(obj_hudbottom,0.02);
  tmcstextureobject(obj_hudbottom,tex_hudbottom);
  tmcssetobjectlit(obj_hudbottom,FALSE);
  tmcssetobjectblending(obj_hudbottom,TRUE);
  tmcssetobjectblendmode(obj_hudbottom,GL_src_alpha_saturate,GL_src_color);
  tmcssetypos(obj_hudbottom,-gamewindow.clientsize.Y/2+tmcsgetsizey(obj_hudbottom)/2);
  tmcscompileobject(obj_hudbottom);

  // HUD élet ikonja
  obj_hudhealthicon := tmcsCreatePlane(gamewindow.clientsize.X*0.05,gamewindow.clientsize.Y*0.06);
  tmcssetobjectstickedstate(obj_hudhealthicon,TRUE);
  tex_hudhealthicon := tmcscreatetexturefromfile(GAME_PATH_HUD+'hud_health.bmp',FALSE,FALSE,FALSE,GL_LINEAR,GL_DECAL,
                                             GL_CLAMP,GL_CLAMP);
  tmcsadjustuvcoords(obj_hudhealthicon,0.02);
  tmcstextureobject(obj_hudhealthicon,tex_hudhealthicon);
  tmcssetobjectlit(obj_hudhealthicon,FALSE);
  tmcssetobjectblending(obj_hudhealthicon,TRUE);
  tmcssetobjectblendmode(obj_hudhealthicon,gl_one,gl_one);
  tmcssetxpos(obj_hudhealthicon,-gamewindow.clientsize.X/2+gamewindow.clientsize.X/32);
  tmcssetypos(obj_hudhealthicon,-gamewindow.clientsize.Y/2+tmcsgetsizey(obj_hudbottom)-tmcsgetsizey(obj_hudhealthicon)-gamewindow.clientsize.Y/96);
  tmcscompileobject(obj_hudhealthicon);

  // HUD pajzs ikonja
  obj_hudshieldicon := tmcsCreatePlane(gamewindow.clientsize.X*0.05,gamewindow.clientsize.Y*0.06);
  tmcssetobjectstickedstate(obj_hudshieldicon,TRUE);
  tex_hudshieldicon := tmcscreatetexturefromfile(GAME_PATH_HUD+'hud_shield.bmp',FALSE,FALSE,FALSE,GL_LINEAR,GL_DECAL,
                                             GL_CLAMP,GL_CLAMP);
  tmcsadjustuvcoords(obj_hudshieldicon,0.02);
  tmcstextureobject(obj_hudshieldicon,tex_hudshieldicon);
  tmcssetobjectlit(obj_hudshieldicon,FALSE);
  tmcssetobjectblending(obj_hudshieldicon,TRUE);
  tmcssetobjectblendmode(obj_hudshieldicon,gl_one,gl_one);
  tmcssetxpos(obj_hudshieldicon,-gamewindow.clientsize.X/2+gamewindow.clientsize.X/16);
  tmcssetypos(obj_hudshieldicon,-gamewindow.clientsize.Y/2+tmcsgetsizey(obj_hudshieldicon)/2 + gamewindow.clientsize.Y/96);
  tmcscompileobject(obj_hudshieldicon);

  // teleportot jelzõ ikon
  obj_hudtport := tmcsCreatePlane(gamewindow.clientsize.X*0.1,gamewindow.clientsize.Y*0.12);
  tmcssetobjectstickedstate(obj_hudtport,TRUE);
  tex_hudtport := tmcscreatetexturefromfile(GAME_PATH_HUD+'hud_tport_'+colorchar+'.bmp',FALSE,FALSE,TRUE,GL_LINEAR,GL_DECAL,
                                             GL_CLAMP,GL_CLAMP);
  tmcsadjustuvcoords(obj_hudtport,0.02);
  tmcstextureobject(obj_hudtport,tex_hudtport);
  tmcssetobjectlit(obj_hudtport,FALSE);
  tmcssetobjectblending(obj_hudtport,TRUE);
  tmcssetobjectblendmode(obj_hudtport,GL_src_alpha_saturate,GL_src_color);
  tmcssetxpos(obj_hudtport,-gamewindow.clientsize.X/2 + tmcsgetsizex(obj_hudtport)/2);
  tmcscompileobject(obj_hudtport);

  // teleportot jelzõ ikon2
  obj_hudtport2 := tmcsCreatePlane(gamewindow.clientsize.X*0.1,gamewindow.clientsize.y*0.12);
  tmcsadjustuvcoords(obj_hudtport2,0.02);
  tmcssetobjectstickedstate(obj_hudtport2,TRUE);
  tex_hudtport := tmcscreatetexturefromfile(GAME_PATH_HUD+'hud_tport2_'+colorchar+'.bmp',FALSE,FALSE,TRUE,GL_LINEAR,GL_DECAL,
                                             GL_CLAMP,GL_CLAMP);
  tmcstextureobject(obj_hudtport2,tex_hudtport);
  tmcssetobjectlit(obj_hudtport2,FALSE);
  tmcssetobjectblending(obj_hudtport2,TRUE);
  tmcssetobjectblendmode(obj_hudtport2,GL_one,GL_one);
  tmcssetxpos(obj_hudtport2,-gamewindow.clientsize.X/2 + tmcsgetsizex(obj_hudtport2)/2);
  tmcscompileobject(obj_hudtport2);
  tmcshideobject(obj_hudtport);
  tmcshideobject(obj_hudtport2);

  obj_qdmg := tmcsCreatePlane(gamewindow.clientsize.X,gamewindow.clientsize.Y);
  tmcssetobjectstickedstate(obj_qdmg,TRUE);
  tex_qdmg := tmcscreatetexturefromfile(GAME_PATH_HUD+'hud_qdmg.bmp',FALSE,FALSE,TRUE,GL_LINEAR,GL_DECAL,
                                        GL_CLAMP,GL_CLAMP);
  tmcstextureobject(obj_qdmg,tex_qdmg);
  tmcssetobjectlit(obj_qdmg,FALSE);
  tmcssetobjectblending(obj_qdmg,TRUE);
  tmcssetobjectblendmode(obj_qdmg,GL_one,GL_one);
  tmcscompileobject(obj_qdmg);
  tmcshideobject(obj_qdmg);

  // számok textúrái
  for i := 0 to 9 do
    begin
      tex_hud_nums[i] := tmcsCreateTextureFromFile(GAME_PATH_HUD+'hud_nums'+inttostr(i)+'.bmp',FALSE,FALSE,FALSE,GL_LINEAR,GL_DECAL,
                                                   GL_CLAMP,GL_CLAMP);
      tex_hud_bignums[i] := tmcsCreateTextureFromFile(GAME_PATH_HUD+'hud_nums_big'+inttostr(i)+'.bmp',FALSE,FALSE,FALSE,GL_LINEAR,GL_DECAL,
                                                   GL_CLAMP,GL_CLAMP);
    end;
  // életerõt kijelzõ számok
   for i := 0 to 2 do
    begin
      obj_hud_health_nums[i] := tmcsCreatePlane(gamewindow.clientsize.X*0.03,gamewindow.clientsize.Y*0.07);
      tmcssetobjectstickedstate(obj_hud_health_nums[i],TRUE);
      tmcssetobjectlit(obj_hud_health_nums[i],FALSE);
      tmcssetobjectblending(obj_hud_health_nums[i],TRUE);
      tmcssetobjectblendmode(obj_hud_health_nums[i],gl_one,gl_one);
      tmcssetxpos(obj_hud_health_nums[i],
                  tmcsgetxpos(obj_hudhealthicon)+tmcsgetsizex(obj_hudhealthicon)/2 + i*tmcsgetsizex(obj_hud_health_nums[i])
                  + gamewindow.clientsize.X/64);
      tmcssetypos(obj_hud_health_nums[i],tmcsgetypos(obj_hudhealthicon));
    end;

  // pajzsot kijelzõ számok
  for i := 0 to 2 do
    begin
      obj_hud_shield_nums[i] := tmcsCreatePlane(gamewindow.clientsize.X*0.03,gamewindow.clientsize.Y*0.07);
      tmcssetobjectstickedstate(obj_hud_shield_nums[i],TRUE);
      tmcssetobjectlit(obj_hud_shield_nums[i],FALSE);
      tmcssetobjectblending(obj_hud_shield_nums[i],TRUE);
      tmcssetobjectblendmode(obj_hud_shield_nums[i],gl_one,gl_one);
      tmcssetxpos(obj_hud_shield_nums[i],
                  tmcsgetxpos(obj_hudshieldicon)+tmcsgetsizex(obj_hudshieldicon)/2 + i*tmcsgetsizex(obj_hud_shield_nums[i])
                  + gamewindow.clientsize.X/64);
      tmcssetypos(obj_hud_shield_nums[i],tmcsgetypos(obj_hudshieldicon));
    end;

  // akutális fegyvert mutató sík
  obj_hud_wpn_current :=  tmcsCreatePlane(gamewindow.clientsize.X/6,gamewindow.clientsize.Y/9);
  tmcssetobjectstickedstate(obj_hud_wpn_current,TRUE);
  tmcssetobjectlit(obj_hud_wpn_current,FALSE);
  tmcssetobjectblending(obj_hud_wpn_current,TRUE);
  tmcssetobjectblendmode(obj_hud_wpn_current,gl_one,gl_one);
  tmcssetypos(obj_hud_wpn_current,-gamewindow.clientsize.Y/2 + gamewindow.clientsize.Y/14);

  // fegyvereket jelzõ textúrák
  tex_hud_wpns[0] := tmcsCreateTextureFromFile(GAME_PATH_HUD+'hud_wpn_pistol_'+colorchar+'.bmp',FALSE,FALSE,FALSE,GL_LINEAR,GL_DECAL,
                                                 GL_CLAMP,GL_CLAMP);
  tex_hud_wpns[1] := tmcsCreateTextureFromFile(GAME_PATH_HUD+'hud_wpn_mchgun_'+colorchar+'.bmp',FALSE,FALSE,FALSE,GL_LINEAR,GL_DECAL,
                                                 GL_CLAMP,GL_CLAMP);
  tex_hud_wpns[2] := tmcsCreateTextureFromFile(GAME_PATH_HUD+'hud_wpn_rocketl_'+colorchar+'.bmp',FALSE,FALSE,FALSE,GL_LINEAR,GL_DECAL,
                                                 GL_CLAMP,GL_CLAMP);

  // nálunk lévõ töltényt kijelzõ számok (csak pisztoly és gépfegyver)
  for i := 0 to 1 do
    begin
      obj_hud_wpn_nums[i] := tmcsCreatePlane(gamewindow.clientsize.X*0.07,gamewindow.clientsize.Y*0.115);
      tmcssetobjectstickedstate(obj_hud_wpn_nums[i],TRUE);
      tmcssetobjectlit(obj_hud_wpn_nums[i],FALSE);
      tmcssetobjectblending(obj_hud_wpn_nums[i],TRUE);
      tmcssetobjectblendmode(obj_hud_wpn_nums[i],gl_one,gl_one);
      tmcssetxpos(obj_hud_wpn_nums[i],
                  gamewindow.clientsize.X/2 - gamewindow.clientsize.X/8 + i*tmcsgetsizex(obj_hud_wpn_nums[i]));
      tmcssetypos(obj_hud_wpn_nums[i],-gamewindow.clientsize.Y/2 + gamewindow.clientsize.Y/15);
    end;

  // nálunk lévõ rakétákat kijelzõ számok
  // aktuális, rakétavetõben lévõ rakéták száma
  obj_hud_wpn_rocketl_nums[0] := tmcsCreatePlane(gamewindow.clientsize.X*0.06,gamewindow.clientsize.Y*0.09);
  tmcssetobjectstickedstate(obj_hud_wpn_rocketl_nums[0],TRUE);
  tmcssetobjectlit(obj_hud_wpn_rocketl_nums[0],FALSE);
  tmcssetobjectblending(obj_hud_wpn_rocketl_nums[0],TRUE);
  tmcssetobjectblendmode(obj_hud_wpn_rocketl_nums[0],gl_one,gl_one);
  tmcssetxpos(obj_hud_wpn_rocketl_nums[0], gamewindow.clientsize.X/2 - gamewindow.clientsize.X/8);
  tmcssetypos(obj_hud_wpn_rocketl_nums[0],-gamewindow.clientsize.Y/2 + gamewindow.clientsize.Y/15);
  // rakétavetõhöz való rakéták száma, amennyi még nálunk van
  for i := 1 to 2 do
    begin
      obj_hud_wpn_rocketl_nums[i] := tmcsCreatePlane(gamewindow.clientsize.X*0.04,gamewindow.clientsize.Y*0.06);
      tmcssetobjectstickedstate(obj_hud_wpn_rocketl_nums[i],TRUE);
      tmcssetobjectlit(obj_hud_wpn_rocketl_nums[i],FALSE);
      tmcssetobjectblending(obj_hud_wpn_rocketl_nums[i],TRUE);
      tmcssetobjectblendmode(obj_hud_wpn_rocketl_nums[i],gl_one,gl_one);
      tmcssetypos(obj_hud_wpn_rocketl_nums[i],-gamewindow.clientsize.Y/2 + gamewindow.clientsize.Y/15);
    end;
  // per jel XD
  obj_hud_wpn_rocketl_slash := tmcsCreatePlane(gamewindow.clientsize.X*0.06,gamewindow.clientsize.Y*0.14);
  tex_hud_wpn_rocketl_slash := tmcsCreateTextureFromFile(GAME_PATH_HUD+'hud_nums_bigslash.bmp',FALSE,FALSE,FALSE,GL_LINEAR,
                                                         GL_DECAL,GL_CLAMP,GL_CLAMP);
  tmcstextureobject(obj_hud_wpn_rocketl_slash,tex_hud_wpn_rocketl_slash);
  tmcssetobjectstickedstate(obj_hud_wpn_rocketl_slash,TRUE);
  tmcssetobjectlit(obj_hud_wpn_rocketl_slash,FALSE);
  tmcssetobjectblending(obj_hud_wpn_rocketl_slash,TRUE);
  tmcssetobjectblendmode(obj_hud_wpn_rocketl_slash,gl_one,gl_one);
  tmcssetxpos(obj_hud_wpn_rocketl_slash,
              tmcsgetxpos(obj_hud_wpn_rocketl_nums[0])+tmcsgetsizex(obj_hud_wpn_rocketl_nums[0])/2+gamewindow.clientsize.X*0.01);
  tmcssetypos(obj_hud_wpn_rocketl_slash,-gamewindow.clientsize.Y/2 + gamewindow.clientsize.Y/15);
  tmcscompileobject(obj_hud_wpn_rocketl_slash);
  for i := 1 to 2 do
    tmcssetxpos(obj_hud_wpn_rocketl_nums[i],
                tmcsgetxpos(obj_hud_wpn_rocketl_slash) + i*(tmcsgetsizex(obj_hud_wpn_rocketl_nums[i])*0.75));
end;

procedure ShowHUD;
var
  i: integer;
begin
  if ( not(DEBUG_WALKTHROUGH) ) then
    begin
      tmcsshowobject(obj_hudbottom);
      tmcsshowobject(obj_hudshieldicon);
      tmcsshowobject(obj_hudhealthicon);
      for i := 0 to 2 do
        begin
          tmcsshowobject(obj_hud_health_nums[i]);
          tmcsshowobject(obj_hud_shield_nums[i]);
        end;
      tmcsshowobject(obj_hud_wpn_current);
      if ( player.wpnsinfo.currentwpn in [1,2] ) then
        begin
          for i := 0 to 1 do
            tmcsshowObject(obj_hud_wpn_nums[i]);
        end
       else
        begin
          for i := 0 to 2 do
            tmcsshowObject(obj_hud_wpn_rocketl_nums[i]);
          tmcsshowObject(obj_hud_wpn_rocketl_slash);
        end;
      if ( not(player.hasteleport) ) then
        begin
          tmcshideobject(obj_hudtport);
          tmcshideobject(obj_hudtport2);
        end;
      hudvisible := TRUE;
    end;
end;

procedure HideHUD;
var
  i: integer;
begin
  tmcshideobject(obj_hudbottom);
  tmcshideobject(obj_hudshieldicon);
  tmcshideobject(obj_hudhealthicon);
  for i := 0 to 2 do
    begin
      tmcshideobject(obj_hud_health_nums[i]);
      tmcshideobject(obj_hud_shield_nums[i]);
    end;
  tmcshideobject(obj_hud_wpn_current);
  for i := 0 to 1 do
    tmcsHideObject(obj_hud_wpn_nums[i]);
  for i := 0 to 2 do
    tmcsHideObject(obj_hud_wpn_rocketl_nums[i]);
  tmcsHideObject(obj_hud_wpn_rocketl_slash);
  tmcshideobject(obj_hudtport);
  tmcshideobject(obj_hudtport2);
  hudvisible := FALSE;
end;

procedure HUDcontrol;
var
  i: integer;
begin
  if ( not(DEBUG_WALKTHROUGH) ) then
    begin
      if ( player.health > 0 ) then
        begin
          if ( player.health = 100 ) then
            begin
              tmcsTextureObject( obj_hud_health_nums[0],tex_hud_nums[1] );
              tmcsTextureObject( obj_hud_health_nums[1],tex_hud_nums[0] );
              tmcsTextureObject( obj_hud_health_nums[2],tex_hud_nums[0] );
            end
           else if ( player.health > 9 ) then
            begin
              tmcsTextureObject( obj_hud_health_nums[0],tex_hud_nums[0] );
              tmcsTextureObject( obj_hud_health_nums[1],tex_hud_nums[player.health div 10] );
              tmcsTextureObject( obj_hud_health_nums[2],tex_hud_nums[player.health mod 10] );
            end
           else
            begin
              tmcsTextureObject(obj_hud_health_nums[0],tex_hud_nums[0] );
              tmcsTextureObject(obj_hud_health_nums[1],tex_hud_nums[0] );
              tmcsTextureObject(obj_hud_health_nums[2],tex_hud_nums[player.health] );
            end;
          if ( player.health < GAME_HUD_HEALTH_MIN ) then
            begin
              if ( gettickcount() - healthlasttime >= GAME_HUD_BLINK_INTERVAL ) then
                begin
                  healthisred := not(healthisred);
                  healthlasttime := gettickcount();
                end;
              if ( healthisred ) then
                begin
                  for i := 0 to 2 do
                    tmcssetobjectcolorkey(obj_hud_health_nums[i],255,0,0,255);
                end
               else
                begin
                  for i := 0 to 2 do
                    tmcssetobjectcolorkey(obj_hud_health_nums[i],255,255,255,255);
                end;
            end
           else
            begin
              healthisred := FALSE;
              for i := 0 to 2 do
                tmcssetobjectcolorkey(obj_hud_health_nums[i],255,255,255,255);
            end;
          if ( player.shield = 100 ) then
            begin
              tmcsTextureObject( obj_hud_shield_nums[0],tex_hud_nums[1] );
              tmcsTextureObject( obj_hud_shield_nums[1],tex_hud_nums[0] );
              tmcsTextureObject( obj_hud_shield_nums[2],tex_hud_nums[0] );
            end
           else if ( player.shield > 9 ) then
            begin
              tmcsTextureObject( obj_hud_shield_nums[0],tex_hud_nums[0] );
              tmcsTextureObject( obj_hud_shield_nums[1],tex_hud_nums[player.shield div 10] );
              tmcsTextureObject( obj_hud_shield_nums[2],tex_hud_nums[player.shield mod 10] );
            end
           else
            begin
              tmcsTextureObject(obj_hud_shield_nums[0],tex_hud_nums[0] );
              tmcsTextureObject(obj_hud_shield_nums[1],tex_hud_nums[0] );
              tmcsTextureObject(obj_hud_shield_nums[2],tex_hud_nums[player.shield] );
            end;
          tmcstextureobject(obj_hud_wpn_current,tex_hud_wpns[player.wpnsinfo.currentwpn-1]);
          tmcsscaleobjectabsolute(obj_hud_wpn_current,round((1-(player.wpnsinfo.wpnchangebias_angz/PLAYER_WPN_CHANGE_ANGLEMAX))*100));
          tmcssetobjectcolorkey(obj_hud_wpn_current,
                                round((1-(player.wpnsinfo.wpnchangebias_angz/PLAYER_WPN_CHANGE_ANGLEMAX))*255),
                                round((1-(player.wpnsinfo.wpnchangebias_angz/PLAYER_WPN_CHANGE_ANGLEMAX))*255),
                                round((1-(player.wpnsinfo.wpnchangebias_angz/PLAYER_WPN_CHANGE_ANGLEMAX))*255),
                                255);
          if ( player.wpnsinfo.currentwpn in [1,2] ) then
            begin  // HUD pisztoly vagy gépfegyver cuccát frissítjük
              if ( hudvisible ) then
                begin
                  for i := 0 to 1 do
                    tmcsShowObject(obj_hud_wpn_nums[i]);
                end;
              for i := 0 to 2 do
                tmcsHideObject(obj_hud_wpn_rocketl_nums[i]);
              tmcsHideObject(obj_hud_wpn_rocketl_slash);
              tmcsTextureObject( obj_hud_wpn_nums[0],tex_hud_bignums[(player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].total div 10)] );
              tmcsTextureObject( obj_hud_wpn_nums[1],tex_hud_bignums[(player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].total mod 10)] );
              if ( player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].total > 0 ) then
                begin
                  tmcsSetObjectColorkey( obj_hud_wpn_current, 255,255,255,255 );
                  for i := 0 to 1 do
                    tmcsSetObjectcolorkey(obj_hud_wpn_nums[i], 255,255,255,255);
                end
               else
                begin
                  tmcsSetObjectColorkey( obj_hud_wpn_current, 255,0,0,255 );
                  for i := 0 to 1 do
                    tmcsSetObjectcolorkey(obj_hud_wpn_nums[i], 255,0,0,255);
                end;
            end
           else
            begin  // HUD rakétavetõ cuccát frissítjük
              for i := 0 to 1 do
                tmcsHideObject(obj_hud_wpn_nums[i]);
              if ( hudvisible ) then
                begin
                  for i := 0 to 2 do
                    tmcsShowObject(obj_hud_wpn_rocketl_nums[i]);
                  tmcsShowObject(obj_hud_wpn_rocketl_slash);
                end;
              tmcsTextureObject(obj_hud_wpn_rocketl_nums[0],tex_hud_bignums[player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].act]);
              tmcsTextureObject(obj_hud_wpn_rocketl_nums[1],tex_hud_nums[(player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].total div 10)]);
              tmcsTextureObject(obj_hud_wpn_rocketl_nums[2],tex_hud_nums[(player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].total mod 10)]);
              if ( player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].act > 0 ) then
                begin
                  if ( player.wpnsinfo.reloading ) then
                    begin
                      tmcsSetObjectColorkey( obj_hud_wpn_current, 255,255,0,255 );
                      for i := 0 to 2 do
                        tmcssetobjectcolorkey(obj_hud_wpn_rocketl_nums[i], 255,255,0,255);
                      tmcssetobjectcolorkey(obj_hud_wpn_rocketl_slash, 255,255,0,255);
                    end
                   else
                    begin
                      tmcsSetObjectColorkey( obj_hud_wpn_current, 255,255,255,255 );
                      for i := 0 to 2 do
                        tmcssetobjectcolorkey(obj_hud_wpn_rocketl_nums[i], 255,255,255,255);
                      tmcssetobjectcolorkey(obj_hud_wpn_rocketl_slash, 255,255,255,255);
                    end;
                end
               else
                begin
                  if ( player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].total > 0 ) then
                    begin
                      tmcsSetObjectColorkey( obj_hud_wpn_current, 255,255,0,255 );
                      for i := 0 to 2 do
                        tmcssetobjectcolorkey(obj_hud_wpn_rocketl_nums[i], 255,255,0,255);
                      tmcssetobjectcolorkey(obj_hud_wpn_rocketl_slash, 255,255,0,255);
                    end
                   else
                    begin
                      tmcsSetObjectColorkey( obj_hud_wpn_current, 255,0,0,255 );
                      for i := 0 to 2 do
                        tmcssetobjectcolorkey(obj_hud_wpn_rocketl_nums[i], 255,0,0,255);
                      tmcssetobjectcolorkey(obj_hud_wpn_rocketl_slash, 255,0,0,255);
                    end;
                end;
            end;
          if ( player.hasquaddamage ) then
            begin
              if ( gettickcount()-player.lastqmd >= GAME_ITEM_QUADDAMAGE_TIME ) then player.hasquaddamage := FALSE
               else
                begin
                  if ( (player.health > 0) and not(endgame) ) then tmcsshowobject(obj_qdmg)
                    else tmcshideobject(obj_qdmg);
                  player.qdmgrot := tmcswrapangle(player.qdmgrot+GAME_ITEM_QUADDAMAGE_SPEED/fps);
                  tmcsscaleobjectabsolute(obj_qdmg,150+sin(degtorad(player.qdmgrot))*20);
                  tmcssetobjectrotationxzy(obj_qdmg);
                end;
            end
           else
            begin
              tmcshideobject(obj_qdmg);
            end;
        end;
    end;
end;


procedure BuildFragTable;
begin
  obj_fragtable := tmcsCreatePlane(gamewindow.clientsize.X,gamewindow.clientsize.Y);
  tmcssetobjectstickedstate(obj_fragtable,TRUE);
  tex_fragtable := tmcscreatetexturefromfile(GAME_PATH_ETC+'fragtable.bmp',FALSE,FALSE,TRUE,GL_LINEAR,GL_DECAL,
                                       GL_CLAMP,GL_CLAMP);
  tmcstextureobject(obj_fragtable,tex_fragtable);
  tmcssetobjectlit(obj_fragtable,FALSE);
  tmcssetobjectblending(obj_fragtable,TRUE);
  tmcssetobjectblendmode(obj_fragtable,gl_src_alpha_saturate,gl_src_color);
  tmcscompileobject(obj_fragtable);

  obj_highlighter := tmcsCreatePlane(gamewindow.clientsize.X*0.85,gamewindow.clientsize.Y*0.04);
  tmcssetobjectstickedstate(obj_highlighter,TRUE);
  tmcssetobjectlit(obj_highlighter,FALSE);
  tmcssetobjectcolor(obj_highlighter,255,255,255);
  tmcssetobjectblending(obj_highlighter,TRUE);
  tmcssetobjectblendmode(obj_highlighter,gl_one,gl_one);
  tmcscompileobject(obj_highlighter);
end;

procedure AddFrag(playerind: integer);
begin
  if ( playerind = -1 ) then player.frags := player.frags + 1
    else if (playerind > -1) then botssetattribint(playerind,bafrags,botsgetattribint(playerind,bafrags)+1);
end;

procedure SubtractFrag(playerind: integer);
begin
  if ( playerind = -1 ) then player.frags := player.frags - 1
    else if (playerind > -1) then botssetattribint(playerind,bafrags,botsgetattribint(playerind,bafrags)-1);
end;

function getTeamNum(playerind: integer): integer;
begin
  if ( playerind = -1 ) then result := player.teamnum
    else if ( playerind > -1 ) then result := botsgetattribint(playerind,bateamnum);
end;

function getPlayerHealth(playerind: integer): integer;
begin
  if ( playerind = -1 ) then result := player.health
    else if (playerind > -1) then result := botsgetattribint(playerind,bahealth);
end;

function getPlayerFrags(index: integer): integer;
begin
  if ( index = 0 ) then result := player.frags
    else if (index > 0) then result := botsGetAttribInt(index-1,baFrags);
end;

function getPlayerDeaths(index: integer): integer;
begin
  if ( index = 0 ) then result := player.deaths
    else if (index > 0) then result := botsGetAttribInt(index-1,baDeaths);
end;

procedure AddDeath(playerind: integer);
begin
  if ( playerind = -1 ) then player.deaths := player.deaths + 1
    else if (playerind > -1) then botssetattribint(playerind,badeaths,botsgetattribint(playerind,badeaths)+1);
end;

function getPlayerName(index: integer): string;
begin
  if ( index = 0 ) then result := settings^.game_name
    else if (index > 0) then result := botsGetAttribString(index-1,baName);
end;

function getPlayerName2(index: integer): string;
begin
  if ( index = -1 ) then result := settings^.game_name
    else if (index > -1) then result := botsGetAttribString(index,baName);
end;

function hasQuadDmg(index: integer): boolean;
begin
  if ( index = -1 ) then result := player.hasquaddamage
    else if (index > -1) then result := botsGetAttribBool(index,baHasQuadDamage);
end;

function colorByPlayer(index: integer): TRGB;
var
  clr: TRGB;
begin
  case cfgGetGameMode() of
    gmDeathMatch       : begin
                           clr.red := 255;
                           clr.green := 255;
                           clr.blue := 255;
                         end;
    gmTeamDeathMatch   : begin
                           if ( getteamnum(index-1) = 0 ) then
                             begin
                               clr.red := 60;
                               clr.green := 60;
                               clr.blue := 255;
                             end
                            else
                             begin
                               clr.red := 255;
                               clr.green := 60;
                               clr.blue := 60;
                             end;
                         end;
    gmGaussElimination : begin
                           if ( (index = 0) and (alliedlist = settings^.game_name)
                                or
                                (index > 0) and (pos(botsGetAttribString(index-1,baName),alliedlist) > 0)
                              ) then
                                 begin
                                   clr.red := 255;
                                   clr.green := 255;
                                   clr.blue := 60;
                                 end
                                else
                                 begin
                                   clr.red := 255;
                                   clr.green := 255;
                                   clr.blue := 255;
                                 end;
                         end;
  end;
  result := clr;
end;

procedure DrawFragTable;
var
  i: integer;
  playertomb: array of integer;
  mp: integer;
  clr: TRGB;

procedure rendez(var tomb: array of integer);
var
  i: integer;

procedure csere(var tomb: array of integer; a,b: integer);
var
  c: integer;
begin
  c := tomb[a];
  tomb[a] := tomb[b];
  tomb[b] := c;
end;

function kisebb(a,b: integer): boolean;
begin
  result := a < b;
end;

function minker(var tomb: array of integer; ah,fh: integer): integer;
var
  i,ind: integer;
  min: integer;
begin
  min := getplayerfrags(tomb[ah]);
  ind := ah;
  for i := ah+1 to fh do
    begin
      if (
           (min < getplayerfrags(tomb[i]))
             or
           ( (min = getplayerfrags(tomb[i])) and (getplayerdeaths(ind) > getplayerdeaths(tomb[i])) )
             or
           ( (min = getplayerfrags(tomb[i])) and (getplayerdeaths(ind) = getplayerdeaths(tomb[i])) and (ansiCompareStr(getplayername(ind),getplayername(tomb[i])) > 0) )
         ) then
            begin
              ind := i;
              min := getplayerfrags(tomb[ind]);
            end;
    end;
  result := ind;
end;

begin
  for i := 0 to length(tomb)-1 do
    csere(tomb,i,minker(tomb,i,length(tomb)-1));
end;

begin                                                       
  tmcsshowobject(obj_fragtable);
  tmcsshowobject(obj_highlighter);
  tmcssettextcolor(255,255,255,255);
  tmcstext(GAME_FRAGTABLE_CAPTION,gamewindow.clientsize.X div 15,gamewindow.clientsize.y-gamewindow.clientsize.Y div 15,18,gamewindow.clientsize.Y div 6);
  tmcsText(GAME_FRAGTABLE_HEADER1,gamewindow.clientsize.X div 15,gamewindow.clientsize.y-gamewindow.clientsize.Y div 8,18,gamewindow.clientsize.Y div 7);
  tmcsText(GAME_FRAGTABLE_HEADER2,gamewindow.clientsize.X div 2,gamewindow.clientsize.y-gamewindow.clientsize.Y div 8,18,gamewindow.clientsize.y div 7);
  tmcsText(GAME_FRAGTABLE_HEADER3,gamewindow.clientsize.X-gamewindow.clientsize.X div 4,gamewindow.clientsize.y-gamewindow.clientsize.Y div 8,18,gamewindow.clientsize.y div 7);
  setlength(playertomb,botsGetBotsCount()+1);
  for i := 0 to length(playertomb)-1 do
    playertomb[i] := i;
  rendez(playertomb);
  mp := gamewindow.clientsize.Y div 24;
  for i := 0 to length(playertomb)-1 do
    begin
      clr := colorByPlayer(playertomb[i]);
      tmcsSetTextColor(clr.red,clr.green,clr.blue,255);
      tmcsText(getPlayerName(playertomb[i]),gamewindow.clientsize.X div 13,gamewindow.clientsize.y-gamewindow.clientsize.Y div 5 - (i+1)*mp,18,gamewindow.clientsize.Y div 8);
      tmcsText(inttostr(getPlayerFrags(playertomb[i])),gamewindow.clientsize.X div 2,gamewindow.clientsize.y-gamewindow.clientsize.Y div 5 - (i+1)*mp,18,gamewindow.clientsize.Y div 8);
      tmcsText(inttostr(getPlayerDeaths(playertomb[i])),gamewindow.clientsize.X-gamewindow.clientsize.X div 4,gamewindow.clientsize.y-gamewindow.clientsize.Y div 5 - (i+1)*mp,18,gamewindow.clientsize.Y div 8);
      if ( getPlayerName(playertomb[i]) = settings^.game_name ) then
        tmcssetypos(obj_highlighter,0+( ((gamewindow.clientsize.y-gamewindow.clientsize.Y div 5 - (i+1)*mp))-(gamewindow.clientsize.Y div 2) )-2)
    end;
  setlength(playertomb,0);
end;

procedure HideFragTable;
begin
  tmcshideobject(obj_fragtable);
  tmcshideobject(obj_highlighter);
end;



// végigmegyek minden sp-n, ha ütközik collzone-nal vagy playerrel, megállok, foglalt, ha végigmentem, nem ütközött, nemfoglalt
procedure UpdateSpawnPointsState;
var
  i,j: integer;
  l: boolean;
  sc: single;
begin
  sc := 100/tmcsGetScaling(obj_map);
  for i := 0 to mapgetspawnpointcount()-1 do
    begin
      l := FALSE;
      j := -2;
      while ( not(l) and (j < botsGetBotsCount()-1) ) do
        begin
          j := j+1;
          if ( j = -1 ) then
            l := (
                   ( (player.px-PLAYER_SIZEX/2 <= mapgetspawnpointx(i)/sc+10) and (player.px+PLAYER_SIZEX/2 >= mapgetspawnpointx(i)/sc-10) )
                     and
                   ( (player.py-PLAYER_SIZEY/2 <= mapgetspawnpointy(i)/sc+10) and (player.py+PLAYER_SIZEY/2 >= mapgetspawnpointy(i)/sc-10) )
                     and
                   ( (player.pz-PLAYER_SIZEZ/2 <= -mapgetspawnpointz(i)/sc+10) and (player.pz+PLAYER_SIZEZ/2 >= -mapgetspawnpointz(i)/sc-10) )
                     and
                   ( player.health > 0 )
                 )
           else
            l := (
                   ( (botsgetattribfloat(j,bapx)-botsgetattribfloat(j,basx)/2 <= mapgetspawnpointx(i)/sc+10) and (botsgetattribfloat(j,bapx)+botsgetattribfloat(j,basx)/2 >= mapgetspawnpointx(i)/sc-10) )
                      and
                   ( (botsgetattribfloat(j,bapy)-botsgetattribfloat(j,basy)/2 <= mapgetspawnpointy(i)/sc+10) and (botsgetattribfloat(j,bapy)+botsgetattribfloat(j,basy)/2 >= mapgetspawnpointy(i)/sc-10) )
                      and
                   ( (botsgetattribfloat(j,bapz)-botsgetattribfloat(j,basz)/2 <= -mapgetspawnpointz(i)/sc+10) and (botsgetattribfloat(j,bapz)+botsgetattribfloat(j,basz)/2 >= -mapgetspawnpointz(i)/sc-10) )
                      and
                   ( botsgetattribint(j,bahealth) > 0)
                 );
        end;
      if ( l ) then mapSetspawnpointengagedstate(i,TRUE)
        else mapSetspawnpointengagedstate(i,FALSE);
    end;

end;


{
 ____  _             _   ____  _
/ ___|| |_ __ _ _ __| |_|  _ \(_) ___
\___ \| __/ _` | '__| __| |_) | |/ __|
 ___) | || (_| | |  | |_|  __/| | (__
|____/ \__\__,_|_|   \__|_|   |_|\___|

}
procedure BuildStartPic;
begin
  obj_start_upper := tmcsCreatePlane(gamewindow.clientsize.X,gamewindow.clientsize.Y/2);
  tmcssetobjectstickedstate(obj_start_upper,TRUE);
  tex_start_upper := tmcscreatetexturefromfile(GAME_PATH_ETC+'g_pfps1.bmp',FALSE,FALSE,TRUE,GL_LINEAR,GL_DECAL,
                                       GL_CLAMP,GL_CLAMP);
  tmcstextureobject(obj_start_upper,tex_start_upper);
  tmcssetobjectlit(obj_start_upper,FALSE);
  tmcssetypos(obj_start_upper,gamewindow.clientsize.Y/2-tmcsgetsizey(obj_start_upper)/2);
  tmcscompileobject(obj_start_upper);

  obj_start_lower := tmcsCreatePlane(gamewindow.clientsize.X,gamewindow.clientsize.Y/2);
  tmcssetobjectstickedstate(obj_start_lower,TRUE);
  tex_start_lower := tmcscreatetexturefromfile(GAME_PATH_ETC+'g_pfps2.bmp',FALSE,FALSE,TRUE,GL_LINEAR,GL_DECAL,
                                       GL_CLAMP,GL_CLAMP);
  tmcstextureobject(obj_start_lower,tex_start_lower);
  tmcssetobjectlit(obj_start_lower,FALSE);
  tmcssetypos(obj_start_lower,-gamewindow.clientsize.Y/2+tmcsgetsizey(obj_start_lower)/2);
  tmcscompileobject(obj_start_lower);
end;

{
 __  __
|  \/  | ___ _ __  _   _
| |\/| |/ _ \ '_ \| | | |
| |  | |  __/ | | | |_| |
|_|  |_|\___|_| |_|\__,_|

}
procedure BuildMenu;
var
  i: integer;
begin
  // GL_src_alpha_saturate,GL_src_color --> fehér szín kihagyása
  // gl_one,gl_one --> fekete szín kihagyása
  // GL_one,GL_one_minus_src_alpha --> mchgun kijelzõjéhez
  obj_framebuffer := tmcsCreatePlane(gamewindow.clientsize.X,gamewindow.clientsize.Y);
  tmcssetobjectstickedstate(obj_framebuffer,TRUE);
  tex_framebuffer := tmcsCreateBlankTexture(getNearestPowerOf2(settings^.video_res_w),getNearestPowerOf2(settings^.video_res_w),
                                            GL_LINEAR,GL_DECAL,GL_CLAMP,GL_CLAMP);
  tmcstextureobject(obj_framebuffer,tex_framebuffer);
  tmcssetobjectlit(obj_framebuffer,FALSE);
  tmcsAdjustPlaneCoordsToViewport(obj_framebuffer,tex_framebuffer);

  obj_menubg := tmcsCreatePlane(gamewindow.clientsize.X,gamewindow.clientsize.Y);
  tmcssetobjectstickedstate(obj_menubg,TRUE);
  tex_menubg := tmcscreatetexturefromfile(GAME_PATH_MENU+'menubg.bmp',FALSE,FALSE,TRUE,GL_LINEAR,GL_DECAL,
                                       GL_CLAMP,GL_CLAMP);
  tmcstextureobject(obj_menubg,tex_menubg);
  tmcssetobjectlit(obj_menubg,FALSE);
  tmcssetobjectblending(obj_menubg,TRUE);
  tmcssetobjectblendmode(obj_menubg,GL_src_alpha_saturate,gl_src_color);
  tmcscompileobject(obj_menubg);

  obj_menutitle := tmcsCreatePlane(gamewindow.clientsize.X*0.8,gamewindow.clientsize.Y*0.53);
  tmcssetypos(obj_menutitle,(gamewindow.clientsize.Y/2-tmcsGetSizeY(obj_menutitle)/2)*1.5);
  tmcssetobjectstickedstate(obj_menutitle,TRUE);
  tex_menutitle := tmcscreatetexturefromfile(GAME_PATH_MENU+'menu_title.bmp',FALSE,FALSE,FALSE,GL_linear,GL_DECAL,
                                       GL_CLAMP,GL_CLAMP);
  tmcstextureobject(obj_menutitle,tex_menutitle);
  tmcssetobjectlit(obj_menutitle,FALSE);
  tmcssetobjectblending(obj_menutitle,TRUE);
  tmcssetobjectblendmode(obj_menutitle,GL_one,GL_one);
  tmcscompileobject(obj_menutitle);

  for i := 1 to GAME_INGAME_MENU_BTNCOUNT do
    begin
      obj_menubtns_up[i] := tmcsCreatePlane(gamewindow.clientsize.X*0.32,gamewindow.clientsize.Y*0.21);
      tmcssetobjectstickedstate(obj_menubtns_up[i],TRUE);
      tmcssetypos(obj_menubtns_up[i],tmcsgetypos(obj_menutitle)-i*tmcsgetsizey(obj_menubtns_up[i])/2);
      tex_menubtns_up[i] := tmcscreatetexturefromfile(GAME_PATH_MENU+GAME_INGAME_MENU_BTNFILE[i],FALSE,FALSE,FALSE,GL_LINEAR,GL_DECAL,
                                                      GL_CLAMP,GL_CLAMP);
      tex_menubtns_over[i] := tmcscreatetexturefromfile(GAME_PATH_MENU+GAME_INGAME_MENU_BTNFILE_OVER[i],FALSE,FALSE,FALSE,GL_LINEAR,GL_DECAL,
                                                        GL_CLAMP,GL_CLAMP);
      tmcstextureobject(obj_menubtns_up[i],tex_menubtns_up[i]);
      tmcssetobjectlit(obj_menubtns_up[i],FALSE);
      tmcssetobjectblending(obj_menubtns_up[i],TRUE);
      tmcssetobjectblendmode(obj_menubtns_up[i],GL_one,GL_one);
    end;
  menuscalex := tmcsgetsizex(obj_menubtns_up[1]) / tmcsgettexturewidth(tex_menubtns_up[1]);
  menuscaley := tmcsgetsizey(obj_menubtns_up[1]) / tmcsgettextureheight(tex_menubtns_up[1]);
  menu_x1_bias := 12-round(gamewindow.clientsize.X/170);
  menu_x2_bias := 20-round(gamewindow.clientsize.Y/76);
end;

procedure ShowMenu;
var
  i: integer;
begin
  hidehud;
  hidexhair;
  hidefpscounter;
  tmcsSetCameray(tmcsgetcameray()+player.cam_ys+player_headposy+player.death_yminus);
  tmcssetcameraangley(tmcsgetcameraangley()+player.cam_yas);
  tmcsRender;
  tmcsSetCameray(tmcsgetcameray()-player.cam_ys-player_headposy-player.death_yminus);
  tmcssetcameraangley(tmcsgetcameraangley()-player.cam_yas);
  tmcsFrameBufferToTexture(tex_framebuffer);
  tmcsshowobject(obj_menubg);
  tmcsshowobject(obj_menutitle);
  if ( settings^.reserved1 = 1 ) then showfpscounter;
  //tmcshideobject(obj_menubg);
  //tmcshideobject(obj_menutitle);
  // vmiért a blendelt menü hátteret és a címét nem rakja a textúránkra...
  // sulis gépen ablakban, itthon teljes képernyõs módban van ez a probléma...
  tmcsHideobject(obj_map);
  if ( obj_skybox > -1 ) then tmcshideobject(obj_skybox);
  tmcsShowObject(obj_framebuffer);
  if ( settings^.video_motionblur > 0 ) then
    begin
      tmcsDisableMotionBlur();
    end;
  for i := 1 to GAME_INGAME_MENU_BTNCOUNT do
    tmcsshowobject(obj_menubtns_up[i]);
  mousemoved := FALSE;
end;

procedure HideMenu;
var
  i: integer;
begin
  tmcshideobject(obj_menutitle);
  tmcshideobject(obj_framebuffer);
  tmcshideobject(obj_menubg);
  tmcsshowobject(obj_map);
  if ( obj_skybox > -1 ) then tmcsshowobject(obj_skybox);
  for i := 1 to GAME_INGAME_MENU_BTNCOUNT do
    tmcshideobject(obj_menubtns_up[i]);
  while ( showcursor(FALSE) > -1 ) do ;
  if ( settings^.video_motionblur = 1 ) then
    begin
      tmcsEnableMotionBlur(getNearestPowerOf2(settings^.video_res_w),getNearestPowerOf2(settings^.video_res_w));
    end;
end;

procedure ReturnToGame;
begin
  hidemenu;
  if ( settings^.game_showhud and (player.health > 0) ) then showhud;
  if ( settings^.game_showxhair and (player.health > 0) ) then showxhair;
  inmenu := not(inmenu);
  mouseToWndCenter;
  while ( showcursor(FALSE) > -1 ) do ;
end;

procedure PrintLoadingText(s: tstr255; num: integer);
var
  i: integer;
  s2: tstr255;
begin
  s2 := '';
  for i := 1 to num do
    s2 := s2+'.';
  tmcsSetTextColor(255,255,255,255);
  tmcsText('Töltés '+s2,gamewindow.clientsize.X div 40,gamewindow.clientsize.Y div 8,18,gamewindow.clientsize.Y div 6);
  tmcsText(s,gamewindow.clientsize.X div 20,gamewindow.clientsize.Y div 14,18,gamewindow.clientsize.Y div 7);
  tmcsRender();
end;

procedure AddBots;
var
  i,tn: integer;
begin
  k := 0;
  j := 0;
  case cfgGetGameMode() of
    gmDeathMatch       : begin
                           k := numStrFound(botslist,'(csiga)');
                           tn := player.teamnum;
                           i := 0;
                           for i := 1 to min(k,mapGetSpawnPointCount()-1) do
                             begin
                               tn := tn+1;
                               PrintLoadingText(GAME_LOADING_TEXTS[12],12+i);
                               botsAdd(botSnail,extractnamefromlines(botslist,i),tn);
                             end;

                           j := numStrFound(botslist,'(robot)');
                           for i := 1 to min( ((mapGetSpawnPointCount()-1)-k),j ) do
                             begin
                               tn := tn+1;
                               PrintLoadingText(GAME_LOADING_TEXTS[13],12+i+j);
                               botsAdd(botRobot,extractnamefromlines(botslist,i+k),tn);
                             end;
                         end;
    gmTeamDeathMatch   : begin
                           k := numStrFound(botslist,'(csiga)');
                           i := 0;
                           for i := 1 to min(k,mapGetSpawnPointCount()-1) do
                             begin
                               if ( pos(extractnamefromlines(botslist,i),alliedlist) > 0 ) then
                                 tn := player.teamnum
                                else tn := player.teamnum + 1;
                               PrintLoadingText(GAME_LOADING_TEXTS[12],12+i);
                               botsAdd(botSnail,extractnamefromlines(botslist,i),tn);
                             end;

                           j := numStrFound(botslist,'(robot)');
                           for i := 1 to min( ((mapGetSpawnPointCount()-1)-k),j ) do
                             begin
                               if ( pos(extractnamefromlines(botslist,i+k),alliedlist) > 0 ) then
                                 begin
                                   tn := player.teamnum;
                                 end
                                else
                                 begin
                                   tn := player.teamnum + 1;
                                 end;
                               PrintLoadingText(GAME_LOADING_TEXTS[13],12+i+j);
                               botsAdd(botRobot,extractnamefromlines(botslist,i+k),tn);
                             end;
                         end;
    gmGaussElimination : begin
                           if ( alliedlist = settings^.game_name ) then
                             begin // a játékos maga Gauss
                               k := numStrFound(botslist,'(csiga)');
                               i := 0;
                               tn := player.teamnum+1;
                               for i := 1 to min(k,mapGetSpawnPointCount()-1) do
                                 begin
                                   PrintLoadingText(GAME_LOADING_TEXTS[12],12+i);
                                   botsAdd(botSnail,extractnamefromlines(botslist,i),tn);
                                 end;

                               j := numStrFound(botslist,'(robot)');
                               for i := 1 to min( ((mapGetSpawnPointCount()-1)-k),j ) do
                                 begin
                                   PrintLoadingText(GAME_LOADING_TEXTS[13],12+i+j);
                                   botsAdd(botRobot,extractnamefromlines(botslist,i+k),tn);
                                 end;
                             end
                            else
                             begin // egy bot Gauss
                               k := numStrFound(botslist,'(csiga)');
                               i := 0;
                               for i := 1 to min(k,mapGetSpawnPointCount()-1) do
                                 begin
                                   if ( pos(extractnamefromlines(botslist,i),alliedlist) > 0 ) then
                                     tn := player.teamnum+1
                                    else tn := player.teamnum;
                                   PrintLoadingText(GAME_LOADING_TEXTS[12],12+i);
                                   botsAdd(botSnail,extractnamefromlines(botslist,i),tn);
                                 end;

                               j := numStrFound(botslist,'(robot)');
                               for i := 1 to min( ((mapGetSpawnPointCount()-1)-k),j ) do
                                 begin
                                   if ( pos(extractnamefromlines(botslist,i+k),alliedlist) > 0 ) then
                                     tn := player.teamnum+1
                                    else tn := player.teamnum;
                                   PrintLoadingText(GAME_LOADING_TEXTS[13],12+i+j);
                                   botsAdd(botRobot,extractnamefromlines(botslist,i+k),tn);
                                 end;
                             end;
                         end;
  end;
end;

procedure MainLoopInitialize; forward;
function bottosp(num: integer; canwait: boolean): boolean; forward;

procedure MenuReact(selitem: byte);
var
  old_video_gamma: shortint;
  oldshowfps: byte;
  oldcdepth,oldrr,oldfiltering,oldmblur,oldsoundsvol: byte;
  olddebug,oldfs,oldzbuffer16bit,oldshading,oldmipmaps,oldsitems,oldmarks,olmaps,oldvsync,oldhudisblue: boolean;
  oldsounds: boolean;
  i: integer;
  allbots: tstringlist;

function getIndexFromName(strings: TStrings; s: string): integer;
var
  i: integer;
  l: boolean;
begin
  i := -1;
  l := FALSE;
  while ( not(l) and (i < strings.Count-1) ) do
    begin
      i := i+1;
      l := ( pos(s,strings[i]) > 0 );
    end;
  if ( l ) then result := i
    else result := -1;
end;

function getBotIndexFromName(s: string): integer;
var
  i: integer;
  l: boolean;
begin
  i := -1;
  l := FALSE;
  while ( not(l) and (i < botsGetBotsCount()-1) ) do
    begin
      i := i+1;
      l := ( botsGetAttribString(i,baName) = s );
    end;
  if ( l ) then result := i
    else result := -1;
end;

function anyChecked(clb: TCheckListBox): boolean;
var
  i: integer;
  l: boolean;
begin
  i := -1;
  l := FALSE;
  while ( not(l) and (i < clb.Items.Count-1) ) do
    begin
      i := i+1;
      l := clb.Checked[i];
    end;
  result := l;
end;

begin
  case selitem of
    1: begin
         if (settings^.audio_sfx) then FSOUND_playsound(FSOUND_free,snd_btnpress);
         returntogame;
       end;
    2: begin
         if (settings^.audio_sfx) then FSOUND_playsound(FSOUND_free,snd_btnpress);
         if ( settings^.video_fullscreen ) then
           begin
             showwindow(gamewindow.hwindow,SW_MINIMIZE);
             tmcsrestoreoriginaldisplaymode();
           end;
         frm_botmanager := Tfrm_botmanager.Create(nil);
         frm_botmanager.FormStyle := fsStayOnTop;
         allbots := tstringlist.Create;
         allbots.LoadFromFile('data\botnames.txt');
         frm_botmanager.clb_bots.Items.Text := allbots.Text;
         allbots.Free;
         for i := 0 to botsGetBotsCount()-1 do
           begin
             if ( pos(botsGetAttribString(i,baName),botslist) > 0 ) then
               frm_botmanager.clb_bots.Checked[getIndexFromName(frm_botmanager.clb_bots.items,botsGetAttribString(i,baName))] := TRUE;
           end;
         setfocus(frm_botmanager.Handle);
         if ( frm_botmanager.ShowModal = mrOk ) then
           begin
             alliedlist := '';
             if ( cfgGetGameMode() = gmTeamDeathMatch ) then
               begin
                 if ( anychecked(frm_botmanager.clb_bots) ) then
                   begin
                     frm_teamselect := Tfrm_teamselect.Create(nil);
                     for i := 0 to frm_botmanager.clb_bots.Items.Count-1 do
                        if (frm_botmanager.clb_bots.Checked[i]) then
                          frm_teamselect.clb_allies.Items.Add( frm_botmanager.clb_bots.Items[i] );
                      frm_teamselect.showmodal;
                      if ( frm_teamselect.ModalResult = mrOk ) then
                        begin
                          // felszabadítás elõtt elkérjük a kiválasztott csapattársak neveit
                          alliedlist := frm_teamselect.alliedlist;
                        end;
                      frm_teamselect.Free;
                   end;
               end
              else if ( cfgGetGameMode() = gmGaussElimination ) then
               begin
                 frm_gausselect := Tfrm_gausselect.Create(nil);
                 frm_gausselect.cbox_gauss.Items.Add(settings^.game_name);
                 for i := 0 to frm_botmanager.clb_bots.Items.Count-1 do
                   frm_gausselect.cbox_gauss.Items.Add( frm_botmanager.clb_bots.Items[i] );
                 frm_gausselect.cbox_gauss.ItemIndex := 0;
                 frm_gausselect.showmodal;
                 if ( frm_gausselect.ModalResult = mrOk ) then
                   begin
                     alliedlist := frm_gausselect.cbox_gauss.Text;
                     frm_newgame.ModalResult := mrOk;
                   end;
                 frm_gausselect.Free;
               end;
             // megjelenítjük az üzenet ablakot
             frm_botmanager_wait := Tfrm_botmanager_wait.Create(nil);
             frm_botmanager_wait.Show;
             frm_botmanager_wait.Update;
             // kitöröljük a botokat, újra inicializáljuk a botrendszert, berakjuk a botokat
             botsShutDown;
             botslist := '';
             for i := 0 to frm_botmanager.clb_bots.Items.Count-1 do
               begin
                 if ( frm_botmanager.clb_bots.Checked[i] ) then botslist := botslist + frm_botmanager.clb_bots.Items[i]+#13+#10;
               end;
             botsInitialize(alliedlist);
             UpdateSpawnpointsState;
             AddBots;
             for i := 0 to botsGetBotsCount()-1 do
               begin
                 botsDefaultSettings(i,TRUE);
                 bottosp(i,FALSE);
               end;
             // kész, bezárjuk az üzenet ablakot
             frm_botmanager_wait.Close;
           end;
         frm_botmanager.Free;
         if ( settings^.video_fullscreen ) then
           begin
             tmcsrestoredisplaymode();
             showwindow(gamewindow.hwindow,SW_RESTORE);
           end;
         setforegroundwindow(gamewindow.hwindow);
         setfocus(gamewindow.hwindow);
       end;
    3: begin
         if (settings^.audio_sfx) then FSOUND_playsound(FSOUND_free,snd_btnpress);
         old_video_gamma := settings^.video_gamma;
         oldshowfps := settings^.reserved1;
         oldcdepth := settings^.video_colordepth;
         oldrr := settings^.video_refreshrate;
         oldfiltering := settings^.video_filtering;
         oldmblur := settings^.video_motionblur;
         olddebug := settings^.video_debug;
         oldfs := settings^.video_fullscreen;
         oldzbuffer16bit := settings^.video_zbuffer16bit;
         oldshading := settings^.video_shading_smooth;
         oldmipmaps := settings^.video_mipmaps;
         oldsitems := settings^.video_simpleitems;
         oldmarks := settings^.video_marksonwalls;
         olmaps := settings^.video_lightmaps;
         oldvsync := settings^.video_vsync;
         oldhudisblue := settings^.game_hudisblue;
         oldsounds := settings^.audio_sfx;
         oldsoundsvol := settings^.audio_sfxvol;
         if ( settings^.video_fullscreen ) then
           begin
             showwindow(gamewindow.hwindow,SW_MINIMIZE);
             tmcsrestoreoriginaldisplaymode();
           end;
         frm_settings := Tfrm_settings.Create(nil);
         frm_settings.FormStyle := fsStayOnTop;
         setforegroundwindow(frm_settings.Handle);
         setfocus(frm_settings.Handle);
         frm_settings.ShowModal;
         frm_settings.Free;
         if ( (settings^.game_hudisblue <> oldhudisblue) or (settings^.video_debug <> olddebug) or
              (settings^.video_res_w <> gamewindow.clientsize.X) or (settings^.video_res_h <> gamewindow.clientsize.Y) or
              (settings^.video_colordepth <> oldcdepth) or (settings^.video_fullscreen <> oldfs) or
              (settings^.video_refreshrate <> oldrr) or (settings^.video_vsync <> oldvsync) or
              (settings^.video_zbuffer16bit <> oldzbuffer16bit) or (settings^.video_shading_smooth <> oldshading) or
              (settings^.video_mipmaps <> oldmipmaps) or (settings^.video_filtering <> oldfiltering) or
              (settings^.video_simpleitems <> oldsitems) or (settings^.video_marksonwalls <> oldmarks) or
              (settings^.video_motionblur <> oldmblur) or (settings^.video_lightmaps <> olmaps) or
              (settings^.audio_sfx <> oldsounds)
            ) then
             begin
               settingchanged := FALSE;
               postquitmessage(0);
             end
            else
             begin
               if ( settings^.audio_sfxvol <> oldsoundsvol ) then FSOUND_SetSFXMasterVolume(round(settings^.audio_sfxvol/100*255));
               if ( oldshowfps <> settings^.reserved1 ) then
                 begin
                   if ( settings^.reserved1 = 1 ) then showfpscounter
                     else hidefpscounter;
                 end;
               if ( settings^.video_gamma <> old_video_gamma ) then
                 tmcsSetGamma(GAME_GAMMA_MAX_R-settings^.video_gamma,GAME_GAMMA_MAX_G-settings^.video_gamma,GAME_GAMMA_MAX_B-settings^.video_gamma);
             end;
         if ( settings^.video_fullscreen ) then
           begin
             tmcsrestoredisplaymode();
             showwindow(gamewindow.hwindow,SW_RESTORE);
             setforegroundwindow(gamewindow.hwindow);
             setfocus(gamewindow.hwindow);
           end;
       end;
    4: begin
         if (settings^.audio_sfx) then FSOUND_playsound(FSOUND_free,snd_btnpress);
         restarting := TRUE;
         MainLoopInitialize;
         HideMenu;
         almafa := TRUE;
       end;
    5: begin
         if (settings^.audio_sfx) then FSOUND_playsound(FSOUND_free,snd_btnpress);
         if ( settings^.video_fullscreen ) then
           begin
             showwindow(gamewindow.hwindow,SW_MINIMIZE);
             tmcsrestoreoriginaldisplaymode();
           end;
         frm_newgame := Tfrm_newgame.Create(nil);
         frm_newgame.FormStyle := fsStayOnTop;
         setfocus(frm_newgame.Handle);
         if ( frm_newgame.ShowModal = mrOk ) then
           begin
             postquitmessage(0);
             newmap := TRUE;
             alliedlist := frm_newgame.alliedlist;
             botslist := frm_newgame.lbox_chosen.Items.Text;
           end;
         frm_newgame.Free;
         if ( settings^.video_fullscreen ) then
           begin
             tmcsrestoredisplaymode();
             showwindow(gamewindow.hwindow,SW_RESTORE);
             setforegroundwindow(gamewindow.hwindow);
             setfocus(gamewindow.hwindow);
           end;
       end;
    6: begin
         if (settings^.audio_sfx) then FSOUND_playsound(FSOUND_free,snd_btnpress);
         postquitmessage(0);
       end;
  end;
end;

{
 ____  _                        ____        _   ____  ____  ____
|  _ \| | __ _ _   _  ___ _ __ | __ )  ___ | |_|___ \/ ___||  _ \
| |_) | |/ _` | | | |/ _ \ '__||  _ \ / _ \| __| __) \___ \| |_) |
|  __/| | (_| | |_| |  __/ |   | |_) | (_) | |_ / __/ ___) |  __/
|_|   |_|\__,_|\__, |\___|_|___|____/ \___/ \__|_____|____/|_|
               |___/      |_____|
}

procedure PlayerDefaults(zerofrags: boolean);
begin
  player.cam_yi := 0;
  player.cam_yai := 0;
  player.cam_ys := 0.0;
  player.cam_yas := 0.0;
  player.death_yminus := 0.0;
  player.gravity := 0.0;
  player.jmp := -1;
  player.jumping := FALSE;
  player.injurycausedbyfalling := 0;
  player.hasteleport := FALSE;
  player.hasquaddamage := FALSE;
  player.lastqmd := 0;
  player.qdmgrot := 0.0;
  player.health := game_MAX_HEALTH;
  player.shield := 0;
  player.teamnum := 0;
  if ( zerofrags ) then
    begin
      player.frags := 0;
      player.deaths := 0;
    end;
  player.wpnsinfo.bulletsinfo[1].total := 8;
  player.wpnsinfo.bulletsinfo[1].act := 0;
  player.wpnsinfo.bulletsinfo[1].actmaxtotal := 0;
  player.wpnsinfo.bulletsinfo[2].total := 0;
  player.wpnsinfo.bulletsinfo[2].act := 0;
  player.wpnsinfo.bulletsinfo[2].actmaxtotal := 0;
  player.wpnsinfo.bulletsinfo[3].total := 0;
  player.wpnsinfo.bulletsinfo[3].act := 0;
  player.wpnsinfo.bulletsinfo[3].actmaxtotal := GAME_ITEM_WPN_ROCKETLAUNCHER_MAXPACK;
  tmcshideobject(obj_wpn_mchgun);
  tmcshideobject(obj_wpn_mchgunlcd1);
  tmcshideobject(obj_wpn_mchgunlcd2);
  tmcshideobject(obj_wpn_mchgunlcdwarning);
  tmcshideobject(obj_wpn_rocketlauncher);
  tmcsshowobject(obj_wpn_pistol);
  player.wpnsinfo.currentwpn := 1;
  player.wpnsinfo.currentwpnobjnum := obj_wpn_pistol;
  player.wpnsinfo.currentwpnmuzzleobjnum := obj_wpn_pistolmuzzle;
  player.wpnsinfo.prevwpn := -1;
  player.wpnsinfo.gettingout := TRUE;
  player.wpnsinfo.takingaway := FALSE;
  player.wpnsinfo.wpnshotbias_angy := 0.0;
  player.wpnsinfo.wpnshotbias_angy_max := 0.0;
  player.wpnsinfo.wpnchangebias_angz := PLAYER_WPN_CHANGE_ANGLEMAX;
  player.wpnsinfo.wpn_ypos_bias := PLAYER_WPN_PISTOL_YPOS_BIAS;
  player.wpnsinfo.shotzangle := PLAYER_WPN_PISTOL_SHOTZANGLE;
  player.wpnsinfo.shotzanglechangespeed := PLAYER_WPN_PISTOL_SHOTZANGLECHANGESPEED;
  player.wpnsinfo.shotzanglechangespeedafter := PLAYER_WPN_PISTOL_SHOTZANGLECHANGESPEEDAFTER;
  player.wpnsinfo.reloadzangle := PLAYER_WPN_PISTOL_RELOADZANGLE;
  player.wpnsinfo.wpnreloadbias_angz := 0.0;
  player.wpnsinfo.numbulletstoreload := 0;
  player.wpnsinfo.lastbulletload := gettickcount() - PLAYER_WPN_ROCKETLAUNCHER_TIME_BETWEEN_RELOAD_STEPS;
  player.wpnsinfo.wpnacc := GAME_WPN_PISTOL_ACCURACY;
  obj_wpn_mchgun_lcdnums_alpha := GAME_WPN_MCHGUN_LCD_ALPHA_MIN;
  obj_wpn_mchgun_lcdnums_alpha_inc := TRUE;
  player.wpnsinfo.wpnshotbias_angz := 0.0;
  player.wpnsinfo.reloading := FALSE;
  player.wpnsinfo.shooting := FALSE;
  player.wpnsinfo.lastshot := 0;
  player.zoomplus := 0.0;
  player.impulsepx := 0.0;
  player.impulsepy := 0.0;
  player.impulsepz := 0.0;
  player.oimpulsepx := 0.0;
  player.oimpulsepy := 0.0;
  player.oimpulsepz := 0.0;
  spacehack := FALSE;
  escapestop := FALSE;
  tabulatorstop := FALSE;
  upstop := FALSE;
  downstop := FALSE;
  mouseleftstop := FALSE;
  rhack := FALSE;
  lastrun := gettickcount();
  leftleg := TRUE;
end;

function PlayerToSP(canwait: boolean): boolean;
var
  spi: integer;
  spointxyz: TXYZ;
  l: boolean;
begin
  l := FALSE;
  if ( canwait ) then
    begin
      spi := random(mapGetSpawnPointCount());
      if ( not(mapSpawnPointIsEngaged(spi)) ) then
        begin
          mapSetSpawnPointEngagedState(spi,TRUE);
          l := TRUE;
        end;
    end
   else
    begin
      repeat
        spi := random(mapGetSpawnPointCount());
      until ( not(mapSpawnPointIsEngaged(spi)) );
      mapSetSpawnPointEngagedState(spi,TRUE);
      l := TRUE;
    end;
  if ( l ) then
    begin
      spointxyz := mapGetSpawnPointXYZ( spi );
      player.opx := spointxyz.x / (100/tmcsGetScaling(obj_map));
      player.opy := spointxyz.y / (100/tmcsGetScaling(obj_map));
      player.opz := -spointxyz.z / (100/tmcsGetScaling(obj_map));
      player.px := player.opx;
      player.py := player.opy;
      player.pz := player.opz;
      player.gravity := 0.0;
      tmcsSetCameraPos(player.px,player.py,player.pz);
      tmcsSetCameraAngleY( mapGetSpawnPointAngleY(spi) );
      tmcsSetCameraAngleX( 0 );
      if (settings^.audio_sfx) then
        begin
          snd_pos.x := player.px;
          snd_pos.y := player.py;
          snd_pos.z := player.pz;
          sndchn := FSOUND_playsoundex(FSOUND_free,snd_useteleport,nil,TRUE);
          FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
          FSOUND_setpaused(sndchn,FALSE);
        end;
    end;
  result := l;
end;

function BotToSP(num: integer; canwait: boolean): boolean;
var
  spi: integer;
  spointxyz: TXYZ;
  l: boolean;
begin
  l := FALSE;
  if ( canwait ) then
    begin
      spi := random(mapGetSpawnPointCount());
      if ( not(mapSpawnPointIsEngaged(spi)) ) then
        begin
          mapSetSpawnPointEngagedState(spi,TRUE);
          l := TRUE;
        end;
    end
   else
    begin
      repeat
        spi := random(mapGetSpawnPointCount());
      until ( not(mapSpawnPointIsEngaged(spi)) );
      mapSetSpawnPointEngagedState(spi,TRUE);
      l := TRUE;
    end;
  if ( l ) then
    begin
      spointxyz := mapGetSpawnPointXYZ( spi );
      botsSetAttribfloat(num, baOPX, spointxyz.x / (100/tmcsGetScaling(obj_map)));
      botsSetAttribfloat(num, baOPY, spointxyz.y / (100/tmcsGetScaling(obj_map)));
      botsSetAttribfloat(num, baOPZ, -spointxyz.z / (100/tmcsGetScaling(obj_map)));
      botsSetAttribfloat(num, baPX, botsGetAttribFloat(num,baOPX));
      botsSetAttribfloat(num, baPY, botsGetAttribFloat(num,baOPY));
      botsSetAttribfloat(num, baPZ, botsGetAttribFloat(num,baOPZ));
      botsSetAttribfloat(num, baGravity, 0.0);
      tmcsSetXPos(botsGetAttribInt(num,baModelNum), botsGetAttribFloat(num,baPX));
      tmcsSetYPos(botsGetAttribInt(num,baModelNum), botsGetAttribFloat(num,baPY));
      tmcsSetZPos(botsGetAttribInt(num,baModelNum), botsGetAttribFloat(num,baPZ));
      botsSetAttribfloat(num, baAngleY, mapGetSpawnPointAngleY(spi));
      tmcsYRotateObject(botsGetAttribInt(num,baModelNum), mapGetSpawnPointAngleY(spi)-botsGetAttribFloat(num,baAngleY));
      if (settings^.audio_sfx) then
        begin
          snd_pos.x := botsGetAttribFloat(num,baPX);
          snd_pos.y := botsGetAttribFloat(num,baPY);
          snd_pos.z := botsGetAttribFloat(num,baPZ);
          sndchn := FSOUND_playsoundex(FSOUND_free,snd_useteleport,nil,TRUE);
          FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
          FSOUND_setpaused(sndchn,FALSE);
        end;
    end;
  result := l;
end;

procedure RevivePlayer(index: integer);
var
  ckey2: TRGBA;
begin
  if ( index = -1 ) then
    begin
      if ( gettickcount() - player.timetorevive >= GAME_TIMETOREVIVE ) then
        begin
          if ( playertosp(TRUE) ) then
            begin
              playerdefaults(FALSE);
              hidemenu;
              if ( settings^.game_showhud and (player.health > 0) ) then showhud;
              if ( settings^.game_showxhair and (player.health > 0) ) then showxhair;
              mblurcolor.red := 255;
              mblurcolor.green := 255;
              mblurcolor.blue := 255;
              if ( settings^.video_motionblur = 1 ) then mblurcolor.alpha := 178
                else mblurcolor.alpha := 0;
              bloodplanecolor.alpha := 0.0;
            end;
        end;
    end
   else
    begin
      if ( not(endgame) ) then
        begin
          if ( gettickcount() - botsgetattribint(index,baTimetorevive) >= GAME_TIMETOREVIVE ) then
            begin
              if ( bottosp(index,TRUE) ) then
                begin
                  botsdefaultsettings(index,FALSE);
                  tmcssetobjectblending(botsgetattribint(index,bamodelnum),FALSE);
                  ckey2 := tmcsgetobjectcolorkey(botsgetattribint(index,bamodelnum));
                  tmcssetobjectcolorkey(botsgetattribint(index,bamodelnum),ckey2.red,ckey2.green,ckey2.blue,255);
                end;
            end;
        end;
    end;
end;

procedure DeleteBullets; forward;
procedure DeleteMarks; forward;
procedure DeleteXplosions; forward;
procedure DeleteSmokes; forward;

procedure MainLoopInitialize;
var
  i: integer;
begin
  if ( restarting ) then
    begin
      while ( showcursor(FALSE) > -1 ) do ;
      DeleteBullets;
      DeleteMarks;
      DeleteXplosions;
      DeleteSmokes;
    end;
  BuildStartPic;
  bullets := tlist.Create;
  marks := tlist.Create;
  xplosions := tlist.Create;
  smokes := tlist.Create;
  lastsmoke := 0;
  itemstexts_h := 0;
  for i := 1 to GAME_MAX_ITEMS_TEXT do
    itemstexts[i] := nil;
  eventstexts_h := 0;
  for i := 1 to GAME_MAX_ITEMS_TEXT do
    eventstexts[i] := nil;
  for i := 0 to mapgetspawnpointcount()-1 do
    mapSetSpawnPointEngagedState(i,FALSE);
  for i := 0 to botsGetBotsCount() - 1 do
    begin
      botsDefaultSettings( i,TRUE );
      bottosp( i,FALSE );
    end;
  playertosp(FALSE);
  playerdefaults(TRUE);
  done := FALSE;
  inmenu := FALSE;
  restarting := FALSE;
  menuact := 1;
  firstframe := TRUE;
  settingchanged := TRUE;
  endgame := FALSE;
  cdopened := FALSE;
  // visszaállítunk minden spawnpointot szabadra
  for i := 0 to mapGetSpawnPointCount()-1 do
    mapSetSpawnPointEngagedState(i,FALSE);
  startpic_takeaway := FALSE;
  setforegroundwindow(gamewindow.hwindow);
  setfocus(gamewindow.hwindow);
  mouseToWndCenter;
  fps_ms := gettickcount();
  if ( GAME_MAXFPS > -1 ) then fps := GAME_MAXFPS
    else fps := 85;
  fps_old := 0;
  gamestarted := gettickcount();
  fps_ms_old := gettickcount();
end;

{
 __  __           ____
|  \/  |___  __ _|  _ \ _ __ ___   ___
| |\/| / __|/ _` | |_) | '__/ _ \ / __|
| |  | \__ \ (_| |  __/| | | (_) | (__
|_|  |_|___/\__, |_|   |_|  \___/ \___|
            |___/

}
function messageProcessing: boolean;
var
  l: boolean;
begin
  l := PeekMessage(windmsg, 0, 0, 0, PM_REMOVE);
  if ( l ) then
    begin
      if ( windmsg.message = WM_QUIT ) then
        begin
          done := TRUE;
        end
       else
        begin
          TranslateMessage(windmsg);
          DispatchMessage(windmsg);
        end;
    end;
  result := l;
end;

{
 ___ _
|_ _| |_ ___ _ __ ___  ___
 | || __/ _ \ '_ ` _ \/ __|
 | || ||  __/ | | | | \__ \
|___|\__\___|_| |_| |_|___/

}

procedure Items;
var
  i: integer;
  itemtime: cardinal;
begin
  for i := 0 to mapGetItemCount()-1 do
    begin
      if ( not(firstframe) ) then
        begin
          if ( fps <> 0 ) then mapupdateitemmotion(i,GAME_ITEMS_YROTPLUS_SPEED/fps,GAME_ITEMS_HEIGHTPLUS_SPEED/fps)
            else mapupdateitemmotion(i,GAME_ITEMS_YROTPLUS_SPEED/900,GAME_ITEMS_HEIGHTPLUS_SPEED/900);
        end;
      if ( mapgetitemtime(i) > 0 ) then
        begin
          case mapgetitemtype(i) of
            itHealth        : itemtime := GAME_ITEM_HEALTH_RESPAWNTIME;
            itShield        : itemtime := GAME_ITEM_SHIELD_RESPAWNTIME;
            itWpnPistolAmmo : itemtime := GAME_ITEM_WPN_PISTOL_RESPAWNTIME;
            itWpnMchgunAmmo : itemtime := GAME_ITEM_WPN_MCHGUN_RESPAWNTIME;
            itWpnRocketAmmo : itemtime := GAME_ITEM_WPN_ROCKETLAUNCHER_RESPAWNTIME;
            itTeleport      : itemtime := GAME_ITEM_TELEPORT_RESPAWNTIME;
            itQuadDamage    : itemtime := GAME_ITEM_QUADDAMAGE_RESPAWNTIME;
          end;
          if ( mapgetitemtime(i) + itemtime <= gettickcount() ) then
            begin
              mapsetitemtime(i,0);
              tmcsshowobject(mapgetitemintobj(i));
              collEnableCollZone(mapgetitemcollzone(i));
              if ( (mapgetitemtype(i) = itHealth) and settings^.audio_sfx) then
                begin
                  snd_pos.x := collGetZonePosX(mapgetitemcollzone(i));
                  snd_pos.y := collGetZonePosY(mapgetitemcollzone(i));
                  snd_pos.z := collGetZonePosZ(mapgetitemcollzone(i));
                  sndchn := FSOUND_playsoundex(FSOUND_free,snd_healthrespawn,nil,TRUE);
                  FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                  FSOUND_setpaused(sndchn,FALSE);
                end;
            end;
        end;
    end;
  if ( not(player.hasteleport) or (player.health = 0) ) then
    begin
      tmcshideobject(obj_hudtport);
      tmcshideobject(obj_hudtport2);
    end
   else
    begin
      tmcsshowobject(obj_hudtport);
      tmcsshowobject(obj_hudtport2);
    end;
end;

procedure PrintMajorText(s: tstr255; r,g,b,a: byte);
begin
  majortext.txt := s;
  majortext.timetaken := gettickcount();
  majortext.color.red := r;
  majortext.color.green := g;
  majortext.color.blue := b;
  majortext.color.alpha := a;
end;

procedure defItemPickupProc(itemindex: integer; time: cardinal; collzoneindex: integer; collattachedobject: integer);
begin
  mapSetItemTime(itemindex,time);
  collDisableCollZone(collzoneindex);
  tmcsHideObject( collattachedobject );
end;

procedure NewItemText(txt: tstr255; r,g,b,a: byte; timetaken: cardinal);
var
  i: byte;
begin
  for i := itemstexts_h downto 1 do
    begin
      if (i < GAME_MAX_ITEMS_TEXT) then itemstexts[i+1] := itemstexts[i]
        else
       begin
         dispose(itemstexts[i]);
         itemstexts[i] := nil;
       end;
    end;
  new(itemstext);
  itemstext.txt := txt;
  itemstext.timetaken := timetaken;
  itemstext.color.red := r;
  itemstext.color.green := g;
  itemstext.color.blue := b;
  itemstext.color.alpha := a;
  itemstexts[1] := itemstext;
  if ( itemstexts_h < GAME_MAX_ITEMS_TEXT ) then itemstexts_h := itemstexts_h + 1;
end;

procedure ItemsTextsProc;
var
  i: byte;
begin
  for i := 1 to itemstexts_h do
    begin
      itemstext := itemstexts[i];
      if ( assigned(itemstext) ) then
        begin
          if ( gettickcount() - itemstext.timetaken > GAME_HUD_ITEMS_TEXT_WAITBEFOREFADE ) then
            begin
              itemstext.color.alpha := itemstext.color.alpha - GAME_HUD_ITEMS_TEXT_FADESPEED/fps;
              if ( itemstext.color.alpha < 0 ) then itemstext.color.alpha := 0;
            end;
          tmcsSetTextColor(round(itemstext.color.red),round(itemstext.color.green),round(itemstext.color.blue),round(itemstext.color.alpha));
          tmcsText(itemstext.txt,0,(gamewindow.clientsize.Y div 2)-gamewindow.clientsize.Y div 10-(i-1)*(gamewindow.clientsize.Y div 24),18,gamewindow.clientsize.Y div 7);
        end;
    end;
  if ( gettickcount() - majortext.timetaken > GAME_HUD_MAJORTEXT_WAITBEFOREFADE ) then
    begin
      majortext.color.alpha := majortext.color.alpha - GAME_HUD_MAJORTEXT_FADESPEED/fps;
      if ( majortext.color.alpha < 0 ) then majortext.color.alpha := 0;
    end;
  if ( majortext.color.alpha > 0 ) then
    begin
      tmcsSetTextColor(round(majortext.color.red),round(majortext.color.green),round(majortext.color.blue),round(majortext.color.alpha));
      tmcsText(majortext.txt,(gamewindow.clientsize.X div 2)-gamewindow.clientsize.X div 6,(gamewindow.clientsize.Y div 2)+gamewindow.clientsize.Y div 5,18,gamewindow.clientsize.X div 4);
    end;
end;

procedure DeleteItemTexts;
var
  i: byte;
begin
  for i := 1 to itemstexts_h do
    if ( assigned(itemstexts[i]) ) then
      begin
        dispose(itemstexts[i]);
        itemstexts[i] := nil;
      end;
  itemstexts_h := 0;
end;

procedure NewEventText(txt1,txt2,txt3: tstr255; timetaken: cardinal; clr1,clr2: TRGB);
var
  i: byte;
begin
  for i := eventstexts_h downto 1 do
    begin
      if (i < GAME_MAX_ITEMS_TEXT) then eventstexts[i+1] := eventstexts[i]
        else
       begin
         dispose(eventstexts[i]);
         eventstexts[i] := nil;
       end;
    end;
  new(eventstext);
  if ( txt1 = txt3 ) then
    begin
      eventstext.txt1.txt := '';
      eventstext.txt1.color.alpha := 0;
      eventstext.txt2.txt := GAME_EVENTS_DEATH_SUICIDESTRING;
    end
   else
    begin
      eventstext.txt1.txt := txt1;
      eventstext.txt1.color.red := clr1.red;
      eventstext.txt1.color.green := clr1.green;
      eventstext.txt1.color.blue := clr1.blue;
      eventstext.txt1.color.alpha := 255;
      eventstext.txt2.txt := txt2;
    end;
  eventstext.txt2.color.red := 255;
  eventstext.txt2.color.green := 255;
  eventstext.txt2.color.blue := 255;
  eventstext.txt2.color.alpha := 255;
  eventstext.txt3.txt := txt3;
  eventstext.txt3.color.red := clr2.red;
  eventstext.txt3.color.green := clr2.green;
  eventstext.txt3.color.blue := clr2.blue;
  eventstext.txt3.color.alpha := 255;
  eventstext.txt1.timetaken := timetaken;
  eventstext.txt2.timetaken := timetaken;
  eventstext.txt3.timetaken := timetaken;
  eventstexts[1] := eventstext;
  if ( eventstexts_h < GAME_MAX_ITEMS_TEXT ) then eventstexts_h := eventstexts_h + 1;
end;

procedure EventsTextsProc;
var
  i: byte;
  basex: integer;
  mp: integer;
begin
  mp := gamewindow.clientsize.X div 60;
  for i := 1 to eventstexts_h do
    begin
      eventstext := eventstexts[i];
      if ( assigned(eventstext) ) then
        begin
          basex := gamewindow.clientsize.X - tmcsgettextwidth(eventstext.txt3.txt,18,gamewindow.clientsize.Y div 8) - length(eventstext.txt3.txt)-mp*2;
          if ( gettickcount() - eventstext.txt1.timetaken > GAME_HUD_ITEMS_TEXT_WAITBEFOREFADE ) then
            begin
              eventstext.txt1.color.alpha := eventstext.txt1.color.alpha - GAME_HUD_ITEMS_TEXT_FADESPEED/fps;
              if ( eventstext.txt1.color.alpha < 0 ) then eventstext.txt1.color.alpha := 0;
              eventstext.txt2.color.alpha := eventstext.txt2.color.alpha - GAME_HUD_ITEMS_TEXT_FADESPEED/fps;
              if ( eventstext.txt2.color.alpha < 0 ) then eventstext.txt2.color.alpha := 0;
              eventstext.txt3.color.alpha := eventstext.txt3.color.alpha - GAME_HUD_ITEMS_TEXT_FADESPEED/fps;
              if ( eventstext.txt3.color.alpha < 0 ) then eventstext.txt3.color.alpha := 0;
            end;
          tmcsSetTextColor(round(eventstext.txt1.color.red),round(eventstext.txt1.color.green),round(eventstext.txt1.color.blue),round(eventstext.txt1.color.alpha));
          tmcsText(eventstext.txt1.txt,basex-length(eventstext.txt2.txt)*mp-length(eventstext.txt1.txt)*mp,
                                  gamewindow.clientsize.Y - gamewindow.clientsize.Y div 6-(i-1)*(gamewindow.clientsize.Y div 24),
                                  18,gamewindow.clientsize.Y div 8);
          tmcsSetTextColor(round(eventstext.txt2.color.red),round(eventstext.txt2.color.green),round(eventstext.txt2.color.blue),round(eventstext.txt2.color.alpha));
          tmcsText(eventstext.txt2.txt,basex-length(eventstext.txt2.txt)*mp,
                                  gamewindow.clientsize.Y - gamewindow.clientsize.Y div 6-(i-1)*(gamewindow.clientsize.Y div 24),
                                  18,gamewindow.clientsize.Y div 8);
          tmcsSetTextColor(round(eventstext.txt3.color.red),round(eventstext.txt3.color.green),round(eventstext.txt3.color.blue),round(eventstext.txt3.color.alpha));
          tmcsText(eventstext.txt3.txt,basex,
                                  gamewindow.clientsize.Y - gamewindow.clientsize.Y div 6-(i-1)*(gamewindow.clientsize.Y div 24),
                                  18,gamewindow.clientsize.Y div 8);
        end;
    end;
end;

procedure DeleteEventTexts;
var
  i: byte;
begin
  for i := 1 to eventstexts_h do
    if ( assigned(eventstexts[i]) ) then
      begin
        dispose(eventstexts[i]);
        eventstexts[i] := nil;
      end;
  eventstexts_h := 0;
end;

{
 __  __            _              ___  _     _           _
|  \/  | _____   _(_)_ __   __ _ / _ \| |__ (_) ___  ___| |_ ___
| |\/| |/ _ \ \ / / | '_ \ / _` | | | | '_ \| |/ _ \/ __| __/ __|
| |  | | (_) \ V /| | | | | (_| | |_| | |_) | |  __/ (__| |_\__ \
|_|  |_|\___/ \_/ |_|_| |_|\__, |\___/|_.__// |\___|\___|\__|___/
                           |___/          |__/
}
procedure MovingObjects(index: integer);
var
  i: integer;
  sxyz,exyz: txyz;
  start,stop: integer;
begin
  if ( not(firstframe) ) then
    begin
      if ( index = -1 ) then
        begin
          start := 0;
          stop := mapgetmovingobjectcount() - 1;
        end
       else
        begin
          start := index;
          stop := index;
        end;
      for i := start to stop do
        begin
          sxyz := mapgetmovingobjectstartpos(i);
          exyz := mapgetmovingobjectendpos(i);
          mapsetmovingobjectoldpos( i, tmcsgetxpos(mapgetmovingobjectattachedobject(i)),tmcsgetypos(mapgetmovingobjectattachedobject(i)),tmcsgetzpos(mapgetmovingobjectattachedobject(i)) );
          case mapgetmovingobjecttype(i) of
            moX: begin
                   if ( mapgetmovingobjectheading(i) ) then
                     begin
                       tmcssetxpos(mapgetmovingobjectattachedobject(i),tmcsgetxpos(mapgetmovingobjectattachedobject(i))+mapgetmovingobjectspeed(i)*80/fps);
                       collsetzoneposx(mapgetmovingobjectcollzone(i),tmcsgetxpos(mapgetmovingobjectattachedobject(i)));
                       if ( tmcsgetxpos(mapgetmovingobjectattachedobject(i)) >= exyz.x ) then
                         begin
                           tmcssetxpos(mapgetmovingobjectattachedobject(i),exyz.x);
                           collsetzoneposx(mapgetmovingobjectcollzone(i),tmcsgetxpos(mapgetmovingobjectattachedobject(i)));
                           mapsetmovingobjectheading(i,FALSE);
                         end;
                     end
                    else
                     begin
                       tmcssetxpos(mapgetmovingobjectattachedobject(i),tmcsgetxpos(mapgetmovingobjectattachedobject(i))-mapgetmovingobjectspeed(i)*80/fps);
                       collsetzoneposx(mapgetmovingobjectcollzone(i),tmcsgetxpos(mapgetmovingobjectattachedobject(i)));
                       if ( tmcsgetxpos(mapgetmovingobjectattachedobject(i)) <= sxyz.x ) then
                         begin
                           tmcssetxpos(mapgetmovingobjectattachedobject(i),sxyz.x);
                           collsetzoneposx(mapgetmovingobjectcollzone(i),tmcsgetxpos(mapgetmovingobjectattachedobject(i)));
                           mapsetmovingobjectheading(i,TRUE);
                         end;
                     end;
                 end;
            moY: begin
                   if ( mapgetmovingobjectheading(i) ) then
                     begin
                       tmcssetypos(mapgetmovingobjectattachedobject(i),tmcsgetypos(mapgetmovingobjectattachedobject(i))+mapgetmovingobjectspeed(i)*80/fps);
                       collsetzoneposy(mapgetmovingobjectcollzone(i),tmcsgetypos(mapgetmovingobjectattachedobject(i)));
                       if ( tmcsgetypos(mapgetmovingobjectattachedobject(i)) >= exyz.y ) then
                         begin
                           tmcssetypos(mapgetmovingobjectattachedobject(i),exyz.y);
                           collsetzoneposy(mapgetmovingobjectcollzone(i),tmcsgetypos(mapgetmovingobjectattachedobject(i)));
                           mapsetmovingobjectheading(i,FALSE);
                         end;
                     end
                    else
                     begin
                       tmcssetypos(mapgetmovingobjectattachedobject(i),tmcsgetypos(mapgetmovingobjectattachedobject(i))-mapgetmovingobjectspeed(i)*80/fps);
                       collsetzoneposy(mapgetmovingobjectcollzone(i),tmcsgetypos(mapgetmovingobjectattachedobject(i)));
                       if ( tmcsgetypos(mapgetmovingobjectattachedobject(i)) <= sxyz.y ) then
                         begin
                           tmcssetypos(mapgetmovingobjectattachedobject(i),sxyz.y);
                           collsetzoneposy(mapgetmovingobjectcollzone(i),tmcsgetypos(mapgetmovingobjectattachedobject(i)));
                           mapsetmovingobjectheading(i,TRUE);
                         end;
                     end;
                 end;
            moZ: begin
                   if ( mapgetmovingobjectheading(i) ) then
                     begin
                       tmcssetzpos(mapgetmovingobjectattachedobject(i),-tmcsgetzpos(mapgetmovingobjectattachedobject(i))+mapgetmovingobjectspeed(i)*80/fps);
                       collsetzoneposz(mapgetmovingobjectcollzone(i),-tmcsgetzpos(mapgetmovingobjectattachedobject(i)));
                       if ( tmcsgetzpos(mapgetmovingobjectattachedobject(i)) >= exyz.z ) then
                         begin
                           tmcssetzpos(mapgetmovingobjectattachedobject(i),exyz.z);
                           collsetzoneposz(mapgetmovingobjectcollzone(i),-tmcsgetzpos(mapgetmovingobjectattachedobject(i)));
                           mapsetmovingobjectheading(i,FALSE);
                         end;
                     end
                    else
                     begin
                       tmcssetzpos(mapgetmovingobjectattachedobject(i),-tmcsgetzpos(mapgetmovingobjectattachedobject(i))-mapgetmovingobjectspeed(i)*80/fps);
                       collsetzoneposz(mapgetmovingobjectcollzone(i),-tmcsgetzpos(mapgetmovingobjectattachedobject(i)));
                       if ( tmcsgetzpos(mapgetmovingobjectattachedobject(i)) <= sxyz.z ) then
                         begin
                           tmcssetzpos(mapgetmovingobjectattachedobject(i),sxyz.z);
                           collsetzoneposz(mapgetmovingobjectcollzone(i),-tmcsgetzpos(mapgetmovingobjectattachedobject(i)));
                           mapsetmovingobjectheading(i,TRUE);
                         end;
                     end;
                 end;
          end;  // case
        mapsetmovingobjectpos( i, tmcsgetxpos(mapgetmovingobjectattachedobject(i)),tmcsgetypos(mapgetmovingobjectattachedobject(i)),tmcsgetzpos(mapgetmovingobjectattachedobject(i)) );
      end;  // i ciklus
  end;
end;

{
 ____
|  _ \  __ _ _ __ ___   __ _  __ _  ___
| | | |/ _` | '_ ` _ \ / _` |/ _` |/ _ \
| |_| | (_| | | | | | | (_| | (_| |  __/
|____/ \__,_|_| |_| |_|\__,_|\__, |\___|
                             |___/
}
procedure DamageToPlayer(playerind: integer; dmg: integer; affectshield: boolean);
var
  ohealth: integer;
  mblurplus: integer;
begin
  if ( dmg > 0 ) then
    begin
      if ( (playerind = -1) and (player.health > 0) ) then
        begin  // játékos
          if ( not(affectshield) and settings^.audio_sfx ) then
            begin
              snd_pos.x := player.px;
              snd_pos.y := player.py;
              snd_pos.z := player.pz;
              sndchn := FSOUND_playsoundex(FSOUND_free,snd_fall,nil,TRUE);
              FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
              FSOUND_setpaused(sndchn,FALSE);
            end;
          ohealth := player.health;
          if ( affectshield ) then
            begin
              if ( player.shield > 1 ) then
                begin
                  player.health := player.health - round(dmg / (player.shield/2));
                  player.shield := player.shield - dmg;
                  if ( player.shield < 0 ) then player.shield := 0;
                end
               else if ( player.shield > 0 ) then
                begin
                  player.health := player.health - dmg+1;
                  player.shield := 0;
                end
               else if ( player.shield = 0 ) then
                 begin
                   player.health := player.health - dmg;
                 end;
            end
           else
            begin
              player.health := player.health - dmg;
            end;
          if ( player.health < 0 ) then player.health := 0;
          if ( player.health = 0 ) then
            begin
              tmcsHideObject(player.wpnsinfo.currentwpnobjnum);
              if ( player.wpnsinfo.currentwpnmuzzleobjnum > -1 ) then
                tmcshideobject(player.wpnsinfo.currentwpnmuzzleobjnum);
              HideHUD;
              HideXHair;
              tmcshideobject(obj_qdmg);
              player.timetorevive := gettickcount();
              if (settings^.game_showblood) then mblurplus := 255;
              hidefragtable;
              if (settings^.audio_sfx) then
                begin
                  sndchn := FSOUND_playsoundex(FSOUND_free,snd_dmg2,nil,TRUE);
                  snd_pos.x := player.px;
                  snd_pos.y := player.py;
                  snd_pos.z := player.pz;
                  FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                  FSOUND_setpaused(sndchn,FALSE);
                end;
            end
           else
            begin
              if ( ohealth >= 25 ) then
                begin  // HUD-nál villogáshoz kell
                  healthlasttime := gettickcount();
                  healthisred := TRUE;
                end;
            end;
          if (settings^.game_showblood) then
            begin
              mblurplus := ohealth - player.health;
              if ( (settings^.video_motionblur = 2) and (mblurplus > 0) and (mblurplus < 255) ) then
                mblurplus := mblurplus + round(fps*GAME_BASE_MBLURALPHA_MULTIPLIER);
              if ( mblurcolor.alpha + mblurplus > 255.0 ) then
                 mblurcolor.alpha := 255.0
                else
                 mblurcolor.alpha := mblurcolor.alpha + mblurplus;
              if ( mblurcolor.green - mblurplus < 0 ) then
                mblurcolor.green := 0
               else
                mblurcolor.green := mblurcolor.green - mblurplus;
              if ( mblurcolor.blue - mblurplus < 0 ) then
                mblurcolor.blue := 0
               else
                mblurcolor.blue := mblurcolor.blue - mblurplus;
              if ( bloodplanecolor.alpha + mblurplus*30 <= 230 ) then
                bloodplanecolor.alpha := bloodplanecolor.alpha + mblurplus*30
               else
                bloodplanecolor.alpha := 230;
            end;
        end  // playerind = -1
       else if ( (playerind > -1) and (playerind < botsGetBotsCount()) and (botsGetAttribInt(playerind,baHealth) > 0) ) then
        begin  // bot
          ohealth := botsGetAttribInt(playerind,baHealth);
          if ( affectshield ) then
            begin
              if ( botsGetAttribInt(playerind,baShield) > 1 ) then
                begin
                  botsSetAttribint(playerind,baHealth,botsGetAttribInt(playerind,baHealth) - round(dmg / (botsGetAttribInt(playerind,baShield)/2)));
                  botsSetAttribint(playerind,baShield,botsGetAttribInt(playerind,baShield) - dmg);
                  if ( botsGetAttribInt(playerind,baShield) < 0 ) then botsSetAttribint(playerind,baShield,0);
                end
               else if ( botsGetAttribInt(playerind,baShield) > 0 ) then
                begin
                  botsSetAttribint(playerind,baHealth,botsGetAttribInt(playerind,bahealth) - dmg+1);
                  botsSetAttribint(playerind,baShield,0);
                end
               else if ( botsGetAttribInt(playerind,baShield) = 0 ) then
                 begin
                   botsSetAttribint(playerind,baHealth,botsGetAttribInt(playerind,bahealth) - dmg);
                 end;
            end
           else
            begin
              botsSetAttribint(playerind,baHealth,botsGetAttribInt(playerind,bahealth) - dmg);
            end;
          if ( botsGetAttribInt(playerind,bahealth) < 0 ) then botsSetAttribint(playerind,baHealth,0);
          if ( botsGetAttribInt(playerind,bahealth) = 0 ) then
            begin
              colldisablecollzone( botsgetattribint(playerind,bacollzone) );
              botsSetattribint(playerind,batimetorevive,gettickcount());
              if (settings^.audio_sfx) then
                begin
                  snd_pos.x := botsGetAttribFloat(playerind,baPX);
                  snd_pos.y := botsGetAttribFloat(playerind,baPY);
                  snd_pos.z := botsGetAttribFloat(playerind,baPZ);
                  if ( botsisbot(playerind,botSnail) ) then sndchn := FSOUND_playsoundex(FSOUND_free,snd_death1,nil,TRUE)
                    else sndchn := FSOUND_playsoundex(FSOUND_free,snd_death2,nil,TRUE);
                  FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                  FSOUND_setpaused(sndchn,FALSE);
                end;
            end;
        end;
    end  // dmg > 0
   else
    begin
      if ( not(affectshield) and (playerind = -1) and (player.gravity < -(GAME_WORLD_GRAVITY_MAX)/fps) and (settings^.audio_sfx) ) then
        begin
          snd_pos.x := player.px;
          snd_pos.y := player.py;
          snd_pos.z := player.pz;
          sndchn := FSOUND_playsoundex(FSOUND_free,snd_land,nil,TRUE);
          FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
          FSOUND_setpaused(sndchn,FALSE);
        end;
    end;
end;

{
 ____        _ _      _                 __  __            _
| __ ) _   _| | | ___| |_ ___   _ __   |  \/  | __ _ _ __| | _____
|  _ \| | | | | |/ _ \ __/ __| | '_ \  | |\/| |/ _` | '__| |/ / __|
| |_) | |_| | | |  __/ |_\__ \ | | | | | |  | | (_| | |  |   <\__ \
|____/ \__,_|_|_|\___|\__|___/ |_| |_| |_|  |_|\__,_|_|  |_|\_\___/

}

procedure NewSmoke(sx,sy: single; x,y,z: single; ax,ay: single; toff: boolean; r,g,b: byte; s,d: TGLConst);
begin
  new(smoke);
  smokes.Add(smoke);
  smoke^.objnum := tmcsCreatePlane(sx,sy);
  smoke^.scaling := 100.0;
  smoke^.takingoff := toff;
  smoke^.colorkey.red := r;
  smoke^.colorkey.green := g;
  smoke^.colorkey.blue := b;
  smoke^.colorkey.alpha := 255;
  tmcssetobjectcolorkey(smoke^.objnum,r,g,b,smoke^.colorkey.alpha);
  tmcssetxpos(smoke^.objnum,x);
  tmcssetypos(smoke^.objnum,y);
  tmcssetzpos(smoke^.objnum,z);
  tmcszrotateobject(smoke^.objnum,360-ax);
  tmcsyrotateobject(smoke^.objnum,ay);
  tmcssetobjectrotationyxz(smoke^.objnum);
  tmcssetobjectlit(smoke^.objnum,FALSE);
  tmcstextureobject(smoke^.objnum,tex_smoke);
  tmcssetobjectblending(smoke^.objnum,TRUE);
  tmcssetobjectblendmode(smoke^.objnum,s,d);
  tmcssetobjectdoublesided(smoke^.objnum,TRUE);
  tmcscompileobject(smoke^.objnum);
end;

procedure DeleteSmoke(index: integer);
begin
  smoke := smokes[index];
  if ( assigned(smoke) ) then
    begin
      tmcsdeleteobject(smoke^.objnum);
      dispose(smoke);
      smokes[index] := nil;
    end;
end;

procedure DeleteSmokes;
var
  i: integer;
begin
  for i := 0 to smokes.Count-1 do
    DeleteSmoke(i);
  smokes.Free;
end;

procedure SmokesProc;
var
  i: integer;
  tmp: single;
begin
  for i := 0 to smokes.Count-1 do
    begin
      smoke := smokes[i];
      if ( assigned(smoke) ) then
        begin
          smoke^.scaling := smoke^.scaling + GAME_ROCKET_SMOKE_SCALESPEED/fps;
          if ( smoke^.scaling > GAME_ROCKET_SMOKE_STOPSCALE ) then deletesmoke(i)
            else
           begin
             tmp := abs(tmcsgetanglez(smoke^.objnum))/90;
             tmcsscaleobjectabsolute(smoke^.objnum,round(smoke^.scaling));
             tmcssetobjectcolorkey(smoke^.objnum,
                                   smoke^.colorkey.red-round((smoke^.scaling/GAME_ROCKET_SMOKE_STOPSCALE)*smoke^.colorkey.red),
                                   smoke^.colorkey.green-round((smoke^.scaling/GAME_ROCKET_SMOKE_STOPSCALE)*smoke^.colorkey.green),
                                   smoke^.colorkey.blue-round((smoke^.scaling/GAME_ROCKET_SMOKE_STOPSCALE)*smoke^.colorkey.blue),
                                   smoke^.colorkey.alpha
                                  );
             tmcssetxpos(smoke^.objnum,tmcsgetxpos(smoke^.objnum) - (cos((tmcsgetangley(smoke^.objnum)+270)*pi/180)/10)*(1-(tmp*tmp))*(GAME_ROCKET_SMOKE_SPEED*(80/fps)));
             if ( smoke^.takingoff ) then tmcssetypos(smoke^.objnum,tmcsgetypos(smoke^.objnum) - (cos((tmcsgetanglez(smoke^.objnum)+270)*pi/180)/10)*(GAME_ROCKET_SMOKE_SPEED*(80/fps)) + GAME_ROCKET_SMOKE_SPEED*100/fps)
               else tmcssetypos(smoke^.objnum,tmcsgetypos(smoke^.objnum) - (cos((tmcsgetanglez(smoke^.objnum)+270)*pi/180)/10)*(GAME_ROCKET_SMOKE_SPEED*(80/fps)));
             tmcssetzpos(smoke^.objnum,tmcsgetzpos(smoke^.objnum) + (sin((tmcsgetangley(smoke^.objnum)+270)*pi/180)/10)*(1-(tmp*tmp))*(GAME_ROCKET_SMOKE_SPEED*(80/fps)));
           end;
        end;
    end;
end;

// új lövedék létrehozása
procedure NewBullet(wpn: integer; owner: integer; posx,posy,posz,angx,angy,angz: single);
var
  scaling: single;
begin
  new(bullet);
  bullets.Add(bullet);
  bullet^.ax := angx;
  bullet^.ay := angy;
  bullet^.az := angz;
  bullet^.ownerplayer := owner;
  bullet^.pos.x := posx;
  bullet^.pos.y := posy;
  bullet^.pos.z := posz;
  bullet^.opos := bullet^.pos;
  bullet^.ownerwpn := wpn;
  bullet^.movecount := 0;
  bullet^.routelength := 0.0;

  case wpn of
    1: begin
         bullet^.objnum := tmcsCreateClonedObject(obj_bullet_pistol);
         bullet^.speed := GAME_PISTOL_BULLET_SPEED;
         bullet^.sizex := GAME_PISTOL_BULLET_SIZEX;
         bullet^.sizey := GAME_PISTOL_BULLET_SIZEY;
         bullet^.sizez := GAME_PISTOL_BULLET_SIZEZ;
       end;
    2: begin
         bullet^.objnum := tmcsCreateClonedObject(obj_bullet_mchgun);
         bullet^.speed := GAME_MCHGUN_BULLET_SPEED;
         bullet^.sizex := GAME_MCHGUN_BULLET_SIZEX;
         bullet^.sizey := GAME_MCHGUN_BULLET_SIZEY;
         bullet^.sizez := GAME_MCHGUN_BULLET_SIZEZ;
       end;
    3: begin
         bullet^.objnum := tmcsCreateClonedObject(obj_bullet_rocketl);
         scaling := 100/tmcsGetScaling(bullet^.objnum);
         bullet^.speed := GAME_ROCKET_SPEED;
         bullet^.sizex := tmcsgetsizex(bullet^.objnum) / scaling;
         bullet^.sizey := tmcsgetsizey(bullet^.objnum) / scaling;
         bullet^.sizez := tmcsgetsizez(bullet^.objnum) / scaling;
       end;
  end;

  tmcssetxpos(bullet^.objnum,bullet^.pos.x);
  tmcssetypos(bullet^.objnum,bullet^.pos.y);
  tmcssetzpos(bullet^.objnum,bullet^.pos.z);
  if ( wpn in [3] ) then
    begin
      tmcsxrotateobject(bullet^.objnum,360-bullet^.az);
      tmcszrotateobject(bullet^.objnum,360-bullet^.ax);
    end
   else
    begin
      tmcsxrotateobject(bullet^.objnum,bullet^.ax);
      tmcszrotateobject(bullet^.objnum,bullet^.az);
    end;
  tmcsyrotateobject(bullet^.objnum,bullet^.ay);
  //tmcscompileobject(bullet^.objnum);
end;

procedure NewMark(bullet: pbullet; colliding: integer);
var
  obj, subobj: integer;
  scaling: single;
  distx,disty,distz: single;
begin
  new(mark);
  marks.Add(mark);
  mark^.objnum := tmcscreateplane(GAME_MARKS_SIZEX,GAME_MARKS_SIZEY);
  mark^.repax := bullet^.ax;
  mark^.repay := bullet^.ay;
  tmcssetobjectlit(mark^.objnum,FALSE);
  tmcstextureobject(mark^.objnum,tex_mark);
  tmcsadjustuvcoords(mark^.objnum,0.1);
  tmcssetobjectblending(mark^.objnum,TRUE);
  tmcssetobjectblendmode(mark^.objnum,GL_src_alpha_saturate,GL_src_color);
  tmcscompileobject(mark^.objnum);

  // tmcssetxpos(mark^.objnum,tmcsgetxpos(mark^.objnum) - (cos((mark^.repay+90)*pi/180)/10)*(1-(tmp*tmp)) * 0.01);
  // tmcssetypos(mark^.objnum,tmcsgetypos(mark^.objnum) - (cos((mark^.repax+90)*pi/180)/10) * 0.01);
  // tmcssetzpos(mark^.objnum,tmcsgetzpos(mark^.objnum) + (sin((mark^.repay+90)*pi/180)/10)*(1-(tmp*tmp)) * 0.01);

  obj := collgetattachedobject(colliding);
  subobj := collgetattachedsubobject(colliding);
  scaling := 100/tmcsGetScaling(obj);

  if ( collGetZoneType(colliding) = ctBox ) then
    begin
      if ( (tmcsGetSubXPos(obj_map,subobj)-tmcsGetSubSizeX(obj_map,subobj)/2)/scaling >= bullet^.opos.x ) then
        begin // a marknak balra kell néznie
          tmcsyrotateobject(mark^.objnum,90);
          distx := (tmcsGetSubXPos(obj_map,subobj)-tmcsGetSubSizeX(obj_map,subobj)/2)/scaling - bullet^.opos.x;
          tmcssetxpos(mark^.objnum,bullet^.opos.x + distx - GAME_MARKS_DISTFROMWALLS);
          tmcssetypos(mark^.objnum,bullet^.opos.y);
          tmcssetzpos(mark^.objnum,bullet^.opos.z);
        end
       else if ( (tmcsGetSubXPos(obj_map,subobj)+tmcsGetSubSizeX(obj_map,subobj)/2)/scaling <= bullet^.opos.x ) then
        begin // a marknak jobbra kell néznie
          tmcsyrotateobject(mark^.objnum,-90);
          distx := bullet^.opos.x - (tmcsGetSubXPos(obj_map,subobj)+tmcsGetSubSizeX(obj_map,subobj)/2)/scaling;
          tmcssetxpos(mark^.objnum,bullet^.opos.x - distx + GAME_MARKS_DISTFROMWALLS);
          tmcssetypos(mark^.objnum,bullet^.opos.y);
          tmcssetzpos(mark^.objnum,bullet^.opos.z);
        end
       else if ( (tmcsGetSubYPos(obj_map,subobj)-tmcsGetSubSizeY(obj_map,subobj)/2)/scaling >= bullet^.opos.y ) then
        begin // a marknak lefele kell néznie
          tmcszrotateobject(mark^.objnum,-90);
          disty := (tmcsGetSubYPos(obj_map,subobj)-tmcsGetSubSizeY(obj_map,subobj)/2)/scaling - bullet^.opos.y;
          tmcssetxpos(mark^.objnum,bullet^.opos.x);
          tmcssetypos(mark^.objnum,bullet^.opos.y + disty - GAME_MARKS_DISTFROMWALLS);
          tmcssetzpos(mark^.objnum,bullet^.opos.z);
        end
       else if ( (tmcsGetSubYPos(obj_map,subobj)+tmcsGetSubSizeY(obj_map,subobj)/2)/scaling <= bullet^.opos.y ) then
        begin // a marknak felfele kell néznie
          tmcszrotateobject(mark^.objnum,90);
          disty := bullet^.opos.y - (tmcsGetSubYPos(obj_map,subobj)+tmcsGetSubSizeY(obj_map,subobj)/2)/scaling;
          tmcssetxpos(mark^.objnum,bullet^.opos.x);
          tmcssetypos(mark^.objnum,bullet^.opos.y - disty + GAME_MARKS_DISTFROMWALLS);
          tmcssetzpos(mark^.objnum,bullet^.opos.z);
        end
       else if ( (-tmcsGetSubZPos(obj_map,subobj)+tmcsGetSubSizeZ(obj_map,subobj)/2)/scaling <= bullet^.opos.z ) then
        begin // a marknak elõre kell néznie
          tmcszrotateobject(mark^.objnum,180);
          distz := bullet^.opos.z - (-tmcsGetSubZPos(obj_map,subobj)+tmcsGetSubSizeZ(obj_map,subobj)/2)/scaling;
          tmcssetxpos(mark^.objnum,bullet^.opos.x);
          tmcssetypos(mark^.objnum,bullet^.opos.y);
          tmcssetzpos(mark^.objnum,bullet^.opos.z - distz + GAME_MARKS_DISTFROMWALLS);
        end
       else if ( (-tmcsGetSubZPos(obj_map,subobj)-tmcsGetSubSizeZ(obj_map,subobj)/2)/scaling >= bullet^.opos.z ) then
        begin // a marknak hátrafele kell néznie (nem kell elforgatni, jó irányba néz)
          distz := (-tmcsGetSubZPos(obj_map,subobj)-tmcsGetSubSizeZ(obj_map,subobj)/2)/scaling - bullet^.opos.z;
          tmcssetxpos(mark^.objnum,bullet^.opos.x);
          tmcssetypos(mark^.objnum,bullet^.opos.y);
          tmcssetzpos(mark^.objnum,bullet^.opos.z + distz - GAME_MARKS_DISTFROMWALLS);
        end;
    end
   else if ( collGetZoneType(colliding) = ctCylindrical ) then
    begin
      if ( (tmcsGetSubYPos(obj_map,subobj)-tmcsGetSubSizeY(obj_map,subobj)/2)/scaling >= bullet^.opos.y ) then
        begin // a marknak lefele kell néznie
          tmcszrotateobject(mark^.objnum,-90);
          disty := (tmcsGetSubYPos(obj_map,subobj)-tmcsGetSubSizeY(obj_map,subobj)/2)/scaling - bullet^.opos.y;
          tmcssetxpos(mark^.objnum,bullet^.opos.x);
          tmcssetypos(mark^.objnum,bullet^.opos.y + disty - GAME_MARKS_DISTFROMWALLS);
          tmcssetzpos(mark^.objnum,bullet^.opos.z);
        end
       else if ( (tmcsGetSubYPos(obj_map,subobj)+tmcsGetSubSizeY(obj_map,subobj)/2)/scaling <= bullet^.opos.y ) then
        begin // a marknak felfele kell néznie
          tmcszrotateobject(mark^.objnum,90);
          disty := bullet^.opos.y - (tmcsGetSubYPos(obj_map,subobj)+tmcsGetSubSizeY(obj_map,subobj)/2)/scaling;
          tmcssetxpos(mark^.objnum,bullet^.opos.x);
          tmcssetypos(mark^.objnum,bullet^.opos.y - disty + GAME_MARKS_DISTFROMWALLS);
          tmcssetzpos(mark^.objnum,bullet^.opos.z);
        end
       else
        begin // a marknak oldalra kell néznie, annak függvényében, h merre van az oszlop középpontjától
          distx := bullet^.opos.x - (tmcsGetSubXPos(obj_map,subobj)-tmcsGetSubSizeX(obj_map,subobj)/2)/scaling;
          distz := bullet^.opos.z - (-tmcsGetSubZPos(obj_map,subobj)-tmcsGetSubSizeZ(obj_map,subobj)/2)/scaling;
          tmcssetxpos(mark^.objnum,bullet^.opos.x + distx);
          tmcssetypos(mark^.objnum,bullet^.opos.y);
          tmcssetzpos(mark^.objnum,bullet^.opos.z + distz);
        end;
    end;
  if ( collTestBoxCollisionAgainstZone(tmcsgetxpos(mark^.objnum),tmcsgetypos(mark^.objnum),tmcsgetzpos(mark^.objnum),tmcsgetsizex(mark^.objnum),tmcsgetsizey(mark^.objnum),0.01,colliding,0) ) then
    mark^.repositioning := FALSE
   else
    mark^.repositioning := TRUE;
  mark^.createtime := gettickcount();
end;

procedure Impulse(x,y,z: single; force: single; owner: integer);
var
  alfa: single;
  newimpx,newimpy,newimpz: single;
  i,dmg: integer;
  c,cy,factor_px,factor_py,factor_pz: single;
  factor_impulsepx,factor_impulsepy,factor_impulsepz: single;
  oldhealth,newhealth: integer;
begin
  for i := -1 to botsGetBotsCount()-1 do
    begin
      if ( i = -1 ) then
        begin
          factor_px := player.px;
          factor_py := player.py;
          factor_pz := player.pz;
          factor_impulsepx := player.impulsepx;
          factor_impulsepy := player.impulsepy;
          factor_impulsepz := player.impulsepz;
          oldhealth := player.health;
        end
       else
        begin
          factor_px := botsGetAttribFloat(i,baPX);
          factor_py := botsGetAttribFloat(i,baPY);
          factor_pz := botsGetAttribFloat(i,baPZ);
          factor_impulsepx := botsGetAttribFloat(i,baImpulsePX);
          factor_impulsepy := botsGetAttribFloat(i,baImpulsePY);
          factor_impulsepz := botsGetAttribFloat(i,baImpulsePZ);
          oldhealth := botsGetAttribInt(i,baHealth);
        end;

      if ( oldhealth > 0 ) then
        begin
          alfa := mapGetAngleYFromAToB(factor_px,factor_pz,x,z);
          c := sqrt( sqr(x-factor_px) + sqr(z-factor_pz) );
          cy := y - factor_py;
          if ( (abs(c) < GAME_ROCKET_XPLOSION_IMPULSE_DIST) and (abs(cy) < GAME_ROCKET_XPLOSION_IMPULSE_DIST) ) then
            begin
              if ( cy = 0.0 ) then cy := 0.01;
              newimpx := ((cos( (alfa)*pi/180 )*force) / (GAME_ROCKET_XPLOSION_IMPULSE_DIST/(GAME_ROCKET_XPLOSION_IMPULSE_DIST-c)/1.3)) * 90/fps;
              newimpy := (((force/cy)*2) / (GAME_ROCKET_XPLOSION_IMPULSE_DIST/(GAME_ROCKET_XPLOSION_IMPULSE_DIST-c)/4)) * 90/fps;
              newimpz := ((sin( (alfa)*pi/180 )*force) / (GAME_ROCKET_XPLOSION_IMPULSE_DIST/(GAME_ROCKET_XPLOSION_IMPULSE_DIST-c)/1.3)) * 90/fps;
              factor_impulsepx := factor_impulsepx - newimpx;
              factor_impulsepy := factor_impulsepy - newimpy;
              factor_impulsepz := factor_impulsepz - newimpz;
              dmg := round((abs(newimpx)+abs(newimpy)+abs(newimpz))*(fps/2));
              damagetoplayer(i,round(dmg*GAME_ROCKET_XPLOSION_IMPULSE_DMG),TRUE);
              if ( i = -1 ) then
                begin
                  newhealth := player.health;
                end
               else
                begin
                  newhealth := botsGetAttribInt(i,baHealth);
                  if ( botsGetAttribInt(i,baTarget) = -2 ) then
                    botsSetAttribInt(i,baTarget,owner);
                end;
              if ( newhealth = 0 ) then
                begin
                  if ( getteamnum(owner) = getteamnum(i) ) then
                    subtractfrag(owner)
                   else addfrag(owner);
                  adddeath(i);
                  neweventtext(getplayername2(owner),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(i),gettickcount(),colorbyplayer(owner+1),colorbyplayer(i+1));
                end;
            end;
          if ( hasQuadDmg(owner) ) then
            begin
              factor_impulsepx := factor_impulsepx*4;
              factor_impulsepy := factor_impulsepy*4;
              factor_impulsepz := factor_impulsepz*4;
            end;
          if ( factor_impulsepx > fps/35 ) then factor_impulsepx := fps/35
            else if ( factor_impulsepx < -fps/35 ) then factor_impulsepx := -fps/35;
          if ( factor_impulsepy > fps/35 ) then factor_impulsepy := fps/35
            else if ( factor_impulsepy < -fps/35 ) then factor_impulsepy := -fps/35;
          if ( factor_impulsepz > fps/35 ) then factor_impulsepz := fps/35
            else if ( factor_impulsepz < -fps/35 ) then factor_impulsepz := -fps/35;
          if ( i = -1 ) then
            begin
              player.impulsepx := factor_impulsepx;
              player.impulsepy := factor_impulsepy;
              player.impulsepz := factor_impulsepz;
            end
           else
            begin
              botsSetAttribfloat(i,baImpulsePX,factor_impulsepx);
              botsSetAttribfloat(i,baImpulsePY,factor_impulsepy);
              botsSetAttribfloat(i,baImpulsePZ,factor_impulsepz);
            end;
        end; // oldhealth > 0
    end;
end;

procedure NewXplosion(x,y,z: single; scndry: boolean; owner: integer);
begin
  new(xplosion);
  xplosions.Add(xplosion);
  xplosion^.objnum := tmcsCreateClonedObject(obj_xplosion);
  tmcsshowobject(xplosion^.objnum);
  xplosion^.secondary := scndry;
  xplosion^.owner := owner;
  tmcsSetXPos(xplosion^.objnum,x);
  tmcsSetYPos(xplosion^.objnum,y);
  tmcsSetZPos(xplosion^.objnum,z);
  tmcsyrotateobject(xplosion^.objnum,tmcsgetcameraangley());
  if ( not(scndry) ) then
    begin
      Impulse(x,y,z,(GAME_ROCKET_XPLOSION_IMPULSE/90)*fps*1.2,owner);
      if (settings^.audio_sfx) then
        begin
          snd_pos.x := x;
          snd_pos.y := y;
          snd_pos.z := z;
          if ( random(2) = 0) then sndchn := FSOUND_playsoundex(FSOUND_free,snd_xplosion,nil,TRUE)
            else sndchn := FSOUND_playsoundex(FSOUND_free,snd_xplosion2,nil,TRUE);
          FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
          FSOUND_setpaused(sndchn,FALSE);
        end;
    end;
end;

procedure DeleteXplosion(index: integer);
var
  xplosion: PXplosion;
begin
  xplosion := xplosions[index];
  if ( assigned(xplosion) ) then
    begin
      tmcsdeleteobject(xplosion^.objnum);
      dispose(xplosion);
      xplosions[index] := nil;
    end;
end;

procedure DeleteXplosions;
var
  i: integer;
begin
  for i := 0 to xplosions.Count-1 do
    DeleteXplosion(i);
  xplosions.Free;
end;

procedure XplosionsProc;
var
  i: integer;
  tmp: single;
begin
  for i := 0 to xplosions.Count-1 do
    begin
      if ( assigned(xplosions[i]) ) then
        begin
          xplosion := xplosions[i];
          if ( tmcsGetScaling(xplosion^.objnum) < GAME_ROCKET_XPLOSION_STOPSCALE ) then
            begin
              tmcsScaleObjectAbsolute(xplosion^.objnum,tmcsGetScaling(xplosion^.objnum)+round((100*GAME_ROCKET_XPLOSION_SCALESPEED)/fps));
              tmp := tmcsGetScaling(xplosion^.objnum)/GAME_ROCKET_XPLOSION_STOPSCALE;
              if ( tmp > 1 ) then tmp := 1
                else if ( (tmp > 0.35) and (tmp < 0.45) ) then
                       begin
                         if ( not(xplosion^.secondary) ) then
                           Newxplosion(tmcsgetxpos(xplosion^.objnum),tmcsgetypos(xplosion^.objnum),tmcsgetzpos(xplosion^.objnum),TRUE,xplosion^.owner);
                       end;
              tmcsSetObjectColorKey(xplosion^.objnum,255-round(255*tmp),255-round(255*tmp),255-round(255*tmp),255);
            end
           else
            begin
              DeleteXplosion(i);
            end;
        end;
    end;
end;

procedure DeleteBullet(index: integer);
var
  bullet: pbullet;
begin
  bullet := bullets[index];
  if ( assigned(bullet) ) then
    begin
      tmcsdeleteobject(bullet^.objnum);
      dispose(bullet);
      bullets[index] := nil;
    end;
end;

procedure DeleteBullets;
var
  i: integer;
begin
  for i := 0 to bullets.Count-1 do
    DeleteBullet(i);
  bullets.Free;
end;

// lövedék kezelõ eljárás
procedure BulletsProc;
var
  i,colliding: integer;
  tmp: single;
  j,k: integer;
  botnum: integer;
  maxroute: single;
  ckey: TRGB;
  blend_s,blend_d: TGLConst;
begin
  case settings^.reserved2 of
    1: maxroute := 20.0;
    2: maxroute := 5.0;
    3: maxroute := 2.0;
  end;
  for i := 0 to bullets.Count-1 do
    begin
      bullet := bullets[i];
      if ( assigned(bullet) ) then
        begin
          bullet^.opos := bullet^.pos;
          tmp := abs(bullet^.ax)/90;

          colliding := -1;
          j := 0;
          while ( (colliding = -1) and (j < GAME_BULLET_MOVEMENT_SUBDIVISION) and (assigned(bullet)) ) do
            begin
              j := j+1;
              bullet^.pos.x := bullet^.pos.x - (cos((bullet^.ay+90)*pi/180)/10)*(1-(tmp*tmp))*(bullet^.speed*(80/(fps*GAME_BULLET_MOVEMENT_SUBDIVISION)));
              bullet^.pos.y := bullet^.pos.y - (cos((bullet^.ax+90)*pi/180)/10)*(bullet^.speed*(80/(fps*GAME_BULLET_MOVEMENT_SUBDIVISION)));
              bullet^.pos.z := bullet^.pos.z + (sin((bullet^.ay+90)*pi/180)/10)*(1-(tmp*tmp))*(bullet^.speed*(80/(fps*GAME_BULLET_MOVEMENT_SUBDIVISION)));
              tmcssetxpos(bullet^.objnum, bullet^.pos.x);
              tmcssetypos(bullet^.objnum, bullet^.pos.y);
              tmcssetzpos(bullet^.objnum, bullet^.pos.z);
              bullet^.movecount := bullet^.movecount + 1;
              if ( bullet^.ownerwpn = 3 ) then
                begin
                  if ( settings^.reserved2 > 0 ) then
                    begin
                      bullet^.routelength := bullet^.routelength + sqrt(sqr(bullet^.pos.x-bullet^.opos.x)+sqr(bullet^.pos.y-bullet^.opos.y)+sqr(bullet^.pos.z-bullet^.opos.z));
                      if ( bullet^.routelength >= maxroute ) then
                        begin
                          bullet^.routelength := 0.0;
                          NewSmoke(GAME_ROCKET_SMOKE_STARTSIZE,GAME_ROCKET_SMOKE_STARTSIZE,
                                   bullet^.pos.x,bullet^.pos.y,bullet^.pos.z,bullet^.ax,bullet^.ay,TRUE,255,255,255,gl_src_color,gl_one_minus_src_color);
                        end;
                    end;
                  if ( bullet^.movecount = ((PLAYER_WPN_ROCKETLAUNCHER_STEPS_TO_SHOW_COUNT*fps) div 210)+2 )
                    then tmcsshowobject(bullet^.objnum);
                end;
              colliding := collIsAreaInZone(bullet^.pos.x,bullet^.pos.y,bullet^.pos.z,bullet^.sizex,bullet^.sizey,bullet^.sizez,0);
              if ( (colliding > -1) and not(mapIsAnItemObject(collGetAttachedObject(colliding))) ) then  // itemekre nem hatnak a lövedékek
                begin
                  if ( bullet^.ownerplayer <> botsBotFromCollZone(colliding) ) then // arra sem hat a lövedék, akié a lövedék, tehát pl 5. csigára nem hatnak 5-ös ownerrel rendlekezõ bulletek
                    begin
                      if ( collTestBoxCollisionAgainstZone(bullet^.pos.x,bullet^.pos.y,bullet^.pos.z,bullet^.sizex,bullet^.sizey,bullet^.sizez,colliding,0) ) then
                        begin
                          if ( collgetzonetype(colliding) in [ctSlopeN,ctSlopeS,ctSlopeW,ctSlopeE] ) then
                            begin  // slope collision
                              if ( bullet^.ownerwpn in [1,2] ) then
                                begin
                                  DeleteBullet(i);
                                end
                               else
                                begin
                                  NewXplosion(bullet^.pos.x,bullet^.pos.y,bullet^.pos.z,FALSE,bullet^.ownerplayer);
                                  DeleteBullet(i);
                                end;
                            end
                           else
                            begin // másfajta collision
                              if ( collgetzonetype(colliding) = ctBox ) then
                                begin
                                  if ( bullet^.ownerwpn in [1,2] ) then
                                    begin
                                      if ( collgetattachedobject(colliding) = obj_map ) then
                                        begin
                                          if ( settings^.video_marksonwalls ) then NewMark(bullet,colliding);
                                        end;

                                      botnum := botsBotFromCollZone(colliding);
                                      if ( botnum > -1 ) then
                                        begin  // találat ért egy botot
                                          if ( botsGetAttribInt(botnum,baTarget) = -2 ) then
                                            botsSetAttribInt(botnum,baTarget,bullet^.ownerplayer);
                                          if ( bullet^.ownerwpn = 1 ) then
                                            begin
                                              if ( hasQuadDmg(bullet^.ownerplayer) ) then
                                                DamageToPlayer(botnum,GAME_WPN_PISTOL_BULLET_DMG*4,TRUE)
                                               else
                                                DamageToPlayer(botnum,GAME_WPN_PISTOL_BULLET_DMG,TRUE);
                                              if (settings^.audio_sfx) then
                                                begin
                                                  sndchn := FSOUND_playsoundex(FSOUND_free,snd_dmg1,nil,TRUE);
                                                  FSOUND_3d_setattributes(sndchn,@bullet^.pos,nil);
                                                  FSOUND_setpaused(sndchn,FALSE);
                                                end;
                                            end
                                           else
                                            begin
                                              if ( hasQuadDmg(bullet^.ownerplayer) ) then
                                                DamageToPlayer(botnum,GAME_WPN_MCHGUN_BULLET_DMG*4,TRUE)
                                               else
                                                DamageToPlayer(botnum,GAME_WPN_MCHGUN_BULLET_DMG,TRUE);
                                              if (settings^.audio_sfx) then
                                                begin
                                                  sndchn := FSOUND_playsoundex(FSOUND_free,snd_dmg1,nil,TRUE);
                                                  FSOUND_3d_setattributes(sndchn,@bullet^.pos,nil);
                                                  FSOUND_setpaused(sndchn,FALSE);
                                                end;
                                            end;
                                          if ( (settings^.game_showblood) and (settings^.reserved2 > 0) ) then
                                            begin
                                              if ( botsisbot(botnum,botSnail) ) then
                                                begin
                                                  ckey.red := 0;
                                                  ckey.green := 200;
                                                  ckey.blue := 0;
                                                  blend_s := gl_src_alpha;
                                                  blend_d := gl_one;
                                                end
                                               else
                                                begin
                                                  ckey.red := 255;
                                                  ckey.green := 255;
                                                  ckey.blue := 255;
                                                  blend_s := gl_src_color;
                                                  blend_d := gl_one_minus_src_color;
                                                end;
                                              for k := 1 to 2 do
                                                newsmoke(BOTS_DMG_BLOOD_SIZE,BOTS_DMG_BLOOD_SIZE,
                                                       bullet^.pos.x,bullet^.pos.y,bullet^.pos.z,bullet^.ax,bullet^.ay,FALSE,ckey.red,ckey.green,ckey.blue,blend_s,blend_d);
                                            end;
                                          if ( botsgetattribint(botnum,bahealth) = 0 ) then
                                            begin
                                              if ( botsgetattribint(botnum,baTeamNum) = getteamnum(bullet^.ownerplayer) ) then
                                                subtractfrag(bullet^.ownerplayer)
                                               else
                                                addfrag(bullet^.ownerplayer);
                                              adddeath(botnum);
                                              neweventtext(getplayername2(bullet^.ownerplayer),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(botnum),gettickcount(),colorbyplayer(bullet^.ownerplayer+1),colorbyplayer(botnum+1));
                                            end;
                                        end;
                                      DeleteBullet(i);
                                    end
                                   else
                                    begin
                                      NewXplosion(bullet^.pos.x,bullet^.pos.y,bullet^.pos.z,FALSE,bullet^.ownerplayer);
                                      botnum := botsBotFromCollZone(colliding);
                                      if ( (botnum > -1) and (botsgetattribint(botnum,bahealth) > 0) ) then
                                        begin  // találat ért egy botot
                                          if ( hasQuadDmg(bullet^.ownerplayer) ) then
                                            DamageToPlayer(botnum,GAME_WPN_ROCKETLAUNCHER_BULLET_DMG*4,TRUE)
                                           else
                                            DamageToPlayer(botnum,GAME_WPN_ROCKETLAUNCHER_BULLET_DMG,TRUE);
                                          if ( botsgetattribint(botnum,bahealth) = 0 ) then
                                            begin
                                              if (settings^.audio_sfx) then
                                                begin
                                                  sndchn := FSOUND_playsoundex(FSOUND_free,snd_splat,nil,TRUE);
                                                  FSOUND_3d_setattributes(sndchn,@bullet^.pos,nil);
                                                  FSOUND_setpaused(sndchn,FALSE);
                                                end;
                                              if ( botsgetattribint(botnum,baTeamNum) = getteamnum(bullet^.ownerplayer) ) then
                                                subtractfrag(bullet^.ownerplayer)
                                               else
                                                addfrag(bullet^.ownerplayer);
                                              adddeath(botnum);
                                              neweventtext(getplayername2(bullet^.ownerplayer),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(botnum),gettickcount(),colorbyplayer(bullet^.ownerplayer+1),colorbyplayer(botnum+1));
                                            end;
                                        end;
                                      DeleteBullet(i);
                                    end;
                                end
                               else
                                if ( collgetzonetype(colliding) = ctCylindrical ) then
                                  begin
                                    if ( bullet^.ownerwpn in [1,2] ) then
                                      begin
                                        //if ( settings^.video_marksonwalls and (collGetAttachedObject(colliding) = obj_map) ) then
                                          //NewMark(bullet,colliding);
                                        DeleteBullet(i);
                                      end
                                     else
                                      begin
                                        NewXplosion(bullet^.pos.x,bullet^.pos.y,bullet^.pos.z,FALSE,bullet^.ownerplayer);
                                        DeleteBullet(i);
                                      end;
                                  end
                                 else
                                  if ( collgetzonetype(colliding) = ctSpherical ) then
                                    begin

                                    end;
                            end;
                        end;  // (colliding = -1) and (j < GAME_BULLET_MOVEMENT_SUBDIVISION)
                    end
                end  // colliding > -1
               else
                begin
                  if ( (bullet^.pos.x <= -mapGetSizeX()*2) or (bullet^.pos.x >= mapGetSizeX()*2)
                                                          or
                       (bullet^.pos.y <= -mapGetSizeY()*2) or (bullet^.pos.y >= mapGetSizeY()*2)
                                                          or
                       (bullet^.pos.z <= -mapGetSizeZ()*2) or (bullet^.pos.z >= mapGetSizeZ()*2)
                     ) then  //  a lövedék már messze jár a pályától, hát töröljük
                        begin
                          DeleteBullet(i);
                          bullet := bullets[i];
                        end
                       else
                        begin  // ütközik-e a lövedék a playerrel
                          if ( bullet^.ownerplayer > -1 ) then
                            begin
                              if ( ( (bullet^.pos.x >= player.opx-PLAYER_SIZEX/2) and (bullet^.pos.x <= player.opx+PLAYER_SIZEX/2) )
                                                                                 and
                                   ( (bullet^.pos.y >= player.opy-PLAYER_SIZEY/2) and (bullet^.pos.y <= player.opy+PLAYER_SIZEY/2) )
                                                                                 and
                                   ( (bullet^.pos.z >= player.opz-PLAYER_SIZEZ/2) and (bullet^.pos.z <= player.opz+PLAYER_SIZEZ/2) )
                               ) then
                                  begin
                                    if ( player.health > 0 ) then
                                      begin
                                        case bullet^.ownerwpn of
                                          1: begin
                                               if ( hasQuadDmg(bullet^.ownerplayer) ) then
                                                 DamageToPlayer(-1,GAME_WPN_PISTOL_BULLET_DMG*4,TRUE)
                                                else
                                                 DamageToPlayer(-1,GAME_WPN_PISTOL_BULLET_DMG,TRUE);
                                               if (settings^.audio_sfx) then
                                                 begin
                                                   sndchn := FSOUND_playsoundex(FSOUND_free,snd_dmg1,nil,TRUE);
                                                   FSOUND_3d_setattributes(sndchn,@bullet^.pos,nil);
                                                   FSOUND_setpaused(sndchn,FALSE);
                                                 end;
                                               if ( player.health = 0 ) then
                                                 begin
                                                   if ( getteamnum(bullet^.ownerplayer) = player.teamnum ) then
                                                     subtractfrag(bullet^.ownerplayer)
                                                    else addfrag(bullet^.ownerplayer);
                                                   adddeath(-1);
                                                   neweventtext(getplayername2(bullet^.ownerplayer),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(-1),gettickcount(),colorbyplayer(bullet^.ownerplayer+1),colorbyplayer(0));
                                                 end;
                                             end;
                                          2: begin
                                               if ( hasQuadDmg(bullet^.ownerplayer) ) then
                                                 DamageToPlayer(-1,GAME_WPN_MCHGUN_BULLET_DMG*4,TRUE)
                                                else
                                                 DamageToPlayer(-1,GAME_WPN_MCHGUN_BULLET_DMG,TRUE);
                                               if (settings^.audio_sfx) then
                                                 begin
                                                   sndchn := FSOUND_playsoundex(FSOUND_free,snd_dmg1,nil,TRUE);
                                                   FSOUND_3d_setattributes(sndchn,@bullet^.pos,nil);
                                                   FSOUND_setpaused(sndchn,FALSE);
                                                 end;
                                               if ( player.health = 0 ) then
                                                 begin
                                                   if ( getteamnum(bullet^.ownerplayer) = player.teamnum ) then
                                                     subtractfrag(bullet^.ownerplayer)
                                                    else addfrag(bullet^.ownerplayer);
                                                   adddeath(-1);
                                                   neweventtext(getplayername2(bullet^.ownerplayer),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(-1),gettickcount(),colorbyplayer(bullet^.ownerplayer+1),colorbyplayer(0));
                                                 end;
                                             end;
                                          3: begin
                                               NewXplosion(bullet^.pos.x,bullet^.pos.y,bullet^.pos.z,FALSE,bullet^.ownerplayer);
                                               if ( player.health > 0 ) then
                                                 begin
                                                   if ( hasQuadDmg(bullet^.ownerplayer) ) then
                                                     DamageToPlayer(-1,GAME_WPN_ROCKETLAUNCHER_BULLET_DMG*4,TRUE)
                                                    else
                                                     DamageToPlayer(-1,GAME_WPN_ROCKETLAUNCHER_BULLET_DMG,TRUE);
                                                   if ( player.health = 0 ) then
                                                     begin
                                                       if (settings^.audio_sfx) then
                                                         begin
                                                           sndchn := FSOUND_playsoundex(FSOUND_free,snd_splat,nil,TRUE);
                                                           FSOUND_3d_setattributes(sndchn,@bullet^.pos,nil);
                                                           FSOUND_setpaused(sndchn,FALSE);
                                                         end;
                                                       if ( getteamnum(bullet^.ownerplayer) = player.teamnum ) then
                                                         subtractfrag(bullet^.ownerplayer)
                                                        else
                                                         addfrag(bullet^.ownerplayer);
                                                       adddeath(-1);
                                                       neweventtext(getplayername2(bullet^.ownerplayer),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(-1),gettickcount(),colorbyplayer(bullet^.ownerplayer+1),colorbyplayer(0));
                                                     end;
                                                 end;
                                             end;
                                        end;
                                        DeleteBullet(i);
                                        bullet := bullets[i];
                                      end;
                                  end;
                            end;  // bullet^.ownerplayer > -1
                        end;
                end;
          end;  //
        end;  // assigned(bullets[i])
    end;  // i ciklus
end;

procedure DeleteMark(index: integer);
var
  mark: pmark;
begin
  mark := marks[index];
  if ( assigned(mark) ) then
    begin
      tmcsdeleteobject(mark^.objnum);
      dispose(mark);
      marks[index] := nil;
    end;
end;

procedure DeleteMarks;
var
  i: integer;
begin
  for i := 0 to marks.Count-1 do
    DeleteMark(i);
  marks.Free;
end;

// lövedéknyomokat kezelõ eljárás
procedure MarksProc;
var
  i,colliding,subobj: integer;
  tmp,scaling: single;
begin
  for i := 0 to marks.Count-1 do
    begin
      mark := marks[i];
      if ( assigned(mark) ) then
        begin
          tmp := abs(mark^.repax)/90;
          if ( mark^.repositioning ) then
            begin
              tmcssetxpos(mark^.objnum,tmcsgetxpos(mark^.objnum) - (cos((mark^.repay+90)*pi/180)/10)*(1-(tmp*tmp)) * GAME_MARKS_REPOSITIONING_SPEED);
              tmcssetypos(mark^.objnum,tmcsgetypos(mark^.objnum) - (cos((mark^.repax+90)*pi/180)/10) * GAME_MARKS_REPOSITIONING_SPEED);
              tmcssetzpos(mark^.objnum,tmcsgetzpos(mark^.objnum) + (sin((mark^.repay+90)*pi/180)/10)*(1-(tmp*tmp)) * GAME_MARKS_REPOSITIONING_SPEED);
              colliding := collIsAreaInZone(tmcsgetxpos(mark^.objnum),tmcsgetypos(mark^.objnum),tmcsgetzpos(mark^.objnum),tmcsgetsizex(mark^.objnum),tmcsgetsizey(mark^.objnum),0.01,0);
              if ( colliding > -1 ) then
                begin
                  subobj := collgetattachedsubobject(colliding);
                  scaling := 100/tmcsGetScaling(obj_map);
                  mark^.repositioning := FALSE;
                  // utólag, már a végleges pozíciónál is elforgatunk, mert az elsõ elforgatásnál a szélek közelében hibás
                  // irányszöget kaphattunk...
                  if ( (tmcsGetSubXPos(obj_map,subobj)-tmcsGetSubSizeX(obj_map,subobj)/2)/scaling >= tmcsgetxpos(mark^.objnum) ) then
                    tmcsyrotateobject(mark^.objnum,90)
                   else if ( (tmcsGetSubXPos(obj_map,subobj)+tmcsGetSubSizeX(obj_map,subobj)/2)/scaling <= tmcsgetxpos(mark^.objnum) ) then
                    tmcsyrotateobject(mark^.objnum,-90)
                   else if ( (tmcsGetSubYPos(obj_map,subobj)-tmcsGetSubSizeY(obj_map,subobj)/2)/scaling >= tmcsgetypos(mark^.objnum) ) then
                    tmcszrotateobject(mark^.objnum,-90)
                   else if ( (tmcsGetSubYPos(obj_map,subobj)+tmcsGetSubSizeY(obj_map,subobj)/2)/scaling <= tmcsgetypos(mark^.objnum) ) then
                    tmcszrotateobject(mark^.objnum,90)
                   else if ( (-tmcsGetSubZPos(obj_map,subobj)+tmcsGetSubSizeZ(obj_map,subobj)/2)/scaling <= tmcsgetzpos(mark^.objnum) ) then
                    tmcszrotateobject(mark^.objnum,180)
                end;  // colliding > -1
            end;  // mark^.repositioning
          if ( (gettickcount() - GAME_MARKS_FREEZETIME) >= mark^.createtime ) then DeleteMark(i);
        end;  // assigned(mark)
    end;  // i ciklus
end;

{
__        __
\ \      / /__  __ _ _ __   ___  _ __  ___
 \ \ /\ / / _ \/ _` | '_ \ / _ \| '_ \/ __|
  \ V  V /  __/ (_| | |_) | (_) | | | \__ \
   \_/\_/ \___|\__,_| .__/ \___/|_| |_|___/
                    |_|
}
procedure BuildWpnPistol;
var
  i: integer;
begin
  obj_wpn_pistol := tmcsCreateObjectFromFile(GAME_PATH_WPNS+'pistol\pistol.obj',FALSE);
  tmcsscaleobject(obj_wpn_pistol,GAME_WPN_SCALING);
  tmcsSetObjectLit(obj_wpn_pistol,FALSE);
  tmcsSetObjectRotationYXZ(obj_wpn_pistol);
  if ( settings^.video_lightmaps ) then
    begin
      obj_junk1 := tmcscreateobjectfromfile(GAME_PATH_WPNS+'pistol\pistol_lm.obj',FALSE);
      if ( obj_junk1 > -1 ) then
        begin
          tmcsSetObjectLit(obj_junk1,FALSE);
          tmcsHideObject(obj_junk1);
          tmcsSetObjectBlendMode(obj_wpn_pistol,GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
          tmcsSetObjectMultitextured(obj_wpn_pistol);
          tmcsMultiTexAssignObject(obj_wpn_pistol,obj_junk1);
        end;
    end;
  for i := 0 to tmcsgetnumsubobjects(obj_wpn_pistol)-1 do
    begin
      if ( pos('hidehide',tmcsgetsubname(obj_wpn_pistol,i)) > 0 ) then tmcshidesubobject(obj_wpn_pistol,i);
    end;
  tmcsCompileObject(obj_wpn_pistol);
  tmcsHideObject(obj_wpn_pistol);
  obj_wpn_pistolmuzzle := tmcsCreateObjectFromFile(GAME_PATH_WPNS+'pistol\pistol_muzzle.obj',TRUE);
  tmcsSetObjectRotationYXZ(obj_wpn_pistolmuzzle);
  if ( obj_wpn_pistolmuzzle > -1 ) then
    begin
      tmcsscaleobject(obj_wpn_pistolmuzzle,GAME_WPN_SCALING);
      tmcsSetObjectLit(obj_wpn_pistolmuzzle,FALSE);
      tmcssetobjectblending(obj_wpn_pistolmuzzle,TRUE);
      tmcssetobjectblendmode(obj_wpn_pistolmuzzle,gl_one,gl_one);
      tmcshideobject(obj_wpn_pistolmuzzle);
    end;
end;

procedure BuildWpnMchGun;
var
  i: integer;

procedure BuildLCD;
var
  i: integer;
begin
  obj_wpn_mchgunlcd1 := tmcsCreateObjectFromFile(GAME_PATH_WPNS+'mchgun\mchgun_lcd1.obj',FALSE);
  tmcsSetObjectRotationYXZ(obj_wpn_mchgunlcd1);
  tmcsscaleobject(obj_wpn_mchgunlcd1,GAME_WPN_SCALING);
  tmcssetobjectlit(obj_wpn_mchgunlcd1,FALSE);
  tmcssetobjectblending(obj_wpn_mchgunlcd1,TRUE);
  tmcssetobjectblendmode(obj_wpn_mchgunlcd1,GL_SRC_ALPHA,GL_ONE);
  tmcssetobjectcolorkey(obj_wpn_mchgunlcd1,255,255,255,255);
  tmcshideobject(obj_wpn_mchgunlcd1);
  obj_wpn_mchgunlcd2 := tmcsCreateObjectFromFile(GAME_PATH_WPNS+'mchgun\mchgun_lcd2.obj',FALSE);
  tmcsSetObjectRotationYXZ(obj_wpn_mchgunlcd2);
  tmcsscaleobject(obj_wpn_mchgunlcd2,GAME_WPN_SCALING);
  tmcssetobjectlit(obj_wpn_mchgunlcd2,FALSE);
  tmcssetobjectblending(obj_wpn_mchgunlcd2,TRUE);
  tmcssetobjectblendmode(obj_wpn_mchgunlcd2,GL_SRC_ALPHA,GL_ONE);
  tmcssetobjectcolorkey(obj_wpn_mchgunlcd1,255,255,255,255);
  tmcshideobject(obj_wpn_mchgunlcd2);
  obj_wpn_mchgunlcdwarning :=  tmcsCreateObjectFromFile(GAME_PATH_WPNS+'mchgun\mchgun_lcdwarning.obj',FALSE);
  tmcsSetObjectRotationYXZ(obj_wpn_mchgunlcdwarning);
  tmcsscaleobject(obj_wpn_mchgunlcdwarning,GAME_WPN_SCALING);
  tmcssetobjectlit(obj_wpn_mchgunlcdwarning,FALSE);
  tmcssetobjectblending(obj_wpn_mchgunlcdwarning,TRUE);
  tmcssetobjectblendmode(obj_wpn_mchgunlcdwarning,GL_SRC_ALPHA,GL_ONE);
  tmcssetobjectcolorkey(obj_wpn_mchgunlcdwarning,255,255,255,GAME_WPN_MCHGUN_LCDWARNING_ALPHA_MAX);
  tmcshideobject(obj_wpn_mchgunlcdwarning);
  tmcscompileobject(obj_wpn_mchgunlcdwarning);
  for i := 0 to 9 do
    begin
      tex_wpn_mchgun_lcdnums[i] := tmcsCreateTextureFromFile(GAME_PATH_WPNS+'mchgun\lcdnum'+inttostr(i)+'.bmp',FALSE,FALSE,TRUE,
                                                          GL_LINEAR,GL_DECAL,GL_CLAMP,GL_CLAMP);
    end;
end;

begin
  obj_wpn_mchgun := tmcsCreateObjectFromFile(GAME_PATH_WPNS+'mchgun\mchgun.obj',FALSE);
  tmcsSetObjectRotationYXZ(obj_wpn_mchgun);
  tmcsscaleobject(obj_wpn_mchgun,GAME_WPN_SCALING);
  tmcsSetObjectLit(obj_wpn_mchgun,FALSE);
  if ( settings^.video_lightmaps ) then
    begin
      obj_junk1 := tmcscreateobjectfromfile(GAME_PATH_WPNS+'mchgun\mchgun_lm.obj',FALSE);
      if ( obj_junk1 > -1 ) then
        begin
          tmcsSetObjectLit(obj_junk1,FALSE);
          tmcsHideObject(obj_junk1);
          tmcsSetObjectBlendMode(obj_wpn_mchgun,GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
          tmcsSetObjectMultitextured(obj_wpn_mchgun);
          tmcsMultiTexAssignObject(obj_wpn_mchgun,obj_junk1);
        end;
    end;
  for i := 0 to tmcsgetnumsubobjects(obj_wpn_mchgun)-1 do
    begin
      if ( pos('hidehide',tmcsgetsubname(obj_wpn_mchgun,i)) > 0 ) then tmcshidesubobject(obj_wpn_mchgun,i);
    end;
  tmcsCompileObject(obj_wpn_mchgun);
  tmcshideobject(obj_wpn_mchgun);
  obj_wpn_mchgunmuzzle := tmcsCreateObjectFromFile(GAME_PATH_WPNS+'mchgun\mchgun_muzzle.obj',TRUE);
  if ( obj_wpn_mchgunmuzzle > -1 ) then
    begin
      tmcsSetObjectRotationYXZ(obj_wpn_mchgunmuzzle);
      tmcsscaleobject(obj_wpn_mchgunmuzzle,GAME_WPN_SCALING);
      tmcsSetObjectLit(obj_wpn_mchgunmuzzle,FALSE);
      tmcssetobjectblending(obj_wpn_mchgunmuzzle,TRUE);
      tmcssetobjectblendmode(obj_wpn_mchgunmuzzle,gl_one,gl_one);
      tmcshideobject(obj_wpn_mchgunmuzzle);
    end;
  BuildLCD;
end;

procedure BuildRocketLauncher;
var
  i: integer;
begin
  obj_wpn_rocketlauncher := tmcsCreateObjectFromFile(GAME_PATH_WPNS+'rocketl\rocketl.obj',FALSE);
  tmcsSetObjectRotationYXZ(obj_wpn_rocketlauncher);
  tmcsscaleobject(obj_wpn_rocketlauncher,GAME_WPN_SCALING);
  tmcsSetObjectLit(obj_wpn_rocketlauncher,FALSE);
  if ( settings^.video_lightmaps ) then
    begin
      obj_junk1 := tmcscreateobjectfromfile(GAME_PATH_WPNS+'rocketl\rocketl_lm.obj',FALSE);
      if ( obj_junk1 > -1 ) then
        begin
          tmcsSetObjectLit(obj_junk1,FALSE);
          tmcsHideObject(obj_junk1);
          tmcsSetObjectBlendMode(obj_wpn_rocketlauncher,GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
          tmcsSetObjectMultitextured(obj_wpn_rocketlauncher);
          tmcsMultiTexAssignObject(obj_wpn_rocketlauncher,obj_junk1);
        end;
    end;
  for i := 0 to tmcsgetnumsubobjects(obj_wpn_rocketlauncher)-1 do
    begin
      if ( pos('hidehide',tmcsgetsubname(obj_wpn_rocketlauncher,i)) > 0 ) then tmcshidesubobject(obj_wpn_rocketlauncher,i);
    end;
  tmcsCompileObject(obj_wpn_rocketlauncher);
  tmcshideobject(obj_wpn_rocketlauncher);
  obj_wpn_rocketlaunchermuzzle := -1;
end;

procedure BuildWeapons;
begin
  BuildWpnPistol;
  BuildWpnMchGun;
  BuildRocketLauncher;
end;

procedure WpnSwitchTo(wpn: integer);
begin
  if ( (wpn > 0) and (wpn <= GAME_WPN_MAX) and not(player.wpnsinfo.takingaway) and not(player.wpnsinfo.gettingout) and not(player.wpnsinfo.reloading) ) then
    begin
      if ( player.wpnsinfo.currentwpn <> wpn ) then
        begin
          if (settings^.audio_sfx) then FSOUND_playsound(FSOUND_free,snd_change);
          player.wpnsinfo.takingaway := TRUE;
          player.wpnsinfo.prevwpn := player.wpnsinfo.currentwpn;
          player.wpnsinfo.newwpn := wpn;
          if ( player.wpnsinfo.prevwpn = 2 ) then
            begin
              tmcshideobject(obj_wpn_mchgunlcd1);
              tmcshideobject(obj_wpn_mchgunlcd2);
              tmcshideobject(obj_wpn_mchgunlcdwarning);
            end;
          case wpn of
            1: begin
                 player.wpnsinfo.shotzangle := PLAYER_WPN_PISTOL_SHOTZANGLE;
                 player.wpnsinfo.shotzanglechangespeed := PLAYER_WPN_PISTOL_SHOTZANGLECHANGESPEED;
                 player.wpnsinfo.shotzanglechangespeedafter := PLAYER_WPN_PISTOL_SHOTZANGLECHANGESPEEDAFTER;
                 player.wpnsinfo.shotyanglechangespeedafter := 0.0;
                 player.wpnsinfo.wpnshotbias_angy := 0.0;
                 player.wpnsinfo.wpnshotbias_angy_max := 0.0;
                 player.wpnsinfo.wpnacc := GAME_WPN_PISTOL_ACCURACY;
                 player.wpnsinfo.reloadzangle := PLAYER_WPN_PISTOL_RELOADZANGLE;
                 player.wpnsinfo.reloadzanglechangespeed := PLAYER_WPN_PISTOL_RELOADZANGLECHANGESPEED;
                 player.wpnsinfo.reloadzanglechangespeedafter := PLAYER_WPN_PISTOL_RELOADZANGLECHANGESPEEDAFTER;
                 player.wpnsinfo.wpnreloadbias_angz := 0.0;
               end;
            2: begin
                 player.wpnsinfo.shotzangle := PLAYER_WPN_MCHGUN_SHOTZANGLE;
                 player.wpnsinfo.shotzanglechangespeed := PLAYER_WPN_MCHGUN_SHOTZANGLECHANGESPEED;
                 player.wpnsinfo.shotzanglechangespeedafter := PLAYER_WPN_MCHGUN_SHOTZANGLECHANGESPEEDAFTER;
                 player.wpnsinfo.shotyanglechangespeedafter := PLAYER_WPN_MCHGUN_SHOTYANGLECHANGESPEEDAFTER;
                 player.wpnsinfo.wpnshotbias_angy := 0.0;
                 player.wpnsinfo.wpnshotbias_angy_max := PLAYER_WPN_MCHGUN_SHOTYANGLE_MAX;
                 player.wpnsinfo.wpnacc := GAME_WPN_MCHGUN_ACCURACY;
                 player.wpnsinfo.reloadzangle := PLAYER_WPN_MCHGUN_RELOADZANGLE;
                 player.wpnsinfo.reloadzanglechangespeed := PLAYER_WPN_MCHUGN_RELOADZANGLECHANGESPEED;
                 player.wpnsinfo.reloadzanglechangespeedafter := PLAYER_WPN_MCHGUN_RELOADZANGLECHANGESPEEDAFTER;
                 player.wpnsinfo.wpnreloadbias_angz := 0.0;
               end;
            3: begin
                 player.wpnsinfo.shotzangle := PLAYER_WPN_ROCKETLAUNCHER_SHOTZANGLE;
                 player.wpnsinfo.shotzanglechangespeed := PLAYER_WPN_ROCKETLAUNCHER_SHOTZANGLECHANGESPEED;
                 player.wpnsinfo.shotzanglechangespeedafter := PLAYER_WPN_ROCKETLAUNCHER_SHOTZANGLECHANGESPEEDAFTER;
                 player.wpnsinfo.shotyanglechangespeedafter := PLAYER_WPN_ROCKETLAUNCHER_SHOTYANGLECHANGESPEEDAFTER;
                 player.wpnsinfo.wpnshotbias_angy := 0.0;
                 player.wpnsinfo.wpnshotbias_angy_max := PLAYER_WPN_ROCKETLAUNCHER_SHOTYANGLE_MAX;
                 player.wpnsinfo.wpnacc := GAME_WPN_ROCKET_ACCURACY;
                 player.wpnsinfo.reloadzangle := PLAYER_WPN_ROCKETLAUNCHER_RELOADZANGLE;
                 player.wpnsinfo.reloadzanglechangespeed := PLAYER_WPN_ROCKETLAUNCHER_RELOADZANGLECHANGESPEED;
                 player.wpnsinfo.reloadzanglechangespeedafter := PLAYER_WPN_ROCKETLAUNCHER_RELOADZANGLECHANGESPEEDAFTER;
                 player.wpnsinfo.wpnreloadbias_angz := 0.0;
               end;
          end;
        end;
    end;
end;

function wpnGetTheBest(wpncurr: integer): integer;
begin
  if ( (player.wpnsinfo.bulletsinfo[3].act = 0) ) then
    begin
      if ( (player.wpnsinfo.bulletsinfo[2].total = 0) ) then
        begin
          if ( (player.wpnsinfo.bulletsinfo[1].total = 0) ) then
            begin
              if ( (player.wpnsinfo.bulletsinfo[3].total = 0) ) then
                begin
                  result := wpncurr;
                end
               else result := 3;
            end
           else result := 1;
        end
       else result := 2;
    end
   else result := 3;
end;

procedure WpnSwitchToTheBest;
var
  a,best: integer;
begin
  if ( player.wpnsinfo.currentwpn in [1,2] ) then a := player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].total
    else
     begin
       if ( (player.wpnsinfo.currentwpn in [3]) and (player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].act > 0) ) then
         a := player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].act
        else
         a := player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].total;
     end;
  if ( (a = 0) and (settings^.game_autoswitchwpn) ) then
    begin
      best := WpnGetTheBest(player.wpnsinfo.currentwpn);
      if ( best <> player.wpnsinfo.currentwpn ) then WpnSwitchTo( best );
    end;
end;

procedure wpnReload(wpn: integer);
var
  tmp: integer;
begin
  if ( (wpn in [3]) and not(player.wpnsinfo.takingaway) and not(player.wpnsinfo.gettingout) ) then
    begin
      if ( (player.wpnsinfo.bulletsinfo[wpn].act < player.wpnsinfo.bulletsinfo[wpn].actmaxtotal) and (player.wpnsinfo.bulletsinfo[wpn].total > 0) ) then
        begin
          tmp := player.wpnsinfo.bulletsinfo[wpn].actmaxtotal - player.wpnsinfo.bulletsinfo[wpn].act;
          // tmp-ben van, hogy mennyi új lövedéket kéne betölteni
          if ( player.wpnsinfo.bulletsinfo[wpn].total < tmp ) then
            begin // ha nincs annyi lövedék, mint amennyit be kéne tölteni, akkor annyit töltünk be, amennyi van
              tmp := player.wpnsinfo.bulletsinfo[wpn].total;
            end;
          player.wpnsinfo.numbulletstoreload := tmp;
          player.wpnsinfo.reloading := TRUE;
          if ( settings^.game_ODDinteract ) then
            begin
              cdthread := TRocketLauncher.Create(FALSE);
            end;
        end;
    end;
end;

function wpnIsAutomatic(wpn: integer): boolean;
begin
  if ( (wpn > 0) and (wpn <= GAME_WPN_MAX) ) then
    begin
      case wpn of
        1: result := FALSE;
        2: result := TRUE;
        3: result := FALSE;
        else result := FALSE;
      end;
    end
   else result := FALSE;
end;

procedure WpnMchgunLCD;
begin
  if ( player.wpnsinfo.currentwpn = 2 ) then
    begin
      tmcssetxpos(obj_wpn_mchgunlcd1,tmcsgetxpos(player.wpnsinfo.currentwpnobjnum));
      tmcssetypos(obj_wpn_mchgunlcd1,tmcsgetypos(player.wpnsinfo.currentwpnobjnum));
      tmcssetzpos(obj_wpn_mchgunlcd1,tmcsgetzpos(player.wpnsinfo.currentwpnobjnum));
      tmcsyrotateobject(obj_wpn_mchgunlcd1,tmcsgetangley(player.wpnsinfo.currentwpnobjnum)-tmcsgetangley(obj_wpn_mchgunlcd1));
      tmcszrotateobject(obj_wpn_mchgunlcd1,tmcsgetanglez(player.wpnsinfo.currentwpnobjnum)-tmcsgetanglez(obj_wpn_mchgunlcd1));
      tmcssetxpos(obj_wpn_mchgunlcd2,tmcsgetxpos(player.wpnsinfo.currentwpnobjnum));
      tmcssetypos(obj_wpn_mchgunlcd2,tmcsgetypos(player.wpnsinfo.currentwpnobjnum));
      tmcssetzpos(obj_wpn_mchgunlcd2,tmcsgetzpos(player.wpnsinfo.currentwpnobjnum));
      tmcsyrotateobject(obj_wpn_mchgunlcd2,tmcsgetangley(player.wpnsinfo.currentwpnobjnum)-tmcsgetangley(obj_wpn_mchgunlcd2));
      tmcszrotateobject(obj_wpn_mchgunlcd2,tmcsgetanglez(player.wpnsinfo.currentwpnobjnum)-tmcsgetanglez(obj_wpn_mchgunlcd2));
      tmcstextureobject(obj_wpn_mchgunlcd1, tex_wpn_mchgun_lcdnums[(player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].total div 10)]);
      tmcstextureobject(obj_wpn_mchgunlcd2, tex_wpn_mchgun_lcdnums[(player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].total mod 10)]);
      tmcssetxpos(obj_wpn_mchgunlcdwarning,tmcsgetxpos(player.wpnsinfo.currentwpnobjnum));
      tmcssetypos(obj_wpn_mchgunlcdwarning,tmcsgetypos(player.wpnsinfo.currentwpnobjnum));
      tmcssetzpos(obj_wpn_mchgunlcdwarning,tmcsgetzpos(player.wpnsinfo.currentwpnobjnum));
      tmcsyrotateobject(obj_wpn_mchgunlcdwarning,tmcsgetangley(player.wpnsinfo.currentwpnobjnum)-tmcsgetangley(obj_wpn_mchgunlcdwarning));
      tmcszrotateobject(obj_wpn_mchgunlcdwarning,tmcsgetanglez(player.wpnsinfo.currentwpnobjnum)-tmcsgetanglez(obj_wpn_mchgunlcdwarning));
      if ( player.wpnsinfo.bulletsinfo[2].total > 0 ) then
        begin
          if ( obj_wpn_mchgun_lcdnums_alpha_inc ) then
            begin
              obj_wpn_mchgun_lcdnums_alpha := obj_wpn_mchgun_lcdnums_alpha + round((GAME_WPN_MCHGUN_LCD_ALPHA_CHANGESPEED/fps)*20);
              if ( obj_wpn_mchgun_lcdnums_alpha >= GAME_WPN_MCHGUN_LCD_ALPHA_MAX ) then
                begin
                  obj_wpn_mchgun_lcdnums_alpha_inc := FALSE;
                  obj_wpn_mchgun_lcdnums_alpha := GAME_WPN_MCHGUN_LCD_ALPHA_MAX;
                end;
            end
           else
            begin
              obj_wpn_mchgun_lcdnums_alpha := obj_wpn_mchgun_lcdnums_alpha - round((GAME_WPN_MCHGUN_LCD_ALPHA_CHANGESPEED/fps)*20);
              if ( obj_wpn_mchgun_lcdnums_alpha <= GAME_WPN_MCHGUN_LCD_ALPHA_MIN ) then
                begin
                  obj_wpn_mchgun_lcdnums_alpha_inc := TRUE;
                  obj_wpn_mchgun_lcdnums_alpha := GAME_WPN_MCHGUN_LCD_ALPHA_MIN;
                end;
            end;
        end  // player.wpnsinfo.bulletsinfo[2].total > 0
       else
        begin
          obj_wpn_mchgun_lcdnums_alpha := GAME_WPN_MCHGUN_LCD_ALPHA_MIN;
        end;
      tmcssetobjectcolorkey(obj_wpn_mchgunlcd1,255,255,255,obj_wpn_mchgun_lcdnums_alpha);
      tmcssetobjectcolorkey(obj_wpn_mchgunlcd2,255,255,255,obj_wpn_mchgun_lcdnums_alpha);
      if ( (player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].total <= GAME_WPN_MCHGUN_WARNINGNUM) and (player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].total > 0) ) then
        tmcssetobjectcolorkey(obj_wpn_mchgunlcdwarning,255,255,255,GAME_WPN_MCHGUN_LCDWARNING_ALPHA_MAX)
       else
        tmcssetobjectcolorkey(obj_wpn_mchgunlcdwarning,255,255,255,GAME_WPN_MCHGUN_LCDWARNING_ALPHA_MIN);
    end;  // player.wpnsinfo.currentwpn = 2
end;

procedure WpnAnimate;
begin
  if ( not(DEBUG_WALKTHROUGH) ) then
    begin
      if ( player.wpnsinfo.gettingout and not(firstframe) ) then
        begin
          player.wpnsinfo.wpnchangebias_angz := player.wpnsinfo.wpnchangebias_angz - PLAYER_WPN_CHANGE_SPEED/fps;
          if ( player.wpnsinfo.currentwpn = 2 ) then
            begin
              tmcsshowobject(obj_wpn_mchgunlcd1);
              tmcsshowobject(obj_wpn_mchgunlcd2);
              tmcsshowobject(obj_wpn_mchgunlcdwarning);
            end
           else
            begin
              tmcshideobject(obj_wpn_mchgunlcd1);
              tmcshideobject(obj_wpn_mchgunlcd2);
              tmcshideobject(obj_wpn_mchgunlcdwarning);
            end;
          if ( player.wpnsinfo.wpnchangebias_angz <= 0.0 ) then
            begin
              player.wpnsinfo.gettingout := FALSE;
              player.wpnsinfo.wpnchangebias_angz := 0.0;
            end;
        end  // player.wpnsinfo.gettingout and not(firstframe)
       else
        if ( player.wpnsinfo.takingaway and not(firstframe) ) then
          begin
            player.wpnsinfo.wpnchangebias_angz := player.wpnsinfo.wpnchangebias_angz + PLAYER_WPN_CHANGE_SPEED/fps;
            if ( player.wpnsinfo.wpnchangebias_angz >= PLAYER_WPN_CHANGE_ANGLEMAX ) then
              begin
                player.wpnsinfo.takingaway := FALSE;
                player.wpnsinfo.wpnchangebias_angz := PLAYER_WPN_CHANGE_ANGLEMAX;
                player.wpnsinfo.gettingout := TRUE;
                tmcshideobject(player.wpnsinfo.currentwpnobjnum);
                case player.wpnsinfo.newwpn of
                  1: begin
                       player.wpnsinfo.currentwpnobjnum := obj_wpn_pistol;
                       player.wpnsinfo.currentwpnmuzzleobjnum := obj_wpn_pistolmuzzle;
                       player.wpnsinfo.wpn_ypos_bias := PLAYER_WPN_PISTOL_YPOS_BIAS;
                     end;
                  2: begin
                       player.wpnsinfo.currentwpnobjnum := obj_wpn_mchgun;
                       player.wpnsinfo.currentwpnmuzzleobjnum := obj_wpn_mchgunmuzzle;
                       player.wpnsinfo.wpn_ypos_bias := PLAYER_WPN_MCHGUN_YPOS_BIAS;
                     end;
                  3: begin
                       player.wpnsinfo.currentwpnobjnum := obj_wpn_rocketlauncher;
                       player.wpnsinfo.currentwpnmuzzleobjnum := obj_wpn_rocketlaunchermuzzle;
                       player.wpnsinfo.wpn_ypos_bias := PLAYER_WPN_ROCKETLAUNCHER_YPOS_BIAS;
                     end;
                end;
                player.wpnsinfo.currentwpn := player.wpnsinfo.newwpn;
                tmcsshowobject(player.wpnsinfo.currentwpnobjnum);
              end;
          end;  

        if ( player.wpnsinfo.shooting ) then
          begin
            if ( (player.wpnsinfo.currentwpnmuzzleobjnum > -1) and not(player.wpnsinfo.takingaway) ) then
              begin
                tmcsshowobject(player.wpnsinfo.currentwpnmuzzleobjnum);
              end;
            if ( player.wpnsinfo.wpnshotbias_angz > player.wpnsinfo.shotzangle ) then
              player.wpnsinfo.wpnshotbias_angz := player.wpnsinfo.wpnshotbias_angz - player.wpnsinfo.shotzanglechangespeed/fps
             else if ( player.wpnsinfo.wpnshotbias_angz <= player.wpnsinfo.shotzangle ) then
               begin
                 player.wpnsinfo.shooting := FALSE;
                 player.wpnsinfo.wpnshotbias_angz := player.wpnsinfo.shotzangle;
               end;
          end  // player.wpnsinfo.shooting
         else
          begin
            if ( not(player.wpnsinfo.reloading) ) then
              begin
                if ( player.wpnsinfo.currentwpnmuzzleobjnum > -1 ) then
                  tmcshideobject(player.wpnsinfo.currentwpnmuzzleobjnum);
                if ( player.wpnsinfo.wpnshotbias_angy > 0.0 ) then
                  player.wpnsinfo.wpnshotbias_angy := player.wpnsinfo.wpnshotbias_angy - player.wpnsinfo.shotyanglechangespeedafter/fps
                 else if ( player.wpnsinfo.wpnshotbias_angy < 0.0 ) then
                  player.wpnsinfo.wpnshotbias_angy := 0.0;

                if ( player.wpnsinfo.wpnshotbias_angz < 0.0 ) then
                  player.wpnsinfo.wpnshotbias_angz := player.wpnsinfo.wpnshotbias_angz + player.wpnsinfo.shotzanglechangespeedafter/fps
                 else if ( player.wpnsinfo.wpnshotbias_angz >= 0.0 ) then
                  begin
                    player.wpnsinfo.wpnshotbias_angz := 0.0;
                    if ( not(wpnIsAutomatic(player.wpnsinfo.currentwpn)) and (inputIsMouseButtonPressed(MBTN_LEFT) = FALSE) ) then mouseleftstop := FALSE;
                    if ( (settings^.game_keybdLEDsinteract) and (player.wpnsinfo.currentwpn in [3]) ) then
                      begin
                        if ( (player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].act = 0)
                                                         and
                             (player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].total > 0)
                           ) then WpnReload(player.wpnsinfo.currentwpn)
                          else WpnSwitchToTheBest;
                      end
                     else
                      begin
                        WpnSwitchToTheBest;
                      end;
                  end;

                if ( player.wpnsinfo.wpnreloadbias_angz > 0.0 ) then
                  begin
                    player.wpnsinfo.wpnreloadbias_angz := player.wpnsinfo.wpnreloadbias_angz - player.wpnsinfo.reloadzanglechangespeedafter/fps
                  end
                 else if ( player.wpnsinfo.wpnreloadbias_angz <= 0.0 ) then
                   begin
                     player.wpnsinfo.wpnreloadbias_angz := 0.0
                   end;
              end  // not(player.wpnsinfo.reloading)
             else
              begin
                if ( player.wpnsinfo.wpnreloadbias_angz < player.wpnsinfo.reloadzangle ) then
                  begin
                    player.wpnsinfo.wpnreloadbias_angz := player.wpnsinfo.wpnreloadbias_angz + player.wpnsinfo.reloadzanglechangespeed/fps
                  end
                 else if ( player.wpnsinfo.wpnreloadbias_angz >= player.wpnsinfo.reloadzangle ) then
                  begin
                    player.wpnsinfo.wpnreloadbias_angz := player.wpnsinfo.reloadzangle;
                    if ( player.wpnsinfo.numbulletstoreload > 0 ) then
                      begin
                        if ( player.health > 0 ) then
                          begin
                            if ( gettickcount() - player.wpnsinfo.lastbulletload >= PLAYER_WPN_ROCKETLAUNCHER_TIME_BETWEEN_RELOAD_STEPS ) then
                              begin
                                player.wpnsinfo.lastbulletload := gettickcount();
                                player.wpnsinfo.numbulletstoreload := player.wpnsinfo.numbulletstoreload-1;
                                player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].total :=
                                  player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].total - 1;
                                player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].act :=
                                  player.wpnsinfo.bulletsinfo[player.wpnsinfo.currentwpn].act + 1;
                                if ( settings^.audio_sfx ) then
                                  begin
                                    snd_pos.x := player.px;
                                    snd_pos.y := player.py;
                                    snd_pos.z := player.pz;
                                    sndchn := FSOUND_playsoundex(FSOUND_free,snd_rocketreload,nil,TRUE);
                                    FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                                    FSOUND_setpaused(sndchn,FALSE);
                                  end;
                              end;
                          end;
                      end
                     else
                      begin
                        player.wpnsinfo.reloading := FALSE;
                        if ( settings^.game_ODDinteract ) then
                          begin
                            cdthread := TRocketLauncher.Create(FALSE);
                          end;
                      end;
                  end;
              end;
          end;

      tmcssetxpos(player.wpnsinfo.currentwpnobjnum,player.px);
      tmcssetypos(player.wpnsinfo.currentwpnobjnum,player.py+player.cam_ys*(PLAYER_WPN_SHAKE_RATE)+player_headposy+player.wpnsinfo.wpn_ypos_bias);
      tmcssetzpos(player.wpnsinfo.currentwpnobjnum,player.pz);
      tmcsyrotateobject(player.wpnsinfo.currentwpnobjnum,tmcsgetcameraangley()-tmcsgetangley(player.wpnsinfo.currentwpnobjnum)+player.wpnsinfo.wpnshotbias_angy);
      tmcszrotateobject(player.wpnsinfo.currentwpnobjnum,tmcsgetcameraanglex()-tmcsgetanglez(player.wpnsinfo.currentwpnobjnum)+player.wpnsinfo.wpnchangebias_angz+player.wpnsinfo.wpnshotbias_angz-player.wpnsinfo.wpnshotbias_angy/2+player.wpnsinfo.wpnreloadbias_angz);
      WpnMchgunLCD;
      if ( player.wpnsinfo.currentwpnmuzzleobjnum > -1 ) then
        begin
          tmcssetxpos(player.wpnsinfo.currentwpnmuzzleobjnum, tmcsgetxpos(player.wpnsinfo.currentwpnobjnum));
          tmcssetypos(player.wpnsinfo.currentwpnmuzzleobjnum, tmcsgetypos(player.wpnsinfo.currentwpnobjnum));
          tmcssetzpos(player.wpnsinfo.currentwpnmuzzleobjnum, tmcsgetzpos(player.wpnsinfo.currentwpnobjnum));
          tmcsyrotateobject(player.wpnsinfo.currentwpnmuzzleobjnum,tmcsgetangley(player.wpnsinfo.currentwpnobjnum)-tmcsgetangley(player.wpnsinfo.currentwpnmuzzleobjnum));
          tmcszrotateobject(player.wpnsinfo.currentwpnmuzzleobjnum,tmcsgetanglez(player.wpnsinfo.currentwpnobjnum)-tmcsgetanglez(player.wpnsinfo.currentwpnmuzzleobjnum));
        end;
    end;
end;


// lövés
procedure WpnShoot(wpn: integer);
var
  a: integer;
  tmp2,tmp3: single;
begin
  if ( not(player.wpnsinfo.reloading) and (player.wpnsinfo.wpnreloadbias_angz = 0.0) ) then
    begin
      if ( wpn in [1,2] ) then a := player.wpnsinfo.bulletsinfo[wpn].total
        else a := player.wpnsinfo.bulletsinfo[wpn].act;
      if ( a > 0 ) then
        begin
          if ( wpn in [2] ) then
            begin
              obj_wpn_mchgun_lcdnums_alpha_inc := TRUE;
              obj_wpn_mchgun_lcdnums_alpha := GAME_WPN_MCHGUN_LCD_ALPHA_MIN;
            end;
          tmp2 := (random(player.wpnsinfo.wpnacc)-player.wpnsinfo.wpnacc/2 + 0.5) / 2;
          tmp3 := ( random(player.wpnsinfo.wpnacc)-player.wpnsinfo.wpnacc/2 + 0.5 ) / 2;
          if ( wpnIsAutomatic(wpn) ) then
            begin  // automata fegyver, tehát folyamatos lövés
              if ( (gettickcount() - player.wpnsinfo.lastshot) >= PLAYER_WPN_MCHGUN_TIMEBETWEENSHOTS ) then
                begin
                  newbullet(wpn,-1,
                            player.px,player.py+player.cam_ys+player_headposy,player.pz,
                            -tmcsgetcameraanglex()+tmp3,tmcsgetcameraangley() + player.wpnsinfo.wpnshotbias_angy/4+tmp2,tmcsgetcameraanglez()
                            );
                  player.wpnsinfo.shooting := TRUE;
                  player.wpnsinfo.lastshot := gettickcount();
                  if ( player.wpnsinfo.wpnshotbias_angy <= player.wpnsinfo.wpnshotbias_angy_max ) then
                    player.wpnsinfo.wpnshotbias_angy := player.wpnsinfo.wpnshotbias_angy+PLAYER_WPN_MCHGUN_SHOTYANGLECHANGESPEED/80
                   else
                    player.wpnsinfo.wpnshotbias_angy := player.wpnsinfo.wpnshotbias_angy_max;
                  if ( wpn in [1,2] ) then player.wpnsinfo.bulletsinfo[wpn].total := player.wpnsinfo.bulletsinfo[wpn].total - 1
                    else player.wpnsinfo.bulletsinfo[wpn].act := player.wpnsinfo.bulletsinfo[wpn].act - 1;
                  if ( (player.wpnsinfo.bulletsinfo[wpn].total = GAME_WPN_MCHGUN_WARNINGNUM) and (settings^.audio_sfx) ) then
                    begin
                      snd_pos.x := player.px;
                      snd_pos.y := player.py;
                      snd_pos.z := player.pz;
                      sndchn := FSOUND_playsoundex(FSOUND_free,snd_mchgunlowammo,nil,TRUE);
                      FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                      FSOUND_setpaused(sndchn,FALSE);
                    end;
                  if ( settings^.audio_sfx and (wpn = 2) ) then FSOUND_playsound(FSOUND_free,snd_mchgun);
                end;
            end
           else
            begin  // félautomata fegyver, tehát a lövéshez klikkelgetni kell
              if ( not(mouseleftstop) and not(player.wpnsinfo.shooting) ) then
                begin
                  newbullet(wpn,-1,
                            player.px,player.py+player.cam_ys+player_headposy,player.pz,
                            -tmcsgetcameraanglex()+tmp3,tmcsgetcameraangley() + player.wpnsinfo.wpnshotbias_angy/4+tmp2,tmcsgetcameraanglez()
                            );
                  player.wpnsinfo.shooting := TRUE;
                  if ( wpn in [1,2] ) then player.wpnsinfo.bulletsinfo[wpn].total := player.wpnsinfo.bulletsinfo[wpn].total - 1
                    else player.wpnsinfo.bulletsinfo[wpn].act := player.wpnsinfo.bulletsinfo[wpn].act - 1;
                  mouseleftstop := TRUE;
                  if ( settings^.audio_sfx ) then
                    begin
                      if ( wpn = 1 ) then FSOUND_playsound(FSOUND_free,snd_pistol)
                        else FSOUND_playsound(FSOUND_free,snd_rocketl);
                    end;
                end;
            end;
        end
       else if ( player.wpnsinfo.wpnshotbias_angz = 0.0 ) then
        begin
          if ( not(mouseleftstop) and settings^.audio_sfx) then
            begin
              FSOUND_playsound(FSOUND_free,snd_noammo);
              if ( not(wpnIsAutomatic(player.wpnsinfo.currentwpn)) ) then mouseleftstop := TRUE;
            end;
          WpnSwitchToTheBest;
        end;
    end;
end;

{
 _  __          ____                      _
| |/ /___ _   _| __ )  ___   __ _ _ __ __| |
| ' // _ \ | | |  _ \ / _ \ / _` | '__/ _` |
| . \  __/ |_| | |_) | (_) | (_| | | | (_| |
|_|\_\___|\__, |____/ \___/ \__,_|_|  \__,_|
          |___/
}
procedure KeyBoard;
var
  l: boolean;
  i: integer;

// kamera rázása
procedure shakecam(running: boolean);
begin
  if ( running ) then
    begin
      player.cam_yi := player.cam_yi + round(PLAYER_CAMSHAKE_YPOS*80/fps);
      player.cam_yai := player.cam_yai + round(PLAYER_CAMSHAKE_Yang*80/fps);
      player.cam_ys := sin(player.cam_yi*3.14/180)/PLAYER_CAMSHAKE_YPOSDIV;
      player.cam_yas := sin(player.cam_yai*3.14/180)/PLAYER_CAMSHAKE_YANGDIV;
    end
   else
    begin
      player.cam_yi := round(player.cam_yi + PLAYER_CAMSHAKE_YPOS*(PLAYER_MOVE_WALK/(fps/2)));
      player.cam_yai := round(player.cam_yai + PLAYER_CAMSHAKE_YANG*(PLAYER_MOVE_WALK/(fps/3)));
      player.cam_ys := sin(player.cam_yi*3.14/180)/PLAYER_CAMSHAKE_YPOSDIV*(PLAYER_MOVE_WALK*2/PLAYER_MOVE_RUN);
      player.cam_yas := sin(player.cam_yai*3.14/180)/PLAYER_CAMSHAKE_YANGDIV*(PLAYER_MOVE_WALK*2/PLAYER_MOVE_RUN);
    end;
end;

// séta adott fokban és új vagy régi pozíciókkal
procedure walk(angle: single; oldpos: boolean);
begin
  if ( oldpos ) then
    begin
      player.px := tmcsGetNewX(player.opx,tmcsGetCameraAngleY()+angle,PLAYER_MOVE_WALK*80/fps);
      player.pz := tmcsGetNewZ(player.opz,tmcsGetCameraAngleY()+angle,PLAYER_MOVE_WALK*80/fps);
    end
   else
    begin
      player.px := tmcsGetNewX(player.px,tmcsGetCameraAngleY()+angle,PLAYER_MOVE_WALK*80/fps);
      player.pz := tmcsGetNewZ(player.pz,tmcsGetCameraAngleY()+angle,PLAYER_MOVE_WALK*80/fps);
    end;
  if ( settings^.audio_sfx and (gettickcount()-lastrun > 400) ) then
    begin
      lastrun := gettickcount();
      leftleg := not(leftleg);
      snd_pos.x := player.px;
      snd_pos.y := player.py;
      snd_pos.z := player.pz;
      if ( leftleg ) then sndchn := FSOUND_playsoundex(FSOUND_free,snd_step1,nil,TRUE)
        else sndchn := FSOUND_playsoundex(FSOUND_free,snd_step2,nil,TRUE);
      FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
      FSOUND_setpaused(sndchn,FALSE);
    end;
end;

// futás adott fokban és új vagy régi pozíciókkal
procedure run(angle: single; oldpos: boolean);
begin
  if ( oldpos ) then
    begin
      player.px := tmcsGetNewX(player.opx,tmcsGetCameraAngleY()+angle,PLAYER_MOVE_RUN*80/fps);
      player.pz := tmcsGetNewZ(player.opz,tmcsGetCameraAngleY()+angle,PLAYER_MOVE_RUN*80/fps);
    end
   else
    begin
      player.px := tmcsGetNewX(player.px,tmcsGetCameraAngleY()+angle,PLAYER_MOVE_RUN*80/fps);
      player.pz := tmcsGetNewZ(player.pz,tmcsGetCameraAngleY()+angle,PLAYER_MOVE_RUN*80/fps);
    end;
  if ( settings^.audio_sfx and (gettickcount()-lastrun > 300) ) then
    begin
      lastrun := gettickcount();
      leftleg := not(leftleg);
      snd_pos.x := player.px;
      snd_pos.y := player.py;
      snd_pos.z := player.pz;
      if ( leftleg ) then sndchn := FSOUND_playsoundex(FSOUND_free,snd_step1,nil,TRUE)
        else sndchn := FSOUND_playsoundex(FSOUND_free,snd_step2,nil,TRUE);
      FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
      FSOUND_setpaused(sndchn,FALSE);
    end;
end;

begin
  if ( inmenu ) then
    begin
      inmenu_keybdcur := FALSE;
      if ( inputiskeypressed(VK_UP) ) then
        begin
          if ( not(upstop) ) then
            begin
              upstop := TRUE;
              if ( menuact = 1 ) then menuact := GAME_INGAME_MENU_BTNCOUNT
                else menuact := menuact-1;
              menubtn_px := round(((gamewindow.wndrect.Right-gamewindow.wndrect.Left) div 2)-tmcsgetxpos(obj_menubtns_up[menuact]))+gamewindow.wndrect.Left;
              menubtn_py := round(((gamewindow.wndrect.bottom-gamewindow.wndrect.top) div 2)-tmcsgetypos(obj_menubtns_up[menuact]))+gamewindow.wndrect.top;
              setcursorpos(menubtn_px,menubtn_py);
              inmenu_keybdcur := TRUE;
            end;
        end
       else upstop := FALSE;
      if ( inputiskeypressed(VK_DOWN) ) then
        begin
          if ( not(downstop) ) then
            begin
              downstop := TRUE;
              if ( menuact = GAME_INGAME_MENU_BTNCOUNT ) then menuact := 1
                else menuact := menuact+1;
              menubtn_px := round(((gamewindow.wndrect.Right-gamewindow.wndrect.Left) div 2)-tmcsgetxpos(obj_menubtns_up[menuact]))+gamewindow.wndrect.Left;
              menubtn_py := round(((gamewindow.wndrect.bottom-gamewindow.wndrect.top) div 2)-tmcsgetypos(obj_menubtns_up[menuact]))+gamewindow.wndrect.top;
              setcursorpos(menubtn_px,menubtn_py);
              inmenu_keybdcur := TRUE;
            end;
        end
       else downstop := FALSE;
      if ( inputiskeypressed(VK_RETURN) or inputiskeypressed(VK_SPACE) ) then
        begin
          menureact(menuact);
          menuact := 0;
          sendmessage(gamewindow.hwindow,WM_keyup,vk_return,0);
          sendmessage(gamewindow.hwindow,WM_keyup,vk_escape,0);
        end;
      if ( inputIsKeypressed(VK_ESCAPE) ) then
        begin
          if ( not(escapestop) ) then
            begin
              escapestop := TRUE;
              returntogame;
            end;
        end
       else escapestop := FALSE;
    end  // inmenu
   else
    begin
      if ( not(endgame) ) then
        begin
          trans_x := player.opx;
          trans_z := player.opz;
          if ( player.health > 0 ) then
            begin
              l := FALSE;
              if ( inputIsKeypressed(VK_UP) or inputiskeypressed(vkkeyscan('w')) ) then
                begin
                  if ( inputiskeypressed(VK_SHIFT) ) then walk(0,TRUE)
                    else run(0,TRUE);
                  shakecam(not(inputiskeypressed(VK_SHIFT)));
                  l := TRUE;
                end;
              if ( inputIsKeypressed(VK_DOWN) or inputiskeypressed(vkkeyscan('s')) ) then
                begin
                  if ( inputiskeypressed(VK_SHIFT) ) then walk(-180,TRUE)
                    else run(-180,TRUE);
                  if not(l) then shakecam(not(inputiskeypressed(VK_SHIFT)));
                  l := TRUE;
                end;
              if ( inputIsKeypressed(VK_LEFT) ) then tmcsYRotateCamera(-PLAYER_ROTATE*80/fps)
               else if ( inputIsKeypressed(VK_RIGHT) ) then tmcsYRotateCamera(PLAYER_ROTATE*80/fps);
              if ( inputiskeypressed(vkkeyscan('a')) ) then
                begin
                  if ( l ) then
                    begin
                      if ( inputiskeypressed(VK_SHIFT) ) then walk(-90,FALSE)
                       else run(-90,FALSE);
                    end
                   else
                    begin
                      if ( inputiskeypressed(VK_SHIFT) ) then walk(-90,FALSE)
                        else run(-90,FALSE);
                      if (not(inputiskeypressed(vkkeyscan('d')))) then shakecam(not(inputiskeypressed(VK_SHIFT)));
                    end;
                  l := TRUE;
                end;
              if ( inputiskeypressed(vkkeyscan('d')) ) then
                begin
                  if ( l ) then
                    begin
                      if ( inputiskeypressed(VK_SHIFT) ) then walk(90,FALSE)
                        else run(90,FALSE);
                    end
                   else
                    begin
                      if ( inputiskeypressed(VK_SHIFT) ) then walk(90,TRUE)
                        else run(90,TRUE);
                      if (not(inputiskeypressed(vkkeyscan('a')))) then shakecam(not(inputiskeypressed(VK_SHIFT)));
                    end;
                  l := TRUE;
                end;
              if ( player.cam_yi > 359 ) then player.cam_yi := 0;
              if ( player.cam_yai > 359 ) then player.cam_yai := 0;
              // E
              if ( inputiskeypressed(vkkeyscan('e')) ) then
                begin
                  if ( player.hasteleport ) then
                    begin
                      player.hasteleport := FALSE;
                      if ( playertosp(TRUE) ) then
                        begin
                          printmajortext(GAME_ITEMS_TEXTS[0],255,255,255,255);
                          if (settings^.audio_sfx) then FSOUND_playsound(FSOUND_free,snd_useteleport);
                        end
                       else sendmessage(gamewindow.hwindow,WM_KEYDOWN,vkkeyscan('e'),0);
                    end;
                end;
              // Q
              if ( inputiskeypressed(vkkeyscan('q')) ) then wpnSwitchTo(player.wpnsinfo.prevwpn);
              // R
              if ( inputiskeypressed(vkkeyscan('r')) ) then
                begin
                  if ( not(rhack) ) then WpnReload(player.wpnsinfo.currentwpn);
                  rhack := TRUE;
                end
               else rhack := FALSE;
              // space
              if ( inputIsKeypressed(vk_space) ) then
                begin
                 if ( not(spacehack) and (player.jmp = -1) ) then
                   begin
                     if ( (player.gravity >= -(GAME_WORLD_GRAVITY+0.01)) and (player.gravity <= 0.0) ) then player.gravity := 0.0;
                     if ( player.gravity = 0.0 ) then
                       begin
                         if (settings^.audio_sfx) then FSOUND_playsound(FSOUND_free,snd_jump);
                         player.jumping := TRUE;
                         player.jmp := 90.0;
                         player.gravity := 0.0;
                         spacehack := TRUE;
                         player.impulsepx := player.impulsepx + (player.px - player.opx)*(1.2*sin(min(fps,90)*pi/180));
                         player.impulsepz := player.impulsepz + (player.pz - player.opz)*(1.2*sin(min(fps,90)*pi/180));
                         if ( player.impulsepx > fps/35 ) then player.impulsepx := fps/35
                            else if ( player.impulsepx < -fps/35 ) then player.impulsepx := -fps/35;
                          if ( player.impulsepy > fps/35 ) then player.impulsepy := fps/35
                            else if ( player.impulsepy < -fps/35 ) then player.impulsepy := -fps/35;
                          if ( player.impulsepz > fps/35 ) then player.impulsepz := fps/35
                            else if ( player.impulsepz < -fps/35 ) then player.impulsepz := -fps/35;
                       end;
                   end;
                end
               else spacehack := FALSE;
              // 1,2,3
              for i := 1 to GAME_WPN_MAX do
                if ( inputIsKeypressed(vkkeyscan(inttostr(i)[1])) ) then WpnSwitchTo(i);
              // TAB
              if ( inputIsKeypressed(VK_TAB) ) then drawfragtable
                else hidefragtable;
              if ( inputIsKeypressed(VK_CONTROL) ) then WpnShoot(player.wpnsinfo.currentwpn);
            end  // player.health > 0
           else
            begin
              if ( inputiskeypressed(VK_RETURN) or inputiskeypressed(VK_SPACE)
                   or inputiskeypressed(VK_CONTROL) ) then
                begin
                  reviveplayer(-1);
                  hidefragtable;
                end;
            end;
        end
       else
        begin
          if ( (inputiskeypressed(VK_RETURN) or inputiskeypressed(VK_SPACE) or
               inputiskeypressed(VK_CONTROL)) and (gettickcount()-gameended >= GAME_TIMETOREVIVE) ) then
             begin
               menureact(4);
             end;
        end;
      // escape
      if ( inputIsKeypressed(VK_ESCAPE) ) then
        begin
          if ( not(escapestop) ) then
            begin
              escapestop := TRUE;
              showmenu;
              inmenu := not(inmenu);
            end;
        end
       else escapestop := FALSE;
    end;
  if ( inputiskeypressed(VK_CONTROL)
        and
       inputiskeypressed(VK_MENU)
        and
       inputiskeypressed(vkkeyscan('x'))
     ) then
        begin
          // lopakodó mód
          if ( settings^.game_stealthmode ) then
            begin
              showwindow(gamewindow.hwindow,SW_HIDE);
              inputsetkeyreleased(VK_CONTROL);
              inputsetkeyreleased(VK_MENU);
              inputsetkeyreleased(vkkeyscan('x'));
              tmcsrestoreoriginaldisplaymode;
            end;
        end;
end;

{
 __  __
|  \/  | ___  _   _ ___  ___
| |\/| |/ _ \| | | / __|/ _ \
| |  | | (_) | |_| \__ \  __/
|_|  |_|\___/ \__,_|___/\___|

}
procedure Mouse;
var
  i,scrollcount: integer;
begin
  if ( inmenu ) then
    begin
      mmx := ocur.x;
      mmy := ocur.y;
      getCursorPos(ocur);
      if ( mousemoved and not(inmenu_keybdcur) ) then
        begin
          while ( showcursor(TRUE) < 0 ) do ;
          mousemoved := FALSE;
          mouselastmoved := gettickcount();
        end
       else if ( inmenu_keybdcur or (gettickcount()-mouselastmoved >= GAME_INGAME_MENU_MOUSEHIDETIME) ) then
        begin
          while ( showcursor(FALSE) > -1 ) do ;
          mousemoved := FALSE;
        end;
      if ( inputismousebuttonpressed(mbtn_left) and not(mouseleftstop) ) then
        begin
          inputSetMouseButtonReleased(MBTN_LEFT);
          mouseleftstop := TRUE;
          sendmessage(gamewindow.hwindow,WM_LBUTTONup,0,0);
          menureact(menuact);
        end
       else mouseleftstop := FALSE;
    end
   else
    begin
      getCursorPos(ocur);
      mmx := ocur.x-mx;
      mmy := ocur.y-my;
      mouseToWndCenter;
      if ( not(endgame) ) then
        begin
          if ( player.health > 0 ) then
            begin
              if ( settings^.input_mousereverse ) then mmy := -mmy;
              tmcsXRotateCamera(mmy*settings^.input_mousesens/100);
              if ( tmcsGetCameraAngleX() < -PLAYER_MAXXANGLE ) then tmcssetcameraanglex(-PLAYER_MAXXANGLE)
                else if ( tmcsGetcameraAngleX() > PLAYER_MAXXANGLE ) then tmcssetcameraanglex(PLAYER_MAXXANGLE);
              tmcsYRotateCamera(mmx*settings^.input_mousesens/100);
              scrollcount := inputGetMouseWheelScrollCount();
              if ( scrollcount > 0 ) then
                begin
                  for i := 1 to scrollcount do
                    begin
                      player.wpnsinfo.newwpn := player.wpnsinfo.currentwpn - 1;
                      if ( player.wpnsinfo.newwpn < 1 ) then player.wpnsinfo.newwpn := GAME_WPN_MAX;
                    end;
                  WpnSwitchTo(player.wpnsinfo.newwpn);
                end
               else if ( scrollcount < 0 ) then
                 begin
                   for i := 1 to abs(scrollcount) do
                    begin
                      player.wpnsinfo.newwpn := player.wpnsinfo.currentwpn + 1;
                      if ( player.wpnsinfo.newwpn > GAME_WPN_MAX ) then player.wpnsinfo.newwpn := 1;
                    end;
                  WpnSwitchTo(player.wpnsinfo.newwpn);
                 end;
              if ( inputIsMouseButtonPressed(MBTN_LEFT) ) then
                begin
                  WpnShoot(player.wpnsinfo.currentwpn);
                end;
              if ( inputIsMouseButtonPressed(MBTN_MIDDLE) ) then
                begin
                  if ( player.zoomplus < GAME_CAMERA_ZOOM_MAX ) then player.zoomplus := player.zoomplus + GAME_CAMERA_ZOOM_SPEED/fps;
                  if ( player.zoomplus > GAME_CAMERA_ZOOM_MAX ) then player.zoomplus := GAME_CAMERA_ZOOM_MAX;
                end
               else
                begin
                  if ( player.zoomplus > 0.0 ) then player.zoomplus := player.zoomplus - GAME_CAMERA_ZOOM_SPEED/fps;
                  if ( player.zoomplus < 0.0 ) then player.zoomplus := 0.0;
                end;
              if ( inputIsMouseButtonPressed(MBTN_RIGHT) ) then
                begin
                  if ( not(spacehack) and (player.jmp = -1) ) then
                    begin
                      if ( (player.gravity >= -(GAME_WORLD_GRAVITY+0.01)) and (player.gravity <= 0.0) ) then player.gravity := 0.0;
                      if ( player.gravity = 0.0 ) then
                        begin
                          if (settings^.audio_sfx) then FSOUND_playsound(FSOUND_free,snd_jump);
                          player.jumping := TRUE;
                          player.jmp := 90.0;
                          player.gravity := 0.0;
                          spacehack := TRUE;
                          if ( (player.px-player.opx = 0) and (player.pz-player.opz = 0) ) then
                            begin
                              player.impulsepx := player.oimpulsepx + (player.px - trans_x)*(1.2*sin(min(fps,90)*pi/180));
                              player.impulsepz := player.oimpulsepz + (player.pz - trans_z)*(1.2*sin(min(fps,90)*pi/180));
                            end
                           else
                            begin
                              player.impulsepx := player.impulsepx + (player.px - player.opx)*(1.2*sin(min(fps,90)*pi/180));
                              player.impulsepz := player.impulsepz + (player.pz - player.opz)*(1.2*sin(min(fps,90)*pi/180));
                            end;
                          if ( player.impulsepx > fps/35 ) then player.impulsepx := fps/35
                            else if ( player.impulsepx < -fps/35 ) then player.impulsepx := -fps/35;
                          if ( player.impulsepy > fps/35 ) then player.impulsepy := fps/35
                            else if ( player.impulsepy < -fps/35 ) then player.impulsepy := -fps/35;
                          if ( player.impulsepz > fps/35 ) then player.impulsepz := fps/35
                            else if ( player.impulsepz < -fps/35 ) then player.impulsepz := -fps/35;
                        end;
                   end;
                end;
            end  // player.health > 0
           else
            begin
              if ( inputIsMouseButtonPressed(MBTN_LEFT) and not(mouseleftstop) ) then
                begin
                  reviveplayer(-1);
                  hidefragtable;
                  mouseleftstop := TRUE;
                end
               else mouseleftstop := FALSE;
            end;
        end
       else
        begin
          if ( inputIsMouseButtonPressed(MBTN_LEFT) and not(mouseleftstop) and (gettickcount()-gameended >= GAME_TIMETOREVIVE) ) then
            begin
              menureact(4);
              mouseleftstop := TRUE;
            end
        end;
    end;
end;

{
  ____                 _ _
 / ___|_ __ __ ___   _(_) |_ _   _
| |  _| '__/ _` \ \ / / | __| | | |
| |_| | | | (_| |\ V /| | |_| |_| |
 \____|_|  \__,_| \_/ |_|\__|\__, |
                             |___/
}
procedure Gravity;
var
  a,i: integer;
begin
  if ( not(player.jumping) ) then
    begin
      player.py := player.opy + (player.gravity*5)/fps;
      player.gravity := player.gravity - (GAME_WORLD_GRAVITY*5)/fps;
      if ( player.gravity < -(GAME_WORLD_GRAVITY_MAX*5)/fps ) then
        begin
          player.gravity := -(GAME_WORLD_GRAVITY_MAX*5)/fps;
        end;
      // kellett egy függvény, ami 90 körüli fpsnél 70 körüli értéket ad,
      // 35 körüli fps-nél 35-öt. Ezért használok sin()-t.
      if ( fps > 10 ) then a := fps-10
        else a := fps;
      if ( player.gravity < -(GAME_WORLD_GRAVITY*(70*sin(a*pi/180)))/fps ) then
        player.injurycausedbyfalling := player.injurycausedbyfalling + GAME_INJURYCAUSEDBYFALLING/(fps/2);
    end
   else
    begin
      player.gravity := player.gravity + ((sin(player.jmp*pi/180)*2)*80)/fps;
      // kellett egy függvény, ami 90 körüli fpsnél 5-öt, ill. 50-et ad,
      // 35 körüli fps-nél 1.9-et, ill. 70-et.
      // ezért py-nál 18-cal osztom az fps-t, és
      // jmp-nél megint sin() meg stb...
      if ( fps > 10 ) then a := fps-10
        else a := fps;
      player.py := player.opy + (player.gravity*(fps/18))/fps; //5 1.8
      player.jmp := player.jmp - (GAME_WORLD_GRAVITY*((65*sin(a*pi/180))*(1/sin(a*pi/180))))/fps;
      if ( player.jmp < 0.0 ) then
        begin
          player.jumping := FALSE;
          player.jmp := 0.0;
        end;
    end;
  for i := 0 to botsGetBotsCount()-1 do
    begin
      botsSetAttribfloat( i, baPY, botsGetAttribFloat(i,baOPY) + (botsGetAttribFloat(i,baGravity)*5)/fps );
      botsSetAttribfloat( i, baGravity, botsGetAttribFloat(i,baGravity) - (GAME_WORLD_GRAVITY*5)/fps );
      if ( botsGetAttribFloat( i, baGravity ) < -(GAME_WORLD_GRAVITY_MAX*5)/fps ) then
        begin
          botsSetAttribfloat( i, baGravity, -(GAME_WORLD_GRAVITY_MAX*5)/fps );
        end;
      if ( fps > 10 ) then a := fps-10
        else a := fps;
      if ( botsGetAttribFloat( i, baGravity ) < -(GAME_WORLD_GRAVITY*(70*sin(a*pi/180)))/fps ) then
        botsSetAttribfloat( i, baInjuryCbyF, botsGetAttribFloat(i,baInjuryCbyF) + 60/(fps/2) );
    end;
end;

procedure ImpulseControl;
var
  factor_impulsepx,factor_impulsepy,factor_impulsepz: single;
  factor_oimpulsepx,factor_oimpulsepy,factor_oimpulsepz: single;
  factor_ratio: single;
  i: integer;
begin
  for i := -1 to botsGetBotsCount()-1 do
    begin
      if ( i = -1 ) then
        begin
          factor_impulsepx := player.impulsepx;
          factor_impulsepy := player.impulsepy;
          factor_impulsepz := player.impulsepz;
        end
       else
        begin
          factor_impulsepx := botsGetAttribFloat(i,baImpulsePX);
          factor_impulsepy := botsGetAttribFloat(i,baImpulsePY);
          factor_impulsepz := botsGetAttribFloat(i,baImpulsePZ);
        end;
      factor_oimpulsepx := factor_impulsepx;
      factor_oimpulsepy := factor_impulsepy;
      factor_oimpulsepz := factor_impulsepz;
      factor_ratio := 1;

      if ( factor_impulsepx > 0.0 ) then
        begin
          factor_impulsepx := factor_impulsepx - abs(factor_ratio)/fps;
        end
       else if ( factor_impulsepx < 0.0 ) then
        begin
          factor_impulsepx := factor_impulsepx + abs(factor_ratio)/fps;
        end;
      if ( ((factor_oimpulsepx > 0.0) and (factor_impulsepx < 0.0))
                                       or
           ((factor_oimpulsepx < 0.0) and (factor_impulsepx > 0.0))
         ) then
        begin
          factor_impulsepx := 0.0;
        end;

      if ( factor_impulsepy > 0.0 ) then factor_impulsepy := factor_impulsepy - 1/fps
        else if ( factor_impulsepy < 0.0 ) then factor_impulsepy := factor_impulsepy + 1/fps;
      if ( ((factor_oimpulsepy > 0.0) and (factor_impulsepy < 0.0))
                                       or
           ((factor_oimpulsepy < 0.0) and (factor_impulsepy > 0.0))
         ) then
        begin
          factor_impulsepy := 0.0;
        end;

      if ( factor_impulsepz > 0.0 ) then factor_impulsepz := factor_impulsepz - 1/fps
        else if ( factor_impulsepz < 0.0 ) then factor_impulsepz := factor_impulsepz + 1/fps;
      if ( ((factor_oimpulsepz > 0.0) and (factor_impulsepz < 0.0))
                                       or
           ((factor_oimpulsepz < 0.0) and (factor_impulsepz > 0.0))
         ) then
        begin
          factor_impulsepz := 0.0;
        end;

      if ( i = -1 ) then
        begin
          player.impulsepx := factor_impulsepx;
          player.impulsepy := factor_impulsepy;
          player.impulsepz := factor_impulsepz;
          player.px := player.px + (player.impulsepx*80)/fps;
          player.py := player.py + (player.impulsepy*80)/fps;
          player.pz := player.pz + (player.impulsepz*80)/fps;
        end
       else
        begin
          botsSetAttribfloat(i,baImpulsePX,factor_impulsepx);
          botsSetAttribfloat(i,baImpulsePY,factor_impulsepy);
          botsSetAttribfloat(i,baImpulsePZ,factor_impulsepz);
          botsSetAttribfloat(i,baPX,botsGetAttribFloat(i,baPX) + (botsGetAttribFloat(i,baImpulsePX)*80)/fps);
          botsSetAttribfloat(i,baPY,botsGetAttribFloat(i,baPY) + (botsGetAttribFloat(i,baImpulsePY)*80)/fps);
          botsSetAttribfloat(i,baPZ,botsGetAttribFloat(i,baPZ) + (botsGetAttribFloat(i,baImpulsePZ)*80)/fps);
        end;

    end;
end;



{
  ____      _ _ _     _
 / ___|___ | | (_)___(_) ___  _ __
| |   / _ \| | | / __| |/ _ \| '_ \
| |__| (_) | | | \__ \ | (_) | | | |
 \____\___/|_|_|_|___/_|\___/|_| |_|

}
procedure Collision;
var
  l: boolean;
  l2: boolean;
  l3: boolean;
  i,nagyi: integer;
  colliding,colliding2,item: integer;
  ind,j: integer;
  mo_oldpos,mo_pos: TXYZ;
  factor_opx,factor_opy,factor_opz,factor_px,factor_py,factor_pz: single;
  factor_sx,factor_sy,factor_sz: single;
  factor_injurycausedbyfalling,factor_gravity,factor_jmp: single;
  factor_impulsepx,factor_impulsepy,factor_impulsepz: single;
  factor_health,factor_shield: integer;
  factor_hasquaddamage,factor_hasteleport,collzonewasactive: boolean;
  factor_lastqdmg: cardinal;

procedure setbotangle(index: integer; colliding: integer);
begin
  case collgetzonetype(colliding) of
    ctSlopeN: tmcssetanglez(botsGetattribint(index,bamodelnum),360-collslopegetangle(colliding));
    ctSlopeS: tmcssetanglez(botsGetattribint(index,bamodelnum),collslopegetangle(colliding));
    ctSlopeW: tmcssetanglex(botsGetattribint(index,bamodelnum),collslopegetangle(colliding));
    ctSlopeE: tmcssetanglex(botsGetattribint(index,bamodelnum),360-collslopegetangle(colliding));
        else begin
               tmcssetanglex(botsGetattribint(index,bamodelnum),0);
               tmcssetanglez(botsGetattribint(index,bamodelnum),0);
             end;
  end;
end;

begin
  for nagyi := -1 to botsGetBotsCount()-1 do
    begin
      if ( nagyi = -1 ) then
        begin
          factor_opx := player.opx;
          factor_opy := player.opy;
          factor_opz := player.opz;
          factor_px := player.px;
          factor_py := player.py;
          factor_pz := player.pz;
          factor_sx := player_sizex;
          factor_sy := player_sizey;
          factor_sz := player_sizez;
          factor_injurycausedbyfalling := player.injurycausedbyfalling;
          factor_health := player.health;
          factor_shield := player.shield;
          factor_hasquaddamage := player.hasquaddamage;
          factor_hasteleport := player.hasteleport;
          factor_jmp := player.jmp;
          factor_gravity := player.gravity;
          factor_impulsepx := player.impulsepx;
          factor_impulsepy := player.impulsepy;
          factor_impulsepz := player.impulsepz;
          factor_lastqdmg := player.lastqmd;
        end
       else
        begin
          factor_opx := botsGetAttribFloat(nagyi,baOPX);
          factor_opy := botsGetAttribFloat(nagyi,baOPy);
          factor_opz := botsGetAttribFloat(nagyi,baOPz);
          factor_px := botsGetAttribFloat(nagyi,baPX);
          factor_py := botsGetAttribFloat(nagyi,baPy);
          factor_pz := botsGetAttribFloat(nagyi,baPz);
          factor_sx := botsGetAttribFloat(nagyi,basx);
          factor_sy := botsGetAttribFloat(nagyi,basy);
          factor_sz := botsGetAttribFloat(nagyi,basz);
          factor_injurycausedbyfalling := botsGetAttribFloat(nagyi,baInjuryCbyF);
          factor_health := botsgetattribint(nagyi,baHealth);
          factor_shield := botsgetattribint(nagyi,bashield);
          factor_hasquaddamage := botsgetattribbool(nagyi,baHasquaddamage);
          factor_hasteleport := botsgetattribbool(nagyi,baHasteleport);
          factor_gravity := botsgetattribfloat(nagyi,baGravity);
          factor_impulsepx := botsgetattribfloat(nagyi,baImpulsePX);
          factor_impulsepy := botsgetattribfloat(nagyi,baImpulsePY);
          factor_impulsepz := botsgetattribfloat(nagyi,baImpulsePZ);
          // letiltjuk saját collzone-ját, ne ütközzön már saját magával XD
          collzonewasactive := collzoneisactive(botsgetattribint(nagyi,bacollzone));
          collDisableCollZone(botsGetAttribInt(nagyi,baCollZone));
          factor_lastqdmg := botsGetAttribInt(nagyi,baLastQDmg);
        end;
      // ütközik-e mozgó platformmal
      i := -1;
      l := FALSE;
      while ( not(l) and (i < mapgetmovingobjectcount()-1) ) do
        begin
          i := i + 1;
          l := collIsAreaInZone(factor_opx,factor_py,factor_opz,factor_sx,factor_sy,factor_sz,nagyi) = mapgetmovingobjectcollzone(i);
        end;

      // ütközik-e itemmel, ha igen, akkor item tárolja azt a bizonyos itemet
      i := -1;
      l2 := FALSE;
      while ( not(l2) and (i < mapgetitemcount()-1) ) do
        begin
          i := i + 1;
          colliding2 := collIsAreaInZone(factor_opx,factor_py,factor_opz,factor_sx,factor_sy,factor_sz,nagyi);
          l2 := ( colliding2 = mapgetitemcollzone(i) );
        end;
      if ( l2 ) then item := i;

      if ( ((factor_opy <> factor_py) or (l)) and not(l2) ) then
        begin
          colliding := collIsAreaInZone(factor_opx,factor_py,factor_opz,factor_sx,factor_sy,factor_sz,nagyi);
          if ( colliding > -1 ) then
            begin
              if ( collTestBoxCollisionAgainstZone(factor_opx,factor_py,factor_opz,factor_sx,factor_sy,factor_sz,colliding,nagyi) ) then
                begin
                  if ( collgetzonetype(colliding) in [ctSlopeN,ctSlopeS,ctSlopeW,ctSlopeE] ) then
                    begin  // slope collision
                      if ( factor_py+PLAYER_MAX_PASSABLE_HEIGHT_SLOPES >= collslopegetycoord(colliding,factor_opx,factor_py,factor_opz,factor_sx,factor_sy,factor_sz,nagyi) ) then
                        begin  // fel is lehet lépni rá
                          if (factor_py <= collslopegetycoord(colliding,factor_opx,factor_py,factor_opz,factor_sx,factor_sy,factor_sz,nagyi)+0.01) then
                            begin  // ne pozícionáljon egybõl rá a lejtõre, ha pl. ráesek
                              factor_py := collSlopeGetYCoord(colliding,factor_opx,factor_py,factor_opz,factor_sx,factor_sy,factor_sz,nagyi);
                              damagetoplayer(nagyi,(round(factor_injurycausedbyfalling)-5),FALSE);
                              factor_injurycausedbyfalling := 0;
                              factor_gravity := 0.0;
                              factor_jmp := -1;
                              factor_impulsepy := 0.0;
                              if ( (factor_health > 0) and (getplayerhealth(nagyi) = 0) ) then
                                begin
                                  subtractfrag(nagyi);
                                  adddeath(nagyi);
                                  neweventtext(getplayername2(nagyi),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(nagyi),gettickcount(),colorbyplayer(nagyi+1),colorbyplayer(nagyi+1));
                                end;
                            end
                           else
                            begin

                            end;
                        end
                       else
                        begin
                          factor_py := factor_opy;
                          damagetoplayer(nagyi,(round(player.injurycausedbyfalling)-5),FALSE);
                          factor_injurycausedbyfalling := 0;
                          factor_gravity := 0.0;
                          factor_jmp := -1;
                          factor_impulsepy := 0.0;
                          if ( (factor_health > 0) and (getplayerhealth(nagyi) = 0) ) then
                            begin
                              subtractfrag(nagyi);
                              adddeath(nagyi);
                              neweventtext(getplayername2(nagyi),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(nagyi),gettickcount(),colorbyplayer(nagyi+1),colorbyplayer(nagyi+1));
                            end;
                        end;
                    end
                   else
                    begin // másfajta collision
                      if ( collgetzonetype(colliding) = ctBox ) then
                        begin
                          if ( (factor_py-factor_sy/2) - (collgetzoneposy(colliding)+collgetzonesizey(colliding)/2) >= -PLAYER_MAX_PASSABLE_HEIGHT_BOXES) then
                            begin
                              if ( (factor_py-factor_sy/2) - (collgetzoneposy(colliding)+collgetzonesizey(colliding)/2) <= 0.0 ) then
                                begin
                                  damagetoplayer(nagyi,(round(factor_injurycausedbyfalling)-5),FALSE);
                                  factor_injurycausedbyfalling  := 0;
                                  factor_gravity := 0.0;
                                  factor_jmp := -1;
                                  factor_py := collgetzoneposy(colliding)+collgetzonesizey(colliding)/2+factor_sy/2 + 0.01;
                                  factor_impulsepy := 0.0;
                                  if ( (factor_health > 0) and (getplayerhealth(nagyi) = 0) ) then
                                    begin
                                      subtractfrag(nagyi);
                                      adddeath(nagyi);
                                      neweventtext(getplayername2(nagyi),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(nagyi),gettickcount(),colorbyplayer(nagyi+1),colorbyplayer(nagyi+1));
                                    end;
                                  // megkeresem a coll zónához tartozó movingobjectet
                                  j := -1;
                                  l3 := FALSE;
                                  while ( (j < mapgetmovingobjectcount()-1) and not(l3) ) do
                                    begin
                                      j := j+1;
                                      l3 := ( mapgetmovingobjectcollzone(j) = colliding );
                                    end;
                                  if ( l3 and (mapgetmovingobjecttype(j) <> moY) ) then
                                    begin
                                      mo_oldpos := mapgetmovingobjectoldpos(j);
                                      mo_pos := mapgetmovingobjectpos(j);
                                      factor_px := factor_px + (mo_pos.x - mo_oldpos.x)*2;
                                      factor_pz := factor_pz + (mo_pos.z - mo_oldpos.z)*2;
                                    end;
                                end
                               else
                                begin
                                  factor_py := factor_opy;
                                end;
                            end
                           else
                            begin
                              factor_py := factor_opy;
                              damagetoplayer(nagyi,(round(factor_injurycausedbyfalling)-5),FALSE);
                              factor_injurycausedbyfalling := 0;
                              factor_gravity := 0.0;
                              factor_jmp := -1;
                              factor_impulsepy := 0.0;
                              if ( (factor_health > 0) and (getplayerhealth(nagyi) = 0) ) then
                                begin
                                  subtractfrag(nagyi);
                                  adddeath(nagyi);
                                  neweventtext(getplayername2(nagyi),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(nagyi),gettickcount(),colorbyplayer(nagyi+1),colorbyplayer(nagyi+1));
                                end;
                              // megkeresem a coll zónához tartozó movingobjectet
                              j := -1;
                              l3 := FALSE;
                              while ( (j < mapgetmovingobjectcount()-1) and not(l3) ) do
                                begin
                                  j := j+1;
                                  l3 := ( mapgetmovingobjectcollzone(j) = colliding );
                                end;
                              if ( l3 and (mapgetmovingobjecttype(j) = moY) ) then
                                begin
                                  mapsetmovingobjectheading(j,not(mapgetmovingobjectheading(j)));
                                  movingobjects(j);
                                end;
                            end;
                        end
                       else
                        if ( collgetzonetype(colliding) = ctCylindrical ) then
                          begin
                            factor_py := factor_opy;
                            damagetoplayer(nagyi,(round(factor_injurycausedbyfalling)-5),FALSE);
                            factor_injurycausedbyfalling := 0;
                            factor_gravity := 0.0;
                            factor_jmp := -1;
                            factor_impulsepy := 0.0;
                            if ( (factor_health > 0) and (getplayerhealth(nagyi) = 0) ) then
                              begin
                                subtractfrag(nagyi);
                                adddeath(nagyi);
                                neweventtext(getplayername2(nagyi),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(nagyi),gettickcount(),colorbyplayer(nagyi+1),colorbyplayer(nagyi+1));
                              end;
                          end
                         else
                          if ( collgetzonetype(colliding) = ctSpherical ) then
                            begin
                              factor_py := factor_opy;
                              damagetoplayer(nagyi,(round(factor_injurycausedbyfalling)-5),FALSE);
                              factor_injurycausedbyfalling := 0;
                              factor_gravity := 0.0;
                              factor_jmp := -1;
                              factor_impulsepy := 0.0;
                              if ( (factor_health > 0) and (getplayerhealth(nagyi) = 0) ) then
                                begin
                                  subtractfrag(nagyi);
                                  adddeath(nagyi);
                                  neweventtext(getplayername2(nagyi),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(nagyi),gettickcount(),colorbyplayer(nagyi+1),colorbyplayer(nagyi+1));
                                end;
                            end;
                    end;
                end;
              if ( nagyi > -1 ) then setbotangle(nagyi,colliding);
            end; // colliding > -1
        end;

      // ütközök-e itemmel és ha igen, melyikkel
      if ( not(l2) ) then
        begin
          i := -1;
          while ( not(l2) and (i < mapgetitemcount()-1) ) do
            begin
              i := i + 1;
              colliding2 := collIsAreaInZone(factor_px,factor_py,factor_opz,factor_sx,factor_sy,factor_sz,nagyi);
              l2 := ( colliding2 = mapgetitemcollzone(i) );
            end;
          if ( l2 ) then item := i;
        end;

      if ( ((factor_opx <> factor_px) or (l)) and not(l2) ) then
        begin
          colliding := collIsAreaInZone(factor_px,factor_py,factor_opz,factor_sx,factor_sy,factor_sz,nagyi);
          if ( colliding > -1 ) then
            begin
              if ( collTestBoxCollisionAgainstZone(factor_px,factor_py,factor_opz,factor_sx,factor_sy,factor_sz,colliding,nagyi) ) then
                begin
                  if ( collgetzonetype(colliding) in [ctSlopeN,ctSlopeS,ctSlopeW,ctSlopeE] ) then
                    begin
                      if ( factor_py+PLAYER_MAX_PASSABLE_HEIGHT_SLOPES >= collslopegetycoord(colliding,factor_px,factor_py,factor_opz,factor_sx,factor_sy,factor_sz,nagyi) ) then
                        begin  // fel is lehet lépni rá
                          if (factor_py <= collslopegetycoord(colliding,factor_px,factor_py,factor_opz,factor_sx,factor_sy,factor_sz,nagyi)+0.01) then
                            begin  // ne pozícionáljon egybõl rá a lejtõre, ha pl. ráesek
                              factor_py := collSlopeGetYCoord(colliding,factor_px,factor_py,factor_opz,factor_sx,factor_sy,factor_sz,nagyi);
                              damagetoplayer(nagyi,(round(factor_injurycausedbyfalling)-5),FALSE);
                              factor_injurycausedbyfalling := 0;
                              factor_gravity := 0.0;
                              factor_jmp := -1;
                              factor_impulsepx := 0.0;
                              if ( nagyi > -1 ) then setbotangle(nagyi,colliding);
                              if ( (factor_health > 0) and (getplayerhealth(nagyi) = 0) ) then
                                begin
                                  subtractfrag(nagyi);
                                  adddeath(nagyi);
                                  neweventtext(getplayername2(nagyi),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(nagyi),gettickcount(),colorbyplayer(nagyi+1),colorbyplayer(nagyi+1));
                                end;
                            end
                           else
                            begin
                            end;
                        end
                       else
                        begin
                          factor_px := factor_opx;
                          factor_impulsepx := 0.0;
                          if ( nagyi > -1 ) then setbotangle(nagyi,colliding);
                        end;
                    end
                   else
                    begin
                      if ( collgetzonetype(colliding) = ctBox ) then
                        begin
                          if ( (factor_py-factor_sy/2) - (collgetzoneposy(colliding)+collgetzonesizey(colliding)/2) >= -PLAYER_MAX_PASSABLE_HEIGHT_BOXES) then
                            begin
                              if ( (factor_py-factor_sy/2) - (collgetzoneposy(colliding)+collgetzonesizey(colliding)/2) <= 0.0 ) then
                                begin
                                  damagetoplayer(nagyi,(round(factor_injurycausedbyfalling)-5),FALSE);
                                  factor_injurycausedbyfalling := 0;
                                  factor_gravity := 0.0;
                                  factor_jmp := -1;
                                  factor_py := collgetzoneposy(colliding)+collgetzonesizey(colliding)/2+factor_sy/2 + 0.01;
                                  factor_impulsepx := 0.0;
                                  if ( (factor_health > 0) and (getplayerhealth(nagyi) = 0) ) then
                                    begin
                                      subtractfrag(nagyi);
                                      adddeath(nagyi);
                                      neweventtext(getplayername2(nagyi),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(nagyi),gettickcount(),colorbyplayer(nagyi+1),colorbyplayer(nagyi+1));
                                    end;
                                end
                               else
                                begin

                                end;
                            end
                           else
                            begin

                            end; {}
                          factor_px := factor_opx;
                          factor_impulsepx := 0.0;
                        end
                       else
                        if ( collgetzonetype(colliding) = ctCylindrical ) then
                          begin
                            factor_px := factor_opx;
                            factor_impulsepx := 0.0;
                          end
                         else
                          if ( collgetzonetype(colliding) = ctSpherical ) then
                            begin
                              factor_px := factor_opx;
                              factor_impulsepx := 0.0;
                            end;
                    end;
                end;
              if ( nagyi > -1 ) then setbotangle(nagyi,colliding);
            end; // colliding > -1
        end;

      // ütközik-e itemmel, és ha igen, melyikkel
      if ( not(l2) ) then
        begin
          i := -1;
          while ( not(l2) and (i < mapgetitemcount()-1) ) do
            begin
              i := i + 1;
              colliding2 := collIsAreaInZone(factor_px,factor_py,factor_pz,factor_sx,factor_sy,factor_sz,nagyi);
              l2 := ( colliding2 = mapgetitemcollzone(i) );
            end;
          if ( l2 ) then item := i;
        end;

      if ( ((factor_opz <> factor_pz) or (l)) and not(l2) ) then
        begin
          colliding := collIsAreaInZone(factor_px,factor_py,factor_pz,factor_sx,factor_sy,factor_sz,nagyi);
          if ( colliding > -1 ) then
            begin
              if ( collTestBoxCollisionAgainstZone(factor_px,factor_py,factor_pz,factor_sx,factor_sy,factor_sz,colliding,nagyi) ) then
                begin
                  if ( collgetzonetype(colliding) in [ctSlopeN,ctSlopeS,ctSlopeW,ctSlopeE] ) then
                    begin
                      if ( factor_py+PLAYER_MAX_PASSABLE_HEIGHT_SLOPES >= collslopegetycoord(colliding,factor_px,factor_py,factor_pz,factor_sx,factor_sy,factor_sz,nagyi)) then
                        begin  // fel is lehet lépni rá
                          if (factor_py <= collslopegetycoord(colliding,factor_px,factor_py,factor_pz,factor_sx,factor_sy,factor_sz,nagyi)+0.01) then
                            begin
                              factor_py := collSlopeGetYCoord(colliding,factor_px,factor_py,factor_pz,factor_sx,factor_sy,factor_sz,nagyi);
                              damagetoplayer(nagyi,(round(factor_injurycausedbyfalling)-5),FALSE);
                              factor_injurycausedbyfalling := 0;
                              factor_gravity := 0.0;
                              factor_jmp := -1;
                              factor_impulsepz := 0.0;
                              if ( nagyi > -1 ) then setbotangle(nagyi,colliding);
                              if ( (factor_health > 0) and (getplayerhealth(nagyi) = 0) ) then
                                begin
                                  subtractfrag(nagyi);
                                  adddeath(nagyi);
                                  neweventtext(getplayername2(nagyi),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(nagyi),gettickcount(),colorbyplayer(nagyi+1),colorbyplayer(nagyi+1));
                                end;
                            end  // ne pozícionáljon egybõl rá a lejtõre, ha pl. ráesek
                           else
                            begin
                            end;
                        end
                       else
                        begin
                          factor_pz := factor_opz;
                          factor_impulsepz := 0.0;
                          if ( nagyi > -1 ) then setbotangle(nagyi,colliding);
                        end;
                    end
                   else
                    begin
                      if ( collgetzonetype(colliding) = ctBox ) then
                        begin
                          if ( (factor_py-factor_sy/2) - (collgetzoneposy(colliding)+collgetzonesizey(colliding)/2) >= -PLAYER_MAX_PASSABLE_HEIGHT_BOXES) then
                            begin
                              if ( (factor_py-factor_sy/2) - (collgetzoneposy(colliding)+collgetzonesizey(colliding)/2) <= 0.0 ) then
                                begin
                                  damagetoplayer(nagyi,(round(factor_injurycausedbyfalling)-5),FALSE);
                                  factor_injurycausedbyfalling := 0;
                                  factor_gravity := 0.0;
                                  factor_jmp := -1;
                                  factor_py := collgetzoneposy(colliding)+collgetzonesizey(colliding)/2+factor_sy/2 + 0.01;
                                  factor_impulsepz := 0.0;
                                  if ( (factor_health > 0) and (getplayerhealth(nagyi) = 0) ) then
                                    begin
                                      subtractfrag(nagyi);
                                      adddeath(nagyi);
                                      neweventtext(getplayername2(nagyi),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(nagyi),gettickcount(),colorbyplayer(nagyi+1),colorbyplayer(nagyi+1));
                                    end;
                                end
                               else
                                begin

                                end;
                            end
                           else
                            begin

                            end; {}
                          factor_pz := factor_opz;
                          factor_impulsepz := 0.0;
                        end
                       else
                        if ( collgetzonetype(colliding) = ctCylindrical ) then
                          begin
                            factor_pz := factor_opz;
                            factor_impulsepz := 0.0;
                          end
                         else
                          if ( collgetzonetype(colliding) = ctSpherical ) then
                            begin
                              factor_pz := factor_opz;
                              factor_impulsepz := 0.0;
                            end;
                    end;
                end; // colliding > -1
              if ( nagyi > -1 ) then setbotangle(nagyi,colliding);
            end;
        end;   {}

      if ( l2 and (factor_health > 0) ) then // itemmel ütköztünk és élünk
        begin
          if ( factor_health > 0 ) then
            begin
              case mapgetitemtype(item) of
                itTeleport: begin
                              if ( not(factor_hasteleport) ) then
                                begin
                                  if (settings^.audio_sfx) then
                                    begin
                                      snd_pos.x := factor_px;
                                      snd_pos.y := factor_py;
                                      snd_pos.z := factor_pz;
                                      sndchn := FSOUND_playsoundex(FSOUND_free,snd_teleport,nil,TRUE);
                                      FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                                      FSOUND_setpaused(sndchn,FALSE);
                                    end;
                                  factor_hasteleport := TRUE;
                                  defItemPickupProc(item,gettickcount(),colliding2,collGetAttachedObject(colliding2));
                                  if ( nagyi = -1 ) then newitemtext(GAME_ITEMS_TEXTS[ord(mapgetitemtype(item))],255,255,255,255,gettickcount());
                                end;
                            end;
                itHealth: begin
                            if ( factor_health <= GAME_MAX_HEALTH - GAME_ITEM_HEALTH ) then
                              begin
                                if (settings^.audio_sfx) then
                                  begin
                                    snd_pos.x := factor_px;
                                    snd_pos.y := factor_py;
                                    snd_pos.z := factor_pz;
                                    sndchn := FSOUND_playsoundex(FSOUND_free,snd_health,nil,TRUE);
                                    FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                                    FSOUND_setpaused(sndchn,FALSE);
                                  end;
                                factor_health := factor_health + GAME_ITEM_HEALTH;
                                defItemPickupProc(item,gettickcount(),colliding2,collGetAttachedObject(colliding2));
                                if ( nagyi = -1 ) then newitemtext(GAME_ITEMS_TEXTS[ord(mapgetitemtype(item))],255,255,255,255,gettickcount());
                              end
                             else
                              begin
                                if ( factor_health < GAME_MAX_HEALTH ) then
                                  begin
                                    if (settings^.audio_sfx) then
                                      begin
                                        snd_pos.x := factor_px;
                                        snd_pos.y := factor_py;
                                        snd_pos.z := factor_pz;
                                        sndchn := FSOUND_playsoundex(FSOUND_free,snd_health,nil,TRUE);
                                        FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                                        FSOUND_setpaused(sndchn,FALSE);
                                      end;
                                    factor_health := game_MAX_HEALTH;
                                    defItemPickupProc(item,gettickcount(),colliding2,collGetAttachedObject(colliding2));
                                    if ( nagyi = -1 ) then newitemtext(GAME_ITEMS_TEXTS[ord(mapgetitemtype(item))],255,255,255,255,gettickcount());
                                  end;
                              end;
                          end;
                itShield: begin
                            if ( factor_shield <= GAME_MAX_SHIELD - GAME_ITEM_SHIELD ) then
                              begin
                                if (settings^.audio_sfx) then
                                  begin
                                    snd_pos.x := factor_px;
                                    snd_pos.y := factor_py;
                                    snd_pos.z := factor_pz;
                                    sndchn := FSOUND_playsoundex(FSOUND_free,snd_shield,nil,TRUE);
                                    FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                                    FSOUND_setpaused(sndchn,FALSE);
                                  end;
                                factor_shield := factor_shield + GAME_ITEM_SHIELD;
                                defItemPickupProc(item,gettickcount(),colliding2,collGetAttachedObject(colliding2));
                                if ( nagyi = -1 ) then newitemtext(GAME_ITEMS_TEXTS[ord(mapgetitemtype(item))],255,255,255,255,gettickcount());
                              end
                             else
                              begin
                                if ( player.shield < GAME_MAX_SHIELD ) then
                                  begin
                                    if (settings^.audio_sfx) then
                                      begin
                                        snd_pos.x := factor_px;
                                        snd_pos.y := factor_py;
                                        snd_pos.z := factor_pz;
                                        sndchn := FSOUND_playsoundex(FSOUND_free,snd_health,nil,TRUE);
                                        FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                                        FSOUND_setpaused(sndchn,FALSE);
                                      end;
                                    factor_shield := GAME_MAX_SHIELD;
                                    defItemPickupProc(item,gettickcount(),colliding2,collGetAttachedObject(colliding2));
                                    if ( nagyi = -1 ) then newitemtext(GAME_ITEMS_TEXTS[ord(mapgetitemtype(item))],255,255,255,255,gettickcount());
                                  end;
                              end;
                          end;
                itQuadDamage: begin
                                if ( not(factor_hasquaddamage) ) then
                                  begin
                                    if (settings^.audio_sfx) then
                                      begin
                                        snd_pos.x := factor_px;
                                        snd_pos.y := factor_py;
                                        snd_pos.z := factor_pz;
                                        sndchn := FSOUND_playsoundex(FSOUND_free,snd_quaddamage,nil,TRUE);
                                        FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                                        FSOUND_setpaused(sndchn,FALSE);
                                      end;
                                    factor_hasquaddamage := TRUE;
                                    defItemPickupProc(item,gettickcount(),colliding2,collGetAttachedObject(colliding2));
                                    factor_lastqdmg := gettickcount();
                                    if ( nagyi = -1 ) then newitemtext(GAME_ITEMS_TEXTS[ord(mapgetitemtype(item))],255,255,255,255,gettickcount());
                                  end;
                              end;
                itWpnPistolAmmo: begin
                                   if ( nagyi = -1 ) then
                                     begin
                                       if ( player.wpnsinfo.bulletsinfo[1].total <= GAME_ITEM_WPN_PISTOL_MAX - GAME_ITEM_WPN_PISTOL_AMMO_DEF ) then
                                         begin
                                           if (settings^.audio_sfx) then
                                             begin
                                               snd_pos.x := factor_px;
                                               snd_pos.y := factor_py;
                                               snd_pos.z := factor_pz;
                                               sndchn := FSOUND_playsoundex(FSOUND_free,snd_pistolammo,nil,TRUE);
                                               FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                                               FSOUND_setpaused(sndchn,FALSE);
                                             end;
                                           player.wpnsinfo.bulletsinfo[1].total := player.wpnsinfo.bulletsinfo[1].total + GAME_ITEM_WPN_PISTOL_AMMO_DEF;
                                           defItemPickupProc(item,gettickcount(),colliding2,collGetAttachedObject(colliding2));
                                           newitemtext(GAME_ITEMS_TEXTS[ord(mapgetitemtype(item))],255,255,255,255,gettickcount());
                                         end
                                        else
                                         begin
                                           if ( player.wpnsinfo.bulletsinfo[1].total < GAME_ITEM_WPN_PISTOL_MAX ) then
                                             begin
                                               if (settings^.audio_sfx) then
                                                 begin
                                                   snd_pos.x := factor_px;
                                                   snd_pos.y := factor_py;
                                                   snd_pos.z := factor_pz;
                                                   sndchn := FSOUND_playsoundex(FSOUND_free,snd_pistolammo,nil,TRUE);
                                                   FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                                                   FSOUND_setpaused(sndchn,FALSE);
                                                 end;
                                               player.wpnsinfo.bulletsinfo[1].total := GAME_ITEM_WPN_PISTOL_MAX;
                                               defItemPickupProc(item,gettickcount(),colliding2,collGetAttachedObject(colliding2));
                                               newitemtext(GAME_ITEMS_TEXTS[ord(mapgetitemtype(item))],255,255,255,255,gettickcount());
                                             end;
                                         end;
                                     end;
                                 end;
                itWpnMchGunAmmo: begin
                                   if ( nagyi = -1 ) then
                                     begin
                                       if ( player.wpnsinfo.bulletsinfo[2].total <= GAME_ITEM_WPN_MCHGUN_MAX - GAME_ITEM_WPN_MCHGUN_AMMO_DEF ) then
                                         begin
                                           if (settings^.audio_sfx) then
                                             begin
                                               snd_pos.x := factor_px;
                                               snd_pos.y := factor_py;
                                               snd_pos.z := factor_pz;
                                               sndchn := FSOUND_playsoundex(FSOUND_free,snd_mchgunammo,nil,TRUE);
                                               FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                                               FSOUND_setpaused(sndchn,FALSE);
                                             end;
                                           player.wpnsinfo.bulletsinfo[2].total := player.wpnsinfo.bulletsinfo[2].total + GAME_ITEM_WPN_MCHGUN_AMMO_DEF;
                                           defItemPickupProc(item,gettickcount(),colliding2,collGetAttachedObject(colliding2));
                                           obj_wpn_mchgun_lcdnums_alpha_inc := FALSE;
                                           obj_wpn_mchgun_lcdnums_alpha := GAME_WPN_MCHGUN_LCD_ALPHA_MAX;
                                           newitemtext(GAME_ITEMS_TEXTS[ord(mapgetitemtype(item))],255,255,255,255,gettickcount());
                                         end
                                        else
                                         begin
                                           if ( player.wpnsinfo.bulletsinfo[2].total < GAME_ITEM_WPN_MCHGUN_MAX ) then
                                             begin
                                               if (settings^.audio_sfx) then
                                                 begin
                                                   snd_pos.x := factor_px;
                                                   snd_pos.y := factor_py;
                                                   snd_pos.z := factor_pz;
                                                   sndchn := FSOUND_playsoundex(FSOUND_free,snd_mchgunammo,nil,TRUE);
                                                   FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                                                   FSOUND_setpaused(sndchn,FALSE);
                                                 end;
                                               player.wpnsinfo.bulletsinfo[2].total := GAME_ITEM_WPN_MCHGUN_MAX;
                                               defItemPickupProc(item,gettickcount(),colliding2,collGetAttachedObject(colliding2));
                                               obj_wpn_mchgun_lcdnums_alpha_inc := FALSE;
                                               obj_wpn_mchgun_lcdnums_alpha := GAME_WPN_MCHGUN_LCD_ALPHA_MAX;
                                               newitemtext(GAME_ITEMS_TEXTS[ord(mapgetitemtype(item))],255,255,255,255,gettickcount());
                                             end;
                                         end;
                                     end;
                                 end;
                itWpnRocketAmmo: begin
                                   if ( nagyi = -1 ) then
                                     begin
                                       if ( player.wpnsinfo.bulletsinfo[3].total <= GAME_ITEM_WPN_ROCKETLAUNCHER_MAX - GAME_ITEM_WPN_ROCKETLAUNCHER_AMMO_DEF ) then
                                         begin
                                           if (settings^.audio_sfx) then
                                             begin
                                               snd_pos.x := factor_px;
                                               snd_pos.y := factor_py;
                                               snd_pos.z := factor_pz;
                                               sndchn := FSOUND_playsoundex(FSOUND_free,snd_rocketammo,nil,TRUE);
                                               FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                                               FSOUND_setpaused(sndchn,FALSE);
                                             end;
                                           player.wpnsinfo.bulletsinfo[3].total := player.wpnsinfo.bulletsinfo[3].total + GAME_ITEM_WPN_ROCKETLAUNCHER_AMMO_DEF;
                                           defItemPickupProc(item,gettickcount(),colliding2,collGetAttachedObject(colliding2));
                                           newitemtext(GAME_ITEMS_TEXTS[ord(mapgetitemtype(item))],255,255,255,255,gettickcount());
                                         end
                                        else
                                         begin
                                           if ( player.wpnsinfo.bulletsinfo[3].total < GAME_ITEM_WPN_ROCKETLAUNCHER_MAX ) then
                                             begin
                                               if (settings^.audio_sfx) then
                                                 begin
                                                   snd_pos.x := factor_px;
                                                   snd_pos.y := factor_py;
                                                   snd_pos.z := factor_pz;
                                                   sndchn := FSOUND_playsoundex(FSOUND_free,snd_rocketammo,nil,TRUE);
                                                   FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                                                   FSOUND_setpaused(sndchn,FALSE);
                                                 end;
                                               player.wpnsinfo.bulletsinfo[3].total := GAME_ITEM_WPN_ROCKETLAUNCHER_MAX;
                                               defItemPickupProc(item,gettickcount(),colliding2,collGetAttachedObject(colliding2));
                                               newitemtext(GAME_ITEMS_TEXTS[ord(mapgetitemtype(item))],255,255,255,255,gettickcount());
                                             end;
                                         end;
                                     end;
                                 end;
              end;
          end;  // player.health > 0
        end;
      if ( nagyi = -1 ) then
        begin
          player.opx := factor_opx;
          player.opy := factor_opy;
          player.opz := factor_opz;
          player.px := factor_px;
          player.py := factor_py;
          player.pz := factor_pz;
          player.injurycausedbyfalling := factor_injurycausedbyfalling;
          player.hasquaddamage := factor_hasquaddamage;
          player.lastqmd := factor_lastqdmg;
          player.hasteleport := factor_hasteleport;
          player.gravity := factor_gravity;
          player.jmp := factor_jmp;
          player.impulsepx := factor_impulsepx;
          player.impulsepy := factor_impulsepy;
          player.impulsepz := factor_impulsepz;
          if ( l2 and (mapgetitemtype(item) in [itHealth,itShield]) ) then
            begin  // ha életet vagy pajzsot felvettünk, akkor az új értékek kellenek
              player.health := factor_health;
              player.shield := factor_shield;
            end
        end
       else
        begin
          botsSetAttribfloat(nagyi,baOPX,factor_opx);
          botsSetAttribfloat(nagyi,baOPY,factor_opy);
          botsSetAttribfloat(nagyi,baOPZ,factor_opz);
          botsSetAttribfloat(nagyi,baPX,factor_px);
          botsSetAttribfloat(nagyi,baPY,factor_py);
          botsSetAttribfloat(nagyi,baPZ,factor_pz);
          botsSetAttribfloat(nagyi,baInjuryCbyF,factor_injurycausedbyfalling);
          botsSetAttribbool(nagyi,baHasquaddamage,factor_hasquaddamage);
          botsSetAttribInt(nagyi,baLastQDmg,factor_lastqdmg);
          botsSetAttribbool(nagyi,baHasteleport,factor_hasteleport);
          botsSetAttribfloat(nagyi,baGravity,factor_gravity);
          botsSetAttribfloat(nagyi,baImpulsePX,factor_impulsepx);
          botsSetAttribfloat(nagyi,baImpulsePY,factor_impulsepy);
          botsSetAttribfloat(nagyi,baImpulsePZ,factor_impulsepz);
          // letiltott collzone visszaállítása
          if ( collzonewasactive ) then collEnableCollZone(botsGetAttribInt(nagyi,baCollZone));
          if ( l2 and (mapgetitemtype(item) in [itHealth,itShield]) ) then
            begin  // ha életet vagy pajzsot felvettek, akkor az új értékek kellenek
              botsSetAttribint(nagyi,baHealth,factor_health);
              botsSetAttribint(nagyi,baShield,factor_shield);
            end
        end;
    end;  // ciklus nagyi
end;

{
 ____  _          ____
/ ___|| | ___   _| __ )  _____  __
\___ \| |/ / | | |  _ \ / _ \ \/ /
 ___) |   <| |_| | |_) | (_) >  <
|____/|_|\_\\__, |____/ \___/_/\_\
            |___/
}
procedure SkyBox;
begin
  if ( obj_skybox > -1 ) then
    begin
      tmcsSetXPos(obj_skybox,player.px);
      tmcsSetYPos(obj_skybox,player.py);
      tmcsSetZPos(obj_skybox,player.pz);
    end;
end;

{
 __  __       _   _               ____  _
|  \/  | ___ | |_(_) ___  _ __   | __ )| |_   _ _ __
| |\/| |/ _ \| __| |/ _ \| '_ \  |  _ \| | | | | '__|
| |  | | (_) | |_| | (_) | | | | | |_) | | |_| | |
|_|  |_|\___/ \__|_|\___/|_| |_| |____/|_|\__,_|_|

}
procedure MotionBlurControl;
begin
  if ( settings^.video_motionblur = 1 ) then
    begin // motion blur mindig
      if ( mblurcolor.alpha > fps*GAME_BASE_MBLURALPHA_MULTIPLIER ) then
        mblurcolor.alpha := mblurcolor.alpha - GAME_BASE_MBLUR_FADESPEED/fps;
      if ( mblurcolor.alpha < fps*GAME_BASE_MBLURALPHA_MULTIPLIER ) then
        mblurcolor.alpha := fps*GAME_BASE_MBLURALPHA_MULTIPLIER;
      if ( mblurcolor.green < 255 ) then
        begin
          if ( mblurcolor.green + GAME_BASE_MBLUR_FADESPEED/fps > 255 ) then
            mblurcolor.green := 255
           else mblurcolor.green := mblurcolor.green + GAME_BASE_MBLUR_FADESPEED/fps;
        end;
      if ( mblurcolor.blue < 255 ) then
        begin
          if ( mblurcolor.blue + GAME_BASE_MBLUR_FADESPEED/fps > 255 ) then
            mblurcolor.blue := 255
           else mblurcolor.blue := mblurcolor.blue + GAME_BASE_MBLUR_FADESPEED/fps;
        end;
    end
   else if ( settings^.video_motionblur = 2 ) then
    begin // motion blur csak sérülésnél
      if ( mblurcolor.alpha > 0 ) then
        begin
          if ( mblurcolor.alpha - (GAME_BASE_MBLUR_FADESPEED*2)/fps < 0 ) then
            mblurcolor.alpha := 0
           else
            mblurcolor.alpha := mblurcolor.alpha - (GAME_BASE_MBLUR_FADESPEED*2)/fps;
        end;
      if ( mblurcolor.green < 255.0 ) then
        begin
          if ( mblurcolor.green + (GAME_BASE_MBLUR_FADESPEED*2)/fps > 255 ) then
            mblurcolor.green := 255.0
           else mblurcolor.green := mblurcolor.green + (GAME_BASE_MBLUR_FADESPEED*2)/fps;
        end;
      if ( mblurcolor.blue < 255.0 ) then
        begin
          if ( mblurcolor.blue + (GAME_BASE_MBLUR_FADESPEED*2)/fps > 255 ) then
            mblurcolor.blue := 255.0
           else mblurcolor.blue := mblurcolor.blue + (GAME_BASE_MBLUR_FADESPEED*2)/fps;
        end;
      if ( (mblurcolor.green = 255.0) and (mblurcolor.blue = 255.0) and (mblurcolor.alpha = 0.0) ) then
        begin
          tmcsDisableMotionBlur();
        end
       else
        begin
          tmcsenablemotionblur(getNearestPowerOf2(settings^.video_res_w),getNearestPowerOf2(settings^.video_res_w));
        end;
    end
   else // csak bloodplane van
    begin
      if ( bloodplanecolor.alpha > 0 ) then
        begin
          if (settings^.game_showblood) then tmcsshowobject(obj_bloodplane);
          if ( bloodplanecolor.alpha - (GAME_BASE_MBLUR_FADESPEED*2)/fps < 0 ) then
            bloodplanecolor.alpha := 0
           else
            bloodplanecolor.alpha := bloodplanecolor.alpha - (GAME_BASE_MBLUR_FADESPEED*2)/fps;
          tmcssetobjectcolor(obj_bloodplane,
                                round(bloodplanecolor.alpha),
                                0,
                                0);
        end
       else tmcshideobject(obj_bloodplane);
    end;
  if ( mblurcolor.red > 255.0 ) then mblurcolor.red := 255.0;
  if ( mblurcolor.green > 255.0 ) then mblurcolor.green := 255.0;
  if ( mblurcolor.blue > 255.0 ) then mblurcolor.blue := 255.0;
  if ( mblurcolor.alpha > 255.0 ) then mblurcolor.alpha := 255.0;
  tmcsSetMotionBlurColor(round(mblurcolor.red),round(mblurcolor.green),round(mblurcolor.blue),
                         round(mblurcolor.alpha));
end;

{
 _____                         _     _           _ _
|  ___| __ __ _ _ __ ___   ___| |   (_)_ __ ___ (_) |_ ___ _ __
| |_ | '__/ _` | '_ ` _ \ / _ \ |   | | '_ ` _ \| | __/ _ \ '__|
|  _|| | | (_| | | | | | |  __/ |___| | | | | | | | ||  __/ |
|_|  |_|  \__,_|_| |_| |_|\___|_____|_|_| |_| |_|_|\__\___|_|

}
procedure FrameLimiter;
var
  alma: integer;
begin
  if ( GAME_MAXFPS > 0 ) then
    begin
      alma := (1000 div GAME_MAXFPS) - fps_ms2;
      if ( almafa ) then
      begin
        almafa := false;
      end;
      if ( (alma > 0) ) then
      begin
        if ( alma < 20 ) then
          sleep(alma);
      end
        else sleep(1);
    end;
end;

// biztosítja, hogy a pályáról kirepült játékosok nem repülnek örökké és meghalnak XD
procedure PlayersWithinBounds;
var
  i: integer;
begin
  if ( (player.px <= -mapGetSizeX()*1.5) or (player.px >= mapGetSizeX()*1.5) ) then
    player.impulsepx := 0.0;
  if ( (player.pz <= -mapGetSizeZ()*1.5) or (player.pz >= mapGetSizeZ()*1.5) ) then
    player.impulsepz := 0.0;
  if ( player.py >= mapGetSizeY()*2.5 ) then
    begin
      player.jmp := 0.0;
      player.jumping := FALSE;
      player.impulsepy := 0.0;
    end
   else if ( player.py <= -mapGetSizeY()*1.5 ) then
    begin
      player.impulsepy := 0.0;
      player.gravity := 0.0;
      if ( player.health > 0 ) then
        begin
          if (settings^.audio_sfx) then
            begin
              sndchn := FSOUND_playsoundex(FSOUND_free,snd_splat,nil,TRUE);
              snd_pos.x := player.px;
              snd_pos.y := player.py;
              snd_pos.z := player.pz;
              FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
              FSOUND_setpaused(sndchn,FALSE);
            end;
          DamageToPlayer(-1,GAME_MAX_HEALTH,FALSE);
          subtractfrag(-1);
          adddeath(-1);
          neweventtext(getplayername2(-1),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(-1),gettickcount(),colorbyplayer(0),colorbyplayer(0));
        end;
    end;
  for i := 0 to botsGetBotsCount()-1 do
    begin
      if ( (botsGetAttribFloat(i,baPX) <= -mapGetSizex()*1.5) or (botsGetAttribFloat(i,baPX) >= mapgetsizex()*1.5) ) then
        botsSetAttribfloat(i,baImpulsePX,0.0);
      if ( (botsGetAttribFloat(i,baPZ) <= -mapgetsizez()*1.5) or (botsGetAttribFloat(i,baPZ) >= mapgetsizez()*1.5) ) then
        botsSetAttribfloat(i,baImpulsePZ,0.0);
      if ( botsGetAttribFloat(i,baPY) >= mapgetsizey()*2.5 ) then
        begin
          botsSetAttribfloat(i,baImpulsePY,0.0);
        end
       else if ( botsGetAttribFloat(i,baPY) <= -mapgetsizey()*1.5) then
        begin
          botsSetAttribfloat(i,baImpulsePY,0.0);
          botsSetAttribfloat(i,baGravity,0.0);
          if ( botsGetAttribInt(i,baHealth) > 0 ) then
            begin
              if (settings^.audio_sfx) then
                begin
                  sndchn := FSOUND_playsoundex(FSOUND_free,snd_splat,nil,TRUE);
                  snd_pos.x := botsGetAttribFloat(i,baPX);
                  snd_pos.y := botsGetAttribFloat(i,baPY);
                  snd_pos.z := botsGetAttribFloat(i,baPZ);
                  FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                  FSOUND_setpaused(sndchn,FALSE);
                end;
              DamageToPlayer(i,GAME_MAX_HEALTH,FALSE);
              subtractfrag(i);
              adddeath(i);
              neweventtext(getplayername2(i),GAME_EVENTS_DEATH_DIVIDERSTRING,getplayername2(i),gettickcount(),colorbyplayer(i+1),colorbyplayer(i+1));
            end;
        end;
    end;
end;

procedure ManageBotsDeath(index: integer);
var
  tmpsize: single;
  ckey,ckey2: trgba;
  blend_s,blend_d: TGLConst;
begin
  if ( botsgetattribint(index,bahealth) = 0 ) then
    begin
      if ( tmcsisvisible(botsgetattribint(index,bamodelnum) ) ) then
        begin
          tmcssetobjectblending(botsgetattribint(index,bamodelnum),TRUE);
          tmcssetobjectblendmode(botsgetattribint(index,bamodelnum),GL_SRC_alpha,gl_one_minus_src_alpha);
          if ( botsgetattribfloat(index,bayrotspeed) < BOTS_DEATH_YROTSPEED_MAX ) then
            botssetattribfloat(index,bayrotspeed,botsgetattribfloat(index,bayrotspeed)+BOTS_DEATH_YROTSPEED/fps);
          if ( botsgetattribfloat(index,bayrotspeed) > BOTS_DEATH_YROTSPEED_MAX ) then
            botssetattribfloat(index,bayrotspeed,BOTS_DEATH_YROTSPEED_MAX);
          tmcsyrotateobject(botsgetattribint(index,bamodelnum),
                            tmcsgetangley(botsgetattribint(index,bamodelnum))+botsgetattribfloat(index,bayrotspeed));
          ckey2 := tmcsgetobjectcolorkey(botsgetattribint(index,bamodelnum));
          if ( ckey2.alpha - BOTS_DEATH_YROTSPEED/fps < 0 ) then ckey2.alpha := 0
            else ckey2.alpha := round(ckey2.alpha - BOTS_DEATH_YROTSPEED/fps);
          tmcssetobjectcolorkey(botsgetattribint(index,bamodelnum),ckey2.red,ckey2.green,ckey2.blue,ckey2.alpha);
          tmpsize := random(round(BOTS_DEATH_SMOKE_SIZE));
          if ( settings^.reserved2 > 0 ) then
            begin
              if (lastsmoke > 0) then lastsmoke := lastsmoke - 1
               else
                begin
                  if ( botsisbot(index,botSnail) ) then
                    begin
                      ckey.red := 0;
                      ckey.green := 200;
                      ckey.blue := 0;
                      blend_s := gl_src_alpha;
                      blend_d := gl_one;
                    end
                   else
                    begin
                      ckey.red := 255;
                      ckey.green := 255;
                      ckey.blue := 255;
                      blend_s := gl_src_color;
                      blend_d := gl_one_minus_src_color;
                    end;
                  newsmoke(BOTS_DEATH_SMOKE_SIZE - tmpsize,
                           BOTS_DEATH_SMOKE_SIZE - tmpsize,
                           botsgetattribfloat(index,bapx),
                           botsgetattribfloat(index,bapy),
                           botsgetattribfloat(index,bapz),
                           0,
                           tmcsgetangley(botsgetattribint(index,bamodelnum)),
                           TRUE,
                           ckey.red,
                           ckey.green,
                           ckey.blue,
                           blend_s,
                           blend_d
                          );
                  case settings^.reserved2 of
                    1: lastsmoke := 10;
                    2: lastsmoke := 4;
                    3: lastsmoke := 2;
                  end;
                end;
            end
           else
            begin
            end;
          if ( ckey2.alpha = 0 ) then
            begin
              tmcshideobject(botsgetattribint(index,bamodelnum));
              tmcssetobjectblending(botsgetattribint(index,bamodelnum),FALSE);
              tmcssetobjectcolorkey(botsgetattribint(index,bamodelnum),ckey2.red,ckey2.green,ckey2.blue,255);
            end;
        end
       else
        begin
          reviveplayer(index);
        end;
    end;
end;

procedure BotBulletProc;
var
  i: integer;
begin
  for i := 0 to botsGetBotsCount()-1 do
    begin
      if ( botsGetAttribBool(i,baAttacking) ) then
        begin
          snd_pos.x := botsGetAttribFloat(i,baOPX);
          snd_pos.y := botsGetAttribFloat(i,baOPY);
          snd_pos.z := botsGetAttribFloat(i,baOPZ);
          if ( botsIsBot(i,botSnail) ) then
            begin // csiga lõ, tehát raksi
              newbullet(3,i,
                        botsGetAttribFloat(i,baOPX),botsGetAttribFloat(i,baOPY)+BOTS_SNAIL_ROCKET_START_Y,botsGetAttribFloat(i,baOPZ),
                        tmcsgetanglex(botsGetAttribInt(i,bamodelnum))+tmcsgetanglez(botsGetAttribInt(i,bamodelnum)),
                        tmcsgetangley(botsGetAttribInt(i,bamodelnum)),
                        tmcsgetanglez(botsGetAttribInt(i,bamodelnum))+tmcsgetanglex(botsGetAttribInt(i,bamodelnum))
                       );
              if (settings^.audio_sfx) then
                begin
                  sndchn := FSOUND_playsoundex(FSOUND_free,snd_rocketl,nil,TRUE);
                  FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                  FSOUND_setpaused(sndchn,FALSE);
                end;
            end
           else
            begin // robot lõ, tehát mchgun bullet
              newbullet(2,i,
                        botsGetAttribFloat(i,baOPX),botsGetAttribFloat(i,baOPY)+BOTS_ROBOT_BULLET_START_Y,botsGetAttribFloat(i,baOPZ),
                        tmcsgetanglex(botsGetAttribInt(i,bamodelnum))+tmcsgetanglez(botsGetAttribInt(i,bamodelnum)),
                        tmcsgetangley(botsGetAttribInt(i,bamodelnum)),
                        tmcsgetanglez(botsGetAttribInt(i,bamodelnum))+tmcsgetanglex(botsGetAttribInt(i,bamodelnum))
                       );
              tmcsShowObject(botsGetAttribInt(i,baModelNum2));
              if (settings^.audio_sfx) then
                begin
                  sndchn := FSOUND_playsoundex(FSOUND_free,snd_mchgun,nil,TRUE);
                  FSOUND_3d_setattributes(sndchn,@snd_pos,nil);
                  FSOUND_setpaused(sndchn,FALSE);
                end;
            end;
          botsSetAttribBool(i,baAttacking,FALSE);
        end
       else
        begin
          if ( botsIsBot(i,botRobot) ) then tmcsHideObject(botsGetAttribInt(i,baModelNum2));
        end;
    end;
end;

procedure C_InGameMenuProcedure;
var
  i: integer;
  l: boolean;
begin
  fps_ms := GetTickCount();
  tmcsRender();
  Keyboard;
  Mouse;
  l := FALSE;
  for i := 1 to GAME_INGAME_MENU_BTNCOUNT do
    begin
      menubtn_px := round(((gamewindow.wndrect.Right-gamewindow.wndrect.Left) div 2)-tmcsgetxpos(obj_menubtns_up[i]))+gamewindow.wndrect.Left;
      menubtn_py := round(((gamewindow.wndrect.bottom-gamewindow.wndrect.top) div 2)-tmcsgetypos(obj_menubtns_up[i]))+gamewindow.wndrect.top;
      if (
           (ocur.X >= menubtn_px - round(GAME_INGAME_MENU_BTN_EFFECTIVE_WIDTH*menuscalex) div 2)
                                       and
           (ocur.X <= menubtn_px + round(GAME_INGAME_MENU_BTN_EFFECTIVE_WIDTH*menuscalex) div 2)
                                       and
           (ocur.Y >= menubtn_py - round(GAME_INGAME_MENU_BTN_EFFECTIVE_HEIGHT*menuscaley) div 2 + menu_x1_bias*menuscaley)
                                       and
           (ocur.Y <= menubtn_py + round(GAME_INGAME_MENU_BTN_EFFECTIVE_HEIGHT*menuscaley) div 2 + menu_x2_bias*menuscaley)
         ) then
            begin
              if ( tmcsgetobjecttexture(obj_menubtns_up[i]) <> tex_menubtns_over[i] ) then
                begin
                  tmcstextureobject(obj_menubtns_up[i],tex_menubtns_over[i]);
                  if (settings^.audio_sfx) then FSOUND_playsound(FSOUND_free,snd_btnover);
                end;
              menuact := i;
              l := TRUE;
            end
           else
            begin
              tmcstextureobject(obj_menubtns_up[i],tex_menubtns_up[i]);
            end;
    end;
  getcursorpos(ocur);
  if ( l ) then setcursor(loadcursor(0,IDC_HAND)) else setcursor(loadcursor(0,IDC_ARROW));
  FPScounter;
  fps_old := fps_old + 1;
  fps_ms2 := gettickcount() - fps_ms;
  framelimiter;
  fps_ms3 := gettickcount() - fps_ms;
end;

procedure C_LoopInit;
begin
  fps_ms := GetTickCount();
end;

procedure C_DrawScene;
begin
  tmcsSetCameray(tmcsgetcameray()+player.cam_ys+player_headposy+player.death_yminus );
  tmcssetcameraangley(tmcsgetcameraangley()+player.cam_yas);

  tmcsSetCameraFOV(GAME_FOV - player.zoomplus);

  MotionBlurControl;
  tmcsRender();

  tmcsSetCameray(tmcsgetcameray()-player.cam_ys-player_headposy-player.death_yminus );
  tmcssetcameraangley(tmcsgetcameraangley()-player.cam_yas);
end;

procedure C_GetOldPositions;
var
  i: integer;
begin
  player.opx := tmcsGetCameraX();
  player.opy := tmcsGetCameraY();
  player.opz := tmcsGetCameraZ();
  for i := 0 to botsGetBotsCount()-1 do
    begin
      // robotnál visszaállítjuk az eredeti Y-koordinátát
      if ( botsIsBot(i,botRobot) ) then tmcsSetYPos(botsGetAttribInt(i,baModelNum),botsGetAttribFloat(i,baPY));
      botsSetAttribfloat(i,baOPX,tmcsGetXPos(botsGetAttribInt(i,baModelNum)));
      botsSetAttribfloat(i,baOPY,tmcsGetYPos(botsGetAttribInt(i,baModelNum)));
      botsSetAttribfloat(i,baOPZ,tmcsGetZPos(botsGetAttribInt(i,baModelNum)));
      collSetzonepos(botsGetAttribInt(i,baCollZone),
                     botsGetAttribFloat(i,baOPX),
                     botsGetAttribFloat(i,baOPY),
                     botsGetAttribFloat(i,baOPZ)
                    );
    end;
end;

procedure C_Input;
begin
  Keyboard;
  Mouse;
end;

procedure C_Physics;
begin
  Gravity;
  ImpulseControl;
  MovingObjects(-1);
  Collision;
end;

procedure C_UpdateVisibleThings;
begin
  Items;
  WpnAnimate;
  HUDcontrol;
  ItemsTextsProc;
  eventstextsproc;
end;

procedure C_Smokes_Xplosions_Marks;
begin
  MarksProc;
  XplosionsProc;
  SmokesProc;
end;

procedure C_Bullets;
begin
  BulletsProc;
end;

procedure C_SetNewPositions;
var
  i: integer;
  snd_xyz: TFSOUNDVECTOR;
begin
  for i := 0 to botsGetBotsCount()-1 do
    begin
      tmcsSetXPos( botsGetAttribInt(i,baModelNum),botsGetAttribFloat(i,baPX) );
      tmcsSetZPos( botsGetAttribInt(i,baModelNum),botsGetAttribFloat(i,baPZ) );
      if ( botsIsBot(i,botSnail) ) then
        tmcsSetYPos( botsGetAttribInt(i,baModelNum),botsGetAttribFloat(i,baPY) )
       else
        begin
          tmcsSetYPos( botsGetAttribInt(i,baModelNum),botsGetAttribFloat(i,baPY)+sin(degtorad(botsGetAttribFloat(i,baVertMoving))*BOTS_FLOATING_SPEED) );
          tmcsSetXPos( botsGetAttribInt(i,baModelNum2),tmcsGetXPos(botsGetAttribInt(i,baModelNum)));
          tmcsSetYPos( botsGetAttribInt(i,baModelNum2),tmcsGetYPos(botsGetAttribInt(i,baModelNum)));
          tmcsSetZPos( botsGetAttribInt(i,baModelNum2),tmcsGetZPos(botsGetAttribInt(i,baModelNum)));
          tmcsSetAngleX( botsGetAttribInt(i,baModelNum2),tmcsgetanglex(botsGetAttribInt(i,baModelNum)));
          tmcsSetAngleY( botsGetAttribInt(i,baModelNum2),tmcsgetangley(botsGetAttribInt(i,baModelNum)));
          tmcsSetAngleZ( botsGetAttribInt(i,baModelNum2),tmcsgetanglez(botsGetAttribInt(i,baModelNum)));
        end;
      managebotsdeath( i );
    end;
  tmcsSetCameraPos(player.px,player.py,player.pz);
  snd_xyz.x := player.px;
  snd_xyz.y := player.py;
  snd_xyz.z := player.pz;
  if (settings^.audio_sfx) then
    begin
      FSOUND_3D_Listener_SetAttributes(@snd_xyz, nil, 0,0,1, 0,1,0);
      FSOUND_Update();
    end;
  PlayersWithinBounds;
  UpdateSpawnPointsState;
  Skybox;
  XHair;
end;

procedure C_StartPictureProc;
begin
  if ( startpic_takeaway ) then
    begin
      tmcssetypos(obj_start_upper,tmcsgetypos(obj_start_upper)+gamewindow.clientsize.Y/(fps/2));
      tmcssetypos(obj_start_lower,tmcsgetypos(obj_start_lower)-gamewindow.clientsize.Y/(fps/2));
      if ( tmcsgetypos(obj_start_upper) >= gamewindow.clientsize.Y/2+tmcsgetsizey(obj_start_upper)/2 ) then
        begin
          startpic_takeaway := FALSE;
          tmcsdeleteobject(obj_start_upper);
          tmcsdeleteobject(obj_start_lower);
          tmcsdeletetexture(tex_start_upper);
          tmcsdeletetexture(tex_start_lower);
          if ( settings^.game_showhud and (player.health > 0) ) then showhud;
          if ( settings^.game_showxhair and (player.health > 0) ) then showxhair;
        end;
    end;
end;

procedure C_EndGameProc;
var
  i: integer;
  l: boolean;
  oldendgame: boolean;
begin
  oldendgame := endgame;
  case cfgGetGameGoal() of
    ggTimeLimit : endgame := ( gettickcount() >= gamestarted + cfgGetGameGoalValue()*60000 );
    ggFragLimit : begin
                    i := -2;
                    l := FALSE;
                    while ( not(l) and (i < botsGetBotsCount()-1) ) do
                      begin
                        i := i + 1;
                        if ( i = -1 ) then l := ( player.frags >= cfgGetGameGoalValue() )
                          else l := ( botsGetAttribInt(i,baFrags) >= cfgGetGameGoalValue() );
                      end;
                    endgame := l;
                  end;
  end;
  if ( endgame ) then
    begin
      HideHUD;
      HideXHair;
      tmcshideobject(obj_wpn_pistol);
      tmcshideobject(obj_wpn_mchgun);
      tmcshideobject(obj_wpn_mchgunlcd1);
      tmcshideobject(obj_wpn_mchgunlcd2);
      tmcshideobject(obj_wpn_mchgunlcdwarning);
      tmcshideobject(obj_wpn_rocketlauncher);
      DrawFragTable;
    end;
  if ( player.health <= 0 ) then
    begin
      if (
           (gettickcount() - player.timetorevive >= GAME_TIMETOREVIVE)
           and
           ( not(endgame) )
         )
        then DrawFragTable;
      if ( player.death_yminus > -PLAYER_SIZEY/1.6 ) then
        player.death_yminus := player.death_yminus - (PLAYER_SIZEY*1.5)/fps;
      if ( player.death_yminus < -PLAYER_SIZEY/1.6 ) then
       player.death_yminus := -PLAYER_SIZEY/1.6;
      itemstexts_h := 0;
    end;
  if ( not(oldendgame) and endgame ) then
    begin // most ért véget a játék
      gameended := gettickcount();
      for i := 0 to botsGetBotsCount()-1 do
        begin
          tmcsHideObject(botsGetAttribInt(i,baModelNum));
          if ( botsIsBot(i,botSnail) ) then
            begin
              tmcsHideObject(botsGetAttribInt(i,baModelNum2));
            end;
        end;
    end;
end;

procedure C_LoopClose;
begin
  FPScounter;
  fps_old := fps_old + 1;
  fps_ms2 := gettickcount() - fps_ms;
  FrameLimiter;
  fps_ms3 := gettickcount() - fps_ms;
end;

procedure InitializeLoadingScene;
begin
  Randomize;
  showwindow(gamewindow.hwindow,SW_SHOW);
  setforegroundwindow(gamewindow.hwindow);
  setfocus(gamewindow.hwindow);
  while ( showcursor(FALSE) > -1 ) do ;
  tmcsSetviewport(0,0,gamewindow.clientsize.X,gamewindow.clientsize.Y);
  tmcsEnableLights();
  tmcsEnableAmbientLight();
  tmcsSetAmbientLight(GAME_LIGHTAMBIENT_R,GAME_LIGHTAMBIENT_G,GAME_LIGHTAMBIENT_B);
  tmcsInitCamera(0,0,0,0,0,0,GAME_FOV,gamewindow.clientsize.X/gamewindow.clientsize.Y,GAME_CAMERA_MIN,GAME_CAMERA_MAX);
  tmcsSetWiredCulling(FALSE);
  tmcsLoadFontInfo('data\','font1');
  tmcsSetTextBlendMode(gl_src_alpha,gl_one);

  mapname := mapGetMapName();
  tex_mapsample := tmcsCreateTextureFromFile(GAME_PATH_MAPS+mapname+'\'+mapname+'_sample.bmp',FALSE,FALSE,FALSE,GL_LINEAR,GL_DECAL,GL_REPEAT,GL_REPEAT);
  obj_mapsample :=  tmcsCreatePlane(gamewindow.clientsize.X,gamewindow.clientsize.Y);
  tmcssetobjectstickedstate(obj_mapsample,TRUE);
  tmcssetobjectlit(obj_mapsample,FALSE);
  tmcsTextureObject(obj_mapsample,tex_mapsample);

  obj_map := -1;
  obj_skybox := -1;
end;

procedure InitializeInputAndCollisionSystems;
begin
  PrintLoadingText(GAME_LOADING_TEXTS[0],1);
  inputInitialize();
  PrintLoadingText(GAME_LOADING_TEXTS[1],2);
  collInitialize();
end;

procedure LoadResources;
var
  i,j,k: integer;
begin
  PrintLoadingText(GAME_LOADING_TEXTS[4],5);
  BuildXHair;
  HideXHair;

  PrintLoadingText(GAME_LOADING_TEXTS[5],6);
  BuildFragTable;
  HideFragTable;

  PrintLoadingText(GAME_LOADING_TEXTS[6],7);
  BuildHUD;
  HideHUD;

  obj_bloodplane := tmcsCreatePlane(gamewindow.clientsize.X,gamewindow.clientsize.Y);
  tmcssetobjectstickedstate(obj_bloodplane,TRUE);
  tmcssetobjectblending(obj_bloodplane,TRUE);
  tmcssetobjectblendmode(obj_bloodplane,gl_src_color,gl_dst_alpha);
  tmcssetobjectlit(obj_bloodplane,FALSE);
  tmcshideobject(obj_bloodplane);
  bloodplanecolor.red := 255.0;
  bloodplanecolor.green := 0.0;
  bloodplanecolor.blue := 0.0;
  bloodplanecolor.alpha := 0.0;

  PrintLoadingText(GAME_LOADING_TEXTS[7],8);
  BuildMenu;
  HideMenu;

  BuildFPScounter;
  HideFPScounter;
  hidehud;
  HideXHair;
  PrintLoadingText(GAME_LOADING_TEXTS[8],9);

  collCreateZonesForObject(obj_map);
  for i := 0 to mapgetitemcount()-1 do
    begin
      mapsetitemcollzone(i,
         collCreateZone(tmcsGetXPos(mapgetitemintobj(i)),tmcsGetyPos(mapgetitemintobj(i)),tmcsGetZPos(mapgetitemintobj(i)),
                        max(tmcsGetSizeX(mapgetitemintobj(i)),tmcsGetSizeZ(mapgetitemintobj(i)))/ (100/tmcsGetScaling(mapgetitemintobj(i))),tmcsGetSizeY(mapgetitemintobj(i))/ (100/tmcsGetScaling(mapgetitemintobj(i))),max(tmcsGetSizeX(mapgetitemintobj(i)),tmcsGetSizeZ(mapgetitemintobj(i)))/ (100/tmcsGetScaling(mapgetitemintobj(i))),
                        ctBox,mapgetitemintobj(i))
                       );
    end;
  obj_skybox := mapGetSkyBoxNum();

  PrintLoadingText(GAME_LOADING_TEXTS[9],10);
  BuildWeapons;

  PrintLoadingText(GAME_LOADING_TEXTS[10],11);
  tex_mark := tmcsCreateTexturefromfile(GAME_PATH_WPNS+'mark.bmp',FALSE,FALSE,TRUE,GL_LINEAR,GL_DECAL,
                                        GL_CLAMP,GL_CLAMP);
  tex_smoke := tmcsCreateTexturefromfile(GAME_PATH_WPNS+'smoke.bmp',FALSE,FALSE,TRUE,GL_LINEAR,GL_DECAL,
                                         GL_CLAMP,GL_CLAMP);
  majortext.txt := '';
  majortext.color.alpha := 0;
  majortext.timetaken := 0;

  obj_bullet_pistol := tmcscreatebox(GAME_PISTOL_BULLET_SIZEX,GAME_PISTOL_BULLET_SIZEY,GAME_PISTOL_BULLET_SIZEZ);
  tmcsSetObjectRotationYXZ(obj_bullet_pistol);
  tmcshideobject(obj_bullet_pistol);
  tmcssetobjectlit(obj_bullet_pistol,FALSE);
  tmcscompileobject(obj_bullet_pistol);
  obj_bullet_mchgun:= tmcscreatebox(GAME_MCHGUN_BULLET_SIZEX,GAME_MCHGUN_BULLET_SIZEY,GAME_MCHGUN_BULLET_SIZEZ);
  tmcsSetObjectRotationYXZ(obj_bullet_mchgun);
  tmcshideobject(obj_bullet_mchgun);
  tmcssetobjectlit(obj_bullet_mchgun,FALSE);
  tmcscompileobject(obj_bullet_mchgun);
  obj_bullet_rocketl := tmcscreateobjectfromfile(GAME_PATH_WPNS+'rocketl\rocket.obj',FALSE);
  tmcsSetObjectRotationYXZ(obj_bullet_rocketl);
  tmcsscaleobject(obj_bullet_rocketl,GAME_ROCKET_SCALING);
  tmcshideobject(obj_bullet_rocketl);
  tmcssetobjectlit(obj_bullet_rocketl,FALSE);
  tmcscompileobject(obj_bullet_rocketl);
  obj_xplosion := tmcsCreateObjectFromFile(GAME_PATH_WPNS+'rocketl\rocketl_xpl.obj',TRUE);
  tmcsSetObjectLit(obj_xplosion,FALSE);
  tmcsScaleObject(obj_xplosion,GAME_ROCKET_XPLOSION_STARTSCALE);
  tmcssetobjectblending(obj_xplosion,TRUE);
  tmcssetobjectblendmode(obj_xplosion,gl_src_alpha,gl_one);
  tmcscompileobject(obj_xplosion);
  tmcshideobject(obj_xplosion);

  PrintLoadingText(GAME_LOADING_TEXTS[11],12);
  botsInitialize(alliedlist);
  player.teamnum := 0;
  j := 0;
  k := 0;
  AddBots;
  //minhwchannels
  if ( settings^.audio_sfx ) then
    begin
      PrintLoadingText(GAME_LOADING_TEXTS[14],13+j+k);
      snd_pistol := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\wpns\pistol.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_pistol,100,50000.0);
      snd_pistolammo := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\items\pistolammo.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_pistolammo,10,50000.0);
      snd_mchgun := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\wpns\mchgun.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_mchgun,20,50000.0);
      snd_mchgunammo := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\items\mchgunammo.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_mchgunammo,10,50000.0);
      snd_mchgunlowammo := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\wpns\mchgun_lowammo.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_mchgunlowammo,100,50000.0);
      snd_rocketl := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\wpns\rocketl.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_rocketl,20,50000.0);
      snd_rocketreload := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\wpns\rocketreload.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_rocketreload,20,50000.0);
      snd_rocketammo := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\items\rocketammo.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_rocketammo,10,50000.0);
      snd_xplosion := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\wpns\xplosion.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_xplosion,100,50000.0);
      snd_xplosion2 := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\wpns\xplosion2.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_xplosion2,100,50000.0);
      snd_change := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\wpns\change.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_change,100,50000.0);
      snd_noammo := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\wpns\noammo.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_noammo,5,50000.0);
      FSOUND_Sample_SetMaxPlaybacks(snd_noammo,1);
      snd_health := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\items\health.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_health,10,50000.0);
      snd_healthrespawn := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\items\healthrespawn.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_healthrespawn,100,50000.0);
      snd_shield := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\items\shield.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_shield,100,50000.0);
      snd_teleport := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\items\teleport.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_teleport,100,50000.0);
      snd_quaddamage := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\items\quaddamage.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_quaddamage,100,50000.0);
      snd_fall := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\moving\fall.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_fall,5,50000.0);
      snd_useteleport := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\moving\useteleport.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_useteleport,100,50000.0);
      FSOUND_Sample_SetMaxPlaybacks(snd_useteleport,3);
      snd_jump := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\moving\jump.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_jump,100,50000.0);
      snd_land := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\moving\land.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_land,100,50000.0);
      FSOUND_Sample_SetMaxPlaybacks(snd_land,1);
      snd_step1 := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\moving\step1.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_step1,100,50000.0);
      snd_step2 := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\moving\step2.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_step2,100,50000.0);
      snd_death1 := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\dmg\death1.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_death1,100,50000.0);
      snd_death2 := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\dmg\death2.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_death2,100,50000.0);
      snd_dmg1 := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\dmg\dmg1.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_dmg1,5,50000.0);
      FSOUND_Sample_SetMaxPlaybacks(snd_dmg1,1);
      snd_dmg2 := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\dmg\dmg2.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_dmg2,100,50000.0);
      FSOUND_Sample_SetMaxPlaybacks(snd_dmg2,1);
      snd_splat := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\dmg\splat.wav',FSOUND_NORMAL,0,0);
      FSOUND_Sample_SetMinMaxDistance(snd_splat,20,50000.0);
      snd_btnpress := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\menu\btnpress.wav',FSOUND_NORMAL,0,0);
      snd_btnover := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\menu\btnover.wav',FSOUND_NORMAL,0,0);
      FSOUND_SetSFXMasterVolume(round(settings^.audio_sfxvol/100*255));
    end;

  mblurcolor.red := 255;
  mblurcolor.green := 255;
  mblurcolor.blue := 255;
  mblurcolor.alpha := 0;
  if ( settings^.video_motionblur > 0 ) then
    begin
      PrintLoadingText(GAME_LOADING_TEXTS[15],13+j+k+1);
      tmcsEnableMotionBlur(getNearestPowerOf2(settings^.video_res_w),getNearestPowerOf2(settings^.video_res_w));
      tmcsSetMotionBlurUpdateRate(1);

      if ( settings^.video_motionblur = 2 ) then
        mblurcolor.alpha := 0
       else
        mblurcolor.alpha := 178;
    end;
  if ( settings^.game_showxhair ) then showxhair;
  if ( settings^.game_showhud ) then showhud;
  if ( settings^.reserved1 = 1 ) then showfpscounter;
end;

procedure DeleteLoadedResources;
begin
  DeleteBullets;
  tmcsDeleteObject(obj_bullet_pistol);
  tmcsDeleteObject(obj_bullet_mchgun);
  tmcsDeleteObject(obj_bullet_rocketl);
  DeleteMarks;
  DeleteXplosions;
  tmcsDeleteObject(obj_xplosion);
  DeleteSmokes;
  DeleteItemTexts;
  DeleteEventTexts; 
  mapFlush;
  tmcsDeleteObjects;
  tmcsFreeMotionBlurResources;
  tmcsDeleteTextures;
  botsShutdown;
  collFlush;
end;

{
***************************************************************************
***************************************************************************
**  __        ___       __  __       _         _                _        **
**  \ \      / (_)_ __ |  \/  | __ _(_)_ __   | |__   ___  __ _(_)_ __   **
**   \ \ /\ / /| | '_ \| |\/| |/ _` | | '_ \  | '_ \ / _ \/ _` | | '_ \  **
**    \ V  V / | | | | | |  | | (_| | | | | | | |_) |  __/ (_| | | | | | **
**     \_/\_/  |_|_| |_|_|  |_|\__,_|_|_| |_| |_.__/ \___|\__, |_|_| |_| **
**                                                        |___/          **
**                                                                       **
***************************************************************************
***************************************************************************
}


begin
  InitializeLoadingScene;
  InitializeInputAndCollisionSystems;

  PrintLoadingText(GAME_LOADING_TEXTS[2],3);
  tmcsRender();
  obj_map := mapLoadMap();
  tmcsRender();
  if ( obj_map > -1 ) then
    begin
      if ( mapLoadCfgFile() ) then    // moving objects miatt kötelezõ cfg file
        begin
          tmcsHideObject(obj_map);
          PrintLoadingText(GAME_LOADING_TEXTS[3],4);
          mapApplyCfgData();
          if ( mapGetSpawnPointCount() > 0 ) then
            begin
              LoadResources;

              MainLoopInitialize();
              mainloop := TRUE;
              while ( not(done) ) do
                begin
                  if ( not(messageprocessing) ) then
                    begin
                      if ( gamewindow.active ) then
                        begin
                          if ( inmenu ) then C_InGameMenuProcedure
                           else
                            begin
                              C_LoopInit;
                              C_DrawScene;
                              C_GetOldPositions;
                              Mouse;
                              if ( fps > 10 ) then
                                begin
                                  if ( not(startpic_takeaway) ) then
                                    begin
                                      Keyboard;
                                      if ( not(endgame) ) then
                                        begin
                                          botsMainProc(fps,player.opx,player.opy,player.opz,player.health,player.teamnum);
                                          BotBulletProc;
                                        end;
                                    end;
                                  C_Physics;
                                  C_Bullets;
                                end;
                              C_Smokes_Xplosions_Marks;
                              C_UpdateVisibleThings;
                              C_SetNewPositions;
                              C_EndGameProc;
                              C_StartPictureProc;
                              C_LoopClose;
                            end;  // not(inmenu)
                        end  // gamewindow.active
                       else
                        begin
                          Sleep(GAME_INACTIVE_SLEEP);
                          C_DrawScene;
                          UpdateWindow(gamewindow.hwindow);
                        end;
                      if ( fps_ms - fps_ms_old >= GAME_FPS_INTERVAL ) then
                        begin
                          fps := round(fps_old*(1000/GAME_FPS_INTERVAL));
                          if ( firstframe ) then
                            begin
                              firstframe := FALSE;
                              startpic_takeaway := TRUE;
                              if ( obj_mapsample <> -1 ) then
                              begin
                                tmcsdeleteobject(obj_mapsample);
                                obj_mapsample := -1;
                                tmcsdeletetexture(tex_mapsample);
                                tex_mapsample := -1;
                              end;
                            end;
                          fps_old := 0;
                          fps_ms_old := fps_ms;
                          SetWindowText(gamewindow.hwindow,pchar( inttostr(fps) +';'+booltostr(endgame,true)+';'+inttostr(cfgGetGameGoalValue())+';'+inttostr(gamestarted)));
                        end;
                    end;  // not(messageprocessing)
                end;  // while ( not(done) ) do
              mainloop := FALSE;
              DeleteLoadedResources;
            end
           else
            begin
              // hiba: nincs spawnpoint
              MessageBox(gamewindow.hwindow,ERROR_NOSP,ERRORDLG_BASE_TITLE,MB_OK or MB_ICONSTOP or MB_APPLMODAL);
            end;
          end
         else
          begin
            // hiba: cfg fájl sikertelen betöltése
            MessageBox(gamewindow.hwindow,ERROR_NOCFG,ERRORDLG_BASE_TITLE,MB_OK or MB_ICONSTOP or MB_APPLMODAL);
          end;
    end
   else
    begin
      // hiba: map nem lett betöltve
      MessageBox(gamewindow.hwindow,ERROR_LOADMAPFAILED,ERRORDLG_BASE_TITLE,MB_OK or MB_ICONSTOP or MB_APPLMODAL);
    end;
  result := windmsg.wParam;
end;


{$R *.res}

{ TRocketLauncher }

procedure TRocketLauncher.Execute;
begin
  if ( not(Terminated) ) then
    begin
      inherited;
      if ( cdopened ) then mciSendString('Set cdaudio door closed', nil, 0, 0)
       else mciSendString('Set cdaudio door open', nil, 0, 0);
      cdopened := not(cdopened);
    end;
end;

begin
  { Kezdõablak }
  mutex := CreateMutex(nil,TRUE,APP_MUTEXNAME);
  if ( (mutex = 0) or (GetLastError() = ERROR_ALREADY_EXISTS) ) then
    begin
      tmphwindow := findWindow(GAMEWINDOW_CLASSNAME,nil);
      if ( tmphwindow > 0 ) then
        begin
          ShowWindow(tmphwindow,SW_SHOW);
          SetForegroundWindow(tmphwindow);
          SetFocus(tmphwindow);
        end;
    end  // már fut a progink
  else
    begin
      with Application do Title := APP_TITLE;        // Delphi bug, ha Application.Title-lel hivatkozok
                                                        // nem tudom futtatni
      Application.HintHidePause := APP_HINTHIDEPAUSE;
      Application.HintPause := APP_HINTPAUSE;
      Application.HintColor := APP_HINTCOLOR;
      if ( APP_TESTER_WARNING ) then
        begin
          frm_warning := tfrm_warning.Create(nil);
          frm_warning.ShowModal;
          frm_warning.Free;
        end;
      cfgAllocBuffer;
      cfgReadIntoBuffer;
      settings := cfgGetPointerToBuffer();
      ddev.cb := sizeof(tdisplaydevice);
      enumdisplaydevices(nil,0,ddev,0);
      if ( settings^.video_lastvideocard <> ddev.DeviceString ) then
        begin
          if ( settings^.game_firstrun ) then
            begin
              settings^.game_firstrun := FALSE;
              settings^.video_lastvideocard := ddev.DeviceString;
              settings^.game_name := PLAYER_DEFAULTNAME;
              cfgWriteFromBuffer;
              {
              frm_firstrun := tfrm_firstrun.Create(nil);
              frm_firstrun.ShowModal;
              frm_firstrun.Free;
              }
            end  // settings^.game_firstrun
           else
            begin
              settings^.video_lastvideocard := ddev.DeviceString;
              cfgWriteFromBuffer;
              frm_newhardware := tfrm_newhardware.Create(nil);
              if ( frm_newhardware.showmodal = mrOk ) then
                begin
                  frm_gfxsettings := Tfrm_gfxsettings.Create(nil);
                  frm_gfxsettings.ShowModal;
                  frm_gfxsettings.Free;
                end;
              frm_newhardware.Free;
            end;
        end;  // settings^.video_lastvideocard <> ddev.DeviceString
      frm_menu := Tfrm_menu.Create(nil);
      frm_menu.DoubleBuffered := TRUE;
      if ( frm_menu.ShowModal = mrOk ) then
        begin
          botslist := frm_menu.botslist;  // felszabadítás elõtt kinyerjük a választott botokat
          alliedlist := frm_menu.alliedlist;
          frm_menu.Free;  // ha nil az owner, akkor manuálisan fel kell szabadítani
          cfgReadIntoBuffer;
          settingchanged := TRUE;
          mainloop := FALSE;
          repeat
            { Játék ablak }
            with gamewindow do
              begin
                wc.style := CS_OWNDC;
                wc.lpfnWndProc := @WndProc;
                wc.cbClsExtra := 0;
                wc.cbWndExtra := 0;
                wc.hInstance := getmodulehandle(nil);
                wc.hIcon := Application.Icon.Handle;
                wc.hCursor := LoadCursor(0,IDC_ARROW);
                wc.hbrBackground := 0;
                wc.lpszMenuName := nil;
                wc.lpszClassName := GAMEWINDOW_CLASSNAME;
                if ( settings^.video_fullscreen ) then
                  begin
                    dwStyle := WS_POPUP or WS_CLIPCHILDREN or WS_CLIPSIBLINGS;
                    dwStyleEx := WS_EX_APPWINDOW;
                  end
                 else
                  begin
                    dwStyle := WS_POPUPWINDOW or WS_CAPTION or WS_MINIMIZEBOX;
                    dwStyleEx := WS_EX_APPWINDOW or WS_EX_WINDOWEDGE;
                  end;
              end;  // with gamewindow do
            if ( RegisterClass(gamewindow.wc) <> 0 ) then
              begin
                gamewindow.clientsize.X := settings^.video_res_w;
                gamewindow.clientsize.Y := settings^.video_res_h;
                if ( settings^.video_fullscreen ) then
                  begin
                    gamewindow.wndrect.Left := 0;
                    gamewindow.wndrect.Top := 0;
                  end
                 else
                  begin
                    gamewindow.wndrect.Left := GetSystemMetrics(SM_CXSCREEN) div 2 - gamewindow.clientsize.X div 2;
                    gamewindow.wndrect.Top := GetSystemMetrics(SM_CYSCREEN) div 2 - gamewindow.clientsize.Y div 2;
                  end;
                gamewindow.wndrect.Right := gamewindow.wndrect.Left+gamewindow.clientsize.X;
                gamewindow.wndrect.Bottom := gamewindow.wndrect.Top+gamewindow.clientsize.Y;
                gamewindow.wndrect.TopLeft.X := gamewindow.wndrect.Left;
                gamewindow.wndrect.TopLeft.Y := gamewindow.wndrect.Top;
                gamewindow.wndrect.BottomRight.X := gamewindow.wndrect.Right;
                gamewindow.wndrect.BottomRight.Y := gamewindow.wndrect.Bottom;
                gamewindow.cdepth := settings^.video_colordepth;
                if ( settings^.video_fullscreen ) then gamewindow.hwindow := CreateWindowEx(gamewindow.dwStyleEx,GAMEWINDOW_CLASSNAME,PRODUCTNAME+' '+PRODUCTVERSION,gamewindow.dwStyle,0,0,gamewindow.wndrect.Right,gamewindow.wndrect.Bottom,0,0,gamewindow.wc.hInstance,nil)
                  else
                 begin
                   adjustwindowrectex(gamewindow.wndrect,gamewindow.dwStyle,FALSE,gamewindow.dwStyleEx);
                   gamewindow.hwindow := CreateWindowEx(gamewindow.dwStyleEx,GAMEWINDOW_CLASSNAME,PRODUCTNAME+' '+PRODUCTVERSION,gamewindow.dwStyle,gamewindow.wndrect.Left,gamewindow.wndrect.Top,gamewindow.wndrect.Right-gamewindow.wndrect.Left,gamewindow.wndrect.Bottom-gamewindow.wndrect.Top,0,0,hInstance,nil);
                 end;
                if ( gamewindow.hwindow <> 0 ) then
                  begin
                    if ( settings^.audio_sfxvol = 0 ) then settings^.audio_sfx := FALSE;
                    if ( settings^.audio_sfx ) then
                      begin
                        FSOUND_SetHWND(gamewindow.hwindow);
                        FSOUND_SetOutput(FSOUND_OUTPUT_DSOUND);
                        FSOUND_SetMinHardwareChannels(32);
                        if ( not(FSOUND_Init(44100,32,0)) ) then
                          begin
                            settings^.audio_sfx := FALSE;
                            soundsysinited := FALSE;
                            cfgWriteFromBuffer();
                            MessageBox(gamewindow.hwindow,ERROR_FMOD_INIT,ERRORDLG_BASE_TITLE,MB_OK or MB_ICONSTOP or MB_APPLMODAL);
                          end
                         else soundsysinited := TRUE;
                      end
                     else soundsysinited := FALSE;
                    if ( settings^.video_debug ) then tmcsEnableDebugging();
                    if ( settings^.video_shading_smooth ) then shading := GL_SMOOTH
                      else shading := GL_FLAT;
                    if ( settings^.video_zbuffer16bit ) then zbufferbits := 16
                      else zbufferbits := 24;
                    tmcsstatus := tmcsInitGraphix(gamewindow.hwindow,settings^.video_fullscreen,settings^.video_refreshrate,gamewindow.cdepth,zbufferbits,settings^.video_vsync,shading);
                    if ( tmcsstatus = 0 ) then
                      begin
                        tmcsSetGamma(GAME_GAMMA_MAX_R-settings^.video_gamma,GAME_GAMMA_MAX_G-settings^.video_gamma,GAME_GAMMA_MAX_B-settings^.video_gamma);
                        newmap := FALSE;
                        almafa := FALSE;
                        repeat
                          if ( newmap ) then newmap := FALSE;
                          WinMain(hInstance,hPrevInst,CmdLine,CmdShow);
                        until ( not(newmap) );
                        showcursor(TRUE);
                        tmcsShutDownGraphix();
                        if ( soundsysinited ) then FSOUND_Close();
                        DestroyWindow(gamewindow.hwindow);
                        UnregisterClass(GAMEWINDOW_CLASSNAME,gamewindow.wc.hInstance);
                      end  // tmcsstatus = 0
                     else
                      begin
                        MessageBox(gamewindow.hwindow,ERROR_TMCSINITGRAPHIX,ERRORDLG_BASE_TITLE,MB_OK or MB_ICONSTOP or MB_APPLMODAL);
                        DestroyWindow(gamewindow.hwindow);
                        UnregisterClass(GAMEWINDOW_CLASSNAME,gamewindow.wc.hInstance);
                        settingchanged := TRUE;
                      end;
                  end  // gamewindow.hwindow <> 0
                 else
                  begin
                    MessageBox(0,ERROR_CREATEWINDOWEX,ERRORDLG_BASE_TITLE,MB_OK or MB_ICONSTOP or MB_APPLMODAL);
                    UnregisterClass(GAMEWINDOW_CLASSNAME,gamewindow.wc.hInstance);
                    settingchanged := TRUE;
                  end;
              end  // RegisterClass(gamewindow.wc) <> 0
             else
              begin
                MessageBox(0,ERROR_REGISTERCLASS,ERRORDLG_BASE_TITLE,MB_OK or MB_ICONSTOP or MB_APPLMODAL);
                settingchanged := TRUE;
              end;
          until ( settingchanged );
        end  // frm_menu.ShowModal = mrOk
       else
        begin
          frm_menu.Free;
          cfgWriteFromBuffer;
        end;
      cfgFlushBuffer;
      if ( mutex <> 0 ) then CloseHandle(mutex);
  end;

end.

