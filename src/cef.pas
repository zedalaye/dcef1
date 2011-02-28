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
  TOnLoadStart = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame; isMainContent: Boolean; out Result: TCefRetval) of object;
  TOnLoadEnd = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame; isMainContent: Boolean; httpStatusCode: Integer; out Result: TCefRetval) of object;
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
    FSelf: Pointer;
    FHandler: TCefHandler;
    FBrowser: ICefBrowser;
    FBrowserHandle: HWND;
    FCriticalSection: TRTLCriticalSection;
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
{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
    FAppEvents: TApplicationEvents;
    procedure doIdle(Sender: TObject; var Done: Boolean);
{$ENDIF}
  protected
    procedure WndProc(var Message: TMessage); override;

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
    function doOnLoadStart(const browser: ICefBrowser; const frame: ICefFrame; isMainContent: Boolean): TCefRetval; virtual;
    function doOnLoadEnd(const browser: ICefBrowser; const frame: ICefFrame; isMainContent: Boolean; httpStatusCode: Integer): TCefRetval; virtual;
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
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;

  end;

  TChromium = class(TCustomChromium)
  published
    property Align;
    property Anchors;
    property Constraints;
    property DefaultUrl;
    property TabOrder;
    property TabStop;
    property Visible;
    property BrowserHandle;

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

{ cef_handler }
function cef_handler_handle_before_created(
      self: PCefHandler; parentBrowser: PCefBrowser;
      var windowInfo: TCefWindowInfo; popup: Integer;
      const popupFeatures: PCefPopupFeatures;
      var handler: PCefHandler; url: PCefString;
      settings: PCefBrowserSettings): TCefRetval; stdcall;
var
  _handler: ICefBase;
  _url: ustring;
begin
  with TCustomChromium(CefGetObject(self)) do
  begin
    if handler <> nil then
      _handler := TCefBaseRef.UnWrap(handler) else
      _handler := nil;
    _url := CefString(url);

    Result := doOnBeforeCreated(
      TCefBrowserRef.UnWrap(parentBrowser),
      windowInfo,
      popup <> 0,
      _handler,
      _url,
      popupFeatures^);

    Assert(settings.size = SizeOf(settings^));
    settings.standard_font_family := CefString(FFontOptions.FStandardFontFamily);
    settings.fixed_font_family := CefString(FFontOptions.FFixedFontFamily);
    settings.serif_font_family := CefString(FFontOptions.FSerifFontFamily);
    settings.sans_serif_font_family := CefString(FFontOptions.FSansSerifFontFamily);
    settings.cursive_font_family := CefString(FFontOptions.FCursiveFontFamily);
    settings.fantasy_font_family := CefString(FFontOptions.FFantasyFontFamily);
    settings.default_font_size := FFontOptions.FDefaultFontSize;
    settings.default_fixed_font_size := FFontOptions.FDefaultFixedFontSize;
    settings.minimum_font_size := FFontOptions.FMinimumFontSize;
    settings.minimum_logical_font_size := FFontOptions.FMinimumLogicalFontSize;
    settings.remote_fonts_disabled := FFontOptions.FRemoteFontsDisabled;
    settings.default_encoding := CefString(FDefaultEncoding);
    settings.user_style_sheet_location := CefString(FUserStyleSheetLocation);

    settings.drag_drop_disabled := coDragDropDisabled in FOptions;
    settings.encoding_detector_enabled := coEncodingDetectorEnabled in FOptions;
    settings.javascript_disabled := coJavascriptDisabled in FOptions;
    settings.javascript_open_windows_disallowed := coJavascriptOpenWindowsDisallowed in FOptions;
    settings.javascript_close_windows_disallowed := coJavascriptCloseWindowsDisallowed in FOptions;
    settings.javascript_access_clipboard_disallowed := coJavascriptAccessClipboardDisallowed in FOptions;
    settings.dom_paste_disabled := coDomPasteDisabled in FOptions;
    settings.caret_browsing_enabled := coCaretBrowsingEnabled in FOptions;
    settings.java_disabled := coJavaDisabled in FOptions;
    settings.plugins_disabled := coPluginsDisabled in FOptions;
    settings.universal_access_from_file_urls_allowed := coUniversalAccessFromFileUrlsAllowed in FOptions;
    settings.file_access_from_file_urls_allowed := coFileAccessFromFileUrlsAllowed in FOptions;
    settings.web_security_disabled := coWebSecurityDisabled in FOptions;
    settings.xss_auditor_enabled := coXssAuditorEnabled in FOptions;
    settings.image_load_disabled := coImageLoadDisabled in FOptions;
    settings.shrink_standalone_images_to_fit := coShrinkStandaloneImagesToFit in FOptions;
    settings.site_specific_quirks_disabled := coSiteSpecificQuirksDisabled in FOptions;
    settings.text_area_resize_disabled := coTextAreaResizeDisabled in FOptions;
    settings.page_cache_disabled := coPageCacheDisabled in FOptions;
    settings.tab_to_links_disabled := coTabToLinksDisabled in FOptions;
    settings.hyperlink_auditing_disabled := coHyperlinkAuditingDisabled in FOptions;
    settings.user_style_sheet_enabled := coUserStyleSheetEnabled in FOptions;
    settings.author_and_user_styles_disabled := coAuthorAndUserStylesDisabled in FOptions;
    settings.local_storage_disabled := coLocalStorageDisabled in FOptions;
    settings.databases_disabled := coDatabasesDisabled in FOptions;
    settings.application_cache_disabled := coApplicationCacheDisabled in FOptions;
    settings.webgl_disabled := coWebglDisabled in FOptions;
    settings.accelerated_compositing_disabled := coAcceleratedCompositingDisabled in FOptions;
    settings.accelerated_layers_disabled := coAcceleratedLayersDisabled in FOptions;
    settings.accelerated_2d_canvas_disabled := coAccelerated2dCanvasDisabled in FOptions;
    settings.developer_tools_disabled := coDeveloperToolsDisabled in FOptions;

    handler := CefGetData(_handler);
    CefStringSet(url, _url);
  end;

end;

function cef_handler_handle_after_created(self: PCefHandler;
  abrowser: PCefBrowser): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnAfterCreated(TCefBrowserRef.UnWrap(abrowser));
end;

function cef_handler_handle_address_change(
    self: PCefHandler; abrowser: PCefBrowser;
    frame: PCefFrame; const uri: PCefString): TCefRetval; stdcall;
begin
   with TCustomChromium(CefGetObject(self)) do
    Result := doOnAddressChange(
      TCefBrowserRef.UnWrap(abrowser),
      TCefFrameRef.UnWrap(frame),
      CefString(uri))
end;

function cef_handler_handle_title_change(
    self: PCefHandler; abrowser: PCefBrowser;
    const title: PCefString): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnTitleChange(TCefBrowserRef.UnWrap(abrowser), CefString(title));
end;

function cef_handler_handle_before_browse(
    self: PCefHandler; abrowser: PCefBrowser;
    frame: PCefFrame; request: PCefRequest;
    navType: TCefHandlerNavtype; isRedirect: Integer): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnBeforeBrowse(
      TCefBrowserRef.UnWrap(abrowser),
      TCefFrameRef.UnWrap(frame),
      TCefRequestRef.UnWrap(request),
      navType,
      isRedirect <> 0)
end;

function cef_handler_handle_load_start(
    self: PCefHandler; abrowser: PCefBrowser;
    frame: PCefFrame; isMainContent: Integer): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnLoadStart(
      TCefBrowserRef.UnWrap(abrowser),
      TCefFrameRef.UnWrap(frame),
      isMainContent <> 0);
end;

function cef_handler_handle_load_end(self: PCefHandler;
    abrowser: PCefBrowser; frame: PCefFrame; isMainContent,
    httpStatusCode: Integer): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnLoadEnd(
      TCefBrowserRef.UnWrap(abrowser),
      TCefFrameRef.UnWrap(frame),
      isMainContent <> 0,
      httpStatusCode);
end;

function cef_handler_handle_load_error(
    self: PCefHandler; abrowser: PCefBrowser;
    frame: PCefFrame; errorCode: TCefHandlerErrorcode;
    const failedUrl: PCefString; var errorText: TCefString): TCefRetval; stdcall;
var
  err: ustring;
begin
  err := CefString(@errorText);
  with TCustomChromium(CefGetObject(self)) do
  begin
    Result := doOnLoadError(
      TCefBrowserRef.UnWrap(abrowser),
      TCefFrameRef.UnWrap(frame),
      errorCode,
      CefString(failedUrl),
      err);
    if Result = RV_HANDLED then
      CefStringSet(@errorText, err);
  end;
end;

function cef_handler_handle_before_resource_load(
    self: PCefHandler; abrowser: PCefBrowser;
    request: PCefRequest; var redirectUrl: TCefString;
    var resourceStream: PCefStreamReader; var mimeType: TCefString;
    loadFlags: Integer): TCefRetval; stdcall;
var
  _redirectUrl: ustring;
  _resourceStream: ICefStreamReader;
  _mimeType: ustring;
begin
  with TCustomChromium(CefGetObject(self)) do
  begin
    _redirectUrl := CefString(@redirectUrl);
    _resourceStream := TCefStreamReaderRef.UnWrap(resourceStream);
    _mimeType := CefString(@mimeType);

    Result := doOnBeforeResourceLoad(
      TCefBrowserRef.UnWrap(abrowser),
      TCefRequestRef.UnWrap(request),
      _redirectUrl,
      _resourceStream,
      _mimeType,
      loadFlags
      );

    if _redirectUrl <> '' then
      redirectUrl := CefStringAlloc(_redirectUrl);

    if _resourceStream <> nil then
      resourceStream := _resourceStream.Wrap;

    if _mimeType <> '' then
      mimeType := CefStringAlloc(_mimeType);
  end;
end;

function cef_handler_handle_protocol_execution(self: PCefHandler; abrowser: PCefBrowser;
  const url: PCefString; var allow_os_execution: Integer): TCefRetval; stdcall;
var
  allow: Boolean;
begin
  allow := allow_os_execution <> 0;
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnProtocolExecution(
      TCefBrowserRef.UnWrap(abrowser),
      CefString(url), allow);
  if allow then
    allow_os_execution := 1 else
    allow_os_execution := 0;
end;

function cef_handler_handle_before_menu(
    self: PCefHandler; abrowser: PCefBrowser;
    const menuInfo: PCefHandlerMenuInfo): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnBeforeMenu(
      TCefBrowserRef.UnWrap(abrowser),
      menuInfo);
end;

function cef_handler_handle_get_menu_label(
    self: PCefHandler; abrowser: PCefBrowser;
    menuId: TCefHandlerMenuId; var label_: TCefString): TCefRetval; stdcall;
var
  str: ustring;
begin
  str := CefString(@label_);
  with TCustomChromium(CefGetObject(self)) do
  begin
    Result := doOnGetMenuLabel(
      TCefBrowserRef.UnWrap(abrowser),
      menuId,
      str);
    CefStringSet(@label_, str);
  end;
end;

function cef_handler_handle_menu_action(
    self: PCefHandler; abrowser: PCefBrowser;
    menuId: TCefHandlerMenuId): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnMenuAction(
      TCefBrowserRef.UnWrap(abrowser),
      menuId);
end;

function cef_handler_handle_print_header_footer(
    self: PCefHandler; abrowser: PCefBrowser;
    frame: PCefFrame; printInfo: PCefPrintInfo;
    url, title: PCefString; currentPage, maxPages: Integer;
    var topLeft, topCenter, topRight, bottomLeft, bottomCenter,
    bottomRight: TCefString): TCefRetval; stdcall;
var
  _topLeft, _topCenter, _topRight, _bottomLeft, _bottomCenter, _bottomRight: ustring;
begin
  with TCustomChromium(CefGetObject(self)) do
  begin
    Result := doOnPrintHeaderFooter(
      TCefBrowserRef.UnWrap(abrowser),
      TCefFrameRef.UnWrap(frame),
      printInfo, CefString(url), CefString(title), currentPage, maxPages,
      _topLeft, _topCenter, _topRight, _bottomLeft, _bottomCenter, _bottomRight
    );
    topLeft := CefStringAlloc(_topLeft);
    topCenter := CefStringAlloc(_topCenter);
    topRight := CefStringAlloc(_topRight);
    bottomLeft := CefStringAlloc(_bottomLeft);
    bottomCenter := CefStringAlloc(_bottomCenter);
    bottomRight := CefStringAlloc(_bottomRight);
  end;
end;

function cef_handler_handle_jsalert(self: PCefHandler;
    abrowser: PCefBrowser; frame: PCefFrame;
    const message: PCefString): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnJsAlert(
      TCefBrowserRef.UnWrap(abrowser),
      TCefFrameRef.UnWrap(frame),
      CefString(message));
end;

function cef_handler_handle_jsconfirm(
    self: PCefHandler; abrowser: PCefBrowser;
    frame: PCefFrame; const message: PCefString;
    var retval: Integer): TCefRetval; stdcall;
var
  ret: Boolean;
begin
  ret := retval <> 0;
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnJsConfirm(
      TCefBrowserRef.UnWrap(abrowser),
      TCefFrameRef.UnWrap(frame),
      CefString(message), ret);
  if Result = RV_HANDLED then
    retval := Ord(ret);

end;

function cef_handler_handle_jsprompt(self: PCefHandler;
    abrowser: PCefBrowser; frame: PCefFrame;
    const message, defaultValue: PCefString; var retval: Integer;
    var return: TCefString): TCefRetval; stdcall;
var
  ret: Boolean;
  str: ustring;
begin
  ret := retval <> 0;
  with TCustomChromium(CefGetObject(self)) do
  begin
    Result := doOnJsPrompt(
      TCefBrowserRef.UnWrap(abrowser),
      TCefFrameRef.UnWrap(frame),
      CefString(message), CefString(defaultValue), ret, str);
    if Result = RV_HANDLED then
    begin
      retval := Ord(ret);
      return := CefStringAlloc(str)
    end;
  end;
end;

function cef_handler_handle_before_window_close(
    self: PCefHandler; abrowser: PCefBrowser): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnBeforeWindowClose(
      TCefBrowserRef.UnWrap(abrowser))
end;

function cef_handler_handle_take_focus(
    self: PCefHandler; abrowser: PCefBrowser;
    reverse: Integer): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnTakeFocus(
      TCefBrowserRef.UnWrap(abrowser), reverse);
end;

function cef_handler_handle_set_focus(
    self: PCefHandler; abrowser: PCefBrowser;
    isWidget: Integer): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnSetFocus(
      TCefBrowserRef.UnWrap(abrowser), isWidget <> 0);
end;

function cef_handler_handle_key_event(
    self: PCefHandler; abrowser: PCefBrowser;
    event: TCefHandlerKeyEventType; code, modifiers,
    isSystemKey: Integer): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnKeyEvent(
      TCefBrowserRef.UnWrap(abrowser),
      event, code, modifiers, isSystemKey <> 0);
end;

function cef_handler_console_message(self: PCefHandler; abrowser: PCefBrowser;
  const message, source: PCefString; line: Integer): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnConsoleMessage(TCefBrowserRef.UnWrap(abrowser), CefString(message), CefString(source), line);
end;

function cef_handler_handle_status(self: PCefHandler; abrowser: PCefBrowser;
  value: PCefString; type_: TCefHandlerStatusType): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnStatus(TCefBrowserRef.UnWrap(abrowser), CefString(value), type_);
end;

function cef_handler_handle_find_result(self: PCefHandler; abrowser: PCefBrowser;
  identifier, count: Integer; const selectionRect: PCefRect;
  activeMatchOrdinal, finalUpdate: Integer): TCefRetval; stdcall;
begin
 with TCustomChromium(CefGetObject(self)) do
    Result := doOnFindResult(
      TCefBrowserRef.UnWrap(abrowser),
        count, selectionRect,
        identifier <> 0,
        activeMatchOrdinal <> 0,
        finalUpdate <> 0);
end;

function cef_handler_handle_print_options(self: PCefHandler; abrowser: PCefBrowser;
        printOptions: PCefPrintOptions): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnPrintOptions(
      TCefBrowserRef.UnWrap(abrowser), printOptions);
end;

function cef_handler_handle_jsbinding(self: PCefHandler; abrowser: PCefBrowser;
      frame: PCefFrame; obj: PCefv8Value): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnJsBinding(
      TCefBrowserRef.UnWrap(abrowser),
      TCefFrameRef.UnWrap(frame),
      TCefv8ValueRef.UnWrap(obj));
end;

function cef_handler_handle_tooltip(self: PCefHandler;
        abrowser: PCefBrowser; text: PCefString): TCefRetval; stdcall;
var
  t: ustring;
begin
  t := CefStringClearAndGet(text^);
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnTooltip(
      TCefBrowserRef.UnWrap(abrowser), t);
  text^ := CefStringAlloc(t);
end;

function cef_handler_handle_download_response(self: PCefHandler;
  abrowser: PCefBrowser; const mimeType, fileName: PCefString; contentLength: int64;
  var handler: PCefDownloadHandler): TCefRetval; stdcall;
var
  _handler: ICefDownloadHandler;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnDownloadResponse(
      TCefBrowserRef.UnWrap(abrowser),
      CefString(mimeType), CefString(fileName), contentLength, _handler);
  if _handler <> nil then
    handler := _handler.Wrap else
    handler := nil;
end;

function cef_handle_authentication_request(
  self: PCefHandler; abrowser: PCefBrowser; isProxy: Integer;
  const host: PCefString; const realm: PCefString; const scheme: PCefString;
  username: PCefString; password: PCefString): TCefRetval; stdcall;
var
  _username, _password: ustring;
begin
  _username := CefString(username);
  _password := CefString(password);
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnAuthenticationRequest(
      TCefBrowserRef.UnWrap(abrowser), isProxy <> 0,
      CefString(host), CefString(realm), CefString(scheme),
      _username, _password
    );
  if Result = RV_HANDLED then
  begin
    CefStringSet(username, _username);
    CefStringSet(password, _password);
  end;
end;

{ TCustomChromium }

constructor TCustomChromium.Create(AOwner: TComponent);
begin
  inherited;
{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  FAppEvents := TApplicationEvents.Create(Self);
  FAppEvents.OnIdle := doIdle;
{$ENDIF}
  InitializeCriticalSection(FCriticalSection);
  FSelf := Self;
  FillChar(FHandler, SizeOf(FHandler), 0);
  FHandler.base.size := SizeOf(FHandler);
  FHandler.handle_before_created := @cef_handler_handle_before_created;
  FHandler.handle_after_created := @cef_handler_handle_after_created;
  FHandler.handle_address_change := @cef_handler_handle_address_change;
  FHandler.handle_title_change := @cef_handler_handle_title_change;
  FHandler.handle_before_browse := @cef_handler_handle_before_browse;
  FHandler.handle_load_start := @cef_handler_handle_load_start;
  FHandler.handle_load_end := @cef_handler_handle_load_end;
  FHandler.handle_load_error := @cef_handler_handle_load_error;
  FHandler.handle_before_resource_load := @cef_handler_handle_before_resource_load;
  FHandler.handle_protocol_execution := @cef_handler_handle_protocol_execution;
  FHandler.handle_download_response := @cef_handler_handle_download_response;
  FHandler.handle_authentication_request := @cef_handle_authentication_request;
  FHandler.handle_before_menu := @cef_handler_handle_before_menu;
  FHandler.handle_get_menu_label := @cef_handler_handle_get_menu_label;
  FHandler.handle_menu_action := @cef_handler_handle_menu_action;
  FHandler.handle_print_header_footer := @cef_handler_handle_print_header_footer;
  FHandler.handle_jsalert := @cef_handler_handle_jsalert;
  FHandler.handle_jsconfirm := @cef_handler_handle_jsconfirm;
  FHandler.handle_jsprompt := @cef_handler_handle_jsprompt;
  FHandler.handle_before_window_close := @cef_handler_handle_before_window_close;
  FHandler.handle_take_focus := @cef_handler_handle_take_focus;
  FHandler.handle_set_focus := @cef_handler_handle_set_focus;
  FHandler.handle_key_event := @cef_handler_handle_key_event;
  FHandler.handle_console_message := @cef_handler_console_message;
  FHandler.handle_status := @cef_handler_handle_status;
  FHandler.handle_find_result := @cef_handler_handle_find_result;
  FHandler.handle_print_options := @cef_handler_handle_print_options;
  FHandler.handle_jsbinding := @cef_handler_handle_jsbinding;
  FHandler.handle_tooltip := @cef_handler_handle_tooltip;

  FOptions := [];
  FFontOptions := TChromiumFontOptions.Create;

  FUserStyleSheetLocation := '';
  FDefaultEncoding := '';

  FBrowserHandle := INVALID_HANDLE_VALUE;
  FBrowser := nil;
end;

destructor TCustomChromium.Destroy;
begin
  FBrowser := nil;
  DeleteCriticalSection(FCriticalSection);
  FFontOptions.Free;
{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  FAppEvents.Free;
{$ENDIF}
  inherited;
end;

{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
procedure TCustomChromium.doIdle(Sender: TObject; var Done: Boolean);
begin
  CefDoMessageLoopWork;
end;
{$ENDIF}

function TCustomChromium.doOnAddressChange(const browser: ICefBrowser;
  const frame: ICefFrame; const url: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnAddressChange) then
    FOnAddressChange(Self, browser, frame, url, Result);
end;

function TCustomChromium.doOnAfterCreated(const browser: ICefBrowser): TCefRetval;
begin
  if (browser <> nil) and not browser.IsPopup then
  begin
    FBrowser := browser;
    FBrowserHandle := browser.GetWindowHandle;
  end;
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
  const frame: ICefFrame; isMainContent: Boolean; httpStatusCode: Integer): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnLoadEnd) then
    FOnLoadEnd(Self, browser, frame, isMainContent, httpStatusCode, Result);
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
  const frame: ICefFrame; isMainContent: Boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnLoadStart) then
    FOnLoadStart(Self, browser, frame, isMainContent, Result);
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

procedure TCustomChromium.Lock;
begin
  EnterCriticalSection(FCriticalSection);
end;

procedure TCustomChromium.UnLock;
begin
  LeaveCriticalSection(FCriticalSection);
end;

procedure TCustomChromium.WndProc(var Message: TMessage);
var
  info: TCefWindowInfo;
  rect: TRect;
  hdwp: THandle;
  brws: ICefBrowser;
begin
  case Message.Msg of
    WM_CREATE:
    begin
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
        CefBrowserCreate(@info, False, @FHandler, FDefaultUrl);
      end;
      inherited WndProc(Message);
    end;
    WM_SIZE:
      begin
        if not (csDesigning in ComponentState) then
        begin
          brws := FBrowser;
          if (brws <> nil) and (brws.GetWindowHandle <> INVALID_HANDLE_VALUE) then
          begin
            rect := GetClientRect;
            hdwp := BeginDeferWindowPos(1);
            hdwp := DeferWindowPos(hdwp, brws.GetWindowHandle, 0,
              rect.left, rect.top, rect.right - rect.left, rect.bottom - rect.top,
              SWP_NOZORDER);
            EndDeferWindowPos(hdwp);
          end;
        end;
        inherited WndProc(Message);
      end;
    WM_SETFOCUS:
      begin
        if (FBrowser <> nil) and (FBrowser.GetWindowHandle <> 0) then
          PostMessage(FBrowser.GetWindowHandle, WM_SETFOCUS, Message.WParam, 0);
        inherited WndProc(Message);
      end;
    WM_ERASEBKGND:
      if (csDesigning in ComponentState) then
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

end.
