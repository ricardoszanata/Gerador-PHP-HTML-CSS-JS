program ZGeradorPHP;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, uconfsrv, umodulo, zcomponent, ugerador
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(Tfrmconfsrv, frmconfsrv);
  Application.CreateForm(Tfrmgerador, frmgerador);
  Application.CreateForm(Tdm, dm);
  Application.Run;
end.

