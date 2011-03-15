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
    actDom: TAction;
    VisitDOM1: TMenuItem;
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
      const frame: ICefFrame; httpStatusCode: Integer; out Result: TCefRetval);
    procedure crmLoadStart(Sender: TCustomChromium; const browser: ICefBrowser;
      const frame: ICefFrame; out Result: TCefRetval);
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
    procedure actDomExecute(Sender: TObject);
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
begin
  if crm.Browser <> nil then
     crm.Browser.CloseDevTools;
end;

{$IFDEF DELPHI12_UP}
function getpath(const n: ICefDomNode): string;
begin
  Result := '<' + n.Name + '>';
  if (n.Parent <> nil) then
    Result := getpath(n.Parent) + Result;
end;
{$ENDIF}

procedure TMainForm.actDomExecute(Sender: TObject);
begin
{$IFDEF DELPHI12_UP}
  crm.Browser.MainFrame.VisitDomProc(
    procedure (const doc: ICefDomDocument) begin
      doc.Body.AddEventListenerProc('mouseover', True,
        procedure (const event: ICefDomEvent) begin
          caption := getpath(event.Target);
        end)
  end);
{$ENDIF}
end;

procedure TMainForm.actExecuteJSExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.MainFrame.ExecuteJavaScript(
      'alert(''JavaScript execute works!'');', 'about:blank', 0);
end;

procedure TMainForm.actFileSchemeExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.MainFrame.LoadUrl('file://c:');
end;

procedure TMainForm.actGetSourceExecute(Sender: TObject);
var
  frame: ICefFrame;
  source: ustring;
begin
  if crm.Browser = nil then Exit;
  frame := crm.Browser.MainFrame;
  source := frame.Source;
  source := StringReplace(source, '<', '&lt;', [rfReplaceAll]);
  source := StringReplace(source, '>', '&gt;', [rfReplaceAll]);
  source := '<html><body>Source:<pre>' + source + '</pre></body></html>';
  frame.LoadString(source, 'http://tests/getsource');
end;

procedure TMainForm.actGetTextExecute(Sender: TObject);
var
  frame: ICefFrame;
  source: ustring;
begin
  if crm.Browser = nil then Exit;
  frame := crm.Browser.MainFrame;
  source := frame.Text;
  source := StringReplace(source, '<', '&lt;', [rfReplaceAll]);
  source := StringReplace(source, '>', '&gt;', [rfReplaceAll]);
  source := '<html><body>Text:<pre>' + source + '</pre></body></html>';
  frame.LoadString(source, 'http://tests/gettext');
end;

procedure TMainForm.actGoToExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.MainFrame.LoadUrl(edAddress.Text);
end;

procedure TMainForm.actHomeExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.MainFrame.LoadUrl(crm.DefaultUrl);
end;

procedure TMainForm.actHomeUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := crm.Browser <> nil;
end;

procedure TMainForm.actNextExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.GoForward;
end;

procedure TMainForm.actNextUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := FCanGoForward;
end;

procedure TMainForm.actPrevExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.GoBack;
end;

procedure TMainForm.actPrevUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := FCanGoBack;
end;

procedure TMainForm.actPrintExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.MainFrame.Print;
end;

procedure TMainForm.actReloadExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    if FLoading then
      crm.Browser.StopLoad else
      crm.Browser.Reload;
end;

procedure TMainForm.actReloadUpdate(Sender: TObject);
begin
  if FLoading then
    TAction(sender).Caption := 'X' else
    TAction(sender).Caption := 'R';
  TAction(Sender).Enabled := crm.Browser <> nil;
end;

procedure TMainForm.actShowDevToolsExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.ShowDevTools;
end;

procedure TMainForm.actZoomInExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.ZoomLevel := crm.Browser.ZoomLevel + 0.5;
end;

procedure TMainForm.actZoomOutExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.ZoomLevel := crm.Browser.ZoomLevel - 0.5;
end;

procedure TMainForm.actZoomResetExecute(Sender: TObject);
begin
  if crm.Browser <> nil then
    crm.Browser.ZoomLevel := 0;
end;

procedure TMainForm.crmAddressChange(Sender: TCustomChromium;
  const browser: ICefBrowser; const frame: ICefFrame; const url: ustring;
  out Result: TCefRetval);
begin
  if (browser.GetWindowHandle = crm.BrowserHandle) and ((frame = nil) or (frame.IsMain)) then
    edAddress.Text := url;
end;

procedure TMainForm.crmLoadEnd(Sender: TCustomChromium; const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: Integer; out Result: TCefRetval);
begin
  if (browser.GetWindowHandle = crm.BrowserHandle) and ((frame = nil) or (frame.IsMain)) then
  begin
    FCanGoBack := browser.CanGoBack;
    FCanGoForward := browser.CanGoForward;
    FLoading := False;
  end;
end;

procedure TMainForm.crmLoadStart(Sender: TCustomChromium;
  const browser: ICefBrowser; const frame: ICefFrame; out Result: TCefRetval);
begin
  if (browser.GetWindowHandle = crm.BrowserHandle) and ((frame = nil) or (frame.IsMain)) then
    FLoading := True;
end;

procedure TMainForm.crmStatus(Sender: TCustomChromium;
  const browser: ICefBrowser; const value: ustring;
  StatusType: TCefHandlerStatusType; out Result: TCefRetval);
begin
  if StatusType in [STATUSTYPE_MOUSEOVER_URL, STATUSTYPE_KEYBOARD_FOCUS_URL] then
    StatusBar.SimpleText := value
end;

procedure TMainForm.crmTitleChange(Sender: TCustomChromium;
  const browser: ICefBrowser; const title: ustring; out Result: TCefRetval);
begin
  if browser.GetWindowHandle = crm.BrowserHandle then
    Caption := title;
end;

procedure TMainForm.edAddressKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    if crm.Browser <> nil then
    begin
      crm.Browser.MainFrame.LoadUrl(edAddress.Text);
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
  CefRegisterScheme('file', '', True, False, TFileScheme);

end.
