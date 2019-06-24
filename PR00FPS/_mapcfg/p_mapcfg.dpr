program p_mapcfg;

uses
  Forms,
  u_main in 'u_main.pas' {frm_main},
  u_about in 'u_about.pas' {frm_about};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'MapCfg';
  Application.CreateForm(Tfrm_main, frm_main);
  Application.CreateForm(Tfrm_about, frm_about);
  Application.Run;
end.
