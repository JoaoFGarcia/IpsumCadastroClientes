inherited frmEmployeeList: TfrmEmployeeList
  Tag = 1
  Caption = 'Manuten'#231#227'o de Funcion'#225'rios'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pgcMain: TPageControl
    inherited tbsList: TTabSheet
      inherited dbgData: TDBGrid
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        Columns = <
          item
            Expanded = False
            FieldName = 'id'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'nome'
            Width = 300
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'cargo'
            Width = 150
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'salario'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'datahora_criacao'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'equipe'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'equipe_descricao'
            Width = 300
            Visible = True
          end>
      end
    end
    inherited tbsMaintenance: TTabSheet
      DesignSize = (
        634
        263)
      object Label1: TLabel [0]
        Left = 3
        Top = 39
        Width = 33
        Height = 13
        Caption = 'C'#243'digo'
      end
      object Label2: TLabel [1]
        Left = 243
        Top = 39
        Width = 27
        Height = 13
        Caption = 'Nome'
      end
      object Label3: TLabel [2]
        Left = 138
        Top = 39
        Width = 29
        Height = 13
        Caption = 'Cargo'
      end
      object Label4: TLabel [3]
        Left = 43
        Top = 39
        Width = 62
        Height = 13
        Caption = 'Data Cria'#231#227'o'
      end
      object Label5: TLabel [4]
        Left = 3
        Top = 133
        Width = 63
        Height = 13
        Caption = 'Observa'#231#245'es'
      end
      object lblSalario: TLabel [5]
        Left = 1
        Top = 85
        Width = 32
        Height = 13
        Caption = 'Sal'#225'rio'
      end
      object Label6: TLabel [6]
        Left = 79
        Top = 85
        Width = 32
        Height = 13
        Caption = 'Equipe'
      end
      object dbeID: TDBEdit
        Left = 3
        Top = 58
        Width = 33
        Height = 21
        DataField = 'id'
        DataSource = dsMain
        Enabled = False
        ReadOnly = True
        TabOrder = 1
      end
      object dbeDescricao: TDBEdit
        Left = 243
        Top = 58
        Width = 388
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'nome'
        DataSource = dsMain
        TabOrder = 4
      end
      object cboCargo: TComboBox
        Left = 138
        Top = 58
        Width = 93
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 3
        Text = 'Administrador'
        Items.Strings = (
          'Administrador'
          'Desenvolvedor'
          'L'#237'der'
          'Gestor')
      end
      object dtpCriacao: TDateTimePicker
        Left = 41
        Top = 58
        Width = 91
        Height = 21
        Date = 44782.000000000000000000
        Time = 0.739915486112295200
        TabOrder = 2
      end
      object dbeObs: TDBMemo
        Left = 3
        Top = 160
        Width = 628
        Height = 100
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataField = 'observacao'
        DataSource = dsMain
        TabOrder = 7
      end
      object dbeSalario: TDBEdit
        Left = 1
        Top = 104
        Width = 72
        Height = 21
        DataField = 'salario'
        DataSource = dsMain
        TabOrder = 5
        OnKeyPress = dbeSalarioKeyPress
      end
      object cboEquipe: TDBLookupComboBox
        Left = 79
        Top = 104
        Width = 145
        Height = 21
        DataField = 'equipe'
        DataSource = dsMain
        KeyField = 'id'
        ListField = 'descricao'
        ListSource = dsEquipe
        TabOrder = 6
      end
    end
  end
  inherited cdsMain: TClientDataSet
    FilterOptions = [foCaseInsensitive]
    AfterScroll = cdsMainAfterScroll
    Left = 472
    Top = 168
    object cdsMainid: TIntegerField
      DisplayLabel = 'ID'
      FieldName = 'id'
    end
    object cdsMainnome: TStringField
      Tag = 1
      DisplayLabel = 'Nome'
      FieldName = 'nome'
      Size = 200
    end
    object cdsMaincargo: TStringField
      Tag = 1
      DisplayLabel = 'Cargo'
      FieldName = 'cargo'
      Size = 200
    end
    object cdsMainsalario: TFMTBCDField
      DisplayLabel = 'Sal'#225'rio'
      FieldName = 'salario'
      DisplayFormat = 'R$ 0.00'
      Size = 18
    end
    object cdsMainequipe: TIntegerField
      Tag = 1
      DisplayLabel = 'Equipe'
      FieldName = 'equipe'
    end
    object cdsMainequipe_descricao: TStringField
      Tag = 1
      DisplayLabel = 'Eq. Descri'#231#227'o'
      FieldName = 'equipe_descricao'
      Size = 200
    end
    object cdsMaindatahora_criacao: TDateTimeField
      DisplayLabel = 'Data cria'#231#227'o'
      FieldName = 'datahora_criacao'
    end
    object cdsMainobservacao: TStringField
      FieldName = 'observacao'
      Size = 300
    end
  end
  inherited dsMain: TDataSource
    Left = 504
    Top = 168
  end
  object cdsEquipe: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 356
    Top = 136
    object cdsEquipeid: TIntegerField
      Tag = 1
      DisplayLabel = 'ID'
      FieldName = 'id'
    end
    object cdsEquipedescricao: TStringField
      Tag = 1
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'descricao'
      Size = 200
    end
    object cdsEquipesetor: TStringField
      Tag = 1
      DisplayLabel = 'Setor'
      FieldName = 'setor'
      Size = 200
    end
    object cdsEquipeobservacao: TStringField
      DisplayLabel = 'Observa'#231#227'o'
      FieldName = 'observacao'
      Size = 300
    end
    object cdsEquipedatahora_criacao: TDateTimeField
      DisplayLabel = 'Data de Cria'#231#227'o'
      FieldName = 'datahora_criacao'
    end
  end
  object dsEquipe: TDataSource
    DataSet = cdsEquipe
    Left = 392
    Top = 136
  end
end
