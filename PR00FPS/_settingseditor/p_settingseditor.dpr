program p_settingseditor;

uses
  Forms,
  u_main in 'u_main.pas' {frm_main},
  u_cfgfile in '..\u_cfgfile.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tfrm_main, frm_main);
  Application.Run;
end.
