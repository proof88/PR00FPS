unit u_bots;

interface

uses
  windows,
  Classes,
  dialogs,
  sysutils,
  forms,
  gfxcore,
  u_cfgfile,
  u_collision,
  u_frm_playermatdebug,
  u_consts,
  graphics,
  extctrls,
  u_map,
  u_minimath,
  fmod,fmodtypes;

const
  SZINEK: array[0..2] of TColor = (clGreen,clRed,clYellow);
  MAXELEMENTS = 70;

type
  TBotsKind   = (botSnail,botRobot);
  TBotsAttrib = (baPX,baPY,baPZ,baOPX,baOPY,baOPZ,baAngleX,baAngleY,baAngleZ,
                 baTeamNum,baModelNum,baGravity,baInjuryCbyF,baHasTeleport,
                 baHasQuadDamage,baHealth,baShield,baImpulsePX,baImpulsePY,
                 baImpulsePZ,baOImpulsePX,baOImpulsePY,baOImpulsePZ,baKind,
                 baSX,baSY,baSZ,baCollZone,baFrags,baDeaths,baName,baYRotSpeed,
                 baAttacking,baVertMoving,baTimeToRevive,baLastQDmg,baTarget,
                 baModelNum2);

procedure botsInitialize(botsallied: string);
procedure botsDefaultSettings(index: integer; zerofrags: boolean);
procedure botsAdd(kind: TBotsKind; name: string; teamnum: integer);
procedure botsDelete(index: integer);
procedure botsShutdown;
function  botsGetBotsCount(): integer;
procedure botsMainProc(fps: integer; playerx, playery, playerz: single; playerhealth: integer; playertn: integer);
function  botsIsBot(index: integer; kind: TBotsKind): boolean;
function  botsGetAttribFloat(index: integer; attrib: TBotsAttrib): single;
function  botsGetAttribInt(index: integer; attrib: TBotsAttrib): integer;
function  botsGetAttribBool(index: integer; attrib: TBotsAttrib): boolean;
function  botsGetAttribString(index: integer; attrib: TBotsAttrib): string;
procedure botsSetAttribInt(index: integer; attrib: TBotsAttrib; value: integer);
procedure botsSetAttribFloat(index: integer; attrib: TBotsAttrib; value: single);
procedure botsSetAttribBool(index: integer; attrib: TBotsAttrib; value: boolean);
procedure botsSetAttribString(index: integer; attrib: TBotsAttrib; value: string);
function  botsBotFromCollZone(zoneindex: integer): integer;

implementation

  
type
  PBot = ^TBot;
  TBot = record
           opx,opy,opz,px,py,pz: single;
           prevpx,prevpz: single;
           timetochdir: integer;
           anglex,angley,anglez: single;
           oldangley: single;
           sx,sy,sz: single;
           teamnum: integer;
           attacking: boolean;
           lastattack: cardinal;
           target: integer;
           timetorevive: integer;
           modelnum: integer;
           modelnum2: integer;
           collzone: integer;
           vertmoving: single;
           lightmappedmodelnum: integer;
           gravity: single;
           injurycausedbyfalling: single;
           hasteleport: boolean;
           hasquaddamage: boolean;
           lastqdmg: cardinal;
           health,shield: integer;
           frags,deaths: integer;
           impulsepx,impulsepy,impulsepz: single;
           oimpulsepx,oimpulsepy,oimpulsepz: single;
           name: string;
           yrotspeed: single;
           kind: TBotsKind;
           frm_matdebug: Tfrm_playermatdebug;
         end;
  PMatrix = ^TMatrix;
  TMatrix = array[1..MAXELEMENTS,1..MAXELEMENTS] of integer;
  TMatrices = record
                matrixlist: tlist;
                basepx,basepz: single;
                starty: integer;
                bs: integer;
                botsize: single;
              end;
  TXZ = record
          x,z: integer;
        end;

var
  bots: tlist;
  bot: PBot;
  settings: pcfgdata;                      // beállításokra mutató mutató
  matrices: TMatrices;
  matform: tform;
  shpmat: array[1..MAXELEMENTS,1..MAXELEMENTS] of tshape;
  ba: string;
  snailmodel,robotmodel,robotmodel2: integer;
  snaillmmodel,robotlmmodel: integer;
  matricesready: boolean;
  snd_snails,snd_robots: PFSOUNDSAMPLE;
  sndchn: integer;
  sndpos: TFSOUNDVECTOR;


procedure botsMainProc(fps: integer; playerx, playery, playerz: single; playerhealth: integer; playertn: integer);
var
  i,ind,j: integer;
  x,z: integer;
  botx,boty,botz: integer;
  playermx,playermy,playermz: integer;
  moldvalue: integer;
  mustchangedirection: boolean;
  h_availdirs: integer;
  availdirs: array[1..8] of txz;
  cel: single;
  targetalfa: single;
  canshoot: boolean;
  x2,z2: integer;

// be: bot forgásszöge (merre néz), aktuális mátrix
// ki: tartható-e a böt forgásszöge, vagy sem
function directionOk(angley: single; matrix: pmatrix): boolean;
begin
  case round( angley ) of
     23.. 68 : result := ( matrix[ botz-1 , botx+1 ] = 0 );
     69..114 : result := ( matrix[ botz-1 , botx   ] = 0 );
    115..159 : result := ( matrix[ botz-1 , botx-1 ] = 0 );
    160..204 : result := ( matrix[ botz   , botx-1 ] = 0 );
    205..249 : result := ( matrix[ botz+1 , botx-1 ] = 0 );
    250..294 : result := ( matrix[ botz+1 , botx   ] = 0 );
    295..339 : result := ( matrix[ botz+1 , botx+1 ] = 0 );
    340..360,
      0.. 22 : result := ( matrix[ botz   , botx+1] = 0 );
       else result := FALSE;
  end;
end;

// be: bot mátrixbeli cellájához viszonyítva megadott cella (x és z lehet -1,0,1)
// ki: fokban merre kell fordulnia a botnak, h adott cellához eljusson
function directionToDeg(x,z: integer): single;
begin
  // x = +1 jobbra
  // x = -1 balra
  // z = +1 fel
  // z = -1 le
  case x of
    -1: begin
          case z of
            -1: result := 225;
             0: result := 180;
             1: result := 135;
          end;
        end;
     0: begin
          case z of
            -1: result := 270;
             0: ; // ide soha nem jutunk el XD
             1: result := 90;
           end;
        end;
     1: begin
          case z of
            -1: result := 315;
             0: result := 0;
             1: result := 45;
          end;
        end;
  end;
end;

// adott indexû botnak keres egy célpontot
// be: a bot indexe, aminek célpontot keresünk
// ki: a talált célpont indexe, mely
//       -2, ha nincs
//       -1, ha a player az
//       0..bots.count-1, kivéve bejövõ indexet, ha valamelyik bot az
function getnewtarget(index: integer; playerx, playery, playerz: single; playerhealth: integer; playertn: integer): integer;
var
  i: integer;
  nearestplayerind: integer;
  nearestplayerdist: single;
  dist: single;
begin
  nearestplayerind := -2;
  nearestplayerdist := BOTS_DIST_STARTATTACK;
  for i := -1 to bots.Count-1 do
    begin
      if ( i = -1 ) then
        begin
          if ( (playerhealth > 0) and (playertn <> pbot(bots[ index ])^.teamnum) ) then
            begin
              dist := sqrt( sqr(playerx - pbot(bots[ index ])^.opx) + sqr(playerz - pbot(bots[ index ])^.opz) );
              if ( dist < nearestplayerdist ) then
                begin // támadási távolságon van a player
                  if ( abs(playery-pbot(bots[ index ])^.opy) < BOTS_DIST_ATTACKMAXYDIST ) then
                    begin
                      nearestplayerdist := dist;
                      nearestplayerind := i;
                    end;
                end;
            end;
        end
       else
        begin
          if ( (pbot(bots[ i ])^.health > 0) and (i <> index) and (pbot(bots[ i ])^.teamnum <> pbot(bots[ index ])^.teamnum) ) then
            begin
              dist := sqrt( sqr(pbot(bots[ i ])^.opx - pbot(bots[ index ])^.opx) + sqr(pbot(bots[ i ])^.opz - pbot(bots[ index ])^.opz) );
              if ( dist < nearestplayerdist ) then
                begin
                  if ( abs(pbot(bots[ i ])^.opy-pbot(bots[ index ])^.opy) < BOTS_DIST_ATTACKMAXYDIST ) then
                    begin
                      nearestplayerdist := dist;
                      nearestplayerind := i;
                    end;
                end;
            end;
        end;
    end;
  if ( (nearestplayerind > -2) and settings^.audio_sfx) then
    begin
      sndpos.x := pbot(bots[ index ])^.px;
      sndpos.y := pbot(bots[ index ])^.py;
      sndpos.z := pbot(bots[ index ])^.pz;
      if ( pbot(bots[ index ])^.kind = botSnail ) then sndchn := fsound_playsoundex(fsound_free,snd_snails,nil,TRUE)
        else sndchn := fsound_playsoundex(fsound_free,snd_robots,nil,TRUE);
      fsound_3d_setattributes(sndchn,@sndpos,nil);
      fsound_setpaused(sndchn,FALSE);
    end;
  result := nearestplayerind;
end;

// megmondja adott indexû botról, hogy ütközik-e valakivel
function hittingplayer(index: integer; px,py,pz: single): boolean;
var
  i: integer;
  l: boolean;
begin
  if ( ( (pbot(bots[ index ])^.opx+pbot(bots[ index ])^.sx >= px-PLAYER_SIZEX/2) and (pbot(bots[ index ])^.opx-pbot(bots[ index ])^.sx <= px+PLAYER_SIZEX/2) )
                                                     and
       ( (pbot(bots[ index ])^.opy+pbot(bots[ index ])^.sy >= py-PLAYER_SIZEY/2) and (pbot(bots[ index ])^.opy-pbot(bots[ index ])^.sy <= py+PLAYER_SIZEY/2) )
                                                     and
       ( (pbot(bots[ index ])^.opz+pbot(bots[ index ])^.sz >= pz-PLAYER_SIZEZ/2) and (pbot(bots[ index ])^.opz-pbot(bots[ index ])^.sz <= pz+PLAYER_SIZEZ/2) )
   ) then result := TRUE
       else
         begin
           l := FALSE;
           i := -1;
           while ( not(l) and (i < bots.Count-1) ) do
             begin
               i := i+1;
               if ( assigned(bots[i]) and (i <> index) ) then
                 begin
                   l := (
                           ( (pbot(bots[ index ])^.opx+pbot(bots[ index ])^.sx >= pbot(bots[ i ])^.opx-pbot(bots[ i ])^.sx/2) and (pbot(bots[ index ])^.opx-pbot(bots[ index ])^.sx <= pbot(bots[ i ])^.opx+pbot(bots[ i ])^.sx/2) )
                                                                         and
                           ( (pbot(bots[ index ])^.opy+pbot(bots[ index ])^.sy >= pbot(bots[ i ])^.opy-pbot(bots[ i ])^.sy/2) and (pbot(bots[ index ])^.opy-pbot(bots[ index ])^.sy <= pbot(bots[ i ])^.opy+pbot(bots[ i ])^.sy/2) )
                                                                         and
                           ( (pbot(bots[ index ])^.opz+pbot(bots[ index ])^.sz >= pbot(bots[ i ])^.opz-pbot(bots[ i ])^.sz/2) and (pbot(bots[ index ])^.opz-pbot(bots[ index ])^.sz <= pbot(bots[ i ])^.opz+pbot(bots[ i ])^.sz/2) )
                        );
                 end;
             end;
           result := l;
         end;
end;

begin
  for i := 0 to bots.Count-1 do
    begin
      if ( assigned(bots[ i ]) ) then
        begin  // nincs törölve a bot
          if ( pbot(bots[ i ])^.health > 0 ) then
            begin  // csak akkor gondolkodhat, ha még él
              // meghatározzuk a helyét a mátrixon és azt, hogy hanyadik mátrixon van (magasság alapján)
              botx := round( (matrices.basepx + pbot(bots[ i ]).opx) / matrices.botsize )+matrices.bs div 2 + 1 ;
              if ( botx < 1 ) then botx := 1
                else if ( botx > matrices.bs-1 ) then botx := matrices.bs-1;
              botz := matrices.bs - (round( (matrices.basepz + pbot(bots[ i ]).opz) / matrices.botsize )+matrices.bs div 2+1) + 1;
              if ( botz < 1 ) then botz := 1
                else if ( botz > matrices.bs-1 ) then botz := matrices.bs-1;
              boty := round( pbot(bots[ i ]).opy )+2;
              if ( boty < matrices.starty ) then boty := matrices.starty
                else if ( boty > matrices.starty+matrices.matrixlist.Count-1 ) then boty := matrices.starty+matrices.matrixlist.Count-1;
              boty := boty-matrices.starty;

              playermx := round( (matrices.basepx + playerx) / matrices.botsize )+matrices.bs div 2 + 1 ;
              if ( playermx < 1 ) then playermx := 1
                else if ( playermx > matrices.bs-1 ) then playermx := matrices.bs-1;
              playermz := matrices.bs - (round( (matrices.basepz + playerz) / matrices.botsize )+matrices.bs div 2+1) + 1;
              if ( playermz < 1 ) then playermz := 1
                else if ( playermz > matrices.bs-1 ) then playermz := matrices.bs-1;
              playermy := round( playery )+2;
              if ( playermy < matrices.starty ) then playermy := matrices.starty
                else if ( playermy > matrices.starty+matrices.matrixlist.Count-1 ) then playermy := matrices.starty+matrices.matrixlist.Count-1;
              playermy := playermy-matrices.starty;
              moldvalue := pmatrix(matrices.matrixlist[boty])^[playermz,playermx];
              pmatrix(matrices.matrixlist[boty])^[playermz,playermx] := 2;

              // megnézzük, van-e a közelben ellenség, de csak akkor, ha még nincs egy kiválasztott.
              // ha nincs, akkor szokásos moving
              // ha van, akkor megállapítjuk, merre van...
              // ha arra, amerre van lehet menni, akkor abba az irányba fordulunk és lövünk
              // ha arra nem lehet menni, akkor szokásos moving

              if ( pbot(bots[ i ])^.target = -2 ) then pbot(bots[ i ])^.target := getnewtarget(i,playerx,playery,playerz,playerhealth,playertn);
              if ( pbot(bots[ i ])^.target > -2 ) then
                begin
                  // megnézzük, hogy él-e még a célpont
                  if ( ( (pbot(bots[ i ])^.target = -1) and (playerhealth > 0) ) or ( (pbot(bots[ i ])^.target > -1) and (pbot(bots[ pbot(bots[ i ])^.target ])^.health > 0) ) ) then
                    begin // él a célpont
                      if ( pbot(bots[ i ])^.target = -1 ) then targetalfa := mapGetAngleYFromAToB(pbot(bots[ i ])^.opx,pbot(bots[ i ])^.opz,playerx,playerz)
                        else targetalfa := mapGetangleyfromatob(pbot(bots[ i ])^.opx,pbot(bots[ i ])^.opz,pbot(bots[ pbot(bots[ i ])^.target ])^.opx,pbot(bots[ pbot(bots[ i ])^.target ])^.opz);
                      if ( pbot(bots[ i ])^.kind = botSnail ) then canshoot := directionOk(targetalfa, matrices.matrixlist[boty]) and ((gettickcount()-pbot(bots[ i ])^.lastattack) > BOTS_TIME_BETWEEN_SHOTS_SNAIL)
                        else canshoot := directionOk(targetalfa, matrices.matrixlist[boty]) and ((gettickcount()-pbot(bots[ i ])^.lastattack) > BOTS_TIME_BETWEEN_SHOTS_ROBOT);
                      if ( canshoot ) then
                        begin
                          if ( ( (pbot(bots[ i ])^.target = -1) and (abs(playery-pbot(bots[ i ])^.opy) < BOTS_DIST_ATTACKMAXYDIST) )
                                or
                               ( (pbot(bots[ i ])^.target > -1) and (abs(pbot(bots[ pbot(bots[ i ])^.target ])^.opy-pbot(bots[ i ])^.opy) < BOTS_DIST_ATTACKMAXYDIST) )
                             ) then
                            begin
                              pbot(bots[ i ])^.angley := targetalfa;
                              pbot(bots[ i ])^.attacking := TRUE;
                              pbot(bots[ i ])^.lastattack := gettickcount();
                            end;
                        end
                       else pbot(bots[ i ])^.attacking := FALSE;
                    end
                   else
                    begin // már nem él a célpont
                      pbot(bots[ i ])^.target := -2;
                      pbot(bots[ i ])^.attacking := FALSE;
                    end;
                end;
              {}

              // ha elõbb valóban elmozdult, akkor nem kell irányt váltani, különben valószínûleg kell
              if ( (pbot(bots[ i ]).px = pbot(bots[ i ]).prevpx) and (pbot(bots[ i ]).pz = pbot(bots[ i ]).prevpz) ) then
                pbot(bots[ i ]).timetochdir := 0
               else pbot(bots[ i ]).timetochdir := pbot(bots[ i ]).timetochdir+1;

              // biztosan irányt kell váltani, ha iránya alapján akadály van elõtte vagy nem elõször nem haladott tovább
              // elvileg jó irányba
              mustchangedirection := (
                                        ( directionOk(pbot(bots[ i ]).angley, matrices.matrixlist[boty]) = FALSE )
                                                                           or
                                        ( pbot(bots[ i ]).timetochdir > 2 )
                                                                           or
                                        ( hittingplayer(i,playerx,playery,playerz) )
                                     );

              if ( mustchangedirection ) then
                begin  // új irányt kell keresni
                  h_availdirs := 0;
                  z := botz-2;
                  while ( (z < botz+1) and (z < matrices.bs) ) do
                    begin
                      z := z+1;
                      if ( z > 0 ) then
                        begin
                          x := botx-2;
                          while ( (x < botx+1) and (x < matrices.bs) ) do
                            begin
                              x := x+1;
                              if ( x > 0 ) then
                                begin
                                  if ( (x = botx) and (z = botz) ) then
                                    begin
                                    end
                                   else
                                    begin  // availdirs tömbbe pakoljuk a jó, választható irányokat (mátrix celláját)
                                      try
                                        if ( (matrices.bs-z > 0) and (x > 0) ) then
                                          begin
                                            if ( ( pmatrix(matrices.matrixlist[boty])[ matrices.bs-z , x ] = 0 ) ) then
                                              begin
                                                h_availdirs := h_availdirs+1;
                                                availdirs[h_availdirs].x := 0-(botx-x);
                                                availdirs[h_availdirs].z := botz-z;
                                              end;
                                          end;
                                      except
                                        on exception do
                                          begin
                                          end;
                                      end;
                                    end;
                                end;
                            end;
                        end;
                    end;
                  if ( h_availdirs > 0 ) then
                    begin  // van merre mennünk, kiválasztunk egy irányt a jó irányok közül (mátrix celláját)
                      ind := random(h_availdirs)+1;
                      x := availdirs[ind].x;
                      z := availdirs[ind].z;
                    end
                   else
                    begin  // nincs merre mennünk
                      x := -800;
                      z := -800;
                    end;
                end;
                if ( (x = -800) and (z = -800) ) then
                  begin  // nincs merre mennünk, körül vagyunk véve akadállyal
                    // todo: nincs merre menni
                  end
                 else
                  begin  // van irányunk
                    // ha irányt kellett váltani, akkor a kapott x-et és z-t fokká alakítjuk
                    if ( mustchangedirection ) then pbot(bots[ i ]).angley := directiontodeg(x,z);
                    // mozog a bot
                    if ( pbot(bots[ i ]).kind = botSnail ) then
                      begin
                        pbot(bots[ i ]).pz := pbot(bots[ i ]).opz - (cos(((pbot(bots[ i ]).angley+90))*pi/180))*BOTS_MOVE_SPEED_SNAIL/fps;
                        pbot(bots[ i ]).px := pbot(bots[ i ]).opx + (sin(((pbot(bots[ i ]).angley+90))*pi/180))*BOTS_MOVE_SPEED_SNAIL/fps;
                      end
                     else
                      begin
                        pbot(bots[ i ]).pz := pbot(bots[ i ]).opz - (cos(((pbot(bots[ i ]).angley+90))*pi/180))*BOTS_MOVE_SPEED_ROBOT/fps;
                        pbot(bots[ i ]).px := pbot(bots[ i ]).opx + (sin(((pbot(bots[ i ]).angley+90))*pi/180))*BOTS_MOVE_SPEED_ROBOT/fps;
                      end;
                    if ( pbot(bots[ i ])^.kind = botRobot ) then
                      begin  // robotnál lebegés
                        if ( pbot(bots[ i ])^.vertmoving < 360.0 ) then
                          pbot(bots[ i ])^.vertmoving := pbot(bots[ i ])^.vertmoving + 10/fps;
                        if ( pbot(bots[ i ])^.vertmoving >= 360.0 ) then
                          pbot(bots[ i ])^.vertmoving := 0.0;
                      end;
                    // hozzá tartozó objektumot is elforgatjuk
                    cel := tmcswrapangle(360-(pbot(bots[ i ]).angley-90));

                    if ( tmcsgetangley(pbot(bots[ i ]).modelnum) < cel ) then
                      tmcssetangley( pbot(bots[ i ]).modelnum, tmcsgetangley(pbot(bots[ i ]).modelnum) + (tmcswrapangle(cel-tmcsgetangley(pbot(bots[ i ]).modelnum)) )/(fps/25) )
                     else if ( tmcsgetangley(pbot(bots[ i ]).modelnum) > cel ) then
                      tmcssetangley( pbot(bots[ i ]).modelnum, tmcsgetangley(pbot(bots[ i ]).modelnum) - (tmcswrapangle(abs(cel-tmcsgetangley(pbot(bots[ i ]).modelnum))) )/(fps/25) );

                    // eltároljuk, hogy merre mentünk, ezt következõ alkalommal figyelni kell, mert lehet, hogy nem várt
                    // collision zone-ba ütköztünk. Ezt figyeljük a botsProc elején (timetochdir)
                    if not( (tmcsgetangley(pbot(bots[ i ]).modelnum) <= tmcswrapangle(cel+2)) and (tmcsgetangley(pbot(bots[ i ]).modelnum) >= tmcswrapangle(cel-2)) ) then
                      begin // csak akkor lõhetünk, ha a modell is arra néz, amerre a bot logikailag néz, így hiteles
                        pbot(bots[ i ]).attacking := FALSE;
                        pbot(bots[ i ]).lastattack := 0;
                      end;
                    pbot(bots[ i ]).prevpz := pbot(bots[ i ]).pz;
                    pbot(bots[ i ]).prevpx := pbot(bots[ i ]).px;
                  end;

              if ( DEBUG_BOTSMATRIX and (i = 0) ) then
                begin
                  // frissítjük a bot formján a shape-eket
                  for z2 := -2 to 2 do
                    for x2 := -2 to 2 do
                      begin
                        if ( (z2 = (5 div 2)-2) and (x2 = z2) ) then
                          begin
                            pbot(bots[ i ]).frm_matdebug.SetElementColor(3+z2,3+x2,clblack);
                          end
                         else
                          begin
                            pbot(bots[ i ]).frm_matdebug.SetElementColor( z2+3, x2+3, SZINEK[pmatrix(matrices.matrixlist[boty])[botz+z2,botx+x2]] );
                          end;
                      end;
                  // frissítjük a nagy form shape-jeit
                  for z2 := 1 to matrices.bs do
                    for x2 := 1 to matrices.bs do
                      begin
                        with shpmat[z2,x2] do
                          begin
                            if ( (x2 >= botx-2) and (x2 <= botx+2) )
                               and
                               ( (z2 >= botz-2) and (z2 <= botz+2) )
                              then brush.Color := SZINEK[2]
                                  else
                                   brush.Color := SZINEK[pmatrix(matrices.matrixlist[boty])[z2,x2]];
                          end;
                      end;
                end;  // DEBUG_BOTSMATRIX
              pmatrix(matrices.matrixlist[boty])^[playermz,playermx] := moldvalue;
            end;  // health > 0
        end;  // assigned(bots[ i ])
    end;  // i ciklus
end;

// botok inicializálásánál betölti a pályához tartozó mátrix(oka)t
function LoadCollMatrix: boolean;
var
  f: cardinal;
  bytesread: cardinal;
  i,j: integer;
  header: array[0..2] of char;
  count: integer;
  matrix: pmatrix;
begin
  f := createfile(pchar(GAME_PATH_MAPS+mapgetmapname()+'\'+mapgetmapname()+'.nav'),GENERIC_READ,0,nil,
                  open_existing,FILE_ATTRIBUTE_NORMAL,0);
  if ( f <> 0 ) then
    begin
      readfile(f,header,3,bytesread,nil);
      count := 0;
      if ( header = 'NAV' ) then
        begin
          matrices.matrixlist := tlist.Create;
          readfile(f,count,sizeof(count),bytesread,nil);
          readfile(f,matrices.starty,sizeof(matrices.starty),bytesread,nil);
          readfile(f,matrices.basepx,sizeof(matrices.basepx),bytesread,nil);
          readfile(f,matrices.basepz,sizeof(matrices.basepz),bytesread,nil);
          readfile(f,matrices.bs,sizeof(matrices.bs),bytesread,nil);
          readfile(f,matrices.botsize,sizeof(matrices.botsize),bytesread,nil);
          for i := 1 to count do
            begin
              new(matrix);
              readfile(f,matrix^,sizeof(tmatrix),bytesread,nil);
              matrices.matrixlist.Add(matrix);
            end;
          result := TRUE;
          if ( DEBUG_BOTSMATRIX ) then
            begin
              matform := tform.Create(nil);
              matform.Left := 10;
              matform.top := 10;
              matform.caption := 'pálya';
              for i := 1 to matrices.bs do
                for j := 1 to matrices.bs do
                  begin
                    shpmat[i,j] := TShape.create(matform);
                    with shpmat[i,j] do
                      begin
                        parent := matform;
                        width := 10;
                        height := 10;
                        top := height*i - i;
                        left := width*j - j;
                      end;
                  end;
              matform.clientwidth := matrices.bs*10-matrices.bs;
              matform.clientheight := matrices.bs*10-matrices.bs;
              matform.Left := 5;
              matform.Top := 5;
              matform.Show;
            end;
        end
       else result := FALSE;
      closehandle(f);
    end
   else
    begin
      result := FALSE;
    end;
end;

// inicializálja a botokat
procedure botsInitialize(botsallied: string);
begin
  bots := tlist.Create;
  ba := botsallied;
  settings := cfgGetPointerToBuffer();
  snailmodel := tmcsCreateObjectFromFile(GAME_PATH_BOTS+'snail.obj',FALSE);
  if ( settings^.video_lightmaps ) then
     snaillmmodel := tmcsCreateObjectFromFile(GAME_PATH_BOTS+'snail_lm.obj',TRUE)
    else
     snaillmmodel := -1;
  tmcssetobjectlit(snailmodel, FALSE);
  if ( snaillmmodel > -1 ) then
     begin
       tmcsSetObjectLit(snaillmmodel,FALSE);
       tmcsHideObject(snaillmmodel);
       tmcsSetObjectBlendMode(snailmodel,GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
       tmcsSetObjectMultitextured(snailmodel);
       tmcsMultiTexAssignObject(snailmodel,snaillmmodel);
     end;
  tmcscompileobject(snailmodel);
  if ( snaillmmodel > -1 ) then tmcsDeleteobject(snaillmmodel);
  tmcshideobject(snailmodel);
  robotmodel := tmcsCreateObjectFromFile(GAME_PATH_BOTS+'robot.obj',FALSE);
  if ( settings^.video_lightmaps ) then
     robotlmmodel := tmcsCreateObjectFromFile(GAME_PATH_BOTS+'robot_lm.obj',TRUE)
    else
     robotlmmodel := -1;
  tmcssetobjectlit(robotmodel, FALSE);
  if ( robotlmmodel > -1 ) then
     begin
       tmcsSetObjectLit(robotlmmodel,FALSE);
       tmcsHideObject(robotlmmodel);
       tmcsSetObjectBlendMode(robotmodel,GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
       tmcsSetObjectMultitextured(robotmodel);
       tmcsMultiTexAssignObject(robotmodel,robotlmmodel);
     end;
  tmcscompileobject(robotmodel);
  if ( robotlmmodel > -1 ) then tmcsDeleteobject(robotlmmodel);
  tmcshideobject(robotmodel);
  robotmodel2 := tmcsCreateObjectFromFile(GAME_PATH_BOTS+'robot_mz.obj',false);
  tmcssetobjectlit(robotmodel2, FALSE);
  tmcssetobjectdoublesided(robotmodel2,TRUE);
  tmcshideobject(robotmodel2);
  tmcssetobjectblending(robotmodel2,TRUE);
  tmcssetobjectblendmode(robotmodel2,gl_one,gl_one);
  tmcscompileobject(robotmodel2);
  matricesready := loadcollmatrix;
  snd_snails := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\bots\snails.wav',FSOUND_NORMAL,0,0);
  FSOUND_Sample_SetMinMaxDistance(snd_snails,100,50000.0);
  FSOUND_Sample_SetMaxPlaybacks(snd_snails,2);
  snd_robots := FSOUND_Sample_Load(FSOUND_FREE,'data\sounds\bots\robots.wav',FSOUND_NORMAL,0,0);
  FSOUND_Sample_SetMinMaxDistance(snd_robots,100,50000.0);
  FSOUND_Sample_SetMaxPlaybacks(snd_robots,2);
end;

// adott indexû botnak alap értékeket állít be
// be: bot indexe
procedure botsDefaultSettings(index: integer; zerofrags: boolean);
begin
  if ( (index < bots.Count) and assigned(bots[index]) ) then
    begin
      pbot(bots[ index ])^.gravity := 0.0;
      pbot(bots[ index ])^.injurycausedbyfalling := 0.0;
      pbot(bots[ index ])^.health := game_MAX_HEALTH;
      pbot(bots[ index ])^.shield := 0;
      if ( zerofrags ) then
        begin
          pbot(bots[ index ])^.frags := 0;
          pbot(bots[ index ])^.deaths := 0;
        end;
      pbot(bots[ index ])^.target := -2;
      pbot(bots[ index ])^.attacking := FALSE;
      pbot(bots[ index ])^.lastattack := 0;
      pbot(bots[ index ])^.hasteleport := FALSE;
      pbot(bots[ index ])^.hasquaddamage := FALSE;
      pbot(bots[ index ])^.lastqdmg := 0;
      pbot(bots[ index ])^.impulsepx := 0.0;
      pbot(bots[ index ])^.impulsepy := 0.0;
      pbot(bots[ index ])^.impulsepz := 0.0;
      pbot(bots[ index ])^.oimpulsepx := 0.0;
      pbot(bots[ index ])^.oimpulsepy := 0.0;
      pbot(bots[ index ])^.oimpulsepz := 0.0;
      pbot(bots[ index ])^.yrotspeed := 0.0;
      pbot(bots[ index ])^.oldangley := 0.0;
      pbot(bots[ index ])^.timetochdir := 0;
      pbot(bots[ index ])^.timetorevive := 0;
      if ( pbot(bots[ index ])^.kind = botSnail ) then tmcsscaleobjectabsolute( pbot(bots[ index ])^.modelnum, BOTS_SNAIL_SCALE)
        else
         begin
           tmcsscaleobjectabsolute( pbot(bots[ index ])^.modelnum, BOTS_ROBOT_SCALE);
           tmcsscaleobjectabsolute( pbot(bots[ index ])^.modelnum2, BOTS_ROBOT_SCALE);
           tmcshideobject(pbot(bots[ index ])^.modelnum2);
         end;
      tmcsshowobject(pbot(bots[ index ])^.modelnum);
      collenablecollzone( botsgetattribint(index,bacollzone) );
      tmcssetanglex(pbot(bots[ index ])^.modelnum,0);
      tmcssetanglez(pbot(bots[ index ])^.modelnum,0);
     end;
end;

// létrehoz egy új botot
// be: bot fajtája (csiga vagy robot), neve
procedure botsAdd(kind: TBotsKind; name: string; teamnum: integer);
var
  index: integer;
begin
  if ( matricesready ) then
    begin
      new(bot);
      index := bots.Add(bot);
      bot^.kind := kind;
      bot^.name := name;
      bot^.teamnum := teamnum;
      bot^.vertmoving := 0.0;
      case kind of
        botSnail: begin
                     bot^.modelnum := tmcsCreateClonedObject(snailmodel);
                     bot^.modelnum2 := -1;
                     bot^.sx := tmcsgetsizex( bot^.modelnum) / (100/BOTS_SNAIL_SCALE );
                     bot^.sy := tmcsgetsizey( bot^.modelnum) / (100/BOTS_SNAIL_SCALE );
                     bot^.sz := tmcsgetsizez( bot^.modelnum) / (100/BOTS_SNAIL_SCALE );
                   end;
        botRobot: begin
                     bot^.modelnum := tmcsCreateClonedObject(robotmodel);
                     bot^.modelnum2 := tmcsCreateClonedObject(robotmodel2);
                     tmcsHideObject(bot^.modelnum2);
                     bot^.sx := tmcsgetsizex( bot^.modelnum) / (100/BOTS_ROBOT_SCALE );
                     bot^.sy := tmcsgetsizey( bot^.modelnum) / (100/BOTS_ROBOT_SCALE );
                     bot^.sz := tmcsgetsizez( bot^.modelnum) / (100/BOTS_ROBOT_SCALE );
                   end;
      end;

      if ( cfgGetGameMode() = gmTeamDeathMatch ) then
        begin
          if ( bot^.teamnum = 0 ) then tmcssetobjectcolorkey(bot^.modelnum,170,170,255,255)
            else tmcssetobjectcolorkey(bot^.modelnum,255,170,170,255);
        end
       else if ( cfgGetGameMode() = gmGaussElimination ) then
         begin
           if ( pos(bot^.name,ba) > 0 ) then tmcssetobjectcolorkey(bot^.modelnum,255,255,170,255);
         end;
      botsDefaultsettings(index,TRUE);
      bot^.collzone := collcreatezone(bot^.px,bot^.py,bot^.pz,
                                     bot^.sx,bot^.sy,bot^.sz,
                                     ctBox,bot^.modelnum);
      if ( DEBUG_BOTSMATRIX and (index = 0) ) then
        begin
          bot^.frm_matdebug := Tfrm_playermatdebug.Create(nil);
          bot^.frm_matdebug.Caption := 'Bot #'+inttostr(index);
          bot^.frm_matdebug.lbl_name.caption := name;
          bot^.frm_matdebug.Show;
        end;
  end;
end;

// törli az adott indexû botot
// be: törlendõ bot indexe
procedure botsDelete(index: integer);
begin
  if ( (index < bots.Count) and assigned(bots[index]) ) then
    begin
      tmcsdeleteobject(pbot(bots[index])^.modelnum);
      colldeletezone(pbot(bots[index])^.collzone);
      if ( DEBUG_BOTSMATRIX ) then
        begin
          pbot(bots[index])^.frm_matdebug.Close;
          pbot(bots[index])^.frm_matdebug.Free;
        end;
      dispose(bots[index]);
      bots[index] := nil;
    end;
end;

// leállítja a botokat, felszabadítja a lefoglalt erõforrásokat
procedure botsShutdown;
var
  i: integer;
begin
  for i := 0 to bots.Count-1 do
    begin
      botsDelete(i);
    end;
  bots.Free;
  tmcsDeleteObject(snailmodel);
  tmcsDeleteObject(robotmodel);
  if ( assigned(matrices.matrixlist) ) then
    begin
      for i := 0 to matrices.matrixlist.Count-1 do
        begin
          dispose(matrices.matrixlist[i]);
          matrices.matrixlist[i] := nil;
        end;
      matrices.matrixlist.Free;
    end;
end;

// ki: botok száma
function botsGetBotsCount(): integer;
begin
  result := bots.Count;
end;

// be: bot indexe, lebegõpontos típusú tulajdonság
// ki: lebegõpontos típusú tulajdonság értéke
function botsGetAttribFloat(index: integer; attrib: TBotsAttrib): single;
begin
  if ( (index <= bots.Count-1) and assigned(bots[index]) ) then
    begin
      case attrib of
        baPX         : result := pbot(bots[ index ])^.px;
        baPY         : result := pbot(bots[ index ])^.py;
        baPZ         : result := pbot(bots[ index ])^.pz;
        baOPX        : result := pbot(bots[ index ])^.opx;
        baOPY        : result := pbot(bots[ index ])^.opy;
        baOPZ        : result := pbot(bots[ index ])^.opz;
        baSX         : result := pbot(bots[ index ])^.sx;
        baSY         : result := pbot(bots[ index ])^.sy;
        baSZ         : result := pbot(bots[ index ])^.sz;
        baAngleX     : result := pbot(bots[ index ])^.anglex;
        baAngleY     : result := pbot(bots[ index ])^.angley;
        baAngleZ     : result := pbot(bots[ index ])^.anglez;
        baGravity    : result := pbot(bots[ index ])^.gravity;
        baInjuryCbyF : result := pbot(bots[ index ])^.injurycausedbyfalling;
        baImpulsePX  : result := pbot(bots[ index ])^.impulsepx;
        baImpulsePY  : result := pbot(bots[ index ])^.impulsepy;
        baImpulsePZ  : result := pbot(bots[ index ])^.impulsepz;
        baOImpulsePX : result := pbot(bots[ index ])^.oimpulsepx;
        baOImpulsePY : result := pbot(bots[ index ])^.oimpulsepy;
        baOImpulsePZ : result := pbot(bots[ index ])^.oimpulsepz;
        bayrotspeed  : result := pbot(bots[ index ])^.yrotspeed;
        baVertMoving : result := pbot(bots[ index ])^.vertmoving;
      end;
    end;
end;

// be: bot indexe, egész típusú tulajdonság
// ki: egész típusú tulajdonság értéke
function botsGetAttribInt(index: integer; attrib: TBotsAttrib): integer;
begin
  if ( (index <= bots.Count-1) and assigned(bots[index]) ) then
    begin
      case attrib of
        baTeamNum  : result := pbot(bots[ index ])^.teamnum;
        baModelNum : result := pbot(bots[ index ])^.modelnum;
        baModelNum2: result := pbot(bots[ index ])^.modelnum2;
        baHealth   : result := pbot(bots[ index ])^.health;
        baShield   : result := pbot(bots[ index ])^.shield;
        baFrags    : result := pbot(bots[ index ])^.frags;
        baDeaths   : result := pbot(bots[ index ])^.deaths;
        baCollZone : result := pbot(bots[ index ])^.collzone;
        baTimetorevive : result := pbot(bots[ index ])^.timetorevive;
        baLastQDmg : result := pbot(bots[ index ])^.lastqdmg;
        baTarget   : result := pbot(bots[ index ])^.target;
      end;
    end;
end;

// be: bot indexe, logikai típusú tulajdonság
// ki: logikai típusú tulajdonság értéke
function botsGetAttribBool(index: integer; attrib: TBotsAttrib): boolean;
begin
  if ( (index <= bots.Count-1) and assigned(bots[index]) ) then
    begin
      case attrib of
        baHasTeleport    : result := pbot(bots[ index ])^.hasteleport;
        baHasQuadDamage  : result := pbot(bots[ index ])^.hasquaddamage;
        baAttacking      : result := pbot(bots[ index ])^.attacking;
      end;
    end;
end;

// be: bot indexe, szöveges típusú tulajdonság
// ki: szöveges típusú tulajdonság értéke
function botsGetAttribString(index: integer; attrib: TBotsAttrib): string;
begin
  if ( (index <= bots.Count-1) and assigned(bots[index]) ) then
    begin
      case attrib of
        baName: result := pbot(bots[ index ])^.name;
      end;
    end;
end;

// megmondja, hogy adott indexû bot adott fajtába tartozik-e
// be: bot indexe, kérdéses fajta
// ki: bot adott fajtájú-e
function botsIsBot(index: integer; kind: TBotsKind): boolean;
begin
  if ( (index <= bots.Count-1) and assigned(bots[index]) ) then
    begin
      result := ( pbot(bots[ index ])^.kind = kind );
    end
   else result := FALSE; 
end;

// adott indexû bot adott egész típusú tulajdonságát állítja be adott értékre
// be: bot indexe, tulajdonság, érték
procedure botsSetAttribInt(index: integer; attrib: TBotsAttrib; value: integer);
begin
  if ( (index <= bots.Count-1) and assigned(bots[index]) ) then
    begin
      case attrib of
        baTeamNum  : pbot(bots[ index ])^.teamnum := value;
        baModelNum : pbot(bots[ index ])^.modelnum := value;
        baModelNum2: pbot(bots[ index ])^.modelnum2 := value;
        baHealth   : pbot(bots[ index ])^.health := value;
        baShield   : pbot(bots[ index ])^.shield := value;
        baFrags    : pbot(bots[ index ])^.frags := value;
        baDeaths   : pbot(bots[ index ])^.deaths := value;
        baCollZone : pbot(bots[ index ])^.collzone := value;
        baTimetorevive : pbot(bots[ index ])^.timetorevive := value;
        baLastQDmg : pbot(bots[ index ])^.lastqdmg := value;
        baTarget   : pbot(bots[ index ])^.target := value;
      end;
    end;
end;

// adott indexû bot adott lebegõpontos típusú tulajdonságát állítja be adott értékre
// be: bot indexe, tulajdonság, érték
procedure botsSetAttribFloat(index: integer; attrib: TBotsAttrib; value: single);
begin
  if ( (index <= bots.Count-1) and assigned(bots[index]) ) then
    begin
      case attrib of
        baOPX        : pbot(bots[ index ])^.opx := value;
        baOPY        : pbot(bots[ index ])^.opy := value;
        baOPZ        : pbot(bots[ index ])^.opz := value;
        baPX         : pbot(bots[ index ])^.px := value;
        baPY         : pbot(bots[ index ])^.py := value;
        baPZ         : pbot(bots[ index ])^.pz := value;
        baSX         : pbot(bots[ index ])^.sx := value;
        baSY         : pbot(bots[ index ])^.sy := value;
        baSZ         : pbot(bots[ index ])^.sz := value;
        baAngleX     : pbot(bots[ index ])^.anglex := value;
        baAngleY     : pbot(bots[ index ])^.angley := value;
        baAngleZ     : pbot(bots[ index ])^.anglez := value;
        baGravity    : pbot(bots[ index ])^.gravity := value;
        baInjuryCbyF : pbot(bots[ index ])^.injurycausedbyfalling := value;
        baImpulsePX  : pbot(bots[ index ])^.impulsepx := value;
        baImpulsePY  : pbot(bots[ index ])^.impulsepy := value;
        baImpulsePZ  : pbot(bots[ index ])^.impulsepz := value;
        baOImpulsePX : pbot(bots[ index ])^.oimpulsepx := value;
        baOImpulsePY : pbot(bots[ index ])^.oimpulsepy := value;
        baOImpulsePZ : pbot(bots[ index ])^.oimpulsepz := value;
        bayrotspeed  : pbot(bots[ index ])^.yrotspeed := value;
        baVertMoving : pbot(bots[ index ])^.vertmoving := value;
      end;
    end;
end;

// adott indexû bot adott logikai típusú tulajdonságát állítja be adott értékre
// be: bot indexe, tulajdonság, érték
procedure botsSetAttribBool(index: integer; attrib: TBotsAttrib; value: boolean);
begin
  if ( (index <= bots.Count-1) and assigned(bots[index]) ) then
    begin
      case attrib of
        baHasTeleport    : pbot(bots[ index ])^.hasteleport := value;
        baHasQuadDamage  : pbot(bots[ index ])^.hasquaddamage := value;
        baAttacking      : pbot(bots[ index ])^.attacking := value;
      end;
    end;
end;

// adott indexû bot adott szöveges típusú tulajdonságát állítja be adott értékre
// be: bot indexe, tulajdonság, érték
procedure botsSetAttribString(index: integer; attrib: TBotsAttrib; value: string);
begin
  if ( (index <= bots.Count-1) and assigned(bots[index]) ) then
    begin
      case attrib of
        baName: pbot(bots[ index ])^.name := value;
      end;
    end
end;

// megmondja, melyik bothoz tartozik az adott collzone
// be: collision zone indexe
// ki: a hozzá tartozó bot indexe
function botsBotFromCollZone(zoneindex: integer): integer;
var
  l: boolean;
  i: integer;
begin
  l := FALSE;
  i := -1;
  while ( not(l) and (i < bots.Count-1) ) do
    begin
      i := i+1;
      if ( assigned(bots[ i ]) ) then l := ( pbot(bots[ i ])^.collzone = zoneindex );
    end;
  if ( l ) then result := i
    else result := -2;
end;


begin

end.
