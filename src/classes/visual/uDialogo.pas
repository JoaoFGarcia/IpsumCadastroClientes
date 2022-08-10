unit uDialogo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Buttons, Vcl.Imaging.pngimage, Vcl.ImgList, ImageList;

type
  TTipoMsg   = (tmAviso, tmErro, tmInfo, tmConfirmacao);
  TTiposMsg  = set of TTipoMsg;
  TBotaoMsg  = (bmOk, bmSim, bmNao);
  TBotoesMsg = set of TBotaoMsg;
  TfrmDialogo = class(TForm)
    pnlBorders: TPanel;
    pnlFundo: TPanel;
    pnlButtons: TPanel;
    pnlOK: TPanel;
    pnlNao: TPanel;
    pnlSim: TPanel;
    imgTipo: TImage;
    imgInfo: TImage;
    imgAlerta: TImage;
    imgErro: TImage;
    imgConfirmacao: TImage;
    lblMensagem: TLabel;
    procedure pnlOKClick(Sender: TObject);
    procedure pnlNaoClick(Sender: TObject);
    procedure pnlSimClick(Sender: TObject);
    procedure PanelEnter(Sender: TObject);
    procedure PanelLeave(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MoveByClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlBordersMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure pnlButtonsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
  private
    procedure DefinirBotoes(Botoes : TBotoesMsg);
    procedure DefinirTipo(Tipo: TTipoMsg);
    procedure DefinirMensagem(Mensagem : String);

    { Private declarations }
  public
    { Public declarations }
  end;

var
  sInput     : String;
  frmDialogo : TfrmDialogo;

  function ExibirMensagem(Mensagem : String; Tipo : TTipoMsg; Botoes : TBotoesMsg; AInput : Boolean = false; APassworded : Boolean = false) : Integer;
  function Alerta(Mensagem : String) : Integer;
  function Erro(Mensagem : String) : Integer;
  function Confirmacao(Mensagem : String) : Integer; overload;
  function Confirmacao(Mensagem : String; out SInputContent : String; APassword : Boolean = false) : Integer; overload;
  function Informacao(Mensagem : String) : Integer;

implementation

function ExibirMensagem(Mensagem : String; Tipo : TTipoMsg; Botoes : TBotoesMsg; AInput : Boolean = false; APassworded : Boolean = false) : Integer;
begin
  frmDialogo := TfrmDialogo.Create(nil);
  try
    with frmDialogo do
    begin
      DefinirBotoes(Botoes);
      DefinirTipo(Tipo);
      DefinirMensagem(Mensagem);
      Result := ShowModal;
    end;
  finally
    FreeAndNil(frmDialogo);
  end;
end;

function Informacao(Mensagem : String) : Integer;
begin
  Result := ExibirMensagem(Mensagem, tmInfo, [bmOk]);
end;

function Alerta(Mensagem : String) : Integer;
begin
  Result := ExibirMensagem(Mensagem, tmAviso, [bmOk]);
end;

function Erro(Mensagem : String) : Integer;
begin
  Result := ExibirMensagem(Mensagem, tmErro, [bmOk]);
end;

function Confirmacao(Mensagem : String) : Integer;
begin
  Result := ExibirMensagem(Mensagem, tmConfirmacao, [bmSim, bmNao]);
end;

function Confirmacao(Mensagem : String; out SInputContent : String; APassword : Boolean = false) : Integer;
begin
  Result        := ExibirMensagem(Mensagem, tmAviso, [bmSim, bmNao], True, APassword);
  SInputContent := sInput;
end;

{$R *.dfm}

procedure TfrmDialogo.pnlBordersMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MoveByClick(Sender, Button, Shift, X, Y);
end;

procedure TfrmDialogo.CreateParams(var Params: TCreateParams);
begin
  inherited;
  Params.WindowClass.Style := Params.WindowClass.Style or $00020000;
end;

procedure TfrmDialogo.pnlButtonsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  MoveByClick(Sender, Button, Shift, X, Y);
end;

procedure TfrmDialogo.pnlNaoClick(Sender: TObject);
begin
  ModalResult := mrNo;
end;

procedure TfrmDialogo.pnlOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TfrmDialogo.pnlSimClick(Sender: TObject);
begin
  ModalResult := mrYes;
end;

procedure TfrmDialogo.PanelEnter(Sender: TObject);
begin
  (Sender as TPanel).Color := RGB(11, 46, 104);
end;

procedure TfrmDialogo.PanelLeave(Sender: TObject);
begin
  (Sender as TPanel).Color := $00C17100;
end;

procedure TfrmDialogo.DefinirBotoes(Botoes : TBotoesMsg);
begin
  if bmSim in (Botoes) then
    pnlSim.Visible := True;
  if bmNao in (Botoes) then
    pnlNao.Visible := True;
  if (bmOk in (Botoes)) and not (bmSim in (Botoes)) then
    pnlOk.Visible := True;
end;

procedure TfrmDialogo.DefinirTipo(Tipo : TTipoMsg);
begin
  case Tipo of
    tmAviso      : imgTipo.Picture := imgAlerta.Picture;
    tmErro       : imgTipo.Picture := imgErro.Picture;
    tmInfo       : imgTipo.Picture := imgInfo.Picture;
    tmConfirmacao: imgTipo.Picture := imgConfirmacao.Picture;
  end;
end;

procedure TfrmDialogo.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Key = 13) or (Key = 112) and (pnlOk.Visible) then
    pnlOKClick(pnlOK);
  if (Key = 13) or (Key = 112) and (pnlSim.Visible) then
    pnlSimClick(pnlSim);
  if (Key = 27) or (Key = 113) and (pnlNao.Visible) then
    pnlNaoClick(pnlNao);
end;

procedure TfrmDialogo.DefinirMensagem(Mensagem : String);
begin
  lblMensagem.Caption := Mensagem;
end;

procedure TfrmDialogo.MoveByClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
const
  SC_DRAGMOVE = $F012;
begin
  if Button = mbLeft then
  begin
    ReleaseCapture;
    Perform(WM_SYSCOMMAND, SC_DRAGMOVE, 0);
  end;
end;

end.
