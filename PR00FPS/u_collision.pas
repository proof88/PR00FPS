unit u_collision;

interface

uses
  classes,
  sysutils,
  dialogs,
  windows,
  gfxcore,
  u_consts,
  u_minimath;

type
  TCollisionType = (ctNone,ctBox,ctSpherical,ctCylindrical,
                    ctSlopeN,ctSlopeS,ctSlopeW,ctSlopeE);

procedure collInitialize;
function  collGetZoneCount(): integer;
function  collCreateZone(px,py,pz,sx,sy,sz: single; typ3: TCollisionType; attachedobject: integer): integer;
function  collGetZonePosX(index: integer): single;
procedure collSetZonePosX(index: integer; px: single);
function  collGetZonePosY(index: integer): single;
procedure collSetZonePosY(index: integer; py: single);
function  collGetZonePosZ(index: integer): single;
procedure collSetZonePosZ(index: integer; pz: single);
procedure collSetZonePos(index: integer; px,py,pz: single);
function  collGetZoneSizeX(index: integer): single;
procedure collSetZoneSizeX(index: integer; sx: single);
function  collGetZoneSizeY(index: integer): single;
procedure collSetZoneSizeY(index: integer; sy: single);
function  collGetZoneSizeZ(index: integer): single;
procedure collSetZoneSizeZ(index: integer; sz: single);
procedure collSetZoneSize(index: integer; sx,sy,sz: single);
function  collGetZoneType(index: integer): TCollisionType;
procedure collSetZoneType(index: integer; typ3: TCollisionType);
function  collGetAttachedObject(index: integer): integer;
procedure collSetAttachedObject(index1, index2: integer);
function  collGetAttachedSubObject(index: integer): integer;
procedure collSetAttachedSubObject(index1, index2: integer);
procedure collEnableCollZone(index: integer);
procedure collDisableCollZone(index: integer);
function  collZoneIsActive(index: integer): boolean;
function  collSlopeGetYCoord(collzone: integer; px,py,pz,sx,sy,sz: single; playerind: integer): single; overload;
function  collSlopeGetAngle(cz: integer): single;
function  collIsAreaInZone(px,py,pz,sx,sy,sz: single; playerind: integer): integer; overload;
function  collIsAreaInZone(px,py,pz,sx,sy,sz: single; start: integer; playerind: integer): integer; overload;
function  collTestBoxCollisionAgainstZone(px,py,pz,sx,sy,sz: single; index: integer; playerind: integer): boolean;
procedure collCreateZonesForObject(index: integer);
procedure collDeleteZone(index: integer);
procedure collFlush;

implementation

type
  PCollisionZone = ^TCollisionZone;
  TCollisionZone = record
                     posx,posy,posz: single;
                     sizex,sizey,sizez: single;
                     active: boolean;
                     typ3: TCollisionType;
                     attachedobject,attachedsubobject: integer;
                     debugbox: integer;
                   end;

var
  collzones: TList;
  collzone: PCollisionZone;

procedure collInitialize;
begin
  collzones := TList.Create;
  randomize;
end;

function collGetZoneCount(): integer;
begin
  result := collzones.Count;
end;

function collCreateZone(px,py,pz,sx,sy,sz: single; typ3: TCollisionType; attachedobject: integer): integer;
begin
  new(collzone);
  collzone^.posx := px;
  collzone^.posy := py;
  collzone^.posz := pz;
  collzone^.sizex := sx;
  collzone^.sizey := sy;
  collzone^.sizez := sz;
  collzone^.typ3 := typ3;
  collzone^.active := TRUE;
  collzone^.attachedobject := attachedobject;
  collzone^.attachedsubobject := 0;
  result := collzones.Add(collzone);

  if ( DEBUG_COLLISION ) then
    begin
      collzone^.debugbox := tmcsCreateBox(sx,sy,sz);
      tmcssetxpos(collzone^.debugbox,px);
      tmcssetypos(collzone^.debugbox,py);
      tmcssetzpos(collzone^.debugbox,pz);
      tmcssetobjectwireframe(collzone^.debugbox,TRUE);
      tmcssetobjectdoublesided(collzone^.debugbox,TRUE);
      tmcssetobjectlit(collzone^.debugbox,FALSE);
      tmcssetobjectcolor(collzone^.debugbox,random(256),random(256),random(256));
      tmcssetobjectzbuffered(collzone^.debugbox,FALSE);
    end;
end;

function collGetZonePosX(index: integer): single;
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      result := collzone^.posx;
    end;
end;

procedure collSetZonePosX(index: integer; px: single);
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      collzone^.posx := px;
      if ( DEBUG_COLLISION ) then tmcssetxpos(collzone^.debugbox,px);
    end;
end;

function collGetZonePosY(index: integer): single;
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      result := collzone^.posy;
    end;
end;

procedure collSetZonePosY(index: integer; py: single);
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      collzone^.posy := py;
      if ( DEBUG_COLLISION ) then tmcssetypos(collzone^.debugbox,py);
    end;
end;

function collGetZonePosZ(index: integer): single;
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      result := collzone^.posz;
    end;
end;

procedure collSetZonePosZ(index: integer; pz: single);
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      collzone^.posz := pz;
      if ( DEBUG_COLLISION ) then tmcssetzpos(collzone^.debugbox,pz);
    end;
end;

procedure collSetZonePos(index: integer; px,py,pz: single);
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      collzone^.posx := px;
      collzone^.posy := py;
      collzone^.posz := pz;
      if ( DEBUG_COLLISION ) then
        begin
          tmcssetxpos(collzone^.debugbox,px);
          tmcssetypos(collzone^.debugbox,py);
          tmcssetzpos(collzone^.debugbox,pz);
        end;
    end;
end;

function collGetZoneSizeX(index: integer): single;
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      result := collzone^.sizex;
    end;
end;

procedure collSetZoneSizeX(index: integer; sx: single);
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      collzone^.sizex := sx;
    end;
end;

function collGetZoneSizeY(index: integer): single;
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      result := collzone^.sizey;
    end;
end;

procedure collSetZoneSizeY(index: integer; sy: single);
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      collzone^.sizey := sy;
    end;
end;

function collGetZoneSizeZ(index: integer): single;
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      result := collzone^.sizez;
    end;
end;

procedure collSetZoneSizeZ(index: integer; sz: single);
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      collzone^.sizez := sz;
    end;
end;

procedure collSetZoneSize(index: integer; sx,sy,sz: single);
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      collzone^.sizex := sx;
      collzone^.sizey := sy;
      collzone^.sizez := sz;
    end;
end;

function collGetZoneType(index: integer): TCollisionType;
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      result := collzone^.typ3;
    end;
end;

procedure collSetZoneType(index: integer; typ3: TCollisionType);
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      collzone^.typ3 := typ3;
    end;
end;

function collGetAttachedObject(index: integer): integer;
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      result := collzone^.attachedobject;
    end
   else result := -1;
end;

procedure collSetAttachedObject(index1, index2: integer);
begin
  if ( (index1 < collzones.Count) and assigned(collzones[index1]) ) then
    begin
      collzone := collzones[index1];
      collzone^.attachedobject := index2;
    end;
end;

function collGetAttachedSubObject(index: integer): integer;
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      result := collzone^.attachedsubobject;
    end;
end;

procedure collSetAttachedSubObject(index1, index2: integer);
begin
  if ( (index1 < collzones.Count) and assigned(collzones[index1]) ) then
    begin
      collzone := collzones[index1];
      collzone^.attachedsubobject := index2;
    end;
end;

procedure collEnableCollZone(index: integer);
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      collzone^.active := TRUE;
    end;
end;

procedure collDisableCollZone(index: integer);
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      collzone^.active := FALSE;
    end else MessageBox(0,pchar('collDisableCollZone('+inttostr(index)+') érvénytelen index!'),ERRORDLG_BASE_TITLE,MB_OK or MB_ICONSTOP or MB_APPLMODAL);
end;

function collZoneIsActive(index: integer): boolean;
begin
  if ( (index < collzones.Count) and assigned(collzones[index]) ) then
    begin
      collzone := collzones[index];
      result := collzone^.active;
    end
   else result := FALSE; 
end;

{
  megmondja, hogy adott pozíciójú és méretû tárgy ütközik-e
  ütközési zónával, és ha igen, result = az ütközõ zóna indexe,
  különben result = -1
}
function collIsAreaInZone(px,py,pz,sx,sy,sz: single; playerind: integer): integer; overload;
var
  i,ind: integer;
  l: boolean;
begin
  l := FALSE;
  i := -1;
  ind := -1;
  while ( not(l) and (i < collzones.Count-1) ) do
    begin
      i := i+1;
      collzone := collzones[i];
      if ( assigned(collzone) and collzone^.active ) then
        begin
          if (
              ( (collzone^.posx-collzone^.sizex/2 <= px+sx/2) and (collzone^.posx+collzone^.sizex/2 >= px-sx/2) )
                                      and
              ( (collzone^.posy-collzone^.sizey/2 <= py+sy/2) and (collzone^.posy+collzone^.sizey/2 >= py-sy/2) )
                                      and
              ( (collzone^.posz-collzone^.sizez/2 <= pz+sz/2) and (collzone^.posz+collzone^.sizez/2 >= pz-sz/2) )
             )
           then
            begin
              l := TRUE;
              ind := i;
            end;
        end;
    end;
  result := ind;
end;

{
  megmondja, hogy adott pozíciójú és méretû tárgy ütközik-e
  ütközési zónával, és ha igen, result = az ütközõ zóna indexe,
  különben result = -1
  a vizsgálatot a start-adik zónától kezdi
}
function collIsAreaInZone(px,py,pz,sx,sy,sz: single; start: integer; playerind: integer): integer; overload;
var
  i,ind: integer;
  l: boolean;
begin
  l := FALSE;
  i := start-1;
  ind := -1;
  while ( not(l) and (i < collzones.Count-1) ) do
    begin
      i := i+1;
      collzone := collzones[i];
      if ( assigned(collzone) and collzone^.active ) then
        begin
          if (
            ( (collzone^.posx-collzone^.sizex/2 <= px+sx/2) and (collzone^.posx+collzone^.sizex/2 >= px-sx/2) )
                                    and
            ( (collzone^.posy-collzone^.sizey/2 <= py+sy/2) and (collzone^.posy+collzone^.sizey/2 >= py-sy/2) )
                                    and
            ( (collzone^.posz-collzone^.sizez/2 <= pz+sz/2) and (collzone^.posz+collzone^.sizez/2 >= pz-sz/2) )
           )
         then
          begin
            l := TRUE;
            ind := i;
          end;
        end;
    end;
  result := ind;
end;

function collSlopeGetYCoord(collzone: PCollisionZone; px,py,pz,sx,sy,sz: single; playerind: integer): single; overload;
var
  start,actsize,tgalpha,height: single;
begin
  if ( assigned(collzone) ) then
  case collzone^.typ3 of
    ctSlopeN : begin
                 start := collzone^.posz - collzone^.sizez/2;
                 actsize := (pz-sz/2)-start;
                 tgalpha := collzone^.sizey / collzone^.sizez;
                 height := tgalpha * actsize;
                 if ( playerind = -1 ) then result := collzone^.posy - collzone^.sizey/2 + height + sy/2
                   else result := collzone^.posy - collzone^.sizey/2 + height + sy/2 + 0.8;
               end;
    ctSlopeS : begin
                 start := collzone^.posz + collzone^.sizez/2;
                 actsize := start-(pz+sz/2);
                 tgalpha := collzone^.sizey / collzone^.sizez;
                 height := tgalpha * actsize;
                 if ( playerind = -1 ) then result := collzone^.posy - collzone^.sizey/2 + height + sy/2
                   else result := collzone^.posy - collzone^.sizey/2 + height + sy/2 + 0.8;
               end;
    ctSlopeW : begin
                 start := collzone^.posx + collzone^.sizex/2;
                 actsize := start-(px+sx/2);
                 tgalpha := collzone^.sizey / collzone^.sizex;
                 height := tgalpha * actsize;
                 if ( playerind = -1 ) then result := collzone^.posy - collzone^.sizey/2 + height + sy/2
                   else result := collzone^.posy - collzone^.sizey/2 + height + sy/2 + 0.8;
               end;
    ctSlopeE : begin
                 start := collzone^.posx - collzone^.sizex/2;
                 actsize := (px-sx/2)-start;
                 tgalpha := collzone^.sizey / collzone^.sizex;
                 height := tgalpha * actsize;
                 if ( playerind = -1 ) then result := collzone^.posy - collzone^.sizey/2 + height + sy/2
                   else result := collzone^.posy - collzone^.sizey/2 + height + sy/2 + 0.8;
               end;
  end;
end;

function collSlopeGetYCoord(collzone: integer; px,py,pz,sx,sy,sz: single; playerind: integer): single; overload;
begin
  if ( collzone <= collzones.Count-1 ) then
    begin
      result := collslopegetycoord(collzones[collzone],px,py,pz,sx,sy,sz,playerind);
    end;
end;

function  collSlopeGetAngle(cz: integer): single;
var
  start,actsize: single;
  sinalpha: single;
begin
  if ( cz <= collzones.Count-1 ) then
    begin
      collzone := collzones[cz];
      if ( assigned(collzone) ) then
      case collzone^.typ3 of
        ctSlopeN : begin
                     start := collzone^.posz - collzone^.sizez/2;
                     sinalpha := collzone^.sizez / sqrt( sqr(collzone^.sizez)+sqr(collzone^.sizey) );
                     result := radtodeg(arccos(sinalpha));
                   end;
        ctSlopeS : begin
                     start := collzone^.posz + collzone^.sizez/2;
                     sinalpha := collzone^.sizez / sqrt( sqr(collzone^.sizez)+sqr(collzone^.sizey) );
                     result := radtodeg(arccos(sinalpha));
                   end;
        ctSlopeW : begin
                     start := collzone^.posx + collzone^.sizex/2;
                     sinalpha := collzone^.sizex / sqrt( sqr(collzone^.sizex)+sqr(collzone^.sizey) );
                     result := radtodeg(arccos(sinalpha));
                   end;
        ctSlopeE : begin
                     start := collzone^.posx - collzone^.sizex/2;
                     sinalpha := collzone^.sizex / sqrt( sqr(collzone^.sizex)+sqr(collzone^.sizey) );
                     result := radtodeg(arccos(sinalpha));
                   end;
      end;
    end;
end;


{
  megmondja, h adott pozíciójú és méretû tárgy valóban ütközik-e adott zónával
  (ha a tárgy a zónát befoglaló téglatesten belül van, akkor kell futtatni,
   tehát ha collIsAreaInZone() értéke igaz, akkor ez a vizsgálat)
  ha a zóna típusa ctBox, igazat fog visszaadni, mert a függvény feltételezi,
  hogy csak úgy lett meghívva index paraméterrel, hogy a collIsAreaInZone()
  értéke index volt.
}
function collTestBoxCollisionAgainstZone(px,py,pz,sx,sy,sz: single; index: integer; playerind: integer): boolean;
var
  dist: single;
  min: single;
  i: byte;
  a: array[1..8] of single;
begin
  if ( index < collzones.Count ) then
    begin
      collzone := collzones[index];
      if ( assigned(collzone) ) then
      case collzone^.typ3 of
        ctBox        : begin
                         result := TRUE;
                       end;
        ctSpherical  : begin
                         dist := sqrt( sqr(px-collzone^.posx) + sqr(py-collzone^.posy) + sqr(pz-collzone^.posz) );
                         a[1] := sqrt( sqr((px-sx/2)-collzone^.posx) + sqr((py-sy/2)-collzone^.posy) + sqr((pz-sz/2)-collzone^.posz) );
                         a[2] := sqrt( sqr((px-sx/2)-collzone^.posx) + sqr((py+sy/2)-collzone^.posy) + sqr((pz-sz/2)-collzone^.posz) );
                         a[3] := sqrt( sqr((px+sx/2)-collzone^.posx) + sqr((py-sy/2)-collzone^.posy) + sqr((pz-sz/2)-collzone^.posz) );
                         a[4] := sqrt( sqr((px+sx/2)-collzone^.posx) + sqr((py+sy/2)-collzone^.posy) + sqr((pz-sz/2)-collzone^.posz) );
                         a[5] := sqrt( sqr((px-sx/2)-collzone^.posx) + sqr((py-sy/2)-collzone^.posy) + sqr((pz+sz/2)-collzone^.posz) );
                         a[6] := sqrt( sqr((px-sx/2)-collzone^.posx) + sqr((py+sy/2)-collzone^.posy) + sqr((pz+sz/2)-collzone^.posz) );
                         a[7] := sqrt( sqr((px+sx/2)-collzone^.posx) + sqr((py+sy/2)-collzone^.posy) + sqr((pz+sz/2)-collzone^.posz) );
                         a[8] := sqrt( sqr((px+sx/2)-collzone^.posx) + sqr((py-sy/2)-collzone^.posy) + sqr((pz+sz/2)-collzone^.posz) );
                         min := a[1];
                         for i := 2 to 8 do
                           if ( a[i] < min ) then min := a[i];
                         result := ( min <= sqrt(sqr(collzone^.sizex/2)+sqr(collzone^.sizey/2)+sqr(collzone^.sizez/2)) );
                       end;
        ctCylindrical: begin
                         dist := sqrt( sqr(px-collzone^.posx) + sqr(pz-collzone^.posz) );
                         result := ( (dist <= collzone^.sizex/2+sx/2) and (collzone^.posy-collzone^.sizey/2 <= py+sy/2)
                                     and (collzone^.posy+collzone^.sizey/2 >= py-sy/2) );
                       end;
        ctSlopeN     : begin
                         result := collSlopeGetYCoord(collzone,px,py,pz,sx,sy,sz,playerind) >= py-sy/2;
                       end;
        ctSlopeS     : begin
                         result := collSlopeGetYCoord(collzone,px,py,pz,sx,sy,sz,playerind) >= py-sy/2;
                       end;
        ctSlopeW     : begin
                         result := collSlopeGetYCoord(collzone,px,py,pz,sx,sy,sz,playerind) >= py-sy/2;
                       end;
        ctSlopeE     : begin
                         result := collSlopeGetYCoord(collzone,px,py,pz,sx,sy,sz,playerind) >= py-sy/2;
                       end;
      end;
    end;
end;

procedure collCreateZonesForObject(index: integer);
var
  i,ind: integer;
  buffer: string;
  typ3: TCollisionType;
  scaling: single;
begin
  scaling := 100/tmcsGetScaling(index);
  for i := 0 to tmcsGetNumSubObjects(index)-1 do
    begin
      buffer := tmcsGetSubName(index,i);
      typ3 := ctNone;
      if ( pos('b_',buffer) = 1 ) then typ3 := ctBox
        else if ( pos('c_',buffer) = 1 ) then typ3 := ctCylindrical
          else if ( pos('s_',buffer) = 1 ) then typ3 := ctSpherical
            else if ( pos('sn_',buffer) = 1 ) then typ3 := ctSlopeN
              else if ( pos('ss_',buffer) = 1 ) then typ3 := ctSlopeS
                else if ( pos('sw_',buffer) = 1 ) then typ3 := ctSlopeW
                  else if ( pos('se_',buffer) = 1 ) then typ3 := ctSlopeE;
      if ( typ3 <> ctNone ) then
        begin
          if ( pos('mov_',buffer) > 0 ) then
            begin
            end
           else
            begin
              ind := collCreateZone(tmcsGetSubXPos(index,i) / scaling,tmcsGetSubYPos(index,i) / scaling,tmcsGetSubZPos(index,i) / -scaling,
                             tmcsGetSubSizeX(index,i) / scaling,tmcsGetSubSizeY(index,i) / scaling,tmcsGetSubSizeZ(index,i) / scaling,
                             typ3,index);
              collSetAttachedSubObject(ind,i);
            end;
        end;
    end;
end;

procedure collDeleteZone(index: integer);
begin
  if ( index < collzones.Count ) then
    begin
      if ( assigned( collzones[index] ) ) then
        begin
          dispose( collzones[index] );
          collzones[index] := nil;
        end;
    end;
end;

procedure collFlush;
var
  i: integer;
begin
  for i := 0 to collzones.Count-1 do
    collDeleteZone(i);
  collzones.Free;
end;

end.
