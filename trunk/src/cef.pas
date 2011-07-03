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
  SysUtils,  Classes, Controls, Messages, Windows, ceflib;

type
  TCustomChromium = class;

  TOnBeforePopup = procedure(const parentBrowser: ICefBrowser;
    var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
    var url: ustring; var client: ICefBase; out Result: Boolean) of object;
  TOnAfterCreated = procedure(Sender: TCustomChromium; const browser: ICefBrowser) of object;
  TOnQuitModal = procedure(Sender: TCustomChromium; const browser: ICefBrowser) of object;
  TOnRunModal = procedure(Sender: TCustomChromium; const browser: ICefBrowser; out Result: Boolean) of object;

  TOnLoadStart = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame) of object;
  TOnLoadEnd = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer; out Result: Boolean) of object;
  TOnLoadError = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    const frame: ICefFrame; errorCode: TCefHandlerErrorcode;
    const failedUrl: ustring; var errorText: ustring; out Result: Boolean) of object;

  TOnAuthCredentials = procedure(Sender: TCustomChromium; const browser: ICefBrowser; isProxy: Boolean;
    const host, realm, scheme: ustring; var username, password: ustring; out Result: Boolean) of object;
  TOnGetDownloadHandler = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const mimeType, fileName: ustring;
    contentLength: int64; var handler: ICefDownloadHandler; out Result: Boolean) of object;
  TOnBeforeBrowse = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame;
    const request: ICefRequest; navType: TCefHandlerNavtype;
    isRedirect: boolean; out Result: Boolean) of object;
  TOnBeforeResourceLoad = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    const request: ICefRequest; var redirectUrl: ustring;
    var resourceStream: ICefStreamReader; const response: ICefResponse;
    loadFlags: Integer; out Result: Boolean) of object;
  TOnProtocolExecution = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    const url: ustring; var AllowOsExecution: Boolean; out Result: Boolean) of object;
  TOnResourceResponse = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    const url: ustring; const response: ICefResponse; var filter: ICefBase) of object;

  TOnAddressChange = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    const frame: ICefFrame; const url: ustring; out Result: Boolean) of object;
  TOnConsoleMessage = procedure(Sender: TCustomChromium; const browser: ICefBrowser; message, source: ustring;
    line: Integer; out Result: Boolean) of object;
  TOnNavStateChange = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    canGoBack, canGoForward: Boolean; out Result: Boolean) of object;
  TOnStatusMessage = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const value: ustring; StatusType: TCefHandlerStatusType; out Result: Boolean) of object;
  TOnTitleChange = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    const title: ustring; out Result: Boolean) of object;
  TOnTooltip = procedure(Sender: TCustomChromium; const browser: ICefBrowser; var text: ustring; out Result: Boolean) of object;

  TOnTakeFocus = procedure(Sender: TCustomChromium; const browser: ICefBrowser; next: Boolean) of object;
  TOnSetFocus = procedure(Sender: TCustomChromium; const browser: ICefBrowser; isWidget: Boolean; out Result: Boolean) of object;

  TOnKeyEvent = procedure(Sender: TCustomChromium; const browser: ICefBrowser; event: TCefHandlerKeyEventType;
    code, modifiers: Integer; isSystemKey: Boolean; out Result: Boolean) of object;

  TOnBeforeMenu = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    const menuInfo: PCefHandlerMenuInfo; out Result: Boolean) of object;
  TOnGetMenuLabel = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    menuId: TCefHandlerMenuId; var caption: ustring; out Result: Boolean) of object;
  TOnMenuAction = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    menuId: TCefHandlerMenuId; out Result: Boolean) of object;

  TOnPrintHeaderFooter = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    const frame: ICefFrame; printInfo: PCefPrintInfo;
    const url, title: ustring; currentPage, maxPages: Integer;
    var topLeft, topCenter, topRight, bottomLeft, bottomCenter,
    bottomRight: ustring; out Result: Boolean) of object;
  TOnPrintOptions = procedure(Sender: TCustomChromium; const browser: ICefBrowser; printOptions: PCefPrintOptions; out Result: Boolean) of object;

  TOnJsAlert = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame;
    const message: ustring; out Result: Boolean) of object;
  TOnJsConfirm = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame;
    const message: ustring; var retval: Boolean; out Result: Boolean) of object;
  TOnJsPrompt = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame;
    const message, defaultValue: ustring; var retval: Boolean;
    var return: ustring; out Result: Boolean) of object;
  TOnBeforeClose = procedure(Sender: TCustomChromium; const browser: ICefBrowser; out Result: Boolean) of object;
  TOnJsBinding = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame; const obj: ICefv8Value; out Result: Boolean) of object;
  TOnFindResult = procedure(Sender: TCustomChromium; const browser: ICefBrowser; count: Integer;
    selectionRect: PCefRect; identifier, activeMatchOrdinal,
    finalUpdate: Boolean; out Result: Boolean) of object;

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

    FOnBeforePopup: TOnBeforePopup;
    FOnAfterCreated: TOnAfterCreated;
    FOnBeforeClose: TOnBeforeClose;
    FOnQuitModal: TOnQuitModal;
    FOnRunModal: TOnRunModal;

    FOnLoadStart: TOnLoadStart;
    FOnLoadEnd: TOnLoadEnd;
    FOnLoadError: TOnLoadError;

    FOnAuthCredentials: TOnAuthCredentials;
    FOnGetDownloadHandler: TOnGetDownloadHandler;
    FOnBeforeBrowse: TOnBeforeBrowse;
    FOnBeforeResourceLoad: TOnBeforeResourceLoad;
    FOnProtocolExecution: TOnProtocolExecution;
    FOnResourceResponse: TOnResourceResponse;

    FOnAddressChange: TOnAddressChange;
    FOnConsoleMessage: TOnConsoleMessage;
    FOnNavStateChange: TOnNavStateChange;
    FOnStatusMessage: TOnStatusMessage;
    FOnTitleChange: TOnTitleChange;
    FOnTooltip: TOnTooltip;

    FOnTakeFocus: TOnTakeFocus;
    FOnSetFocus: TOnSetFocus;

    FOnKeyEvent: TOnKeyEvent;

    FOnBeforeMenu: TOnBeforeMenu;
    FOnGetMenuLabel: TOnGetMenuLabel;
    FOnMenuAction: TOnMenuAction;

    FOnPrintHeaderFooter: TOnPrintHeaderFooter;
    FOnPrintOptions: TOnPrintOptions;

    FOnFindResult: TOnFindResult;

    FOnJsAlert: TOnJsAlert;
    FOnJsConfirm: TOnJsConfirm;
    FOnJsPrompt: TOnJsPrompt;
    FOnJsBinding: TOnJsBinding;

    FOptions: TChromiumOptions;
    FUserStyleSheetLocation: ustring;
    FDefaultEncoding: ustring;
    FFontOptions: TChromiumFontOptions;

    procedure GetSettings(var settings: TCefBrowserSettings);
    procedure CreateBrowser;
  protected
    procedure WndProc(var Message: TMessage); override;
    procedure Loaded; override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure Resize; override;

    function doOnBeforePopup(const parentBrowser: ICefBrowser;
      var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
      var url: ustring; var client: ICefBase): Boolean; virtual;
    procedure doOnAfterCreated(const browser: ICefBrowser); virtual;
    function doOnBeforeClose(const browser: ICefBrowser): Boolean; virtual;
    procedure doOnQuitModal(const browser: ICefBrowser); virtual;
    function doOnRunModal(const browser: ICefBrowser): Boolean; virtual;

    procedure doOnLoadStart(const browser: ICefBrowser; const frame: ICefFrame); virtual;
    function doOnLoadEnd(const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer): Boolean; virtual;
    function doOnLoadError(const browser: ICefBrowser;
      const frame: ICefFrame; errorCode: TCefHandlerErrorcode;
      const failedUrl: ustring; var errorText: ustring): Boolean; virtual;

    function doOnAuthCredentials(const browser: ICefBrowser; isProxy: Boolean;
      const host, realm, scheme: ustring; var username, password: ustring): Boolean; virtual;
    function doOnGetDownloadHandler(const browser: ICefBrowser; const mimeType, fileName: ustring;
      contentLength: int64; var handler: ICefDownloadHandler): Boolean; virtual;
    function doOnBeforeBrowse(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; navType: TCefHandlerNavtype;
      isRedirect: boolean): Boolean; virtual;
    function doOnBeforeResourceLoad(const browser: ICefBrowser;
      const request: ICefRequest; var redirectUrl: ustring;
      var resourceStream: ICefStreamReader; const response: ICefResponse;
      loadFlags: Integer): Boolean; virtual;
    function doOnProtocolExecution(const browser: ICefBrowser;
      const url: ustring; var AllowOsExecution: Boolean): Boolean; virtual;
    procedure doOnResourceResponse(const browser: ICefBrowser;
      const url: ustring; const response: ICefResponse; var filter: ICefBase); virtual;

    function doOnAddressChange(const browser: ICefBrowser;
      const frame: ICefFrame; const url: ustring): Boolean; virtual;
    function doOnConsoleMessage(const browser: ICefBrowser; const message,
      source: ustring; line: Integer): Boolean; stdcall;
    function doOnNavStateChange(const browser: ICefBrowser; canGoBack,
      canGoForward: Boolean): Boolean; virtual;
    function doOnStatusMessage(const browser: ICefBrowser; const value: ustring;
      StatusType: TCefHandlerStatusType): Boolean; virtual;
    function doOnTitleChange(const browser: ICefBrowser;
      const title: ustring): Boolean; virtual;
    function doOnTooltip(const browser: ICefBrowser; var text: ustring): Boolean; virtual;

    procedure doOnTakeFocus(const browser: ICefBrowser; next: Boolean); virtual;
    function doOnSetFocus(const browser: ICefBrowser; isWidget: Boolean): Boolean; virtual;

    function doOnKeyEvent(const browser: ICefBrowser; event: TCefHandlerKeyEventType;
      code, modifiers: Integer; isSystemKey: Boolean): Boolean; virtual;

    function doOnBeforeMenu(const browser: ICefBrowser;
      const menuInfo: PCefHandlerMenuInfo): Boolean; virtual;
    function doOnGetMenuLabel(const browser: ICefBrowser;
      menuId: TCefHandlerMenuId; var caption: ustring): Boolean; virtual;
    function doOnMenuAction(const browser: ICefBrowser;
      menuId: TCefHandlerMenuId): Boolean; virtual;

    function doOnPrintHeaderFooter(const browser: ICefBrowser;
      const frame: ICefFrame; printInfo: PCefPrintInfo;
      const url, title: ustring; currentPage, maxPages: Integer;
      var topLeft, topCenter, topRight, bottomLeft, bottomCenter,
      bottomRight: ustring): Boolean; virtual;
    function doOnPrintOptions(const browser: ICefBrowser;
        printOptions: PCefPrintOptions): Boolean; virtual;

    function doOnJsAlert(const browser: ICefBrowser; const frame: ICefFrame;
      const message: ustring): Boolean; virtual;
    function doOnJsConfirm(const browser: ICefBrowser; const frame: ICefFrame;
      const message: ustring; var retval: Boolean): Boolean; virtual;
    function doOnJsPrompt(const browser: ICefBrowser; const frame: ICefFrame;
      const message, defaultValue: ustring; var retval: Boolean;
      var return: ustring): Boolean; virtual;
    function doOnJsBinding(const browser: ICefBrowser;
      const frame: ICefFrame; const obj: ICefv8Value): Boolean; virtual;
    function doOnFindResult(const browser: ICefBrowser; count: Integer;
      selectionRect: PCefRect; identifier, activeMatchOrdinal,
      finalUpdate: Boolean): Boolean; virtual;

    property DefaultUrl: ustring read FDefaultUrl write FDefaultUrl;

    property OnBeforePopup: TOnBeforePopup read FOnBeforePopup write FOnBeforePopup;
    property OnAfterCreated: TOnAfterCreated read FOnAfterCreated write FOnAfterCreated;
    property OnBeforeClose: TOnBeforeClose read FOnBeforeClose write FOnBeforeClose;
    property OnQuitModal: TOnQuitModal read FOnQuitModal write FOnQuitModal;
    property OnRunModal: TOnRunModal read FOnRunModal write FOnRunModal;

    property OnLoadStart: TOnLoadStart read FOnLoadStart write FOnLoadStart;
    property OnLoadEnd: TOnLoadEnd read FOnLoadEnd write FOnLoadEnd;
    property OnLoadError: TOnLoadError read FOnLoadError write FOnLoadError;

    property OnAuthCredentials: TOnAuthCredentials read FOnAuthCredentials write FOnAuthCredentials;
    property OnGetDownloadHandler: TOnGetDownloadHandler read FOnGetDownloadHandler write FOnGetDownloadHandler;
    property OnBeforeBrowse: TOnBeforeBrowse read FOnBeforeBrowse write FOnBeforeBrowse;
    property OnBeforeResourceLoad: TOnBeforeResourceLoad read FOnBeforeResourceLoad write FOnBeforeResourceLoad;
    property OnProtocolExecution: TOnProtocolExecution read FOnProtocolExecution write FOnProtocolExecution;
    property OnResourceResponse: TOnResourceResponse read FOnResourceResponse write FOnResourceResponse;

    property OnAddressChange: TOnAddressChange read FOnAddressChange write FOnAddressChange;
    property OnConsoleMessage: TOnConsoleMessage read FOnConsoleMessage write FOnConsoleMessage;
    property OnNavStateChange: TOnNavStateChange read FOnNavStateChange write FOnNavStateChange;
    property OnStatusMessage: TOnStatusMessage read FOnStatusMessage write FOnStatusMessage;
    property OnTitleChange: TOnTitleChange read FOnTitleChange write FOnTitleChange;
    property OnTooltip: TOnTooltip read FOnTooltip write FOnTooltip;

    property OnTakeFocus: TOnTakeFocus read FOnTakeFocus write FOnTakeFocus;
    property OnSetFocus: TOnSetFocus read FOnSetFocus write FOnSetFocus;

    property OnKeyEvent: TOnKeyEvent read FOnKeyEvent write FOnKeyEvent;

    property OnBeforeMenu: TOnBeforeMenu read FOnBeforeMenu write FOnBeforeMenu;
    property OnGetMenuLabel: TOnGetMenuLabel read FOnGetMenuLabel write FOnGetMenuLabel;
    property OnMenuAction: TOnMenuAction read FOnMenuAction write FOnMenuAction;

    property OnPrintHeaderFooter: TOnPrintHeaderFooter read FOnPrintHeaderFooter write FOnPrintHeaderFooter;
    property OnPrintOptions: TOnPrintOptions read FOnPrintOptions write FOnPrintOptions;

    property OnJsAlert: TOnJsAlert read FOnJsAlert write FOnJsAlert;
    property OnJsConfirm: TOnJsConfirm read FOnJsConfirm write FOnJsConfirm;
    property OnJsPrompt: TOnJsPrompt read FOnJsPrompt write FOnJsPrompt;
    property OnJsBinding: TOnJsBinding read FOnJsBinding write FOnJsBinding;
    property OnFindResult: TOnFindResult read FOnFindResult write FOnFindResult;

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
    procedure ReCreateBrowser(const url: string);
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

    property OnBeforePopup;
    property OnAfterCreated;
    property OnBeforeClose;
    property OnQuitModal;
    property OnRunModal;

    property OnLoadStart;
    property OnLoadEnd;
    property OnLoadError;

    property OnAuthCredentials;
    property OnGetDownloadHandler;
    property OnBeforeBrowse;
    property OnBeforeResourceLoad;
    property OnProtocolExecution;
    property OnResourceResponse;

    property OnAddressChange;
    property OnConsoleMessage;
    property OnNavStateChange;
    property OnStatusMessage;
    property OnTitleChange;
    property OnTooltip;

    property OnTakeFocus;
    property OnSetFocus;

    property OnKeyEvent;

    property OnBeforeMenu;
    property OnGetMenuLabel;
    property OnMenuAction;

    property OnPrintHeaderFooter;
    property OnPrintOptions;

    property OnJsAlert;
    property OnJsConfirm;
    property OnJsPrompt;
    property OnJsBinding;
    property OnFindResult;

    property Options;
    property FontOptions;
    property DefaultEncoding;
    property UserStyleSheetLocation;
  end;

  ICefClientHandler = interface
    ['{E76F6888-D9C3-4FCE-9C23-E89659820A36}']
    procedure Disconnect;
  end;

  TCustomClientHandler = class(TCefClientOwn, ICefClientHandler)
  private
    FLifeSpanHandler: ICefBase;
    FLoadHandler: ICefBase;
    FRequestHandler: ICefBase;
    FDisplayHandler: ICefBase;
    FFocusHandler: ICefBase;
    FKeyboardHandler: ICefBase;
    FMenuHandler: ICefBase;
    FPrintHandler: ICefBase;
    FFindHandler: ICefBase;
    FJsdialogHandler: ICefBase;
    FJsbindingHandler: ICefBase;
    FRenderHandler: ICefBase;
  protected
    function GetLifeSpanHandler: ICefBase; override;
    function GetLoadHandler: ICefBase; override;
    function GetRequestHandler: ICefBase; override;
    function GetDisplayHandler: ICefBase; override;
    function GetFocusHandler: ICefBase; override;
    function GetKeyboardHandler: ICefBase; override;
    function GetMenuHandler: ICefBase; override;
    function GetPrintHandler: ICefBase; override;
    function GetFindHandler: ICefBase; override;
    function GetJsdialogHandler: ICefBase; override;
    function GetJsbindingHandler: ICefBase; override;
    function GetRenderHandler: ICefBase; override;
    procedure Disconnect;
  public
    constructor Create(crm: TCustomChromium); reintroduce;
    destructor Destroy; override;
  end;

  TCustomLifeSpanHandler = class(TCefLifeSpanHandlerOwn)
  private
    FCrm: TCustomChromium;
  protected
    function OnBeforePopup(const parentBrowser: ICefBrowser;
       var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
       var url: ustring; var client: ICefBase;
       var settings: TCefBrowserSettings): Boolean; override;
    procedure OnAfterCreated(const browser: ICefBrowser); override;
    procedure OnBeforeClose(const browser: ICefBrowser); override;
    function RunModal(const browser: ICefBrowser): Boolean; override;
    procedure QuitModal(const browser: ICefBrowser); override;
  public
    constructor Create(crm: TCustomChromium); reintroduce;
  end;

  TCustomLoadHandler = class(TCefLoadHandlerOwn)
  private
    FCrm: TCustomChromium;
  protected
    procedure OnLoadStart(const browser: ICefBrowser; const frame: ICefFrame); override;
    procedure OnLoadEnd(const browser: ICefBrowser; const frame: ICefFrame; httpStatusCode: Integer); override;
    function OnLoadError(const browser: ICefBrowser; const frame: ICefFrame;
      errorCode: TCefHandlerErrorcode; const failedUrl: ustring; var errorText: ustring): Boolean; override;
  public
    constructor Create(crm: TCustomChromium); reintroduce;
  end;

  TCustomRequestHandler = class(TCefRequestHandlerOwn)
  private
    FCrm: TCustomChromium;
  protected
    function OnBeforeBrowse(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; navType: TCefHandlerNavtype;
      isRedirect: Boolean): Boolean; override;
    function OnBeforeResourceLoad(const browser: ICefBrowser; const request: ICefRequest;
      var redirectUrl: ustring;  var resourceStream: ICefStreamReader;
      const response: ICefResponse; loadFlags: Integer): Boolean; override;
    procedure OnResourceResponse(const browser: ICefBrowser; const url: ustring;
        const response: ICefResponse; var filter: ICefBase); override;
    function OnProtocolExecution(const browser: ICefBrowser; const url: ustring;
        var allowOSExecution: Boolean): Boolean; override;
    function GetDownloadHandler(const browser: ICefBrowser;
      const mimeType, fileName: ustring; contentLength: int64;
        var handler: ICefDownloadHandler): Boolean; override;
    function GetAuthCredentials(const browser: ICefBrowser;
      isProxy: Boolean; const host, realm, scheme: ustring;
      var username, password: ustring): Boolean; override;
  public
    constructor Create(crm: TCustomChromium); reintroduce;
  end;

  TCustomDisplayHandler = class(TCefDisplayHandlerOwn)
  private
    FCrm: TCustomChromium;
  protected
    procedure OnNavStateChange(const browser: ICefBrowser;
      canGoBack, canGoForward: Boolean); override;
    procedure OnAddressChange(const browser: ICefBrowser;
      const frame: ICefFrame; const url: ustring); override;
    procedure OnTitleChange(const browser: ICefBrowser;
      const title: ustring); override;
    function OnTooltip(const browser: ICefBrowser;
      var text: ustring): Boolean; override;
    procedure OnStatusMessage(const browser: ICefBrowser; const value: ustring;
        kind: TCefHandlerStatusType); override;
    function OnConsoleMessage(const browser: ICefBrowser; const message,
      source: ustring; line: Integer): Boolean; override;
  public
    constructor Create(crm: TCustomChromium); reintroduce;
  end;

  TCustomFocusHandler = class(TCefFocusHandlerOwn)
  private
    FCrm: TCustomChromium;
  protected
    procedure OnTakeFocus(const browser: ICefBrowser; next: Boolean); override;
    function OnSetFocus(const browser: ICefBrowser; isWidget: Boolean): Boolean; override;
  public
    constructor Create(crm: TCustomChromium); reintroduce;
  end;

  TCustomKeyboardHandler = class(TCefKeyboardHandlerOwn)
  private
    FCrm: TCustomChromium;
  protected
    function OnKeyEvent(const browser: ICefBrowser; event: TCefHandlerKeyEventType;
      code, modifiers: Integer; isSystemKey: Boolean): Boolean; override;
  public
    constructor Create(crm: TCustomChromium); reintroduce;
  end;

  TCustomMenuHandler = class(TCefMenuHandlerOwn)
  private
    FCrm: TCustomChromium;
  protected
    function OnBeforeMenu(const browser: ICefBrowser;
      const menuInfo: PCefHandlerMenuInfo): Boolean; override;
    procedure GetMenuLabel(const browser: ICefBrowser;
      menuId: TCefHandlerMenuId; var caption: ustring); override;
    function OnMenuAction(const browser: ICefBrowser;
      menuId: TCefHandlerMenuId): Boolean; override;
  public
    constructor Create(crm: TCustomChromium); reintroduce;
  end;

  TCustomPrintHandler = class(TCefPrintHandlerOwn)
  private
    FCrm: TCustomChromium;
  protected
    function GetPrintOptions(const browser: ICefBrowser;
      printOptions: PCefPrintOptions): Boolean; override;
    function GetPrintHeaderFooter(const browser: ICefBrowser; const frame: ICefFrame;
      const printInfo: PCefPrintInfo; const url, title: ustring; currentPage, maxPages: Integer;
      var topLeft, topCenter, topRight, bottomLeft, bottomCenter, bottomRight: ustring): Boolean; override;
  public
    constructor Create(crm: TCustomChromium); reintroduce;
  end;

  TCustomFindHandler = class(TCefFindHandlerOwn)
  private
    FCrm: TCustomChromium;
  protected
    procedure OnFindResult(const browser: ICefBrowser; count: Integer;
      const selectionRect: PCefRect; identifier, activeMatchOrdinal,
      finalUpdate: Boolean); override;
  public
    constructor Create(crm: TCustomChromium); reintroduce;
  end;

  TCustomJsDialogHandler = class(TCefJsDialogHandlerOwn)
  private
    FCrm: TCustomChromium;
  protected
    function OnJsAlert(const browser: ICefBrowser; const frame: ICefFrame;
      const message: ustring): Boolean; override;
    function OnJsConfirm(const browser: ICefBrowser; const frame: ICefFrame;
      const message: ustring; var retval: Boolean): Boolean; override;
    function OnJsPrompt(const browser: ICefBrowser; const frame: ICefFrame;
      const message, defaultValue: ustring; var retval: Boolean;
      var return: ustring): Boolean; override;
  public
    constructor Create(crm: TCustomChromium); reintroduce;
  end;

  TCustomJsBindingHandler = class(TCefJsBindingHandlerOwn)
  private
    FCrm: TCustomChromium;
  protected
    procedure OnJsBinding(const browser: ICefBrowser;
      const frame: ICefFrame; const obj: ICefv8Value); override;
  public
    constructor Create(crm: TCustomChromium); reintroduce;
  end;

procedure Register;

implementation

{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
var
  CefInstances: Integer = 0;
  CefTimer: UINT = 0;
{$ENDIF}

procedure Register;
begin
  RegisterComponents('Chromium', [TChromium]);
end;

{ TCustomChromium }

constructor TCustomChromium.Create(AOwner: TComponent);
begin
  inherited;
  if not (csDesigning in ComponentState) then
    FHandler := TCustomClientHandler.Create(Self) as ICefBase;

  FOptions := [];
  FFontOptions := TChromiumFontOptions.Create;

  FUserStyleSheetLocation := '';
  FDefaultEncoding := '';

  FBrowserHandle := INVALID_HANDLE_VALUE;
  FBrowser := nil;
end;

procedure TCustomChromium.CreateBrowser;
var
  info: TCefWindowInfo;
  rect: TRect;
  settings: TCefBrowserSettings;
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
    FillChar(settings, SizeOf(TCefBrowserSettings), 0);
    settings.size := SizeOf(TCefBrowserSettings);
    GetSettings(settings);
{$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
    CefBrowserCreate(@info, FHandler.Wrap, FDefaultUrl, @settings);
{$ELSE}
    FBrowser := CefBrowserCreateSync(@info, FHandler.Wrap, '', @settings);
    FBrowserHandle := FBrowser.GetWindowHandle;
{$ENDIF}
  end;
end;

procedure TCustomChromium.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited;
  CreateBrowser;
end;

destructor TCustomChromium.Destroy;
begin
  if FHandler <> nil then
    (FHandler as ICefClientHandler).Disconnect;
  FHandler := nil;
  FBrowser := nil;
//  SendMessage(FBrowserHandle, WM_CLOSE, 0, 0);
//  SendMessage(FBrowserHandle, WM_DESTROY, 0, 0);
  FFontOptions.Free;
  inherited;
end;

function TCustomChromium.doOnAddressChange(const browser: ICefBrowser;
  const frame: ICefFrame; const url: ustring): Boolean;
begin
  Result := False;
  if Assigned(FOnAddressChange) then
    FOnAddressChange(Self, browser, frame, url, Result);
end;

procedure TCustomChromium.doOnAfterCreated(const browser: ICefBrowser);
begin
{$IFDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  if (browser <> nil) and not browser.IsPopup then
  begin
    FBrowser := browser;
    FBrowserHandle := browser.GetWindowHandle;
  end;
{$ENDIF}
  if Assigned(FOnAfterCreated) then
    FOnAfterCreated(Self, browser);
end;

function TCustomChromium.doOnAuthCredentials(const browser: ICefBrowser;
  isProxy: Boolean; const host, realm, scheme: ustring; var username,
  password: ustring): Boolean;
begin
  Result := False;
  if Assigned(FOnAuthCredentials) then
    FOnAuthCredentials(Self, browser, isProxy, host, realm, scheme, username, password, Result);
end;

function TCustomChromium.doOnBeforeBrowse(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest;
  navType: TCefHandlerNavtype; isRedirect: boolean): Boolean;
begin
  Result := False;
  if Assigned(FOnBeforeBrowse) then
    FOnBeforeBrowse(Self, browser, frame, request, navType, isRedirect, Result);
end;

function TCustomChromium.doOnBeforeMenu(const browser: ICefBrowser;
  const menuInfo: PCefHandlerMenuInfo): Boolean;
begin
  Result := False;
  if Assigned(FOnBeforeMenu) then
    FOnBeforeMenu(Self, browser, menuInfo, Result);
end;

function TCustomChromium.doOnBeforePopup(const parentBrowser: ICefBrowser;
  var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
  var url: ustring; var client: ICefBase): Boolean;
begin
  Result := False;
  if Assigned(FOnBeforePopup) then
    FOnBeforePopup(parentBrowser, popupFeatures, windowInfo, url, client, Result);
end;

function TCustomChromium.doOnBeforeResourceLoad(const browser: ICefBrowser;
  const request: ICefRequest; var redirectUrl: ustring;
  var resourceStream: ICefStreamReader; const response: ICefResponse;
  loadFlags: Integer): Boolean;
begin
  Result := False;
  if Assigned(FOnBeforeResourceLoad) then
    FOnBeforeResourceLoad(Self, browser, request, redirectUrl, resourceStream,
      response, loadFlags, Result);
end;

function TCustomChromium.doOnBeforeClose(
  const browser: ICefBrowser): Boolean;
begin
  Result := False;
  if Assigned(FOnBeforeClose) then
    FOnBeforeClose(Self, browser, Result);
end;

function TCustomChromium.doOnConsoleMessage(const browser: ICefBrowser; const message,
  source: ustring; line: Integer): Boolean;
begin
  Result := False;
  if Assigned(FOnConsoleMessage) then
    FOnConsoleMessage(Self, browser, message, source, line, Result);
end;

function TCustomChromium.doOnGetDownloadHandler(const browser: ICefBrowser;
  const mimeType, fileName: ustring; contentLength: int64;
  var handler: ICefDownloadHandler): Boolean;
begin
  Result := False;
  if Assigned(FOnGetDownloadHandler) then
    FOnGetDownloadHandler(Self, browser, mimeType, fileName, contentLength, handler, Result);
end;

function TCustomChromium.doOnFindResult(const browser: ICefBrowser;
  count: Integer; selectionRect: PCefRect; identifier, activeMatchOrdinal,
  finalUpdate: Boolean): Boolean;
begin
  Result := False;
  if Assigned(FOnFindResult) then
    FOnFindResult(Self, browser, count, selectionRect, identifier,
      activeMatchOrdinal, finalUpdate, Result);
end;

function TCustomChromium.doOnGetMenuLabel(const browser: ICefBrowser;
  menuId: TCefHandlerMenuId; var caption: ustring): Boolean;
begin
  Result := False;
  if Assigned(FOnGetMenuLabel) then
    FOnGetMenuLabel(Self, browser, menuId, caption, Result);
end;

function TCustomChromium.doOnJsAlert(const browser: ICefBrowser;
  const frame: ICefFrame; const message: ustring): Boolean;
begin
  Result := False;
  if Assigned(FOnJsAlert) then
    FOnJsAlert(Self, browser, frame, message, Result);
end;

function TCustomChromium.doOnJsBinding(const browser: ICefBrowser;
  const frame: ICefFrame; const obj: ICefv8Value): Boolean;
begin
  Result := False;
  if Assigned(FOnJsBinding) then
    FOnJsBinding(Self, browser, frame, obj, Result);
end;

function TCustomChromium.doOnJsConfirm(const browser: ICefBrowser;
  const frame: ICefFrame; const message: ustring;
  var retval: Boolean): Boolean;
begin
  Result := False;
  if Assigned(FOnJsConfirm) then
    FOnJsConfirm(Self, browser, frame, message, retval, Result);
end;

function TCustomChromium.doOnJsPrompt(const browser: ICefBrowser;
  const frame: ICefFrame; const message, defaultValue: ustring;
  var retval: Boolean; var return: ustring): Boolean;
begin
  Result := False;
  if Assigned(FOnJsPrompt) then
    FOnJsPrompt(Self, browser, frame, message, defaultValue, retval, return, Result);
end;

function TCustomChromium.doOnKeyEvent(const browser: ICefBrowser;
  event: TCefHandlerKeyEventType; code, modifiers: Integer;
  isSystemKey: Boolean): Boolean;
begin
  Result := False;
  if Assigned(FOnKeyEvent) then
    FOnKeyEvent(Self, browser, event, code, modifiers, isSystemKey, Result);
end;

function TCustomChromium.doOnLoadEnd(const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: Integer): Boolean;
begin
  Result := False;
  if Assigned(FOnLoadEnd) then
    FOnLoadEnd(Self, browser, frame, httpStatusCode, Result);
end;

function TCustomChromium.doOnLoadError(const browser: ICefBrowser;
  const frame: ICefFrame; errorCode: TCefHandlerErrorcode;
  const failedUrl: ustring; var errorText: ustring): Boolean;
begin
  Result := False;
  if Assigned(FOnLoadError) then
    FOnLoadError(Self, browser, frame, errorCode, failedUrl, errorText, Result);
end;

procedure TCustomChromium.doOnLoadStart(const browser: ICefBrowser;
  const frame: ICefFrame);
begin
  if Assigned(FOnLoadStart) then
    FOnLoadStart(Self, browser, frame);
end;

function TCustomChromium.doOnMenuAction(const browser: ICefBrowser;
  menuId: TCefHandlerMenuId): Boolean;
begin
  Result := False;
  if Assigned(FOnMenuAction) then
    FOnMenuAction(Self, browser, menuId, Result);
end;

function TCustomChromium.doOnNavStateChange(const browser: ICefBrowser;
  canGoBack, canGoForward: Boolean): Boolean;
begin
  Result := False;
  if Assigned(FOnNavStateChange) then
    FOnNavStateChange(Self, browser, canGoBack, canGoForward, Result);
end;

function TCustomChromium.doOnPrintHeaderFooter(const browser: ICefBrowser;
  const frame: ICefFrame; printInfo: PCefPrintInfo; const url, title: ustring;
  currentPage, maxPages: Integer; var topLeft, topCenter, topRight, bottomLeft,
  bottomCenter, bottomRight: ustring): Boolean;
begin
  Result := False;
  if Assigned(FOnPrintHeaderFooter) then
    FOnPrintHeaderFooter(Self, browser, frame, printInfo, url, title,
      currentPage, maxPages, topLeft, topCenter, topRight, bottomLeft,
      bottomCenter, bottomRight, Result);
end;

function TCustomChromium.doOnPrintOptions(const browser: ICefBrowser;
  printOptions: PCefPrintOptions): Boolean;
begin
  Result := False;
  if Assigned(FOnPrintOptions) then
    FOnPrintOptions(Self, browser, printOptions, Result);
end;

function TCustomChromium.doOnProtocolExecution(const browser: ICefBrowser;
  const url: ustring; var AllowOsExecution: Boolean): Boolean;
begin
  Result := False;
  if Assigned(FOnProtocolExecution) then
    FOnProtocolExecution(Self, browser, url, AllowOsExecution, Result);
end;

procedure TCustomChromium.doOnQuitModal(const browser: ICefBrowser);
begin
  if Assigned(FOnQuitModal) then
    FOnQuitModal(Self, browser);
end;

procedure TCustomChromium.doOnResourceResponse(const browser: ICefBrowser;
  const url: ustring; const response: ICefResponse; var filter: ICefBase);
begin
  if Assigned(FOnResourceResponse) then
    FOnResourceResponse(Self, browser, url, response, filter);
end;

function TCustomChromium.doOnRunModal(const browser: ICefBrowser): Boolean;
begin
  Result := False;
  if Assigned(FOnRunModal) then
    FOnRunModal(Self, browser, Result);
end;

function TCustomChromium.doOnSetFocus(const browser: ICefBrowser;
  isWidget: Boolean): Boolean;
begin
  Result := False;
  if Assigned(FOnSetFocus) then
    FOnSetFocus(Self, browser, isWidget, Result);
end;

function TCustomChromium.doOnStatusMessage(const browser: ICefBrowser;
  const value: ustring; StatusType: TCefHandlerStatusType): Boolean;
begin
  Result := False;
  if Assigned(FOnStatusMessage) then
    FOnStatusMessage(Self, browser, value, StatusType, Result);
end;

procedure TCustomChromium.doOnTakeFocus(const browser: ICefBrowser;
  next: Boolean);
begin
  if Assigned(FOnTakeFocus) then
    FOnTakeFocus(Self, browser, next);
end;

function TCustomChromium.doOnTitleChange(const browser: ICefBrowser;
  const title: ustring): Boolean;
begin
  Result := False;
  if Assigned(FOnTitleChange) then
    FOnTitleChange(Self, browser, title, Result);
end;

function TCustomChromium.doOnTooltip(const browser: ICefBrowser;
  var text: ustring): Boolean;
begin
  Result := False;
  if Assigned(FOnTooltip) then
    FOnTooltip(Self, browser, text, Result);
end;

procedure TCustomChromium.GetSettings(var settings: TCefBrowserSettings);
begin
  Assert(settings.size = SizeOf(settings));
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

procedure TCustomChromium.ReCreateBrowser(const url: string);
begin
  if (FBrowser <> nil) and (FBrowserHandle <> 0) then
  begin
    SendMessage(FBrowserHandle, WM_CLOSE, 0, 0);
    SendMessage(FBrowserHandle, WM_DESTROY, 0, 0);
    FBrowserHandle := 0;
    FBrowser := nil;

    CreateBrowser;
    Load(url);
  end;
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
    CM_WANTSPECIALKEY:
      if not (TWMKey(Message).CharCode in [VK_LEFT .. VK_DOWN]) then
        Message.Result := 1 else
        inherited WndProc(Message);
    WM_GETDLGCODE:
      Message.Result := DLGC_WANTARROWS;
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

{ TCefCustomHandler }

constructor TCustomClientHandler.Create(crm: TCustomChromium);
begin
  inherited Create;
  FLifeSpanHandler := TCustomLifeSpanHandler.Create(crm);
  FLoadHandler := TCustomLoadHandler.Create(crm);
  FRequestHandler := TCustomRequestHandler.Create(crm);
  FDisplayHandler := TCustomDisplayHandler.Create(crm);
  FFocusHandler := TCustomFocusHandler.Create(crm);
  FKeyboardHandler := TCustomKeyboardHandler.Create(crm);
  FMenuHandler := TCustomMenuHandler.Create(crm);
  FPrintHandler := TCustomPrintHandler.Create(crm);
  FFindHandler := TCustomFindHandler.Create(crm);
  FJsdialogHandler := TCustomJsDialogHandler.Create(crm);
  FJsbindingHandler := TCustomJsBindingHandler.Create(crm);
{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  if CefInstances = 0 then
    CefTimer := SetTimer(0, 0, 10, nil);
  InterlockedIncrement(CefInstances);
{$ENDIF}
end;

destructor TCustomClientHandler.Destroy;
begin
{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}
  InterlockedDecrement(CefInstances);
  if CefInstances = 0 then
    KillTimer(0, CefTimer);
{$ENDIF}
  inherited;
end;

procedure TCustomClientHandler.Disconnect;
begin
  FLifeSpanHandler := nil;
  FLoadHandler := nil;
  FRequestHandler := nil;
  FDisplayHandler := nil;
  FFocusHandler := nil;
  FKeyboardHandler := nil;
  FMenuHandler := nil;
  FPrintHandler := nil;
  FFindHandler := nil;
  FJsdialogHandler := nil;
  FJsbindingHandler := nil;
  FRenderHandler := nil;
end;

function TCustomClientHandler.GetDisplayHandler: ICefBase;
begin
  Result := FDisplayHandler;
end;

function TCustomClientHandler.GetFindHandler: ICefBase;
begin
  Result := FFindHandler;
end;

function TCustomClientHandler.GetFocusHandler: ICefBase;
begin
  Result := FFocusHandler;
end;

function TCustomClientHandler.GetJsbindingHandler: ICefBase;
begin
  Result := FJsbindingHandler;
end;

function TCustomClientHandler.GetJsdialogHandler: ICefBase;
begin
  Result := FJsdialogHandler;
end;

function TCustomClientHandler.GetKeyboardHandler: ICefBase;
begin
  Result := FKeyboardHandler;
end;

function TCustomClientHandler.GetLifeSpanHandler: ICefBase;
begin
  Result := FLifeSpanHandler;
end;

function TCustomClientHandler.GetLoadHandler: ICefBase;
begin
  Result := FLoadHandler;
end;

function TCustomClientHandler.GetMenuHandler: ICefBase;
begin
  Result := FMenuHandler;
end;

function TCustomClientHandler.GetPrintHandler: ICefBase;
begin
  Result := FPrintHandler;
end;

function TCustomClientHandler.GetRenderHandler: ICefBase;
begin
  Result := FRenderHandler;
end;

function TCustomClientHandler.GetRequestHandler: ICefBase;
begin
  Result := FRequestHandler;
end;

{ TCustomLifeSpanHandler }

constructor TCustomLifeSpanHandler.Create(crm: TCustomChromium);
begin
  inherited Create;
  FCrm := crm;
end;

procedure TCustomLifeSpanHandler.OnAfterCreated(const browser: ICefBrowser);
begin
  FCrm.doOnAfterCreated(browser);
end;

procedure TCustomLifeSpanHandler.OnBeforeClose(const browser: ICefBrowser);
begin
  FCrm.doOnBeforeClose(browser);
end;

function TCustomLifeSpanHandler.OnBeforePopup(const parentBrowser: ICefBrowser;
  var popupFeatures: TCefPopupFeatures; var windowInfo: TCefWindowInfo;
  var url: ustring; var client: ICefBase;
  var settings: TCefBrowserSettings): Boolean;
begin
  FCrm.GetSettings(settings);
  Result := FCrm.doOnBeforePopup(parentBrowser, popupFeatures, windowInfo, url, client);
end;

procedure TCustomLifeSpanHandler.QuitModal(const browser: ICefBrowser);
begin
  FCrm.doOnQuitModal(browser);
end;

function TCustomLifeSpanHandler.RunModal(const browser: ICefBrowser): Boolean;
begin
  Result := FCrm.doOnRunModal(browser);
end;

{ TCustomLoadHandler }

constructor TCustomLoadHandler.Create(crm: TCustomChromium);
begin
  inherited Create;
  FCrm := crm;
end;

procedure TCustomLoadHandler.OnLoadEnd(const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: Integer);
begin
  FCrm.doOnLoadEnd(browser, frame, httpStatusCode);
end;

function TCustomLoadHandler.OnLoadError(const browser: ICefBrowser;
  const frame: ICefFrame; errorCode: TCefHandlerErrorcode; const failedUrl: ustring;
  var errorText: ustring): Boolean;
begin
  Result := FCrm.doOnLoadError(browser, frame, errorCode, failedUrl, errorText);
end;

procedure TCustomLoadHandler.OnLoadStart(const browser: ICefBrowser;
  const frame: ICefFrame);
begin
  FCrm.doOnLoadStart(browser, frame)
end;

{ TCustomRequestHandler }

constructor TCustomRequestHandler.Create(crm: TCustomChromium);
begin
  inherited Create;
  FCrm := crm;
end;

function TCustomRequestHandler.GetAuthCredentials(const browser: ICefBrowser;
  isProxy: Boolean; const host, realm, scheme: ustring; var username,
  password: ustring): Boolean;
begin
  Result := FCrm.doOnAuthCredentials(browser, isProxy, host, realm, scheme, username, password);
end;

function TCustomRequestHandler.GetDownloadHandler(const browser: ICefBrowser;
  const mimeType, fileName: ustring; contentLength: int64;
  var handler: ICefDownloadHandler): Boolean;
begin
  Result := FCrm.doOnGetDownloadHandler(browser, mimeType, fileName, contentLength, handler);
end;

function TCustomRequestHandler.OnBeforeBrowse(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest;
  navType: TCefHandlerNavtype; isRedirect: Boolean): Boolean;
begin
  Result := FCrm.doOnBeforeBrowse(browser, frame, request, navType, isRedirect);
end;

function TCustomRequestHandler.OnBeforeResourceLoad(const browser: ICefBrowser;
  const request: ICefRequest; var redirectUrl: ustring;
  var resourceStream: ICefStreamReader; const response: ICefResponse;
  loadFlags: Integer): Boolean;
begin
  Result := FCrm.doOnBeforeResourceLoad(browser, request, redirectUrl,
    resourceStream, response, loadFlags);
end;

function TCustomRequestHandler.OnProtocolExecution(const browser: ICefBrowser;
  const url: ustring; var allowOSExecution: Boolean): Boolean;
begin
  Result := FCrm.doOnProtocolExecution(browser, url, allowOSExecution);
end;

procedure TCustomRequestHandler.OnResourceResponse(const browser: ICefBrowser;
  const url: ustring; const response: ICefResponse; var filter: ICefBase);
begin
  FCrm.doOnResourceResponse(browser, url, response, filter);
end;

{ TCustomDisplayHandler }

constructor TCustomDisplayHandler.Create(crm: TCustomChromium);
begin
  inherited Create;
  FCrm := crm;
end;

procedure TCustomDisplayHandler.OnAddressChange(const browser: ICefBrowser;
  const frame: ICefFrame; const url: ustring);
begin
  FCrm.doOnAddressChange(browser, frame, url);
end;

function TCustomDisplayHandler.OnConsoleMessage(const browser: ICefBrowser;
  const message, source: ustring; line: Integer): Boolean;
begin
  Result := FCrm.doOnConsoleMessage(browser, message, source, line);
end;

procedure TCustomDisplayHandler.OnNavStateChange(const browser: ICefBrowser;
  canGoBack, canGoForward: Boolean);
begin
  FCrm.doOnNavStateChange(browser, canGoBack, canGoForward);
end;

procedure TCustomDisplayHandler.OnStatusMessage(const browser: ICefBrowser;
  const value: ustring; kind: TCefHandlerStatusType);
begin
  FCrm.doOnStatusMessage(browser, value, kind);
end;

procedure TCustomDisplayHandler.OnTitleChange(const browser: ICefBrowser;
  const title: ustring);
begin
  FCrm.doOnTitleChange(browser, title);
end;

function TCustomDisplayHandler.OnTooltip(const browser: ICefBrowser;
  var text: ustring): Boolean;
begin
  Result := FCrm.doOnTooltip(browser, text);
end;

{ TCustomFocusHandler }

constructor TCustomFocusHandler.Create(crm: TCustomChromium);
begin
  inherited Create;
  FCrm := crm;
end;

function TCustomFocusHandler.OnSetFocus(const browser: ICefBrowser;
  isWidget: Boolean): Boolean;
begin
  Result := FCrm.doOnSetFocus(browser, isWidget)
end;

procedure TCustomFocusHandler.OnTakeFocus(const browser: ICefBrowser;
  next: Boolean);
begin
  FCrm.doOnTakeFocus(browser, next)
end;

{ TCustomKeyboardHandler }

constructor TCustomKeyboardHandler.Create(crm: TCustomChromium);
begin
  inherited Create;
  FCrm := crm;
end;

function TCustomKeyboardHandler.OnKeyEvent(const browser: ICefBrowser;
  event: TCefHandlerKeyEventType; code, modifiers: Integer;
  isSystemKey: Boolean): Boolean;
begin
  Result := FCrm.doOnKeyEvent(browser, event, code, modifiers, isSystemKey);
end;

{ TCustomMenuHandler }

constructor TCustomMenuHandler.Create(crm: TCustomChromium);
begin
  inherited Create;
  FCrm := crm;
end;

procedure TCustomMenuHandler.GetMenuLabel(const browser: ICefBrowser;
  menuId: TCefHandlerMenuId; var caption: ustring);
begin
  FCrm.doOnGetMenuLabel(browser, menuId, caption);
end;

function TCustomMenuHandler.OnBeforeMenu(const browser: ICefBrowser;
  const menuInfo: PCefHandlerMenuInfo): Boolean;
begin
  Result := FCrm.doOnBeforeMenu(browser, menuInfo);
end;

function TCustomMenuHandler.OnMenuAction(const browser: ICefBrowser;
  menuId: TCefHandlerMenuId): Boolean;
begin
  Result := FCrm.doOnMenuAction(browser, menuId);
end;

{ TCustomPrintHandler }

constructor TCustomPrintHandler.Create(crm: TCustomChromium);
begin
  inherited Create;
  FCrm := crm;
end;

function TCustomPrintHandler.GetPrintHeaderFooter(const browser: ICefBrowser;
  const frame: ICefFrame; const printInfo: PCefPrintInfo; const url,
  title: ustring; currentPage, maxPages: Integer; var topLeft, topCenter,
  topRight, bottomLeft, bottomCenter, bottomRight: ustring): Boolean;
begin
  Result := FCrm.doOnPrintHeaderFooter(browser, frame, printInfo, url, title, currentPage,
    maxPages, topLeft, topCenter, topRight, bottomLeft, bottomCenter, bottomRight);
end;

function TCustomPrintHandler.GetPrintOptions(const browser: ICefBrowser;
  printOptions: PCefPrintOptions): Boolean;
begin
  Result := FCrm.doOnPrintOptions(browser, printOptions);
end;

{ TCustomFindHandler }

constructor TCustomFindHandler.Create(crm: TCustomChromium);
begin
  inherited Create;
  FCrm := crm;
end;

procedure TCustomFindHandler.OnFindResult(const browser: ICefBrowser;
  count: Integer; const selectionRect: PCefRect; identifier, activeMatchOrdinal,
  finalUpdate: Boolean);
begin
  FCrm.doOnFindResult(browser, count, selectionRect, identifier, activeMatchOrdinal, finalUpdate);
end;

{ TCustomJsDialogHandler }

constructor TCustomJsDialogHandler.Create(crm: TCustomChromium);
begin
  inherited Create;
  FCrm := crm;
end;

function TCustomJsDialogHandler.OnJsAlert(const browser: ICefBrowser;
  const frame: ICefFrame; const message: ustring): Boolean;
begin
  Result := FCrm.doOnJsAlert(browser, frame, message);
end;

function TCustomJsDialogHandler.OnJsConfirm(const browser: ICefBrowser;
  const frame: ICefFrame; const message: ustring; var retval: Boolean): Boolean;
begin
  Result := FCrm.doOnJsConfirm(browser, frame, message, retval);
end;

function TCustomJsDialogHandler.OnJsPrompt(const browser: ICefBrowser;
  const frame: ICefFrame; const message, defaultValue: ustring;
  var retval: Boolean; var return: ustring): Boolean;
begin
  Result := FCrm.doOnJsPrompt(browser, frame, message, defaultValue, retval, return);
end;

{ TCustomJsBindingHandler }

constructor TCustomJsBindingHandler.Create(crm: TCustomChromium);
begin
  inherited Create;
  FCrm := crm;
end;

procedure TCustomJsBindingHandler.OnJsBinding(const browser: ICefBrowser;
  const frame: ICefFrame; const obj: ICefv8Value);
begin
  FCrm.doOnJsBinding(browser, frame, obj)
end;

{$IFNDEF CEF_MULTI_THREADED_MESSAGE_LOOP}

type
  TCefApplicationEvents = class(TApplicationEvents)
  public
    procedure doIdle(Sender: TObject; var Done: Boolean);
    procedure doMessage(var Msg: TMsg; var Handled: Boolean);
    constructor Create(AOwner: TComponent); override;
  end;

constructor TCefApplicationEvents.Create(AOwner: TComponent);
begin
  inherited;
  OnIdle := doIdle;
  OnMessage := doMessage;
end;

procedure TCefApplicationEvents.doIdle(Sender: TObject; var Done: Boolean);
begin
  if CefInstances > 0 then
    CefDoMessageLoopWork;
end;

procedure TCefApplicationEvents.doMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if CefInstances > 0 then
    CefDoMessageLoopWork;
end;

var
  AppEvent: TCefApplicationEvents;

initialization
  AppEvent := TCefApplicationEvents.Create(nil);

finalization
  AppEvent.Free;
{$ENDIF}

end.

