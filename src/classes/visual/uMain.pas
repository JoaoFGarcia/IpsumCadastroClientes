unit uMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.ComCtrls,
  uMainDM, Vcl.Buttons, Vcl.ToolWin, Vcl.ActnMan, Vcl.ActnCtrls, Vcl.ActnMenus,
  Vcl.PlatformDefaultStyleActnCtrls, System.Actions, Vcl.ActnList,
  Vcl.ButtonGroup, Vcl.Imaging.pngimage, uIpsumControls, System.ImageList,
  Vcl.ImgList, frxClass, frxDBSet, Data.DB, Datasnap.DBClient;

type
  TfrmMain = class(TForm)
    pnlMenu: TPanel;
    pgcMain: TPageControl;
    btnConfig: TIpsumButton;
    btnCadFuncionario: TIpsumButton;
    btnCadEquipe: TIpsumButton;
    frxReport: TfrxReport;
    frxDBDataset: TfrxDBDataset;
    IpsumButton1: TIpsumButton;
    cdsRel: TClientDataSet;
    cdsRelid: TIntegerField;
    cdsRelsetor: TStringField;
    cdsRelnome: TStringField;
    cdsRelcargo: TStringField;
    cdsRelsalario: TFMTBCDField;
    cdsRelequipe: TIntegerField;
    cdsRelequipe_descricao: TStringField;
    procedure btnCadEquipeClick(Sender: TObject);
    procedure btnCadFuncionarioClick(Sender: TObject);
    procedure IpsumButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
  private
    procedure OpenForm(AForm: TComponentClass; APageControl: TPageControl = nil);
    function FormOpened(AForm: TComponent; APageControl: TPageControl = nil): boolean;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  uTeamList,
  uEmployeeList,
  uFuncionario,
  uConnectionController,
  uConfig,
  uManifest;

{$R *.dfm}

procedure TfrmMain.btnCadEquipeClick(Sender: TObject);
begin
  OpenForm(TfrmTeamList, pgcMain);
end;

procedure TfrmMain.OpenForm(AForm: TComponentClass; APageControl: TPageControl = nil);
var
  TabSheet: TTabSheet;
  Form    : TComponent;
begin
  Form := AForm.Create(Self);
  if (APageControl <> nil) and not (FormOpened(Form, APageControl)) then
  begin
    TForm(Form).BorderStyle := bsNone;
    TabSheet                := TTabSheet.Create(Self);
    TabSheet.Caption        := TForm(Form).Caption;
    TabSheet.PageControl    := APageControl;
    TabSheet.Tag            := TForm(Form).Tag;
    TForm(Form).Align       := alClient;
    TForm(Form).Parent      := TabSheet;
    TForm(Form).Show;
    APageControl.ActivePageIndex := APageControl.PageCount - 1;
  end else
    FreeAndNil(Form);
end;

procedure TfrmMain.btnCadFuncionarioClick(Sender: TObject);
begin
  OpenForm(TfrmEmployeeList, pgcMain);
end;

procedure TfrmMain.btnConfigClick(Sender: TObject);
begin
  frmConfig := TfrmConfig.Create(Self);
  try
    if frmConfig.ShowModal = mrOk then
    begin
      Controller.ReloadConfig(Config.Database.Servidor, Config.Database.Database, Config.Database.Usuario, Config.Database.Senha, Config.Database.AutenticacaoLocal);
      Controller.LoadConnection;
    end;
  finally
    FreeAndNil(frmConfig);
  end;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  cdsRel.CreateDataSet;
end;

function TfrmMain.FormOpened(AForm: TComponent; APageControl: TPageControl = nil): boolean;
var
  iIterator : Integer;
begin
  Result := False;
  for iIterator := 0 to APageControl.PageCount - 1 do
    if APageControl.Pages[iIterator].Tag = TForm(AForm).Tag then
    begin
      APageControl.ActivePage := APageControl.Pages[iIterator];
      Result := True;
    end;
end;

procedure TfrmMain.IpsumButton1Click(Sender: TObject);
var
  oFuncionario : TFuncionario;
begin
  oFuncionario := TFuncionario.Create(Controller, True);
  try
    cdsRel.DisableControls;
    cdsRel.EmptyDataSet;
    oFuncionario.Ordenacao('ORDER BY A.EQUIPE, A.NOME');
    oFuncionario.Buscar([], []);
    oFuncionario.ToClientDataSet(cdsRel);
    frxReport.LoadFromFile(ExpandFileName(GetCurrentDir + '\') + 'relPrincipal.fr3');
    frxReport.ShowReport();
  finally
    FreeAndNil(oFuncionario);
  end;
end;

end.
