unit uconfsrv;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;

type

  { Tfrmconfsrv }

  Tfrmconfsrv = class(TForm)
    btnconectar: TBitBtn;
    edthost: TEdit;
    edtpwd: TEdit;
    edtport: TEdit;
    edtuser: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    btnhelp: TSpeedButton;
    Label4: TLabel;
    procedure btnconectarClick(Sender: TObject);
    procedure btnhelpClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    help: integer;
  public

  end;

var
  frmconfsrv: Tfrmconfsrv;

implementation

{$R *.lfm}
uses umodulo, ugerador;

{ Tfrmconfsrv }

procedure Tfrmconfsrv.btnconectarClick(Sender: TObject);
begin
  dm.zHostName := edthost.Text;
  dm.zPort := StrToInt(edtport.Text);
  dm.zUser := edtuser.Text;
  dm.zPassword := edtpwd.Text;
  frmgerador.Show;
  Hide;
end;

procedure Tfrmconfsrv.btnhelpClick(Sender: TObject);
begin
  if help = 0 then
  begin
    edthost.TextHint := '';
    edtport.TextHint := '';
    edtuser.TextHint := '';
    edtpwd.TextHint := '';
    help := 1;
  end
  else
  begin
    edthost.TextHint := 'localhost';
    edtport.TextHint := '3306';
    edtuser.TextHint := 'user';
    edtpwd.TextHint := '12345';
    help := 0;
  end;
end;

procedure Tfrmconfsrv.FormShow(Sender: TObject);
begin
  help := 1;
end;

end.
