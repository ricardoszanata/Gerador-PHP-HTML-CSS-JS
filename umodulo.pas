unit umodulo;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset, DB;

type

  { Tdm }

  Tdm = class(TDataModule)
    dscampos: TDataSource;
    dstables: TDataSource;
    dsdb: TDataSource;
    qdb: TZQuery;
    qdbDatabase: TStringField;
    zcon: TZConnection;
    zconexao: TZConnection;
    qtables: TZQuery;
    qcampos: TZQuery;
  private

  public

  end;

var
  dm: Tdm;

implementation

{$R *.lfm}

end.

