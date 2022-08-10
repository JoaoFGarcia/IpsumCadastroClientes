object frmConfig: TfrmConfig
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Configura'#231#245'es'
  ClientHeight = 162
  ClientWidth = 267
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 88
    Height = 13
    Caption = 'Nome do servidor:'
  end
  object Label2: TLabel
    Left = 136
    Top = 8
    Width = 50
    Height = 13
    Caption = 'Database:'
  end
  object Label3: TLabel
    Left = 8
    Top = 48
    Width = 40
    Height = 13
    Caption = 'Usu'#225'rio:'
  end
  object Label4: TLabel
    Left = 136
    Top = 48
    Width = 34
    Height = 13
    Caption = 'Senha:'
  end
  object edtHostname: TEdit
    Left = 8
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object edtDatabase: TEdit
    Left = 136
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 1
  end
  object edtUser: TEdit
    Left = 8
    Top = 64
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object edtPassword: TEdit
    Left = 135
    Top = 64
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 3
  end
  object ckbAuthent: TCheckBox
    Left = 8
    Top = 91
    Width = 248
    Height = 17
    Caption = 'Usar autentica'#231#227'o do sistema operacional'
    TabOrder = 4
    OnClick = ckbAuthentClick
  end
  object btnSave: TIpsumButton
    Left = 8
    Top = 120
    Width = 248
    Height = 26
    Alignment = taCenter
    BevelOuter = bvNone
    Caption = 'Salvar'
    Color = 10443520
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWhite
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentBackground = False
    ShowCaption = False
    TabOrder = 5
    OnClick = btnSaveClick
    Down = False
    HotColor = 13990400
    IconSize = 0
  end
end
