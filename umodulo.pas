unit umodulo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, Dialogs, ZConnection, ZDataset, DB;

type

  { Tdm }

  Tdm = class(TDataModule)
    dscampos: TDataSource;
    dsdb: TDataSource;
    dstables: TDataSource;
    dstableschemaPK: TDataSource;
    dstableschemaFK: TDataSource;
    ImageList1: TImageList;
    qcampos: TZQuery;
    qdb: TZQuery;
    qdbDatabase: TStringField;
    qtables: TZQuery;
    qtableschemaPK: TZQuery;
    qtableschemaFK: TZQuery;
    qtableschemaPKCHARACTER_MAXIMUM_LENGTH: TLargeintField;
    qtableschemaPKCHARACTER_MAXIMUM_LENGTH1: TLargeintField;
    qtableschemaPKCHARACTER_OCTET_LENGTH: TLargeintField;
    qtableschemaPKCHARACTER_OCTET_LENGTH1: TLargeintField;
    qtableschemaPKCHARACTER_SET_NAME: TStringField;
    qtableschemaPKCHARACTER_SET_NAME1: TStringField;
    qtableschemaPKCOLLATION_NAME: TStringField;
    qtableschemaPKCOLLATION_NAME1: TStringField;
    qtableschemaPKCOLUMN_COMMENT: TStringField;
    qtableschemaPKCOLUMN_COMMENT1: TStringField;
    qtableschemaPKCOLUMN_DEFAULT: TMemoField;
    qtableschemaPKCOLUMN_DEFAULT1: TMemoField;
    qtableschemaPKCOLUMN_KEY: TStringField;
    qtableschemaPKCOLUMN_KEY1: TStringField;
    qtableschemaPKCOLUMN_NAME: TStringField;
    qtableschemaPKCOLUMN_NAME1: TStringField;
    qtableschemaPKCOLUMN_TYPE: TMemoField;
    qtableschemaPKCOLUMN_TYPE1: TMemoField;
    qtableschemaPKDATA_TYPE: TStringField;
    qtableschemaPKDATA_TYPE1: TStringField;
    qtableschemaPKDATETIME_PRECISION: TLargeintField;
    qtableschemaPKDATETIME_PRECISION1: TLargeintField;
    qtableschemaPKEXTRA: TStringField;
    qtableschemaPKEXTRA1: TStringField;
    qtableschemaPKGENERATION_EXPRESSION: TMemoField;
    qtableschemaPKGENERATION_EXPRESSION1: TMemoField;
    qtableschemaPKIS_GENERATED: TStringField;
    qtableschemaPKIS_GENERATED1: TStringField;
    qtableschemaPKIS_NULLABLE: TStringField;
    qtableschemaPKIS_NULLABLE1: TStringField;
    qtableschemaPKNUMERIC_PRECISION: TLargeintField;
    qtableschemaPKNUMERIC_PRECISION1: TLargeintField;
    qtableschemaPKNUMERIC_SCALE: TLargeintField;
    qtableschemaPKNUMERIC_SCALE1: TLargeintField;
    qtableschemaPKORDINAL_POSITION: TLargeintField;
    qtableschemaPKORDINAL_POSITION1: TLargeintField;
    qtableschemaPKPRIVILEGES: TStringField;
    qtableschemaPKPRIVILEGES1: TStringField;
    qtableschemaPKTABLE_CATALOG: TStringField;
    qtableschemaPKTABLE_CATALOG1: TStringField;
    qtableschemaPKTABLE_NAME: TStringField;
    qtableschemaPKTABLE_NAME1: TStringField;
    qtableschemaPKTABLE_SCHEMA: TStringField;
    qtableschemaPKTABLE_SCHEMA1: TStringField;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    zcon: TZConnection;
    zcon1: TZConnection;
    zconexao: TZConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure zconBeforeConnect(Sender: TObject);
  private

  public
    zHostName: string;
    zPort: integer;
    zUser: string;
    zPassword: string;
    zvalida: boolean;
  end;

var
  dm: Tdm;

implementation

{$R *.lfm}

{ Tdm }

procedure Tdm.zconBeforeConnect(Sender: TObject);
begin
  zcon.HostName := zHostName;
  zcon.Port := zPort;
  zcon.User := zUser;
  zcon.Password := zPassword;
  zvalida := True;
end;

procedure Tdm.DataModuleCreate(Sender: TObject);
begin
  if zvalida then
  begin
    zcon.Connected := True;
  end;
end;

end.
