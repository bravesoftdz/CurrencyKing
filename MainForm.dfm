object frmMain: TfrmMain
  Left = 0
  Top = 0
  AlphaBlend = True
  BorderStyle = bsToolWindow
  Caption = 'Currency Converter'
  ClientHeight = 49
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  ScreenSnap = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblArrow: TLabel
    Left = 111
    Top = 11
    Width = 53
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = '->'
    Enabled = False
  end
  object lblUpdated: TLabel
    Left = 8
    Top = 35
    Width = 257
    Height = 13
    Alignment = taCenter
    AutoSize = False
    Caption = 'Exchange Rates Correct as of'
    OnClick = lblUpdatedClick
  end
  object editIn: TEdit
    Left = 8
    Top = 8
    Width = 97
    Height = 21
    Alignment = taCenter
    TabOrder = 0
    OnChange = editInChange
  end
  object editOut: TEdit
    Left = 170
    Top = 8
    Width = 97
    Height = 21
    Alignment = taCenter
    Enabled = False
    TabOrder = 1
    Text = #8364'0.00'
  end
  object trayIcon: TTrayIcon
    PopupMenu = trayMenu
    Visible = True
    OnClick = trayIconClick
    Left = 32
  end
  object trayMenu: TPopupMenu
    Left = 8
    object CurrencyConverter1: TMenuItem
      Caption = 'Currency Converter'
      Enabled = False
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Update1: TMenuItem
      Caption = 'Update Rates'
      OnClick = Update1Click
    end
    object Exit1: TMenuItem
      Caption = 'Exit'
      OnClick = Exit1Click
    end
  end
end
