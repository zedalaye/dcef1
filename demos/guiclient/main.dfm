object Form4: TForm4
  Left = 276
  Top = 194
  ActiveControl = edAddress
  Caption = 'Chromium Embedded'
  ClientHeight = 453
  ClientWidth = 768
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    768
    453)
  PixelsPerInch = 96
  TextHeight = 13
  object SpeedButton1: TSpeedButton
    Left = 0
    Top = 0
    Width = 23
    Height = 22
    Action = actPrev
  end
  object SpeedButton2: TSpeedButton
    Left = 24
    Top = 0
    Width = 23
    Height = 22
    Action = actNext
  end
  object SpeedButton3: TSpeedButton
    Left = 48
    Top = 0
    Width = 23
    Height = 22
    Action = actHome
    Caption = 'H'
  end
  object SpeedButton4: TSpeedButton
    Left = 72
    Top = 0
    Width = 23
    Height = 22
    Action = actReload
    Caption = 'R'
  end
  object SpeedButton5: TSpeedButton
    Left = 745
    Top = -1
    Width = 23
    Height = 22
    Action = actGoTo
    Anchors = [akTop, akRight]
  end
  object crm: TChromium
    Left = 0
    Top = 24
    Width = 768
    Height = 410
    Align = alBottom
    Anchors = [akLeft, akTop, akRight, akBottom]
    DefaultUrl = 'http://www.google.com'
    OnAfterCreated = crmAfterCreated
    OnAddressChange = crmAddressChange
    OnTitleChange = crmTitleChange
    OnLoadStart = crmLoadStart
    OnLoadEnd = crmLoadEnd
    OnBeforeWindowClose = crmBeforeWindowClose
  end
  object edAddress: TEdit
    Left = 95
    Top = 0
    Width = 650
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 1
    Text = 'http://www.google.com'
    OnKeyPress = edAddressKeyPress
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 434
    Width = 768
    Height = 19
    Panels = <>
    SimplePanel = True
  end
  object ActionList: TActionList
    Left = 624
    Top = 32
    object actPrev: TAction
      Caption = '<-'
      Enabled = False
      OnExecute = actPrevExecute
      OnUpdate = actPrevUpdate
    end
    object actNext: TAction
      Caption = '->'
      Enabled = False
      OnExecute = actNextExecute
      OnUpdate = actNextUpdate
    end
    object actHome: TAction
      Caption = 'actHome'
      OnExecute = actHomeExecute
      OnUpdate = actHomeUpdate
    end
    object actReload: TAction
      Caption = 'actReload'
      OnExecute = actReloadExecute
      OnUpdate = actReloadUpdate
    end
    object actGoTo: TAction
      Caption = '>'
      OnExecute = actGoToExecute
    end
  end
end
