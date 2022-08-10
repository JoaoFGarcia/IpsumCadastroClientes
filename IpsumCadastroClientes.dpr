program IpsumCadastroClientes;

uses
  Vcl.Forms,
  uMain in 'src\classes\visual\uMain.pas' {frmMain},
  uMainDM in 'src\classes\uMainDM.pas' {dmMain: TDataModule},
  uConnectionController in 'src\orm\uConnectionController.pas',
  uUtils in 'src\classes\uUtils.pas',
  uManifest in 'src\classes\uManifest.pas',
  uDialogo in 'src\classes\visual\uDialogo.pas' {frmDialogo},
  uIpsumControls in 'src\componentes\uIpsumControls.pas',
  uBaseManutencao in 'src\classes\base\uBaseManutencao.pas' {frmManutencao},
  uModeloEquipe in 'src\classes\model\uModeloEquipe.pas',
  uEquipe in 'src\classes\object\uEquipe.pas',
  uTeamList in 'src\classes\visual\uTeamList.pas' {frmTeamList},
  uObjeto in 'src\orm\uObjeto.pas',
  uModelo in 'src\orm\uModelo.pas',
  uEmployeeList in 'src\classes\visual\uEmployeeList.pas' {frmEmployeeList},
  uModeloFuncionario in 'src\classes\model\uModeloFuncionario.pas',
  uFuncionario in 'src\classes\object\uFuncionario.pas',
  uConfig in 'src\classes\visual\uConfig.pas' {frmConfig};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TdmMain, dmMain);
  Application.CreateForm(TfrmEmployeeList, frmEmployeeList);
  Application.CreateForm(TfrmConfig, frmConfig);
  Application.Run;
end.
