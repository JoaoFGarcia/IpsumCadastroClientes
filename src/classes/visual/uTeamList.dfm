inherited frmTeamList: TfrmTeamList
  Caption = 'Manuten'#231#227'o de Equipes'
  PixelsPerInch = 96
  TextHeight = 13
  inherited pgcMain: TPageControl
    inherited tbsList: TTabSheet
      inherited dbgData: TDBGrid
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        Columns = <
          item
            Alignment = taCenter
            Expanded = False
            FieldName = 'id'
            Title.Alignment = taCenter
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'descricao'
            Width = 200
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'setor'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'datahora_criacao'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'observacao'
            Width = 300
            Visible = True
          end>
      end
    end
    inherited tbsMaintenance: TTabSheet
      object Label1: TLabel [0]
        Left = 3
        Top = 39
        Width = 33
        Height = 13
        Caption = 'C'#243'digo'
      end
      object Label2: TLabel [1]
        Left = 291
        Top = 39
        Width = 46
        Height = 13
        Caption = 'Descri'#231#227'o'
      end
      object Label3: TLabel [2]
        Left = 138
        Top = 39
        Width = 26
        Height = 13
        Caption = 'Setor'
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
        Top = 85
        Width = 63
        Height = 13
        Caption = 'Observa'#231#245'es'
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
        Left = 291
        Top = 58
        Width = 340
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        DataField = 'descricao'
        DataSource = dsMain
        TabOrder = 4
      end
      object cboSetor: TComboBox
        Left = 138
        Top = 58
        Width = 145
        Height = 21
        Style = csDropDownList
        ItemIndex = 0
        TabOrder = 3
        Text = 'Administra'#231#227'o'
        Items.Strings = (
          'Administra'#231#227'o'
          'Almoxarifado'
          'Tecnologia')
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
        Top = 104
        Width = 628
        Height = 156
        Anchors = [akLeft, akTop, akRight, akBottom]
        DataField = 'observacao'
        DataSource = dsMain
        TabOrder = 5
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
    object cdsMaindescricao: TStringField
      Tag = 1
      DisplayLabel = 'Descri'#231#227'o'
      FieldName = 'descricao'
      Size = 200
    end
    object cdsMainsetor: TStringField
      Tag = 1
      DisplayLabel = 'Setor'
      FieldName = 'setor'
      Size = 200
    end
    object cdsMainobservacao: TStringField
      DisplayLabel = 'Observa'#231#227'o'
      FieldName = 'observacao'
      Size = 300
    end
    object cdsMaindatahora_criacao: TDateTimeField
      DisplayLabel = 'Data de Cria'#231#227'o'
      FieldName = 'datahora_criacao'
    end
  end
  inherited dsMain: TDataSource
    Left = 504
    Top = 168
  end
end
