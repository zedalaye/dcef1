unit main;

interface
{$I cef.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cef, ceflib, Buttons, ComCtrls, ActnList, Menus;

type
  TMainForm = class(TForm)
    crm: TChromium;
    edAddress: TEdit;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    StatusBar: TStatusBar;
    ActionList: TActionList;
    actPrev: TAction;
    actNext: TAction;
    actHome: TAction;
    actReload: TAction;
    actGoTo: TAction;
    MainMenu: TMainMenu;
    File1: TMenuItem;
    est1: TMenuItem;
    mGetsource: TMenuItem;
    mGetText: TMenuItem;
    actGetSource: TAction;
    actGetText: TAction;
    actShowDevTools: TAction;
    Showdevtools1: TMenuItem;
    actCloseDevTools: TAction;
    Closedeveloppertools1: TMenuItem;
    actZoomIn: TAction;
    actZoomOut: TAction;
    actZoomReset: TAction;
    Zoomin1: TMenuItem;
    Zoomout1: TMenuItem;
    Zoomreset1: TMenuItem;
    actExecuteJS: TAction;
    ExecuteJavaScript1: TMenuItem;
    Exit1: TMenuItem;
    actPrint: TAction;
    Print1: TMenuItem;
    actFileScheme: TAction;
    actFileScheme1: TMenuItem;
    procedure edAddressKeyPress(Sender: TObject; var Key: Char);
    procedure actPrevExecute(Sender: TObject);
    procedure actNextExecute(Sender: TObject);
    procedure actHomeExecute(Sender: TObject);
    procedure actReloadExecute(Sender: TObject);
    procedure actPrevUpdate(Sender: TObject);
    procedure actNextUpdate(Sender: TObject);
    procedure actReloadUpdate(Sender: TObject);
    procedure actGoToExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actHomeUpdate(Sender: TObject);
    procedure crmAddressChange(Sender: TCustomChromium;
      const browser: ICefBrowser; const frame: ICefFrame; const url: ustring;
      out Result: TCefRetval);
    procedure crmLoadEnd(Sender: TCustomChromium; const browser: ICefBrowser;
      const frame: ICefFrame; isMainContent: Boolean; httpStatusCode: Integer; out Result: TCefRetval);
    procedure crmLoadStart(Sender: TCustomChromium; const browser: ICefBrowser;
      const frame: ICefFrame; isMainContent: Boolean; out Result: TCefRetval);
    procedure crmTitleChange(Sender: TCustomChromium;
      const browser: ICefBrowser; const title: ustring; out Result: TCefRetval);
    procedure actGetSourceExecute(Sender: TObject);
    procedure actGetTextExecute(Sender: TObject);
    procedure actShowDevToolsExecute(Sender: TObject);
    procedure actCloseDevToolsExecute(Sender: TObject);
    procedure actZoomInExecute(Sender: TObject);
    procedure actZoomOutExecute(Sender: TObject);
    procedure actZoomResetExecute(Sender: TObject);
    procedure actExecuteJSExecute(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure crmStatus(Sender: TCustomChromium; const browser: ICefBrowser;
      const value: ustring; StatusType: TCefHandlerStatusType;
      out Result: TCefRetval);
    procedure actPrintExecute(Sender: TObject);
    procedure actFileSchemeExecute(Sender: TObject);
  private
    { Déclarations privées }
    FCanGoBack: Boolean;
    FCanGoForward: Boolean;
    FLoading: Boolean;
  end;

var
  MainForm: TMainForm;

implementation
uses ceffilescheme;

{$R *.dfm}

procedure TMainForm.actCloseDevToolsExecute(Sender: TObject);
var
  brws: ICefBrowser;
begin
  brws := crm.Browser;
  if brws <> nil then
     brws.CloseDevTools;
end;

procedure TMainForm.actExecuteJSExecute(Sender: TObject);
var
  brws: ICefBrowser;
begin
  brws := crm.Browser;
  if brws <> nil then
    brws.MainFrame.ExecuteJavaScript(
      'alert(''JavaScript execute works!'');', 'about:blank', 0);
end;

procedure TMainForm.actFileSchemeExecute(Sender: TObject);
var
  brws: ICefBrowser;
begin
  brws := crm.Browser;
  if brws <> nil then
    brws.MainFrame.LoadUrl('file://c:');
end;

{$IFNDEF DELPHI12_UP}
procedure CallBackGetSource(const browser: ICefBrowser);
var
  source: ustring;
  frame: ICefFrame;
begin
  frame := browser.MainFrame;
  source := frame.Source;
  source := StringReplace(source, '<', '&lt;', [rfReplaceAll]);
  source := StringReplace(source, '>', '&gt;', [rfReplaceAll]);
  source := '<html><body>Source:<pre>' + source + '</pre></body></html>';
  frame.LoadString(source, 'http://tests/getsource');
end;
{$ENDIF}

procedure TMainForm.actGetSourceExecute(Sender: TObject);
{$IFDEF DELPHI12_UP}
var
  frame: ICefFrame;
  brws: ICefBrowser;
{$ENDIF}
begin
{$IFDEF DELPHI12_UP}
  brws := crm.Browser;
  if brws = nil then Exit;
  frame := brws.MainFrame;
  TCefFastTask.Post(TID_UI, procedure
    var
      source: ustring;
    begin
      source := frame.Source;
      source := StringReplace(source, '<', '&lt;', [rfReplaceAll]);
      source := StringReplace(source, '>', '&gt;', [rfReplaceAll]);
      source := '<html><body>Source:<pre>' + source + '</pre></body></html>';
      frame.LoadString(source, 'http://tests/getsource');
    end);
{$ELSE}
   TCefFastTask.Post(TID_UI, @CallBackGetSource, crm.Browser);
{$ENDIF}
end;

{$IFNDEF DELPHI12_UP}
procedure CallBackGetText(const browser: ICefBrowser);
var
  source: ustring;
  frame: ICefFrame;
begin
  frame := browser.MainFrame;
  source := frame.Text;
  source := StringReplace(source, '<', '&lt;', [rfReplaceAll]);
  source := StringReplace(source, '>', '&gt;', [rfReplaceAll]);
  source := '<html><body>Text:<pre>' + source + '</pre></body></html>';
  frame.LoadString(source, 'http://tests/gettext');
end;
{$ENDIF}

procedure TMainForm.actGetTextExecute(Sender: TObject);
{$IFDEF DELPHI12_UP}
var
  frame: ICefFrame;
  brws: ICefBrowser;
{$ENDIF}
begin
{$IFDEF DELPHI12_UP}
  brws := crm.Browser;
  if brws = nil then Exit;
  frame := brws.MainFrame;
  TCefFastTask.Post(TID_UI, procedure
    var
      source: ustring;
    begin
      source := frame.Text;
      source := StringReplace(source, '<', '&lt;', [rfReplaceAll]);
      source := StringReplace(source, '>', '&gt;', [rfReplaceAll]);
      source := '<html><body>Text:<pre>' + source + '</pre></body></html>';
      frame.LoadString(source, 'http://tests/gettext');
    end);
{$ELSE}
  TCefFastTask.Post(TID_UI, @CallBackGetText, crm.Browser);
{$ENDIF}
end;

procedure TMainForm.actGoToExecute(Sender: TObject);
var
  brws: ICefBrowser;
begin
  brws := crm.Browser;
  if brws <> nil then
    brws.MainFrame.LoadUrl(edAddress.Text);
end;

procedure TMainForm.actHomeExecute(Sender: TObject);
var
  brws: ICefBrowser;
begin
  brws := crm.Browser;
  if brws <> nil then
    brws.MainFrame.LoadUrl(crm.DefaultUrl);
end;

procedure TMainForm.actHomeUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := crm.Browser <> nil;
end;

procedure TMainForm.actNextExecute(Sender: TObject);
var
  brws: ICefBrowser;
begin
  brws := crm.Browser;
  if brws <> nil then
    brws.GoForward;
end;

procedure TMainForm.actNextUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := FCanGoForward;
end;

procedure TMainForm.actPrevExecute(Sender: TObject);
var
  brws: ICefBrowser;
begin
  brws := crm.Browser;
  if brws <> nil then
    brws.GoBack;
end;

procedure TMainForm.actPrevUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := FCanGoBack;
end;

procedure TMainForm.actPrintExecute(Sender: TObject);
var
  brws: ICefBrowser;
begin
  brws := crm.Browser;
  if brws <> nil then
    brws.MainFrame.Print;
end;

procedure TMainForm.actReloadExecute(Sender: TObject);
var
  brws: ICefBrowser;
begin
  brws := crm.Browser;
  if brws <> nil then
    if FLoading then
      brws.StopLoad else
      brws.Reload;
end;

procedure TMainForm.actReloadUpdate(Sender: TObject);
begin
  if FLoading then
    TAction(sender).Caption := 'X' else
    TAction(sender).Caption := 'R';
  TAction(Sender).Enabled := crm.Browser <> nil;
end;

procedure TMainForm.actShowDevToolsExecute(Sender: TObject);
var
  brws: ICefBrowser;
begin
  brws := crm.Browser;
  if brws <> nil then
    brws.ShowDevTools;
end;

procedure TMainForm.actZoomInExecute(Sender: TObject);
var
  brws: ICefBrowser;
begin
  brws := crm.Browser;
  if brws <> nil then
    brws.ZoomLevel := crm.Browser.ZoomLevel + 0.5;
end;

procedure TMainForm.actZoomOutExecute(Sender: TObject);
var
  brws: ICefBrowser;
begin
  brws := crm.Browser;
  if brws <> nil then
    brws.ZoomLevel := crm.Browser.ZoomLevel - 0.5;
end;

procedure TMainForm.actZoomResetExecute(Sender: TObject);
var
  brws: ICefBrowser;
begin
  brws := crm.Browser;
  if brws <> nil then
    brws.ZoomLevel := 0;
end;

procedure TMainForm.crmAddressChange(Sender: TCustomChromium;
  const browser: ICefBrowser; const frame: ICefFrame; const url: ustring;
  out Result: TCefRetval);
begin
  if (browser.GetWindowHandle = crm.BrowserHandle) and frame.IsMain then
{$IFDEF DELPHI12_UP}
    TThread.Queue(nil, procedure begin edAddress.Text := url end);
{$ELSE}
    SetWindowTextW(edAddress.Handle, PWideChar(url))
{$ENDIF}
end;

procedure TMainForm.crmLoadEnd(Sender: TCustomChromium; const browser: ICefBrowser;
  const frame: ICefFrame; isMainContent: Boolean; httpStatusCode: Integer;
  out Result: TCefRetval);
begin
  if (browser.GetWindowHandle = crm.BrowserHandle) and ((frame = nil) or (frame.IsMain)) then
  begin
    FCanGoBack := browser.CanGoBack;
    FCanGoForward := browser.CanGoForward;
    FLoading := False;
  end;
end;

procedure TMainForm.crmLoadStart(Sender: TCustomChromium;
  const browser: ICefBrowser; const frame: ICefFrame; isMainContent: Boolean; out Result: TCefRetval);
begin
  if (browser.GetWindowHandle = crm.BrowserHandle) and ((frame = nil) or (frame.IsMain)) then
    FLoading := True;
end;

procedure TMainForm.crmStatus(Sender: TCustomChromium;
  const browser: ICefBrowser; const value: ustring;
  StatusType: TCefHandlerStatusType; out Result: TCefRetval);
begin
{$IFDEF DELPHI12_UP}
  case StatusType of
    STATUSTYPE_MOUSEOVER_URL, STATUSTYPE_KEYBOARD_FOCUS_URL:
      TThread.Queue(nil, procedure begin
        StatusBar.SimpleText := value
      end);
  end;
{$ENDIF}
end;

procedure TMainForm.crmTitleChange(Sender: TCustomChromium;
  const browser: ICefBrowser; const title: ustring; out Result: TCefRetval);
begin
  if browser.GetWindowHandle = crm.BrowserHandle then
{$IFDEF DELPHI12_UP}
    TThread.Queue(nil, procedure begin Caption := title end);
{$ELSE}
    SetWindowTextW(MainForm.Handle, PWideChar(title))
{$ENDIF}
end;

procedure TMainForm.edAddressKeyPress(Sender: TObject; var Key: Char);
var
  brws: ICefBrowser;
begin
  if Key = #13 then
  begin
    brws := crm.Browser;
    if brws <> nil then
    begin
      brws.MainFrame.LoadUrl(edAddress.Text);
      Abort;
    end;
  end;
end;

procedure TMainForm.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FCanGoBack := False;
  FCanGoForward := False;
  FLoading := False;
end;

initialization
  CefRegisterScheme('file', '', TFileScheme);

end.
