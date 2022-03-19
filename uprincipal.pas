unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  ZConnection, ZDataset, strutils;

type

  { TForm1 }

  TForm1 = class(TForm)
    DBGrid1: TDBGrid;
    DBGrid2: TDBGrid;
    DBGrid3: TDBGrid;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure DBGrid1CellClick(Column: TColumn);
    procedure DBGrid2CellClick(Column: TColumn);
    procedure GeraPHPI();
    procedure GeraHTMLI();
  private
    tabela: string;
    col: integer;
    cont: integer;
    campos: string;
    atributo: string;
    post: string;
    parametros: string;
    input: string;
    titulo: string;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}
uses umodulo;

{ TForm1 }
procedure TForm1.GeraPHPI();
begin
  Memo1.Clear;
  campos := '';
  parametros := '';
  atributo := '';
  cont := 0;
  dm.qcampos.Close;
  dm.qcampos.SQL.Clear;
  dm.qcampos.SQL.Add('select * from ' + dm.qtables.FieldByName(tabela).AsString);
  dm.qcampos.Open;
  col := dm.qcampos.FieldCount;
  {início da construção da parte inicial do PHP}
  Memo1.Lines.Add('<?php');
  Memo1.Lines.Add('/*');
  Memo1.Lines.Add('* Description of ' + dm.qtables.FieldByName(tabela).AsString);
  Memo1.Lines.Add('* @author ZANATA');
  Memo1.Lines.Add('*/');
  Memo1.Lines.Add('require "./banco.php";');
  Memo1.Lines.Add('if ($_SERVER["REQUEST_METHOD"] == "POST") {');
  Memo1.Lines.Add('$msgerror = null;');
  Memo1.Lines.Add('if (!empty($_POST)) {');
  Memo1.Lines.Add('$validacao = true;');
  {fim da construção da parte inicial do PHP}
  while cont < col do
  begin
    input := input + dm.qcampos.Fields.Fields[cont].DisplayLabel;
    input := AnsiReverseString(input);
    Delete(input, length(input), 1);
    Delete(input, length(input), 1);
    Delete(input, length(input), 1);
    input := AnsiReverseString(input);
    campos := campos + dm.qcampos.Fields.Fields[cont].DisplayLabel + ',';
    atributo := atributo + '$' + dm.qcampos.Fields.Fields[cont].DisplayLabel + ',';
    parametros := parametros + '?,';
    {inicio da construção da estrutura que receberá o post}
    post := '$' + dm.qcampos.Fields.Fields[cont].DisplayLabel +
      '= mb_strtoupper($_POST["' + input + '"], "utf-8");';
    Memo1.Lines.Add(post);
    input := '';
    {fim da construção da estrutura que receberá o post}
    cont := cont + 1;
  end;
  Delete(campos, length(campos), 1);
  Delete(atributo, length(atributo), 1);
  Delete(parametros, length(parametros), 1);
  Memo1.Lines.Add('}');
  Memo1.Lines.Add('if ($validacao) {');
  Memo1.Lines.Add('$pdo = Banco::conectar();');
  Memo1.Lines.Add('$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);');
  Memo1.Lines.Add('$sql = "insert into ' + dm.qtables.FieldByName(tabela).AsString +
    '(' + campos + ')values(' + parametros + ');";');
  Memo1.Lines.Add('$prp = $pdo->prepare($sql);');
  Memo1.Lines.Add('$prp->execute(array(' + atributo + '));');
  Memo1.Lines.Add('Banco::desconectar();');
  Memo1.Lines.Add('header("Location: smodalidade.php");');
  Memo1.Lines.Add('}');
  Memo1.Lines.Add('}');
end;

procedure TForm1.GeraHTMLI();
begin
  Memo2.Clear;
  input := '';
  cont := 0;
  dm.qcampos.Close;
  dm.qcampos.SQL.Clear;
  dm.qcampos.SQL.Add('select * from ' + dm.qtables.FieldByName(tabela).AsString);
  dm.qcampos.Open;
  col := dm.qcampos.FieldCount;
  titulo := dm.qtables.FieldByName(tabela).AsString;
  {início da construção da parte inicial do HTML}
  Memo2.Lines.Add('<?php');
  Memo2.Lines.Add('/*');
  Memo2.Lines.Add(' * Description of ' + dm.qtables.FieldByName(tabela).AsString);
  Memo2.Lines.Add(' *');
  Memo2.Lines.Add(' * @author ZANATA');
  Memo2.Lines.Add(' */');
  Memo2.Lines.Add('require "./zcontrol/ins' + titulo + '.php";');
  Memo2.Lines.Add('?>');
  Memo2.Lines.Add('<!doctype html>');
  Memo2.Lines.Add('<html lang="pt-br">');
  Memo2.Lines.Add('  <head>');
  Memo2.Lines.Add('    <meta charset="utf-8">');
  Memo2.Lines.Add(
    '	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">');
  Memo2.Lines.Add(
    '   <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">');
  Memo2.Lines.Add('    <title>Z-ACADEMIA</title>');
  Memo2.Lines.Add('  </head>');
  Memo2.Lines.Add('  <body>');
  Memo2.Lines.Add('  <div class="container">');
  Memo2.Lines.Add('<h1>CADASTRO DE ' + UpperCase(titulo) + '</h1>');
  Memo2.Lines.Add('        <form action="i' + titulo + '.php" method="POST">');
  {fim da construção da parte inicial do HTML}
  while cont < col do
  begin
    input := '';
    atributo := '';
    input := input + dm.qcampos.Fields.Fields[cont].DisplayLabel;
    input := AnsiReverseString(input);
    Delete(input, length(input), 1);
    Delete(input, length(input), 1);
    Delete(input, length(input), 1);
    input := AnsiReverseString(input);
    atributo := atributo + '$' + dm.qcampos.Fields.Fields[cont].DisplayLabel;
    //Memo2.Lines.Add(campos);
    {inicio da construção da estrutura de entrada de dados}
    Memo2.Lines.Add(
      '<div class="input-group mb-3 <?php echo!empty($msgerror) ? "ERROR" : ""; ?>">');
    Memo2.Lines.Add('    <div class="input-group-prepend">');
    Memo2.Lines.Add('        <span class="input-group-text" id="basic-addon1">' +
      UpperCase(input) + '</span>');
    Memo2.Lines.Add('    </div>');
    Memo2.Lines.Add(
      '	<input type="text" class="form-control" aria-label="Usuário" aria-describedby="basic-addon1" id="'
      + input + '"name="' + input + '" value="<?php echo!empty(' +
      atributo + ') ? ' + atributo + ' : ""; ?>">');
    Memo2.Lines.Add('</div>');
    {fim da construção da estrutura de entrada de dados}
    cont := cont + 1;
  end;
  Memo2.Lines.Add('		<input type="submit" value="GRAVAR" class="btn btn-outline-dark">');
  Memo2.Lines.Add('		<div>');
  Memo2.Lines.Add('			<?php if (!empty($msgerror)): ?>');
  Memo2.Lines.Add('				<span class="text-danger"><?php echo $msgerror; ?></span>');
  Memo2.Lines.Add('			<?php endif; ?>');
  Memo2.Lines.Add('		</div>');
  Memo2.Lines.Add('    </form>');
  Memo2.Lines.Add('    </div>');
  Memo2.Lines.Add(
    '        <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>');
  Memo2.Lines.Add(
    '        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>');
  Memo2.Lines.Add(
    '        <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>');
  Memo2.Lines.Add('    </body>');
  Memo2.Lines.Add('</html>');
end;

procedure TForm1.DBGrid1CellClick(Column: TColumn);
begin
  dm.zconexao.Connected := False;
  dm.zconexao.HostName := dm.zcon.HostName;
  dm.zconexao.Port := dm.zcon.Port;
  dm.zconexao.Protocol := dm.zcon.Protocol;
  dm.zconexao.User := dm.zcon.User;
  dm.zconexao.Password := dm.zcon.Password;
  dm.zconexao.Database := dm.qdbDatabase.AsString;
  dm.zconexao.Connected := True;
  dm.qtables.Close;
  dm.qtables.Open;
  tabela := 'Tables_in_' + dm.qdbDatabase.AsString;

end;

procedure TForm1.DBGrid2CellClick(Column: TColumn);
begin
  GeraPHPI();
  GeraHTMLI();
end;

end.
