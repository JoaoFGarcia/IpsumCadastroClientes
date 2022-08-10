unit uObjeto;

interface

uses
  Classes,
  SysUtils,
  uModelo,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  Datasnap.DBClient,
  System.Rtti,
  Data.DB,
  System.RegularExpressions,
  System.Variants,
  System.DateUtils,
  StrUtils,
  Math,
  uConnectionController,
  uUtils,
  JSON,
  FireDAC.Stan.Async,
  Winapi.Windows;

type
  TRotina = (rtInsert, rtEdit);
  TTipoWhere = (twAnd, twOr);
type
  TConsultas = class
  private
    FFetch     : String;
    FUpdate    : String;
    FDelete    : String;
    FInsert    : String;
    FJoins     : String;
    FKeyWhere  : String;
    FKeys      : TStringList;
    FTipoWhere : TTipoWhere;
    FOrdenacao : String;
  published
    property Buscar    : string read FFetch     write FFetch;
    property Atualizar : string read FUpdate    write FUpdate;
    property Deletar   : string read FDelete    write FDelete;
    property Inserir   : string read FInsert    write FInsert;
    property Joins     : string read FJoins     write FJoins;
    property KeyWhere  : string read FKeyWhere  write FKeyWhere;
    property Keys      : TStringList read FKeys write FKeys;
  public
    constructor Create();
    destructor Destroy; override;
    procedure Clear;
    function Operador(Espacado : Boolean = True) : String;
  end;

type
  TTBObjeto<T: TModelo, constructor> = class(TInterfacedObject)
  private
    FController     : TController;
    FModels         : TObjectList<T>;
    FLoadForeign    : Boolean;
    FLoadForeignList: Boolean;
    FMainQuery      : TFDQuery;
    FAuxQuery       : TFDQuery;
    FIndex          : Integer;
    FQueries        : TConsultas;
    FErrors         : TStringList;
    FVirtual        : Boolean;
    FEOF            : Boolean;
    FBOF            : Boolean;
  private
    procedure LoadFields();
  published
    property Models     : TObjectList<T> read FModels write FModels;
    property Errors     : TStringList read FErrors write FErrors;
    property GetIndex   : Integer read FIndex;
    property Controller : TController read FController write FController;
    property EOF        : Boolean read FEOF;
    property BOF        : Boolean read FBOF;
    property Query      : TFDQuery read FMainQuery write FMainQuery;
  public
    constructor Create(Controller : TController; LoadForeign: Boolean = False; LoadForeignList: Boolean = False);
    destructor Destroy; override;
    procedure  ToClientDataSet(DataSet: TClientDataSet);
    function   Buscar(Fields: Array of Variant; Values: Array of Variant; AppendTo: Boolean = False) : Boolean;
    procedure  LoadQueries();
    procedure  BucarPorChaves();
    procedure  Next();
    procedure  Prior();
    procedure  First();
    procedure  Last();
    function   Inserir(): Boolean;
    function   Atualizar(): Boolean;
    function   Deletar(): Boolean;
    function   VerificarAntesSalvar(Rotina : TRotina): Boolean; virtual;
    function   ExecutarAntesSalvar(Rotina : TRotina): Boolean; virtual;
    function   ExecutarAposSalvar(Rotina  : TRotina): Boolean; virtual;
    function   Modelo() : T;
    function   DefinirTipoWhere(Tipo : TTipoWhere) : TTBObjeto<T>;
    function   Ordenacao(Ordenacao : String) : TTBObjeto<T>;
    procedure ExtrairModelos(ListaObjetos : TObjectList<T>);
    procedure Adicionar(AModelo : T);
    procedure Preparar();
    function InserirTodos(Substituir : Boolean = False): Boolean;
  end;

implementation

{ TQueries }

procedure TConsultas.Clear;
begin
  FFetch    := '';
  FUpdate   := '';
  FDelete   := '';
  FInsert   := '';
  FJoins    := '';
  FKeyWhere := '';
  FKeys.Clear;
end;

constructor TConsultas.Create;
begin
  FKeys      := TStringList.Create;
  FTipoWhere := twAnd;
end;

destructor TConsultas.Destroy;
begin
  inherited;
  FreeAndNil(FKeys);
end;

function TConsultas.Operador(Espacado: Boolean): String;
begin
  Result := IIF(Espacado,
               IIF(FTipoWhere = twAnd,
                   Format(' %s ', ['AND']),
                   Format(' %s ', ['OR'])),
               IIF(FTipoWhere = twAnd,
                   'AND',
                   'OR'
               ));
end;

{ TTBObjeto }

constructor TTBObjeto<T>.Create(Controller : TController; LoadForeign: Boolean = False; LoadForeignList: Boolean = False);
var
  rtContext : TRttiContext;
  rtType    : TRttiType;
begin
  rtContext := TRttiContext.Create();
  rtType    := rtContext.GetType(T);
  try
    FVirtual  := Tabela(rtType.GetAttributes[0]).IsVirtual;
  finally
    rtContext.Free;
  end;

  FController             := Controller;
  FModels                 := TObjectList<T>.Create(False);
  FMainQuery              := TFDQuery.Create(nil);
  FMainQuery.Connection   := FController.Connection;
  FAuxQuery               := TFDQuery.Create(nil);
  FAuxQuery.Connection    := FController.Connection;
  FLoadForeign            := LoadForeign;
  FLoadForeignList        := LoadForeignList;
  FQueries                := TConsultas.Create;
  FErrors                 := TStringList.Create;
  if not FVirtual then
    LoadQueries();
  FIndex := -1;
  FEOF   := False;
end;

function TTBObjeto<T>.Deletar: Boolean;
var
  rtContext   : TRttiContext;
  rtType      : TRttiType;
  rtProperty  : TRttiProperty;
  vValue      : TValue;
  sTempString : String;
begin
  Self.Errors.Clear;
  Result := False;
  if not (FModels.Count > 0) then
    Exit;
  rtContext := TRttiContext.Create();
  try
    try
      rtType     := rtContext.GetType(T);
      FMainQuery.SQL.Text := FQueries.Deletar + ' ' + FQueries.KeyWhere;
      for sTempString in FQueries.Keys do
      begin
        rtProperty := rtType.GetProperty(sTempString);
        FMainQuery.ParamByName('WH_' + sTempString).AsInteger := rtProperty.GetValue(Pointer(FModels.Items[FIndex])).AsInteger;
      end;
      FMainQuery.ExecSQL;
      FMainQuery.Connection.Commit;
    finally
      rtContext.Free;
      FMainQuery.Close;
    end;
  except
    on e: exception do
      FErrors.Add(e.Message);
  end;
  Result := True;
end;

destructor TTBObjeto<T>.Destroy;
var
  oModel   : T;
  iCounter : Integer;
begin
  if Assigned(FModels) then
  begin
    for iCounter := 0 to FModels.Count-1 do
      FreeAndNil(FModels[iCounter]);

    FreeAndNil(FModels);
  end;

  FreeAndNil(FMainQuery);
  FreeAndNil(FAuxQuery);
  FreeAndNil(FQueries);
  FreeAndNil(FErrors);
end;

procedure TTBObjeto<T>.First;
begin
  FIndex := 0;

  FEOF := Self.Models.Count = 0;
  FBOF := Self.Models.Count = 0;
end;

function TTBObjeto<T>.InserirTodos(Substituir : Boolean = False): Boolean;
begin
  Self.First;
  while not (Self.EOF) do
  begin
    Self.Inserir();
    Self.Next;
  end;
  Result := True;
end;

function TTBObjeto<T>.Inserir(): Boolean;
var
  rtContext   : TRttiContext;
  rtType      : TRttiType;
  rtProperty  : TRttiProperty;
  vValue      : TValue;
  sTempString : String;
  vFField     : TField;
begin
  Self.Errors.Clear;
  Result := False;

  if not (FModels.Count > 0) then
    Exit;
  if not ExecutarAntesSalvar(rtInsert) then
    Exit;
  if not VerificarAntesSalvar(rtInsert) then
    Exit;

  rtContext := TRttiContext.Create();
  try
    try
      rtType                := rtContext.GetType(T);
      FMainQuery.SQL.Text   := FQueries.Inserir;

      for rtProperty in rtType.GetProperties() do
      begin
        if (dbUpdate in Campo(rtProperty.GetAttributes[0]).Tipos)  then
        begin
          vValue  := rtProperty.GetValue(Pointer(FModels.Items[FIndex])).ToString();
          vFField := FAuxQuery.FindField(rtProperty.Name);
          if (vFField is TStringField) or (vFField is TWideStringField) or (vFField is TMemoField) then
            FMainQuery.ParamByName('NEW_' + rtProperty.Name).AsString  := vValue.ToString
          else if vFField is TIntegerField then
          begin
            //if vValue.ToString = '0' then
            //  FMainQuery.ParamByName('NEW_' + rtProperty.Name).Clear
            //else
              FMainQuery.ParamByName('NEW_' + rtProperty.Name).AsInteger := StrToIntDef(vValue.ToString, 0)
          end
          else if (vFField is TFMTBCDField) or (vFField is TCurrencyField) or (vFField is TBCDField) then
            FMainQuery.ParamByName('NEW_' + rtProperty.Name).AsFloat   := StrToFloatDef(vValue.ToString, 0.00)
          else if (vFField is TDateField) or (vFField is TSQLTimeStampField) then
          begin
            if vValue.ToString <> '' then
              FMainQuery.ParamByName('NEW_' + rtProperty.Name).AsDateTime := StrToDateTime(vValue.ToString)
            else
              FMainQuery.ParamByName('NEW_' + rtProperty.Name).AsDateTime := 0;
          end
          else if (vFField is TTimeField) then
          begin
            if vValue.ToString <> '' then
              FMainQuery.ParamByName('NEW_' + rtProperty.Name).AsTime := StrToTime(vValue.ToString)
            else
              FMainQuery.ParamByName('NEW_' + rtProperty.Name).AsTime := 0;
          end;

          if (dbTernaryUpdate in Campo(rtProperty.GetAttributes[0]).Tipos) and (Trim(FMainQuery.ParamByName('NEW_' + rtProperty.Name).AsString) = '') then
          begin
            FMainQuery.SQL.Text := StringReplace(FMainQuery.SQL.Text, ', :NEW_' + rtProperty.Name,'', [rfReplaceAll]);
            FMainQuery.SQL.Text := StringReplace(FMainQuery.SQL.Text, ':NEW_' + rtProperty.Name,'', [rfReplaceAll]);

            FMainQuery.SQL.Text := StringReplace(FMainQuery.SQL.Text, ', ' + rtProperty.Name,'', [rfReplaceAll]);
            FMainQuery.SQL.Text := StringReplace(FMainQuery.SQL.Text, rtProperty.Name,'', [rfReplaceAll]);
          end;
        end;

        vValue := nil;
      end;
      FMainQuery.ExecSQL;

      if ExecutarAposSalvar(rtInsert) then
        FMainQuery.Connection.Commit;
    finally
      rtContext.Free;
      FMainQuery.Close;
    end;
  except
    on e: exception do
      FErrors.Add(e.Message);
  end;
  Result := True;
end;

procedure TTBObjeto<T>.Last;
begin
  FIndex := FModels.Count - 1;
end;

procedure TTBObjeto<T>.BucarPorChaves();
var
  sFields     : array of Variant;
  sValues     : array of Variant;
  rtContext   : TRttiContext;
  rtType      : TRttiType;
  rtProperty  : TRttiProperty;
  vValue      : TValue;
  sTempString : String;
begin
  if not (FModels.Count > 0) then
    Exit;
  rtContext := TRttiContext.Create();
  try
    rtType     := rtContext.GetType(T);
    for sTempString in FQueries.Keys do
    begin
      SetLength(sFields, Length(sFields) + 1);
      SetLength(sValues, Length(sValues) + 1);
      rtProperty := rtType.GetProperty(sTempString);
      sFields[Length(sFields) - 1] := sTempString;
      sValues[Length(sValues) - 1] := rtProperty.GetValue(Pointer(FModels.Items[FIndex])).ToString;
    end;
    Self.Buscar(sFields, sValues);
  finally
    rtContext.Free;
  end;
end;

function TTBObjeto<T>.Buscar(Fields, Values: array of Variant; AppendTo: Boolean = False): Boolean;
var
  i          : Integer;
  sWhere     : String;
  Model      : T;
  rtContext  : TRttiContext;
  rtType     : TRttiType;
  rtProperty : TRttiProperty;
  vValue     : TValue;
  fAux       : Double;
  v : TFieldType;
begin
  Self.Errors.Clear;
  Result := False;

  if Length(Fields) <> Length(Values) then
  begin
    FErrors.Add('Quantidade de campos difere da quantidade de valores!');
  end;

  rtContext := TRttiContext.Create();
  try
    try
      if not AppendTo then
        FModels.Clear;
      FMainQuery.SQL.Text := FQueries.Buscar;
      for i := 0 to (Length(Values) - 1) do
      begin
        if sWhere <> EmptyStr then
          sWhere := sWhere + FQueries.Operador(True);
        sWhere := sWhere + 'A.' + Fields[i] + ' = ' + QuotedStr(Values[i]);
      end;
      if Length(Values) > 0 then
        FMainQuery.SQL.Text := FMainQuery.SQL.Text + ' WHERE ' + (sWhere);

      FMainQuery.SQL.Text := FMainQuery.SQL.Text + ' ' + FQueries.FOrdenacao;
      FMainQuery.Open();
      if (FMainQuery.IsEmpty) then
        Exit;
      FMainQuery.First;
      rtType := rtContext.GetType(T);
      while not(FMainQuery.Eof) do
      begin
        Model := T.Create;
        for rtProperty in rtType.GetProperties() do
        begin
          if dbVirtual in Campo(rtProperty.GetAttributes[0]).Tipos then
            Continue;
          
          if not (rtProperty.IsReadable) or (dbForeignList in Campo(rtProperty.GetAttributes[0]).Tipos) then
            Continue;

          case FMainQuery.FieldByName(rtProperty.Name).DataType of
            ftAutoInc, ftInteger, ftSmallInt:
              rtProperty.SetValue(Pointer(Model), IfThen(FMainQuery.FieldByName(rtProperty.Name).AsInteger <> 0, FMainQuery.FieldByName(rtProperty.Name).AsInteger, 0));
            ftFloat, ftCurrency, ftBCD, ftFMTBcd:
              rtProperty.SetValue(Pointer(Model), IfThen(FMainQuery.FieldByName(rtProperty.Name).AsFloat <> 0, FMainQuery.FieldByName(rtProperty.Name).AsFloat, 0));
            ftDate, ftDateTime, ftTimeStamp :
            begin
              fAux := StrToDateTime(IfThen(FMainQuery.FieldByName(rtProperty.Name).AsString <> '', FMainQuery.FieldByName(rtProperty.Name).AsString, '30/12/1899'));
              if fAux <> 0 then
                rtProperty.SetValue(Pointer(Model), fAux);
            end;
            ftTime:
            begin
              fAux := StrToTime(IfThen(FMainQuery.FieldByName(rtProperty.Name).AsString <> '', FMainQuery.FieldByName(rtProperty.Name).AsString, '00:00'));
              if fAux <> 0 then
                rtProperty.SetValue(Pointer(Model), fAux);
            end
          else
            rtProperty.SetValue(Pointer(Model), FMainQuery.FieldByName(rtProperty.Name).AsString);
          end;
        end;
        FModels.Add(Model);
        FMainQuery.Next;
      end;
      FMainQuery.EmptyDataSet;
      Self.First;
    finally
      FreeAndNil(rtType);
      FreeAndNil(rtProperty);
      rtContext.Free;
      Result := not (FModels.Count = 0);
      FMainQuery.EmptyDataSet;
      FMainQuery.Close;
    end;
  except
    on e: exception do
      FErrors.Add(e.Message);
  end;
end;

procedure TTBObjeto<T>.LoadFields;
begin
  if FQueries.Buscar = EmptyStr then
    Exit;
  if not FAuxQuery.Connection.Connected then
    Exit;

  FAuxQuery.Close;
  FAuxQuery.SQL.Text := FQueries.Buscar + ' ORDER BY ID OFFSET 0 ROWS FETCH NEXT 1 ROWS ONLY';
  FAuxQuery.Open();
end;

procedure TTBObjeto<T>.LoadQueries;
var
  rtContext : TRttiContext;
  rtType    : TRttiType;
  rtProperty: TRttiProperty;
  vValue    : TValue;
  vAttr     : Campo;
  vForeign  : TDictionary<String, String>;
  vItem     : TPair<string, string>;
  sValues   : String;
label
  lUpdate, lBuscar;
begin
  rtContext := TRttiContext.Create();
  vForeign := TDictionary<String, String>.Create;
  try
    FQueries.Clear;
    FMainQuery.SQL.Clear;
    rtType := rtContext.GetType(T);
    for rtProperty in rtType.GetProperties() do
    begin
      if not (rtProperty.IsWritable) then
        Continue;
      if Length(rtProperty.GetAttributes) <> 0 then
      begin
        vAttr := Campo(rtProperty.GetAttributes[0]);
        if (dbForeignList in vAttr.Tipos) then
          Continue;
        if (FQueries.Buscar <> EmptyStr) and not(dbVirtual in vAttr.Tipos) then
          FQueries.Buscar := FQueries.Buscar + ','#13;
        if (FQueries.Inserir <> EmptyStr) and not(dbForeign in vAttr.Tipos) and not(dbVirtual in vAttr.Tipos) then
          FQueries.Inserir := FQueries.Inserir + ', ';
        if (sValues <> EmptyStr) and not(dbForeign in vAttr.Tipos) and not(dbVirtual in vAttr.Tipos) then
          sValues := sValues + ', ';
        if (FQueries.Atualizar <> EmptyStr) and (dbUpdate in vAttr.Tipos) then
          FQueries.Atualizar := FQueries.Atualizar + ', ';
        if (dbKey in vAttr.Tipos) then
        begin
          if FQueries.KeyWhere <> EmptyStr then
            FQueries.KeyWhere := FQueries.KeyWhere + '    AND ('
          else
            FQueries.KeyWhere := FQueries.KeyWhere + ' WHERE '#13;
          FQueries.KeyWhere := FQueries.KeyWhere + '       (' + rtProperty.Name + ' = :WH_' +
            rtProperty.Name + ')';
          FQueries.Buscar := FQueries.Buscar + '       A.' + rtProperty.Name;
          FQueries.Keys.Add(rtProperty.Name);
        end
        else if (dbForeign in vAttr.Tipos) and (vAttr.ForeignAlias <> EmptyStr)
        then
        begin
          FQueries.Buscar := FQueries.Buscar + '       ' + vAttr.ForeignAlias +
            '.' + vAttr.ForeignField + ' AS ' + rtProperty.Name;
        end else
        if dbForeignWhere in vAttr.Tipos then
        begin
          if vForeign.ContainsKey(vAttr.ForeignTable + ' ' + vAttr.ForeignAlias)
          then
          begin
            vForeign.Items[vAttr.ForeignTable + ' ' + vAttr.ForeignAlias] :=
              vForeign.Items[vAttr.ForeignTable + ' ' + vAttr.ForeignAlias] +
              ' AND A.' + rtProperty.Name + ' = ' + vAttr.ForeignAlias + '.' +
              vAttr.ForeignField;
          end
          else
          begin
            vForeign.Add(vAttr.ForeignTable + ' ' + vAttr.ForeignAlias,
              'A.' + rtProperty.Name + ' = ' + vAttr.ForeignAlias + '.' +
              vAttr.ForeignField);
          end;

          goto lBuscar;
        end else
        lBuscar:
        if (dbUpdate in vAttr.Tipos) then
        begin
          FQueries.Buscar := FQueries.Buscar + '       A.' + rtProperty.Name;
          lUpdate:
          FQueries.Atualizar := FQueries.Atualizar + rtProperty.Name + ' = :NEW_' +
            rtProperty.Name;
            FQueries.Inserir := FQueries.Inserir + rtProperty.Name;
            sValues := sValues + ':NEW_' + rtProperty.Name;
        end;
      end;
    end;
    FQueries.Buscar := 'SELECT'#13 + FQueries.Buscar + #13;
    FQueries.Buscar := FQueries.Buscar + '  FROM ' + Tabela(rtType.GetAttributes[0]).Name + ' A';
    for vItem in vForeign do
    begin
      FQueries.Buscar := #13 + FQueries.Buscar +
        ('  LEFT JOIN ' + vItem.Key + ' ON (' + vItem.Value + ')');
    end;
    FQueries.Inserir := 'INSERT INTO ' + Tabela(rtType.GetAttributes[0]).Name + '(' + FQueries.Inserir + ') VALUES(' + sValues + ')';
    FQueries.Atualizar := 'UPDATE ' + Tabela(rtType.GetAttributes[0]).Name + ' SET ' + FQueries.Atualizar;
    FQueries.Deletar := 'DELETE FROM ' + Tabela(rtType.GetAttributes[0]).Name + '';
    LoadFields;
  finally
    rtContext.Free;
    FreeAndNil(vForeign);
  end;
end;

function TTBObjeto<T>.Modelo: T;
begin
  if FModels.Count > 0 then
  begin
    if FIndex = -1 then
      FIndex := 0;
    if FIndex > FModels.Count-1 then
      FIndex := FModels.Count-1;

    Result := FModels[FIndex];
  end;
end;

procedure TTBObjeto<T>.Next;
begin
  if FModels.Count = 0 then
    FIndex := -1
  else if FIndex >= FModels.Count - 1  then
    FEOF := True
  else
    Inc(FIndex);
end;

function TTBObjeto<T>.Ordenacao(Ordenacao: String): TTBObjeto<T>;
begin
  Self.FQueries.FOrdenacao := Ordenacao;

  Result := Self;
end;

procedure TTBObjeto<T>.Prior;
begin
  if FModels.Count = 0 then
    FIndex := -1
  else if FIndex = 0 then
    FBOF := True
  else
    Dec(FIndex);
end;

function TTBObjeto<T>.DefinirTipoWhere(Tipo: TTipoWhere): TTBObjeto<T>;
begin
  case Tipo of
    twAnd: FQueries.FTipoWhere := twAnd;
    twOr : FQueries.FTipoWhere := twOr;
  end;

  Result := Self;
end;

procedure TTBObjeto<T>.ToClientDataSet(DataSet: TClientDataSet);
var
  rtContext : TRttiContext;
  rtType    : TRttiType;
  rtProperty: TRttiProperty;
  vValue    : TValue;
  Model     : T;
  Field     : TField;
begin
  if (DataSet = nil) then
    Exit;
  if not(DataSet.Active) then
    DataSet.CreateDataSet;
  DataSet.EmptyDataSet;
  rtContext := TRttiContext.Create();
  try
    rtType := rtContext.GetType(T);
    DataSet.DisableControls;
    for Model in FModels do
    begin
      DataSet.Append;
      for rtProperty in rtType.GetProperties() do
      begin
        if not rtProperty.IsReadable then
          Continue;
        Field := DataSet.FindField(rtProperty.Name);
        if Field <> nil then
        begin
          if Field.DisplayLabel <> Campo(rtProperty.GetAttributes[0]).Description then
            DataSet.FieldByName(rtProperty.Name).DisplayLabel := Campo(rtProperty.GetAttributes[0]).Description;
          case DataSet.FieldByName(rtProperty.Name).DataType of
            ftInteger, ftSmallInt:
              DataSet.FieldByName(rtProperty.Name).AsInteger := rtProperty.GetValue(Pointer(Model)).AsInteger;
            ftFloat, ftCurrency, ftBCD, ftFMTBcd:
              DataSet.FieldByName(rtProperty.Name).AsFloat   := StrToFloat(rtProperty.GetValue(Pointer(Model)).ToString);
          else
            DataSet.FieldByName(rtProperty.Name).AsString    := rtProperty.GetValue(Pointer(Model)).ToString;
          end;
        end;
      end;
      DataSet.Post;
    end;
  finally
    rtContext.Free;
    DataSet.EnableControls;
  end;
end;

procedure TTBObjeto<T>.Preparar();
var
  Model : T;
begin
  Model := T.Create;
  Self.Models.Add(Model);
  Self.Last;
end;

procedure TTBObjeto<T>.Adicionar(AModelo: T);
begin
  Self.Models.Add(AModelo);
  Self.Last;
end;

function TTBObjeto<T>.Atualizar: Boolean;
var
  rtContext   : TRttiContext;
  rtType      : TRttiType;
  rtProperty  : TRttiProperty;
  vValue      : TValue;
  vFField     : TField;
  sTempString : String;
begin
  Self.Errors.Clear;
  Result := False;
  if not (FModels.Count > 0) then
    Exit;
  if not VerificarAntesSalvar(rtEdit) then
    Exit;
  rtContext := TRttiContext.Create();
  try
    try
      rtType     := rtContext.GetType(T);
      FMainQuery.SQL.Text := FQueries.Atualizar + ' ' + FQueries.KeyWhere;
      for sTempString in FQueries.Keys do
      begin
        rtProperty := rtType.GetProperty(sTempString);
        FMainQuery.ParamByName('WH_' + sTempString).AsInteger := StrToiNT(rtProperty.GetValue(Pointer(FModels.Items[FIndex])).ToString);
      end;
      for rtProperty in rtType.GetProperties() do
      begin
        if not (dbUpdate in Campo(rtProperty.GetAttributes[0]).Tipos) then
          Continue;
        if (dbUpdate in Campo(rtProperty.GetAttributes[0]).Tipos)  then
        begin
          vValue  := rtProperty.GetValue(Pointer(FModels.Items[FIndex])).ToString();
          vFField := FAuxQuery.FindField(rtProperty.Name);
          if (vFField is TStringField) or (vFField is TWideStringField) or (vFField is TMemoField) then
            FMainQuery.ParamByName('NEW_' + rtProperty.Name).AsString  := vValue.ToString
          else if vFField is TIntegerField then
            FMainQuery.ParamByName('NEW_' + rtProperty.Name).AsInteger := StrToIntDef(vValue.ToString, 0)
          else if vFField is TFMTBCDField then
            FMainQuery.ParamByName('NEW_' + rtProperty.Name).AsFloat   := StrToFloatDef(vValue.ToString, 0.00)
          else if (vFField is TDateField) or (vFField is TSQLTimeStampField) then
            FMainQuery.ParamByName('NEW_' + rtProperty.Name).AsDate    := StrToDateTime(IfThen(vValue.ToString <> '', vValue.ToString, '30/12/1899'))
        end;
      end;
      FMainQuery.ExecSQL;
      FMainQuery.Connection.Commit;
    finally
      rtContext.Free;
      FMainQuery.Close;
    end;
  except
    on e: exception do
      FErrors.Add(e.Message);
  end;
  Result := True;
end;

function TTBObjeto<T>.ExecutarAntesSalvar(Rotina : TRotina): Boolean;
begin
  Result := True;
end;

function TTBObjeto<T>.ExecutarAposSalvar(Rotina: TRotina): Boolean;
begin
  Result := True;
end;

procedure TTBObjeto<T>.ExtrairModelos(ListaObjetos: TObjectList<T>);
var
  iContador : Integer;
begin
  for iContador := Self.Models.Count-1 downto 0 do
    ListaObjetos.Add(Self.Models.ExtractAt(iContador));
end;

function TTBObjeto<T>.VerificarAntesSalvar(Rotina : TRotina): Boolean;
var
  rtContext  : TRttiContext;
  rtType     : TRttiType;
  rtProperty : TRttiProperty;
  vValue     : TValue;
  Model      : T;
  vAttr      : Campo;
begin
  Result    := False;
  rtContext := TRttiContext.Create();
  try
    rtType := rtContext.GetType(T);
    for Model in FModels do
    begin
      for rtProperty in rtType.GetProperties() do
      begin
        if Campo(rtProperty.GetAttributes[0]).CanBeEmpty then
          Continue;
          if (rtProperty.GetValue(Pointer(Model)).ToString = EmptyStr) or (rtProperty.GetValue(Pointer(Model)).ToString = '0') then
          begin
            FErrors.Add('O campo ' + Campo(rtProperty.GetAttributes[0]).Description + ' não pode ser vazio ou nulo!');
            Exit;
          end;
        end;
      end;
  finally
    rtContext.Free;
  end;
  Result := True;
end;

end.
