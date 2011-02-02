{$IFDEF FPC}
   {$MODE DELPHI}{$H+}
{$ENDIF}
unit ceflib;
{$ALIGN ON}
{$MINENUMSIZE 4}
{$I cef.inc}

interface
uses
  Classes, Windows;

type
{$IFDEF UNICODE}
  ustring = type string;
  rbstring = type RawByteString;
{$ELSE}
  {$IFDEF FPC}
    {$if defined(unicodestring)}
      ustring = type unicodestring;
    {$else}
      ustring = type WideString;
    {$ifend}
  {$ELSE}
    ustring = type WideString;
  {$ENDIF}
  rbstring = type AnsiString;
{$ENDIF}

  // CEF provides functions for converting between UTF-8, -16 and -32 strings.
  // CEF string types are safe for reading from multiple threads but not for
  // modification. It is the user's responsibility to provide synchronization if
  // modifying CEF strings from multiple threads.

  // CEF character type definitions. wchat_t is 2 bytes on Windows and 4 bytes on
  // most other platforms.

  Char16 = WideChar;
  PChar16 = PWideChar;

  // CEF string type definitions. Whomever allocates |str| is responsible for
  // providing an appropriate |dtor| implementation that will free the string in
  // the same memory space. When reusing an existing string structure make sure
  // to call |dtor| for the old value before assigning new |str| and |dtor|
  // values. Static strings will have a NULL |dtor| value. Using the below
  // functions if you want this managed for you.

  PCefStringWide = ^TCefStringWide;
  TCefStringWide = record
    str: PWideChar;
    length: Cardinal;
    dtor: procedure(str: PWideChar); stdcall;
  end;

  PCefStringUtf8 = ^TCefStringUtf8;
  TCefStringUtf8 = record
    str: PAnsiChar;
    length: Cardinal;
    dtor: procedure(str: PAnsiChar); stdcall;
  end;

  PCefStringUtf16 = ^TCefStringUtf16;
  TCefStringUtf16 = record
    str: PChar16;
    length: Cardinal;
    dtor: procedure(str: PChar16); stdcall;
  end;


  // It is sometimes necessary for the system to allocate string structures with
  // the expectation that the user will free them. The userfree types act as a
  // hint that the user is responsible for freeing the structure.

  PCefStringUserFreeWide = ^TCefStringUserFreeWide;
  TCefStringUserFreeWide = type TCefStringWide;

  PCefStringUserFreeUtf8 = ^TCefStringUserFreeUtf8;
  TCefStringUserFreeUtf8 = type TCefStringUtf8;

  PCefStringUserFreeUtf16 = ^TCefStringUserFreeUtf16;
  TCefStringUserFreeUtf16 = type TCefStringUtf16;

{$IFDEF CEF_STRING_TYPE_UTF8}
  TCefChar = AnsiChar;
  PCefChar = PAnsiChar;
  TCefStringUserFree = TCefStringUserFreeUtf8;
  PCefStringUserFree = PCefStringUserFreeUtf8;
  TCefString = TCefStringUtf8;
  PCefString = PCefStringUtf8;
{$ENDIF}

{$IFDEF CEF_STRING_TYPE_UTF16}
  TCefChar = Char16;
  PCefChar = PChar16;
  TCefStringUserFree = TCefStringUserFreeUtf16;
  PCefStringUserFree = PCefStringUserFreeUtf16;
  TCefString = TCefStringUtf16;
  PCefString = PCefStringUtf16;
{$ENDIF}

{$IFDEF CEF_STRING_TYPE_WIDE}
  TCefChar = WideChar;
  PCefChar = PWideChar;
  TCefStringUserFree = TCefStringUserFreeWide;
  PCefStringUserFree = PCefStringUserFreeWide;
  TCefString = TCefStringWide;
  PCefString = PCefStringWide;
{$ENDIF}

  //PCefStringUserFree = ^TCefStringUserFree;

  // CEF strings are NUL-terminated wide character strings prefixed with a size
  // value, similar to the Microsoft BSTR type.  Use the below API functions for
  // allocating, managing and freeing CEF strings.


  // CEF string maps are a set of key/value string pairs.
  TCefStringMap = Pointer;

  // CEF string maps are a set of key/value string pairs.
  TCefStringList = Pointer;

  // Class representing window information.
  PCefWindowInfo = ^TCefWindowInfo;
  TCefWindowInfo = record
    // Standard parameters required by CreateWindowEx()
    ExStyle: DWORD;
    windowName: TCefString;
    Style: DWORD;
    x: Integer;
    y: Integer;
    Width: Integer;
    Height: Integer;
    WndParent: HWND;
    Menu: HMENU;
    // Handle for the new browser window.
    Wnd: HWND ;
  end;

  // Class representing print context information.
  TCefPrintInfo = record
    DC: HDC;
    Rect: TRect;
    Scale: double;
  end;

  // Window handle.
  CefWindowHandle = HWND;


  // Log severity levels.
  TCefLogSeverity = (
    LOGSEVERITY_VERBOSE = -1,
    LOGSEVERITY_INFO,
    LOGSEVERITY_WARNING,
    LOGSEVERITY_ERROR,
    LOGSEVERITY_ERROR_REPORT,
    // Disables logging completely.
    LOGSEVERITY_DISABLE = 99
  );

  // Initialization settings. Specify NULL or 0 to get the recommended default
  // values.
  PCefSettings = ^TCefSettings;
  TCefSettings = record
    // Size of this structure.
    size: Cardinal;

    // Set to true (1) to have the message loop run in a separate thread. If
    // false (0) than the CefDoMessageLoopWork() function must be called from
    // your application message loop.
    multi_threaded_message_loop: Boolean;

    // The location where cache data will be stored on disk. If empty an
    // in-memory cache will be used. HTML5 databases such as localStorage will
    // only persist across sessions if a cache path is specified.
    cache_path: TCefString;

    // Value that will be returned as the User-Agent HTTP header. If empty the
    // default User-Agent string will be used.
    user_agent: TCefString;

    // Value that will be inserted as the product portion of the default
    // User-Agent string. If empty the Chromium product version will be used. If
    // |userAgent| is specified this value will be ignored.
    product_version: TCefString;

    // The locale string that will be passed to WebKit. If empty the default
    // locale of "en-US" will be used.
    locale: TCefString;

    // List of file system paths that will be searched by the browser to locate
    // plugins. This is in addition to the default search paths.
    extra_plugin_paths: TCefStringList;

    // The directory and file name to use for the debug log. If empty, the
    // default name of "debug.log" will be used and the file will be written
    // to the application directory.
    log_file: TCefString;

    // The log severity. Only messages of this severity level or higher will be
    // logged.
    log_severity: TCefLogSeverity;
  end;

  // Browser initialization settings. Specify NULL or 0 to get the recommended
  // default values. The consequences of using custom values may not be well
  // tested.
  PCefBrowserSettings = ^TCefBrowserSettings;
  TCefBrowserSettings = record
    // Size of this structure.
    size: Cardinal;

    // Disable drag & drop of URLs from other windows.
    drag_drop_disabled: Boolean;

    // The below values map to WebPreferences settings.

    // Font settings.
    standard_font_family: TCefString;
    fixed_font_family: TCefString;
    serif_font_family: TCefString;
    sans_serif_font_family: TCefString;
    cursive_font_family: TCefString;
    fantasy_font_family: TCefString;
    default_font_size: Integer;
    default_fixed_font_size: Integer;
    minimum_font_size: Integer;
    minimum_logical_font_size: Integer;

    // Set to true (1) to disable loading of fonts from remote sources.
    remote_fonts_disabled: Boolean;

    // Default encoding for Web content. If empty "ISO-8859-1" will be used.
    default_encoding: TCefString;

    // Set to true (1) to attempt automatic detection of content encoding.
    encoding_detector_enabled: Boolean;

    // Set to true (1) to disable JavaScript.
    javascript_disabled: Boolean;

    // Set to true (1) to disallow JavaScript from opening windows.
    javascript_open_windows_disallowed: Boolean;

    // Set to true (1) to disallow JavaScript from closing windows.
    javascript_close_windows_disallowed: Boolean;

    // Set to true (1) to disallow JavaScript from accessing the clipboard.
    javascript_access_clipboard_disallowed: Boolean;

    // Set to true (1) to disable DOM pasting in the editor. DOM pasting also
    // depends on |javascript_cannot_access_clipboard| being false (0).
    dom_paste_disabled: Boolean;

    // Set to true (1) to enable drawing of the caret position.
    caret_browsing_enabled: Boolean;

    // Set to true (1) to disable Java.
    java_disabled: Boolean;

    // Set to true (1) to disable plugins.
    plugins_disabled: Boolean;

    // Set to true (1) to allow access to all URLs from file URLs.
    universal_access_from_file_urls_allowed: Boolean;

    // Set to true (1) to allow access to file URLs from other file URLs.
    file_access_from_file_urls_allowed: Boolean;

    // Set to true (1) to allow risky security behavior such as cross-site
    // scripting (XSS). Use with extreme care.
    web_security_disabled: Boolean;

    // Set to true (1) to enable console warnings about XSS attempts.
    xss_auditor_enabled: Boolean;

    // Set to true (1) to suppress the network load of image URLs.  A cached
    // image will still be rendered if requested.
    image_load_disabled: Boolean;

    // Set to true (1) to shrink standalone images to fit the page.
    shrink_standalone_images_to_fit: Boolean;

    // Set to true (1) to disable browser backwards compatibility features.
    site_specific_quirks_disabled: Boolean;

    // Set to true (1) to disable resize of text areas.
    text_area_resize_disabled: Boolean;

    // Set to true (1) to disable use of the page cache.
    page_cache_disabled: Boolean;

    // Set to true (1) to not have the tab key advance focus to links.
    tab_to_links_disabled: Boolean;

    // Set to true (1) to disable hyperlink pings (<a ping> and window.sendPing).
    hyperlink_auditing_disabled: Boolean;

    // Set to true (1) to enable the user style sheet for all pages.
    // |user_style_sheet_location| must be set to the style sheet URL.
    user_style_sheet_enabled: Boolean;
    user_style_sheet_location: TCefString;

    // Set to true (1) to disable style sheets.
    author_and_user_styles_disabled: Boolean;

    // Set to true (1) to disable local storage.
    local_storage_disabled: Boolean;

    // Set to true (1) to disable databases.
    databases_disabled: Boolean;

    // Set to true (1) to disable application cache.
    application_cache_disabled: Boolean;

    // Set to true (1) to disable WebGL.
    webgl_disabled: Boolean;

    // Set to true (1) to disable accelerated compositing.
    accelerated_compositing_disabled: Boolean;

    // Set to true (1) to disable accelerated layers. This affects features like
    // 3D CSS transforms.
    accelerated_layers_disabled: Boolean;

    // Set to true (1) to disable accelerated 2d canvas.
    accelerated_2d_canvas_disabled: Boolean;

    // Set to true (1) to disable developer tools (WebKit inspector).
    developer_tools_disabled: Boolean;
  end;

  // URL component parts.
  PCefUrlParts = ^TCefUrlParts;
  TCefUrlParts = record
    // The complete URL specification.
    spec: TCefString;

    // Scheme component not including the colon (e.g., "http").
    scheme: TCefString;

    // User name component.
    username: TCefString;

    // Password component.
    password: TCefString;

    // Host component. This may be a hostname, an IPv4 address or an IPv6 literal
    // surrounded by square brackets (e.g., "[2001:db8::1]").
    host: TCefString;

    // Port number component.
    port: TCefString;

    // Path component including the first slash following the host.
    path: TCefString;

    // Query string component (i.e., everything following the '?').
    query: TCefString;
  end;


  // Define handler return value types. Returning RV_HANDLED indicates
  // that the implementation completely handled the method and that no further
  // processing is required.  Returning RV_CONTINUE indicates that the
  // implementation did not handle the method and that the default handler
  // should be called.
  PCefRetval = ^TCefRetval;
  TCefRetval = (
    RV_HANDLED   = 0,
    RV_CONTINUE  = 1
  );

  // Various browser navigation types supported by chrome.
  TCefHandlerNavtype = (
    NAVTYPE_LINKCLICKED = 0,
    NAVTYPE_FORMSUBMITTED,
    NAVTYPE_BACKFORWARD,
    NAVTYPE_RELOAD,
    NAVTYPE_FORMRESUBMITTED,
    NAVTYPE_OTHER
  );

  // Supported error code values. See net\base\net_error_list.h for complete
  // descriptions of the error codes.
  TCefHandlerErrorcode = Integer;

const
  ERR_FAILED = -2;
  ERR_ABORTED = -3;
  ERR_INVALID_ARGUMENT = -4;
  ERR_INVALID_HANDLE = -5;
  ERR_FILE_NOT_FOUND = -6;
  ERR_TIMED_OUT = -7;
  ERR_FILE_TOO_BIG = -8;
  ERR_UNEXPECTED = -9;
  ERR_ACCESS_DENIED = -10;
  ERR_NOT_IMPLEMENTED = -11;
  ERR_CONNECTION_CLOSED = -100;
  ERR_CONNECTION_RESET = -101;
  ERR_CONNECTION_REFUSED = -102;
  ERR_CONNECTION_ABORTED = -103;
  ERR_CONNECTION_FAILED = -104;
  ERR_NAME_NOT_RESOLVED = -105;
  ERR_INTERNET_DISCONNECTED = -106;
  ERR_SSL_PROTOCOL_ERROR = -107;
  ERR_ADDRESS_INVALID = -108;
  ERR_ADDRESS_UNREACHABLE = -109;
  ERR_SSL_CLIENT_AUTH_CERT_NEEDED = -110;
  ERR_TUNNEL_CONNECTION_FAILED = -111;
  ERR_NO_SSL_VERSIONS_ENABLED = -112;
  ERR_SSL_VERSION_OR_CIPHER_MISMATCH = -113;
  ERR_SSL_RENEGOTIATION_REQUESTED = -114;
  ERR_CERT_COMMON_NAME_INVALID = -200;
  ERR_CERT_DATE_INVALID = -201;
  ERR_CERT_AUTHORITY_INVALID = -202;
  ERR_CERT_CONTAINS_ERRORS = -203;
  ERR_CERT_NO_REVOCATION_MECHANISM = -204;
  ERR_CERT_UNABLE_TO_CHECK_REVOCATION = -205;
  ERR_CERT_REVOKED = -206;
  ERR_CERT_INVALID = -207;
  ERR_CERT_END = -208;
  ERR_INVALID_URL = -300;
  ERR_DISALLOWED_URL_SCHEME = -301;
  ERR_UNKNOWN_URL_SCHEME = -302;
  ERR_TOO_MANY_REDIRECTS = -310;
  ERR_UNSAFE_REDIRECT = -311;
  ERR_UNSAFE_PORT = -312;
  ERR_INVALID_RESPONSE = -320;
  ERR_INVALID_CHUNKED_ENCODING = -321;
  ERR_METHOD_NOT_SUPPORTED = -322;
  ERR_UNEXPECTED_PROXY_AUTH = -323;
  ERR_EMPTY_RESPONSE = -324;
  ERR_RESPONSE_HEADERS_TOO_BIG = -325;
  ERR_CACHE_MISS = -400;
  ERR_INSECURE_RESPONSE = -501;

type
  // Structure representing menu information.
  TCefHandlerMenuInfo = record
    typeFlags: Integer;
    x: Integer;
    y: Integer;
    linkUrl: TCefString;
    imageUrl: TCefString;
    pageUrl: TCefString;
    frameUrl: TCefString;
    selectionText: TCefString;
    misspelledWord: TCefString;
    editFlags: Integer;
    securityInfo: TCefString;
  end;

  // The TCefHandlerMenuInfo typeFlags value will be a combination of the
  // following values.
  TCefHandlerMenuTypeBits = (
    // No node is selected
    MENUTYPE_NONE = $0,
    // The top page is selected
    MENUTYPE_PAGE = $1,
    // A subframe page is selected
    MENUTYPE_FRAME = $2,
    // A link is selected
    MENUTYPE_LINK = $4,
    // An image is selected
    MENUTYPE_IMAGE = $8,
    // There is a textual or mixed selection that is selected
    MENUTYPE_SELECTION = $10,
    // An editable element is selected
    MENUTYPE_EDITABLE = $20,
    // A misspelled word is selected
    MENUTYPE_MISSPELLED_WORD = $40,
    // A video node is selected
    MENUTYPE_VIDEO = $80,
    // A video node is selected
    MENUTYPE_AUDIO = $100
  );

  // The TCefHandlerMenuInfo editFlags value will be a combination of the
  // following values.
  TCefHandlerMenuCapabilityBits = (
    // Values from WebContextMenuData::EditFlags in WebContextMenuData.h
    MENU_CAN_DO_NONE = $0,
    MENU_CAN_UNDO = $1,
    MENU_CAN_REDO = $2,
    MENU_CAN_CUT = $4,
    MENU_CAN_COPY = $8,
    MENU_CAN_PASTE = $10,
    MENU_CAN_DELETE = $20,
    MENU_CAN_SELECT_ALL = $40,
    MENU_CAN_TRANSLATE = $80,
    // Values unique to CEF
    MENU_CAN_GO_FORWARD = $10000000,
    MENU_CAN_GO_BACK = $20000000
  );

  // Supported menu ID values.
  TCefHandlerMenuId = (
    MENU_ID_NAV_BACK = 10,
    MENU_ID_NAV_FORWARD = 11,
    MENU_ID_NAV_RELOAD = 12,
    MENU_ID_NAV_RELOAD_NOCACHE = 13,
    MENU_ID_NAV_STOP = 14,
    MENU_ID_UNDO = 20,
    MENU_ID_REDO = 21,
    MENU_ID_CUT = 22,
    MENU_ID_COPY = 23,
    MENU_ID_PASTE = 24,
    MENU_ID_DELETE = 25,
    MENU_ID_SELECTALL = 26,
    MENU_ID_PRINT = 30,
    MENU_ID_VIEWSOURCE = 31
  );

  // Post data elements may represent either bytes or files.
  TCefPostDataElementType = (
    PDE_TYPE_EMPTY  = 0,
    PDE_TYPE_BYTES,
    PDE_TYPE_FILE
  );

  // Key event types.
  TCefHandlerKeyEventType = (
    KEYEVENT_RAWKEYDOWN = 0,
    KEYEVENT_KEYDOWN,
    KEYEVENT_KEYUP,
    KEYEVENT_CHAR
  );

  // Key event modifiers.
  TCefHandlerKeyEventModifiers = (
    KEY_SHIFT = 1 shl 0,
    KEY_CTRL  = 1 shl 1,
    KEY_ALT   = 1 shl 2,
    KEY_META  = 1 shl 3
  );

  // Structure representing a rectangle.

  PCefRect = ^TCefRect;
  TCefRect = record
    x: Integer;
    y: Integer;
    width: Integer;
    height: Integer;
  end;

  // Existing thread IDs.
  TCefThreadId = (
    TID_UI      = 0,
    TID_IO      = 1,
    TID_FILE    = 2
  );

  // Paper type for printing.
  TCefPaperType = (
    PT_LETTER = 0,
    PT_LEGAL,
    PT_EXECUTIVE,
    PT_A3,
    PT_A4,
    PT_CUSTOM
  );

  // Paper metric information for printing.
  TCefPaperMetrics = record
    paper_type: TCefPaperType;
    //Length and width needed if paper_type is custom_size
    //Units are in inches.
    length: Double;
    width: Double;
  end;

  // Paper print margins.
  TCefPrintMargins = record
    //Margin size in inches for left/right/top/bottom (this is content margins).
    left: Double;
    right: Double;
    top: Double;
    bottom: Double;
    //Margin size (top/bottom) in inches for header/footer.
    header: Double;
    footer: Double;
  end;

  // Page orientation for printing
  TCefPageOrientation = (
    PORTRAIT = 0,
    LANDSCAPE
  );

  // Printing options.
  PCefPrintOptions = ^TCefPrintOptions;
  TCefPrintOptions = record
    page_orientation: TCefPageOrientation;
    paper_metrics: TCefPaperMetrics;
    paper_margins: TCefPrintMargins;
  end;

  // Supported XML encoding types. The parser supports ASCII, ISO-8859-1, and
  // UTF16 (LE and BE) by default. All other types must be translated to UTF8
  // before being passed to the parser. If a BOM is detected and the correct
  // decoder is available then that decoder will be used automatically.
  TCefXmlEncodingType = (
    XML_ENCODING_NONE = 0,
    XML_ENCODING_UTF8,
    XML_ENCODING_UTF16LE,
    XML_ENCODING_UTF16BE,
    XML_ENCODING_ASCII
  );

  // XML node types.
  TCefXmlNodeType = (
    XML_NODE_UNSUPPORTED = 0,
    XML_NODE_PROCESSING_INSTRUCTION,
    XML_NODE_DOCUMENT_TYPE,
    XML_NODE_ELEMENT_START,
    XML_NODE_ELEMENT_END,
    XML_NODE_ATTRIBUTE,
    XML_NODE_TEXT,
    XML_NODE_CDATA,
    XML_NODE_ENTITY_REFERENCE,
    XML_NODE_WHITESPACE,
    XML_NODE_COMMENT
  );

  // Status message types.
  TCefHandlerStatusType = (
    STATUSTYPE_TEXT = 0,
    STATUSTYPE_MOUSEOVER_URL,
    STATUSTYPE_KEYBOARD_FOCUS_URL
  );

  // Popup window features.
  PCefPopupFeatures = ^TCefPopupFeatures;
  TCefPopupFeatures = record
    x: Integer;
    xSet: Boolean;
    y: Integer;
    ySet: Boolean;
    width: Integer;
    widthSet: Boolean;
    height: Integer;
    heightSet: Boolean;

    menuBarVisible: Boolean;
    statusBarVisible: Boolean;
    toolBarVisible: Boolean;
    locationBarVisible: Boolean;
    scrollbarsVisible: Boolean;
    resizable: Boolean;

    fullscreen: Boolean;
    dialog: Boolean;
    additionalFeatures: TCefStringList;
  end;

(*******************************************************************************
   capi
 *******************************************************************************)
type
  PCefv8Handler = ^TCefv8Handler;
  PCefv8Value = ^TCefv8Value;
  PCefV8ValueArray = array[0..(High(Integer) div SizeOf(Integer)) - 1] of PCefV8Value;
  PPCefV8Value = ^PCefV8ValueArray;
  PCefSchemeHandlerFactory = ^TCefSchemeHandlerFactory;
  PCefHandler = ^TCefHandler;
  PCefFrame = ^TCefFrame;
  PCefRequest = ^TCefRequest;
  PCefStreamReader = ^TCefStreamReader;
  PCefHandlerMenuInfo = ^TCefHandlerMenuInfo;
  PCefPrintInfo = ^TCefPrintInfo;
  PCefPostData = ^TCefPostData;
  PCefPostDataElement = ^TCefPostDataElement;
  PCefReadHandler = ^TCefReadHandler;
  PCefWriteHandler = ^TCefWriteHandler;
  PCefStreamWriter = ^TCefStreamWriter;
  PCefSchemeHandler = ^TCefSchemeHandler;
  PCefBase = ^TCefBase;
  PCefBrowser = ^TCefBrowser;
  PCefTask = ^TCefTask;
  PCefDownloadHandler = ^TCefDownloadHandler;
  PCefXmlReader = ^TCefXmlReader;
  PCefZipReader = ^TCefZipReader;


  TCefBase = record
    // Size of the data structure.
    size: Cardinal;

    // Increment the reference count.
    add_ref: function(self: PCefBase): Integer; stdcall;
    // Decrement the reference count.  Delete this object when no references
    // remain.
    release: function(self: PCefBase): Integer; stdcall;
    // Returns the current number of references.
    get_refct: function(self: PCefBase): Integer; stdcall;
  end;

  // Implement this structure for task execution. The functions of this structure
  // may be called on any thread.
  TCefTask = record
    // Base structure.
    base: TCefBase;
    // Method that will be executed. |threadId| is the thread executing the call.
    execute: procedure(self: PCefTask; threadId: TCefThreadId); stdcall;
  end;

  // Structure used to represent a browser window. The functions of this structure
  // may be called on any thread unless otherwise indicated in the comments.
  TCefBrowser = record
    // Base structure.
    base: TCefBase;

    // Returns true (1) if the browser can navigate backwards.
    can_go_back: function(self: PCefBrowser): Integer; stdcall;

    // Navigate backwards.
    go_back: procedure(self: PCefBrowser); stdcall;

    // Returns true (1) if the browser can navigate forwards.
    can_go_forward: function(self: PCefBrowser): Integer; stdcall;

    // Navigate backwards.
    go_forward: procedure(self: PCefBrowser); stdcall;

    // Reload the current page.
    reload: procedure(self: PCefBrowser); stdcall;

    // Reload the current page ignoring any cached data.
    reload_ignore_cache: procedure(self: PCefBrowser); stdcall;

    // Stop loading the page.
    stop_load: procedure(self: PCefBrowser); stdcall;

    // Set focus for the browser window. If |enable| is true (1) focus will be set
    // to the window. Otherwise, focus will be removed.
    set_focus: procedure(self: PCefBrowser; enable: Integer); stdcall;

    // Retrieve the window handle for this browser.
    get_window_handle: function(self: PCefBrowser): CefWindowHandle; stdcall;

    // Returns true (1) if the window is a popup window.
    is_popup: function(self: PCefBrowser): Integer; stdcall;

    // Returns the handler for this browser.
    get_handler: function(self: PCefBrowser): PCefHandler; stdcall;

    // Returns the main (top-level) frame for the browser window.
    get_main_frame: function(self: PCefBrowser): PCefFrame; stdcall;

    // Returns the focused frame for the browser window. This function should only
    // be called on the UI thread.
    get_focused_frame: function (self: PCefBrowser): PCefFrame; stdcall;

    // Returns the frame with the specified name, or NULL if not found. This
    // function should only be called on the UI thread.
    get_frame: function(self: PCefBrowser; const name: TCefString): PCefFrame; stdcall;

    // Returns the names of all existing frames. This function should only be
    // called on the UI thread.
    get_frame_names: procedure(self: PCefBrowser; names: TCefStringList); stdcall;

    // Search for |searchText|. |identifier| can be used to have multiple searches
    // running simultaniously. |forward| indicates whether to search forward or
    // backward within the page. |matchCase| indicates whether the search should
    // be case-sensitive. |findNext| indicates whether this is the first request
    // or a follow-up.
    find: procedure(self: PCefBrowser; identifier: Integer; const searchText: TCefString;
      forward, matchCase, findNext: Integer); stdcall;

    // Cancel all searches that are currently going on.
    stop_finding: procedure(self: PCefBrowser; clearSelection: Integer); stdcall;

    // Get the zoom level.
    get_zoom_level: function(self: PCefBrowser): Double; stdcall;

    // Change the zoom level to the specified value.
    set_zoom_level: procedure(self: PCefBrowser; zoomLevel: Double); stdcall;

    // Open developer tools in its own window.
    show_dev_tools: procedure(self: PCefBrowser); stdcall;

    // Explicitly close the developer tools window if one exists for this browser
    // instance.
    close_dev_tools: procedure(self: PCefBrowser); stdcall;
  end;

  // Structure used to represent a frame in the browser window. The functions of
  // this structure may be called on any thread unless otherwise indicated in the
  // comments.
  TCefFrame = record
    // Base structure.
    base: TCefBase;

    // Execute undo in this frame.
    undo: procedure(self: PCefFrame); stdcall;

    // Execute redo in this frame.
    redo: procedure(self: PCefFrame); stdcall;

    // Execute cut in this frame.
    cut: procedure(self: PCefFrame); stdcall;

    // Execute copy in this frame.
    copy: procedure(self: PCefFrame); stdcall;

    // Execute paste in this frame.
    paste: procedure(self: PCefFrame); stdcall;

    // Execute delete in this frame.
    del: procedure(self: PCefFrame); stdcall;

    // Execute select all in this frame.
    select_all: procedure(self: PCefFrame); stdcall;

    // Execute printing in the this frame.  The user will be prompted with the
    // print dialog appropriate to the operating system.
    print: procedure(self: PCefFrame); stdcall;

    // Save this frame's HTML source to a temporary file and open it in the
    // default text viewing application.
    view_source: procedure(self: PCefFrame); stdcall;

    // Returns this frame's HTML source as a string. This function should only be
    // called on the UI thread.
    get_source: function(self: PCefFrame): PCefStringUserFree; stdcall;

    // Returns this frame's display text as a string. This function should only be
    // called on the UI thread.
    get_text: function(self: PCefFrame): PCefStringUserFree; stdcall;

    // Load the request represented by the |request| object.
    load_request: procedure(self: PCefFrame; request: PCefRequest); stdcall;

    // Load the specified |url|.
    load_url: procedure(self: PCefFrame; const url: TCefString); stdcall;

    // Load the contents of |string| with the optional dummy target |url|.
    load_string: procedure(self: PCefFrame; const string_, url: TCefString); stdcall;

    // Load the contents of |stream| with the optional dummy target |url|.
    load_stream: procedure(self: PCefFrame; stream: PCefStreamReader; const url: TCefString); stdcall;

    // Execute a string of JavaScript code in this frame. The |script_url|
    // parameter is the URL where the script in question can be found, if any. The
    // renderer may request this URL to show the developer the source of the
    // error.  The |start_line| parameter is the base line number to use for error
    // reporting.
    execute_java_script: procedure(self: PCefFrame; const jsCode, scriptUrl: TCefString; startLine: Integer); stdcall;

    // Returns true (1) if this is the main frame.
    is_main: function(self: PCefFrame): Integer; stdcall;

    // Returns true (1) if this is the focused frame. This function should only be
    // called on the UI thread.
    is_focused: function(self: PCefFrame): Integer; stdcall;

    // Returns this frame's name.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_name: function(self: PCefFrame): PCefStringUserFree; stdcall;

    // Return the URL currently loaded in this frame. This function should only be
    // called on the UI thread.
    get_url: function(self: PCefFrame): PCefStringUserFree; stdcall;
  end;

  // Structure that should be implemented to handle events generated by the
  // browser window. The functions of this structure will be called on the thread
  // indicated in the function comments.
  TCefHandler = record
    // Base structure.
    base: TCefBase;

    // Called on the UI thread before a new window is created. The |parentBrowser|
    // parameter will point to the parent browser window, if any. The |popup|
    // parameter will be true (1) if the new window is a popup window, in which
    // case |popupFeatures| will contain information about the style of popup
    // window requested. If you create the window yourself you should populate the
    // window handle member of |createInfo| and return RV_HANDLED.  Otherwise,
    // return RV_CONTINUE and the framework will create the window.  By default, a
    // newly created window will recieve the same handler as the parent window.
    // To change the handler for the new window modify the object that |handler|
    // points to.
    handle_before_created: function(
      self: PCefHandler; parentBrowser: PCefBrowser;
      var windowInfo: TCefWindowInfo; popup: Integer;
      const popupFeatures: PCefPopupFeatures;
      var handler: PCefHandler; url: PCefString;
      settings: PCefBrowserSettings): TCefRetval; stdcall;

    // Called on the UI thread after a new window is created. The return value is
    // currently ignored.
    handle_after_created: function(self: PCefHandler;
      browser: PCefBrowser): TCefRetval; stdcall;

    // Called on the UI thread when a frame's address has changed. The return
    // value is currently ignored.
    handle_address_change: function(
        self: PCefHandler; browser: PCefBrowser;
        frame: PCefFrame; const url: PCefString): TCefRetval; stdcall;

    // Called on the UI thread when the page title changes. The return value is
    // currently ignored.
    handle_title_change: function(
        self: PCefHandler; browser: PCefBrowser;
        const title: PCefString): TCefRetval; stdcall;

    // Called on the UI thread before browser navigation. The client has an
    // opportunity to modify the |request| object if desired.  Return RV_HANDLED
    // to cancel navigation.
    handle_before_browse: function(
        self: PCefHandler; browser: PCefBrowser;
        frame: PCefFrame; request: PCefRequest;
        navType: TCefHandlerNavtype; isRedirect: Integer): TCefRetval; stdcall;

    // Called on the UI thread when the browser begins loading a page. The |frame|
    // pointer will be NULL if the event represents the overall load status and
    // not the load status for a particular frame. |isMainContent| will be true
    // (1) if this load is for the main content area and not an iframe. This
    // function may not be called if the load request fails. The return value is
    // currently ignored.
    handle_load_start: function(
        self: PCefHandler; browser: PCefBrowser;
        frame: PCefFrame; isMainContent: Integer): TCefRetval; stdcall;

    // Called on the UI thread when the browser is done loading a page. The
    // |frame| pointer will be NULL if the event represents the overall load
    // status and not the load status for a particular frame. |isMainContent| will
    // be true (1) if this load is for the main content area and not an iframe.
    // This function will be called irrespective of whether the request completes
    // successfully. The return value is currently ignored.
    handle_load_end: function(self: PCefHandler; browser: PCefBrowser;
      frame: PCefFrame; isMainContent, httpStatusCode: Integer): TCefRetval; stdcall;

    // Called on the UI thread when the browser fails to load a resource.
    // |errorCode| is the error code number and |failedUrl| is the URL that failed
    // to load. To provide custom error text assign the text to |errorText| and
    // return RV_HANDLED.  Otherwise, return RV_CONTINUE for the default error
    // text.
    handle_load_error: function(
        self: PCefHandler; browser: PCefBrowser;
        frame: PCefFrame; errorCode: TCefHandlerErrorcode;
        const failedUrl: PCefString; var errorText: TCefString): TCefRetval; stdcall;

    // Called on the IO thread before a resource is loaded.  To allow the resource
    // to load normally return RV_CONTINUE. To redirect the resource to a new url
    // populate the |redirectUrl| value and return RV_CONTINUE.  To specify data
    // for the resource return a CefStream object in |resourceStream|, set
    // |mimeType| to the resource stream's mime type, and return RV_CONTINUE. To
    // cancel loading of the resource return RV_HANDLED. Any modifications to
    // |request| will be observed.  If the URL in |request| is changed and
    // |redirectUrl| is also set, the URL in |request| will be used.
    handle_before_resource_load: function(
        self: PCefHandler; browser: PCefBrowser;
        request: PCefRequest; var redirectUrl: TCefString;
        var resourceStream: PCefStreamReader; var mimeType: TCefString;
        loadFlags: Integer): TCefRetval; stdcall;

    // Called on the IO thread to handle requests for URLs with an unknown
    // protocol component. Return RV_HANDLED to indicate that the request should
    // succeed because it was externally handled. Set |allow_os_execution| to true
    // (1) and return RV_CONTINUE to attempt execution via the registered OS
    // protocol handler, if any. If RV_CONTINUE is returned and either
    // |allow_os_execution| is false (0) or OS protocol handler execution fails
    // then the request will fail with an error condition. SECURITY WARNING: YOU
    // SHOULD USE THIS METHOD TO ENFORCE RESTRICTIONS BASED ON SCHEME, HOST OR
    // OTHER URL ANALYSIS BEFORE ALLOWING OS EXECUTION.
    handle_protocol_execution: function(self: PCefHandler; browser: PCefBrowser;
      const url: TCefString; var allow_os_execution: Integer): TCefRetval; stdcall;

    // Called on the UI thread when a server indicates via the 'Content-
    // Disposition' header that a response represents a file to download.
    // |mimeType| is the mime type for the download, |fileName| is the suggested
    // target file name and |contentLength| is either the value of the 'Content-
    // Size' header or -1 if no size was provided. Set |handler| to the
    // cef_download_handler_t instance that will recieve the file contents. Return
    // RV_CONTINUE to download the file or RV_HANDLED to cancel the file download.
    handle_download_response: function (
        self: PCefHandler; browser: PCefBrowser;
        const mimeType, fileName: PCefString; contentLength: int64;
        var handler: PCefDownloadHandler): TCefRetval; stdcall;

    // Called on the IO thread when the browser needs credentials from the user.
    // |isProxy| indicates whether the host is a proxy server. |host| contains the
    // hostname and port number. Set |username| and |password| and return
    // RV_HANDLED to handle the request. Return RV_CONTINUE to cancel the request.
    handle_authentication_request: function(
        self: PCefHandler; browser: PCefBrowser; isProxy: Integer;
        const host: PCefString; const realm: PCefString; const scheme: PCefString;
        username: PCefString; password: PCefString): TCefRetval; stdcall;

    // Called on the UI thread before a context menu is displayed. To cancel
    // display of the default context menu return RV_HANDLED.
    handle_before_menu: function(
        self: PCefHandler; browser: PCefBrowser;
        const menuInfo: PCefHandlerMenuInfo): TCefRetval; stdcall;

    // Called on the UI thread to optionally override the default text for a
    // context menu item. |label| contains the default text and may be modified to
    // substitute alternate text. The return value is currently ignored.
    handle_get_menu_label: function(
        self: PCefHandler; browser: PCefBrowser;
        menuId: TCefHandlerMenuId; var label_: TCefString): TCefRetval; stdcall;

    // Called on the UI thread when an option is selected from the default context
    // menu. Return RV_HANDLED to cancel default handling of the action.
    handle_menu_action: function(
        self: PCefHandler; browser: PCefBrowser;
        menuId: TCefHandlerMenuId): TCefRetval; stdcall;

    // Called on the UI thread to allow customization of standard print options
    // before the print dialog is displayed. |printOptions| allows specification
    // of paper size, orientation and margins. Note that the specified margins may
    // be adjusted if they are outside the range supported by the printer. All
    // units are in inches. Return RV_CONTINUE to display the default print
    // options or RV_HANDLED to display the modified |printOptions|.
    handle_print_options: function(self: PCefHandler; browser: PCefBrowser;
        printOptions: PCefPrintOptions): TCefRetval;


    // Called on the UI thread to format print headers and footers. |printInfo|
    // contains platform-specific information about the printer context. |url| is
    // the URL if the currently printing page, |title| is the title of the
    // currently printing page, |currentPage| is the current page number and
    // |maxPages| is the total number of pages. Six default header locations are
    // provided by the implementation: top left, top center, top right, bottom
    // left, bottom center and bottom right. To use one of these default locations
    // just assign a string to the appropriate variable. To draw the header and
    // footer yourself return RV_HANDLED. Otherwise, populate the approprate
    // variables and return RV_CONTINUE.
    handle_print_header_footer: function(
        self: PCefHandler; browser: PCefBrowser;
        frame: PCefFrame; printInfo: PCefPrintInfo;
        url, title: PCefString; currentPage, maxPages: Integer;
        var topLeft, topCenter, topRight, bottomLeft, bottomCenter,
        bottomRight: TCefString): TCefRetval; stdcall;

    // Called on the UI thread to run a JS alert message. Return RV_CONTINUE to
    // display the default alert or RV_HANDLED if you displayed a custom alert.
    handle_jsalert: function(self: PCefHandler;
        browser: PCefBrowser; frame: PCefFrame;
        const message: PCefString): TCefRetval; stdcall;

    // Called on the UI thread to run a JS confirm request. Return RV_CONTINUE to
    // display the default alert or RV_HANDLED if you displayed a custom alert. If
    // you handled the alert set |retval| to true (1) if the user accepted the
    // confirmation.
    handle_jsconfirm: function(
        self: PCefHandler; browser: PCefBrowser;
        frame: PCefFrame; const message: PCefString;
        var retval: Integer): TCefRetval; stdcall;

    // Called on the UI thread to run a JS prompt request. Return RV_CONTINUE to
    // display the default prompt or RV_HANDLED if you displayed a custom prompt.
    // If you handled the prompt set |retval| to true (1) if the user accepted the
    // prompt and request and |result| to the resulting value.
    handle_jsprompt: function(self: PCefHandler;
        browser: PCefBrowser; frame: PCefFrame;
        const message, defaultValue: PCefString; var retval: Integer;
        var result: TCefString): TCefRetval; stdcall;

    // Called on the UI thread for adding values to a frame's JavaScript 'window'
    // object. The return value is currently ignored.
    handle_jsbinding: function(self: PCefHandler; browser: PCefBrowser;
      frame: PCefFrame; obj: PCefv8Value): TCefRetval; stdcall;

    // Called on the UI thread just before a window is closed. The return value is
    // currently ignored.
    handle_before_window_close: function(
        self: PCefHandler; browser: PCefBrowser): TCefRetval; stdcall;

    // Called on the UI thread when the browser component is about to loose focus.
    // For instance, if focus was on the last HTML element and the user pressed
    // the TAB key. The return value is currently ignored.
    handle_take_focus: function(
        self: PCefHandler; browser: PCefBrowser;
        reverse: Integer): TCefRetval; stdcall;

    // Called on the UI thread when the browser component is requesting focus.
    // |isWidget| will be true (1) if the focus is requested for a child widget of
    // the browser window. Return RV_CONTINUE to allow the focus to be set or
    // RV_HANDLED to cancel setting the focus.
    handle_set_focus: function(
        self: PCefHandler; browser: PCefBrowser;
        isWidget: Integer): TCefRetval; stdcall;

    // Called on the UI thread when the browser component receives a keyboard
    // event. |type| is the type of keyboard event, |code| is the windows scan-
    // code for the event, |modifiers| is a set of bit-flags describing any
    // pressed modifier keys and |isSystemKey| is true (1) if Windows considers
    // this a 'system key' message (see http://msdn.microsoft.com/en-
    // us/library/ms646286(VS.85).aspx). Return RV_HANDLED if the keyboard event
    // was handled or RV_CONTINUE to allow the browser component to handle the
    // event.
    handle_key_event: function(
        self: PCefHandler; browser: PCefBrowser;
        event: TCefHandlerKeyEventType; code, modifiers,
        isSystemKey: Integer): TCefRetval; stdcall;

    // Called on the UI thread when the browser is about to display a tooltip.
    // |text| contains the text that will be displayed in the tooltip. To handle
    // the display of the tooltip yourself return RV_HANDLED. Otherwise, you can
    // optionally modify |text| and then return RV_CONTINUE to allow the browser
    // to display the tooltip.
    handle_tooltip: function(self: PCefHandler;
        browser: PCefBrowser; text: PCefString): TCefRetval; stdcall;

    // Called on the UI thread when the browser has a status message. |text|
    // contains the text that will be displayed in the status message and |type|
    // indicates the status message type. The return value is currently ignored.
    handle_status: function(self: PCefHandler; browser: PCefBrowser;
      value: PCefString; type_: TCefHandlerStatusType): TCefRetval; stdcall;

    // Called on the UI thread to display a console message. Return RV_HANDLED to
    // stop the message from being output to the console.
    handle_console_message: function(
        self: PCefHandler; browser: PCefBrowser;
        const message, source: PCefString; line: Integer): TCefRetval; stdcall;

    // Called on the UI thread to report find results returned by
    // cef_browser_t::find(). |identifer| is the identifier passed to
    // cef_browser_t::find(), |count| is the number of matches currently
    // identified, |selectionRect| is the location of where the match was found
    // (in window coordinates), |activeMatchOrdinal| is the current position in
    // the search results, and |finalUpdate| is true (1) if this is the last find
    // notification. The return value is currently ignored.
    handle_find_result: function(self: PCefHandler; browser: PCefBrowser;
        identifier, count: Integer; const selectionRect: Pointer;
        activeMatchOrdinal, finalUpdate: Integer): TCefRetval; stdcall;

  end;

  // Structure used to represent a web request. The functions of this structure
  // may be called on any thread.
  TCefRequest = record
    // Base structure.
    base: TCefBase;

    // Fully qualified URL to load.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_url: function(self: PCefRequest): PCefStringUserFree; stdcall;
    set_url: procedure(self: PCefRequest; const url: TCefString); stdcall;

    // Optional request function type, defaulting to POST if post data is provided
    // and GET otherwise.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_method: function(self: PCefRequest): PCefStringUserFree; stdcall;
    set_method: procedure(self: PCefRequest; const method: TCefString); stdcall;

    // Optional post data.
    get_post_data: function(self: PCefRequest): PCefPostData; stdcall;
    set_post_data: procedure(self: PCefRequest; postData: PCefPostData); stdcall;

    // Optional header values.
    get_header_map: procedure(self: PCefRequest; headerMap: TCefStringMap); stdcall;
    set_header_map: procedure(self: PCefRequest; headerMap: TCefStringMap); stdcall;

    // Set all values at one time.
    set_: procedure(self: PCefRequest; const url, method: PCefString;
      postData: PCefPostData;  headerMap: TCefStringMap); stdcall;

  end;

  // Structure used to represent post data for a web request. The functions of
  // this structure may be called on any thread.
  TCefPostData = record
    // Base structure.
    base: TCefBase;

    // Returns the number of existing post data elements.
    get_element_count: function(self: PCefPostData): Cardinal; stdcall;

    // Retrieve the post data elements.
    get_elements: function(self: PCefPostData;
      elementIndex: Integer): PCefPostDataElement; stdcall;

    // Remove the specified post data element.  Returns true (1) if the removal
    // succeeds.
    remove_element: function(self: PCefPostData;
      element: PCefPostDataElement): Integer; stdcall;

    // Add the specified post data element.  Returns true (1) if the add succeeds.
    add_element: function(self: PCefPostData;
        element: PCefPostDataElement): Integer; stdcall;

    // Remove all existing post data elements.
    remove_elements: procedure(self: PCefPostData); stdcall;

  end;

  // Structure used to represent a single element in the request post data. The
  // functions of this structure may be called on any thread.
  TCefPostDataElement = record
    // Base structure.
    base: TCefBase;

    // Remove all contents from the post data element.
    set_to_empty: procedure(self: PCefPostDataElement); stdcall;

    // The post data element will represent a file.
    set_to_file: procedure(self: PCefPostDataElement;
        const fileName: TCefString); stdcall;

    // The post data element will represent bytes.  The bytes passed in will be
    // copied.
    set_to_bytes: procedure(self: PCefPostDataElement;
        size: Cardinal; const bytes: Pointer); stdcall;

    // Return the type of this post data element.
    get_type: function(self: PCefPostDataElement): TCefPostDataElementType; stdcall;

    // Return the file name.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_file: function(self: PCefPostDataElement): PCefStringUserFree; stdcall;

    // Return the number of bytes.
    get_bytes_count: function(self: PCefPostDataElement): Cardinal; stdcall;

    // Read up to |size| bytes into |bytes| and return the number of bytes
    // actually read.
    get_bytes: function(self: PCefPostDataElement;
        size: Cardinal; bytes: Pointer): Cardinal; stdcall;
  end;

  // Structure the client can implement to provide a custom stream reader. The
  // functions of this structure may be called on any thread.
  TCefReadHandler = record
    // Base structure.
    base: TCefBase;

    // Read raw binary data.
    read: function(self: PCefReadHandler; ptr: Pointer;
      size, n: Cardinal): Cardinal; stdcall;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET.
    seek: function(self: PCefReadHandler; offset: LongInt;
      whence: Integer): Integer; stdcall;

    // Return the current offset position.
    tell: function(self: PCefReadHandler): LongInt; stdcall;

    // Return non-zero if at end of file.
    eof: function(self: PCefReadHandler): Integer; stdcall;
  end;

  // Structure used to read data from a stream. The functions of this structure
  // may be called on any thread.
  TCefStreamReader = record
    // Base structure.
    base: TCefBase;

    // Read raw binary data.
    read: function(self: PCefStreamReader; ptr: Pointer;
        size, n: Cardinal): Cardinal; stdcall;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET. Returns zero on success and non-zero on failure.
    seek: function(self: PCefStreamReader; offset: LongInt;
        whence: Integer): Integer; stdcall;

    // Return the current offset position.
    tell: function(self: PCefStreamReader): LongInt; stdcall;

    // Return non-zero if at end of file.
    eof: function(self: PCefStreamReader): Integer; stdcall;
  end;

  // Structure the client can implement to provide a custom stream writer. The
  // functions of this structure may be called on any thread.
  TCefWriteHandler = record
    // Base structure.
    base: TCefBase;

    // Write raw binary data.
    write: function(self: PCefWriteHandler;
        const ptr: Pointer; size, n: Cardinal): Cardinal; stdcall;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET.
    seek: function(self: PCefWriteHandler; offset: LongInt;
        whence: Integer): Integer; stdcall;

    // Return the current offset position.
    tell: function(self: PCefWriteHandler): LongInt; stdcall;

    // Flush the stream.
    flush: function(self: PCefWriteHandler): Integer; stdcall;
  end;

  // Structure used to write data to a stream. The functions of this structure may
  // be called on any thread.
  TCefStreamWriter = record
    // Base structure.
    base: TCefBase;

    // Write raw binary data.
    write: function(self: PCefStreamWriter;
        const ptr: Pointer; size, n: Cardinal): Cardinal; stdcall;

    // Seek to the specified offset position. |whence| may be any one of SEEK_CUR,
    // SEEK_END or SEEK_SET.
    seek: function(self: PCefStreamWriter; offset: LongInt;
        whence: Integer): Integer; stdcall;

    // Return the current offset position.
    tell: function(self: PCefStreamWriter): LongInt; stdcall;

    // Flush the stream.
    flush: function(self: PCefStreamWriter): Integer; stdcall;
  end;

  // Structure that should be implemented to handle V8 function calls. The
  // functions of this structure will always be called on the UI thread.
  TCefv8Handler = record
    // Base structure.
    base: TCefBase;

    // Execute with the specified argument list and return value.  Return true (1)
    // if the function was handled.
    execute: function(self: PCefv8Handler;
        const name: TCefString; obj: PCefv8Value; argumentCount: Cardinal;
        const arguments: PPCefV8Value; var retval: PCefV8Value;
        var exception: TCefString): Integer; stdcall;
  end;

  // Structure representing a V8 value. The functions of this structure should
  // only be called on the UI thread.
  TCefv8Value = record
    // Base structure.
    base: TCefBase;

    // Check the value type.
    is_undefined: function(self: PCefv8Value): Integer; stdcall;
    is_null: function(self: PCefv8Value): Integer; stdcall;
    is_bool: function(self: PCefv8Value): Integer; stdcall;
    is_int: function(self: PCefv8Value): Integer; stdcall;
    is_double: function(self: PCefv8Value): Integer; stdcall;
    is_string: function(self: PCefv8Value): Integer; stdcall;
    is_object: function(self: PCefv8Value): Integer; stdcall;
    is_array: function(self: PCefv8Value): Integer; stdcall;
    is_function: function(self: PCefv8Value): Integer; stdcall;

    // Return a primitive value type.  The underlying data will be converted to
    // the requested type if necessary.
    get_bool_value: function(self: PCefv8Value): Integer; stdcall;
    get_int_value: function(self: PCefv8Value): Integer; stdcall;
    get_double_value: function(self: PCefv8Value): double; stdcall;
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_string_value: function(self: PCefv8Value): PCefStringUserFree; stdcall;


    // OBJECT METHODS - These functions are only available on objects. Arrays and
    // functions are also objects. String- and integer-based keys can be used
    // interchangably with the framework converting between them as necessary.
    // Keys beginning with "Cef::" and "v8::" are reserved by the system.

    // Returns true (1) if the object has a value with the specified identifier.
    has_value_bykey: function(self: PCefv8Value; const key: TCefString): Integer; stdcall;
    has_value_byindex: function(self: PCefv8Value; index: Integer): Integer; stdcall;

    // Delete the value with the specified identifier.
    delete_value_bykey: function(self: PCefv8Value; const key: TCefString): Integer; stdcall;
    delete_value_byindex: function(self: PCefv8Value; index: Integer): Integer; stdcall;

    // Returns the value with the specified identifier.
    get_value_bykey: function(self: PCefv8Value; const key: TCefString): PCefv8Value; stdcall;
    get_value_byindex: function(self: PCefv8Value; index: Integer): PCefv8Value; stdcall;

    // Associate value with the specified identifier.
    set_value_bykey: function(self: PCefv8Value;
       const key: TCefString; value: PCefv8Value): Integer; stdcall;
    set_value_byindex: function(self: PCefv8Value; index: Integer;
       value: PCefv8Value): Integer; stdcall;

    // Read the keys for the object's values into the specified vector. Integer-
    // based keys will also be returned as strings.
    get_keys: function(self: PCefv8Value;
        keys: TCefStringList): Integer; stdcall;

    // Returns the user data, if any, specified when the object was created.
    get_user_data: function(
        self: PCefv8Value): PCefBase; stdcall;


    // ARRAY METHODS - These functions are only available on arrays.

    // Returns the number of elements in the array.
    get_array_length: function(self: PCefv8Value): Integer; stdcall;


    // FUNCTION METHODS - These functions are only available on functions.

    // Returns the function name.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_function_name: function(self: PCefv8Value): PCefStringUserFree; stdcall;

    // Returns the function handler or NULL if not a CEF-created function.
    get_function_handler: function(
        self: PCefv8Value): PCefv8Handler; stdcall;

    // Execute the function.
    execute_function: function(self: PCefv8Value;
        obj: PCefv8Value; argumentCount: Cardinal;
        const arguments: PPCefV8Value; var retval: PCefV8Value;
        var exception: TCefString): Integer; stdcall;
  end;

  // Structure that creates cef_scheme_handler_t instances. The functions of this
  // structure will always be called on the IO thread.
  TCefSchemeHandlerFactory = record
    // Base structure.
    base: TCefBase;

    // Return a new scheme handler instance to handle the request.
    create: function(self: PCefSchemeHandlerFactory): PCefSchemeHandler; stdcall;
  end;

  // Structure used to represent a custom scheme handler structure. The functions
  // of this structure will always be called on the IO thread.
  TCefSchemeHandler = record
    // Base structure.
    base: TCefBase;

    // Process the request. All response generation should take place in this
    // function. If there is no response set |response_length| to zero and
    // read_response() will not be called. If the response length is not known
    // then set |response_length| to -1 and read_response() will be called until
    // it returns false (0) or until the value of |bytes_read| is set to 0.
    // Otherwise, set |response_length| to a positive value and read_response()
    // will be called until it returns false (0), the value of |bytes_read| is set
    // to 0 or the specified number of bytes have been read. If there is a
    // response set |mime_type| to the mime type for the response.
    process_request: function(self: PCefSchemeHandler;
        request: PCefRequest; var mime_type: TCefString;
        var response_length: Integer): Integer; stdcall;

    // Cancel processing of the request.
    cancel: procedure(self: PCefSchemeHandler); stdcall;

    // Copy up to |bytes_to_read| bytes into |data_out|. If the copy succeeds set
    // |bytes_read| to the number of bytes copied and return true (1). If the copy
    // fails return false (0) and read_response() will not be called again.
    read_response: function(self: PCefSchemeHandler;
        data_out: Pointer; bytes_to_read: Integer; var bytes_read: Integer): Integer; stdcall;
  end;

  // Structure used to handle file downloads. The functions of this structure will
  // always be called on the UI thread.
  TCefDownloadHandler = record
    // Base structure.
    base: TCefBase;

    // A portion of the file contents have been received. This function will be
    // called multiple times until the download is complete. Return |true (1)| to
    // continue receiving data and |false (0)| to cancel.
    received_data: function(self: PCefDownloadHandler; data: Pointer; data_size: Integer): Integer; stdcall;

    // The download is complete.
    complete: procedure(self: PCefDownloadHandler); stdcall;
  end;

  // Structure that supports the reading of XML data via the libxml streaming API.
  // The functions of this structure should only be called on the thread that
  // creates the object.
  TCefXmlReader = record
    // Base structure.
    base: TcefBase;

    // Moves the cursor to the next node in the document. This function must be
    // called at least once to set the current cursor position. Returns true (1)
    // if the cursor position was set successfully.
    move_to_next_node: function(self: PCefXmlReader): Integer; stdcall;

    // Close the document. This should be called directly to ensure that cleanup
    // occurs on the correct thread.
    close: function(self: PCefXmlReader): Integer; stdcall;

    // Returns true (1) if an error has been reported by the XML parser.
    has_error: function(self: PCefXmlReader): Integer; stdcall;

    // Returns the error string.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_error: function(self: PCefXmlReader): PCefStringUserFree; stdcall;


    // The below functions retrieve data for the node at the current cursor
    // position.

    // Returns the node type.
    get_type: function(self: PCefXmlReader): TCefXmlNodeType; stdcall;

    // Returns the node depth. Depth starts at 0 for the root node.
    get_depth: function(self: PCefXmlReader): Integer; stdcall;

    // Returns the local name. See http://www.w3.org/TR/REC-xml-names/#NT-
    // LocalPart for additional details.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_local_name: function(self: PCefXmlReader): PCefStringUserFree; stdcall;

    // Returns the namespace prefix. See http://www.w3.org/TR/REC-xml-names/ for
    // additional details.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_prefix: function(self: PCefXmlReader): PCefStringUserFree; stdcall;

    // Returns the qualified name, equal to (Prefix:)LocalName. See
    // http://www.w3.org/TR/REC-xml-names/#ns-qualnames for additional details.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_qualified_name: function(self: PCefXmlReader): PCefStringUserFree; stdcall;

    // Returns the URI defining the namespace associated with the node. See
    // http://www.w3.org/TR/REC-xml-names/ for additional details.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_namespace_uri: function(self: PCefXmlReader): PCefStringUserFree; stdcall;

    // Returns the base URI of the node. See http://www.w3.org/TR/xmlbase/ for
    // additional details.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_base_uri: function(self: PCefXmlReader): PCefStringUserFree; stdcall;

    // Returns the xml:lang scope within which the node resides. See
    // http://www.w3.org/TR/REC-xml/#sec-lang-tag for additional details.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_xml_lang: function(self: PCefXmlReader): PCefStringUserFree; stdcall;

    // Returns true (1) if the node represents an NULL element. <a/> is considered
    // NULL but <a></a> is not.
    is_empty_element: function(self: PCefXmlReader): Integer; stdcall;

    // Returns true (1) if the node has a text value.
    has_value: function(self: PCefXmlReader): Integer; stdcall;

    // Returns the text value.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_value: function(self: PCefXmlReader): PCefStringUserFree; stdcall;

    // Returns true (1) if the node has attributes.
    has_attributes: function(self: PCefXmlReader): Integer; stdcall;

    // Returns the number of attributes.
    get_attribute_count: function(self: PCefXmlReader): Cardinal; stdcall;

    // Returns the value of the attribute at the specified 0-based index.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_attribute_byindex: function(self: PCefXmlReader; index: Integer): PCefStringUserFree; stdcall;

    // Returns the value of the attribute with the specified qualified name.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_attribute_byqname: function(self: PCefXmlReader; const qualifiedName: TCefString): PCefStringUserFree; stdcall;

    // Returns the value of the attribute with the specified local name and
    // namespace URI.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_attribute_bylname: function(self: PCefXmlReader; const localName, namespaceURI: TCefString): PCefStringUserFree; stdcall;

    // Returns an XML representation of the current node's children.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_inner_xml: function(self: PCefXmlReader): PCefStringUserFree; stdcall;

    // Returns an XML representation of the current node including its children.
    // The resulting string must be freed by calling cef_string_userfree_free().
    get_outer_xml: function(self: PCefXmlReader): PCefStringUserFree; stdcall;

    // Returns the line number for the current node.
    get_line_number: function(self: PCefXmlReader): Integer; stdcall;


    // Attribute nodes are not traversed by default. The below functions can be
    // used to move the cursor to an attribute node. move_to_carrying_element()
    // can be called afterwards to return the cursor to the carrying element. The
    // depth of an attribute node will be 1 + the depth of the carrying element.

    // Moves the cursor to the attribute at the specified 0-based index. Returns
    // true (1) if the cursor position was set successfully.
    move_to_attribute_byindex: function(self: PCefXmlReader; index: Integer): Integer; stdcall;

    // Moves the cursor to the attribute with the specified qualified name.
    // Returns true (1) if the cursor position was set successfully.
    move_to_attribute_byqname: function(self: PCefXmlReader; const qualifiedName: TCefString): Integer; stdcall;

    // Moves the cursor to the attribute with the specified local name and
    // namespace URI. Returns true (1) if the cursor position was set
    // successfully.
    move_to_attribute_bylname: function(self: PCefXmlReader; const localName, namespaceURI: TCefString): Integer; stdcall;

    // Moves the cursor to the first attribute in the current element. Returns
    // true (1) if the cursor position was set successfully.
    move_to_first_attribute: function(self: PCefXmlReader): Integer; stdcall;

    // Moves the cursor to the next attribute in the current element. Returns true
    // (1) if the cursor position was set successfully.
    move_to_next_attribute: function(self: PCefXmlReader): Integer; stdcall;

    // Moves the cursor back to the carrying element. Returns true (1) if the
    // cursor position was set successfully.
    move_to_carrying_element: function(self: PCefXmlReader): Integer; stdcall;
  end;

  // Structure that supports the reading of zip archives via the zlib unzip API.
  // The functions of this structure should only be called on the thread that
  // creates the object.
  TCefZipReader = record
    // Base structure.
    base: TCefBase;

    // Moves the cursor to the first file in the archive. Returns true (1) if the
    // cursor position was set successfully.
    move_to_first_file: function(self: PCefZipReader): Integer; stdcall;

    // Moves the cursor to the next file in the archive. Returns true (1) if the
    // cursor position was set successfully.
    move_to_next_file: function(self: PCefZipReader): Integer; stdcall;

    // Moves the cursor to the specified file in the archive. If |caseSensitive|
    // is true (1) then the search will be case sensitive. Returns true (1) if the
    // cursor position was set successfully.
    move_to_file: function(self: PCefZipReader; const fileName: TCefString; caseSensitive: Integer): Integer; stdcall;

    // Closes the archive. This should be called directly to ensure that cleanup
    // occurs on the correct thread.
    close: function(Self: PCefZipReader): Integer; stdcall;


    // The below functions act on the file at the current cursor position.

    // Returns the name of the file.
  // The resulting string must be freed by calling cef_string_userfree_free().
    get_file_name: function(Self: PCefZipReader): PCefStringUserFree; stdcall;

    // Returns the uncompressed size of the file.
    get_file_size: function(Self: PCefZipReader): LongInt; stdcall;

    // Returns the last modified timestamp for the file.
    get_file_last_modified: function(Self: PCefZipReader): LongInt; stdcall;

    // Opens the file for reading of uncompressed data. A read password may
    // optionally be specified.
    open_file: function(Self: PCefZipReader; const password: TCefString): Integer; stdcall;

    // Closes the file.
    close_file: function(Self: PCefZipReader): Integer; stdcall;

    // Read uncompressed file contents into the specified buffer. Returns < 0 if
    // an error occurred, 0 if at the end of file, or the number of bytes read.
    read_file: function(Self: PCefZipReader; buffer: Pointer; bufferSize: Cardinal): Integer; stdcall;

    // Returns the current offset in the uncompressed file contents.
    tell: function(Self: PCefZipReader): LongInt; stdcall;

    // Returns true (1) if at end of the file contents.
    eof: function(Self: PCefZipReader): Integer; stdcall;
  end;


  ICefBrowser = interface;
  ICefFrame = interface;
  ICefRequest = interface;
  ICefv8Value = interface;

  ICefBase = interface
    ['{1F9A7B44-DCDC-4477-9180-3ADD44BDEB7B}']
    function Wrap: Pointer;
  end;

  ICefBrowser = interface(ICefBase)
    ['{BA003C2E-CF15-458F-9D4A-FE3CEFCF3EEF}']
    function CanGoBack: Boolean;
    procedure GoBack;
    function CanGoForward: Boolean;
    procedure GoForward;
    procedure Reload;
    procedure ReloadIgnoreCache;
    procedure StopLoad;
    procedure SetFocus(enable: Boolean);
    function GetWindowHandle: CefWindowHandle;
    function IsPopup: Boolean;
    function GetHandler: ICefBase;
    function GetMainFrame: ICefFrame;
    function  GetFocusedFrame: ICefFrame;
    function GetFrame(const name: ustring): ICefFrame;
    procedure GetFrameNames(const names: TStrings);
    procedure Find(const searchText: ustring;
      identifier, forward, matchCase, findNext: Boolean);
    procedure StopFinding(ClearSelection: Boolean);
    function GetZoomLevel: Double;
    procedure SetZoomLevel(zoomLevel: Double);
    procedure ShowDevTools;
    procedure CloseDevTools;
    property MainFrame: ICefFrame read GetMainFrame;
    property Frame[const name: ustring]: ICefFrame read GetFrame;
    property ZoomLevel: Double read GetZoomLevel write SetZoomLevel;
  end;

  ICefPostDataElement = interface(ICefBase)
    ['{3353D1B8-0300-4ADC-8D74-4FF31C77D13C}']
    procedure SetToEmpty;
    procedure SetToFile(const fileName: ustring);
    procedure SetToBytes(size: Cardinal; bytes: Pointer);
    function GetType: TCefPostDataElementType;
    function GetFile: ustring;
    function GetBytesCount: Cardinal;
    function GetBytes(size: Cardinal; bytes: Pointer): Cardinal;
  end;

  ICefPostData = interface(ICefBase)
    ['{1E677630-9339-4732-BB99-D6FE4DE4AEC0}']
    function GetCount: Cardinal;
    function GetElement(Index: Integer): ICefPostDataElement;
    function RemoveElement(const element: ICefPostDataElement): Integer;
    function AddElement(const element: ICefPostDataElement): Integer;
    procedure RemoveElements;
  end;

  ICefStringMap = interface
  ['{A33EBC01-B23A-4918-86A4-E24A243B342F}']
    function GetHandle: TCefStringMap;
    function GetSize: Integer;
    function Find(const key: ustring): ustring;
    function GetKey(index: Integer): ustring;
    function GetValue(index: Integer): ustring;
    procedure Append(const key, value: ustring);
    procedure Clear;

    property Handle: TCefStringMap read GetHandle;
    property Size: Integer read GetSize;
    property Key[index: Integer]: ustring read GetKey;
    property Value[index: Integer]: ustring read GetValue;
  end;

  ICefRequest = interface(ICefBase)
    ['{FB4718D3-7D13-4979-9F4C-D7F6C0EC592A}']
    function GetUrl: ustring;
    function GetMethod: ustring;
    function GetPostData: ICefPostData;
    procedure GetHeaderMap(const HeaderMap: ICefStringMap);
    procedure SetUrl(const value: ustring);
    procedure SetMethod(const value: ustring);
    procedure SetPostData(const value: ICefPostData);
    procedure SetHeaderMap(const HeaderMap: ICefStringMap);
    property Url: ustring read GetUrl write SetUrl;
    property Method: ustring read GetMethod write SetMethod;
    property PostData: ICefPostData read GetPostData write SetPostData;
  end;

  ICefFrame = interface(ICefBase)
    ['{8FD3D3A6-EA3A-4A72-8501-0276BD5C3D1D}']
    procedure Undo;
    procedure Redo;
    procedure Cut;
    procedure Copy;
    procedure Paste;
    procedure Del;
    procedure SelectAll;
    procedure Print;
    procedure ViewSource;
    function GetSource: ustring;
    function getText: ustring;
    procedure LoadRequest(const request: ICefRequest);
    procedure LoadUrl(const url: ustring);
    procedure LoadString(const str, url: ustring);
    procedure LoadStream(const stream: TStream; const url: ustring);
    procedure LoadFile(const filename, url: ustring);
    procedure ExecuteJavaScript(const jsCode, scriptUrl: ustring; startLine: Integer);
    function IsMain: Boolean;
    function IsFocused: Boolean;
    function GetName: ustring;
    function GetUrl: ustring;
    property Name: ustring read GetName;
    property Url: ustring read GetUrl;
    property Source: ustring read GetSource;
    property Text: ustring read getText;
  end;

  ICefStreamReader = interface(ICefBase)
    ['{DD5361CB-E558-49C5-A4BD-D1CE84ADB277}']
    function Read(ptr: Pointer; size, n: Cardinal): Cardinal;
    function Seek(offset: LongInt; whence: Integer): Integer;
    function Tell: LongInt;
    function Eof: Boolean;
  end;

  ICefSchemeHandler = interface(ICefBase)
  ['{A965F2A8-1675-44AE-AA54-F4C64B85A263}']
    function ProcessRequest(const Request: ICefRequest; var MimeType: ustring;
      var ResponseLength: Integer): Boolean;
    procedure Cancel;
    function ReadResponse(DataOut: Pointer; BytesToRead: Integer;
      var BytesRead: Integer): Boolean;
  end;

  ICefSchemeHandlerFactory = interface(ICefBase)
    ['{4D9B7960-B73B-4EBD-9ABE-6C1C43C245EB}']
    function New: ICefSchemeHandler;
  end;

  ICefDownloadHandler = interface(ICefBase)
  ['{3137F90A-5DC5-43C1-858D-A269F28EF4F1}']
    function ReceivedData(data: Pointer; DataSize: Integer): Integer;
    procedure Complete;
  end;

  TCefv8ValueArray = array of ICefv8Value;

  ICefv8Handler = interface(ICefBase)
    ['{F94CDC60-FDCB-422D-96D5-D2A775BD5D73}']
    function Execute(const name: ustring; const obj: ICefv8Value;
      const arguments: TCefv8ValueArray; var retval: ICefv8Value;
      var exception: ustring): Boolean;
  end;

  ICefTask = interface(ICefBase)
    ['{0D965470-4A86-47CE-BD39-A8770021AD7E}']
    procedure Execute(threadId: TCefThreadId);
  end;

  ICefv8Value = interface(ICefBase)
  ['{52319B8D-75A8-422C-BD4B-16FA08CC7F42}']
    function IsUndefined: Boolean;
    function IsNull: Boolean;
    function IsBool: Boolean;
    function IsInt: Boolean;
    function IsDouble: Boolean;
    function IsString: Boolean;
    function IsObject: Boolean;
    function IsArray: Boolean;
    function IsFunction: Boolean;
    function GetBoolValue: Boolean;
    function GetIntValue: Integer;
    function GetDoubleValue: Double;
    function GetStringValue: ustring;
    function HasValueByKey(const key: ustring): Boolean;
    function HasValueByIndex(index: Integer): Boolean;
    function DeleteValueByKey(const key: ustring): Boolean;
    function DeleteValueByIndex(index: Integer): Boolean;
    function GetValueByKey(const key: ustring): ICefv8Value;
    function GetValueByIndex(index: Integer): ICefv8Value;
    function SetValueByKey(const key: ustring; const value: ICefv8Value): Boolean;
    function SetValueByIndex(index: Integer; const value: ICefv8Value): Boolean;
    function GetKeys(const keys: TStrings): Integer; stdcall;
    function GetUserData: ICefBase;
    function GetArrayLength: Integer;
    function GetFunctionName: ustring;
    function GetFunctionHandler: ICefv8Handler;
    function ExecuteFunction(const obj: ICefv8Value;
      const arguments: TCefv8ValueArray; var retval: ICefv8Value;
      var exception: ustring): Boolean;
  end;

  ICefXmlReader = interface(ICefBase)
  ['{0DE686C3-A8D7-45D2-82FD-92F7F4E62A90}']
    function MoveToNextNode: Boolean;
    function Close: Boolean;
    function HasError: Boolean;
    function GetError: ustring;
    function GetType: TCefXmlNodeType;
    function GetDepth: Integer;
    function GetLocalName: ustring;
    function GetPrefix: ustring;
    function GetQualifiedName: ustring;
    function GetNamespaceUri: ustring;
    function GetBaseUri: ustring;
    function GetXmlLang: ustring;
    function IsEmptyElement: Boolean;
    function HasValue: Boolean;
    function GetValue: ustring;
    function HasAttributes: Boolean;
    function GetAttributeCount: Cardinal;
    function GetAttributeByIndex(index: Integer): ustring;
    function GetAttributeByQName(const qualifiedName: ustring): ustring;
    function GetAttributeByLName(const localName, namespaceURI: ustring): ustring;
    function GetInnerXml: ustring;
    function GetOuterXml: ustring;
    function GetLineNumber: Integer;
    function MoveToAttributeByIndex(index: Integer): Boolean;
    function MoveToAttributeByQName(const qualifiedName: ustring): Boolean;
    function MoveToAttributeByLName(const localName, namespaceURI: ustring): Boolean;
    function MoveToFirstAttribute: Boolean;
    function MoveToNextAttribute: Boolean;
    function MoveToCarryingElement: Boolean;
  end;

  ICefZipReader = interface(ICefBase)
  ['{3B6C591F-9877-42B3-8892-AA7B27DA34A8}']
    function MoveToFirstFile: Boolean;
    function MoveToNextFile: Boolean;
    function MoveToFile(const fileName: ustring; caseSensitive: Boolean): Boolean;
    function Close: Boolean;
    function GetFileName: ustring;
    function GetFileSize: LongInt;
    function GetFileLastModified: LongInt;
    function OpenFile(const password: ustring): Boolean;
    function CloseFile: Boolean;
    function ReadFile(buffer: Pointer; bufferSize: Cardinal): Integer;
    function Tell: LongInt;
    function Eof: Boolean;
  end;

  TCefBaseOwn = class(TInterfacedObject, ICefBase)
  private
    FData: Pointer;
    FCriticaSection: TRTLCriticalSection;
  protected
    function Wrap: Pointer;
    procedure Lock;
    procedure Unlock;
  public
    constructor CreateData(size: Cardinal); virtual;
    destructor Destroy; override;
    property Data: Pointer read Wrap;
  end;

  TCefBaseRef = class(TInterfacedObject, ICefBase)
  private
    FData: Pointer;
  protected
    function Wrap: Pointer;
  public
    constructor Create(data: Pointer); virtual;
    destructor Destroy; override;
    class function UnWrap(data: Pointer): ICefBase;
  end;

  TCefBrowserRef = class(TCefBaseRef, ICefBrowser)
  protected
    function CanGoBack: Boolean;
    procedure GoBack;
    function CanGoForward: Boolean;
    procedure GoForward;
    procedure Reload;
    procedure ReloadIgnoreCache;
    procedure StopLoad;
    procedure SetFocus(enable: Boolean);
    function GetWindowHandle: CefWindowHandle;
    function IsPopup: Boolean;
    function GetHandler: ICefBase;
    function GetMainFrame: ICefFrame;
    function  GetFocusedFrame: ICefFrame;
    function GetFrame(const name: ustring): ICefFrame;
    procedure GetFrameNames(const names: TStrings);
    procedure Find(const searchText: ustring;
      identifier, forward, matchCase, findNext: Boolean);
    procedure StopFinding(ClearSelection: Boolean);
    function GetZoomLevel: Double;
    procedure SetZoomLevel(zoomLevel: Double);
    procedure ShowDevTools;
    procedure CloseDevTools;
  public
    class function UnWrap(data: Pointer): ICefBrowser;
  end;

  TCefFrameRef = class(TCefBaseRef, ICefFrame)
  protected
    procedure Undo;
    procedure Redo;
    procedure Cut;
    procedure Copy;
    procedure Paste;
    procedure Del;
    procedure SelectAll;
    procedure Print;
    procedure ViewSource;
    function GetSource: ustring;
    function getText: ustring;
    procedure LoadRequest(const request: ICefRequest);
    procedure LoadUrl(const url: ustring);
    procedure LoadString(const str, url: ustring);
    procedure LoadStream(const stream: TStream; const url: ustring);
    procedure LoadFile(const filename, url: ustring);
    procedure ExecuteJavaScript(const jsCode, scriptUrl: ustring; startLine: Integer);
    function IsMain: Boolean;
    function IsFocused: Boolean;
    function GetName: ustring;
    function GetUrl: ustring;
  public
    class function UnWrap(data: Pointer): ICefFrame;
  end;

  TCefPostDataRef = class(TCefBaseRef, ICefPostData)
  protected
    function GetCount: Cardinal;
    function GetElement(Index: Integer): ICefPostDataElement;
    function RemoveElement(const element: ICefPostDataElement): Integer;
    function AddElement(const element: ICefPostDataElement): Integer;
    procedure RemoveElements;
  public
    class function UnWrap(data: Pointer): ICefPostData;
  end;

  TCefPostDataElementRef = class(TCefBaseRef, ICefPostDataElement)
  protected
    procedure SetToEmpty;
    procedure SetToFile(const fileName: ustring);
    procedure SetToBytes(size: Cardinal; bytes: Pointer);
    function GetType: TCefPostDataElementType;
    function GetFile: ustring;
    function GetBytesCount: Cardinal;
    function GetBytes(size: Cardinal; bytes: Pointer): Cardinal;
  public
    class function UnWrap(data: Pointer): ICefPostDataElement;
  end;

  TCefRequestRef = class(TCefBaseRef, ICefRequest)
  protected
    function GetUrl: ustring;
    function GetMethod: ustring;
    function GetPostData: ICefPostData;
    procedure GetHeaderMap(const HeaderMap: ICefStringMap);
    procedure SetUrl(const value: ustring);
    procedure SetMethod(const value: ustring);
    procedure SetPostData(const value: ICefPostData);
    procedure SetHeaderMap(const HeaderMap: ICefStringMap);
  public
    class function UnWrap(data: Pointer): ICefRequest;
  end;

  TCefStreamReaderRef = class(TCefBaseRef, ICefStreamReader)
  protected
    function Read(ptr: Pointer; size, n: Cardinal): Cardinal;
    function Seek(offset: LongInt; whence: Integer): Integer;
    function Tell: LongInt;
    function Eof: Boolean;
  public
    class function UnWrap(data: Pointer): ICefStreamReader;
  end;

  TCefv8ValueRef = class(TCefBaseRef, ICefv8Value)
  protected
    function IsUndefined: Boolean;
    function IsNull: Boolean;
    function IsBool: Boolean;
    function IsInt: Boolean;
    function IsDouble: Boolean;
    function IsString: Boolean;
    function IsObject: Boolean;
    function IsArray: Boolean;
    function IsFunction: Boolean;
    function GetBoolValue: Boolean;
    function GetIntValue: Integer;
    function GetDoubleValue: Double;
    function GetStringValue: ustring;
    function HasValueByKey(const key: ustring): Boolean;
    function HasValueByIndex(index: Integer): Boolean;
    function DeleteValueByKey(const key: ustring): Boolean;
    function DeleteValueByIndex(index: Integer): Boolean;
    function GetValueByKey(const key: ustring): ICefv8Value;
    function GetValueByIndex(index: Integer): ICefv8Value;
    function SetValueByKey(const key: ustring; const value: ICefv8Value): Boolean;
    function SetValueByIndex(index: Integer; const value: ICefv8Value): Boolean;
    function GetKeys(const keys: TStrings): Integer; stdcall;
    function GetUserData: ICefBase;
    function GetArrayLength: Integer;
    function GetFunctionName: ustring;
    function GetFunctionHandler: ICefv8Handler;
    function ExecuteFunction(const obj: ICefv8Value;
      const arguments: TCefv8ValueArray; var retval: ICefv8Value;
      var exception: ustring): Boolean;
  public
    class function UnWrap(data: Pointer): ICefv8Value;
    constructor CreateUndefined;
    constructor CreateNull;
    constructor CreateBool(value: Boolean);
    constructor CreateInt(value: Integer);
    constructor CreateDouble(value: Double);
    constructor CreateString(const str: ustring);
    constructor CreateObject(const UserData: ICefBase);
    constructor CreateArray;
    constructor CreateFunction(const name: ustring; const handler: ICefv8Handler);
  end;

  TCefv8HandlerRef = class(TCefBaseRef, ICefv8Handler)
  protected
    function Execute(const name: ustring; const obj: ICefv8Value;
      const arguments: TCefv8ValueArray; var retval: ICefv8Value;
      var exception: ustring): Boolean;
  public
    class function UnWrap(data: Pointer): ICefv8Handler;
  end;

  TCefHandlerOwn = class(TCefBaseOwn)
  protected
    function doOnBeforeCreated(const parentBrowser: ICefBrowser;
      var windowInfo: TCefWindowInfo; popup: Boolean;
      var handler: ICefBase; var url: ustring;
      var settings: TCefBrowserSettings): TCefRetval; virtual;
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
    function doOnPrintOptions(const browser: ICefBrowser;
        printOptions: PCefPrintOptions): TCefRetval; virtual;
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
    function doOnJsBinding(const browser: ICefBrowser;
      const frame: ICefFrame; const obj: ICefv8Value): TCefRetval; virtual;
    function doOnBeforeWindowClose(const browser: ICefBrowser): TCefRetval; virtual;
    function doOnTakeFocus(const browser: ICefBrowser; reverse: Integer): TCefRetval; virtual;
    function doOnSetFocus(const browser: ICefBrowser; isWidget: Boolean): TCefRetval; virtual;
    function doOnKeyEvent(const browser: ICefBrowser; event: TCefHandlerKeyEventType;
      code, modifiers: Integer; isSystemKey: Boolean): TCefRetval; virtual;
    function doOnTooltip(const browser: ICefBrowser; var text: ustring): TCefRetval; virtual;
    function doOnStatus(const browser: ICefBrowser; const value: ustring;
      StatusType: TCefHandlerStatusType): TCefRetval; virtual;
    function doOnConsoleMessage(const browser: ICefBrowser; const message,
      source: ustring; line: Integer): TCefRetval; virtual;
    function doOnFindResult(const browser: ICefBrowser; count: Integer;
      selectionRect: PCefRect; identifier, activeMatchOrdinal,
      finalUpdate: Boolean): TCefRetval; virtual;
    function doOnDownloadResponse(const browser: ICefBrowser; const mimeType, fileName: ustring;
      contentLength: int64; var handler: ICefDownloadHandler): TCefRetval; virtual;
    function doOnAuthenticationRequest(const browser: ICefBrowser; isProxy: Boolean;
      const host, realm, scheme: ustring; var username, password: ustring): TCefRetval; virtual;
  public
    constructor Create; virtual;
  end;

  TCefStreamReaderOwn = class(TCefBaseOwn, ICefStreamReader)
  private
    FStream: TStream;
    FOwned: Boolean;
  protected
    function Read(ptr: Pointer; size, n: Cardinal): Cardinal; virtual;
    function Seek(offset: LongInt; whence: Integer): Integer; virtual;
    function Tell: LongInt; virtual;
    function Eof: Boolean; virtual;
  public
    constructor Create(Stream: TStream; Owned: Boolean); overload; virtual;
    constructor Create(const filename: string); overload; virtual;
    destructor Destroy; override;
  end;

  TCefPostDataElementOwn = class(TCefBaseOwn, ICefPostDataElement)
  private
    FDataType: TCefPostDataElementType;
    FValueByte: Pointer;
    FValueStr: TCefString;
    FSize: Cardinal;
    procedure Clear;
  protected
    procedure SetToEmpty; virtual;
    procedure SetToFile(const fileName: ustring); virtual;
    procedure SetToBytes(size: Cardinal; bytes: Pointer); virtual;
    function GetType: TCefPostDataElementType; virtual;
    function GetFile: ustring; virtual;
    function GetBytesCount: Cardinal; virtual;
    function GetBytes(size: Cardinal; bytes: Pointer): Cardinal; virtual;
  public
    constructor Create; virtual;
  end;

  TCefSchemeHandlerOwn = class(TCefBaseOwn, ICefSchemeHandler)
  private
    FCancelled: Boolean;
  protected
    function ProcessRequest(const Request: ICefRequest; var MimeType: ustring;
      var ResponseLength: Integer): Boolean; virtual;
    procedure Cancel; virtual;
    function ReadResponse(DataOut: Pointer; BytesToRead: Integer;
      var BytesRead: Integer): Boolean; virtual;
  public
    constructor Create; virtual;
    property Cancelled: Boolean read FCancelled;
  end;
  TCefSchemeHandlerClass = class of TCefSchemeHandlerOwn;

  TCefSchemeHandlerFactoryOwn = class(TCefBaseOwn, ICefSchemeHandlerFactory)
  private
    FClass: TCefSchemeHandlerClass;
  protected
    function New: ICefSchemeHandler; virtual;
  public
    constructor Create(const AClass: TCefSchemeHandlerClass); virtual;
  end;

  TCefDownloadHandlerOwn = class(TCefBaseOwn, ICefDownloadHandler)
  protected
    function ReceivedData(data: Pointer; DataSize: Integer): Integer; virtual; abstract;
    procedure Complete; virtual; abstract;
  public
    constructor Create; virtual;
  end;

  TCefv8HandlerOwn = class(TCefBaseOwn, ICefv8Handler)
  protected
    function Execute(const name: ustring; const obj: ICefv8Value;
      const arguments: TCefv8ValueArray; var retval: ICefv8Value;
      var exception: ustring): Boolean; virtual;
  public
    constructor Create; virtual;
  end;

  TCefTaskOwn = class(TCefBaseOwn, ICefTask)
  protected
    procedure Execute(threadId: TCefThreadId); virtual;
  public
    constructor Create; virtual;
  end;

  TCefStringMapOwn = class(TInterfacedObject, ICefStringMap)
  private
    FStringMap: TCefStringMap;
  protected
    function GetHandle: TCefStringMap; virtual;
    function GetSize: Integer; virtual;
    function Find(const key: ustring): ustring; virtual;
    function GetKey(index: Integer): ustring; virtual;
    function GetValue(index: Integer): ustring; virtual;
    procedure Append(const key, value: ustring); virtual;
    procedure Clear; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
  end;

  TCefXmlReaderRef = class(TCefBaseRef, ICefXmlReader)
  protected
    function MoveToNextNode: Boolean;
    function Close: Boolean;
    function HasError: Boolean;
    function GetError: ustring;
    function GetType: TCefXmlNodeType;
    function GetDepth: Integer;
    function GetLocalName: ustring;
    function GetPrefix: ustring;
    function GetQualifiedName: ustring;
    function GetNamespaceUri: ustring;
    function GetBaseUri: ustring;
    function GetXmlLang: ustring;
    function IsEmptyElement: Boolean;
    function HasValue: Boolean;
    function GetValue: ustring;
    function HasAttributes: Boolean;
    function GetAttributeCount: Cardinal;
    function GetAttributeByIndex(index: Integer): ustring;
    function GetAttributeByQName(const qualifiedName: ustring): ustring;
    function GetAttributeByLName(const localName, namespaceURI: ustring): ustring;
    function GetInnerXml: ustring;
    function GetOuterXml: ustring;
    function GetLineNumber: Integer;
    function MoveToAttributeByIndex(index: Integer): Boolean;
    function MoveToAttributeByQName(const qualifiedName: ustring): Boolean;
    function MoveToAttributeByLName(const localName, namespaceURI: ustring): Boolean;
    function MoveToFirstAttribute: Boolean;
    function MoveToNextAttribute: Boolean;
    function MoveToCarryingElement: Boolean;
  public
    constructor Create(const stream: ICefStreamReader;
      encodingType: TCefXmlEncodingType; const URI: ustring); reintroduce; virtual;
  end;

  TCefZipReaderRef = class(TCefBaseRef, ICefZipReader)
  protected
    function MoveToFirstFile: Boolean;
    function MoveToNextFile: Boolean;
    function MoveToFile(const fileName: ustring; caseSensitive: Boolean): Boolean;
    function Close: Boolean;
    function GetFileName: ustring;
    function GetFileSize: LongInt;
    function GetFileLastModified: LongInt;
    function OpenFile(const password: ustring): Boolean;
    function CloseFile: Boolean;
    function ReadFile(buffer: Pointer; bufferSize: Cardinal): Integer;
    function Tell: LongInt;
    function Eof: Boolean;
  public
    constructor Create(const stream: ICefStreamReader); reintroduce; virtual;
  end;

{$IFDEF DELPHI12_UP}
  TCefGenericTask<T> = class(TCefTaskOwn)
  type
    TCefTaskMethod = reference to procedure(const param: T);
  private
    FParam: T;
    FMethod: TCefTaskMethod;
  protected
    procedure Execute(threadId: TCefThreadId); override;
  public
    class procedure Post(threadId: TCefThreadId; const param: T; const method: TCefTaskMethod);
    class procedure PostDelayed(threadId: TCefThreadId; Delay: Integer; const param: T; const method: TCefTaskMethod);
    constructor Create(const param: T; const method: TCefTaskMethod); reintroduce;
  end;
{$ENDIF}

procedure CefLoadLib(const Cache: ustring = ''; const UserAgent: ustring = '';
  const ProductVersion: ustring = ''; const Locale: ustring = '';
  const LogFile: ustring = ''; LogSeverity: TCefLogSeverity = LOGSEVERITY_DISABLE;
  ExtraPluginPaths: TStrings = nil);
function CefGetObject(ptr: Pointer): TObject;
function CefStringAlloc(const str: ustring): TCefString;

function CefString(const str: ustring): TCefString; overload;
function CefString(const str: PCefString): ustring; overload;
function CefStringClearAndGet(var str: TCefString): ustring;
procedure CefStringFree(const str: PCefString);
function CefStringFreeAndGet(const str: PCefStringUserFree): ustring;
procedure CefStringSet(const str: PCefString; const value: ustring);
function CefBrowserCreate(windowInfo: PCefWindowInfo; popup: Boolean;
  handler: PCefHandler; const url: ustring): Boolean;
function CefRegisterScheme(const SchemeName, HostName: ustring;
  const handler: TCefSchemeHandlerClass): Boolean;
function CefRegisterExtension(const name, code: ustring;
  const Handler: ICefv8Handler): Boolean;
function CefCurrentlyOn(ThreadId: TCefThreadId): Boolean;
procedure CefPostTask(ThreadId: TCefThreadId; const task: ICefTask);
procedure CefPostDelayedTask(ThreadId: TCefThreadId; const task: ICefTask; delayMs: Integer);
function CefGetData(const i: ICefBase): Pointer;

var
  CefCache: ustring = '';
  CefUserAgent: ustring = '';
  CefProductVersion: ustring = '';
  CefLocale: ustring = '';
  CefLogFile: ustring = '';
  CefLogSeverity: TCefLogSeverity = LOGSEVERITY_DISABLE;

implementation
uses SysUtils;

const
  LIBCEF = 'libcef.dll';

var
// These functions set string values. If |copy| is true (1) the value will be
// copied instead of referenced. It is up to the user to properly manage
// the lifespan of references.

  cef_string_wide_set: function(const src: PWideChar; src_len: Cardinal;  output: PCefStringWide; copy: Integer): Integer; cdecl;
  cef_string_utf8_set: function(const src: PAnsiChar; src_len: Cardinal; output: PCefStringUtf8; copy: Integer): Integer; cdecl;
  cef_string_utf16_set: function(const src: PChar16; src_len: Cardinal; output: PCefStringUtf16; copy: Integer): Integer; cdecl;
  cef_string_set: function(const src: PCefChar; src_len: Cardinal; output: PCefString; copy: Integer): Integer; cdecl;

  // These functions clear string values. The structure itself is not freed.

  cef_string_wide_clear: procedure(str: PCefStringWide); cdecl;
  cef_string_utf8_clear: procedure(str: PCefStringUtf8); cdecl;
  cef_string_utf16_clear: procedure(str: PCefStringUtf16); cdecl;
  cef_string_clear: procedure(str: PCefString); cdecl;

  // These functions compare two string values with the same results as strcmp().

  cef_string_wide_cmp: function(const str1, str2: PCefStringWide): Integer; cdecl;
  cef_string_utf8_cmp: function(const str1, str2: PCefStringUtf8): Integer; cdecl;
  cef_string_utf16_cmp: function(const str1, str2: PCefStringUtf16): Integer; cdecl;

  // These functions convert between UTF-8, -16, and -32 strings. They are
  // potentially slow so unnecessary conversions should be avoided. The best
  // possible result will always be written to |output| with the boolean return
  // value indicating whether the conversion is 100% valid.

  cef_string_wide_to_utf8: function(const src: PWideChar; src_len: Cardinal; output: PCefStringUtf8): Integer; cdecl;
  cef_string_utf8_to_wide: function(const src: PAnsiChar; src_len: Cardinal; output: PCefStringWide): Integer; cdecl;

  cef_string_wide_to_utf16: function (const src: PWideChar; src_len: Cardinal; output: PCefStringUtf16): Integer; cdecl;
  cef_string_utf16_to_wide: function(const src: PChar16; src_len: Cardinal; output: PCefStringWide): Integer; cdecl;

  cef_string_utf8_to_utf16: function(const src: PAnsiChar; src_len: Cardinal; output: PCefStringUtf16): Integer; cdecl;
  cef_string_utf16_to_utf8: function(const src: PChar16; src_len: Cardinal; output: PCefStringUtf8): Integer; cdecl;

  cef_string_to_utf8: function(const src: PCefChar; src_len: Cardinal; output: PCefStringUtf8): Integer; cdecl;
  cef_string_from_utf8: function(const src: PAnsiChar; src_len: Cardinal; output: PCefString): Integer; cdecl;
  cef_string_to_utf16: function(const src: PCefChar; src_len: Cardinal; output: PCefStringUtf16): Integer; cdecl;
  cef_string_from_utf16: function(const src: PChar16; src_len: Cardinal; output: PCefString): Integer; cdecl;
  cef_string_to_wide: function(const src: PCefChar; src_len: Cardinal; output: PCefStringWide): Integer; cdecl;
  cef_string_from_wide: function(const src: PWideChar; src_len: Cardinal; output: PCefString): Integer; cdecl;

  // These functions convert an ASCII string, typically a hardcoded constant, to a
  // Wide/UTF16 string. Use instead of the UTF8 conversion routines if you know
  // the string is ASCII.

  cef_string_ascii_to_wide: function(const src: PAnsiChar; src_len: Cardinal; output: PCefStringWide): Integer; cdecl;
  cef_string_ascii_to_utf16: function(const src: PAnsiChar; src_len: Cardinal; output: PCefStringUtf16): Integer; cdecl;
  cef_string_from_ascii: function(const src: PAnsiChar; src_len: Cardinal; output: PCefString): Integer; cdecl;

  // These functions allocate a new string structure. They must be freed by
  // calling the associated free function.

  cef_string_userfree_wide_alloc: function(): PCefStringUserFreeWide; cdecl;
  cef_string_userfree_utf8_alloc: function(): PCefStringUserFreeUtf8; cdecl;
  cef_string_userfree_utf16_alloc: function(): PCefStringUserFreeUtf16; cdecl;
  cef_string_userfree_alloc: function(): PCefStringUserFree; cdecl;

  // These functions free the string structure allocated by the associated
  // alloc function. Any string contents will first be cleared.

  cef_string_userfree_wide_free: procedure(str: PCefStringUserFreeWide); cdecl;
  cef_string_userfree_utf8_free: procedure(str: PCefStringUserFreeUtf8); cdecl;
  cef_string_userfree_utf16_free: procedure(str: PCefStringUserFreeUtf16); cdecl;
  cef_string_userfree_free: procedure(str: PCefStringUserFree); cdecl;

// Convenience macros for copying values.
function cef_string_wide_copy(const src: PWideChar; src_len: Cardinal;  output: PCefStringWide): Integer; //inline;
begin
  Result := cef_string_wide_set(src, src_len, output, ord(True))
end;

function cef_string_utf8_copy(const src: PAnsiChar; src_len: Cardinal; output: PCefStringUtf8): Integer; //inline;
begin
  Result := cef_string_utf8_set(src, src_len, output, ord(True))
end;

function cef_string_utf16_copy(const src: PChar16; src_len: Cardinal; output: PCefStringUtf16): Integer; cdecl;
begin
  Result := cef_string_utf16_set(src, src_len, output, ord(True))
end;

function cef_string_copy(const src: PCefChar; src_len: Cardinal; output: PCefString): Integer; cdecl;
begin
  Result := cef_string_set(src, src_len, output, ord(True));
end;

var
  // Create a new browser window using the window parameters specified by
  // |windowInfo|. All values will be copied internally and the actual window will
  // be created on the UI thread.  The |popup| parameter should be true (1) if the
  // new window is a popup window. This function call will not block.
  cef_browser_create: function(windowInfo: PCefWindowInfo; popup: Integer; handler: PCefHandler; const url: TCefString): Integer; cdecl;

  // Create a new browser window using the window parameters specified by
  // |windowInfo|. The |popup| parameter should be true (1) if the new window is a
  // popup window. This function should only be called on the UI thread.
  cef_browser_create_sync: function(windowInfo: PCefWindowInfo; popup: Integer; handler: PCefHandler; const url: PCefString): PCefBrowser; cdecl;

  // Perform message loop processing. This function must be called on the main
  // application thread if cef_initialize() is called with a
  // CefSettings.multi_threaded_message_loop value of false (0).
  cef_do_message_loop_work: procedure(); cdecl;

  // This function should be called on the main application thread to initialize
  // CEF when the application is started.  A return value of true (1) indicates
  // that it succeeded and false (0) indicates that it failed.
  cef_initialize: function(const settings: PCefSettings;  const browser_defaults: PCefBrowserSettings): Integer; cdecl;

  // This function should be called on the main application thread to shut down
  // CEF before the application exits.
  cef_shutdown: procedure(); cdecl;

  // Allocate a new string map.
  cef_string_map_alloc: function(): TCefStringMap; cdecl;
  //function cef_string_map_size(map: TCefStringMap): Integer; cdecl;
  cef_string_map_size: function(map: TCefStringMap): Integer; cdecl;
  // Return the value assigned to the specified key.
  cef_string_map_find: function(map: TCefStringMap; const key: TCefString; var value: TCefString): Integer; cdecl;
  // Return the key at the specified zero-based string map index.
  cef_string_map_key: function(map: TCefStringMap; index: Integer; var key: TCefString): Integer; cdecl;
  // Return the value at the specified zero-based string map index.
  cef_string_map_value: function(map: TCefStringMap; index: Integer; var value: TCefString): Integer; cdecl;
  // Append a new key/value pair at the end of the string map.
  cef_string_map_append: function(map: TCefStringMap; const key, value: TCefString): Integer; cdecl;
  // Clear the string map.
  cef_string_map_clear: procedure(map: TCefStringMap); cdecl;
  // Free the string map.
  cef_string_map_free: procedure(map: TCefStringMap); cdecl;

  // Allocate a new string map.
  cef_string_list_alloc: function(): TCefStringList; cdecl;
  // Return the number of elements in the string list.
  cef_string_list_size: function(list: TCefStringList): Integer; cdecl;
  // Retrieve the value at the specified zero-based string list index. Returns
  // true (1) if the value was successfully retrieved.
  cef_string_list_value: function(list: TCefStringList; index: Integer; value: PCefString): Integer; cdecl;
  // Append a new value at the end of the string list.
  cef_string_list_append: procedure(list: TCefStringList; const value: TCefString); cdecl;
  // Clear the string list.
  cef_string_list_clear: procedure(list: TCefStringList); cdecl;
  // Free the string list.
  cef_string_list_free: procedure(list: TCefStringList); cdecl;
  // Creates a copy of an existing string list.
  cef_string_list_copy: function(list: TCefStringList): TCefStringList;


  // Register a new V8 extension with the specified JavaScript extension code and
  // handler. Functions implemented by the handler are prototyped using the
  // keyword 'native'. The calling of a native function is restricted to the scope
  // in which the prototype of the native function is defined. This function may
  // be called on any thread.
  //
  // Example JavaScript extension code:
  //
  //   // create the 'example' global object if it doesn't already exist.
  //   if (!example)
  //     example = {};
  //   // create the 'example.test' global object if it doesn't already exist.
  //   if (!example.test)
  //     example.test = {};
  //   (function() {
  //     // Define the function 'example.test.myfunction'.
  //     example.test.myfunction = function() {
  //       // Call CefV8Handler::Execute() with the function name 'MyFunction'
  //       // and no arguments.
  //       native function MyFunction();
  //       return MyFunction();
  //     };
  //     // Define the getter function for parameter 'example.test.myparam'.
  //     example.test.__defineGetter__('myparam', function() {
  //       // Call CefV8Handler::Execute() with the function name 'GetMyParam'
  //       // and no arguments.
  //       native function GetMyParam();
  //       return GetMyParam();
  //     });
  //     // Define the setter function for parameter 'example.test.myparam'.
  //     example.test.__defineSetter__('myparam', function(b) {
  //       // Call CefV8Handler::Execute() with the function name 'SetMyParam'
  //       // and a single argument.
  //       native function SetMyParam();
  //       if(b) SetMyParam(b);
  //     });
  //
  //     // Extension definitions can also contain normal JavaScript variables
  //     // and functions.
  //     var myint = 0;
  //     example.test.increment = function() {
  //       myint += 1;
  //       return myint;
  //     };
  //   })();
  //
  // Example usage in the page:
  //
  //   // Call the function.
  //   example.test.myfunction();
  //   // Set the parameter.
  //   example.test.myparam = value;
  //   // Get the parameter.
  //   value = example.test.myparam;
  //   // Call another function.
  //   example.test.increment();
  //
  cef_register_extension: function(const extension_name, javascript_code: TCefString; handler: PCefv8Handler): Integer; cdecl;

  // Register a custom scheme handler factory for the specified |scheme_name| and
  // |host_name|. All URLs beginning with scheme_name://host_name/ can be handled
  // by TCefSchemeHandler instances returned by the factory. Specify an NULL
  // |host_name| value to match all host names. This function may be called on any
  // thread.
  cef_register_scheme: function(const scheme_name, host_name: TCefString; factory: PCefSchemeHandlerFactory): Integer; cdecl;


  // CEF maintains multiple internal threads that are used for handling different
  // types of tasks. The UI thread creates the browser window and is used for all
  // interaction with the WebKit rendering engine and V8 JavaScript engine (The UI
  // thread will be the same as the main application thread if cef_initialize() is
  // called with a CefSettings.multi_threaded_message_loop value of false (0).)
  // The IO thread is used for handling schema and network requests. The FILE
  // thread is used for the application cache and other miscellaneous activities.
  // This function will return true (1) if called on the specified thread.
  cef_currently_on: function(threadId: TCefThreadId): Integer; cdecl;

  // Post a task for execution on the specified thread. This function may be
  // called on any thread.
  cef_post_task: function(threadId: TCefThreadId; task: PCefTask): Integer; cdecl;

  // Post a task for delayed execution on the specified thread. This function may
  // be called on any thread.
  cef_post_delayed_task: function(threadId: TCefThreadId;
      task: PCefTask; delay_ms: LongInt): Integer; cdecl;

  // Parse the specified |url| into its component parts. Returns false (0) if the
  // URL is NULL or invalid.
  cef_parse_url: function(const url: TCefString; parts: PCefUrlParts): Integer; cdecl;

  // Creates a URL from the specified |parts|, which must contain a non-NULL spec
  // or a non-NULL host and path (at a minimum), but not both. Returns false (0)
  // if |parts| isn't initialized as described.
  cef_create_url: function(parts: PCefUrlParts; url: PCefString): Integer; cdecl;

  // Create a new TCefRequest object.
  cef_request_create: function(): PCefRequest; cdecl;

  // Create a new TCefPostData object.
  cef_post_data_create: function(): PCefPostData; cdecl;

  // Create a new cef_post_data_Element object.
  cef_post_data_element_create: function(): PCefPostDataElement; cdecl;

  // Create a new TCefStreamReader object.
  cef_stream_reader_create_for_file: function(const fileName: TCefString): PCefStreamReader; cdecl;
  cef_stream_reader_create_for_data: function(data: Pointer; size: Cardinal): PCefStreamReader; cdecl;
  cef_stream_reader_create_for_handler: function(handler: PCefReadHandler): PCefStreamReader; cdecl;

  // Create a new TCefStreamWriter object.
  cef_stream_writer_create_for_file: function(const fileName: PCefString): PCefStreamWriter; cdecl;
  cef_stream_writer_create_for_handler: function(handler: PCefWriteHandler): PCefStreamWriter; cdecl;

  // Create a new TCefv8Value object of the specified type.  These functions
  // should only be called from within the JavaScript context -- either in a
  // TCefv8Handler::execute() callback or a TCefHandler.handle_jsbinding()
  cef_v8value_create_undefined: function(): PCefv8Value; cdecl;
  cef_v8value_create_null: function(): PCefv8Value; cdecl;
  cef_v8value_create_bool: function(value: Integer): PCefv8Value; cdecl;
  cef_v8value_create_int: function(value: Integer): PCefv8Value; cdecl;
  cef_v8value_create_double: function(value: Double): PCefv8Value; cdecl;
  cef_v8value_create_string: function(const value: TCefString): PCefv8Value; cdecl;
  cef_v8value_create_object: function(user_data: PCefBase): PCefv8Value; cdecl;
  cef_v8value_create_array: function(): PCefv8Value; cdecl;
  cef_v8value_create_function: function(const name: TCefString; handler: PCefv8Handler): PCefv8Value; cdecl;

  // Create a new cef_xml_reader_t object. The returned object's functions can
  // only be called from the thread that created the object.
  cef_xml_reader_create: function(stream: PCefStreamReader;
    encodingType: TCefXmlEncodingType; const URI: TCefString): PCefXmlReader; cdecl;

  // Create a new cef_zip_reader_t object. The returned object's functions can
  // only be called from the thread that created the object.
  cef_zip_reader_create: function(stream: PCefStreamReader): PCefZipReader; cdecl;

function CefGetData(const i: ICefBase): Pointer;
begin
  if i <> nil then
    Result := i.Wrap else
    Result := nil;
end;

function CefGetObject(ptr: Pointer): TObject;
begin
  Dec(PByte(ptr), SizeOf(Pointer));
  Result := TObject(PPointer(ptr)^);
end;

{ cef_base }

function cef_base_add_ref(self: PCefBase): Integer; stdcall;
begin
  Result := TCefBaseOwn(CefGetObject(self))._AddRef;
end;

function cef_base_release(self: PCefBase): Integer; stdcall;
begin
  Result := TCefBaseOwn(CefGetObject(self))._Release;
end;

function cef_base_get_refct(self: PCefBase): Integer; stdcall;
begin
  Result := TCefBaseOwn(CefGetObject(self)).FRefCount;
end;

{ cef_handler }

function cef_handler_handle_before_created(
      self: PCefHandler; parentBrowser: PCefBrowser;
      var windowInfo: TCefWindowInfo; popup: Integer;
      const popupFeatures: PCefPopupFeatures;
      var handler: PCefHandler; var url: TCefString;
      settings: PCefBrowserSettings): TCefRetval; stdcall;
var
  _handler: ICefBase;
  _url: ustring;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
  begin
    _handler := TCefBaseRef.UnWrap(handler);
    _url := CefString(@url);

    Result := doOnBeforeCreated(
      TCefBrowserRef.UnWrap(parentBrowser),
      windowInfo,
      popup <> 0,
      _handler,
      _url,
      settings^);

    CefStringSet(@url, _url);
    handler :=  CefGetData(_handler);
  end;
end;

function cef_handler_handle_after_created(self: PCefHandler;
  browser: PCefBrowser): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnAfterCreated(TCefBrowserRef.UnWrap(browser));
end;

function cef_handler_handle_address_change(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame; const url: TCefString): TCefRetval; stdcall;
begin
   with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnAddressChange(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      cefstring(@url))
end;

function cef_handler_handle_title_change(
    self: PCefHandler; browser: PCefBrowser;
    const title: PCefString): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnTitleChange(TCefBrowserRef.UnWrap(browser), CefString(title));
end;

function cef_handler_handle_before_browse(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame; request: PCefRequest;
    navType: TCefHandlerNavtype; isRedirect: Integer): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnBeforeBrowse(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      TCefRequestRef.UnWrap(request),
      navType,
      isRedirect <> 0)
end;

function cef_handler_handle_load_start(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame; isMainContent: Integer): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnLoadStart(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame), isMainContent <> 0);
end;

function cef_handler_handle_load_end(self: PCefHandler;
    browser: PCefBrowser; frame: PCefFrame; isMainContent, httpStatusCode: Integer): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnLoadEnd(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      isMainContent <> 0,
      httpStatusCode);
end;

function cef_handler_handle_load_error(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame; errorCode: TCefHandlerErrorcode;
    const failedUrl: PCefString; var errorText: TCefString): TCefRetval; stdcall;
var
  err: ustring;
begin
  err := CefString(@errorText);
  with TCefHandlerOwn(CefGetObject(self)) do
  begin
    Result := doOnLoadError(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      errorCode,
      CefString(failedUrl),
      err);
    if Result = RV_HANDLED then
      CefStringSet(@errorText, err);
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
  with TCefHandlerOwn(CefGetObject(self)) do
  begin
    _redirectUrl := CefString(@redirectUrl);
    _resourceStream := TCefStreamReaderRef.UnWrap(resourceStream);
    _mimeType := CefString(@mimeType);

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

      resourceStream := CefGetData(_resourceStream);
      mimeType := CefStringAlloc(_mimeType);
    end;
  end;
end;

function cef_handler_handle_protocol_execution(self: PCefHandler; browser: PCefBrowser;
  const url: TCefString; var allow_os_execution: Integer): TCefRetval; stdcall;
var
  allow: Boolean;
begin
  allow := allow_os_execution <> 0;
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnProtocolExecution(
      TCefBrowserRef.UnWrap(browser),
      CefString(@url), allow);
  if allow then
    allow_os_execution := 1 else
    allow_os_execution := 0;
end;

function cef_handler_handle_download_response(self: PCefHandler;
  browser: PCefBrowser; const mimeType, fileName: PCefString; contentLength: int64;
  var handler: PCefDownloadHandler): TCefRetval; stdcall;
var
  _handler: ICefDownloadHandler;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnDownloadResponse(
      TCefBrowserRef.UnWrap(browser),
      CefString(mimeType), CefString(fileName), contentLength, _handler);
  handler := CefGetData(_handler);
end;

function cef_handle_authentication_request(
  self: PCefHandler; browser: PCefBrowser; isProxy: Integer;
  const host: PCefString; const realm: PCefString; const scheme: PCefString;
  username: PCefString; password: PCefString): TCefRetval; stdcall;
var
  _username, _password: ustring;
begin
  _username := CefString(username);
  _password := CefString(password);
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnAuthenticationRequest(
      TCefBrowserRef.UnWrap(browser), isProxy <> 0,
      CefString(host), CefString(realm), CefString(scheme),
      _username, _password
    );
  if Result = RV_HANDLED then
  begin
    CefStringSet(username, _username);
    CefStringSet(password, _password);
  end;
end;

function cef_handler_handle_before_menu(
    self: PCefHandler; browser: PCefBrowser;
    const menuInfo: PCefHandlerMenuInfo): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
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
  str := CefString(@label_);
  with TCefHandlerOwn(CefGetObject(self)) do
  begin
    Result := doOnGetMenuLabel(
      TCefBrowserRef.UnWrap(browser),
      menuId,
      str);
    if Result = RV_HANDLED then
      CefStringSet(@label_, str);
  end;
end;

function cef_handler_handle_menu_action(
    self: PCefHandler; browser: PCefBrowser;
    menuId: TCefHandlerMenuId): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnMenuAction(
      TCefBrowserRef.UnWrap(browser),
      menuId);
end;

function cef_handler_handle_print_options(self: PCefHandler; browser: PCefBrowser;
        printOptions: PCefPrintOptions): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnPrintOptions(
      TCefBrowserRef.UnWrap(browser), printOptions);
end;

function cef_handler_handle_print_header_footer(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame; printInfo: PCefPrintInfo;
    url, title: PCefString; currentPage, maxPages: Integer;
    var topLeft, topCenter, topRight, bottomLeft, bottomCenter,
    bottomRight: TCefString): TCefRetval; stdcall;
var
  _topLeft, _topCenter, _topRight, _bottomLeft, _bottomCenter, _bottomRight: ustring;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
  begin
    Result := doOnPrintHeaderFooter(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      printInfo, CefString(url), CefString(title), currentPage, maxPages,
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
    const message: PCefString): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnJsAlert(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      CefString(message));
end;

function cef_handler_handle_jsconfirm(
    self: PCefHandler; browser: PCefBrowser;
    frame: PCefFrame; const message: PCefString;
    var retval: Integer): TCefRetval; stdcall;
var
  ret: Boolean;
begin
  ret := retval <> 0;
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnJsConfirm(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      CefString(message), ret);
  if Result = RV_HANDLED then
    retval := Ord(ret);

end;

function cef_handler_handle_jsprompt(self: PCefHandler;
    browser: PCefBrowser; frame: PCefFrame;
    const message, defaultValue: PCefString; var retval: Integer;
    var return: TCefString): TCefRetval; stdcall;
var
  ret: Boolean;
  str: ustring;
begin
  ret := retval <> 0;
  with TCefHandlerOwn(CefGetObject(self)) do
  begin
    Result := doOnJsPrompt(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      CefString(message), CefString(defaultValue), ret, str);
    if Result = RV_HANDLED then
    begin
      retval := Ord(ret);
      return := CefStringAlloc(str)
    end;
  end;
end;

function cef_handler_handle_jsbinding(self: PCefHandler; browser: PCefBrowser;
      frame: PCefFrame; obj: PCefv8Value): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnJsBinding(
      TCefBrowserRef.UnWrap(browser),
      TCefFrameRef.UnWrap(frame),
      TCefv8ValueRef.UnWrap(obj));
end;

function cef_handler_handle_before_window_close(
    self: PCefHandler; browser: PCefBrowser): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnBeforeWindowClose(
      TCefBrowserRef.UnWrap(browser))
end;

function cef_handler_handle_take_focus(
    self: PCefHandler; browser: PCefBrowser;
    reverse: Integer): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnTakeFocus(
      TCefBrowserRef.UnWrap(browser), reverse);
end;

function cef_handler_handle_set_focus(
    self: PCefHandler; browser: PCefBrowser;
    isWidget: Integer): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnSetFocus(
      TCefBrowserRef.UnWrap(browser), isWidget <> 0);
end;

function cef_handler_handle_key_event(
    self: PCefHandler; browser: PCefBrowser;
    event: TCefHandlerKeyEventType; code, modifiers,
    isSystemKey: Integer): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnKeyEvent(
      TCefBrowserRef.UnWrap(browser),
      event, code, modifiers, isSystemKey <> 0);
end;

function cef_handler_handle_tooltip(self: PCefHandler;
        browser: PCefBrowser; var text: TCefString): TCefRetval; stdcall;
var
  t: ustring;
begin
  t := CefStringClearAndGet(text);
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnTooltip(
      TCefBrowserRef.UnWrap(browser), t);
  text := CefStringAlloc(t);
end;

function cef_handler_handle_status(self: PCefHandler; browser: PCefBrowser;
  value: PCefString; type_: TCefHandlerStatusType): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnStatus(TCefBrowserRef.UnWrap(browser), CefString(value), type_);
end;

function cef_handler_handle_console_message(self: PCefHandler; browser: PCefBrowser;
  const message, source: PCefString; line: Integer): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnConsoleMessage(TCefBrowserRef.UnWrap(browser), CefString(message), CefString(source), line);
end;

function cef_handler_handle_find_result(self: PCefHandler; browser: PCefBrowser;
  identifier, count: Integer; const selectionRect: PCefRect;
  activeMatchOrdinal, finalUpdate: Integer): TCefRetval; stdcall;
begin
  with TCefHandlerOwn(CefGetObject(self)) do
    Result := doOnFindResult(
      TCefBrowserRef.UnWrap(browser),
        count, selectionRect, identifier <> 0, activeMatchOrdinal <> 0, finalUpdate <> 0);
end;

{  cef_stream_reader }

function cef_stream_reader_read(self: PCefStreamReader; ptr: Pointer; size, n: Cardinal): Cardinal; stdcall;
begin
  with TCefStreamReaderOwn(CefGetObject(self)) do
    Result := Read(ptr, size, n);
end;

function cef_stream_reader_seek(self: PCefStreamReader; offset: LongInt; whence: Integer): Integer; stdcall;
begin
  with TCefStreamReaderOwn(CefGetObject(self)) do
    Result := Seek(offset, whence);
end;

function cef_stream_reader_tell(self: PCefStreamReader): LongInt; stdcall;
begin
  with TCefStreamReaderOwn(CefGetObject(self)) do
    Result := Tell;
end;

function cef_stream_reader_eof(self: PCefStreamReader): Integer; stdcall;
begin
  with TCefStreamReaderOwn(CefGetObject(self)) do
    Result := Ord(eof);
end;

{ cef_post_data_element }

procedure cef_post_data_element_set_to_empty(self: PCefPostDataElement); stdcall;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    SetToEmpty;
end;

procedure cef_post_data_element_set_to_file(self: PCefPostDataElement; const fileName: PCefString); stdcall;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    SetToFile(CefString(fileName));
end;

procedure cef_post_data_element_set_to_bytes(self: PCefPostDataElement; size: Cardinal; const bytes: Pointer); stdcall;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    SetToBytes(size, bytes);
end;

function cef_post_data_element_get_type(self: PCefPostDataElement): TCefPostDataElementType; stdcall;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    Result := GetType;
end;

function cef_post_data_element_get_file(self: PCefPostDataElement): TCefString; stdcall;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    Result := CefStringAlloc(GetFile);
end;

function cef_post_data_element_get_bytes_count(self: PCefPostDataElement): Cardinal; stdcall;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    Result := GetBytesCount;
end;

function cef_post_data_element_get_bytes(self: PCefPostDataElement; size: Cardinal; bytes: Pointer): Cardinal; stdcall;
begin
  with TCefPostDataElementOwn(CefGetObject(self)) do
    Result := GetBytes(size, bytes)
end;

{ cef_scheme_handler_factory}

function cef_scheme_handler_factory_create(self: PCefSchemeHandlerFactory): PCefSchemeHandler; stdcall;
begin
  with TCefSchemeHandlerFactoryOwn(CefGetObject(self)) do
    Result := New.Wrap;
end;

{ cef_scheme_handler }

function cef_scheme_handler_process_request(self: PCefSchemeHandler;
  request: PCefRequest; var mime_type: TCefString;
  var response_length: Integer): Integer; stdcall;
var
  _mime_type: ustring;
begin
  with TCefSchemeHandlerOwn(CefGetObject(self)) do
    Result := Ord(ProcessRequest(TCefRequestRef.UnWrap(request),
      _mime_type, response_length));
  if _mime_type <> '' then
    mime_type := CefStringAlloc(_mime_type);
end;

procedure cef_scheme_handler_cancel(self: PCefSchemeHandler); stdcall;
begin
  with TCefSchemeHandlerOwn(CefGetObject(self)) do
    Cancel;
end;

function cef_scheme_handler_read_response(self: PCefSchemeHandler; data_out: Pointer; bytes_to_read: Integer; var bytes_read: Integer): Integer; stdcall;
begin
  with TCefSchemeHandlerOwn(CefGetObject(self)) do
    Result := Ord(ReadResponse(data_out, bytes_to_read, bytes_read));
end;

{ cef_v8_handler }

function cef_v8_handler_execute(self: PCefv8Handler;
  const name: PCefString; obj: PCefv8Value; argumentCount: Cardinal;
  const arguments: PPCefV8Value; var retval: PCefV8Value;
  var exception: TCefString): Integer; stdcall;
var
  args: TCefv8ValueArray;
  i: Integer;
  ret: ICefv8Value;
  exc: ustring;
begin
  SetLength(args, argumentCount);
  for i := 0 to argumentCount - 1 do
    args[i] := TCefv8ValueRef.UnWrap(arguments[i]);

  Result := Ord(TCefv8HandlerOwn(CefGetObject(self)).Execute(
    CefString(name), TCefv8ValueRef.UnWrap(obj), args, ret, exc));
  retval := CefGetData(ret);
  exception := CefStringAlloc(exc);
end;

{ cef_task }

procedure cef_task_execute(self: PCefTask; threadId: TCefThreadId); stdcall;
begin
  TCefTaskOwn(CefGetObject(self)).Execute(threadId);
end;

{ cef_download_handler }

function cef_download_handler_received_data(self: PCefDownloadHandler; data: Pointer; data_size: Integer): Integer; stdcall;
begin
  Result := TCefDownloadHandlerOwn(CefGetObject(self)).ReceivedData(data, data_size);
end;

procedure cef_download_handler_complete(self: PCefDownloadHandler); stdcall;
begin
  TCefDownloadHandlerOwn(CefGetObject(self)).Complete;
end;

{ TCefBaseOwn }

constructor TCefBaseOwn.CreateData(size: Cardinal);
begin
  InitializeCriticalSection(FCriticaSection);
  GetMem(FData, size + SizeOf(Pointer));
  PPointer(FData)^ := Self;
  inc(PByte(FData), SizeOf(Pointer));
  FillChar(FData^, size, 0);
  PCefBase(FData)^.size := size;
  PCefBase(FData)^.add_ref := @cef_base_add_ref;
  PCefBase(FData)^.release := @cef_base_release;
  PCefBase(FData)^.get_refct := @cef_base_get_refct;
end;

destructor TCefBaseOwn.Destroy;
begin
  Dec(PByte(FData), SizeOf(Pointer));
  FreeMem(FData);
  DeleteCriticalSection(FCriticaSection);
  inherited;
end;

function TCefBaseOwn.Wrap: Pointer;
begin
  Result := FData;
  if Assigned(PCefBase(FData)^.add_ref) then
    PCefBase(FData)^.add_ref(PCefBase(FData));
end;

procedure TCefBaseOwn.Lock;
begin
  EnterCriticalSection(FCriticaSection);
end;

procedure TCefBaseOwn.Unlock;
begin
  LeaveCriticalSection(FCriticaSection);
end;

{ TCefHandlerOwn }

constructor TCefHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefHandler));
  with PCefHandler(FData)^ do
  begin
    handle_before_created := @cef_handler_handle_before_created;
    handle_after_created := @cef_handler_handle_after_created;
    handle_address_change := @cef_handler_handle_address_change;
    handle_title_change := @cef_handler_handle_title_change;
    handle_before_browse := @cef_handler_handle_before_browse;
    handle_load_start := @cef_handler_handle_load_start;
    handle_load_end := @cef_handler_handle_load_end;
    handle_load_error := @cef_handler_handle_load_error;
    handle_before_resource_load := @cef_handler_handle_before_resource_load;
    handle_protocol_execution := @cef_handler_handle_protocol_execution;
    handle_download_response := @cef_handler_handle_download_response;
    handle_authentication_request := @cef_handle_authentication_request;
    handle_before_menu := @cef_handler_handle_before_menu;
    handle_get_menu_label := @cef_handler_handle_get_menu_label;
    handle_menu_action := @cef_handler_handle_menu_action;
    handle_print_options := @cef_handler_handle_print_options;
    handle_print_header_footer := @cef_handler_handle_print_header_footer;
    handle_jsalert := @cef_handler_handle_jsalert;
    handle_jsconfirm := @cef_handler_handle_jsconfirm;
    handle_jsprompt := @cef_handler_handle_jsprompt;
    handle_jsbinding := @cef_handler_handle_jsbinding;
    handle_before_window_close := @cef_handler_handle_before_window_close;
    handle_take_focus := @cef_handler_handle_take_focus;
    handle_set_focus := @cef_handler_handle_set_focus;
    handle_key_event := @cef_handler_handle_key_event;
    handle_tooltip := @cef_handler_handle_tooltip;
    handle_status := @cef_handler_handle_status;
    handle_console_message := @cef_handler_handle_console_message;
    handle_find_result := @cef_handler_handle_find_result;
  end;
end;

function TCefHandlerOwn.doOnAddressChange(const browser: ICefBrowser;
  const frame: ICefFrame; const url: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnAfterCreated(const browser: ICefBrowser): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnAuthenticationRequest(const browser: ICefBrowser;
  isProxy: Boolean; const host, realm, scheme: ustring; var username,
  password: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnBeforeBrowse(const browser: ICefBrowser;
  const frame: ICefFrame; const request: ICefRequest; navType: TCefHandlerNavtype;
  isRedirect: boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnBeforeCreated(const parentBrowser: ICefBrowser;
  var windowInfo: TCefWindowInfo; popup: Boolean; var handler: ICefBase;
  var url: ustring; var settings: TCefBrowserSettings): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnBeforeMenu(const browser: ICefBrowser;
  const menuInfo: PCefHandlerMenuInfo): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnBeforeResourceLoad(const browser: ICefBrowser;
  const request: ICefRequest; var redirectUrl: ustring;
  var resourceStream: ICefStreamReader; var mimeType: ustring;
  loadFlags: Integer): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnBeforeWindowClose(
  const browser: ICefBrowser): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnConsoleMessage(const browser: ICefBrowser;
  const message, source: ustring; line: Integer): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnDownloadResponse(const browser: ICefBrowser;
  const mimeType, fileName: ustring; contentLength: int64;
  var handler: ICefDownloadHandler): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnFindResult(const browser: ICefBrowser; count: Integer;
  selectionRect: PCefRect; identifier, activeMatchOrdinal, finalUpdate: Boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnGetMenuLabel(const browser: ICefBrowser;
  menuId: TCefHandlerMenuId; var caption: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnJsAlert(const browser: ICefBrowser;
  const frame: ICefFrame; const message: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnJsBinding(const browser: ICefBrowser;
  const frame: ICefFrame; const obj: ICefv8Value): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnJsConfirm(const browser: ICefBrowser;
  const frame: ICefFrame; const message: ustring;
  var retval: Boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnJsPrompt(const browser: ICefBrowser;
  const frame: ICefFrame; const message, defaultValue: ustring;
  var retval: Boolean; var return: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnKeyEvent(const browser: ICefBrowser;
  event: TCefHandlerKeyEventType; code, modifiers: Integer;
  isSystemKey: Boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnLoadEnd(const browser: ICefBrowser;
  const frame: ICefFrame; isMainContent: Boolean; httpStatusCode: Integer): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnLoadError(const browser: ICefBrowser;
  const frame: ICefFrame; errorCode: TCefHandlerErrorcode; const failedUrl: ustring;
  var errorText: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnLoadStart(const browser: ICefBrowser;
  const frame: ICefFrame; isMainContent: Boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnMenuAction(const browser: ICefBrowser;
  menuId: TCefHandlerMenuId): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnPrintHeaderFooter(const browser: ICefBrowser;
  const frame: ICefFrame; printInfo: PCefPrintInfo; const url, title: ustring;
  currentPage, maxPages: Integer; var topLeft, topCenter, topRight, bottomLeft,
  bottomCenter, bottomRight: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnPrintOptions(const browser: ICefBrowser;
  printOptions: PCefPrintOptions): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnProtocolExecution(const browser: ICefBrowser;
  const url: ustring; var AllowOsExecution: Boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnSetFocus(const browser: ICefBrowser;
  isWidget: Boolean): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnStatus(const browser: ICefBrowser;
  const value: ustring; StatusType: TCefHandlerStatusType): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnTakeFocus(const browser: ICefBrowser;
  reverse: Integer): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnTitleChange(const browser: ICefBrowser;
  const title: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

function TCefHandlerOwn.doOnTooltip(const browser: ICefBrowser;
  var text: ustring): TCefRetval;
begin
  Result := RV_CONTINUE;
end;

{ TCefBaseRef }

constructor TCefBaseRef.Create(data: Pointer);
begin
  FData := data;
  if Assigned(PCefBase(FData)^.add_ref) then
    PCefBase(FData)^.add_ref(PCefBase(FData));
end;

destructor TCefBaseRef.Destroy;
begin
  if Assigned(PCefBase(FData)^.release) then
    PCefBase(FData)^.release(PCefBase(FData));
  inherited;
end;

class function TCefBaseRef.UnWrap(data: Pointer): ICefBase;
begin
  if data <> nil then
  begin
    Result := Create(data);
    if Assigned(PCefBase(Data)^.release) then
      PCefBase(Data)^.release(PCefBase(Data));
  end else
    Result := nil;
end;

function TCefBaseRef.Wrap: Pointer;
begin
  Result := FData;
  if Assigned(PCefBase(FData)^.add_ref) then
    PCefBase(FData)^.add_ref(PCefBase(FData));
end;

{ TCefBrowserRef }

function TCefBrowserRef.CanGoBack: Boolean;
begin
  Result := PCefBrowser(FData)^.can_go_back(PCefBrowser(FData)) <> 0;
end;

function TCefBrowserRef.CanGoForward: Boolean;
begin
  Result := PCefBrowser(FData)^.can_go_forward(PCefBrowser(FData)) <> 0;
end;

procedure TCefBrowserRef.CloseDevTools;
begin
  PCefBrowser(FData)^.close_dev_tools(PCefBrowser(FData));
end;

procedure TCefBrowserRef.Find(const searchText: ustring; identifier,
  forward, matchCase, findNext: Boolean);
begin
  PCefBrowser(FData)^.find(PCefBrowser(FData), Ord(identifier), CefString(searchText),
    Ord(forward), Ord(matchCase), Ord(findNext));
end;

function TCefBrowserRef.GetFocusedFrame: ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefBrowser(FData)^.get_focused_frame(PCefBrowser(FData)))
end;

function TCefBrowserRef.GetFrame(const name: ustring): ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefBrowser(FData)^.get_frame(PCefBrowser(FData), CefString(name)));
end;

procedure TCefBrowserRef.GetFrameNames(const names: TStrings);
var
  list: TCefStringList;
  i: Integer;
  str: TCefString;
begin
  list := cef_string_list_alloc;
  try
    PCefBrowser(FData)^.get_frame_names(PCefBrowser(FData), list);
    FillChar(str, SizeOf(str), 0);
    for i := 0 to cef_string_list_size(list) - 1 do
    begin
      cef_string_list_value(list, i, @str);
      names.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

function TCefBrowserRef.GetHandler: ICefBase;
begin
  Result := TInterfacedObject(CefGetObject(PCefBrowser(FData)^.get_handler(PCefBrowser(FData)))) as ICefBase;
end;

function TCefBrowserRef.GetMainFrame: ICefFrame;
begin
  Result := TCefFrameRef.UnWrap(PCefBrowser(FData)^.get_main_frame(PCefBrowser(FData)))
end;

function TCefBrowserRef.GetWindowHandle: CefWindowHandle;
begin
  Result := PCefBrowser(FData)^.get_window_handle(PCefBrowser(FData));
end;

function TCefBrowserRef.GetZoomLevel: Double;
begin
  Result := PCefBrowser(FData)^.get_zoom_level(PCefBrowser(FData))
end;

procedure TCefBrowserRef.GoBack;
begin
  PCefBrowser(FData)^.go_back(PCefBrowser(FData));
end;

procedure TCefBrowserRef.GoForward;
begin
  PCefBrowser(FData)^.go_forward(PCefBrowser(FData));
end;

function TCefBrowserRef.IsPopup: Boolean;
begin
  Result := PCefBrowser(FData)^.is_popup(PCefBrowser(FData)) <> 0;
end;

procedure TCefBrowserRef.Reload;
begin
  PCefBrowser(FData)^.reload(PCefBrowser(FData));
end;

procedure TCefBrowserRef.ReloadIgnoreCache;
begin
  PCefBrowser(FData)^.reload_ignore_cache(PCefBrowser(FData));
end;

procedure TCefBrowserRef.SetFocus(enable: Boolean);
begin
  PCefBrowser(FData)^.set_focus(PCefBrowser(FData), ord(enable));
end;

procedure TCefBrowserRef.SetZoomLevel(zoomLevel: Double);
begin
  PCefBrowser(FData)^.set_zoom_level(PCefBrowser(FData), zoomlevel);
end;

procedure TCefBrowserRef.ShowDevTools;
begin
  PCefBrowser(FData)^.show_dev_tools(PCefBrowser(FData));
end;

procedure TCefBrowserRef.StopFinding(ClearSelection: Boolean);
begin
  PCefBrowser(FData)^.stop_finding(PCefBrowser(FData), Ord(ClearSelection));
end;

procedure TCefBrowserRef.StopLoad;
begin
  PCefBrowser(FData)^.stop_load(PCefBrowser(FData));
end;

class function TCefBrowserRef.UnWrap(data: Pointer): ICefBrowser;
begin
  if data <> nil then
  begin
    Result := Create(data);
    if Assigned(PCefBase(Data)^.release) then
      PCefBase(Data)^.release(PCefBase(Data));
  end else
    Result := nil;
end;

{ TCefFrameRef }

procedure TCefFrameRef.Copy;
begin
  PCefFrame(FData)^.copy(PCefFrame(FData));
end;

procedure TCefFrameRef.Cut;
begin
  PCefFrame(FData)^.cut(PCefFrame(FData));
end;

procedure TCefFrameRef.Del;
begin
  PCefFrame(FData)^.del(PCefFrame(FData));
end;

procedure TCefFrameRef.ExecuteJavaScript(const jsCode, scriptUrl: ustring;
  startLine: Integer);
begin
  PCefFrame(FData)^.execute_java_script(PCefFrame(FData), CefString(jsCode), CefString(scriptUrl), startline);
end;

function TCefFrameRef.GetName: ustring;
begin
  Result := CefStringFreeAndGet(PCefFrame(FData)^.get_name(PCefFrame(FData)));
end;

function TCefFrameRef.GetSource: ustring;
begin
  Result := CefStringFreeAndGet(PCefFrame(FData)^.get_source(PCefFrame(FData)));
end;

function TCefFrameRef.getText: ustring;
begin
  Result := CefStringFreeAndGet(PCefFrame(FData)^.get_text(PCefFrame(FData)));
end;

function TCefFrameRef.GetUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefFrame(FData)^.get_url(PCefFrame(FData)));
end;

function TCefFrameRef.IsFocused: Boolean;
begin
  Result := PCefFrame(FData)^.is_focused(PCefFrame(FData)) <> 0;
end;

function TCefFrameRef.IsMain: Boolean;
begin
  Result := PCefFrame(FData)^.is_main(PCefFrame(FData)) <> 0;
end;

procedure TCefFrameRef.LoadFile(const filename, url: ustring);
var
  strm: ICefStreamReader;
begin
  strm := TCefStreamReaderRef.Create(cef_stream_reader_create_for_file(CefString(filename)));
  PCefFrame(FData)^.load_stream(PCefFrame(FData), strm.Wrap, CefString(url));
end;

procedure TCefFrameRef.LoadRequest(const request: ICefRequest);
begin
  PCefFrame(FData)^.load_request(PCefFrame(FData), request.Wrap);
end;

procedure TCefFrameRef.LoadStream(const stream: TStream; const url: ustring);
var
  strm: ICefStreamReader;
begin
  strm := TCefStreamReaderOwn.Create(stream, False);
  PCefFrame(FData)^.load_stream(PCefFrame(FData), strm.Wrap, CefString(url));
end;

procedure TCefFrameRef.LoadString(const str, url: ustring);
begin
  PCefFrame(FData)^.load_string(PCefFrame(FData), CefString(str), CefString(url));
end;

procedure TCefFrameRef.LoadUrl(const url: ustring);
begin
  PCefFrame(FData)^.load_url(PCefFrame(FData), CefString(url));
end;

procedure TCefFrameRef.Paste;
begin
  PCefFrame(FData)^.paste(PCefFrame(FData));
end;

procedure TCefFrameRef.Print;
begin
  PCefFrame(FData)^.print(PCefFrame(FData));
end;

procedure TCefFrameRef.Redo;
begin
  PCefFrame(FData)^.redo(PCefFrame(FData));
end;

procedure TCefFrameRef.SelectAll;
begin
  PCefFrame(FData)^.select_all(PCefFrame(FData));
end;

procedure TCefFrameRef.Undo;
begin
  PCefFrame(FData)^.undo(PCefFrame(FData));
end;

procedure TCefFrameRef.ViewSource;
begin
  PCefFrame(FData)^.view_source(PCefFrame(FData));
end;

class function TCefFrameRef.UnWrap(data: Pointer): ICefFrame;
begin
  if data <> nil then
  begin
    Result := Create(data);
    if Assigned(PCefBase(Data)^.release) then
      PCefBase(Data)^.release(PCefBase(Data));
  end else
    Result := nil;
end;

{ TCefStreamReaderOwn }

constructor TCefStreamReaderOwn.Create(Stream: TStream; Owned: Boolean);
begin
  inherited CreateData(SizeOf(TCefStreamReader));
  FStream := stream;
  FOwned := Owned;
  with PCefStreamReader(FData)^ do
  begin
    read := @cef_stream_reader_read;
    seek := @cef_stream_reader_seek;
    tell := @cef_stream_reader_tell;
    eof := @cef_stream_reader_eof;
  end;
end;

constructor TCefStreamReaderOwn.Create(const filename: string);
begin
  Create(TFileStream.Create(filename, fmOpenRead or fmShareDenyWrite), True);
end;

destructor TCefStreamReaderOwn.Destroy;
begin
  if FOwned then
    FStream.Free;
  inherited;
end;

function TCefStreamReaderOwn.Eof: Boolean;
begin
  Lock;
  try
    Result := FStream.Position = FStream.size;
  finally
    Unlock;
  end;
end;

function TCefStreamReaderOwn.Read(ptr: Pointer; size, n: Cardinal): Cardinal;
begin
  Lock;
  try
    result := Cardinal(FStream.Read(ptr^, n * size)) div size;
  finally
    Unlock;
  end;
end;

function TCefStreamReaderOwn.Seek(offset, whence: Integer): Integer;
begin
  Lock;
  try
    Result := FStream.Seek(offset, whence);
  finally
    Unlock;
  end;
end;

function TCefStreamReaderOwn.Tell: LongInt;
begin
  Lock;
  try
    Result := FStream.Position;
  finally
    Unlock;
  end;
end;

{ TCefPostDataRef }

function TCefPostDataRef.AddElement(
  const element: ICefPostDataElement): Integer;
begin
  Result := PCefPostData(FData)^.add_element(PCefPostData(FData), element.Wrap);
end;

function TCefPostDataRef.GetCount: Cardinal;
begin
  Result := PCefPostData(FData)^.get_element_count(PCefPostData(FData))
end;

function TCefPostDataRef.GetElement(Index: Integer): ICefPostDataElement;
begin
  Result := TCefPostDataElementRef.UnWrap(PCefPostData(FData)^.get_elements(PCefPostData(FData), Index))
end;

function TCefPostDataRef.RemoveElement(
  const element: ICefPostDataElement): Integer;
begin
  Result := PCefPostData(FData)^.remove_element(PCefPostData(FData), element.Wrap);
end;

procedure TCefPostDataRef.RemoveElements;
begin
  PCefPostData(FData)^.remove_elements(PCefPostData(FData));
end;

class function TCefPostDataRef.UnWrap(data: Pointer): ICefPostData;
begin
  if data <> nil then
  begin
    Result := Create(data);
    if Assigned(PCefBase(Data)^.release) then
      PCefBase(Data)^.release(PCefBase(Data));
  end else
    Result := nil;
end;

{ TCefPostDataElementRef }

function TCefPostDataElementRef.GetBytes(size: Cardinal;
  bytes: Pointer): Cardinal;
begin
  Result := PCefPostDataElement(FData)^.get_bytes(PCefPostDataElement(FData), size, bytes);
end;

function TCefPostDataElementRef.GetBytesCount: Cardinal;
begin
  Result := PCefPostDataElement(FData)^.get_bytes_count(PCefPostDataElement(FData));
end;

function TCefPostDataElementRef.GetFile: ustring;
begin
  Result := CefStringFreeAndGet(PCefPostDataElement(FData)^.get_file(PCefPostDataElement(FData)));
end;

function TCefPostDataElementRef.GetType: TCefPostDataElementType;
begin
  Result := PCefPostDataElement(FData)^.get_type(PCefPostDataElement(FData));
end;

procedure TCefPostDataElementRef.SetToBytes(size: Cardinal; bytes: Pointer);
begin
  PCefPostDataElement(FData)^.set_to_bytes(PCefPostDataElement(FData), size, bytes);
end;

procedure TCefPostDataElementRef.SetToEmpty;
begin
  PCefPostDataElement(FData)^.set_to_empty(PCefPostDataElement(FData));
end;

procedure TCefPostDataElementRef.SetToFile(const fileName: ustring);
begin
  PCefPostDataElement(FData)^.set_to_file(PCefPostDataElement(FData), CefString(fileName));
end;

class function TCefPostDataElementRef.UnWrap(data: Pointer): ICefPostDataElement;
begin
  if data <> nil then
  begin
    Result := Create(data);
    if Assigned(PCefBase(Data)^.release) then
      PCefBase(Data)^.release(PCefBase(Data));
  end else
    Result := nil;
end;

{ TCefPostDataElementOwn }

procedure TCefPostDataElementOwn.Clear;
begin
  case FDataType of
    PDE_TYPE_BYTES:
      if (FValueByte <> nil) then
      begin
        FreeMem(FValueByte);
        FValueByte := nil;
      end;
    PDE_TYPE_FILE:
      CefStringFree(@FValueStr)
  end;
  FDataType := PDE_TYPE_EMPTY;
  FSize := 0;
end;

constructor TCefPostDataElementOwn.Create;
begin
  inherited CreateData(SizeOf(TCefPostDataElement));
  FDataType := PDE_TYPE_EMPTY;
  FValueByte := nil;
  FillChar(FValueStr, SizeOf(FValueStr), 0);
  FSize := 0;
  with PCefPostDataElement(FData)^ do
  begin
    set_to_empty := @cef_post_data_element_set_to_empty;
    set_to_file := @cef_post_data_element_set_to_file;
    set_to_bytes := @cef_post_data_element_set_to_bytes;
    get_type := @cef_post_data_element_get_type;
    get_file := @cef_post_data_element_get_file;
    get_bytes_count := @cef_post_data_element_get_bytes_count;
    get_bytes := @cef_post_data_element_get_bytes;
  end;
end;

function TCefPostDataElementOwn.GetBytes(size: Cardinal;
  bytes: Pointer): Cardinal;
begin
  Lock;
  try
    if (FDataType = PDE_TYPE_BYTES) and (FValueByte <> nil) then
    begin
      if size > FSize then
        Result := FSize else
        Result := size;
      Move(FValueByte^, bytes^, Result);
    end else
      Result := 0;
  finally
    Unlock;
  end;
end;

function TCefPostDataElementOwn.GetBytesCount: Cardinal;
begin
  if (FDataType = PDE_TYPE_BYTES) then
    Result := FSize else
    Result := 0;
end;

function TCefPostDataElementOwn.GetFile: ustring;
begin
  Lock;
  try
    if (FDataType = PDE_TYPE_FILE) then
      Result := CefString(@FValueStr) else
      Result := '';
  finally
    Unlock;
  end;
end;

function TCefPostDataElementOwn.GetType: TCefPostDataElementType;
begin
  Result := FDataType;
end;

procedure TCefPostDataElementOwn.SetToBytes(size: Cardinal; bytes: Pointer);
begin
  Lock;
  try
    Clear;
    if (size > 0) and (bytes <> nil) then
    begin
      GetMem(FValueByte, size);
      Move(bytes^, FValueByte, size);
      FSize := size;
    end else
    begin
      FValueByte := nil;
      FSize := 0;
    end;
    FDataType := PDE_TYPE_BYTES;
  finally
    Unlock;
  end;
end;

procedure TCefPostDataElementOwn.SetToEmpty;
begin
  Lock;
  try
    Clear;
  finally
    Unlock;
  end;
end;

procedure TCefPostDataElementOwn.SetToFile(const fileName: ustring);
begin
  Lock;
  try
    Clear;
    FSize := 0;
    FValueStr := CefStringAlloc(fileName);
    FDataType := PDE_TYPE_FILE;
  finally
    Unlock;
  end;
end;

{ TCefRequestRef }

procedure TCefRequestRef.GetHeaderMap(const HeaderMap: ICefStringMap);
begin
  PCefRequest(FData)^.get_header_map(PCefRequest(FData), HeaderMap.Handle);
end;

function TCefRequestRef.GetMethod: ustring;
begin
  Result := CefStringFreeAndGet(PCefRequest(FData)^.get_method(PCefRequest(FData)))
end;

function TCefRequestRef.GetPostData: ICefPostData;
begin
  Result := TCefPostDataRef.UnWrap(PCefRequest(FData)^.get_post_data(PCefRequest(FData)));
end;

function TCefRequestRef.GetUrl: ustring;
begin
  Result := CefStringFreeAndGet(PCefRequest(FData)^.get_url(PCefRequest(FData)))
end;

procedure TCefRequestRef.SetHeaderMap(const HeaderMap: ICefStringMap);
begin
  PCefRequest(FData)^.set_header_map(PCefRequest(FData), HeaderMap.Handle);
end;

procedure TCefRequestRef.SetMethod(const value: ustring);
begin
  PCefRequest(FData)^.set_method(PCefRequest(FData), CefString(value));
end;

procedure TCefRequestRef.SetPostData(const value: ICefPostData);
begin
  if value <> nil then
    PCefRequest(FData)^.set_post_data(PCefRequest(FData), value.Wrap);
end;

procedure TCefRequestRef.SetUrl(const value: ustring);
begin
  PCefRequest(FData)^.set_url(PCefRequest(FData), CefString(value));
end;

class function TCefRequestRef.UnWrap(data: Pointer): ICefRequest;
begin
  if data <> nil then
  begin
    Result := Create(data);
    if Assigned(PCefBase(Data)^.release) then
      PCefBase(Data)^.release(PCefBase(Data));
  end else
    Result := nil;
end;

{ TCefStreamReaderRef }

function TCefStreamReaderRef.Eof: Boolean;
begin
  Result := PCefStreamReader(FData)^.eof(PCefStreamReader(FData)) <> 0;
end;

function TCefStreamReaderRef.Read(ptr: Pointer; size, n: Cardinal): Cardinal;
begin
  Result := PCefStreamReader(FData)^.read(PCefStreamReader(FData), ptr, size, n);
end;

function TCefStreamReaderRef.Seek(offset, whence: Integer): Integer;
begin
  Result := PCefStreamReader(FData)^.seek(PCefStreamReader(FData), offset, whence);
end;

function TCefStreamReaderRef.Tell: LongInt;
begin
  Result := PCefStreamReader(FData)^.tell(PCefStreamReader(FData));
end;

class function TCefStreamReaderRef.UnWrap(data: Pointer): ICefStreamReader;
begin
  if data <> nil then
  begin
    Result := Create(data);
    if Assigned(PCefBase(Data)^.release) then
      PCefBase(Data)^.release(PCefBase(Data));
  end else
    Result := nil;
end;

{ TCefLib }

var
  LibHandle: THandle = 0;

procedure CefLoadLib(const Cache, UserAgent, ProductVersion, Locale, LogFile: ustring;
  LogSeverity: TCefLogSeverity; ExtraPluginPaths: TStrings);
var
  settings: TCefSettings;
  i: Integer;
begin
  if LibHandle = 0 then
  begin
    LibHandle := LoadLibrary(LIBCEF);
    if LibHandle = 0 then
      RaiseLastOSError;

    cef_string_wide_set := GetProcAddress(LibHandle, 'cef_string_wide_set');
    cef_string_utf8_set := GetProcAddress(LibHandle, 'cef_string_utf8_set');
    cef_string_utf16_set := GetProcAddress(LibHandle, 'cef_string_utf16_set');
    cef_string_wide_clear := GetProcAddress(LibHandle, 'cef_string_wide_clear');
    cef_string_utf8_clear := GetProcAddress(LibHandle, 'cef_string_utf8_clear');
    cef_string_utf16_clear := GetProcAddress(LibHandle, 'cef_string_utf16_clear');
    cef_string_wide_cmp := GetProcAddress(LibHandle, 'cef_string_wide_cmp');
    cef_string_utf8_cmp := GetProcAddress(LibHandle, 'cef_string_utf8_cmp');
    cef_string_utf16_cmp := GetProcAddress(LibHandle, 'cef_string_utf16_cmp');
    cef_string_wide_to_utf8 := GetProcAddress(LibHandle, 'cef_string_wide_to_utf8');
    cef_string_utf8_to_wide := GetProcAddress(LibHandle, 'cef_string_utf8_to_wide');
    cef_string_wide_to_utf16 := GetProcAddress(LibHandle, 'cef_string_wide_to_utf16');
    cef_string_utf16_to_wide := GetProcAddress(LibHandle, 'cef_string_utf16_to_wide');
    cef_string_utf8_to_utf16 := GetProcAddress(LibHandle, 'cef_string_utf8_to_utf16');
    cef_string_utf16_to_utf8 := GetProcAddress(LibHandle, 'cef_string_utf16_to_utf8');
    cef_string_ascii_to_wide := GetProcAddress(LibHandle, 'cef_string_ascii_to_wide');
    cef_string_ascii_to_utf16 := GetProcAddress(LibHandle, 'cef_string_ascii_to_utf16');
    cef_string_userfree_wide_alloc := GetProcAddress(LibHandle, 'cef_string_userfree_wide_alloc');
    cef_string_userfree_utf8_alloc := GetProcAddress(LibHandle, 'cef_string_userfree_utf8_alloc');
    cef_string_userfree_utf16_alloc := GetProcAddress(LibHandle, 'cef_string_userfree_utf16_alloc');
    cef_string_userfree_wide_free := GetProcAddress(LibHandle, 'cef_string_userfree_wide_free');
    cef_string_userfree_utf8_free := GetProcAddress(LibHandle, 'cef_string_userfree_utf8_free');
    cef_string_userfree_utf16_free := GetProcAddress(LibHandle, 'cef_string_userfree_utf16_free');

{$IFDEF CEF_STRING_TYPE_UTF8}
  cef_string_set := cef_string_utf8_set;
  cef_string_clear := cef_string_utf8_clear;
  cef_string_userfree_alloc := cef_string_userfree_utf8_alloc;
  cef_string_userfree_free := cef_string_userfree_utf8_free;
  cef_string_from_ascii := cef_string_utf8_copy;
  cef_string_to_utf8 := cef_string_utf8_copy;
  cef_string_from_utf8 := cef_string_utf8_copy;
  cef_string_to_utf16 := cef_string_utf8_to_utf16;
  cef_string_from_utf16 := cef_string_utf16_to_utf8;
  cef_string_to_wide := cef_string_utf8_to_wide;
  cef_string_from_wide := cef_string_wide_to_utf8;
{$ENDIF}

{$IFDEF CEF_STRING_TYPE_UTF16}
    cef_string_set := cef_string_utf16_set;
    cef_string_clear := cef_string_utf16_clear;
    cef_string_userfree_alloc := cef_string_userfree_utf16_alloc;
    cef_string_userfree_free := cef_string_userfree_utf16_free;
    cef_string_from_ascii := cef_string_ascii_to_utf16;
    cef_string_to_utf8 := cef_string_utf16_to_utf8;
    cef_string_from_utf8 := cef_string_utf8_to_utf16;
    cef_string_to_utf16 := cef_string_utf16_copy;
    cef_string_from_utf16 := cef_string_utf16_copy;
    cef_string_to_wide := cef_string_utf16_to_wide;
    cef_string_from_wide := cef_string_wide_to_utf16;
{$ENDIF}

{$IFDEF CEF_STRING_TYPE_WIDE}
    cef_string_set := cef_string_wide_set;
    cef_string_clear := cef_string_wide_clear;
    cef_string_userfree_alloc := cef_string_userfree_wide_alloc;
    cef_string_userfree_free := cef_string_userfree_wide_free;
    cef_string_from_ascii := cef_string_ascii_to_wide;
    cef_string_to_utf8 := cef_string_wide_to_utf8;
    cef_string_from_utf8 := cef_string_utf8_to_wide;
    cef_string_to_utf16 := cef_string_wide_to_utf16;
    cef_string_from_utf16 := cef_string_utf16_to_wide;
    cef_string_to_wide := cef_string_wide_copy;
    cef_string_from_wide := cef_string_wide_copy;
{$ENDIF}

    cef_string_map_alloc := GetProcAddress(LibHandle, 'cef_string_map_alloc');
    cef_string_map_size := GetProcAddress(LibHandle, 'cef_string_map_size');
    cef_string_map_find := GetProcAddress(LibHandle, 'cef_string_map_find');
    cef_string_map_key := GetProcAddress(LibHandle, 'cef_string_map_key');
    cef_string_map_value := GetProcAddress(LibHandle, 'cef_string_map_value');
    cef_string_map_append := GetProcAddress(LibHandle, 'cef_string_map_append');
    cef_string_map_clear := GetProcAddress(LibHandle, 'cef_string_map_clear');
    cef_string_map_free := GetProcAddress(LibHandle, 'cef_string_map_free');
    cef_string_list_alloc := GetProcAddress(LibHandle, 'cef_string_list_alloc');
    cef_string_list_size := GetProcAddress(LibHandle, 'cef_string_list_size');
    cef_string_list_value := GetProcAddress(LibHandle, 'cef_string_list_value');
    cef_string_list_append := GetProcAddress(LibHandle, 'cef_string_list_append');
    cef_string_list_clear := GetProcAddress(LibHandle, 'cef_string_list_clear');
    cef_string_list_free := GetProcAddress(LibHandle, 'cef_string_list_free');
    cef_string_list_copy := GetProcAddress(LibHandle, 'cef_string_list_copy');
    cef_initialize := GetProcAddress(LibHandle, 'cef_initialize');
    cef_shutdown := GetProcAddress(LibHandle, 'cef_shutdown');
    cef_do_message_loop_work := GetProcAddress(LibHandle, 'cef_do_message_loop_work');
    cef_register_extension := GetProcAddress(LibHandle, 'cef_register_extension');
    cef_register_scheme := GetProcAddress(LibHandle, 'cef_register_scheme');
    cef_currently_on := GetProcAddress(LibHandle, 'cef_currently_on');
    cef_post_task := GetProcAddress(LibHandle, 'cef_post_task');
    cef_post_delayed_task := GetProcAddress(LibHandle, 'cef_post_delayed_task');
    cef_parse_url := GetProcAddress(LibHandle, 'cef_parse_url');
    cef_create_url := GetProcAddress(LibHandle, 'cef_create_url');
    cef_browser_create := GetProcAddress(LibHandle, 'cef_browser_create');
    cef_browser_create_sync := GetProcAddress(LibHandle, 'cef_browser_create_sync');
    cef_request_create := GetProcAddress(LibHandle, 'cef_request_create');
    cef_post_data_create := GetProcAddress(LibHandle, 'cef_post_data_create');
    cef_post_data_element_create := GetProcAddress(LibHandle, 'cef_post_data_element_create');
    cef_stream_reader_create_for_file := GetProcAddress(LibHandle, 'cef_stream_reader_create_for_file');
    cef_stream_reader_create_for_data := GetProcAddress(LibHandle, 'cef_stream_reader_create_for_data');
    cef_stream_reader_create_for_handler := GetProcAddress(LibHandle, 'cef_stream_reader_create_for_handler');
    cef_stream_writer_create_for_file := GetProcAddress(LibHandle, 'cef_stream_writer_create_for_file');
    cef_stream_writer_create_for_handler := GetProcAddress(LibHandle, 'cef_stream_writer_create_for_handler');
    cef_v8value_create_undefined := GetProcAddress(LibHandle, 'cef_v8value_create_undefined');
    cef_v8value_create_null := GetProcAddress(LibHandle, 'cef_v8value_create_null');
    cef_v8value_create_bool := GetProcAddress(LibHandle, 'cef_v8value_create_bool');
    cef_v8value_create_int := GetProcAddress(LibHandle, 'cef_v8value_create_int');
    cef_v8value_create_double := GetProcAddress(LibHandle, 'cef_v8value_create_double');
    cef_v8value_create_string := GetProcAddress(LibHandle, 'cef_v8value_create_string');
    cef_v8value_create_object := GetProcAddress(LibHandle, 'cef_v8value_create_object');
    cef_v8value_create_array := GetProcAddress(LibHandle, 'cef_v8value_create_array');
    cef_v8value_create_function := GetProcAddress(LibHandle, 'cef_v8value_create_function');
    cef_xml_reader_create := GetProcAddress(LibHandle, 'cef_xml_reader_create');
    cef_zip_reader_create := GetProcAddress(LibHandle, 'cef_zip_reader_create');

    if not (
      Assigned(cef_string_wide_set) and
      Assigned(cef_string_utf8_set) and
      Assigned(cef_string_utf16_set) and
      Assigned(cef_string_wide_clear) and
      Assigned(cef_string_utf8_clear) and
      Assigned(cef_string_utf16_clear) and
      Assigned(cef_string_wide_cmp) and
      Assigned(cef_string_utf8_cmp) and
      Assigned(cef_string_utf16_cmp) and
      Assigned(cef_string_wide_to_utf8) and
      Assigned(cef_string_utf8_to_wide) and
      Assigned(cef_string_wide_to_utf16) and
      Assigned(cef_string_utf16_to_wide) and
      Assigned(cef_string_utf8_to_utf16) and
      Assigned(cef_string_utf16_to_utf8) and
      Assigned(cef_string_ascii_to_wide) and
      Assigned(cef_string_ascii_to_utf16) and
      Assigned(cef_string_userfree_wide_alloc) and
      Assigned(cef_string_userfree_utf8_alloc) and
      Assigned(cef_string_userfree_utf16_alloc) and
      Assigned(cef_string_userfree_wide_free) and
      Assigned(cef_string_userfree_utf8_free) and
      Assigned(cef_string_userfree_utf16_free) and

      Assigned(cef_string_map_alloc) and
      Assigned(cef_string_map_size) and
      Assigned(cef_string_map_find) and
      Assigned(cef_string_map_key) and
      Assigned(cef_string_map_value) and
      Assigned(cef_string_map_append) and
      Assigned(cef_string_map_clear) and
      Assigned(cef_string_map_free) and
      Assigned(cef_string_list_alloc) and
      Assigned(cef_string_list_size) and
      Assigned(cef_string_list_value) and
      Assigned(cef_string_list_append) and
      Assigned(cef_string_list_clear) and
      Assigned(cef_string_list_free) and
      Assigned(cef_string_list_copy) and
      Assigned(cef_initialize) and
      Assigned(cef_shutdown) and
      Assigned(cef_do_message_loop_work) and
      Assigned(cef_register_extension) and
      Assigned(cef_register_scheme) and
      Assigned(cef_currently_on) and
      Assigned(cef_post_task) and
      Assigned(cef_post_delayed_task) and
      Assigned(cef_parse_url) and
      Assigned(cef_create_url) and
      Assigned(cef_browser_create) and
      Assigned(cef_browser_create_sync) and
      Assigned(cef_request_create) and
      Assigned(cef_post_data_create) and
      Assigned(cef_post_data_element_create) and
      Assigned(cef_stream_reader_create_for_file) and
      Assigned(cef_stream_reader_create_for_data) and
      Assigned(cef_stream_reader_create_for_handler) and
      Assigned(cef_stream_writer_create_for_file) and
      Assigned(cef_stream_writer_create_for_handler) and
      Assigned(cef_v8value_create_undefined) and
      Assigned(cef_v8value_create_null) and
      Assigned(cef_v8value_create_bool) and
      Assigned(cef_v8value_create_int) and
      Assigned(cef_v8value_create_double) and
      Assigned(cef_v8value_create_string) and
      Assigned(cef_v8value_create_object) and
      Assigned(cef_v8value_create_array) and
      Assigned(cef_v8value_create_function) and
      Assigned(cef_xml_reader_create) and
      Assigned(cef_zip_reader_create)
    ) then raise Exception.Create('Invalid CEF Library version');

    FillChar(settings, SizeOf(settings), 0);
    settings.size := SizeOf(settings);
    settings.multi_threaded_message_loop := True;
    settings.cache_path := CefString(Cache);
    settings.user_agent := cefstring(UserAgent);
    settings.product_version := CefString(ProductVersion);
    settings.locale := CefString(Locale);
    if (ExtraPluginPaths <> nil) then
    begin
      settings.extra_plugin_paths := cef_string_list_alloc;
      for i := 0 to ExtraPluginPaths.Count - 1 do
        cef_string_list_append(settings.extra_plugin_paths, cefString(ExtraPluginPaths[i]));
    end;
    settings.log_file := CefString(LogFile);
    settings.log_severity := LogSeverity;
    cef_initialize(@settings, nil);
    if settings.extra_plugin_paths <> nil then
      cef_string_list_free(settings.extra_plugin_paths);
  end;
end;

function CefBrowserCreate(windowInfo: PCefWindowInfo; popup: Boolean;
  handler: PCefHandler; const url: ustring): Boolean;
begin
  CefLoadLib(CefCache, CefUserAgent, CefProductVersion, CefLocale, CefLogFile, CefLogSeverity);

  Result :=
    cef_browser_create(
      windowInfo,
      Ord(popup),
      handler,
      CefString(url)) <> 0;
end;

function CefString(const str: ustring): TCefString;
begin
  Result.str := PChar16(PWideChar(str));
  Result.length := Length(str);
  Result.dtor := nil;
end;

function CefString(const str: PCefString): ustring; overload;
//var
//  w: TCefStringWide;
begin
  if str <> nil then
    SetString(Result, str.str, str.length) else
    Result := '';
//  FillChar(w, SizeOf(w), 0);
//  if (str <> nil) then
//    cef_string_to_wide(str.str, str.length, @w);
//  Result := w.str;
//  cef_string_wide_clear(@w);
end;

function CefStringAlloc(const str: ustring): TCefString;
begin
  FillChar(Result, SizeOf(Result), 0);
  cef_string_from_wide(PWideChar(str), Length(str), @Result);
end;

procedure CefStringSet(const str: PCefString; const value: ustring);
begin
  cef_string_set(PWideChar(value), Length(value), str, 1);
end;

function CefStringClearAndGet(var str: TCefString): ustring;
begin
  Result := CefString(@str);
  cef_string_clear(@str);
end;

function CefStringFreeAndGet(const str: PCefStringUserFree): ustring;
begin
  if str <> nil then
  begin
    Result := CefString(PCefString(str));
    cef_string_userfree_free(str);
  end else
    Result := '';
end;

procedure CefStringFree(const str: PCefString);
begin
  if str <> nil then
    cef_string_clear(str);
end;

function CefRegisterScheme(const SchemeName, HostName: ustring;
  const handler: TCefSchemeHandlerClass): Boolean;
begin
  Result := cef_register_scheme(
    CefString(SchemeName),
    CefString(HostName),
    (TCefSchemeHandlerFactoryOwn.Create(handler) as ICefBase).Wrap) <> 0;
end;

function CefRegisterExtension(const name, code: ustring;
  const Handler: ICefv8Handler): Boolean;
begin
  Result := cef_register_extension(CefString(name), CefString(code), handler.Wrap) <> 0;
end;

function CefCurrentlyOn(ThreadId: TCefThreadId): Boolean;
begin
  Result := cef_currently_on(ThreadId) <> 0;
end;

procedure CefPostTask(ThreadId: TCefThreadId; const task: ICefTask);
begin
  cef_post_task(ThreadId, task.Wrap);
end;

procedure CefPostDelayedTask(ThreadId: TCefThreadId; const task: ICefTask; delayMs: Integer);
begin
  cef_post_delayed_task(ThreadId, task.Wrap, delayMs);
end;

{ TCefSchemeHandlerFactoryOwn }

constructor TCefSchemeHandlerFactoryOwn.Create(const AClass: TCefSchemeHandlerClass);
begin
  inherited CreateData(SizeOf(TCefSchemeHandlerFactory));
  with PCefSchemeHandlerFactory(FData)^ do
    create := @cef_scheme_handler_factory_create;
  FClass := AClass;
end;

function TCefSchemeHandlerFactoryOwn.New: ICefSchemeHandler;
begin
  Result := FClass.Create;
end;

{ TCefSchemeHandlerOwn }

procedure TCefSchemeHandlerOwn.Cancel;
begin
  // do not lock
  FCancelled := True;
end;

constructor TCefSchemeHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefSchemeHandler));
  FCancelled := False;
  with PCefSchemeHandler(FData)^ do
  begin
    process_request := @cef_scheme_handler_process_request;
    cancel := @cef_scheme_handler_cancel;
    read_response := @cef_scheme_handler_read_response;
  end;
end;

function TCefSchemeHandlerOwn.ProcessRequest(const Request: ICefRequest;
  var MimeType: ustring; var ResponseLength: Integer): Boolean;
begin
  Result := False;
end;

function TCefSchemeHandlerOwn.ReadResponse(DataOut: Pointer;
  BytesToRead: Integer; var BytesRead: Integer): Boolean;
begin
  Result := False;
end;

{ TCefv8ValueRef }

constructor TCefv8ValueRef.CreateArray;
begin
  Create(cef_v8value_create_array);
end;

constructor TCefv8ValueRef.CreateBool(value: Boolean);
begin
  Create(cef_v8value_create_bool(Ord(value)));
end;

constructor TCefv8ValueRef.CreateDouble(value: Double);
begin
  Create(cef_v8value_create_double(value));
end;

constructor TCefv8ValueRef.CreateFunction(const name: ustring;
  const handler: ICefv8Handler);
begin
  Create(cef_v8value_create_function(CefString(name), CefGetData(handler)));
end;

constructor TCefv8ValueRef.CreateInt(value: Integer);
begin
  Create(cef_v8value_create_int(value))
end;

constructor TCefv8ValueRef.CreateNull;
begin
  Create(cef_v8value_create_null);
end;

constructor TCefv8ValueRef.CreateObject(const UserData: ICefBase);
begin
  Create(cef_v8value_create_object(CefGetData(UserData)));
end;

constructor TCefv8ValueRef.CreateString(const str: ustring);
begin
  Create(cef_v8value_create_string(CefString(str)));
end;

constructor TCefv8ValueRef.CreateUndefined;
begin
  Create(cef_v8value_create_undefined);
end;

function TCefv8ValueRef.DeleteValueByIndex(index: Integer): Boolean;
begin
  Result := PCefV8Value(FData)^.delete_value_byindex(PCefV8Value(FData), index) <> 0;
end;

function TCefv8ValueRef.DeleteValueByKey(const key: ustring): Boolean;
begin
  Result := PCefV8Value(FData)^.delete_value_bykey(PCefV8Value(FData), CefString(key)) <> 0;
end;

function TCefv8ValueRef.ExecuteFunction(const obj: ICefv8Value;
  const arguments: TCefv8ValueArray; var retval: ICefv8Value;
  var exception: ustring): Boolean;
var
  args: array of PCefV8Value;
  i: Integer;
  ret: PCefV8Value;
  exc: TCefString;
begin
  SetLength(args, Length(arguments));
  for i := 0 to Length(arguments) - 1 do
    args[i] := CefGetData(arguments[i]);
  ret := nil;
  FillChar(exc, SizeOf(exc), 0);
  Result := PCefV8Value(FData)^.execute_function(PCefV8Value(FData),
    CefGetData(obj), Length(arguments), @args, ret, exc) <> 0;
  retval := TCefv8ValueRef.UnWrap(ret);
  exception := CefStringClearAndGet(exc);
end;

function TCefv8ValueRef.GetArrayLength: Integer;
begin
  Result := PCefV8Value(FData)^.get_array_length(PCefV8Value(FData));
end;

function TCefv8ValueRef.GetBoolValue: Boolean;
begin
  Result := PCefV8Value(FData)^.get_bool_value(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.GetDoubleValue: Double;
begin
  Result := PCefV8Value(FData)^.get_double_value(PCefV8Value(FData));
end;

function TCefv8ValueRef.GetFunctionHandler: ICefv8Handler;
begin
  Result := TCefv8HandlerRef.UnWrap(PCefV8Value(FData)^.get_function_handler(PCefV8Value(FData)));
end;

function TCefv8ValueRef.GetFunctionName: ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Value(FData)^.get_function_name(PCefV8Value(FData)))
end;

function TCefv8ValueRef.GetIntValue: Integer;
begin
  Result := PCefV8Value(FData)^.get_int_value(PCefV8Value(FData))
end;

function TCefv8ValueRef.GetKeys(const keys: TStrings): Integer;
var
  list: TCefStringList;
  i: Integer;
  str: TCefString;
begin
  list := cef_string_list_alloc;
  try
    Result := PCefV8Value(FData)^.get_keys(PCefV8Value(FData), list);
    FillChar(str, SizeOf(str), 0);
    for i := 0 to cef_string_list_size(list) - 1 do
    begin
      cef_string_list_value(list, i, @str);
      keys.Add(CefStringClearAndGet(str));
    end;
  finally
    cef_string_list_free(list);
  end;
end;

function TCefv8ValueRef.GetStringValue: ustring;
begin
  Result := CefStringFreeAndGet(PCefV8Value(FData)^.get_string_value(PCefV8Value(FData)));
end;

function TCefv8ValueRef.GetUserData: ICefBase;
begin
  Result := TCefBaseRef.UnWrap(PCefV8Value(FData)^.get_user_data(PCefV8Value(FData)));
end;

function TCefv8ValueRef.GetValueByIndex(index: Integer): ICefv8Value;
begin
  Result := TCefv8ValueRef.UnWrap(PCefV8Value(FData)^.get_value_byindex(PCefV8Value(FData), index))
end;

function TCefv8ValueRef.GetValueByKey(const key: ustring): ICefv8Value;
begin
  Result := TCefv8ValueRef.UnWrap(PCefV8Value(FData)^.get_value_bykey(PCefV8Value(FData), CefString(key)))
end;

function TCefv8ValueRef.HasValueByIndex(index: Integer): Boolean;
begin
  Result := PCefV8Value(FData)^.has_value_byindex(PCefV8Value(FData), index) <> 0;
end;

function TCefv8ValueRef.HasValueByKey(const key: ustring): Boolean;
begin
  Result := PCefV8Value(FData)^.has_value_bykey(PCefV8Value(FData), CefString(key)) <> 0;
end;

function TCefv8ValueRef.IsArray: Boolean;
begin
  Result := PCefV8Value(FData)^.is_array(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsBool: Boolean;
begin
  Result := PCefV8Value(FData)^.is_bool(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsDouble: Boolean;
begin
  Result := PCefV8Value(FData)^.is_double(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsFunction: Boolean;
begin
  Result := PCefV8Value(FData)^.is_function(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsInt: Boolean;
begin
  Result := PCefV8Value(FData)^.is_int(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsNull: Boolean;
begin
  Result := PCefV8Value(FData)^.is_null(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsObject: Boolean;
begin
  Result := PCefV8Value(FData)^.is_object(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsString: Boolean;
begin
  Result := PCefV8Value(FData)^.is_string(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.IsUndefined: Boolean;
begin
  Result := PCefV8Value(FData)^.is_undefined(PCefV8Value(FData)) <> 0;
end;

function TCefv8ValueRef.SetValueByIndex(index: Integer;
  const value: ICefv8Value): Boolean;
begin
  Result:= PCefV8Value(FData)^.set_value_byindex(PCefV8Value(FData), index, CefGetData(value)) <> 0;
end;

function TCefv8ValueRef.SetValueByKey(const key: ustring;
  const value: ICefv8Value): Boolean;
begin
  Result:= PCefV8Value(FData)^.set_value_bykey(PCefV8Value(FData), CefString(key), CefGetData(value)) <> 0;
end;

class function TCefv8ValueRef.UnWrap(data: Pointer): ICefv8Value;
begin
  if data <> nil then
  begin
    Result := Create(data);
    if Assigned(PCefBase(Data)^.release) then
      PCefBase(Data)^.release(PCefBase(Data));
  end else
    Result := nil;
end;

{ TCefv8HandlerRef }

function TCefv8HandlerRef.Execute(const name: ustring; const obj: ICefv8Value;
  const arguments: TCefv8ValueArray; var retval: ICefv8Value;
  var exception: ustring): Boolean;
var
  args: array of PCefV8Value;
  i: Integer;
  ret: PCefV8Value;
  exc: TCefString;
begin
  SetLength(args, Length(arguments));
  for i := 0 to Length(arguments) - 1 do
    args[i] := CefGetData(arguments[i]);
  ret := nil;
  FillChar(exc, SizeOf(exc), 0);
  Result := PCefv8Handler(FData)^.execute(PCefv8Handler(FData), CefString(name),
    CefGetData(obj), Length(arguments), @args, ret, exc) <> 0;
  retval := TCefv8ValueRef.UnWrap(ret);
  exception := CefStringClearAndGet(exc);
end;

class function TCefv8HandlerRef.UnWrap(data: Pointer): ICefv8Handler;
begin
  if data <> nil then
  begin
    Result := Create(data);
    if Assigned(PCefBase(Data)^.release) then
      PCefBase(Data)^.release(PCefBase(Data));
  end else
    Result := nil;
end;

{ TCefv8HandlerOwn }

constructor TCefv8HandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefv8Handler));
  with PCefv8Handler(FData)^ do
    execute := @cef_v8_handler_execute;
end;

function TCefv8HandlerOwn.Execute(const name: ustring; const obj: ICefv8Value;
  const arguments: TCefv8ValueArray; var retval: ICefv8Value;
  var exception: ustring): Boolean;
begin
  Result := False;
end;

{ TCefTaskOwn }

constructor TCefTaskOwn.Create;
begin
  inherited CreateData(SizeOf(TCefTask));
  with PCefTask(FData)^ do
    execute := @cef_task_execute;
end;

procedure TCefTaskOwn.Execute(threadId: TCefThreadId);
begin
  Beep;
end;

{ TCefStringMapOwn }

procedure TCefStringMapOwn.Append(const key, value: ustring);
begin
  cef_string_map_append(FStringMap, CefString(key), CefString(value));
end;

procedure TCefStringMapOwn.Clear;
begin
  cef_string_map_clear(FStringMap);
end;

constructor TCefStringMapOwn.Create;
begin
  FStringMap := cef_string_map_alloc;
end;

destructor TCefStringMapOwn.Destroy;
begin
  cef_string_map_free(FStringMap);
end;

function TCefStringMapOwn.Find(const key: ustring): ustring;
var
  str: TCefString;
begin
  FillChar(str, SizeOf(str), 0);
  cef_string_map_find(FStringMap, CefString(key), str);
  Result := CefString(@str);
end;

function TCefStringMapOwn.GetHandle: TCefStringMap;
begin
  Result := FStringMap;
end;

function TCefStringMapOwn.GetKey(index: Integer): ustring;
var
  str: TCefString;
begin
  FillChar(str, SizeOf(str), 0);
  cef_string_map_key(FStringMap, index, str);
  Result := CefString(@str);
end;

function TCefStringMapOwn.GetSize: Integer;
begin
  Result := cef_string_map_size(FStringMap);
end;

function TCefStringMapOwn.GetValue(index: Integer): ustring;
var
  str: TCefString;
begin
  FillChar(str, SizeOf(str), 0);
  cef_string_map_value(FStringMap, index, str);
  Result := CefString(@str);
end;

{ TCefDownloadHandlerOwn }

constructor TCefDownloadHandlerOwn.Create;
begin
  inherited CreateData(SizeOf(TCefDownloadHandler));
  with PCefDownloadHandler(FData)^ do
  begin
    received_data := @cef_download_handler_received_data;
    complete := @cef_download_handler_complete;
  end;
end;

{ TCefXmlReaderRef }

function TCefXmlReaderRef.Close: Boolean;
begin
  Result := PCefXmlReader(FData).close(FData) <> 0;
end;

constructor TCefXmlReaderRef.Create(const stream: ICefStreamReader;
  encodingType: TCefXmlEncodingType; const URI: ustring);
begin
  inherited Create(cef_xml_reader_create(stream.Wrap, encodingType, CefString(URI)));
end;

function TCefXmlReaderRef.GetAttributeByIndex(index: Integer): ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData).get_attribute_byindex(FData, index));
end;

function TCefXmlReaderRef.GetAttributeByLName(const localName,
  namespaceURI: ustring): ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData).get_attribute_bylname(FData, CefString(localName), CefString(namespaceURI)));
end;

function TCefXmlReaderRef.GetAttributeByQName(
  const qualifiedName: ustring): ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData).get_attribute_byqname(FData, CefString(qualifiedName)));
end;

function TCefXmlReaderRef.GetAttributeCount: Cardinal;
begin
  Result := PCefXmlReader(FData).get_attribute_count(FData);
end;

function TCefXmlReaderRef.GetBaseUri: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData).get_base_uri(FData));
end;

function TCefXmlReaderRef.GetDepth: Integer;
begin
  Result := PCefXmlReader(FData).get_depth(FData);
end;

function TCefXmlReaderRef.GetError: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData).get_error(FData));
end;

function TCefXmlReaderRef.GetInnerXml: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData).get_inner_xml(FData));
end;

function TCefXmlReaderRef.GetLineNumber: Integer;
begin
  Result := PCefXmlReader(FData).get_line_number(FData);
end;

function TCefXmlReaderRef.GetLocalName: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData).get_local_name(FData));
end;

function TCefXmlReaderRef.GetNamespaceUri: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData).get_namespace_uri(FData));
end;

function TCefXmlReaderRef.GetOuterXml: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData).get_outer_xml(FData));
end;

function TCefXmlReaderRef.GetPrefix: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData).get_prefix(FData));
end;

function TCefXmlReaderRef.GetQualifiedName: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData).get_qualified_name(FData));
end;

function TCefXmlReaderRef.GetType: TCefXmlNodeType;
begin
  Result := PCefXmlReader(FData).get_type(FData);
end;

function TCefXmlReaderRef.GetValue: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData).get_value(FData));
end;

function TCefXmlReaderRef.GetXmlLang: ustring;
begin
  Result := CefStringFreeAndGet(PCefXmlReader(FData).get_xml_lang(FData));
end;

function TCefXmlReaderRef.HasAttributes: Boolean;
begin
  Result := PCefXmlReader(FData).has_attributes(FData) <> 0;
end;

function TCefXmlReaderRef.HasError: Boolean;
begin
  Result := PCefXmlReader(FData).has_error(FData) <> 0;
end;

function TCefXmlReaderRef.HasValue: Boolean;
begin
  Result := PCefXmlReader(FData).has_value(FData) <> 0;
end;

function TCefXmlReaderRef.IsEmptyElement: Boolean;
begin
  Result := PCefXmlReader(FData).is_empty_element(FData) <> 0;
end;

function TCefXmlReaderRef.MoveToAttributeByIndex(index: Integer): Boolean;
begin
  Result := PCefXmlReader(FData).move_to_attribute_byindex(FData, index) <> 0;
end;

function TCefXmlReaderRef.MoveToAttributeByLName(const localName,
  namespaceURI: ustring): Boolean;
begin
  Result := PCefXmlReader(FData).move_to_attribute_bylname(FData, CefString(localName), CefString(namespaceURI)) <> 0;
end;

function TCefXmlReaderRef.MoveToAttributeByQName(
  const qualifiedName: ustring): Boolean;
begin
  Result := PCefXmlReader(FData).move_to_attribute_byqname(FData, CefString(qualifiedName)) <> 0;
end;

function TCefXmlReaderRef.MoveToCarryingElement: Boolean;
begin
  Result := PCefXmlReader(FData).move_to_carrying_element(FData) <> 0;
end;

function TCefXmlReaderRef.MoveToFirstAttribute: Boolean;
begin
  Result := PCefXmlReader(FData).move_to_first_attribute(FData) <> 0;
end;

function TCefXmlReaderRef.MoveToNextAttribute: Boolean;
begin
  Result := PCefXmlReader(FData).move_to_next_attribute(FData) <> 0;
end;

function TCefXmlReaderRef.MoveToNextNode: Boolean;
begin
  Result := PCefXmlReader(FData).move_to_next_node(FData) <> 0;
end;

{ TCefZipReaderRef }

function TCefZipReaderRef.Close: Boolean;
begin
  Result := PCefZipReader(FData).close(FData) <> 0;
end;

function TCefZipReaderRef.CloseFile: Boolean;
begin
  Result := PCefZipReader(FData).close_file(FData) <> 0;
end;

constructor TCefZipReaderRef.Create(const stream: ICefStreamReader);
begin
  inherited Create(cef_zip_reader_create(stream.Wrap));
end;

function TCefZipReaderRef.Eof: Boolean;
begin
  Result := PCefZipReader(FData).eof(FData) <> 0;
end;

function TCefZipReaderRef.GetFileLastModified: LongInt;
begin
  Result := PCefZipReader(FData).get_file_last_modified(FData);
end;

function TCefZipReaderRef.GetFileName: ustring;
begin
  Result := CefStringFreeAndGet(PCefZipReader(FData).get_file_name(FData));
end;

function TCefZipReaderRef.GetFileSize: LongInt;
begin
  Result := PCefZipReader(FData).get_file_size(FData);
end;

function TCefZipReaderRef.MoveToFile(const fileName: ustring;
  caseSensitive: Boolean): Boolean;
begin
  Result := PCefZipReader(FData).move_to_file(FData, CefString(fileName), Ord(caseSensitive)) <> 0;
end;

function TCefZipReaderRef.MoveToFirstFile: Boolean;
begin
  Result := PCefZipReader(FData).move_to_first_file(FData) <> 0;
end;

function TCefZipReaderRef.MoveToNextFile: Boolean;
begin
  Result := PCefZipReader(FData).move_to_next_file(FData) <> 0;
end;

function TCefZipReaderRef.OpenFile(const password: ustring): Boolean;
begin
  Result := PCefZipReader(FData).open_file(FData, CefString(password)) <> 0;
end;

function TCefZipReaderRef.ReadFile(buffer: Pointer;
  bufferSize: Cardinal): Integer;
begin
    Result := PCefZipReader(FData).read_file(FData, buffer, buffersize);
end;

function TCefZipReaderRef.Tell: LongInt;
begin
  Result := PCefZipReader(FData).tell(FData);
end;

{$IFDEF DELPHI12_UP}

{ TCefGenericTask<T> }

constructor TCefGenericTask<T>.Create(const param: T;
  const method: TCefTaskMethod);
begin
  inherited Create;
  FParam := param;
  FMethod := method;
end;

procedure TCefGenericTask<T>.Execute(threadId: TCefThreadId);
begin
  FMethod(FParam);
end;

class procedure TCefGenericTask<T>.Post(threadId: TCefThreadId; const param: T;
  const method: TCefTaskMethod);
begin
  CefPostTask(threadId, Create(param, method));
end;

class procedure TCefGenericTask<T>.PostDelayed(threadId: TCefThreadId;
  Delay: Integer; const param: T; const method: TCefTaskMethod);
begin
  CefPostDelayedTask(threadId, Create(param, method), Delay);
end;
{$ENDIF}

initialization
  IsMultiThread := True;

finalization
  if LibHandle <> 0 then
  begin
    cef_shutdown;
    FreeLibrary(LibHandle);
  end;

end.
