unit cef;

interface
uses Classes, Controls, Messages, Windows, ceflib;

type
  TCustomChromium = class;

  TOnBeforeCreated = procedure(Sender: TCustomChromium; const parentBrowser: ICefBrowser;
    var windowInfo: TCefWindowInfo; popup: Boolean;
    var handler: ICefBase; var url: ustring; out Result: TCefRetval) of object;
  TOnAfterCreated = procedure(Sender: TCustomChromium; const browser: ICefBrowser; out Result: TCefRetval) of object;
  TOnAddressChange = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    const frame: ICefFrame; const url: ustring; out Result: TCefRetval) of object;
  TOnTitleChange = procedure(Sender: TCustomChromium; const browser: ICefBrowser;
    const title: ustring; out Result: TCefRetval) of object;
  TOnBeforeBrowse = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame;
    const request: ICefRequest; navType: TCefHandlerNavtype;
    isRedirect: boolean; out Result: TCefRetval) of object;
  TOnLoadStart = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame; out Result: TCefRetval) of object;
  TOnLoadEnd = procedure(Sender: TCustomChromium; const browser: ICefBrowser; const frame: ICefFrame; out Result: TCefRetval) of object;
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
    FOnSetFocus: TOnSetFocus;
    FOnKeyEvent: TOnKeyEvent;
    FOnConsoleMessage: TOnConsoleMessage;
    FOnPrintOptions: TOnPrintOptions;
    FOnJsBinding: TOnJsBinding;
    FOnTooltip: TOnTooltip;
    FOnFindResult: TOnFindResult;
  protected
    procedure WndProc(var Message: TMessage); override;
    function doOnBeforeCreated(const parentBrowser: ICefBrowser;
      var windowInfo: TCefWindowInfo; popup: Boolean;
      var handler: ICefBase; var url: ustring): TCefRetval; virtual;
    function doOnAfterCreated(const browser: ICefBrowser): TCefRetval; virtual;
    function doOnAddressChange(const browser: ICefBrowser;
      const frame: ICefFrame; const url: ustring): TCefRetval; virtual;
    function doOnTitleChange(const browser: ICefBrowser;
      const title: ustring): TCefRetval; virtual;
    function doOnBeforeBrowse(const browser: ICefBrowser; const frame: ICefFrame;
      const request: ICefRequest; navType: TCefHandlerNavtype;
      isRedirect: boolean): TCefRetval; virtual;
    function doOnLoadStart(const browser: ICefBrowser; const frame: ICefFrame): TCefRetval; virtual;
    function doOnLoadEnd(const browser: ICefBrowser; const frame: ICefFrame): TCefRetval; virtual;
    function doOnLoadError(const browser: ICefBrowser;
      const frame: ICefFrame; errorCode: TCefHandlerErrorcode;
      const failedUrl: ustring; var errorText: ustring): TCefRetval; virtual;
    function doOnBeforeResourceLoad(const browser: ICefBrowser;
      const request: ICefRequest; var redirectUrl: ustring;
      var resourceStream: ICefStreamReader; var mimeType: ustring;
      loadFlags: Integer): TCefRetval; virtual;
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

    property BrowserHandle: HWND read FBrowserHandle;
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
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Lock;
    procedure UnLock;
  end;

  TChromium = class(TCustomChromium)
  public
    property BrowserHandle;
  published
    property Align;
    property Anchors;
    property Constraints;
    property DefaultUrl;
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
    var handler: PCefHandler; var uri: TCefString): TCefRetval; stdcall;
var
  _handler: ICefBase;
  _url: ustring;
begin
  with TCustomChromium(CefGetObject(self)) do
  begin
    if handler <> nil then
      _handler := TCefBaseRef.UnWrap(handler) else
      _handler := nil;
    _url := uri;

    Result := doOnBeforeCreated(
      TCefBrowserRef.UnWrap(parentBrowser),
      windowInfo,
      popup <> 0,
      _handler,
      _url);

    if Result = RV_HANDLED then
    begin
      if _handler <> nil then
        handler := _handler.Wrap;
      if uri <> nil then
        CefStringFree(uri);
      uri := CefStringAlloc(_url);
    end;
  end;

end;

function cef_handler_handle_after_created(self: PCefHandler;
  browser: PCefBrowser): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnAfterCreated(TCefBrowserRef.UnWrap(browser));
end;

function cef_handler_handle_address_change(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame; const uri: PWideChar): TCefRetval; stdcall;
begin
   with TCustomChromium(CefGetObject(self)) do
    Result := doOnAddressChange(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      uri)
end;

function cef_handler_handle_title_change(
    self: PCefHandler; browser: PCefBrowser;
    const title: PWideChar): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnTitleChange(TCefBrowserRef.UnWrap(browser), title);
end;

function cef_handler_handle_before_browse(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame; request: PCefRequest;
    navType: TCefHandlerNavtype; isRedirect: Integer): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnBeforeBrowse(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      TCefRequestRef.UnWrap(request),
      navType,
      isRedirect <> 0)
end;

function cef_handler_handle_load_start(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnLoadStart(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame));
end;

function cef_handler_handle_load_end(self: PCefHandler;
    browser: PCefBrowser; frame: PCefFrame): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnLoadEnd(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame));
end;

function cef_handler_handle_load_error(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame; errorCode: TCefHandlerErrorcode;
    const failedUrl: PWideChar; var errorText: TCefString): TCefRetval; stdcall;
var
  err: ustring;
begin
  err := errorText;
  with TCustomChromium(CefGetObject(self)) do
  begin
    Result := doOnLoadError(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      errorCode,
      failedUrl,
      err);
    if Result = RV_HANDLED then
    begin
      if errorText <> nil then
        CefStringFree(errorText);
      errorText := CefStringAlloc(err);
    end;
  end;
end;

function cef_handler_handle_before_resource_load(
    self: PCefHandler; browser: PCefBrowser;
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
    _redirectUrl := redirectUrl;
    _resourceStream := TCefStreamReaderRef.UnWrap(resourceStream);
    _mimeType := mimeType;

    Result := doOnBeforeResourceLoad(
      TCefBrowserRef.UnWrap(browser),
      TCefRequestRef.UnWrap(request),
      _redirectUrl,
      _resourceStream,
      _mimeType,
      loadFlags
      );

    if Result = RV_HANDLED then
    begin
      if _redirectUrl <> '' then
        redirectUrl := CefStringAlloc(_redirectUrl);

      if _resourceStream <> nil then
        resourceStream := _resourceStream.Wrap;

      if _mimeType <> '' then
        mimeType := CefStringAlloc(_mimeType);
    end;
  end;
end;

function cef_handler_handle_before_menu(
    self: PCefHandler; browser: PCefBrowser;
    const menuInfo: PCefHandlerMenuInfo): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnBeforeMenu(
      TCefBrowserRef.UnWrap(browser),
      menuInfo);
end;

function cef_handler_handle_get_menu_label(
    self: PCefHandler; browser: PCefBrowser;
    menuId: TCefHandlerMenuId; var label_: TCefString): TCefRetval; stdcall;
var
  str: ustring;
begin
  str := label_;
  with TCustomChromium(CefGetObject(self)) do
  begin
    Result := doOnGetMenuLabel(
      TCefBrowserRef.UnWrap(browser),
      menuId,
      str);
    if Result = RV_HANDLED then
    begin
      if label_ <> nil then CefStringFree(label_);
      label_ := CefStringAlloc(str);
    end;
  end;
end;

function cef_handler_handle_menu_action(
    self: PCefHandler; browser: PCefBrowser;
    menuId: TCefHandlerMenuId): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnMenuAction(
      TCefBrowserRef.UnWrap(browser),
      menuId);
end;

function cef_handler_handle_print_header_footer(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame; printInfo: PCefPrintInfo;
    url, title: PWideChar; currentPage, maxPages: Integer;
    var topLeft, topCenter, topRight, bottomLeft, bottomCenter,
    bottomRight: TCefString): TCefRetval; stdcall;
var
  _topLeft, _topCenter, _topRight, _bottomLeft, _bottomCenter, _bottomRight: ustring;
begin
  with TCustomChromium(CefGetObject(self)) do
  begin
    Result := doOnPrintHeaderFooter(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      printInfo, url, title, currentPage, maxPages,
      _topLeft, _topCenter, _topRight, _bottomLeft, _bottomCenter, _bottomRight
    );
    if Result = RV_HANDLED then
    begin
      topLeft := CefStringAlloc(_topLeft);
      topCenter := CefStringAlloc(_topCenter);
      topRight := CefStringAlloc(_topRight);
      bottomLeft := CefStringAlloc(_bottomLeft);
      bottomCenter := CefStringAlloc(_bottomCenter);
      bottomRight := CefStringAlloc(_bottomRight);
    end;
  end;
end;

function cef_handler_handle_jsalert(self: PCefHandler;
    browser: PCefBrowser; frame: PCefFrame;
    const message: PWideChar): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnJsAlert(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      message);
end;

function cef_handler_handle_jsconfirm(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame; const message: PWideChar;
    var retval: Integer): TCefRetval; stdcall;
var
  ret: Boolean;
begin
  ret := retval <> 0;
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnJsConfirm(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      message, ret);
  if Result = RV_HANDLED then
    retval := Ord(ret);

end;

function cef_handler_handle_jsprompt(self: PCefHandler;
    browser: PCefBrowser; frame: PCefFrame;
    const message, defaultValue: PWideChar; var retval: Integer;
    var return: TCefString): TCefRetval; stdcall;
var
  ret: Boolean;
  str: ustring;
begin
  ret := retval <> 0;
  with TCustomChromium(CefGetObject(self)) do
  begin
    Result := doOnJsPrompt(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      message, defaultValue, ret, str);
    if Result = RV_HANDLED then
    begin
      retval := Ord(ret);
      return := CefStringAlloc(str)
    end;
  end;
end;

function cef_handler_handle_before_window_close(
    self: PCefHandler; browser: PCefBrowser): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnBeforeWindowClose(
      TCefBrowserRef.UnWrap(browser))
end;

function cef_handler_handle_take_focus(
    self: PCefHandler; browser: PCefBrowser;
    reverse: Integer): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnTakeFocus(
      TCefBrowserRef.UnWrap(browser), reverse);
end;

function cef_handler_handle_set_focus(
    self: PCefHandler; browser: PCefBrowser;
    isWidget: Integer): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnSetFocus(
      TCefBrowserRef.UnWrap(browser), isWidget <> 0);
end;

function cef_handler_handle_key_event(
    self: PCefHandler; browser: PCefBrowser;
    event: TCefHandlerKeyEventType; code, modifiers,
    isSystemKey: Integer): TCefRetval; stdcall;
begin
  with TCustomChromium(CefGetObject(self)) do
    Result := doOnKeyEvent(
      TCefBrowserRef.UnWrap(browser),
      event, code, modifiers, isSystemKey <> 0);
end;

function cef_handler_console_message(self: PCefHandler; browser: PCefBrowser;
  const message, source: PWideChar; line: Integer): TCefRetval; stdcall;
begin
 with TCustomChromium(CefGetObject(self)) do
    Result := doOnConsoleMessage(TCefBrowserRef.UnWrap(browser), message, source, line);
end;

{ TCustomChromium }

constructor TCustomChromium.Create(AOwner: TComponent);
begin
  inherited;
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
  FHandler.handle_find_result := nil; // todo

  FBrowserHandle := INVALID_HANDLE_VALUE;
  FBrowser := nil;
end;

destructor TCustomChromium.Destroy;
begin
  FBrowser := nil;
  DeleteCriticalSection(FCriticalSection);
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
  if not browser.IsPopup then
  begin
    FBrowser := browser;
    FBrowserHandle := browser.GetWindowHandle;
  end;
  Result := RV_CONTINUE;
  if Assigned(FOnAfterCreated) then
    FOnAfterCreated(Self, browser, Result);
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
  var url: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnBeforeCreated) then
    FOnBeforeCreated(Self, parentBrowser, windowInfo, popup, handler, url, Result);
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
  const frame: ICefFrame): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnLoadEnd) then
    FOnLoadEnd(Self, browser, frame, Result);
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

function TCustomChromium.doOnSetFocus(const browser: ICefBrowser;
  isWidget: Boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
  if Assigned(FOnSetFocus) then
    FOnSetFocus(Self, browser, isWidget, Result);
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
        Assert(CefBrowserCreate(@info, False, @FHandler, FDefaultUrl));
      end;
      inherited WndProc(Message);
    end;
    WM_SIZE:
      begin
        if not (csDesigning in ComponentState) then
        begin
          if (FBrowser <> nil) and (FBrowser.GetWindowHandle <> INVALID_HANDLE_VALUE) then
          begin
            rect := GetClientRect;
            hdwp := BeginDeferWindowPos(1);
            hdwp := DeferWindowPos(hdwp, FBrowser.GetWindowHandle, 0,
              rect.left, rect.top, rect.right - rect.left, rect.bottom - rect.top,
              SWP_NOZORDER);
            EndDeferWindowPos(hdwp);
          end else
            inherited WndProc(Message);
        end else
          inherited WndProc(Message);
      end;
    WM_ERASEBKGND:
      if (csDesigning in ComponentState) then
        inherited WndProc(Message);
  else
    inherited WndProc(Message);
  end;
end;

end.
