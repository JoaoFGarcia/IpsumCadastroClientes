unit uUtils;

interface

uses
  IdIcmpClient,
  uManifest,
  IdHTTP,
  IdTCPClient,
  IdStack,
  Vcl.Controls,
  Winapi.Windows,
  WinApi.Messages,
  JSON,
  DB,
  REST.Response.Adapter,
  System.Generics.Collections,
  System.Classes,
  SysUtils,
  Datasnap.DBClient,
  Graphics,
  REST.Json,
  StrUtils,
  Data.FmtBcd,
  Vcl.Forms;

function IIF(Condicao : Boolean; Resultado : Variant; ResultadoAlternativo : Variant) : Variant; overload;
function IIF(Condicao : Boolean; Resultado : TBcd; ResultadoAlternativo : TBcd) : TBcd; overload;
function IIF(AValor : Variant; Padrao : Variant) : Variant; overload;
function StrDef(const AValue: string; const ADefault: string): string;

procedure Focus(Control : TWinControl);

function RemoveAcentos(Texto : String): String;
function FormataCPF(CPF: string): string;
function FormataCNPJ(CNPJ: string): string;
function somenteNumeros(texto: String): String;
procedure SalvarJSON(AJSON : TJSonValue; APath : String);
function ToUpper(const S: string): string;
function ZeroEsquerda(AValor: string; ATamanho : Integer; APad : char = '0'): string; overload;
function RemoveZeroEsquerda(AValor : string) : string;

function FormatStr(AValue: String; ASize: Integer; ADir: Char = 'R'; AChr: Char = ' '): String;
function NaN(const [ref] Objs : array of TObject) : boolean;

implementation

uses Winapi.Wincodec;

function IIF(Condicao : Boolean; Resultado : Variant; ResultadoAlternativo : Variant) : Variant;
begin
  case Condicao of
    True  : Result := Resultado;
    False : Result := ResultadoAlternativo;
  end;
end;

function IIF(AValor : Variant; Padrao : Variant) : Variant; overload;
begin
  if (String(AValor) = '') or (String(AValor) = '0') then
    Result := Padrao
  else
    Result := AValor;
end;

function IIF(Condicao : Boolean; Resultado : TBcd; ResultadoAlternativo : TBcd) : TBcd;
begin
  case Condicao of
    True  : Result := Resultado;
    False : Result := ResultadoAlternativo;
  end;
end;



function StrDef(const AValue: string; const ADefault: string): string;
begin
  if AValue = '' then
    Result := ADefault
  else
    Result := AValue;
end;

procedure Focus(Control : TWinControl);
begin
  Control.SetFocus;
  PostMessage((Control).Handle, WM_ACTIVATE, 1, 0);
end;

function RemoveAcentos(Texto : String): String;
const ComAcento = 'àâêôûãõáéíóúçüÀÂÊÔÛÃÕÁÉÍÓÚÇÜ';
      SemAcento = 'aaeouaoaeioucuAAEOUAOAEIOUCU';
var
  x : Integer;
begin
  for x := 1 to Length(Texto) do
  begin
    if Pos(Texto[x], ComAcento) <> 0 Then
    begin
      Texto[x] := SemAcento[Pos(Texto[x],ComAcento)];
    end;
  end;

  Result := Texto;
end;

function FormataCPF(CPF: string): string;
begin
  Result := Copy(CPF,1,3)+'.'+Copy(CPF,4,3)+'.'+Copy(CPF,7,3)+'-'+Copy(CPF,10,2);
end;

function FormataCNPJ(CNPJ: string): string;
begin
  Result :=Copy(CNPJ,1,2)+'.'+Copy(CNPJ,3,3)+'.'+Copy(CNPJ,6,3)+'/'+Copy(CNPJ,9,4)+'-'+Copy(CNPJ,13,2);
end;

function SomenteNumeros(texto: String): String;
var
  novoValor: String;
  i: Integer;
begin
  novoValor := '';

  for i := 1 to High(texto) do
  begin
    if StrToIntDef(Copy(texto, i, 1), -1) in [0..9] then
      novoValor := novoValor + Copy(texto, i, 1);
  end;

  Result := novoValor;
end;

procedure SalvarJSON(AJSON : TJSonValue; APath : String);
var
  vConteudo : TStrings;
begin
  vConteudo := TStringList.Create;
  try
    vConteudo.Text := StringReplace(TJson.Format(AJSON), '\/', '/', [rfReplaceAll]);
    vConteudo.SaveToFile(APath);
  finally
    FreeAndNil(vConteudo);
  end;
end;

function ToUpper(const S: string): string;
var
  Ch          : Char;
  L           : Integer;
  Source, Dest: PChar;
begin
  L := Length(S);
  SetLength(Result, L);
  Source := Pointer(S);
  Dest := Pointer(Result);
  while L <> 0 do
  begin
    Ch := Source^;
    if (Ch >= 'a') and (Ch <= 'z') then Dec(Ch, 32);
    if (Ch >= 'á') and (Ch <= 'ú') then Dec(Ch, 32);
    if (Ch >= 'ã') and (Ch <= 'õ') then Dec(Ch, 32);
    if (Ch >= 'ä') and (Ch <= 'ü') then Dec(Ch, 32);
    if (Ch >= 'à') and (Ch <= 'ù') then Dec(Ch, 32);
    if (Ch >= 'â') and (Ch <= 'û') then Dec(Ch, 32);
    Dest^ := Ch;
    Inc(Source);
    Inc(Dest);
    Dec(L);
  end;
end;

function ZeroEsquerda(AValor: string; ATamanho : Integer; APad : char = '0'): string; overload;
begin
  Result := RightStr(StringOfChar(APad, ATamanho) + AValor, ATamanho);
end;

function RemoveZeroEsquerda(AValor : string) : string;
var
  i : integer;
begin
  for i := 0 to length(AValor) do
  begin
    if AValor[i] in ['1'..'9','-'] then
      Break;
  end;

  Result := copy(AValor, i , 20);
end;

function FormatStr(AValue: String; ASize: Integer; ADir: Char = 'R'; AChr: Char = ' '): String;
begin
  if ADir = 'R' then
    Result := RightStr(StringOfChar(AChr, ASize) + AValue, ASize)
  else
    Result := LeftStr(AValue + StringOfChar(AChr, ASize), ASize);
end;

function NaN(const [ref] Objs : array of TObject) : boolean;
var
  I    : Integer;
begin
  for I := 0 to Length(Objs)-1 do
  begin
    if Assigned(Objs[I]) and (Objs[I] <> nil) then
      FreeAndNil(Objs[I]);
  end;
end;

end.
