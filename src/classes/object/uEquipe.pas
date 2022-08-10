unit uEquipe;

interface

uses
  uObjeto,
  uModelo,
  System.Generics.Collections,
  System.SysUtils,
  System.RegularExpressions,
  uModeloEquipe,
  JSON,
  uUtils,
  StrUtils;

type
  TEquipe = class(TTBObjeto<TModeloEquipe>)
  private
  public
    function VerificarAntesSalvar(Rotina : TRotina): Boolean; override;
    function ExecutarAntesSalvar(Rotina : TRotina): Boolean; override;
    function ExecutarAposSalvar(Rotina : TRotina): Boolean; override;
  end;

implementation

function TEquipe.ExecutarAntesSalvar(Rotina : TRotina): Boolean;
begin
  Result := False;
  Result := True;
end;

function TEquipe.ExecutarAposSalvar(Rotina: TRotina): Boolean;
begin
  Result := True;
end;

function TEquipe.VerificarAntesSalvar(Rotina : TRotina): Boolean;
begin
  Result := False;

  if not inherited then
    Exit;

  Result := true;
end;

end.
