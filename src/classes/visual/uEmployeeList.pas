unit uEmployeeList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBaseManutencao, Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, uIpsumControls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Mask, Vcl.DBCtrls, uDialogo;

type
  TfrmEmployeeList = class(TfrmManutencao)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    dbeID: TDBEdit;
    dbeDescricao: TDBEdit;
    cboCargo: TComboBox;
    Label4: TLabel;
    dtpCriacao: TDateTimePicker;
    Label5: TLabel;
    dbeObs: TDBMemo;
    cdsMainid: TIntegerField;
    cdsMainnome: TStringField;
    cdsMaincargo: TStringField;
    cdsMainsalario: TFMTBCDField;
    cdsMainequipe: TIntegerField;
    cdsMainequipe_descricao: TStringField;
    cdsMaindatahora_criacao: TDateTimeField;
    dbeSalario: TDBEdit;
    cdsMainobservacao: TStringField;
    lblSalario: TLabel;
    Label6: TLabel;
    cdsEquipe: TClientDataSet;
    dsEquipe: TDataSource;
    cdsEquipeid: TIntegerField;
    cdsEquipedescricao: TStringField;
    cdsEquipesetor: TStringField;
    cdsEquipeobservacao: TStringField;
    cdsEquipedatahora_criacao: TDateTimeField;
    cboEquipe: TDBLookupComboBox;
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure cdsMainAfterScroll(DataSet: TDataSet);
    procedure btnAddClick(Sender: TObject);
    procedure btnAlterClick(Sender: TObject);
    procedure dbeSalarioKeyPress(Sender: TObject; var Key: Char);
  private
    procedure LoadData;
    procedure LoadTeamData;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmEmployeeList: TfrmEmployeeList;

implementation

uses
  uFuncionario,
  uEquipe,
  uConnectionController,
  uUtils;

{$R *.dfm}

procedure TfrmEmployeeList.btnAddClick(Sender: TObject);
begin
  inherited;
  dtpCriacao.DateTime := Now;
  Focus(dbeDescricao);
end;

procedure TfrmEmployeeList.btnAlterClick(Sender: TObject);
begin
  inherited;
  Focus(dbeDescricao);
end;

procedure TfrmEmployeeList.btnDeleteClick(Sender: TObject);
var
  oFuncionario : TFuncionario;
begin

  oFuncionario := TFuncionario.Create(Controller);
  try
    oFuncionario.Preparar;
    oFuncionario.Modelo.ID := cdsMain.FieldByName('id').AsInteger;
    oFuncionario.Deletar;
  finally
    FreeAndNil(oFuncionario);
  end;

  inherited;
end;

procedure TfrmEmployeeList.btnSaveClick(Sender: TObject);
var
  oFuncionario : TFuncionario;
  tdsRotine    : TDataSetState;
begin
  tdsRotine := cdsMain.State;
  inherited;
  oFuncionario := TFuncionario.Create(Controller);
  try
    oFuncionario.Preparar;

    oFuncionario.Modelo.CARGO            := cboCargo.Text;
    oFuncionario.Modelo.DATAHORA_CRIACAO := dtpCriacao.DateTime;
    oFuncionario.Modelo.ID               := cdsMain.FieldByName('id').AsInteger;
    oFuncionario.Modelo.NOME             := cdsMain.FieldByName('nome').AsString;
    oFuncionario.Modelo.OBSERVACAO       := cdsMain.FieldByName('observacao').AsString;
    oFuncionario.Modelo.SALARIO          := cdsMain.FieldByName('salario').AsFloat;
    oFuncionario.Modelo.EQUIPE           := cdsMain.FieldByName('equipe').AsInteger;
    if tdsRotine = dsInsert then
    begin
      if not oFuncionario.Inserir then
      begin
        Erro(oFuncionario.Errors[0]);
      end;
    end
    else
    begin
      if not oFuncionario.Atualizar then
      begin
        Erro(oFuncionario.Errors[0]);
      end;
    end;
  finally
    FreeAndNil(oFuncionario);
    LoadData();
  end;
end;

procedure TfrmEmployeeList.cdsMainAfterScroll(DataSet: TDataSet);
begin
  inherited;
  cboCargo.Text       := cdsMain.FieldByName('cargo').AsString;
  dtpCriacao.DateTime := cdsMain.FieldByName('datahora_criacao').AsDateTime;
end;

procedure TfrmEmployeeList.dbeSalarioKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;
  if not (Key in ['1','2','3','4','5','6','7','8','9','0',',',#8]) then
    Key :=#0;
end;

procedure TfrmEmployeeList.LoadData();
var
  oFuncionario : TFuncionario;
begin
  inherited;
  oFuncionario := TFuncionario.Create(Controller, True);
  cdsMain.DisableControls;
  try
    oFuncionario.Buscar([], []);
    oFuncionario.ToClientDataSet(cdsMain);
  finally
    cdsMain.EnableControls;
    cdsMain.Last;
    FreeAndNil(oFuncionario);
  end;
end;

procedure TfrmEmployeeList.LoadTeamData();
var
  oEquipe : TEquipe;
begin
  inherited;
  oEquipe := TEquipe.Create(Controller);
  try
    oEquipe.Buscar([], []);
    oEquipe.ToClientDataSet(cdsEquipe);
  finally
    FreeAndNil(oEquipe);
  end;
end;

procedure TfrmEmployeeList.FormShow(Sender: TObject);
begin
  inherited;
  LoadData();
  LoadTeamData;
end;

end.
