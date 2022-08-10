unit uModelo;

interface

uses
  Classes,
  SysUtils,
  System.Rtti;

type
  Filtrar = class(TCustomAttribute)
  type
  private
    FCampo : String;
    FValor : String;
  published
    property Valor : String read FValor write FValor;
    property Campo : String read FCampo write FCampo;
  public
    constructor Create(ACampo : String; AFiltro : String);
  end;

type
  Ordenar = class(TCustomAttribute)
  type
  private
    FValor : String;
  published
    property Valor : String read FValor write FValor;
  public
    constructor Create(AOrdenacao : String);
  end;

type
  Tabela = class(TCustomAttribute)
  private
    FName      : String;
    FVirtual   : Boolean;
    FOrder : String;
  published
    property Name      : String read FName write FName;
    property IsVirtual : Boolean read FVirtual write FVirtual;
    property Order     : String read FOrder write FOrder;
  public
    constructor Create(const Name: string; AOrder : String = ''; AVirtual : Boolean = False);
  end;

type
  TTipoCampo    = (dbKey, dbUpdate, dbForeign, dbForeignWhere, dbForeignList, dbVirtual, dbTernaryUpdate);
  TTiposCampo   = set of TTipoCampo;
  Campo = class(TCustomAttribute)
  private
    FDescricao             : string;
    FCampoIntegrado        : String;
    FPodeSerVazio          : Boolean;
    FTipos                 : TTiposCampo;
    FTabelaEstrangeira     : String;
    FCampoLocal            : String;
    FCampoEstrangeiro      : String;
    FPseudominoEstrangeiro : String;
    FOrdenacao             : String;
  public
    constructor Create(const Description: string; Types: TTiposCampo; const CanBeEmpty: Boolean = True; const ForeignAlias : String = ''; const ForeignTable : String = ''; const LocalField: String = ''; const ForeignField : String = ''; CampoIntegrado : String = ''; Ordenacao : String = ''); overload;
    destructor  Destroy(); override;
    property Description : string   read FDescricao;
    property CanBeEmpty  : boolean  read FPodeSerVazio;
    property Tipos       : TTiposCampo read FTipos;
    property ForeignAlias   : string   read FPseudominoEstrangeiro;
    property LocalField     : string   read FCampoLocal;
    property ForeignTable   : string   read FTabelaEstrangeira;
    property ForeignField   : string   read FCampoEstrangeiro;
    property CampoIntegrado : string read FCampoIntegrado;
    property Ordenacao      : String read FOrdenacao write FOrdenacao;
  end;

type
  TModelo = class(TObject)
  end;

implementation

constructor Campo.Create(const Description: string; Types: TTiposCampo; const CanBeEmpty: Boolean = True; const ForeignAlias : String = ''; const ForeignTable : String = ''; const LocalField: String = ''; const ForeignField : String = ''; CampoIntegrado : String = ''; Ordenacao : String = '');
begin
  FDescricao             := Trim(Description);
  FTipos                 := Types;
  FPodeSerVazio          := CanBeEmpty;
  FPseudominoEstrangeiro := ForeignAlias;
  FTabelaEstrangeira     := ForeignTable;
  FCampoEstrangeiro      := ForeignField;
  FCampoLocal            := LocalField;
  FCampoIntegrado        := CampoIntegrado;
  FOrdenacao             := Ordenacao;
end;

destructor Campo.Destroy();
begin
  inherited;
end;

{ TTable }
constructor Tabela.Create(const Name: string; AOrder : String = ''; AVirtual : Boolean = False);
begin
  FName    := Name;
  FVirtual := AVirtual;
  FOrder   := AOrder;
end;

{ Ordenacao }

constructor Ordenar.Create(AOrdenacao: String);
begin
  FValor := AOrdenacao;
end;

{ Filtrar }

constructor Filtrar.Create(ACampo : String; AFiltro : String);
begin
  FValor := AFiltro;
  FCampo := ACampo;
end;

end.
