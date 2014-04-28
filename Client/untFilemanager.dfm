object Form2: TForm2
  Left = 811
  Top = 257
  Width = 514
  Height = 426
  Caption = 'Form2'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object ComboBox1: TComboBox
    Left = 8
    Top = 8
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object Edit1: TEdit
    Left = 160
    Top = 8
    Width = 345
    Height = 21
    TabOrder = 1
    Text = 'Edit1'
  end
  object ListView1: TListView
    Left = 8
    Top = 32
    Width = 497
    Height = 361
    Columns = <
      item
        AutoSize = True
        Caption = 'Name'
      end
      item
        AutoSize = True
        Caption = 'Size'
        MaxWidth = 100
      end>
    TabOrder = 2
    ViewStyle = vsReport
  end
end
