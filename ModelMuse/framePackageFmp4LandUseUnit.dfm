inherited framePackageFmp4LandUse: TframePackageFmp4LandUse
  Height = 516
  ExplicitHeight = 516
  DesignSize = (
    422
    516)
  inherited memoComments: TMemo
    Height = 43
    ExplicitHeight = 43
  end
  object cpnlgrp1: TCategoryPanelGroup [3]
    Left = 0
    Top = 111
    Width = 422
    Height = 405
    VertScrollBar.Tracking = True
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -12
    HeaderFont.Name = 'Segoe UI'
    HeaderFont.Style = []
    TabOrder = 1
    object cpnlPrint: TCategoryPanel
      Top = 0
      Height = 229
      Caption = 'Print'
      TabOrder = 0
      object clbPrint: TCheckListBox
        Left = 0
        Top = 0
        Width = 399
        Height = 162
        Align = alClient
        Enabled = False
        ItemHeight = 15
        Items.Strings = (
          'PRINT BYWBS'
          'PRINT BYWBS_BYCROP'
          'PRINT BYCROP'
          'PRINT BARE'
          'PRINT ALL'
          'PRINT ALL_VERBOSE'
          'PRINT ET_BYWBS_BYCROP'
          'PRINT ROW_COLUMN')
        TabOrder = 0
        ExplicitHeight = 132
      end
      object pnl2: TPanel
        Left = 0
        Top = 162
        Width = 399
        Height = 41
        Align = alBottom
        TabOrder = 1
        ExplicitTop = 132
        object lblSpecifyCrops: TLabel
          Left = 164
          Top = 8
          Width = 112
          Height = 15
          Caption = 'Specify crops to print'
        end
        object comboSpecifyCrops: TComboBox
          Left = 13
          Top = 6
          Width = 145
          Height = 23
          Style = csDropDownList
          Enabled = False
          ItemIndex = 0
          TabOrder = 0
          Text = 'Don'#39't use'
          Items.Strings = (
            'Don'#39't use'
            'Static'
            'Transient')
        end
      end
    end
    object cpnlOptions: TCategoryPanel
      Top = 229
      Height = 371
      Caption = 'Land Use Options'
      TabOrder = 1
      ExplicitTop = 199
      object rdgSoils: TRbwDataGrid4
        Left = 0
        Top = 89
        Width = 399
        Height = 256
        Align = alClient
        ColCount = 4
        Enabled = False
        FixedCols = 1
        RowCount = 15
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
        TabOrder = 0
        OnSelectCell = rdgSoilsSelectCell
        ExtendedAutoDistributeText = False
        AutoMultiEdit = False
        AutoDistributeText = False
        AutoIncreaseColCount = False
        AutoIncreaseRowCount = False
        SelectedRowOrColumnColor = clAqua
        UnselectableColor = clBtnFace
        ColorRangeSelection = False
        Columns = <
          item
            AutoAdjustRowHeights = False
            AutoAdjustCaptionRowHeights = True
            ButtonCaption = '...'
            ButtonFont.Charset = DEFAULT_CHARSET
            ButtonFont.Color = clWindowText
            ButtonFont.Height = -12
            ButtonFont.Name = 'Segoe UI'
            ButtonFont.Style = []
            ButtonUsed = False
            ButtonWidth = 20
            CheckMax = False
            CheckMin = False
            ComboUsed = False
            Format = rcf4String
            LimitToList = False
            MaxLength = 0
            ParentButtonFont = False
            WordWrapCaptions = True
            WordWrapCells = False
            CaseSensitivePicklist = False
            CheckStyle = csCheck
            AutoAdjustColWidths = True
          end
          item
            AutoAdjustRowHeights = True
            AutoAdjustCaptionRowHeights = True
            ButtonCaption = '...'
            ButtonFont.Charset = DEFAULT_CHARSET
            ButtonFont.Color = clWindowText
            ButtonFont.Height = -12
            ButtonFont.Name = 'Segoe UI'
            ButtonFont.Style = []
            ButtonUsed = False
            ButtonWidth = 20
            CheckMax = False
            CheckMin = False
            ComboUsed = True
            Format = rcf4String
            LimitToList = True
            MaxLength = 0
            ParentButtonFont = False
            WordWrapCaptions = True
            WordWrapCells = False
            CaseSensitivePicklist = False
            CheckStyle = csCheck
            AutoAdjustColWidths = True
          end
          item
            AutoAdjustRowHeights = True
            AutoAdjustCaptionRowHeights = True
            ButtonCaption = '...'
            ButtonFont.Charset = DEFAULT_CHARSET
            ButtonFont.Color = clWindowText
            ButtonFont.Height = -12
            ButtonFont.Name = 'Segoe UI'
            ButtonFont.Style = []
            ButtonUsed = False
            ButtonWidth = 20
            CheckMax = False
            CheckMin = False
            ComboUsed = True
            Format = rcf4String
            LimitToList = True
            MaxLength = 0
            ParentButtonFont = False
            PickList.Strings = (
              'Array'
              'List')
            WordWrapCaptions = True
            WordWrapCells = False
            CaseSensitivePicklist = False
            CheckStyle = csCheck
            AutoAdjustColWidths = True
          end
          item
            AutoAdjustRowHeights = True
            AutoAdjustCaptionRowHeights = True
            ButtonCaption = '...'
            ButtonFont.Charset = DEFAULT_CHARSET
            ButtonFont.Color = clWindowText
            ButtonFont.Height = -12
            ButtonFont.Name = 'Segoe UI'
            ButtonFont.Style = []
            ButtonUsed = False
            ButtonWidth = 20
            CheckMax = False
            CheckMin = False
            ComboUsed = True
            Format = rcf4String
            LimitToList = True
            MaxLength = 0
            ParentButtonFont = False
            PickList.Strings = (
              'Crop coefficient'
              'Consumptive use')
            WordWrapCaptions = True
            WordWrapCells = False
            CaseSensitivePicklist = False
            CheckStyle = csCheck
            AutoAdjustColWidths = True
          end>
        WordWrapRowCaptions = False
      end
      object pnl1: TPanel
        Left = 0
        Top = 0
        Width = 399
        Height = 89
        Align = alTop
        TabOrder = 1
        object lblLandUsePerCell: TLabel
          Left = 168
          Top = 11
          Width = 88
          Height = 15
          Caption = 'Land use per cell'
        end
        object lblMinimumBareFraction: TLabel
          Left = 167
          Top = 35
          Width = 123
          Height = 15
          Caption = 'Minimum bare fraction'
        end
        object lblRelaxFracHeadChange: TLabel
          Left = 167
          Top = 63
          Width = 178
          Height = 15
          Caption = 'Relaxation factor for head change'
        end
        object comboLandUsePerCell: TComboBox
          Left = 13
          Top = 3
          Width = 145
          Height = 23
          Enabled = False
          ItemIndex = 0
          TabOrder = 0
          Text = 'Single'
          Items.Strings = (
            'Single'
            'Multiple')
        end
        object rdeMinimumBareFraction: TRbwDataEntry
          Left = 13
          Top = 32
          Width = 145
          Height = 22
          Color = clBtnFace
          Enabled = False
          TabOrder = 1
          Text = '0'
          DataType = dtReal
          Max = 1.000000000000000000
          CheckMin = True
          ChangeDisabledColor = True
        end
        object rdeRelaxFracHeadChange: TRbwDataEntry
          Left = 13
          Top = 60
          Width = 145
          Height = 22
          Color = clBtnFace
          Enabled = False
          TabOrder = 2
          Text = '0'
          DataType = dtReal
          Max = 1.000000000000000000
          CheckMin = True
          ChangeDisabledColor = True
        end
      end
    end
  end
  inherited rcSelectionController: TRbwController
    ControlList = <
      item
        Control = lblComments
      end
      item
        Control = memoComments
      end
      item
        Control = clbPrint
      end
      item
        Control = comboSpecifyCrops
      end
      item
        Control = comboLandUsePerCell
      end
      item
        Control = rdeMinimumBareFraction
      end
      item
        Control = rdeRelaxFracHeadChange
      end
      item
        Control = rdgSoils
      end>
  end
end