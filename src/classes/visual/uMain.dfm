object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Cadastro de Equipes'
  ClientHeight = 375
  ClientWidth = 818
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlMenu: TPanel
    Left = 0
    Top = 0
    Width = 818
    Height = 57
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnlMenu'
    Color = 10443520
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    object btnConfig: TIpsumButton
      Left = 665
      Top = 0
      Width = 153
      Height = 57
      Align = alRight
      BevelOuter = bvNone
      Caption = 'Configura'#231#245'es'
      Color = 10443520
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ShowCaption = False
      TabOrder = 0
      OnClick = btnConfigClick
      Down = False
      HotColor = 13990400
      ImageList = dmMain.imlButtons32
      ImageIndex = 1
    end
    object btnCadFuncionario: TIpsumButton
      Left = 185
      Top = 0
      Width = 217
      Height = 57
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Cadastro de Funcion'#225'rios'
      Color = 10443520
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ShowCaption = False
      TabOrder = 1
      OnClick = btnCadFuncionarioClick
      Down = False
      HotColor = 13990400
      ImageList = dmMain.imlButtons32
      ImageIndex = 2
    end
    object btnCadEquipe: TIpsumButton
      Left = 0
      Top = 0
      Width = 185
      Height = 57
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Cadastro de Equipes'
      Color = 10443520
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ShowCaption = False
      TabOrder = 2
      OnClick = btnCadEquipeClick
      Down = False
      HotColor = 13990400
      ImageList = dmMain.imlButtons32
      ImageIndex = 0
    end
    object IpsumButton1: TIpsumButton
      Left = 402
      Top = 0
      Width = 119
      Height = 57
      Align = alLeft
      BevelOuter = bvNone
      Caption = 'Relat'#243'rio'
      Color = 10443520
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentBackground = False
      ShowCaption = False
      TabOrder = 3
      OnClick = IpsumButton1Click
      Down = False
      HotColor = 13990400
      ImageList = dmMain.imlButtons32
      ImageIndex = 3
    end
  end
  object pgcMain: TPageControl
    Left = 0
    Top = 57
    Width = 818
    Height = 318
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    TabOrder = 1
  end
  object frxReport: TfrxReport
    Version = '6.9.14'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick, pbCopy, pbSelection]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 44782.912401979200000000
    ReportOptions.LastChange = 44782.948895196760000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    Left = 480
    Top = 216
    Datasets = <
      item
        DataSet = frxDBDataset
        DataSetName = 'frxDBDataset'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 215.900000000000000000
      PaperHeight = 279.400000000000000000
      PaperSize = 1
      LeftMargin = 10.000000000000000000
      RightMargin = 10.000000000000000000
      TopMargin = 10.000000000000000000
      BottomMargin = 10.000000000000000000
      Frame.Typ = []
      MirrorMode = []
      object rTitle: TfrxReportTitle
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 22.677180000000000000
        Top = 18.897650000000000000
        Width = 740.409927000000000000
        object Memo1: TfrxMemoView
          Align = baClient
          AllowVectorExport = True
          Width = 740.409927000000000000
          Height = 22.677180000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          HAlign = haCenter
          Memo.UTF8W = (
            'RELAT'#211'RIO DE FUNCION'#193'RIOS')
          ParentFont = False
        end
      end
      object PageHeader1: TfrxPageHeader
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 41.574830000000000000
        Top = 64.252010000000000000
        Width = 740.409927000000000000
        object Memo4: TfrxMemoView
          AllowVectorExport = True
          Left = 37.795300000000000000
          Top = 22.677180000000000000
          Width = 226.771800000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Nome')
          ParentFont = False
        end
        object Memo5: TfrxMemoView
          AllowVectorExport = True
          Left = 264.567100000000000000
          Top = 22.677180000000000000
          Width = 139.842610000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Cargo')
          ParentFont = False
        end
        object Memo6: TfrxMemoView
          AllowVectorExport = True
          Left = 408.189240000000000000
          Top = 22.677180000000000000
          Width = 139.842610000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Sal'#225'rio')
          ParentFont = False
        end
      end
      object MasterData1: TfrxMasterData
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 15.118120000000000000
        Top = 166.299320000000000000
        Width = 740.409927000000000000
        DataSet = frxDBDataset
        DataSetName = 'frxDBDataset'
        RowCount = 0
      end
      object GroupHeader1: TfrxGroupHeader
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Height = 18.897650000000000000
        Top = 204.094620000000000000
        Width = 740.409927000000000000
        Condition = 'frxDBDataset."equipe"'
        object Memo2: TfrxMemoView
          AllowVectorExport = True
          Width = 56.692950000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Equipe:')
          ParentFont = False
        end
        object Memo3: TfrxMemoView
          AllowVectorExport = True
          Left = 60.472480000000000000
          Width = 672.756340000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDataset."equipe"] - [frxDBDataset."equipe_descricao"]')
          ParentFont = False
          Formats = <
            item
            end
            item
            end>
        end
      end
      object GroupFooter1: TfrxGroupFooter
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = []
        Height = 45.354360000000000000
        Top = 287.244280000000000000
        Width = 740.409927000000000000
        object Memo10: TfrxMemoView
          AllowVectorExport = True
          Width = 56.692950000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            'Totais:')
          ParentFont = False
        end
        object Memo11: TfrxMemoView
          AllowVectorExport = True
          Left = 408.189240000000000000
          Width = 139.842610000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = 'R$ %2.2n'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Frame.Typ = []
          Memo.UTF8W = (
            '[SUM(<frxDBDataset."salario">,DetailData1)]')
          ParentFont = False
        end
      end
      object DetailData1: TfrxDetailData
        FillType = ftBrush
        FillGap.Top = 0
        FillGap.Left = 0
        FillGap.Bottom = 0
        FillGap.Right = 0
        Frame.Typ = [ftLeft, ftRight, ftTop, ftBottom]
        Height = 18.897650000000000000
        Top = 245.669450000000000000
        Width = 740.409927000000000000
        DataSet = frxDBDataset
        DataSetName = 'frxDBDataset'
        RowCount = 0
        object Memo7: TfrxMemoView
          AllowVectorExport = True
          Left = 37.795300000000000000
          Width = 226.771800000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDataset."nome"]')
          ParentFont = False
        end
        object Memo8: TfrxMemoView
          AllowVectorExport = True
          Left = 264.567100000000000000
          Width = 139.842610000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDataset."cargo"]')
          ParentFont = False
        end
        object Memo9: TfrxMemoView
          AllowVectorExport = True
          Left = 408.189240000000000000
          Width = 139.842610000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = ','
          DisplayFormat.FormatStr = 'R$ %2.2n'
          DisplayFormat.Kind = fkNumeric
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Frame.Typ = []
          Memo.UTF8W = (
            '[frxDBDataset."salario"]')
          ParentFont = False
        end
      end
    end
  end
  object frxDBDataset: TfrxDBDataset
    UserName = 'frxDBDataset'
    CloseDataSource = False
    DataSet = cdsRel
    BCDToCurrency = False
    Left = 448
    Top = 216
  end
  object cdsRel: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 536
    Top = 216
    object cdsRelid: TIntegerField
      DisplayLabel = 'ID'
      FieldName = 'id'
    end
    object cdsRelnome: TStringField
      Tag = 1
      DisplayLabel = 'Nome'
      FieldName = 'nome'
      Size = 200
    end
    object cdsRelsalario: TFMTBCDField
      DisplayLabel = 'Sal'#225'rio'
      FieldName = 'salario'
      Size = 18
    end
    object cdsRelcargo: TStringField
      Tag = 1
      DisplayLabel = 'Cargo'
      FieldName = 'cargo'
      Size = 200
    end
    object cdsRelequipe: TIntegerField
      Tag = 1
      DisplayLabel = 'Equipe'
      FieldName = 'equipe'
    end
    object cdsRelequipe_descricao: TStringField
      Tag = 1
      DisplayLabel = 'Eq. Descri'#231#227'o'
      FieldName = 'equipe_descricao'
      Size = 200
    end
    object cdsRelsetor: TStringField
      Tag = 1
      DisplayLabel = 'Setor'
      FieldName = 'equipe_setor'
      Size = 200
    end
  end
end
