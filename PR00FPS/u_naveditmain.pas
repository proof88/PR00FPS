unit u_naveditmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, math, gfxcore, u_collision, u_map, u_cfgfile, u_consts, Spin,
  ExtCtrls;

const MAXELEMENTS = 70;
      ELEMENTWIDTH = 10;
      BOTS_PATH_AREA_SIZE_MULTIPLIER = 1;

type
  TEMATRIX = array[1..maxelements,1..maxelements] of integer;
  TSHPMATRIX = array[1..maxelements,1..maxelements] of tshape;
  TForm1 = class(TForm)
    btn_loadobj: TButton;
    dlg_open: TOpenDialog;
    SpinEdit1: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    SpinEdit2: TSpinEdit;
    ScrollBox1: TScrollBox;
    pnl: TPanel;
    SpinEdit3: TSpinEdit;
    Label3: TLabel;
    btn_savenav: TButton;
    dlg_save: TSaveDialog;
    Label4: TLabel;
    SpinEdit4: TSpinEdit;
    Label5: TLabel;
    SpinEdit5: TSpinEdit;
    Label6: TLabel;
    Label7: TLabel;
    SpinEdit6: TSpinEdit;
    SpinEdit7: TSpinEdit;
    procedure btn_loadobjClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SpinEdit3Change(Sender: TObject);
    procedure btn_savenavClick(Sender: TObject);
    procedure SpinEdit6Change(Sender: TObject);
    procedure SpinEdit7Change(Sender: TObject);
  private
    { Private declarations }
    obj_map: integer;
    obj_bot: integer;
    loadok: boolean;
    cfgsettings: pcfgdata;
    matrix: tematrix;
    shpmatrix: tshpmatrix;
    globalybase: single;
    botsize,botsizey: single;
    basepx,basepz: single;
    bs: integer;
  public
    { Public declarations }
    procedure updateshapes;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btn_loadobjClick(Sender: TObject);
var
  s: string;
  i,j: integer;
  s1,s2: integer;
  perc: integer;
begin
  s := getcurrentdir();
  if ( dlg_open.Execute ) then
    begin
      form1.Caption := 'Forma1 - loading ...';
      if ( obj_map > -1 ) then tmcsdeleteobject(obj_map);
      mapsetmapname(copy(extractfilename(dlg_open.FileName),1,length(extractfilename(dlg_open.FileName))-4));
      setcurrentdir(s);
      obj_map := maploadmap();
      if ( obj_map > -1 ) then
        begin//tmcsCreateObjectFromFile(GAME_PATH_MAPS+map.name+'\'+map.name+'.obj',false);
          if ( maploadcfgfile() ) then
            begin
              mapapplycfgdata();
              collcreatezonesforobject(obj_map);
              spinedit1.minvalue := 0;
              spinedit2.MinValue := 0;
              botsize := max(tmcsgetsizex(obj_bot),tmcsgetsizez(obj_bot)) / (100/BOTS_SNAIL_SCALE);
              botsizey := tmcsgetsizey(obj_bot) / (100/BOTS_SNAIL_SCALE);
              s1 := round( mapgetsizex() / botsize );
              s2 := round( mapgetsizez() / botsize );
              globalybase := 0.0;
              bs := max(s1,s2) + 8;
              if ( bs > MAXELEMENTS ) then bs := MAXELEMENTS;
              spinedit1.MinValue := bs;
              spinedit2.MinValue := bs;
              spinedit1.MaxValue := bs;
              spinedit2.MaxValue := bs;
              spinedit1.Value := bs;
              spinedit2.Value := bs;
              for i := 1 to bs do
                for j := 1 to bs do
                  if ( assigned(shpmatrix[i,j]) ) then shpmatrix[i,j].Free;
              pnl.Width := bs*ELEMENTWIDTH;
              pnl.Height := pnl.Width;
              perc := 0;
              for i := 1 to bs do
                begin
                  for j := 1 to bs do
                    begin
                      perc := perc+1;
                      shpmatrix[i,j] := tshape.Create(pnl);
                      with shpmatrix[i,j] do
                        begin
                          width := ELEMENTWIDTH;
                          height := width;
                          left := j*width - width-j;
                          top := i*height - height-i;
                          parent := pnl;
                        end;
                    end;
                  form1.Caption := 'Forma1 - loading ... ('+floattostr(roundto((perc / (bs*bs))*100,-2))+'%)';
                end;
              updateshapes;
            end
           else
            begin
              showmessage('map cfg data couldnt be loaded');
              tmcsdeleteobject(obj_map);
            end;
        end
       else showmessage('map couldnt be loaded');
    end;
  form1.Caption := 'Forma1';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  //forcecurrentdirectory := true;
  loadok := false;
  if ( cfgfileexists() ) then
    begin
      cfgallocbuffer();
      cfgreadintobuffer();
      cfgsettings := cfggetpointertobuffer();
      cfgsettings^.video_lightmaps := false; // ne töltse be a map unit a lightmapot
      cfgsettings^.video_simpleitems := false;
      collinitialize();
      if ( tmcsInitGraphix(form1.Handle,false,255,16,16,false,gl_smooth) = 0 ) then
        begin
          tmcsSetviewport(0,0,320,240);
          tmcsinitcamera(0,0,0,0,0,0,45,4/3,0.1,100.0);
          obj_map := -1;
          basepx := 0.0;
          basepz := 0.0;
          obj_bot := tmcscreateobjectfromfile(game_path_bots+'snail.obj',false);
          pnl.DoubleBuffered := true;
          loadok := true;
        end
       else
        begin
          collflush();
          cfgflushbuffer();
          showmessage('error: gfx subsystem couldnt be initialized. the program wont work properly');
        end;
    end
   else
    begin
      showmessage('warning: cfg file doesnt exist so the program will not work properly');
    end;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ( loadok ) then
    begin
      tmcsshutdowngraphix();
      collflush();
      cfgflushbuffer();
    end;
end;

procedure TForm1.updateshapes;
var
  i,j: integer;
  colliding: integer;
  area_x,area_z: single;
begin
  form1.Caption := 'Forma1 - updating ...';
  for i := 1 to bs do
    begin
      for j := 1 to bs do
        begin
          area_x := basepx + (-((bs div 2)+1)+j)*botsize*BOTS_PATH_AREA_SIZE_MULTIPLIER;
          area_z := basepz + (-((bs div 2)+1)+i)*botsize*BOTS_PATH_AREA_SIZE_MULTIPLIER;
          colliding := collIsAreaInZone(area_x,globalybase,area_z,botsize*BOTS_PATH_AREA_SIZE_MULTIPLIER,botsizey,botsize*BOTS_PATH_AREA_SIZE_MULTIPLIER,-1);
          if( (colliding > -1) and (collgetattachedobject(colliding) = mapGetObjectNum()) ) then
            begin
              if ( collTestBoxCollisionAgainstZone(area_x,globalybase,area_z,botsize*BOTS_PATH_AREA_SIZE_MULTIPLIER,botsizey,botsize*BOTS_PATH_AREA_SIZE_MULTIPLIER,colliding,-1) ) then
                begin
                  if ( collgetzonetype(colliding) in [ctBox,ctCylindrical] ) then
                    begin
                      shpmatrix[bs+1-i,j].Brush.Color := clred;
                      matrix[bs+1-i,j] := 1;
                    end
                   else
                    begin
                      if (
                           (area_x <= -mapgetsizex()/2) or (area_x >= mapgetsizex()/2)
                                                        or
                           (area_z <= -mapgetsizez()/2) or (area_z >= mapgetsizez()/2)
                         ) then begin
                                  shpmatrix[bs+1-i,j].Brush.Color := clred;
                                  matrix[bs+1-i,j] := 1;
                                end
                             else
                               begin
                                 shpmatrix[bs+1-i,j].Brush.Color := clgreen;
                                 matrix[bs+1-i,j] := 0;
                               end;
                    end;
                end
               else
                begin
                  if (
                           (area_x <= -mapgetsizex()/2) or (area_x >= mapgetsizex()/2)
                                                        or
                           (area_z <= -mapgetsizez()/2) or (area_z >= mapgetsizez()/2)
                         ) then begin
                                  shpmatrix[bs+1-i,j].Brush.Color := clred;
                                  matrix[bs+1-i,j] := 1;
                                end
                             else
                               begin
                                 shpmatrix[bs+1-i,j].Brush.Color := clgreen;
                                 matrix[bs+1-i,j] := 0;
                               end;
                end;
            end
           else
            begin
              if (
                           (area_x <= -mapgetsizex()/2) or (area_x >= mapgetsizex()/2)
                                                        or
                           (area_z <= -mapgetsizez()/2) or (area_z >= mapgetsizez()/2)
                         ) then begin
                                  shpmatrix[bs+1-i,j].Brush.Color := clred;
                                  matrix[bs+1-i,j] := 1;
                                end
                             else
                               begin
                                 shpmatrix[bs+1-i,j].Brush.Color := clgreen;
                                 matrix[bs+1-i,j] := 0;
                               end;
            end;
        end;
    end;
  form1.Caption := 'Forma1';
end;

procedure TForm1.SpinEdit3Change(Sender: TObject);
begin
  globalybase := spinedit3.Value;
  updateshapes;
end;

procedure TForm1.btn_savenavClick(Sender: TObject);
var
  f: cardinal;
  byteswritten,bytesread: cardinal;
  i,j: integer;
  s: cardinal;
  header: array[0..2] of char;
  count: integer;
  starty: integer;
begin
  if ( loadok and (dlg_open.FileName <> '') ) then
    begin
      if ( dlg_save.Execute ) then
        begin
          f := createfile(pchar(dlg_save.Filename+'.nav'),GENERIC_WRITE,0,nil,
                          CREATE_ALWAYS,FILE_ATTRIBUTE_NORMAL,0);
          writefile(f,'NAV',3,byteswritten,nil);
          count := spinedit5.value-spinedit4.value + 1;
          starty := spinedit4.Value;
          writefile(f,count,sizeof(count),byteswritten,nil);
          writefile(f,starty,sizeof(starty),byteswritten,nil);
          writefile(f,basepx,sizeof(basepx),byteswritten,nil);
          writefile(f,basepz,sizeof(basepz),byteswritten,nil);
          writefile(f,bs,sizeof(bs),byteswritten,nil);
          writefile(f,botsize,sizeof(botsize),byteswritten,nil);
          s := 3+sizeof(count)+sizeof(starty)+sizeof(basepx)+sizeof(basepz)+sizeof(bs)+sizeof(botsize);
          for i := spinedit4.Value to spinedit5.Value do
            begin
              globalybase := i;
              updateshapes;
              writefile(f,matrix,sizeof(matrix),byteswritten,nil);
              s := s+sizeof(matrix);
            end;
          if ( windows.getfilesize(f,nil) <> s) then showmessage('error while saving data');
          closehandle(f);
          // read back
          f := createfile(pchar(dlg_save.Filename+'.nav'),GENERIC_READ,0,nil,
                          open_existing,FILE_ATTRIBUTE_NORMAL,0);
          readfile(f,header,3,bytesread,nil);
          count := 0;
          if ( header = 'NAV' ) then
            begin
              readfile(f,count,sizeof(count),bytesread,nil);
              readfile(f,starty,sizeof(starty),bytesread,nil);
              readfile(f,basepx,sizeof(basepx),bytesread,nil);
              readfile(f,basepz,sizeof(basepz),bytesread,nil);
              readfile(f,bs,sizeof(bs),bytesread,nil);
              readfile(f,botsize,sizeof(botsize),bytesread,nil);
              spinedit3.Value := round(starty-1);
              for i := 1 to count do
                begin
                  globalybase := starty;
                  readfile(f,matrix,sizeof(matrix),bytesread,nil);
                  spinedit3.Value := spinedit3.Value + 1;
                end;
            end
           else showmessage('failed reading saved data'); 
          closehandle(f);
        end;
    end;
end;

procedure TForm1.SpinEdit6Change(Sender: TObject);
begin
  basepx := spinedit6.value;
  updateshapes;
end;

procedure TForm1.SpinEdit7Change(Sender: TObject);
begin
  basepz := spinedit7.value;
  updateshapes;
end;

end.
