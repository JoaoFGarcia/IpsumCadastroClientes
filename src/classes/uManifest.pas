unit uManifest;

interface

uses
  REST.Json,
  REST.Json.Types,
  System.Classes,
  SysUtils,
  JSON,
  System.TypInfo,
  StrUtils;

type
  TConfigDatabase = class
  private
    FServidor          : String;
    FDatabase          : String;
    FUsuario           : String;
    FSenha             : String;
    FAutenticacaoLocal : Boolean;
  published
    property Servidor          : String  read FServidor          write FServidor;
    property Database          : String  read FDatabase          write FDatabase;
    property Usuario           : String  read FUsuario           write FUsuario;
    property Senha             : String  read FSenha             write FSenha;
    property AutenticacaoLocal : Boolean read FAutenticacaoLocal write FAutenticacaoLocal;
  public
    constructor Create(AServidor : String; ADataBase : String; AUsuario : String; ASenha : String; AAutenticacaoLocal : Boolean);
  end;

type
  TConfig = class(TObject)
  private
    FDatabase         : TConfigDatabase;
    [JSONMarshalled(False)]
    Arquivo           : String;
  published
    property Database : TConfigDatabase read FDatabase write FDatabase;
  public
    procedure Carregar;
    procedure Salvar(Caminho : String = '');
    constructor Create(const Arquivo : String);
  end;

var
  Config : TConfig;

implementation

{ Configuracao }

procedure TConfig.Carregar;
var
  vConteudo    : TStrings;
  jObj         : TJsonObject;
label
  lInitialize;
begin
  vConteudo := TStringList.Create;
  try
    try
      if not FileExists(Arquivo) then
        goto lInitialize;

      vConteudo.LoadFromFile(Arquivo);

      if not vConteudo.Text.StartsWith('{') then vConteudo.Text := vConteudo[0];

      jObj := TJsonObject.ParseJSONValue(vConteudo.Text) as TJsonObject;
      TJson.JsonToObject(Self, jObj,  [joIndentCaseLower]);

      lInitialize:
      if not Assigned(FDatabase) then
      begin
        Self.FDatabase := TConfigDatabase.Create('DESKTOP-HRKFL1T\SQLEXPRESS', 'ipsum', 'DESKTOP-HRKFL1T\joao.garcia', 'sw2de3', True);
        Self.Salvar();
      end;
    finally
      if Assigned(vConteudo) then
        FreeAndNil(vConteudo);
    end;
  except
    on E: Exception
    do begin
      raise Exception.Create('Ocorreu um erro ao salvar o arquivo de configuração: ' + E.Message);
    end;
  end;
end;

constructor TConfig.Create(const Arquivo : String);
begin
  Self.Arquivo          := Arquivo;
  Carregar;
end;

procedure TConfig.Salvar(Caminho : String = '');
var
  vConteudo : TStrings;
  sLine     : String;
begin
  vConteudo := TStringList.Create;
  try
    vConteudo.Text := (StringReplace((TJson.ObjectToJsonObject(Self, [joIndentCaseLower]).ToString), '\/', '/', [rfReplaceAll]));
    vConteudo.SaveToFile(IfThen(Caminho <> '', Caminho, Arquivo));
  finally
    FreeAndNil(vConteudo);
  end;
end;

{ TConfigDatabase }

constructor TConfigDatabase.Create(AServidor : String; ADataBase : String; AUsuario : String; ASenha : String; AAutenticacaoLocal : Boolean);
begin
  FServidor          := AServidor;
  FDatabase          := ADataBase;
  FUsuario           := AUsuario;
  FSenha             := ASenha;
  FAutenticacaoLocal := AAutenticacaoLocal;
end;

initialization
  Config := TConfig.Create(ExtractFilePath(ParamStr(0)) + 'conf.json')

finalization
  FreeAndNil(Config);

end.
