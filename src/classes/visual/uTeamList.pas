unit uTeamList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uBaseManutencao, Data.DB,
  Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls, uIpsumControls,
  Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Mask, Vcl.DBCtrls, uDialogo;

type
  TfrmTeamList = class(TfrmManutencao)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    dbeID: TDBEdit;
    dbeDescricao: TDBEdit;
    cboSetor: TComboBox;
    Label4: TLabel;
    dtpCriacao: TDateTimePicker;
    Label5: TLabel;
    dbeObs: TDBMemo;
    cdsMainid: TIntegerField;
    cdsMaindescricao: TStringField;
    cdsMainsetor: TStringField;
    cdsMainobservacao: TStringField;
    cdsMaindatahora_criacao: TDateTimeField;
    procedure btnSaveClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure cdsMainAfterScroll(DataSet: TDataSet);
    procedure btnAddClick(Sender: TObject);
    procedure btnAlterClick(Sender: TObject);
  private
    procedure LoadData;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTeamList: TfrmTeamList;

implementation

uses
  uEquipe,
  uConnectionController,
  uUtils;

{$R *.dfm}

procedure TfrmTeamList.btnAddClick(Sender: TObject);
begin
  inherited;
  dtpCriacao.DateTime := Now;
  Focus(dbeDescricao);
end;

procedure TfrmTeamList.btnAlterClick(Sender: TObject);
begin
  inherited;
  Focus(dbeDescricao);
end;

procedure TfrmTeamList.btnDeleteClick(Sender: TObject);
var
  oEquipe : TEquipe;
begin

  oEquipe := TEquipe.Create(Controller);
  try
    oEquipe.Preparar;
    oEquipe.Modelo.ID := cdsMain.FieldByName('id').AsInteger;
    oEquipe.Deletar;
  finally
    FreeAndNil(oEquipe);
  end;

  inherited;
end;

procedure TfrmTeamList.btnSaveClick(Sender: TObject);
var
  oEquipe : TEquipe;
  tdsRotine : TDataSetState;
begin
  tdsRotine := cdsMain.State;
  inherited;
  oEquipe := TEquipe.Create(Controller);
  try
    oEquipe.Preparar;

    oEquipe.Modelo.SETOR            := cboSetor.Text;
    oEquipe.Modelo.DATAHORA_CRIACAO := dtpCriacao.DateTime;
    oEquipe.Modelo.ID               := cdsMain.FieldByName('id').AsInteger;
    oEquipe.Modelo.DESCRICAO        := cdsMain.FieldByName('descricao').AsString;
    oEquipe.Modelo.OBSERVACAO       := cdsMain.FieldByName('observacao').AsString;
    if tdsRotine = dsInsert then
    begin
      if not oEquipe.Inserir then
      begin
        Erro(oEquipe.Errors[0]);
      end;
    end
    else
      oEquipe.Atualizar;
  finally
    FreeAndNil(oEquipe);
    LoadData();
  end;
end;

procedure TfrmTeamList.cdsMainAfterScroll(DataSet: TDataSet);
begin
  inherited;
  cboSetor.Text := cdsMain.FieldByName('setor').AsString;
  dtpCriacao.DateTime := cdsMain.FieldByName('datahora_criacao').AsDateTime;
end;

procedure TfrmTeamList.LoadData();
var
  oEquipe : TEquipe;
begin
  inherited;
  oEquipe := TEquipe.Create(Controller);
  cdsMain.DisableControls;
  try
    oEquipe.Buscar([], []);
    oEquipe.ToClientDataSet(cdsMain);
  finally
    cdsMain.EnableControls;
    cdsMain.Last;
    FreeAndNil(oEquipe);
  end;
end;

procedure TfrmTeamList.FormShow(Sender: TObject);
begin
  inherited;
  LoadData();
end;

end.
