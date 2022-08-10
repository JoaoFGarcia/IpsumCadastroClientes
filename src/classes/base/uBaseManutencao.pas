unit uBaseManutencao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uIpsumControls, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.ComCtrls, Data.DB, Vcl.Grids, Vcl.DBGrids, Datasnap.DBClient, uUtils;

type
  TfrmManutencao = class(TForm)
    cdsMain: TClientDataSet;
    dsMain: TDataSource;
    pgcMain: TPageControl;
    tbsList: TTabSheet;
    tbsMaintenance: TTabSheet;
    pnlMenu: TPanel;
    btnAdd: TIpsumButton;
    btnAlter: TIpsumButton;
    btnDelete: TIpsumButton;
    btnFechar: TIpsumButton;
    pnlSearch: TPanel;
    lblField: TLabel;
    cboField: TComboBox;
    edtSearchContent: TEdit;
    btnSearch: TIpsumButton;
    dbgData: TDBGrid;
    Panel1: TPanel;
    btnSave: TIpsumButton;
    btnCancel: TIpsumButton;
    IpsumButton5: TIpsumButton;
    procedure btnFecharClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnAlterClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure dsMainStateChange(Sender: TObject);
    procedure dsMainDataChange(Sender: TObject; Field: TField);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure edtSearchContentKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    sFields : TStringList;
    procedure SetButtons;
  public
    { Public declarations }
  end;

var
  frmManutencao: TfrmManutencao;

implementation

uses
  uDialogo;

{$R *.dfm}

procedure TfrmManutencao.btnAddClick(Sender: TObject);
begin
  if cdsMain.State = dsBrowse then
  begin
    cdsMain.Insert;
    pgcMain.ActivePageIndex := 1;
  end;
end;

procedure TfrmManutencao.btnAlterClick(Sender: TObject);
begin
  if cdsMain.State = dsBrowse then
  begin
    cdsMain.Edit;
    pgcMain.ActivePageIndex := 1;
  end;
end;

procedure TfrmManutencao.btnCancelClick(Sender: TObject);
begin
  cdsMain.Cancel;
  pgcMain.ActivePageIndex := 0;
end;

procedure TfrmManutencao.btnDeleteClick(Sender: TObject);
begin
  if cdsMain.State = dsBrowse then
  begin
    if Confirmacao('Deseja realmente excluir o registro selecionado?') = mrYes then
      cdsMain.Delete;
  end;
end;

procedure TfrmManutencao.btnFecharClick(Sender: TObject);
var
  vParent: TWinControl;
begin
  vParent := Self.Parent;
  FreeAndNil(Self);
  if (vParent <> nil) and (vParent is TTabSheet) then
    FreeAndNil(vParent);
end;

procedure TfrmManutencao.btnSaveClick(Sender: TObject);
begin
  cdsMain.Post;
  pgcMain.ActivePageIndex := 0;
end;

procedure TfrmManutencao.SetButtons();
begin
  btnAdd.Visible  := (cdsMain.State = dsBrowse);
  btnAdd.Left     := 1000;
  btnAlter.Visible  := (cdsMain.RecordCount > 0) and (cdsMain.State = dsBrowse);
  btnAlter.Left     := 1000;
  btnDelete.Visible := (cdsMain.RecordCount > 0) and (cdsMain.State = dsBrowse);
  btnDelete.Left     := 1000;
  btnSave.Visible   := (cdsMain.State in [dsEdit, dsInsert]);
  btnSave.Left     := 1000;
  btnCancel.Visible   := (cdsMain.State in [dsEdit, dsInsert]);
  btnCancel.Left     := 1000;
end;

procedure TfrmManutencao.dsMainDataChange(Sender: TObject; Field: TField);
begin
  SetButtons();
end;

procedure TfrmManutencao.dsMainStateChange(Sender: TObject);
begin
  SetButtons();
end;

procedure TfrmManutencao.edtSearchContentKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    btnSearch.Click;
    Key := #0;
  end;
end;

procedure TfrmManutencao.FormCreate(Sender: TObject);
var
  vField : TField;
begin
  cdsMain.CreateDataSet;
  sFields := TStringList.Create;

  pgcMain.ActivePageIndex := 0;

  for vField in cdsMain.Fields do
  begin
    if vField.Tag = 1 then
    begin
      cboField.Items.Add(vField.DisplayName);
      sFields.Add(vField.FieldName);
    end;
  end;

  if sFields.Count > 0 then
    cboField.ItemIndex := 0;
end;

procedure TfrmManutencao.FormShow(Sender: TObject);
begin
  Focus(edtSearchContent);
end;

procedure TfrmManutencao.btnSearchClick(Sender: TObject);
begin
  if cboField.ItemIndex = -1 then
    Exit;

  if Trim(edtSearchContent.Text) = '' then
  begin
    cdsMain.Filtered := false;
    Exit;
  end;

  try
    cdsMain.Filter   := sFields[cboField.ItemIndex] + ' LIKE ' + QuotedStr('%'+edtSearchContent.Text+'%');
    cdsMain.Filtered := true;
  except
    cdsMain.Filtered := false;
  end;
end;

end.
