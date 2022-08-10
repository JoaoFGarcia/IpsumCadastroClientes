unit uModeloFuncionario;

interface

uses
  uModelo,
  System.Generics.Collections,
  System.SysUtils,
  System.Rtti;

type
  [Tabela('funcionario')]
  TModeloFuncionario = class(TModelo)
  private
    FID                : Integer;
    FNOME              : String;
    FCARGO             : String;
    FOBSERVACAO        : String;
    FDATAHORA_CRIACAO  : TDateTime;
    FSALARIO           : Double;
    FEQUIPE            : Integer;
    FEQUIPE_DESCRICAO  : String;
  published
    [Campo('Identificador', [dbKey], True)]
    property ID                 : Integer   read FID                write FID;
    [Campo('Nome', [dbUpdate], False)]
    property NOME               : String    read FNOME              write FNOME;
    [Campo('Cargo', [dbUpdate], False)]
    property CARGO              : String    read FCARGO             write FCARGO;
    [Campo('Observa��o', [dbUpdate], True)]
    property OBSERVACAO         : String    read FOBSERVACAO        write FOBSERVACAO;
    [Campo('Data/hora cria��o', [dbUpdate], False)]
    property DATAHORA_CRIACAO   : TDateTime read FDATAHORA_CRIACAO  write FDATAHORA_CRIACAO;
    [Campo('Sal�rio', [dbUpdate], False)]
    property SALARIO            : Double    read FSALARIO           write FSALARIO;
    [Campo('Equipe', [dbUpdate, dbForeignWhere], False, 'B', 'equipe', '', 'id')]
    property EQUIPE             : Integer   read FEQUIPE            write FEQUIPE;
    [Campo('Equipe descri��o', [dbForeign], True, 'B', 'equipe', '', 'descricao')]
    property EQUIPE_DESCRICAO   : String   read FEQUIPE_DESCRICAO            write FEQUIPE_DESCRICAO;
  public
  end;

implementation

end.
