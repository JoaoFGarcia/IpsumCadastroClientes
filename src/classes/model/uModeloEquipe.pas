unit uModeloEquipe;

interface

uses
  uModelo,
  System.Generics.Collections,
  System.SysUtils,
  System.Rtti;

type
  [Tabela('equipe')]
  TModeloEquipe = class(TModelo)
  private
    FID                : Integer;
    FDESCRICAO         : String;
    FSETOR             : String;
    FOBSERVACAO        : String;
    FDATAHORA_CRIACAO  : TDateTime;
  published
    [Campo('Identificador', [dbKey], True)]
    property ID                 : Integer   read FID                 write FID;
    [Campo('Descrição', [dbUpdate], False)]
    property DESCRICAO          : String    read FDESCRICAO          write FDESCRICAO;
    [Campo('Setor', [dbUpdate], False)]
    property SETOR              : String    read FSETOR              write FSETOR;
    [Campo('Observação', [dbUpdate], True)]
    property OBSERVACAO         : String    read FOBSERVACAO         write FOBSERVACAO;
    [Campo('Data/hora criação', [dbUpdate], False)]
    property DATAHORA_CRIACAO   : TDateTime read FDATAHORA_CRIACAO   write FDATAHORA_CRIACAO;
  public
  end;

implementation

end.
