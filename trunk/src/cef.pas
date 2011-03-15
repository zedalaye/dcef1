(*
 *                       Delphi Chromium Embedded
 *
 * Usage allowed under the restrictions of the Lesser GNU General Public License
 * or alternatively the restrictions of the Mozilla Public License 1.1
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
 * the specific language governing rights and limitations under the License.
 *
 * Unit owner : Henri Gourvest <hgourvest@gmail.com>
 * Web site   : http://www.progdigy.com
 * Repository : http://code.google.com/p/delphichromiumembedded/
 * Group      : http://groups.google.com/group/delphichromiumembedded
 *)

unit cef;
{$I cef.inc}
interface
uses
{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  AppEvnts,
{$ENDIF}
  Classes, Controls, Messages, Windows, ceflib;

type
  TCustomChromium = class;

  TOnBeforeCreated = procedure(Sender: TCustomChromium; const parentBrowser: ICefBrowser;
    var windowInfo: TCefWindowInfo; popup: Boolean;
    var handler: ICefBase; var url: ustring; var popupFeatures: TCefPopupFeatures; out Result: TCefRetval) of object;
  TOnAfterCreated = procedure(Sender: TCustomChromium; const browser: ICefBrowser; out Result: TCefRetval) of object;
  TOnAddressChange = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    const frame: ICefFrame; const url: ustring; out Result: TCefRetval) of object;
  TOnTitleChange = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    const title: ustring; out Result: TCefRetval) of object;
  TOnBeforeBrowse = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame;
    const request: ICefRequest; navType: TCefHandlerNavtype;
    isRedirect: boolean; out Result: TCefRetval) of object;
  TOnLoadStart = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame; out Result: TCefRetval) of object;
  TOnLoadEnd = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer; out Result: TCefRetval) of object;
  TOnLoadError = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    const frame: ICefFrame; errorCode: TCefHandlerErrorcode;
    const failedUrl: ustring; var errorText: ustring; out Result: TCefRetval) of object;
  TOnBeforeResourceLoad = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    const request: ICefRequest; var redirectUrl: ustring;
    var resourceStream: ICefStreamReader; var mimeType: ustring;
    loadFlags: Integer; out Result: TCefRetval) of object;
  TOnBeforeMenu = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    const menuInfo: PCefHandlerMenuInfo; out Result: TCefRetval) of object;
  TOnGetMenuLabel = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    menuId: TCefHandlerMenuId; var caption: ustring; out Result: TCefRetval) of object;
  TOnMenuAction = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    menuId: TCefHandlerMenuId; out Result: TCefRetval) of object;
  TOnPrintHeaderFooter = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    const frame: ICefFrame; printInfo: PCefPrintInfo;
    const url, title: ustring; currentPage, maxPages: Integer;
    var topLeft, topCenter, topRight, bottomLeft, bottomCenter,
    bottomRight: ustring; out Result: TCefRetval) of object;
  TOnJsAlert = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame;
    const message: ustring; out Result: TCefRetval) of object;
  TOnJsConfirm = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame;
    const message: ustring; var retval: Boolean; out Result: TCefRetval) of object;
  TOnJsPrompt = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame;
    const message, defaultValue: ustring; var retval: Boolean;
    var return: ustring; out Result: TCefRetval) of object;
  TOnBeforeWindowClose = procedure(Sender: TCustomChromium; const browser: ICefBrowser; out Result: TCefRetval) of object;
  TOnTakeFocus = procedure(Sender: TCustomChromium; const browser: ICefBrowser; reverse: Integer; out Result: TCefRetval) of object;
  TOnSetFocus = procedure(Sender: TCustomChromium; const browser: ICefBrowser; isWidget: Boolean; out Result: TCefRetval) of object;
  TOnProtocolExecution = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const url: ustring; var AllowOsExecution: Boolean; out Result: TCefRetval) of object;
  TOnStatus = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const value: ustring; StatusType: TCefHandlerStatusType; out Result: TCefRetval) of object;
  TOnKeyEvent = procedure(Sender: TCustomChromium; const browser: ICefBrowser; event: TCefHandlerKeyEventType;
    code, modifiers: Integer; isSystemKey: Boolean; out Result: TCefRetval) of object;
  TOnConsoleMessage = procedure(Sender: TCustomChromium; const browser: ICefBrowser; message, source: ustring;
    line: Integer; out Result: TCefRetval) of object;
  TOnPrintOptions = procedure(Sender: TCustomChromium; const browser: ICefBrowser; printOptions: PCefPrintOptions; out Result: TCefRetval) of object;
  TOnJsBinding = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame; const obj: ICefv8Value; out Result: TCefRetval) of object;
  TOnTooltip = procedure(Sender: TCustomChromium; const browser: ICefBrowser; var text: ustring; out Result: TCefRetval) of object;
  TOnFindResult = procedure(Sender: TCustomChromium; const browser: ICefBrowser; count: Integer;
    selectionRect: PCefRect; identifier, activeMatchOrdinal,
    finalUpdate: Boolean; out Result: TCefRetval) of object;
  TOnDownloadResponse = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const mimeType, fileName: ustring;
    contentLength: int64; var handler: ICefDownloadHandler; out Result: TCefRetval) of object;
  TOnAuthenticationRequest = procedure(Sender: TCustomChromium; const browser: ICefBrowser; isProxy: Boolean;
    const host, realm, scheme: ustring; var username, password: ustring; out Result: TCefRetval) of object;

  TChromiumOption = (coDragDropDisabled, coEncodingDetectorEnabled, coJavascriptDisabled, coJavascriptOpenWindowsDisallowed,
    coJavascriptCloseWindowsDisallowed, coJavascriptAccessClipboardDisallowed, coDomPasteDisabled,
    coCaretBrowsingEnabled, coJavaDisabled, coPluginsDisabled, coUniversalAccessFromFileUrlsAllowed,
    coFileAccessFromFileUrlsAllowed, coWebSecurityDisabled, coXssAuditorEnabled, coImageLoadDisabled,
    coShrinkStandaloneImagesToFit, coSiteSpecificQuirksDisabled, coTextAreaResizeDisabled,
    coPageCacheDisabled, coTabToLinksDisabled, coHyperlinkAuditingDisabled, coUserStyleSheetEnabled,
    coAuthorAndUserStylesDisabled, coLocalStorageDisabled, coDatabasesDisabled,
    coApplicationCacheDisabled, coWebglDisabled, coAcceleratedCompositingDisabled,
    coAcceleratedLayersDisabled, coAccelerated2dCanvasDisabled, coDeveloperToolsDisabled);

  TChromiumOptions = set of TChromiumOption;

  TChromiumFontOptions = class(TPersistent)
  private
    FStandardFontFamily: ustring;
    FCursiveFontFamily: ustring;
    FSansSerifFontFamily: ustring;
    FMinimumLogicalFontSize: Integer;
    FFantasyFontFamily: ustring;
    FSerifFontFamily: ustring;
    FDefaultFixedFontSize: Integer;
    FDefaultFontSize: Integer;
    FRemoteFontsDisabled: Boolean;
    FFixedFontFamily: ustring;
    FMinimumFontSize: Integer;
  public
    constructor Create; virtual;
  published
    property StandardFontFamily: ustring read FStandardFontFamily;
    property FixedFontFamily: ustring read FFixedFontFamily write FFixedFontFamily;
    property SerifFontFamily: ustring read FSerifFontFamily write FSerifFontFamily;
    property SansSerifFontFamily: ustring read FSansSerifFontFamily write FSansSerifFontFamily;
    property CursiveFontFamily: ustring read FCursiveFontFamily write FCursiveFontFamily;
    property FantasyFontFamily: ustring read FFantasyFontFamily write FFantasyFontFamily;
    property DefaultFontSize: Integer read FDefaultFontSize write FDefaultFontSize default 0;
    property DefaultFixedFontSize: Integer read FDefaultFixedFontSize write FDefaultFixedFontSize default 0;
    property MinimumFontSize: Integer read FMinimumFontSize write FMinimumFontSize default 0;
    property MinimumLogicalFontSize: Integer read FMinimumLogicalFontSize write FMinimumLogicalFontSize default 0;
    property RemoteFontsDisabled: Boolean read FRemoteFontsDisabled write FRemoteFontsDisabled default False;
  end;

  TCustomChromium = class(TWinControl)
  private
    FHandler: ICefBase;
    FBrowser: ICefBrowser;
    FBrowserHandle: HWND;
    FDefaultUrl: ustring;

    FOnBeforeCreated: TOnBeforeCreated;
    FOnAfterCreated: TOnAfterCreated;
    FOnAddressChange: TOnAddressChange;
    FOnTitleChange: TOnTitleChange;
    FOnBeforeBrowse: TOnBeforeBrowse;
    FOnLoadStart: TOnLoadStart;
    FOnLoadEnd: TOnLoadEnd;
    FOnLoadError: TOnLoadError;
    FOnBeforeResourceLoad: TOnBeforeResourceLoad;
    FOnBeforeMenu: TOnBeforeMenu;
    FOnGetMenuLabel: TOnGetMenuLabel;
    FOnMenuAction: TOnMenuAction;
    FOnPrintHeaderFooter: TOnPrintHeaderFooter;
    FOnJsAlert: TOnJsAlert;
    FOnJsConfirm: TOnJsConfirm;
    FOnJsPrompt: TOnJsPrompt;
    FOnBeforeWindowClose: TOnBeforeWindowClose;
    FOnTakeFocus: TOnTakeFocus;
    FOnStatus: TOnStatus;
    FOnSetFocus: TOnSetFocus;
    FOnProtocolExecution: TOnProtocolExecution;
    FOnKeyEvent: TOnKeyEvent;
    FOnConsoleMessage: TOnConsoleMessage;
    FOnPrintOptions: TOnPrintOptions;
    FOnJsBinding: TOnJsBinding;
    FOnTooltip: TOnTooltip;
    FOnFindResult: TOnFindResult;
    FOnDownloadResponse: TOnDownloadResponse;
    FOnAuthenticationRequest: TOnAuthenticationRequest;

    FOptions: TChromiumOptions;
    FUserStyleSheetLocation: ustring;
    FDefaultEncoding: ustring;
    FFontOptions: TChromiumFontOptions;
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure Loaded; override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure Resize; override;

    function doOnBeforeCreated(const parentBrowser: ICefBrowser;
      var windowInfo: TCefWindowInfo; popup: Boolean;
      var handler: ICefBase; var url: ustring; var popupFeatures: TCefPopupFeatures): TCefRetval; virtual;
    function doOnAfterCreated(const browser: ICefBrowser): TCefRetval; virtual;
    function doOnAddressChange(const browser: ICefBrowser;
      const frame: ICefFrame; const url: ustring): TCefRetval; virtual;
    function doOnTitleChange(const browser: ICefBrowser;
      const title: ustring): TCefRetval; virtual;
    function doOnBeforeBrowse(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; navType: TCefHandlerNavtype;
      isRedirect: boolean): TCefRetval; virtual;
    function doOnLoadStart(const browser: ICefBrowser; const frame: ICefFrame): TCefRetval; virtual;
    function doOnLoadEnd(const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer): TCefRetval; virtual;
    function doOnLoadError(const browser: ICefBrowser;
      const frame: ICefFrame; errorCode: TCefHandlerErrorcode;
      const failedUrl: ustring; var errorText: ustring): TCefRetval; virtual;
    function doOnBeforeResourceLoad(const browser: ICefBrowser;
      const request: ICefRequest; var redirectUrl: ustring;
      var resourceStream: ICefStreamReader; var mimeType: ustring;
      loadFlags: Integer): TCefRetval; virtual;
    function doOnProtocolExecution(const browser: ICefBrowser;
      const url: ustring; var AllowOsExecution: Boolean): TCefRetval; virtual;
    function doOnBeforeMenu(const browser: ICefBrowser;
      const menuInfo: PCefHandlerMenuInfo): TCefRetval; virtual;
    function doOnGetMenuLabel(const browser: ICefBrowser;
      menuId: TCefHandlerMenuId; var caption: ustring): TCefRetval; virtual;
    function doOnMenuAction(const browser: ICefBrowser;
      menuId: TCefHandlerMenuId): TCefRetval; virtual;
    function doOnPrintHeaderFooter(const browser: ICefBrowser;
      const frame: ICefFrame; printInfo: PCefPrintInfo;
      const url, title: ustring; currentPage, maxPages: Integer;
      var topLeft, topCenter, topRight, bottomLeft, bottomCenter,
      bottomRight: ustring): TCefRetval; virtual;
    function doOnJsAlert(const browser: ICefBrowser; const frame: ICefFrame;
      const message: ustring): TCefRetval; virtual;
    function doOnJsConfirm(const browser: ICefBrowser; const frame: ICefFrame;
      const message: ustring; var retval: Boolean): TCefRetval; virtual;
    function doOnJsPrompt(const browser: ICefBrowser; const frame: ICefFrame;
      const message, defaultValue: ustring; var retval: Boolean;
      var return: ustring): TCefRetval; virtual;
    function doOnBeforeWindowClose(const browser: ICefBrowser): TCefRetval; virtual;
    function doOnTakeFocus(const browser: ICefBrowser; reverse: Integer): TCefRetval; virtual;
    function doOnSetFocus(const browser: ICefBrowser; isWidget: Boolean): TCefRetval; virtual;
    function doOnKeyEvent(const browser: ICefBrowser; event: TCefHandlerKeyEventType;
      code, modifiers: Integer; isSystemKey: Boolean): TCefRetval; virtual;
    function doOnConsoleMessage(const browser: ICefBrowser; const message,
      source: ustring; line: Integer): TCefRetval; stdcall;
    function doOnPrintOptions(const browser: ICefBrowser;
        printOptions: PCefPrintOptions): TCefRetval; virtual;
    function doOnJsBinding(const browser: ICefBrowser;
      const frame: ICefFrame; const obj: ICefv8Value): TCefRetval; virtual;
    function doOnTooltip(const browser: ICefBrowser; var text: ustring): TCefRetval; virtual;
    function doOnFindResult(const browser: ICefBrowser; count: Integer;
      selectionRect: PCefRect; identifier, activeMatchOrdinal,
      finalUpdate: Boolean): TCefRetval; virtual;
    function doOnDownloadResponse(const browser: ICefBrowser; const mimeType, fileName: ustring;
      contentLength: int64; var handler: ICefDownloadHandler): TCefRetval; virtual;
    function doOnAuthenticationRequest(const browser: ICefBrowser; isProxy: Boolean;
      const host, realm, scheme: ustring; var username, password: ustring): TCefRetval; virtual;
    function doOnStatus(const browser: ICefBrowser; const value: ustring;
      StatusType: TCefHandlerStatusType): TCefRetval; virtual;

    property DefaultUrl: ustring read FDefaultUrl write FDefaultUrl;
    property OnBeforeCreated: TOnBeforeCreated read FOnBeforeCreated write FOnBeforeCreated;
    property OnAfterCreated: TOnAfterCreated read FOnAfterCreated write FOnAfterCreated;
    property OnAddressChange: TOnAddressChange read FOnAddressChange write FOnAddressChange;
    property OnTitleChange: TOnTitleChange read FOnTitleChange write FOnTitleChange;
    property OnBeforeBrowse: TOnBeforeBrowse read FOnBeforeBrowse write FOnBeforeBrowse;
    property OnLoadStart: TOnLoadStart read FOnLoadStart write FOnLoadStart;
    property OnLoadEnd: TOnLoadEnd read FOnLoadEnd write FOnLoadEnd;
    property OnLoadError: TOnLoadError read FOnLoadError write FOnLoadError;
    property OnBeforeResourceLoad: TOnBeforeResourceLoad read FOnBeforeResourceLoad write FOnBeforeResourceLoad;
    property OnBeforeMenu: TOnBeforeMenu read FOnBeforeMenu write FOnBeforeMenu;
    property OnGetMenuLabel: TOnGetMenuLabel read FOnGetMenuLabel write FOnGetMenuLabel;
    property OnMenuAction: TOnMenuAction read FOnMenuAction write FOnMenuAction;
    property OnPrintHeaderFooter: TOnPrintHeaderFooter read FOnPrintHeaderFooter write FOnPrintHeaderFooter;
    property OnJsAlert: TOnJsAlert read FOnJsAlert write FOnJsAlert;
    property OnJsConfirm: TOnJsConfirm read FOnJsConfirm write FOnJsConfirm;
    property OnJsPrompt: TOnJsPrompt read FOnJsPrompt write FOnJsPrompt;
    property OnBeforeWindowClose: TOnBeforeWindowClose read FOnBeforeWindowClose write FOnBeforeWindowClose;
    property OnTakeFocus: TOnTakeFocus read FOnTakeFocus write FOnTakeFocus;
    property OnSetFocus: TOnSetFocus read FOnSetFocus write FOnSetFocus;
    property OnKeyEvent: TOnKeyEvent read FOnKeyEvent write FOnKeyEvent;
    property OnPrintOptions: TOnPrintOptions read FOnPrintOptions write FOnPrintOptions;
    property OnJsBinding: TOnJsBinding read FOnJsBinding write FOnJsBinding;
    property OnTooltip: TOnTooltip read FOnTooltip write FOnTooltip;
    property OnFindResult: TOnFindResult read FOnFindResult write FOnFindResult;
    property OnDownloadResponse: TOnDownloadResponse read FOnDownloadResponse write FOnDownloadResponse;
    property OnConsoleMessage: TOnConsoleMessage read FOnConsoleMessage write FOnConsoleMessage;
    property OnAuthenticationRequest: TOnAuthenticationRequest read FOnAuthenticationRequest write FOnAuthenticationRequest;
    property OnStatus: TOnStatus read FOnStatus write FOnStatus;
    property OnProtocolExecution: TOnProtocolExecution read FOnProtocolExecution write FOnProtocolExecution;

    property Options: TChromiumOptions read FOptions write FOptions default [];
    property FontOptions: TChromiumFontOptions read FFontOptions;
    property DefaultEncoding: ustring read FDefaultEncoding write FDefaultEncoding;
    property UserStyleSheetLocation: ustring read FUserStyleSheetLocation write FUserStyleSheetLocation;
    property BrowserHandle: HWND read FBrowserHandle;
    property Browser: ICefBrowser read FBrowser;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Load(const url: ustring);
  end;

  TChromium = class(TCustomChromium)
  published
    property Color;
    property Align;
    property Anchors;
    property Constraints;
    property DefaultUrl;
    property TabOrder;
    property TabStop;
    property Visible;
    property BrowserHandle;
    property Browser;

    property OnBeforeCreated;
    property OnAfterCreated;
    property OnAddressChange;
    property OnTitleChange;
    property OnBeforeBrowse;
    property OnLoadStart;
    property OnLoadEnd;
    property OnLoadError;
    property OnBeforeResourceLoad;
    property OnBeforeMenu;
    property OnGetMenuLabel;
    property OnMenuAction;
    property OnPrintHeaderFooter;
    property OnJsAlert;
    property OnJsConfirm;
    property OnJsPrompt;
    property OnBeforeWindowClose;
    property OnTakeFocus;
    property OnSetFocus;
    property OnKeyEvent;
    property OnPrintOptions;
    property OnJsBinding;
    property OnTooltip;
    property OnFindResult;
    property OnDownloadResponse;
    property OnConsoleMessage;
    property OnAuthenticationRequest;
    property OnStatus;
    property OnProtocolExecution;

    property Options;
    property FontOptions;
    property DefaultEncoding;
    property UserStyleSheetLocation;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Google', [TChromium]);
end;


{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
var
  CefInstances: Integer = 0;

type
  TCefApplicationEvents = class(TApplicationEvents)
  private
    FTick: Cardinal;
  public
    procedure doIdle(Sender: TObject; var Done: Boolean);
    constructor Create(AOwner: TComponent); override;
  end;
{$ENDIF}

  ICefCustomHandler = interface
    ['{91D102A8-E68B-41F8-A323-F77F0C190BD9}']
    procedure Disconnect;
  end;

  TCefCustomHandler = class(TCefHandlerOwn, ICefCustomHandler)
  private
    FCrm: TCustomChromium;
  protected
    procedure Disconnect;
    function doOnBeforeCreated(const parentBrowser: ICefBrowser;
      var windowInfo: TCefWindowInfo; popup: Boolean; var popupFeatures: TCefPopupFeatures;
      var handler: ICefBase; var url: ustring; var settings: TCefBrowserSettings): TCefRetval; override;
    function doOnAfterCreated(const browser: ICefBrowser): TCefRetval; override;
    function doOnAddressChange(const browser: ICefBrowser;
      const frame: ICefFrame; const url: ustring): TCefRetval; override;
    function doOnTitleChange(const browser: ICefBrowser;
      const title: ustring): TCefRetval; override;
    function doOnBeforeBrowse(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; navType: TCefHandlerNavtype;
      isRedirect: boolean): TCefRetval; override;
    function doOnLoadStart(const browser: ICefBrowser; const frame: ICefFrame): TCefRetval; override;
    function doOnLoadEnd(const browser: ICefBrowser; const frame: ICefFrame;
      httpStatusCode: Integer): TCefRetval; override;
    function doOnLoadError(const browser: ICefBrowser;
      const frame: ICefFrame; errorCode: TCefHandlerErrorcode;
      const failedUrl: ustring; var errorText: ustring): TCefRetval; override;
    function doOnBeforeResourceLoad(const browser: ICefBrowser;
      const request: ICefRequest; var redirectUrl: ustring;
      var resourceStream: ICefStreamReader; var mimeType: ustring;
      loadFlags: Integer): TCefRetval; override;
    function doOnProtocolExecution(const browser: ICefBrowser;
      const url: ustring; var AllowOsExecution: Boolean): TCefRetval; override;
    function doOnBeforeMenu(const browser: ICefBrowser;
      const menuInfo: PCefHandlerMenuInfo): TCefRetval; override;
    function doOnGetMenuLabel(const browser: ICefBrowser;
      menuId: TCefHandlerMenuId; var caption: ustring): TCefRetval; override;
    function doOnMenuAction(const browser: ICefBrowser;
      menuId: TCefHandlerMenuId): TCefRetval; override;
    function doOnPrintOptions(const browser: ICefBrowser;
        printOptions: PCefPrintOptions): TCefRetval; override;
    function doOnPrintHeaderFooter(const browser: ICefBrowser;
      const frame: ICefFrame; printInfo: PCefPrintInfo;
      const url, title: ustring; currentPage, maxPages: Integer;
      var topLeft, topCenter, topRight, bottomLeft, bottomCenter,
      bottomRight: ustring): TCefRetval; override;
    function doOnJsAlert(const browser: ICefBrowser; const frame: ICefFrame;
      const message: ustring): TCefRetval; override;
    function doOnJsConfirm(const browser: ICefBrowser; const frame: ICefFrame;
      const message: ustring; var retval: Boolean): TCefRetval; override;
    function doOnJsPrompt(const browser: ICefBrowser; const frame: ICefFrame;
      const message, defaultValue: ustring; var retval: Boolean;
      var return: ustring): TCefRetval; override;
    function doOnJsBinding(const browser: ICefBrowser;
      const frame: ICefFrame; const obj: ICefv8Value): TCefRetval; override;
    function doOnBeforeWindowClose(const browser: ICefBrowser): TCefRetval; override;
    function doOnTakeFocus(const browser: ICefBrowser; reverse: Integer): TCefRetval; override;
    function doOnSetFocus(const browser: ICefBrowser; isWidget: Boolean): TCefRetval; override;
    function doOnKeyEvent(const browser: ICefBrowser; event: TCefHandlerKeyEventType;
      code, modifiers: Integer; isSystemKey: Boolean): TCefRetval; override;
    function doOnTooltip(const browser: ICefBrowser; var text: ustring): TCefRetval; override;
    function doOnStatus(const browser: ICefBrowser; const value: ustring;
      StatusType: TCefHandlerStatusType): TCefRetval; override;
    function doOnConsoleMessage(const browser: ICefBrowser; const message,
      source: ustring; line: Integer): TCefRetval; override;
    function doOnFindResult(const browser: ICefBrowser; count: Integer;
      selectionRect: PCefRect; identifier, activeMatchOrdinal,
      finalUpdate: Boolean): TCefRetval; override;
    function doOnDownloadResponse(const browser: ICefBrowser; const mimeType, fileName: ustring;
      contentLength: int64; var handler: ICefDownloadHandler): TCefRetval; override;
    function doOnAuthenticationRequest(const browser: ICefBrowser; isProxy: Boolean;
      const host, realm, scheme: ustring; var username, password: ustring): TCefRetval; override;
  public
    constructor Create(crm: TCustomChromium); reintroduce;
    destructor Destroy; override;
    property Crm: TCustomChromium read FCrm write FCrm;
  end;

{ TCustomChromium }

constructor TCustomChromium.Create(AOwner: TComponent);
begin
  inherited;
  if not (csDesigning in ComponentState) then
    FHandler := TCefCustomHandler.Create(Self) as ICefBase;

  FOptions := [];
  FFontOptions := TChromiumFontOptions.Create;

  FUserStyleSheetLocation := '';
  FDefaultEncoding := '';

  FBrowserHandle := INVALID_HANDLE_VALUE;
  FBrowser := nil;
end;

procedure TCustomChromium.CreateWindowHandle(const Params: TCreateParams);
var
  info: TCefWindowInfo;
  rect: TRect;
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    FillChar(info, SizeOf(info), 0);
    rect := GetClientRect;
    info.Style := WS_CHILD or WS_VISIBLE or WS_CLIPCHILDREN or WS_CLIPSIBLINGS or WS_TABSTOP;
    info.WndParent := Handle;
    info.x := rect.left;
    info.y := rect.top;
    info.Width := rect.right - rect.left;
    info.Height := rect.bottom - rect.top;
    info.ExStyle := 0;
{$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
    CefBrowserCreate(@info, False, FHandler.Wrap, FDefaultUrl);
{$ELSE}
    FBrowser := CefBrowserCreateSync(@info, False, FHandler.Wrap, '');
    FBrowserHandle := FBrowser.GetWindowHandle;
{$ENDIF}
  end;
end;

destructor TCustomChromium.Destroy;
begin
  FBrowser := nil;
  FFontOptions.Free;
  if FHandler <> nil then
  begin
    (FHandler as ICefCustomHandler).Disconnect;
    FHandler := nil;
  end;
  inherited;
end;

function TCustomChromium.doOnAddressChange(const browser: ICefBrowser;
  const frame: ICefFrame; const url: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnAddressChange) then
    FOnAddressChange(Self, browser, frame, url, Result);
end;

function TCustomChromium.doOnAfterCreated(const browser: ICefBrowser): TCefRetval;
begin
{$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  if (browser <> nil) and not browser.IsPopup then
  begin
    FBrowser := browser;
    FBrowserHandle := browser.GetWindowHandle;
  end;
{$ENDIF}
  Result := RV_CONTINUE;
  if Assigned(FOnAfterCreated) then
    FOnAfterCreated(Self, browser, Result);
end;

function TCustomChromium.doOnAuthenticationRequest(const browser: ICefBrowser;
  isProxy: Boolean; const host, realm, scheme: ustring; var username,
  password: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnAuthenticationRequest) then
    FOnAuthenticationRequest(Self, browser, isProxy, host, realm, scheme, username, password, Result);
end;

function TCustomChromium.doOnBeforeBrowse(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest;
  navType: TCefHandlerNavtype; isRedirect: boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnBeforeBrowse) then
    FOnBeforeBrowse(Self, browser, frame, request, navType, isRedirect, Result);
end;

function TCustomChromium.doOnBeforeCreated(const parentBrowser: ICefBrowser;
  var windowInfo: TCefWindowInfo; popup: Boolean; var handler: ICefBase;
  var url: ustring; var popupFeatures: TCefPopupFeatures): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnBeforeCreated) then
    FOnBeforeCreated(Self, parentBrowser, windowInfo, popup, handler, url, popupFeatures, Result);
end;

function TCustomChromium.doOnBeforeMenu(const browser: ICefBrowser;
  const menuInfo: PCefHandlerMenuInfo): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnBeforeMenu) then
    FOnBeforeMenu(Self, browser, menuInfo, Result);
end;

function TCustomChromium.doOnBeforeResourceLoad(const browser: ICefBrowser;
  const request: ICefRequest; var redirectUrl: ustring;
  var resourceStream: ICefStreamReader; var mimeType: ustring;
  loadFlags: Integer): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnBeforeResourceLoad) then
    FOnBeforeResourceLoad(Self, browser, request, redirectUrl, resourceStream,
      mimeType, loadFlags, Result);
end;

function TCustomChromium.doOnBeforeWindowClose(
  const browser: ICefBrowser): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnBeforeWindowClose) then
    FOnBeforeWindowClose(Self, browser, Result);
  if browser.GetWindowHandle = FBrowserHandle then
    FBrowser := nil;
end;

function TCustomChromium.doOnConsoleMessage(const browser: ICefBrowser; const message,
  source: ustring; line: Integer): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnConsoleMessage) then
    FOnConsoleMessage(Self, browser, message, source, line, Result);
end;

function TCustomChromium.doOnDownloadResponse(const browser: ICefBrowser;
  const mimeType, fileName: ustring; contentLength: int64;
  var handler: ICefDownloadHandler): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnDownloadResponse) then
    FOnDownloadResponse(Self, browser, mimeType, fileName, contentLength, handler, Result);
end;

function TCustomChromium.doOnFindResult(const browser: ICefBrowser;
  count: Integer; selectionRect: PCefRect; identifier, activeMatchOrdinal,
  finalUpdate: Boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnFindResult) then
    FOnFindResult(Self, browser, count, selectionRect, identifier,
      activeMatchOrdinal, finalUpdate, Result);
end;

function TCustomChromium.doOnGetMenuLabel(const browser: ICefBrowser;
  menuId: TCefHandlerMenuId; var caption: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnGetMenuLabel) then
    FOnGetMenuLabel(Self, browser, menuId, caption, Result);
end;

function TCustomChromium.doOnJsAlert(const browser: ICefBrowser;
  const frame: ICefFrame; const message: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnJsAlert) then
    FOnJsAlert(Self, browser, frame, message, Result);
end;

function TCustomChromium.doOnJsBinding(const browser: ICefBrowser;
  const frame: ICefFrame; const obj: ICefv8Value): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnJsBinding) then
    FOnJsBinding(Self, browser, frame, obj, Result);
end;

function TCustomChromium.doOnJsConfirm(const browser: ICefBrowser;
  const frame: ICefFrame; const message: ustring;
  var retval: Boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnJsConfirm) then
    FOnJsConfirm(Self, browser, frame, message, retval, Result);
end;

function TCustomChromium.doOnJsPrompt(const browser: ICefBrowser;
  const frame: ICefFrame; const message, defaultValue: ustring;
  var retval: Boolean; var return: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnJsPrompt) then
    FOnJsPrompt(Self, browser, frame, message, defaultValue, retval, return, Result);
end;

function TCustomChromium.doOnKeyEvent(const browser: ICefBrowser;
  event: TCefHandlerKeyEventType; code, modifiers: Integer;
  isSystemKey: Boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnKeyEvent) then
    FOnKeyEvent(Self, browser, event, code, modifiers, isSystemKey, Result);
end;

function TCustomChromium.doOnLoadEnd(const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: Integer): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnLoadEnd) then
    FOnLoadEnd(Self, browser, frame, httpStatusCode, Result);
end;

function TCustomChromium.doOnLoadError(const browser: ICefBrowser;
  const frame: ICefFrame; errorCode: TCefHandlerErrorcode;
  const failedUrl: ustring; var errorText: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnLoadError) then
    FOnLoadError(Self, browser, frame, errorCode, failedUrl, errorText, Result);
end;

function TCustomChromium.doOnLoadStart(const browser: ICefBrowser;
  const frame: ICefFrame): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnLoadStart) then
    FOnLoadStart(Self, browser, frame, Result);
end;

function TCustomChromium.doOnMenuAction(const browser: ICefBrowser;
  menuId: TCefHandlerMenuId): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnMenuAction) then
    FOnMenuAction(Self, browser, menuId, Result);
end;

function TCustomChromium.doOnPrintHeaderFooter(const browser: ICefBrowser;
  const frame: ICefFrame; printInfo: PCefPrintInfo; const url, title: ustring;
  currentPage, maxPages: Integer; var topLeft, topCenter, topRight, bottomLeft,
  bottomCenter, bottomRight: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnPrintHeaderFooter) then
    FOnPrintHeaderFooter(Self, browser, frame, printInfo, url, title,
      currentPage, maxPages, topLeft, topCenter, topRight, bottomLeft,
      bottomCenter, bottomRight, Result);
end;

function TCustomChromium.doOnPrintOptions(const browser: ICefBrowser;
  printOptions: PCefPrintOptions): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnPrintOptions) then
    FOnPrintOptions(Self, browser, printOptions, Result);
end;

function TCustomChromium.doOnProtocolExecution(const browser: ICefBrowser;
  const url: ustring; var AllowOsExecution: Boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnProtocolExecution) then
    FOnProtocolExecution(Self, browser, url, AllowOsExecution, Result);
end;

function TCustomChromium.doOnSetFocus(const browser: ICefBrowser;
  isWidget: Boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnSetFocus) then
    FOnSetFocus(Self, browser, isWidget, Result);
end;

function TCustomChromium.doOnStatus(const browser: ICefBrowser;
  const value: ustring; StatusType: TCefHandlerStatusType): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnStatus) then
    FOnStatus(Self, browser, value, StatusType, Result);
end;

function TCustomChromium.doOnTakeFocus(const browser: ICefBrowser;
  reverse: Integer): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnTakeFocus) then
    FOnTakeFocus(Self, browser, reverse, Result);
end;

function TCustomChromium.doOnTitleChange(const browser: ICefBrowser;
  const title: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnTitleChange) then
    FOnTitleChange(Self, browser, title, Result);
end;

function TCustomChromium.doOnTooltip(const browser: ICefBrowser;
  var text: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnTooltip) then
    FOnTooltip(Self, browser, text, Result);
end;

procedure TCustomChromium.Load(const url: ustring);
var
  frm: ICefFrame;
begin
  HandleNeeded;
  if FBrowser <> nil then
  begin
    frm := FBrowser.MainFrame;
    if frm <> nil then
      frm.LoadUrl(url);
  end;
end;

procedure TCustomChromium.Loaded;
begin
  inherited;
  Load(FDefaultUrl);
end;

procedure TCustomChromium.Resize;
var
  brws: ICefBrowser;
  rect: TRect;
  hdwp: THandle;
begin
  inherited;
  if not (csDesigning in ComponentState) then
  begin
    brws := FBrowser;
    if (brws <> nil) and (brws.GetWindowHandle <> INVALID_HANDLE_VALUE) then
    begin
      rect := GetClientRect;
      hdwp := BeginDeferWindowPos(1);
      try
        hdwp := DeferWindowPos(hdwp, brws.GetWindowHandle, 0,
          rect.left, rect.top, rect.right - rect.left, rect.bottom - rect.top,
          SWP_NOZORDER);
      finally
        EndDeferWindowPos(hdwp);
      end;
    end;
  end;
end;

procedure TCustomChromium.WndProc(var Message: TMessage);
begin
  case Message.Msg of
    WM_SETFOCUS:
      begin
        if (FBrowser <> nil) and (FBrowser.GetWindowHandle <> 0) then
          PostMessage(FBrowser.GetWindowHandle, WM_SETFOCUS, Message.WParam, 0);
        inherited WndProc(Message);
      end;
    WM_ERASEBKGND:
      if (csDesigning in ComponentState) or (FBrowser = nil) then
        inherited WndProc(Message);
  else
    inherited WndProc(Message);
  end;
end;

{ TChromiumFontOptions }

constructor TChromiumFontOptions.Create;
begin
  FStandardFontFamily := '';
  FCursiveFontFamily := '';
  FSansSerifFontFamily := '';
  FMinimumLogicalFontSize := 0;
  FFantasyFontFamily := '';
  FSerifFontFamily := '';
  FDefaultFixedFontSize := 0;
  FDefaultFontSize := 0;
  FRemoteFontsDisabled := False;
  FFixedFontFamily := '';
  FMinimumFontSize := 0;
end;

{ TCefApplicationEvents }

{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
constructor TCefApplicationEvents.Create(AOwner: TComponent);
begin
  inherited;
  OnIdle := DoIdle;
  FTick := GetTickCount;
end;
{$ENDIF}

{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
procedure TCefApplicationEvents.doIdle(Sender: TObject; var Done: Boolean);
var
  c: Cardinal;
begin
  if CefInstances > 0 then
  begin
    CefDoMessageLoopWork;
    c := GetTickCount;
    if  c - FTick <= 32 then
      // avoid flickering :p
      Done := False else
      begin
        Done := True;
        FTick := c;
      end;
  end;
end;
{$ENDIF}

{ TCefCustomHandler }

constructor TCefCustomHandler.Create(crm: TCustomChromium);
begin
  inherited Create;
  FCrm := crm;
{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  InterlockedIncrement(CefInstances);
{$ENDIF}
end;

destructor TCefCustomHandler.Destroy;
begin
{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  InterlockedDecrement(CefInstances);
{$ENDIF}
  inherited;
end;

procedure TCefCustomHandler.Disconnect;
begin
  FCrm := nil;
end;

function TCefCustomHandler.doOnAddressChange(const browser: ICefBrowser;
  const frame: ICefFrame; const url: ustring): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnAddressChange(browser, frame, url) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnAfterCreated(
  const browser: ICefBrowser): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnAfterCreated(browser) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnAuthenticationRequest(const browser: ICefBrowser;
  isProxy: Boolean; const host, realm, scheme: ustring; var username,
  password: ustring): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnAuthenticationRequest(browser, isProxy, host, realm, scheme, username, password) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnBeforeBrowse(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest;
  navType: TCefHandlerNavtype; isRedirect: boolean): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnBeforeBrowse(browser, frame, request, navType, isRedirect) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnBeforeCreated(const parentBrowser: ICefBrowser;
  var windowInfo: TCefWindowInfo; popup: Boolean; var popupFeatures: TCefPopupFeatures;
  var handler: ICefBase; var url: ustring; var settings: TCefBrowserSettings): TCefRetval;
begin
  if FCrm <> nil then
  begin
    Result := FCrm.doOnBeforeCreated(parentBrowser, windowInfo, popup, handler, url, popupFeatures);

    Assert(settings.size = SizeOf(settings));
    settings.standard_font_family := CefString(FCrm.FFontOptions.FStandardFontFamily);
    settings.fixed_font_family := CefString(FCrm.FFontOptions.FFixedFontFamily);
    settings.serif_font_family := CefString(FCrm.FFontOptions.FSerifFontFamily);
    settings.sans_serif_font_family := CefString(FCrm.FFontOptions.FSansSerifFontFamily);
    settings.cursive_font_family := CefString(FCrm.FFontOptions.FCursiveFontFamily);
    settings.fantasy_font_family := CefString(FCrm.FFontOptions.FFantasyFontFamily);
    settings.default_font_size := FCrm.FFontOptions.FDefaultFontSize;
    settings.default_fixed_font_size := FCrm.FFontOptions.FDefaultFixedFontSize;
    settings.minimum_font_size := FCrm.FFontOptions.FMinimumFontSize;
    settings.minimum_logical_font_size := FCrm.FFontOptions.FMinimumLogicalFontSize;
    settings.remote_fonts_disabled := FCrm.FFontOptions.FRemoteFontsDisabled;
    settings.default_encoding := CefString(FCrm.FDefaultEncoding);
    settings.user_style_sheet_location := CefString(FCrm.FUserStyleSheetLocation);

    settings.drag_drop_disabled := coDragDropDisabled in FCrm.FOptions;
    settings.encoding_detector_enabled := coEncodingDetectorEnabled in FCrm.FOptions;
    settings.javascript_disabled := coJavascriptDisabled in FCrm.FOptions;
    settings.javascript_open_windows_disallowed := coJavascriptOpenWindowsDisallowed in FCrm.FOptions;
    settings.javascript_close_windows_disallowed := coJavascriptCloseWindowsDisallowed in FCrm.FOptions;
    settings.javascript_access_clipboard_disallowed := coJavascriptAccessClipboardDisallowed in FCrm.FOptions;
    settings.dom_paste_disabled := coDomPasteDisabled in FCrm.FOptions;
    settings.caret_browsing_enabled := coCaretBrowsingEnabled in FCrm.FOptions;
    settings.java_disabled := coJavaDisabled in FCrm.FOptions;
    settings.plugins_disabled := coPluginsDisabled in FCrm.FOptions;
    settings.universal_access_from_file_urls_allowed := coUniversalAccessFromFileUrlsAllowed in FCrm.FOptions;
    settings.file_access_from_file_urls_allowed := coFileAccessFromFileUrlsAllowed in FCrm.FOptions;
    settings.web_security_disabled := coWebSecurityDisabled in FCrm.FOptions;
    settings.xss_auditor_enabled := coXssAuditorEnabled in FCrm.FOptions;
    settings.image_load_disabled := coImageLoadDisabled in FCrm.FOptions;
    settings.shrink_standalone_images_to_fit := coShrinkStandaloneImagesToFit in FCrm.FOptions;
    settings.site_specific_quirks_disabled := coSiteSpecificQuirksDisabled in FCrm.FOptions;
    settings.text_area_resize_disabled := coTextAreaResizeDisabled in FCrm.FOptions;
    settings.page_cache_disabled := coPageCacheDisabled in FCrm.FOptions;
    settings.tab_to_links_disabled := coTabToLinksDisabled in FCrm.FOptions;
    settings.hyperlink_auditing_disabled := coHyperlinkAuditingDisabled in FCrm.FOptions;
    settings.user_style_sheet_enabled := coUserStyleSheetEnabled in FCrm.FOptions;
    settings.author_and_user_styles_disabled := coAuthorAndUserStylesDisabled in FCrm.FOptions;
    settings.local_storage_disabled := coLocalStorageDisabled in FCrm.FOptions;
    settings.databases_disabled := coDatabasesDisabled in FCrm.FOptions;
    settings.application_cache_disabled := coApplicationCacheDisabled in FCrm.FOptions;
    settings.webgl_disabled := coWebglDisabled in FCrm.FOptions;
    settings.accelerated_compositing_disabled := coAcceleratedCompositingDisabled in FCrm.FOptions;
    settings.accelerated_layers_disabled := coAcceleratedLayersDisabled in FCrm.FOptions;
    settings.accelerated_2d_canvas_disabled := coAccelerated2dCanvasDisabled in FCrm.FOptions;
    settings.developer_tools_disabled := coDeveloperToolsDisabled in FCrm.FOptions;
  end else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnBeforeMenu(const browser: ICefBrowser;
  const menuInfo: PCefHandlerMenuInfo): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnBeforeMenu(browser, menuInfo) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnBeforeResourceLoad(const browser: ICefBrowser;
  const request: ICefRequest; var redirectUrl: ustring;
  var resourceStream: ICefStreamReader; var mimeType: ustring;
  loadFlags: Integer): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnBeforeResourceLoad(browser, request, redirectUrl,
      resourceStream, mimeType, loadFlags) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnBeforeWindowClose(
  const browser: ICefBrowser): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnBeforeWindowClose(browser) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnConsoleMessage(const browser: ICefBrowser;
  const message, source: ustring; line: Integer): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnConsoleMessage(browser, message, source, line) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnDownloadResponse(const browser: ICefBrowser;
  const mimeType, fileName: ustring; contentLength: int64;
  var handler: ICefDownloadHandler): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnDownloadResponse(browser, mimeType, fileName, contentLength, handler) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnFindResult(const browser: ICefBrowser;
  count: Integer; selectionRect: PCefRect; identifier, activeMatchOrdinal,
  finalUpdate: Boolean): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnFindResult(browser, count, selectionRect, identifier,
      activeMatchOrdinal, finalUpdate) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnGetMenuLabel(const browser: ICefBrowser;
  menuId: TCefHandlerMenuId; var caption: ustring): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnGetMenuLabel(browser, menuId, caption) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnJsAlert(const browser: ICefBrowser;
  const frame: ICefFrame; const message: ustring): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnJsAlert(browser, frame, message) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnJsBinding(const browser: ICefBrowser;
  const frame: ICefFrame; const obj: ICefv8Value): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnJsBinding(browser, frame, obj) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnJsConfirm(const browser: ICefBrowser;
  const frame: ICefFrame; const message: ustring;
  var retval: Boolean): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnJsConfirm(browser, frame, message, retval) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnJsPrompt(const browser: ICefBrowser;
  const frame: ICefFrame; const message, defaultValue: ustring;
  var retval: Boolean; var return: ustring): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnJsPrompt(browser, frame, message, defaultValue, retval, return) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnKeyEvent(const browser: ICefBrowser;
  event: TCefHandlerKeyEventType; code, modifiers: Integer;
  isSystemKey: Boolean): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnKeyEvent(browser, event, code, modifiers, isSystemKey) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnLoadEnd(const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: Integer): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnLoadEnd(browser, frame, httpStatusCode) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnLoadError(const browser: ICefBrowser;
  const frame: ICefFrame; errorCode: TCefHandlerErrorcode;
  const failedUrl: ustring; var errorText: ustring): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnLoadError(browser, frame, errorCode, failedUrl, errorText) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnLoadStart(const browser: ICefBrowser;
  const frame: ICefFrame): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnLoadStart(browser, frame) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnMenuAction(const browser: ICefBrowser;
  menuId: TCefHandlerMenuId): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnMenuAction(browser, menuId) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnPrintHeaderFooter(const browser: ICefBrowser;
  const frame: ICefFrame; printInfo: PCefPrintInfo; const url, title: ustring;
  currentPage, maxPages: Integer; var topLeft, topCenter, topRight, bottomLeft,
  bottomCenter, bottomRight: ustring): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnPrintHeaderFooter(browser, frame, printInfo, url, title,
    currentPage, maxPages, topLeft, topCenter, topRight, bottomLeft, bottomCenter, bottomRight) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnPrintOptions(const browser: ICefBrowser;
  printOptions: PCefPrintOptions): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnPrintOptions(browser, printOptions) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnProtocolExecution(const browser: ICefBrowser;
  const url: ustring; var AllowOsExecution: Boolean): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnProtocolExecution(browser, url, AllowOsExecution) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnSetFocus(const browser: ICefBrowser;
  isWidget: Boolean): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnSetFocus(browser, isWidget) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnStatus(const browser: ICefBrowser;
  const value: ustring; StatusType: TCefHandlerStatusType): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnStatus(browser, value, StatusType) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnTakeFocus(const browser: ICefBrowser;
  reverse: Integer): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnTakeFocus(browser, reverse) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnTitleChange(const browser: ICefBrowser;
  const title: ustring): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnTitleChange(browser, title) else
    Result := RV_CONTINUE;
end;

function TCefCustomHandler.doOnTooltip(const browser: ICefBrowser;
  var text: ustring): TCefRetval;
begin
  if FCrm <> nil then
    Result := FCrm.doOnTooltip(browser, text) else
    Result := RV_CONTINUE;
end;

{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
var
  AppEvent: TCefApplicationEvents;

initialization
  AppEvent := TCefApplicationEvents.Create(nil);

finalization
  AppEvent.Free;
{$ENDIF}

end.
