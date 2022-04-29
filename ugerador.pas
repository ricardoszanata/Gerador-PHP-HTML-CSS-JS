unit ugerador;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  DBGrids, ComCtrls, strutils;

type

  { Tfrmgerador }

  Tfrmgerador = class(TForm)
    btngeraconexao: TBitBtn;
    btngeraphphtml: TBitBtn;
    btnabrir: TBitBtn;
    dbgDatabase: TDBGrid;
    dbgDatabase1: TDBGrid;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    grpbanco: TGroupBox;
    grptabela: TGroupBox;
    lblcaminho: TLabel;
    lblcaminhocompleto: TLabel;
    TreeView1: TTreeView;
    procedure btnabrirClick(Sender: TObject);
    procedure btngeraconexaoClick(Sender: TObject);
    procedure btngeraphphtmlClick(Sender: TObject);
    procedure dbgDatabaseCellClick(Column: TColumn);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);

  private
    title: string;
    tabela: string;
    col: integer;
    cont: integer;
    campos: string;
    atributo: string;
    post: string;
    parametros: string;
    input: string;
    titulo: string;
    caminho: string;
    pk: string;
    procedure ListaDiretoriosArquivos();
    procedure GetDirectories(Tree: TTreeView; Directory: string;
      Item: TTreeNode; IncludeFiles: boolean);
    procedure geraHTMLHeader();
    procedure geraHTMLMenu();
    procedure geraPHPInsert();
    procedure geraHTMLInsert();
    procedure geraPHPUpdate();
    procedure geraHTMLUpdate();
    procedure geraHTMLFooter();
  public
    phpconexao: TMemo;
    phpheader: TMemo;
    phpmenu: TMemo;
    phpfooter: TMemo;
    phpinsert: TMemo;
    phpupdate: TMemo;
    phpselect: TMemo;
    htmlinsert: TMemo;
    htmlupdate: TMemo;
    htmlselect: TMemo;
  end;

var
  frmgerador: Tfrmgerador;

implementation

{$R *.lfm}
uses umodulo;

{ Tfrmgerador }

procedure Tfrmgerador.geraHTMLHeader();
begin
  phpheader := tmemo.Create(self);
  phpheader.parent := self;
  phpheader.Clear;
  phpheader.WordWrap := False;
  phpheader.Visible := False;
  phpheader.Lines.Add('<!doctype html>');
  phpheader.Lines.Add('<html lang="pt-br">');
  phpheader.Lines.Add('  <head>');
  phpheader.Lines.Add('    <meta charset="utf-8">');
  phpheader.Lines.Add(
    '    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">');
  phpheader.Lines.Add('');
  phpheader.Lines.Add(
    '    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">');
  phpheader.Lines.Add('');
  phpheader.Lines.Add('    <title>Z-' + title + '</title>');
  phpheader.Lines.Add('  </head>');
  phpheader.Lines.Add('  <body>');
  phpheader.Lines.Add('');
  phpheader.Lines.SaveToFile(lblcaminho.Caption + '\zheader.php');
  phpheader.Free;
end;

procedure Tfrmgerador.geraHTMLMenu();
begin

end;

procedure Tfrmgerador.geraPHPInsert();
begin
  phpinsert := tmemo.Create(self);
  phpinsert.parent := self;
  phpinsert.Clear;
  phpinsert.WordWrap := False;
  phpinsert.Visible := False;
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
  phpinsert.Lines.Add('<?php');
  phpinsert.Lines.Add('/*');
  phpinsert.Lines.Add('* Description of ' + dm.qtables.FieldByName(tabela).AsString);
  phpinsert.Lines.Add('* @author ZANATA');
  phpinsert.Lines.Add('*/');
  phpinsert.Lines.Add('require "./zcontrol/zbnc.php";');
  phpinsert.Lines.Add('if ($_SERVER["REQUEST_METHOD"] == "POST") {');
  phpinsert.Lines.Add('$msgerror = null;');
  phpinsert.Lines.Add('if (!empty($_POST)) {');
  phpinsert.Lines.Add('$validacao = true;');
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
    phpinsert.Lines.Add(post);
    input := '';
    {fim da construção da estrutura que receberá o post}
    cont := cont + 1;
  end;
  Delete(campos, length(campos), 1);
  Delete(atributo, length(atributo), 1);
  Delete(parametros, length(parametros), 1);
  phpinsert.Lines.Add('}');
  phpinsert.Lines.Add('if ($validacao) {');
  phpinsert.Lines.Add('$pdo = ZBnc::conectar();');
  phpinsert.Lines.Add('$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);');
  phpinsert.Lines.Add('$sql = "insert into ' +
    dm.qtables.FieldByName(tabela).AsString + '(' + campos + ')values(' +
    parametros + ');";');
  phpinsert.Lines.Add('$prp = $pdo->prepare($sql);');
  phpinsert.Lines.Add('$prp->execute(array(' + atributo + '));');
  phpinsert.Lines.Add('ZBnc::desconectar();');
  phpinsert.Lines.Add('header("Location: smodalidade.php");');
  phpinsert.Lines.Add('}');
  phpinsert.Lines.Add('}');
  phpinsert.Lines.SaveToFile(lblcaminho.Caption + '\zcontrol\zins' + titulo + '.php');
  phpinsert.Free;
end;

procedure Tfrmgerador.geraHTMLInsert();
begin
  htmlinsert := tmemo.Create(self);
  htmlinsert.parent := self;
  htmlinsert.Clear;
  htmlinsert.WordWrap := False;
  htmlinsert.Visible := False;
  input := '';
  cont := 0;
  dm.qcampos.Close;
  dm.qcampos.SQL.Clear;
  dm.qcampos.SQL.Add('select * from ' + dm.qtables.FieldByName(tabela).AsString);
  dm.qcampos.Open;
  col := dm.qcampos.FieldCount;
  titulo := dm.qtables.FieldByName(tabela).AsString;
  {início da construção da parte inicial do HTML}
  htmlinsert.Lines.Add('<?php');
  htmlinsert.Lines.Add('/*');
  htmlinsert.Lines.Add(' * Description of ' + dm.qtables.FieldByName(tabela).AsString);
  htmlinsert.Lines.Add(' *');
  htmlinsert.Lines.Add(' * @author ZANATA');
  htmlinsert.Lines.Add(' */');
  htmlinsert.Lines.Add('require "./zcontrol/zins' + titulo + '.php";');
  htmlinsert.Lines.Add('require "zheader.php";');
  htmlinsert.Lines.Add('require "zmenutopo.php";');
  htmlinsert.Lines.Add('?>');
  htmlinsert.Lines.Add('  <div class="container">');
  htmlinsert.Lines.Add('<h1>CADASTRO DE ' + UpperCase(titulo) + '</h1>');
  htmlinsert.Lines.Add('        <form action="zi' + titulo + '.php" method="POST">');
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
    //htmlinsert.Lines.Add(campos);
    {inicio da construção da estrutura de entrada de dados}
    htmlinsert.Lines.Add(
      '<div class="input-group mb-3 <?php echo!empty($msgerror) ? "ERROR" : ""; ?>">');
    htmlinsert.Lines.Add('    <div class="input-group-prepend">');
    htmlinsert.Lines.Add('        <span class="input-group-text" id="basic-addon1">' +
      UpperCase(input) + '</span>');
    htmlinsert.Lines.Add('    </div>');
    htmlinsert.Lines.Add(
      '	<input type="text" class="form-control" aria-label="Usuário" aria-describedby="basic-addon1" id="'
      + input + '"name="' + input + '" value="<?php echo!empty(' +
      atributo + ') ? ' + atributo + ' : ""; ?>">');
    htmlinsert.Lines.Add('</div>');
    {fim da construção da estrutura de entrada de dados}
    cont := cont + 1;
  end;
  htmlinsert.Lines.Add(
    '		<input type="submit" value="GRAVAR" class="btn btn-outline-dark">');
  htmlinsert.Lines.Add('		<div>');
  htmlinsert.Lines.Add('			<?php if (!empty($msgerror)): ?>');
  htmlinsert.Lines.Add('				<span class="text-danger"><?php echo $msgerror; ?></span>');
  htmlinsert.Lines.Add('			<?php endif; ?>');
  htmlinsert.Lines.Add('		</div>');
  htmlinsert.Lines.Add('    </form>');
  htmlinsert.Lines.Add('    </div>');
  htmlinsert.Lines.Add('<?php');
  htmlinsert.Lines.Add('require "zfooter.php";');
  htmlinsert.Lines.Add('?>');
  htmlinsert.Lines.SaveToFile(lblcaminho.Caption + '\zi' + titulo + '.php');
  htmlinsert.Free;
end;

procedure Tfrmgerador.geraPHPUpdate();
begin
  phpupdate := tmemo.Create(self);
  phpupdate.parent := self;
  phpupdate.Clear;
  phpupdate.WordWrap := False;
  phpupdate.Visible := False;
  campos := '';
  parametros := '';
  atributo := '';
  cont := 0;
  dm.qcampos.Close;
  dm.qcampos.SQL.Clear;
  dm.qcampos.SQL.Add('select * from ' + dm.qtables.FieldByName(tabela).AsString);
  dm.qcampos.Open;
  col := dm.qcampos.FieldCount;
  pk := dm.qtableschemaPKCOLUMN_NAME.AsString;
  {início da construção da parte inicial do PHP}
  phpupdate.Lines.Add('<?php');
  phpupdate.Lines.Add('/*');
  phpupdate.Lines.Add('* Description of ' + dm.qtables.FieldByName(tabela).AsString);
  phpupdate.Lines.Add('* @author ZANATA');
  phpupdate.Lines.Add('*/');
  phpupdate.Lines.Add('require "./zcontrol/zbnc.php";');
  phpupdate.Lines.Add('if ($_SERVER["REQUEST_METHOD"] == "POST") {');
  phpupdate.Lines.Add('$msgerror = null;');
  phpupdate.Lines.Add('if (!empty($_POST)) {');
  phpupdate.Lines.Add('$validacao = true;');
  {fim da construção da parte inicial do PHP}
  while cont < col do
  begin
    input := input + dm.qcampos.Fields.Fields[cont].DisplayLabel;
    input := AnsiReverseString(input);
    Delete(input, length(input), 1);
    Delete(input, length(input), 1);
    Delete(input, length(input), 1);
    input := AnsiReverseString(input);
    campos := campos + dm.qcampos.Fields.Fields[cont].DisplayLabel + '=?,';
    atributo := atributo + '$' + dm.qcampos.Fields.Fields[cont].DisplayLabel + ',';
    parametros := parametros + '?,';
    {inicio da construção da estrutura que receberá o post}
    post := '$' + dm.qcampos.Fields.Fields[cont].DisplayLabel +
      '= mb_strtoupper($_POST["' + input + '"], "utf-8");';
    phpupdate.Lines.Add(post);
    input := '';
    {fim da construção da estrutura que receberá o post}
    cont := cont + 1;
  end;
  Delete(campos, length(campos), 1);
  Delete(atributo, length(atributo), 1);
  Delete(parametros, length(parametros), 1);
  phpupdate.Lines.Add('}');
  phpupdate.Lines.Add('if ($validacao) {');
  phpupdate.Lines.Add('$pdo = ZBnc::conectar();');
  phpupdate.Lines.Add('$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);');
  phpupdate.Lines.Add('$sql = "update ' + dm.qtables.FieldByName(tabela).AsString +
    ' set ' + campos + ' where ' + pk + '=?;";');
  phpupdate.Lines.Add('$prp = $pdo->prepare($sql);');
  phpupdate.Lines.Add('$prp->execute(array(' + atributo + ',$' + pk + '));');
  phpupdate.Lines.Add('ZBnc::desconectar();');
  phpupdate.Lines.Add('header("Location: smodalidade.php");');
  phpupdate.Lines.Add('}');
  phpupdate.Lines.Add('}');
  phpupdate.Lines.SaveToFile(lblcaminho.Caption + '\zcontrol\zupd' + titulo + '.php');
  phpupdate.Free;
end;

procedure Tfrmgerador.geraHTMLUpdate();
begin
  htmlupdate := tmemo.Create(self);
  htmlupdate.parent := self;
  htmlupdate.Clear;
  htmlupdate.WordWrap := False;
  input := '';
  cont := 0;
  dm.qcampos.Close;
  dm.qcampos.SQL.Clear;
  dm.qcampos.SQL.Add('select * from ' + dm.qtables.FieldByName(tabela).AsString);
  dm.qcampos.Open;
  col := dm.qcampos.FieldCount;
  titulo := dm.qtables.FieldByName(tabela).AsString;
  {início da construção da parte inicial do HTML}
  htmlupdate.Lines.Add('<?php');
  htmlupdate.Lines.Add('/*');
  htmlupdate.Lines.Add(' * Description of ' + dm.qtables.FieldByName(tabela).AsString);
  htmlupdate.Lines.Add(' *');
  htmlupdate.Lines.Add(' * @author ZANATA');
  htmlupdate.Lines.Add(' */');
  htmlupdate.Lines.Add('require "./zcontrol/upd' + titulo + '.php";');
  htmlupdate.Lines.Add('require "zheader.php";');
  htmlupdate.Lines.Add('require "zmenutopo.php";');
  htmlupdate.Lines.Add('?>');
  htmlupdate.Lines.Add('  <div class="container">');
  htmlupdate.Lines.Add('<h1>ALTERAÇÃO DE ' + UpperCase(titulo) + '</h1>');
  htmlupdate.Lines.Add('        <form action="zu' + titulo + '.php" method="POST">');
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
    //htmlupdate.Lines.Add(campos);
    {inicio da construção da estrutura de entrada de dados}
    htmlupdate.Lines.Add(
      '<div class="input-group mb-3 <?php echo!empty($msgerror) ? "ERROR" : ""; ?>">');
    htmlupdate.Lines.Add('    <div class="input-group-prepend">');
    htmlupdate.Lines.Add('        <span class="input-group-text" id="basic-addon1">' +
      UpperCase(input) + '</span>');
    htmlupdate.Lines.Add('    </div>');
    htmlupdate.Lines.Add(
      '	<input type="text" class="form-control" aria-label="Usuário" aria-describedby="basic-addon1" id="'
      + input + '"name="' + input + '" value="<?php echo!empty(' +
      atributo + ') ? ' + atributo + ' : ""; ?>">');
    htmlupdate.Lines.Add('</div>');
    {fim da construção da estrutura de entrada de dados}
    cont := cont + 1;
  end;
  htmlupdate.Lines.Add(
    '		<input type="submit" value="GRAVAR" class="btn btn-outline-dark">');
  htmlupdate.Lines.Add('		<div>');
  htmlupdate.Lines.Add('			<?php if (!empty($msgerror)): ?>');
  htmlupdate.Lines.Add('				<span class="text-danger"><?php echo $msgerror; ?></span>');
  htmlupdate.Lines.Add('			<?php endif; ?>');
  htmlupdate.Lines.Add('		</div>');
  htmlupdate.Lines.Add('    </form>');
  htmlupdate.Lines.Add('    </div>');
  htmlupdate.Lines.Add('<?php');
  htmlupdate.Lines.Add('require "zfooter.php";');
  htmlupdate.Lines.Add('?>');
  htmlupdate.Lines.SaveToFile(lblcaminho.Caption + '\zu' + titulo + '.php');
  htmlupdate.Free;
end;

procedure Tfrmgerador.ListaDiretoriosArquivos;
var
  Node: TTreeNode;
  Path: string;
  Dir: string;
begin
  Dir := lblcaminho.Caption;
  Screen.Cursor := crHourGlass;
  TreeView1.Items.BeginUpdate;
  try
    TreeView1.Items.Clear;
    GetDirectories(TreeView1, Dir, nil, True);
  finally
    Screen.Cursor := crDefault;
    TreeView1.Items.EndUpdate;
  end;
end;

procedure Tfrmgerador.GetDirectories(Tree: TTreeView; Directory: string;
  Item: TTreeNode; IncludeFiles: boolean);
var
  SearchRec: TSearchRec;
  ItemTemp: TTreeNode;
  idxImagem: integer;
begin
  idxImagem := -1;
  Tree.Items.BeginUpdate;
  if Directory[Length(Directory)] <> '\' then Directory := Directory + '\';
  if FindFirst(Directory + '*.*', faDirectory, SearchRec) = 0 then
  begin
    repeat
      if (SearchRec.Attr and faDirectory = faDirectory) and
        (SearchRec.Name[1] <> '.') then
      begin
        if (SearchRec.Attr and faDirectory > 0) then
          Item := Tree.Items.AddChild(Item, SearchRec.Name);
        if ((Item.Level = 0) or (Item.Level = 1) or (Item.Level = 2)) then
        begin
          idxImagem := 7;
        end;
        item.ImageIndex := idxImagem;
        ItemTemp := Item.Parent;
        GetDirectories(Tree, Directory + SearchRec.Name, Item, IncludeFiles);
        Item := ItemTemp;
      end
      else if IncludeFiles then
        if SearchRec.Name[1] <> '.' then
          Tree.Items.AddChild(Item, SearchRec.Name);
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;
  Tree.Items.EndUpdate;
end;

procedure Tfrmgerador.btnabrirClick(Sender: TObject);
begin
  if dm.SelectDirectoryDialog1.Execute then
  begin
    lblcaminho.Caption := dm.SelectDirectoryDialog1.FileName;
    caminho := dm.SelectDirectoryDialog1.FileName;
    dm.qdb.Open;
    grpbanco.Enabled := True;
  end;
end;

procedure Tfrmgerador.btngeraconexaoClick(Sender: TObject);
begin
  //criação da conexao
  phpconexao := tmemo.Create(self);
  phpconexao.parent := self;
  phpconexao.Clear;
  phpconexao.WordWrap := False;
  phpconexao.Visible := False;
  phpconexao.Lines.Add('<?php');
  phpconexao.Lines.Add('');
  phpconexao.Lines.Add('/**');
  phpconexao.Lines.Add(' * Description of banco');
  phpconexao.Lines.Add(' *');
  phpconexao.Lines.Add(' * @author ZANATA');
  phpconexao.Lines.Add(' */');
  phpconexao.Lines.Add('class ZBnc {');
  phpconexao.Lines.Add('');
  phpconexao.Lines.Add('    private static $dbName = "' +
    dm.qdbDatabase.AsString + '";');
  phpconexao.Lines.Add('    private static $host = "' + dm.zconexao.HostName + '";');
  phpconexao.Lines.Add('    private static $user = "' + dm.zconexao.User + '";');
  phpconexao.Lines.Add('    private static $pass = "' + dm.zconexao.Password + '";');
  phpconexao.Lines.Add('    private static $cont = null;');
  phpconexao.Lines.Add('');
  phpconexao.Lines.Add('    public function __construct() {');
  phpconexao.Lines.Add('        die("A função Init não é permitido!");');
  phpconexao.Lines.Add('    }');
  phpconexao.Lines.Add('');
  phpconexao.Lines.Add('    public static function conectar() {');
  phpconexao.Lines.Add('        if (null == self::$cont) {');
  phpconexao.Lines.Add('            try {');
  phpconexao.Lines.Add(
    '                self::$cont = new PDO("mysql:host=" . self::$host . "; dbname=" . self::$dbName, self::$user, self::$pass, array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));');
  phpconexao.Lines.Add('            } catch (Exception $ex) {');
  phpconexao.Lines.Add('                die($ex->getMessage());');
  phpconexao.Lines.Add('            }');
  phpconexao.Lines.Add('        }');
  phpconexao.Lines.Add('        return self::$cont;');
  phpconexao.Lines.Add('    }');
  phpconexao.Lines.Add('');
  phpconexao.Lines.Add('    public static function desconectar() {');
  phpconexao.Lines.Add('        self::$cont = null;');
  phpconexao.Lines.Add('    }');
  phpconexao.Lines.Add('');
  phpconexao.Lines.Add('}');

  if not DirectoryExists(lblcaminho.Caption + '\zcontrol') then
  begin
    CreateDir(lblcaminho.Caption + '\zcontrol');
  end;
  phpconexao.Lines.SaveToFile(lblcaminho.Caption + '\zcontrol\zbnc.php');
  phpconexao.Free;
  TreeView1.CleanupInstance;
  TreeView1.Items.Clear;
end;

procedure Tfrmgerador.btngeraphphtmlClick(Sender: TObject);
begin
  //**************************************************************************//
  //criação do cabeçalho

  //**************************************************************************//
  //percorrendo as tabelas
  dm.qtables.First;
  while not dm.qtables.EOF do
  begin
    //**************************************************************************//
    //criação do PHPInsert

    //**************************************************************************//
    //criação do HTMLInsert


    //**************************************************************************//
    //criação do PHPUpdate


    //**************************************************************************//
    //criação do HTMLUpdate


    //**************************************************************************//
    //criação do menu
    phpmenu := tmemo.Create(self);
    phpmenu.parent := self;
    phpmenu.Clear;
    phpmenu.WordWrap := False;
    phpmenu.Visible := False;
    phpmenu.Lines.Add('');
    phpmenu.Lines.Add('<nav class="navbar navbar-expand-lg navbar-light bg-light">');
    phpmenu.Lines.Add('  <div class="container-fluid">');
    phpmenu.Lines.Add('    <a class="navbar-brand" href="#">Logo da Empresa</a>');
    phpmenu.Lines.Add(
      '    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">');
    phpmenu.Lines.Add('      <span class="navbar-toggler-icon"></span>');
    phpmenu.Lines.Add('    </button>');
    phpmenu.Lines.Add(
      '    <div class="collapse navbar-collapse" id="navbarSupportedContent">');
    phpmenu.Lines.Add('      <ul class="navbar-nav me-auto mb-2 mb-lg-0">');
    phpmenu.Lines.Add('        <li class="nav-item">');
    phpmenu.Lines.Add(
      '          <a class="nav-link active" aria-current="page" href="#">Inicial</a>');
    phpmenu.Lines.Add('        </li>');
    phpmenu.Lines.Add('        <li class="nav-item">');
    phpmenu.Lines.Add('          <a class="nav-link" href="#">Link</a>');
    phpmenu.Lines.Add('        </li>');
    phpmenu.Lines.Add('        <li class="nav-item dropdown">');
    phpmenu.Lines.Add(
      '          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">');
    phpmenu.Lines.Add('            Dropdown');
    phpmenu.Lines.Add('          </a>');
    phpmenu.Lines.Add(
      '          <ul class="dropdown-menu" aria-labelledby="navbarDropdown">');
    phpmenu.Lines.Add('            <li><a class="dropdown-item" href="#">Action</a></li>');
    phpmenu.Lines.Add(
      '            <li><a class="dropdown-item" href="#">Another action</a></li>');
    phpmenu.Lines.Add('            <li><hr class="dropdown-divider"></li>');
    phpmenu.Lines.Add(
      '            <li><a class="dropdown-item" href="#">Something else here</a></li>');
    phpmenu.Lines.Add('          </ul>');
    phpmenu.Lines.Add('        </li>');
    phpmenu.Lines.Add('      </ul>');
    phpmenu.Lines.Add('    </div>');
    phpmenu.Lines.Add('  </div>');
    phpmenu.Lines.Add('</nav>');
    phpmenu.Lines.Add('');

    //**************************************************************************//
    //criação os arquivos
    if not DirectoryExists(lblcaminho.Caption) then
    begin
      CreateDir(lblcaminho.Caption);
    end;




    //listar Diretórios e Arquivos
    ListaDiretoriosArquivos();
    dm.qtables.Next;
  end;
  //fim do while que percorre as tabelas
  if not DirectoryExists(lblcaminho.Caption) then
  begin
    CreateDir(lblcaminho.Caption);
  end;
  phpmenu.Lines.SaveToFile(lblcaminho.Caption + '\zmenutopo.php');
  phpmenu.Free;

  //**************************************************************************//
  //criação do rodape
  phpfooter := tmemo.Create(self);
  phpfooter.parent := self;
  phpfooter.Clear;
  phpfooter.WordWrap := False;
  phpfooter.Lines.Add('');
  phpfooter.Lines.Add(
    '  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>');
  phpfooter.Lines.Add(
    '  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js" integrity="sha384-7+zCNj/IqJ95wo16oMtfsKbZ9ccEh31eOz1HGyDuCQ6wgnyJNSYdrPa03rtR1zdB" crossorigin="anonymous"></script>');
  phpfooter.Lines.Add(
    '  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.min.js" integrity="sha384-QJHtvGhmr9XOIpI6YVutG+2QOK9T+ZnN4kzFN1RtK3zEFEIsxhlmWl5/YESvpZ13" crossorigin="anonymous"></script>');
  phpfooter.Lines.Add('  </body>');
  phpfooter.Lines.Add('</html>');
  if not DirectoryExists(lblcaminho.Caption) then
  begin
    CreateDir(lblcaminho.Caption);
  end;
  phpfooter.Lines.SaveToFile(lblcaminho.Caption + '\zfooter.php');
  phpfooter.Free;
end;

procedure Tfrmgerador.dbgDatabaseCellClick(Column: TColumn);
begin
  lblcaminho.Caption := '';
  lblcaminho.Caption := caminho;
  dm.zconexao.Connected := False;
  dm.zconexao.HostName := dm.zcon.HostName;
  dm.zconexao.Port := dm.zcon.Port;
  dm.zconexao.Protocol := dm.zcon.Protocol;
  dm.zconexao.User := dm.zcon.User;
  dm.zconexao.Password := dm.zcon.Password;
  dm.zconexao.Database := dm.qdbDatabase.AsString;
  dm.zconexao.Connected := True;
  dm.zcon1.HostName := dm.zcon.HostName;
  dm.zcon1.Port := dm.zcon.Port;
  dm.zcon1.Protocol := dm.zcon.Protocol;
  dm.zcon1.User := dm.zcon.User;
  dm.zcon1.Password := dm.zcon.Password;
  dm.zcon1.Connected := True;
  dm.qtables.Close;
  dm.qtables.Open;
  tabela := 'Tables_in_' + dm.qdbDatabase.AsString;
  grptabela.Enabled := True;
  title := UpperCase(dm.qdbDatabase.AsString);
  lblcaminho.Caption := lblcaminho.Caption + '\' + dm.qdbDatabase.AsString;
  if not DirectoryExists(lblcaminho.Caption) then
  begin
    CreateDir(lblcaminho.Caption);
  end;
end;

procedure Tfrmgerador.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Application.Terminate;
end;

end.
