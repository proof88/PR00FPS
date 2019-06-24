unit u_map;

interface

uses
  sysutils,
  classes,
  windows,
  dialogs,
  gfxCore,
  u_consts,
  u_minimath,
  u_cfgfile,
  u_collision;

type
  TMOType = (moX,moY,moZ);
  TItemType = (itTeleport,itHealth,itShield,itQuadDamage,
               itWpnPistolAmmo,itWpnMchgunAmmo,itWpnRocketAmmo);

function mapGetMapName(): string;
procedure mapSetMapName(mapname: string);
function mapLoadCfgFile(): boolean;
function mapApplyCfgData(): boolean;
function mapLoadMap(): integer;
function mapGetObjectNum(): integer;
procedure mapFlush;
function mapGetSizeX(): single;
function mapGetSizeY(): single;
function mapGetSizeZ(): single;
function mapGetSpawnPointCount(): integer;
function mapGetSpawnPointXYZ(index: integer): TXYZ;
function mapgetspawnpointx(index: integer): single;
function mapgetspawnpointy(index: integer): single;
function mapgetspawnpointz(index: integer): single;
function mapGetSpawnPointAngleY(index: integer): single;
function mapSpawnPointIsEngaged(index: integer): boolean;
procedure mapSetSpawnPointEngagedState(index: integer; state: boolean);
function mapGetSkyBoxNum(): integer;
function mapGetMovingObjectCount(): integer;
function mapGetMovingObjectStartPos(index: integer): TXYZ;
function mapGetMovingObjectEndPos(index: integer): TXYZ;
function mapGetMovingObjectOldPos(index: integer): TXYZ;
function mapGetMovingObjectPos(index: integer): TXYZ;
procedure mapSetMovingObjectOldPos(index: integer; x,y,z: single);
procedure mapSetMovingObjectPos(index: integer; x,y,z: single);
function mapGetMovingObjectType(index: integer): TMOType;
function mapGetMovingObjectCollZone(index: integer): integer;
function mapgetmovingobjectspeed(index: integer): single;
function mapgetmovingobjectattachedobject(index: integer): integer;
function mapgetmovingobjectinternalsubobjectnum(index: integer): integer;
function mapgetmovingobjectheading(index: integer): boolean;
procedure mapsetmovingobjectheading(index: integer; state: boolean);
function mapgetitemcount(): integer;
function mapgetitemintobj(index: integer): integer;
function mapisanitemobject(index: integer): boolean;
procedure mapupdateitemmotion(index: integer; yrotplus, yheightplus: single);
function mapgetitemCollZone(index: integer): integer;
procedure mapsetitemcollzone(index1,index2: integer);
function mapgetitemtime(index: integer): cardinal;
procedure mapsetitemtime(index: integer; time: cardinal);
function mapgetitemtype(index: integer): TItemType;
function mapGetAngleYFromAToB(x1,z1,x2,z2: single): single;

implementation

type
  PSpawnPoint = ^TSpawnPoint;
  TSpawnPoint = record
                  posx,posy,posz: single;
                  angley: single;
                  engaged: boolean;
                end;
  PMovingObject = ^TMovingObject;
  TMovingObject = record
                    startpos: TXYZ;
                    endpos: TXYZ;
                    oldpos,pos: TXYZ;
                    speed: single;
                    typ3: TMOType;
                    objnum: integer;
                    internalmodel: integer;
                    ahead: boolean;
                    collzone: integer;
                  end;
  PItem = ^TItem;
  TItem = record
            posx,posy,posz: single;
            typ3: TItemType;
            intobj: integer;
            motionsin: single;
            collzone: integer;
            time: cardinal;
          end;
  TMap = record
           name: string;
           modelnum: integer;
           lightmapnum: integer;
           skyboxnum: integer;
           sizex,sizey,sizez: single;
         end;
  PMapCfgData = ^TMapCfgData;
  TMapCfgData = record
                  scale: word;
                  skycolor: TRGB;
                  skyboxfname: TSTR40;
                end;


var
  map: TMap;                        // a map
  sp: PSpawnPoint;                  // spawnpoint-ra (induló pont) mutató mutató
  spawnpoints: tlist;               // itt vannak eltárolva a spawnpoint-ok
  item: PItem;
  items: tlist;
  mo: PMovingObject;                // moving object-re mutató mutató
  movingobjects: tlist;             // itt vannak eltárolva a mozgó objektumok
  settings: pcfgdata;               // beállításokra mutató pointer
  cfgdata: PMapCfgData;             // a pályához tartozó beállításokra mutató mutató
  obj_healthitem,obj_shielditem,
  obj_teleportitem,obj_quaddmgitem,
  obj_pistolammoitem,obj_mchgunammoitem,
  obj_rocketammoitem : integer;



{ visszaadja a beállított map nevet }
function mapGetMapName(): string;
begin
  result := map.name;
end;

{ beállítja a map nevét }
procedure mapSetMapName(mapname: string);
begin
  map.name := mapname;
end;

{ betölti a beállított pálya név alapján a hozzátartozó config fájlt }
function mapLoadCfgFile(): boolean;
var
  filehandle: cardinal;
  bytesread: cardinal;
begin
  if ( not(assigned(cfgdata)) ) then
    begin
      new(cfgdata);
      zeromemory(cfgdata,sizeof(TMapCfgData));
    end;
  if ( fileExists(GAME_PATH_MAPS+map.name+'\'+map.name+'.dat') ) then
    begin
      filehandle := createfile(pchar(GAME_PATH_MAPS+map.name+'\'+map.name+'.dat'),
                               GENERIC_READ,FILE_SHARE_READ,nil,OPEN_EXISTING,
                               FILE_ATTRIBUTE_NORMAL,0);
      readfile(filehandle,cfgdata^,sizeof(TMapCfgData),bytesread,nil);
      closehandle(filehandle);
      result := TRUE;
    end
   else result := FALSE;
end;

{ érvényesíti a betöltött config fájlban letárolt beállításokat }
function mapApplyCfgData(): boolean;
var
  i: integer;
  scaling: single;
  filt: TGLConst;
begin
  if ( assigned(cfgdata) ) then
    begin
      tmcsSetBgColor(cfgdata^.skycolor.red,cfgdata^.skycolor.green,cfgdata^.skycolor.blue,255);
      tmcsScaleObject(map.modelnum,cfgdata^.scale);
      scaling := 100/tmcsGetScaling(map.modelnum);
      map.sizex := map.sizex/scaling;
      map.sizey := map.sizey/scaling;
      map.sizez := map.sizez/scaling;
      if ( settings^.video_mipmaps ) then
        begin
          if ( settings^.video_filtering = 0 ) then filt := GL_LINEAR_MIPMAP_NEAREST
            else filt := GL_LINEAR_MIPMAP_LINEAR;
        end
       else
        begin
          if ( settings^.video_filtering = 0 ) then filt := GL_NEAREST
            else filt := GL_LINEAR;
        end;
      tmcsSetExtObjectsTexturemode(FALSE,GL_LINEAR,GL_decal,FALSE,FALSE,GL_clamp,GL_clamp);
      if ( settings^.video_simpleitems ) then
        map.skyboxnum := tmcsCreateObjectFromFile(GAME_PATH_MAPS+map.name+'\'+cfgdata^.skyboxfname,FALSE)
       else map.skyboxnum := -1;
      tmcsSetExtObjectsTextureMode(settings^.video_mipmaps,filt,GL_DECAL,FALSE,FALSE,GL_REPEAT,GL_REPEAT);
      if ( map.skyboxnum > -1 ) then
        begin
          tmcsSetObjectLit(map.skyboxnum,FALSE);
          tmcsScaleObject(map.skyboxnum,cfgdata^.scale);
          tmcsAdjustUVCoords(map.skyboxnum,GAME_SKYBOX_UV_BIAS);
          tmcsCompileObject(map.skyboxnum);
        end
       else
        begin
          tmcsSetBgColor(cfgdata^.skycolor.red,cfgdata^.skycolor.green,cfgdata^.skycolor.blue,255);
        end;
      for i := 0 to movingobjects.Count-1 do
        begin
          mo := movingobjects[i];
          tmcsscaleobject(mo^.objnum,tmcsgetscaling(map.modelnum));
          tmcssetxpos(mo^.objnum,tmcsgetxpos(mo^.objnum)/scaling);
          tmcssetypos(mo^.objnum,tmcsgetypos(mo^.objnum)/scaling);
          tmcssetzpos(mo^.objnum,tmcsgetzpos(mo^.objnum)/scaling);
          mo^.startpos.x := mo^.startpos.x / scaling;
          mo^.startpos.y := mo^.startpos.y / scaling;
          mo^.startpos.z := mo^.startpos.z / scaling;
          mo^.endpos.x := mo^.endpos.x / scaling;
          mo^.endpos.y := mo^.endpos.y / scaling;
          mo^.endpos.z := mo^.endpos.z / scaling;

          mo^.collzone := collCreateZone(tmcsgetxpos(mo^.objnum),
                                        tmcsgetypos(mo^.objnum),
                                        tmcsgetzpos(mo^.objnum),
                                        tmcsGetSizeX(mo^.objnum)/scaling,
                                        tmcsGetSizeY(mo^.objnum)/scaling,
                                        tmcsGetSizeZ(mo^.objnum)/scaling,
                                        ctBox,mo^.objnum);
        end;
      for i := 0 to items.Count-1 do
        begin
          item := items[i];
          tmcssetxpos(item^.intobj,tmcsgetxpos(item^.intobj)/scaling);
          tmcssetypos(item^.intobj,tmcsgetypos(item^.intobj)/scaling);
          tmcssetzpos(item^.intobj,tmcsgetzpos(item^.intobj)/scaling);
        end;
      result := TRUE;
    end
   else result := FALSE;
end;



{ betölti a beállított név alapján a pályát }
function mapLoadMap(): integer;
var
  i: integer;
  buffer: string;
  tmpi: integer;
  tmps,tmps2: string;
  tmpf: single;
  dm: char;
  filt: TGLConst;
begin
  spawnpoints := tlist.Create;
  movingobjects := tlist.Create;
  items := tlist.Create;
  settings := cfgGetPointerToBuffer();
  if ( settings^.video_mipmaps ) then
    begin
      if ( settings^.video_filtering = 0 ) then filt := GL_LINEAR_MIPMAP_NEAREST
        else filt := GL_LINEAR_MIPMAP_LINEAR;
    end
   else
    begin
      if ( settings^.video_filtering = 0 ) then filt := GL_NEAREST
        else filt := GL_LINEAR;
    end;
  tmcsSetExtObjectsTextureMode(settings^.video_mipmaps,filt,GL_DECAL,FALSE,TRUE,GL_REPEAT,GL_REPEAT);
  map.modelnum := tmcsCreateObjectFromFile(GAME_PATH_MAPS+map.name+'\'+map.name+'.obj',FALSE);
  map.lightmapnum := -1;
  dm := decimalseparator;
  if ( settings^.video_lightmaps ) then map.lightmapnum := tmcscreateobjectfromfile(GAME_PATH_MAPS+map.name+'\'+map.name+'_lm.obj',FALSE);
  obj_healthitem := tmcsCreateObjectFromFile(GAME_PATH_ITEMS+'health.obj',FALSE);
  tmcscompileobject(obj_healthitem);
  tmcsScaleObject(obj_healthitem,GAME_ITEMS_SCALE);
  tmcsSetobjectlit(obj_healthitem,FALSE);
  tmcshideobject(obj_healthitem);
  obj_shielditem := tmcsCreateObjectFromFile(GAME_PATH_ITEMS+'shield.obj',FALSE);
  tmcscompileobject(obj_shielditem);
  tmcsScaleObject(obj_shielditem,GAME_ITEMS_SCALE);
  tmcsSetobjectlit(obj_shielditem,FALSE);
  tmcshideobject(obj_shielditem);
  obj_teleportitem := tmcsCreateObjectFromFile(GAME_PATH_ITEMS+'teleport.obj',FALSE);
  tmcscompileobject(obj_teleportitem);
  tmcsScaleObject(obj_teleportitem,GAME_ITEMS_SCALE);
  tmcsSetobjectlit(obj_teleportitem,FALSE);
  tmcshideobject(obj_teleportitem);
  obj_quaddmgitem := tmcsCreateObjectFromFile(GAME_PATH_ITEMS+'quaddamage.obj',FALSE);
  tmcscompileobject(obj_quaddmgitem);
  tmcsScaleObject(obj_quaddmgitem,GAME_ITEMS_SCALE);
  tmcsSetobjectlit(obj_quaddmgitem,FALSE);
  tmcshideobject(obj_quaddmgitem);
  obj_pistolammoitem := tmcsCreateObjectFromFile(GAME_PATH_ITEMS+'wpn_pistol_ammo.obj',FALSE);
  tmcscompileobject(obj_pistolammoitem);
  tmcsScaleObject(obj_pistolammoitem,GAME_ITEMS_SCALE);
  tmcsSetobjectlit(obj_pistolammoitem,FALSE);
  tmcshideobject(obj_pistolammoitem);
  obj_mchgunammoitem := tmcsCreateObjectFromFile(GAME_PATH_ITEMS+'wpn_mchgun_ammo.obj',FALSE);
  tmcscompileobject(obj_mchgunammoitem);
  tmcsScaleObject(obj_mchgunammoitem,GAME_ITEMS_SCALE);
  tmcsSetobjectlit(obj_mchgunammoitem,FALSE);
  tmcshideobject(obj_mchgunammoitem);
  obj_rocketammoitem := tmcsCreateObjectFromFile(GAME_PATH_ITEMS+'wpn_rocket_ammo.obj',FALSE);
  tmcscompileobject(obj_rocketammoitem);
  tmcsScaleObject(obj_rocketammoitem,GAME_ITEMS_SCALE);
  tmcsSetobjectlit(obj_rocketammoitem,FALSE);
  tmcshideobject(obj_rocketammoitem);

  if ( map.modelnum > -1 ) then
    begin
      result := map.modelnum;
      tmcsSetObjectLit(map.modelnum,FALSE);
      map.sizex := tmcsGetSizeX(map.modelnum);
      map.sizey := tmcsGetSizeY(map.modelnum);
      map.sizez := tmcsGetSizeZ(map.modelnum);

      for i := 0 to tmcsGetNumSubObjects(map.modelnum)-1 do
        begin
          buffer := tmcsgetsubname(map.modelnum,i);
          if ( pos('sp_',buffer) = 1 ) then
            begin
              new(sp);
              sp^.posx := tmcsGetSubXPos(map.modelnum,i);
              sp^.posy := tmcsGetSubYPos(map.modelnum,i);
              sp^.posz := tmcsGetSubZPos(map.modelnum,i);
              sp^.angley := strtofloat( copy(buffer,4,3) );
              sp^.engaged := FALSE;
              spawnpoints.Add(sp);
              tmcshidesubobject(map.modelnum,i);
            end;
          if ( pos('teleport',buffer) = 1 ) then
            begin
              new(item);
              item^.posx := tmcsGetSubXPos(map.modelnum,i);
              item^.posy := tmcsGetSubyPos(map.modelnum,i);
              item^.posz := -tmcsGetSubzPos(map.modelnum,i);
              item^.typ3 := itTeleport;
              item^.motionsin := random(360);
              item^.intobj := tmcsCreateClonedObject(obj_teleportitem);
              item^.time := 0;
              tmcsShowObject(item^.intobj);
              tmcsSetXPos(item^.intobj,item^.posx);
              tmcsSetyPos(item^.intobj,item^.posy);
              tmcsSetzPos(item^.intobj,item^.posz);
              items.Add(item);
              tmcsHideSubObject(map.modelnum,i);
            end;
          if ( pos('health',buffer) = 1 ) then
            begin
              new(item);
              item^.posx := tmcsGetSubXPos(map.modelnum,i);
              item^.posy := tmcsGetSubyPos(map.modelnum,i);
              item^.posz := -tmcsGetSubzPos(map.modelnum,i);
              item^.typ3 := itHealth;
              item^.motionsin := random(360);
              item^.intobj := tmcsCreateClonedObject(obj_healthitem);;
              item^.time := 0;
              tmcsShowObject(item^.intobj);
              tmcsSetXPos(item^.intobj,item^.posx);
              tmcsSetyPos(item^.intobj,item^.posy);
              tmcsSetzPos(item^.intobj,item^.posz);
              items.Add(item);
              tmcsHideSubObject(map.modelnum,i);
            end;
          if ( pos('shield',buffer) = 1 ) then
            begin
              new(item);
              item^.posx := tmcsGetSubXPos(map.modelnum,i);
              item^.posy := tmcsGetSubyPos(map.modelnum,i);
              item^.posz := -tmcsGetSubzPos(map.modelnum,i);
              item^.typ3 := itShield;
              item^.motionsin := random(360);
              item^.intobj := tmcsCreateClonedObject(obj_shielditem);
              item^.time := 0;
              tmcsShowObject(item^.intobj);
              tmcsSetXPos(item^.intobj,item^.posx);
              tmcsSetyPos(item^.intobj,item^.posy);
              tmcsSetzPos(item^.intobj,item^.posz);
              tmcsSetObjectDoubleSided(item^.intobj,TRUE);
              items.Add(item);
              tmcsHideSubObject(map.modelnum,i);
            end;
          if ( pos('quaddamage',buffer) = 1 ) then
            begin
              new(item);
              item^.posx := tmcsGetSubXPos(map.modelnum,i);
              item^.posy := tmcsGetSubyPos(map.modelnum,i);
              item^.posz := -tmcsGetSubzPos(map.modelnum,i);
              item^.typ3 := itQuadDamage;
              item^.motionsin := random(360);
              item^.intobj := tmcsCreateClonedObject(obj_quaddmgitem);
              item^.time := 0;
              tmcsShowObject(item^.intobj);
              tmcsSetXPos(item^.intobj,item^.posx);
              tmcsSetyPos(item^.intobj,item^.posy);
              tmcsSetzPos(item^.intobj,item^.posz);
              tmcsSetObjectDoubleSided(item^.intobj,TRUE);
              items.Add(item);
              tmcsHideSubObject(map.modelnum,i);
            end;

          if ( pos('pistolammo',buffer) = 1 ) then
            begin
              new(item);
              item^.posx := tmcsGetSubXPos(map.modelnum,i);
              item^.posy := tmcsGetSubyPos(map.modelnum,i);
              item^.posz := -tmcsGetSubzPos(map.modelnum,i);
              item^.typ3 := itWpnPistolAmmo;
              item^.motionsin := random(360);
              item^.intobj := tmcsCreateClonedObject(obj_pistolammoitem);
              item^.time := 0;
              tmcsShowObject(item^.intobj);
              tmcsSetXPos(item^.intobj,item^.posx);
              tmcsSetyPos(item^.intobj,item^.posy);
              tmcsSetzPos(item^.intobj,item^.posz);
              items.Add(item);
              tmcsHideSubObject(map.modelnum,i);
            end;
          if ( pos('mchgunammo',buffer) = 1 ) then
            begin
              new(item);
              item^.posx := tmcsGetSubXPos(map.modelnum,i);
              item^.posy := tmcsGetSubyPos(map.modelnum,i);
              item^.posz := -tmcsGetSubzPos(map.modelnum,i);
              item^.typ3 := itWpnMchgunAmmo;
              item^.motionsin := random(360);
              item^.intobj := tmcsCreateClonedObject(obj_mchgunammoitem);
              item^.time := 0;
              tmcsShowObject(item^.intobj);
              tmcsSetXPos(item^.intobj,item^.posx);
              tmcsSetyPos(item^.intobj,item^.posy);
              tmcsSetzPos(item^.intobj,item^.posz);
              items.Add(item);
              tmcsHideSubObject(map.modelnum,i);
            end;
          if ( pos('rocketammo',buffer) = 1 ) then
            begin
              new(item);
              item^.posx := tmcsGetSubXPos(map.modelnum,i);
              item^.posy := tmcsGetSubyPos(map.modelnum,i);
              item^.posz := -tmcsGetSubzPos(map.modelnum,i);
              item^.typ3 := itWpnRocketAmmo;
              item^.motionsin := random(360);
              item^.intobj := tmcsCreateClonedObject(obj_rocketammoitem);
              item^.time := 0;
              tmcsShowObject(item^.intobj);
              tmcsSetXPos(item^.intobj,item^.posx);
              tmcsSetyPos(item^.intobj,item^.posy);
              tmcsSetzPos(item^.intobj,item^.posz);
              items.Add(item);
              tmcsHideSubObject(map.modelnum,i);
            end;
          tmpi := pos('mov_',buffer);                                // buffer = b_mov_y_100_s_1
          if ( tmpi > 0 ) then
            begin
              new(mo);
              mo^.startpos.x := tmcsgetsubxpos(map.modelnum,i);
              mo^.startpos.y := tmcsgetsubypos(map.modelnum,i);
              mo^.startpos.z := tmcsgetsubzpos(map.modelnum,i);
              tmps := copy(buffer,tmpi+4,2);                         // y_
              tmps2 := copy(buffer,tmpi+6,length(buffer)-(tmpi+5));  // 100_s_1
              if ( pos('.',tmps2) > 0 ) then decimalseparator := '.'
                else decimalseparator := ',';
              tmpf := strtofloat(copy(tmps2,1,pos('_',tmps2)-1));    // 100
              if ( tmps = 'x_' ) then
                begin
                  mo^.endpos.x := mo^.startpos.x + tmpf;
                  mo^.endpos.y := mo^.startpos.y;
                  mo^.endpos.z := mo^.startpos.z;
                  mo^.typ3 := moX;
                end
               else if ( tmps = 'y_' ) then
                 begin
                   mo^.endpos.x := mo^.startpos.x;
                   mo^.endpos.y := mo^.startpos.y + tmpf;
                   mo^.endpos.z := mo^.endpos.z;
                   mo^.typ3 := moY;
                 end
                else if ( tmps = 'z_' ) then
                  begin
                    mo^.endpos.x := mo^.startpos.x;
                    mo^.endpos.y := mo^.startpos.y;
                    mo^.endpos.z := mo^.startpos.z + tmpf;
                    mo^.typ3 := moZ;
                  end;
              tmps := copy(tmps2,pos('s_',tmps2)+2,length(tmps2)-(pos('s_',tmps2)-1)); // 1
              if ( pos('.',tmps) > 0 ) then decimalseparator := '.'
                else decimalseparator := ',';
              mo^.speed := strtofloat(tmps);
              mo^.internalmodel := i;
              tmcshidesubobject(map.modelnum,mo^.internalmodel);
              mo^.ahead := TRUE;
              mo^.objnum := tmcscreatebox(tmcsGetSubSizeX(map.modelnum,i),
                                         tmcsGetSubSizeY(map.modelnum,i),
                                         tmcsGetSubSizeZ(map.modelnum,i));
              tmcssetxpos(mo^.objnum,tmcsgetsubxpos(map.modelnum,i));
              tmcssetypos(mo^.objnum,tmcsgetsubypos(map.modelnum,i));
              tmcssetzpos(mo^.objnum,-tmcsgetsubzpos(map.modelnum,i));
              tmcssetobjectlit(mo^.objnum,FALSE);
              if ( tmcsgetsubobjecttexture(map.modelnum,i) > -1 ) then
                tmcstextureobject(mo^.objnum,tmcsgetsubobjecttexture(map.modelnum,i));
              tmcscompileobject(mo^.objnum);
              movingobjects.Add(mo);
            end;
        end;

      if ( map.lightmapnum > -1 ) then
        begin
          tmcsHideObject(map.lightmapnum);
          tmcsSetObjectBlendMode(map.modelnum,GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
          tmcsSetObjectMultitextured(map.modelnum);
          tmcsMultiTexAssignObject(map.modelnum,map.lightmapnum);
        end;   
      tmcsCompileObject(map.modelnum);
      if ( map.lightmapnum > -1 ) then
        begin
          tmcsDeleteObject(map.lightmapnum);
          map.lightmapnum := -1;
        end;
    end
   else result := -1;

  decimalseparator := dm;
end;

{ a pályához tartozó betöltött erõforrásokat felszabadítja }
procedure mapFlush;
var
  i: integer;
begin
  if ( map.modelnum > -1 ) then
    begin
      tmcsDeleteObject(map.modelnum);
      if ( map.skyboxnum > -1 ) then tmcsDeleteObject(map.skyboxnum);
      if ( assigned(spawnpoints) ) then
        begin
          for i := 0 to spawnpoints.Count-1 do
            begin
              sp := spawnpoints[i];
              if ( assigned(sp) ) then
                begin
                  dispose(spawnpoints[i]);
                  spawnpoints[i] := nil;
                end;
            end;
          spawnpoints.Free;
        end;
      if ( assigned(items) ) then
        begin
          for i := 0 to items.Count-1 do
            begin
              item := items[i];
              if ( assigned(item) ) then
                begin
                  tmcsDeleteObject(item^.intobj);
                  collDeleteZone(item^.collzone);
                  dispose(items[i]);
                  items[i] := nil;
                end;
            end;
          items.Free;
        end;
      tmcsdeleteobject(obj_healthitem);
      tmcsdeleteobject(obj_shielditem);
      tmcsdeleteobject(obj_teleportitem);
      tmcsdeleteobject(obj_quaddmgitem);
      tmcsdeleteobject(obj_pistolammoitem);
      tmcsdeleteobject(obj_mchgunammoitem);
      tmcsdeleteobject(obj_rocketammoitem);
      if ( assigned(movingobjects) ) then
        begin
          for i := 0 to movingobjects.Count-1 do
            begin
              mo := movingobjects[i];
              if ( assigned(mo) ) then
                begin
                  tmcsDeleteObject(mo^.objnum);
                  collDeleteZone(mo^.collzone);
                  dispose(movingobjects[i]);
                  movingobjects[i] := nil;
                end;
            end;
          movingobjects.Free;
        end;
    end;  // map.modelnum > -1
end;

function mapGetObjectNum(): integer;
begin
  result := map.modelnum;
end;

function mapGetSizeX(): single;
begin
  result := map.sizex;
end;

function mapGetSizeY(): single;
begin
  result := map.sizey;
end;

function mapGetSizeZ(): single;
begin
  result := map.sizez;
end;

{ a betöltött pályán elhelyezett induló pozíciók számát adja vissza }
function mapGetSpawnPointCount(): integer;
begin
  result := spawnpoints.Count;
end;

function mapGetSpawnPointXYZ(index: integer): TXYZ;
var pos: TXYZ;
begin
  if ( index < spawnpoints.Count ) then
    begin
      sp := spawnpoints[index];
      pos.x := sp^.posx;
      pos.y := sp^.posy;
      pos.z := sp^.posz;
      result := pos;
    end;
end;

function mapgetspawnpointx(index: integer): single;
begin
  if ( index < spawnpoints.Count ) then
    begin
      sp := spawnpoints[index];
      result := sp^.posx;
    end;
end;

function mapgetspawnpointy(index: integer): single;
begin
  if ( index < spawnpoints.Count ) then
    begin
      sp := spawnpoints[index];
      result := sp^.posy;
    end;
end;

function mapgetspawnpointz(index: integer): single;
begin
  if ( index < spawnpoints.Count ) then
    begin
      sp := spawnpoints[index];
      result := sp^.posz;
    end;
end;

function mapGetSpawnPointAngleY(index: integer): single;
begin
  if ( index < spawnpoints.Count ) then
    begin
      sp := spawnpoints[index];
      result := sp^.angley;
    end;
end;

function mapSpawnPointIsEngaged(index: integer): boolean;
begin
  if ( index < spawnpoints.Count ) then
    begin
      sp := spawnpoints[index];
      result := sp^.engaged;
    end;
end;

procedure mapSetSpawnPointEngagedState(index: integer; state: boolean);
begin
  if ( index < spawnpoints.Count ) then
    begin
      sp := spawnpoints[index];
      sp^.engaged := state;
    end;
end;

function mapGetSkyBoxNum(): integer;
begin
  result := map.skyboxnum;
end;

function mapGetMovingObjectCount(): integer;
begin
  result := movingobjects.Count;
end;

function mapGetMovingObjectType(index: integer): TMOType;
begin
  if ( index < movingobjects.Count ) then
    begin
      mo := movingobjects[index];
      result := mo^.typ3;
    end;
end;

function mapGetMovingObjectCollZone(index: integer): integer;
begin
  if ( index < movingobjects.Count ) then
    begin
      mo := movingobjects[index];
      result := mo^.collzone;
    end;
end;

function mapGetMovingObjectStartPos(index: integer): TXYZ;
begin
  if ( index < movingobjects.Count ) then
    begin
      mo := movingobjects[index];
      result := mo^.startpos;
    end;
end;

function mapGetMovingObjectEndPos(index: integer): TXYZ;
begin
  if ( index < movingobjects.Count ) then
    begin
      mo := movingobjects[index];
      result := mo^.endpos;
    end;
end;

function mapGetMovingObjectOldPos(index: integer): TXYZ;
begin
  if ( index < movingobjects.Count ) then
    begin
      mo := movingobjects[index];
      result := mo^.oldpos;
    end;
end;

function mapGetMovingObjectPos(index: integer): TXYZ;
begin
  if ( index < movingobjects.Count ) then
    begin
      mo := movingobjects[index];
      result := mo^.pos;
    end;
end;

procedure mapSetMovingObjectOldPos(index: integer; x,y,z: single);
begin
  if ( index < movingobjects.Count ) then
    begin
      mo := movingobjects[index];
      mo^.oldpos.x := x;
      mo^.oldpos.y := y;
      mo^.oldpos.z := z;
    end;
end;

procedure mapSetMovingObjectPos(index: integer; x,y,z: single);
begin
  if ( index < movingobjects.Count ) then
    begin
      mo := movingobjects[index];
      mo^.pos.x := x;
      mo^.pos.y := y;
      mo^.pos.z := z;
    end;
end;

function mapGetMovingObjectSpeed(index: integer): single;
begin
  if ( index < movingobjects.Count ) then
    begin
      mo := movingobjects[index];
      result := mo^.speed;
    end;
end;

function mapgetmovingobjectattachedobject(index: integer): integer;
begin
  if ( index < movingobjects.Count ) then
    begin
      mo := movingobjects[index];
      result := mo^.objnum;
    end;
end;

function mapgetmovingobjectinternalsubobjectnum(index: integer): integer;
begin
  if ( index < movingobjects.Count ) then
    begin
      mo := movingobjects[index];
      result := mo^.internalmodel;
    end;
end;

function mapgetmovingobjectheading(index: integer): boolean;
begin
  if ( index < movingobjects.Count ) then
    begin
      mo := movingobjects[index];
      result := mo^.ahead;
    end;
end;

procedure mapsetmovingobjectheading(index: integer; state: boolean);
begin
  if ( index < movingobjects.Count ) then
    begin
      mo := movingobjects[index];
      mo^.ahead := state;
    end;
end;

function mapgetitemcount(): integer;
begin
  result := items.Count;
end;

// visszaadja az adott sorszámú itemhez tartozó objektum sorszámát
function mapgetitemintobj(index: integer): integer;
begin
  if ( index <= items.Count-1 ) then
    begin
      item := items[index];
      result := item^.intobj;
    end;
end;

// megállapítja, hogy adott objektum item objektum-e
function mapisanitemobject(index: integer): boolean;
var
  i: integer;
  l: boolean;
begin
  l := FALSE;
  i := -1;
  while ( not(l) and (i < items.Count-1) ) do
    begin
      i := i + 1;
      item := items[i];
      l := (item^.intobj = index);
    end;
  result := l;
end;

procedure mapupdateitemmotion(index: integer; yrotplus, yheightplus: single);
var
  scaling: single;
begin
  if ( (index <= items.Count-1) and (tmcsisvisible(pitem(items[index])^.intobj)) ) then
    begin
      scaling := 100/tmcsGetScaling(map.modelnum);
      item := items[index];
      tmcsyrotateobject(item^.intobj,yrotplus);
      if ( item^.motionsin < 359 ) then item^.motionsin := item^.motionsin + yheightplus
        else item^.motionsin := 0;
      tmcssetypos(item^.intobj,item^.posy/scaling + sin(degtorad(item^.motionsin)));
    end;
end;

function mapgetitemCollZone(index: integer): integer;
begin
  if ( index <= items.Count-1 ) then
    begin
      item := items[index];
      result := item^.collzone;
    end
   else result := -1;
end;

procedure mapsetitemcollzone(index1,index2: integer);
begin
  if ( index1 <= items.Count-1 ) then
    begin
      item := items[index1];
      item^.collzone := index2;
    end;
end;

function mapgetitemtime(index: integer): cardinal;
begin
  if ( index <= items.Count-1 ) then
    begin
      item := items[index];
      result := item^.time;
    end;
end;

procedure mapsetitemtime(index: integer; time: cardinal);
begin
  if ( index <= items.Count-1 ) then
    begin
      item := items[index];
      item^.time := time;
    end;
end;

function mapgetitemtype(index: integer): TItemType;
begin
  if ( index <= items.Count-1 ) then
    begin
      item := items[index];
      result := item^.typ3;
    end;
end;

function mapGetAngleYFromAToB(x1,z1,x2,z2: single): single;
var
  a,b,c: single;
  sinalfa: single;
  radalfa,alfa: single;
begin
  {
      I\
    a Iß\ c
      I  \
      I__L\
       b
  }
  
  a := z2 - z1;
  b := x2 - x1;
  c := sqrt(a*a + b*b);
  sinalfa := a/c;
  radalfa := arcsin( sinalfa );
  alfa := radtodeg( radalfa );
  if ( x2 < x1 ) then alfa := 90 + (90 - alfa)
    else if ( (x2 > x1) and (z2 < z1) ) then alfa := 360 + alfa;
  result := alfa;
end;

end.
