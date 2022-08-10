unit uConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  uIpsumControls;

type
  TfrmConfig = class(TForm)
    Label1: TLabel;
    edtHostname: TEdit;
    Label2: TLabel;
    edtDatabase: TEdit;
    Label3: TLabel;
    edtUser: TEdit;
    Label4: TLabel;
    edtPassword: TEdit;
    ckbAuthent: TCheckBox;
    btnSave: TIpsumButton;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure ckbAuthentClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmConfig: TfrmConfig;

implementation

uses
  uManifest;

{$R *.dfm}

procedure TfrmConfig.ckbAuthentClick(Sender: TObject);
begin
  edtUser.Enabled     := not ckbAuthent.Checked;
  edtPassword.Enabled := not ckbAuthent.Checked;
end;

procedure TfrmConfig.FormCreate(Sender: TObject);
begin
  edtHostname.Text   := Config.Database.Servidor;
  edtDatabase.Text   := Config.Database.Database;
  edtUser.Text       := Config.Database.Usuario;
  edtPassword.Text   := Config.Database.Senha;
  ckbAuthent.Checked := Config.Database.AutenticacaoLocal;
end;

procedure TfrmConfig.btnSaveClick(Sender: TObject);
begin
  Config.Database.Servidor := edtHostname.Text;
  Config.Database.Database := edtDatabase.Text;
  Config.Database.Usuario  := edtUser.Text;
  Config.Database.Senha    := edtPassword.Text;
  Config.Database.AutenticacaoLocal := ckbAuthent.Checked;

  ModalResult := mrOk;
end;

end.
