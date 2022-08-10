unit uConnectionController;

interface

uses
  FireDAC.Comp.Client, 
  Classes,
  SysUtils,
  System.JSON,
  FireDAC.Phys.PGWrapper, 
  uManifest, 
  FireDac.Stan.Def,
  FireDAC.Phys,
  FireDAC.Phys.IBBase,
  FireDAC.Phys.FB,
  FireDAC.Phys.FBDef,
  FireDAC.Phys.IBWrapper,
  FireDAC.DApt,
  Windows,
  uUtils,
  System.RegularExpressions,
  REST.Client,
  REST.Types,
  StrUtils,
  IdHashMessageDigest,
  DB,
  Vcl.Forms,
  FireDAC.VCLUI.Wait,
  DateUtils,
  FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef;

type
  TDefinicoesExcecao = record
  Suprimido : Boolean;
  Prefixo   : String;
  Sufixo    : String;
end;

type
  TDadosLogin = record
  Login : String;
  Senha : String;
  end;
type
  TController = class
  private
    FConnection           : TFDConnection;
    FHostName             : String;
    FUsername             : String;
    FPassword             : String;
    FDatabase             : String;
    FOSAuthent            : Boolean;
    procedure ConnError(ASender: TObject; AInitiator: TObject; var AException: Exception);
  published
    property Connection      : TFDConnection  read FConnection write FConnection;
    property Hostname        : String         read FHostName   write FHostName;
    property Username        : String         read FUsername   write FUsername;
    property Password        : String         read FPassword   write FPassword;
    property Database        : String         read FDatabase   write FDatabase;
  public
    constructor Create(AHostname : String = ''; ADatabase : String = ''; AUsername : String = ''; APassword : String = ''; AOSAuthent : Boolean = true);
    destructor Destroy; override;
    function LoadConnection() : String;
    constructor ReloadConfig(AHostname : String = ''; ADatabase : String = ''; AUsername : String = ''; APassword : String = ''; AOSAuthent : Boolean = true);
  end;

var
  Controller : TController;

implementation

{ TController }

constructor TController.Create(AHostname : String = ''; ADatabase : String = ''; AUsername : String = ''; APassword : String = ''; AOSAuthent : Boolean = true);
begin
  FHostname  := AHostname;
  FDatabase  := ADatabase;
  FUsername  := AUsername;
  FPassword  := APassword;
  FOSAuthent := AOSAuthent;

  FConnection                            := TFDConnection.Create(nil);
  FConnection.OnError                    := ConnError;
  FConnection.ResourceOptions.SilentMode := True;
end;

constructor TController.ReloadConfig(AHostname : String = ''; ADatabase : String = ''; AUsername : String = ''; APassword : String = ''; AOSAuthent : Boolean = true);
begin
  FHostname  := AHostname;
  FDatabase  := ADatabase;
  FUsername  := AUsername;
  FPassword  := APassword;
  FOSAuthent := AOSAuthent;
end;

destructor TController.Destroy;
begin
  FreeAndNil(FConnection);
end;

procedure TController.ConnError(ASender: TObject; AInitiator: TObject; var AException: Exception);
var
  oExc: EPgNativeException;
begin
  if AException is EPgNativeException then begin
    oExc := EPgNativeException(AException);
    oExc.Message := 'Por favor no primeiro uso configure a conexão com o banco de dados!';
  end;
end;

function TController.LoadConnection : String;
begin
  try
    FConnection.DriverName := 'MSSQL';
    FConnection.Params.add('DriverID=MSSQL');
    FConnection.Params.add('Server='   + Hostname);
    FConnection.Params.add('Database=' + Database);
    if FOSAuthent then
      FConnection.Params.add('OSAuthent=Yes');
    FConnection.Params.UserName := FUsername;
    FConnection.Params.Password := FPassword;

    if (Database <> EmptyStr) and (Hostname <> EmptyStr) then
      FConnection.Connected := True;
  except
    on e: EPgNativeException do
    begin
      Result := e.Message;
    end;
  end;
end;

{$REGION 'INIT'}
initialization
  Controller := TController.Create(Config.Database.Servidor, Config.Database.Database, Config.Database.Usuario, Config.Database.Senha, Config.Database.AutenticacaoLocal);
  Controller.LoadConnection;

finalization
  FreeAndNil(Controller);
{$ENDREGION}

end.
