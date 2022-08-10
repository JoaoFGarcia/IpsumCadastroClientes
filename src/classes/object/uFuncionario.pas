unit uFuncionario;

interface

uses
  uObjeto,
  uModelo,
  System.Generics.Collections,
  System.SysUtils,
  System.RegularExpressions,
  uModeloFuncionario,
  JSON,
  uUtils,
  StrUtils;

type
  TFuncionario = class(TTBObjeto<TModeloFuncionario>)
  private
  public
    function VerificarAntesSalvar(Rotina : TRotina): Boolean; override;
    function ExecutarAntesSalvar(Rotina : TRotina): Boolean; override;
    function ExecutarAposSalvar(Rotina : TRotina): Boolean; override;
  end;

implementation

function TFuncionario.ExecutarAntesSalvar(Rotina : TRotina): Boolean;
begin
  Result := False;
  Result := True;
end;

function TFuncionario.ExecutarAposSalvar(Rotina: TRotina): Boolean;
begin
  Result := True;
end;

function TFuncionario.VerificarAntesSalvar(Rotina : TRotina): Boolean;
begin
  Result := False;

  if not inherited then
    Exit;

  Result := true;
end;

end.
