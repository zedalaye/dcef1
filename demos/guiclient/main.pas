unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, cef, ceflib, Buttons, ComCtrls, ActnList;

type
  TForm4 = class(TForm)
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
    procedure crmAfterCreated(Sender: TCustomChromium;
      const browser: ICefBrowser; out Result: TCefRetval);
    procedure crmLoadEnd(Sender: TCustomChromium; const browser: ICefBrowser;
      const frame: ICefFrame; out Result: TCefRetval);
    procedure crmLoadStart(Sender: TCustomChromium; const browser: ICefBrowser;
      const frame: ICefFrame; out Result: TCefRetval);
    procedure crmTitleChange(Sender: TCustomChromium;
      const browser: ICefBrowser; const title: ustring; out Result: TCefRetval);
    procedure crmBeforeWindowClose(Sender: TCustomChromium;
      const browser: ICefBrowser; out Result: TCefRetval);
  private
    { Déclarations privées }
    FCanGoBack: Boolean;
    FCanGoForward: Boolean;
    FLoading: Boolean;
    FBrowser: ICefBrowser;
  public
    { Déclarations publiques }
    brws: TChromium;
  end;

var
  Form4: TForm4;

implementation
uses ceffilescheme;

{$R *.dfm}

procedure TForm4.actGoToExecute(Sender: TObject);
begin
  FBrowser.MainFrame.LoadUrl(edAddress.Text);
end;

procedure TForm4.actHomeExecute(Sender: TObject);
begin
  FBrowser.MainFrame.LoadUrl(crm.DefaultUrl);
end;

procedure TForm4.actHomeUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := FBrowser <> nil;
end;

procedure TForm4.actNextExecute(Sender: TObject);
begin
  FBrowser.GoForward;
end;

procedure TForm4.actNextUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := FCanGoForward;
end;

procedure TForm4.actPrevExecute(Sender: TObject);
begin
  FBrowser.GoBack;
end;

procedure TForm4.actPrevUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled := FCanGoBack;
end;

procedure TForm4.actReloadExecute(Sender: TObject);
begin
  if FLoading then
    FBrowser.StopLoad else
    FBrowser.Reload;
end;

procedure TForm4.actReloadUpdate(Sender: TObject);
begin
  if FLoading then
    TAction(sender).Caption := 'X' else
    TAction(sender).Caption := 'R';
  TAction(Sender).Enabled := FBrowser <> nil;
end;

procedure TForm4.crmAddressChange(Sender: TCustomChromium;
  const browser: ICefBrowser; const frame: ICefFrame; const url: ustring;
  out Result: TCefRetval);
begin
  if (browser.GetWindowHandle = crm.BrowserHandle) and frame.IsMain then
{$IFDEF UNICODE}
    TThread.Queue(nil, procedure begin edAddress.Text := url end);
{$ELSE}
    SetWindowTextW(edAddress.Handle, PWideChar(url))
{$ENDIF}
end;

procedure TForm4.crmAfterCreated(Sender: TCustomChromium;
  const browser: ICefBrowser; out Result: TCefRetval);
begin
  if not browser.IsPopup then
    FBrowser := browser;
end;

procedure TForm4.crmBeforeWindowClose(Sender: TCustomChromium;
  const browser: ICefBrowser; out Result: TCefRetval);
begin
  if not browser.IsPopup then
    FBrowser := nil;
end;

procedure TForm4.crmLoadEnd(Sender: TCustomChromium; const browser: ICefBrowser;
  const frame: ICefFrame; out Result: TCefRetval);
begin
  if (browser.GetWindowHandle = crm.BrowserHandle) and ((frame = nil) or (frame.IsMain)) then
  begin
    FCanGoBack := browser.CanGoBack;
    FCanGoForward := browser.CanGoForward;
    FLoading := False;
  end;
end;

procedure TForm4.crmLoadStart(Sender: TCustomChromium;
  const browser: ICefBrowser; const frame: ICefFrame; out Result: TCefRetval);
begin
  if (browser.GetWindowHandle = crm.BrowserHandle) and ((frame = nil) or (frame.IsMain)) then
    FLoading := True;
end;

procedure TForm4.crmTitleChange(Sender: TCustomChromium;
  const browser: ICefBrowser; const title: ustring; out Result: TCefRetval);
begin
  if browser.GetWindowHandle = crm.BrowserHandle then
{$IFDEF UNICODE}
    TThread.Queue(nil, procedure begin Caption := title end);
{$ELSE}
    SetWindowTextW(Form4.Handle, PWideChar(title))
{$ENDIF}
end;

procedure TForm4.edAddressKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    FBrowser.MainFrame.LoadUrl(edAddress.Text);
    Abort;
  end;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  FCanGoBack := False;
  FCanGoForward := False;
  FLoading := False;
end;

initialization
  CefLoadLib;
  CefRegisterScheme('file', '', TFileScheme)

end.
