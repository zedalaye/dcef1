{$IFDEF FPC}
   {$MODE DELPHI}{$H+}
   {$APPTYPE GUI}
{$ENDIF}
program cefclient;

uses
  Classes,
  Windows,
  Messages,
  SysUtils,
  ceflib;


type
  THandler = class(TCefHandlerOwn)
  protected
    function doOnAfterCreated(const browser: ICefBrowser): TCefRetval; override;
    function doOnTitleChange(const browser: ICefBrowser;
      const title: ustring): TCefRetval; override;
    function doOnAddressChange(const browser: ICefBrowser;
      const frame: ICefFrame; const url: ustring): TCefRetval; override;
    function doOnLoadStart(const browser: ICefBrowser;
      const frame: ICefFrame): TCefRetval; override;
    function doOnLoadEnd(const browser: ICefBrowser;
      const frame: ICefFrame): TCefRetval; override;
  end;

  TScheme = class(TCefSchemeHandlerOwn)
  private
    FResponse: TMemoryStream;
    procedure Output(const str: ustring);
  protected
    function ProcessRequest(const Request: ICefRequest; var MimeType: ustring;
      var ResponseLength: Integer): Boolean; override;
    function ReadResponse(DataOut: Pointer; BytesToRead: Integer;
      var BytesRead: Integer): Boolean; override;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

type
{$IFDEF FPC}
  TWindowProc = LongInt;
{$ELSE}
  TWindowProc = Pointer;
  WNDPROC = Pointer;
{$ENDIF}

var
  Window : HWND;
  handl: ICefBase = nil;
  brows: ICefBrowser = nil;
  browsrHwnd: HWND = INVALID_HANDLE_VALUE;
  navigateto: ustring = 'http://www.google.com';

  backWnd, forwardWnd, reloadWnd, stopWnd, editWnd: HWND;
  editWndOldProc: TWindowProc;
  isLoading, canGoBack, canGoForward: Boolean;

const
  MAX_LOADSTRING = 100;
  MAX_URL_LENGTH = 255;
  BUTTON_WIDTH = 72;
  URLBAR_HEIGHT = 24;

  IDC_NAV_BACK = 200;
  IDC_NAV_FORWARD = 201;
  IDC_NAV_RELOAD = 202;
  IDC_NAV_STOP = 203;

function CefWndProc(Wnd: HWND; message: UINT; wParam: Integer; lParam: Integer): Integer; stdcall;
var
  ps: PAINTSTRUCT;
  info: TCefWindowInfo;
  rect: TRect;
  hdwp: THandle;
  x: Integer;
  strPtr: array[0..MAX_URL_LENGTH-1] of WideChar;
  strLen, urloffset: Integer;
begin
  if Wnd = editWnd then
    case message of
    WM_CHAR:
      if (wParam = VK_RETURN) then
      begin
        // When the user hits the enter key load the URL
        FillChar(strPtr, SizeOf(strPtr), 0);
        PDWORD(@strPtr)^ := MAX_URL_LENGTH;
        strLen := SendMessageW(Wnd, EM_GETLINE, 0, Integer(@strPtr));
        if (strLen > 0) then
        begin
          strPtr[strLen] := #0;
          brows.MainFrame.LoadUrl(strPtr);
        end;
        Result := 0;
      end else
        Result := CallWindowProc(WNDPROC(editWndOldProc), Wnd, message, wParam, lParam);
    else
      Result := CallWindowProc(WNDPROC(editWndOldProc), Wnd, message, wParam, lParam);
    end else
    case message of
      WM_PAINT:
        begin
          BeginPaint(Wnd, ps);
          EndPaint(Wnd, ps);
          result := 0;
        end;
      WM_CREATE:
        begin
          handl := THandler.Create;
          x := 0;
          GetClientRect(Wnd, rect);

          backWnd := CreateWindowW('BUTTON', 'Back',
                                 WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON
                                 or WS_DISABLED, x, 0, BUTTON_WIDTH, URLBAR_HEIGHT,
                                 Wnd, IDC_NAV_BACK, HInstance, nil);
          Inc(x, BUTTON_WIDTH);

          forwardWnd := CreateWindowW('BUTTON', 'Forward',
                                    WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON
                                    or WS_DISABLED, x, 0, BUTTON_WIDTH,
                                    URLBAR_HEIGHT, Wnd, IDC_NAV_FORWARD,
                                    HInstance, nil);
          Inc(x, BUTTON_WIDTH);

          reloadWnd := CreateWindowW('BUTTON', 'Reload',
                                   WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON
                                   or WS_DISABLED, x, 0, BUTTON_WIDTH,
                                   URLBAR_HEIGHT, Wnd, IDC_NAV_RELOAD,
                                   HInstance, nil);
          Inc(x, BUTTON_WIDTH);

          stopWnd := CreateWindowW('BUTTON', 'Stop',
                                 WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON
                                 or WS_DISABLED, x, 0, BUTTON_WIDTH, URLBAR_HEIGHT,
                                 Wnd, IDC_NAV_STOP, HInstance, nil);
          Inc(x, BUTTON_WIDTH);

          editWnd := CreateWindowW('EDIT', nil,
                                 WS_CHILD or WS_VISIBLE or WS_BORDER or ES_LEFT or
                                 ES_AUTOVSCROLL or ES_AUTOHSCROLL or WS_DISABLED,
                                 x, 0, rect.right - BUTTON_WIDTH * 4,
                                 URLBAR_HEIGHT, Wnd, 0, HInstance, nil);

          // Assign the edit window's WNDPROC to this function so that we can
          // capture the enter key
          editWndOldProc := TWindowProc(GetWindowLong(editWnd, GWL_WNDPROC));
          SetWindowLong(editWnd, GWL_WNDPROC, LongInt(@CefWndProc));

          FillChar(info, SizeOf(info), 0);
          Inc(rect.top, URLBAR_HEIGHT);

          info.Style := WS_CHILD or WS_VISIBLE or WS_CLIPCHILDREN or WS_CLIPSIBLINGS or WS_TABSTOP;
          info.WndParent := Wnd;
          info.x := rect.left;
          info.y := rect.top;
          info.Width := rect.right - rect.left;
          info.Height := rect.bottom - rect.top;
          CefBrowserCreate(@info, False, handl.Wrap, navigateto);
          isLoading := False;
          canGoBack := False;
          canGoForward := False;
          SetTimer(Wnd, 1, 100, nil);
          result := 0;
        end;
      WM_TIMER:
        begin
          // Update the status of child windows
          EnableWindow(editWnd, True);
          EnableWindow(backWnd, canGoBack);
          EnableWindow(forwardWnd, canGoForward);
          EnableWindow(reloadWnd, not isLoading);
          EnableWindow(stopWnd, isLoading);
          Result := 0;
        end;
      WM_COMMAND:
        case LOWORD(wParam) of
          IDC_NAV_BACK:
            begin
              brows.GoBack;
              Result := 0;
            end;
          IDC_NAV_FORWARD:
            begin
              brows.GoForward;
              Result := 0;
            end;
          IDC_NAV_RELOAD:
            begin
              brows.Reload;
              Result := 0;
            end;
          IDC_NAV_STOP:
            begin
              brows.StopLoad;
              Result := 0;
            end;
        else
          result := DefWindowProc(Wnd, message, wParam, lParam);
        end;
      WM_DESTROY:
        begin
          brows := nil;
          PostQuitMessage(0);
          result := 0;
        end;
      WM_SETFOCUS:
        begin
          if browsrHwnd <> INVALID_HANDLE_VALUE then
            PostMessage(browsrHwnd, WM_SETFOCUS, wParam, 0);
          Result := 0;
        end;
      WM_SIZE:
        begin
          if(browsrHwnd <> INVALID_HANDLE_VALUE) then
          begin
            // Resize the browser window and address bar to match the new frame
            // window size
            GetClientRect(Wnd, rect);
            Inc(rect.top, URLBAR_HEIGHT);
            urloffset := rect.left + BUTTON_WIDTH * 4;
            hdwp := BeginDeferWindowPos(1);
         		hdwp := DeferWindowPos(hdwp, editWnd, 0, urloffset, 0, rect.right - urloffset, URLBAR_HEIGHT, SWP_NOZORDER);
            hdwp := DeferWindowPos(hdwp, browsrHwnd, 0, rect.left, rect.top,
              rect.right - rect.left, rect.bottom - rect.top, SWP_NOZORDER);
            EndDeferWindowPos(hdwp);
          end;
          result := DefWindowProc(Wnd, message, wParam, lParam);
        end
     else
       result := DefWindowProc(Wnd, message, wParam, lParam);
     end;
end;

{ THandler }

function THandler.doOnAddressChange(const browser: ICefBrowser;
  const frame: ICefFrame; const url: ustring): TCefRetval;
begin
  Lock;
  try
    if (browser.GetWindowHandle = browsrHwnd) and frame.IsMain then
      SetWindowTextW(editWnd, PWideChar(url));
    Result := RV_CONTINUE;
  finally
    Unlock;
  end;
end;

function THandler.doOnAfterCreated(const browser: ICefBrowser): TCefRetval;
begin
  Lock;
  try
    if not browser.IsPopup then
    begin
      // get the first browser
      brows := browser;
      browsrHwnd := brows.GetWindowHandle;
    end;
  finally
    Unlock;
  end;
  Result := RV_CONTINUE;
end;

function THandler.doOnLoadEnd(const browser: ICefBrowser;
  const frame: ICefFrame): TCefRetval;
begin
  if browser.GetWindowHandle = browsrHwnd then
    isLoading := False;
  Result := RV_CONTINUE;
end;

function THandler.doOnLoadStart(const browser: ICefBrowser;
  const frame: ICefFrame): TCefRetval;
begin
  Lock;
  try
    if browser.GetWindowHandle = browsrHwnd then
    begin
      isLoading := True;
      canGoBack := browser.CanGoBack;
      canGoForward := browser.CanGoForward;
    end;
    Result := RV_CONTINUE;
  finally
    Unlock;
  end;
end;

function THandler.doOnTitleChange(const browser: ICefBrowser;
  const title: ustring): TCefRetval;
begin
  Lock;
  try
    if browser.GetWindowHandle = browsrHwnd then
      SetWindowTextW(Window, PWideChar(title));
    Result := RV_CONTINUE;
  finally
    Unlock;
  end;
end;

{ TScheme }

constructor TScheme.Create;
begin
  inherited;
  FResponse := TMemoryStream.Create;
end;

destructor TScheme.Destroy;
begin
  FResponse.Free;
  inherited;
end;

function TScheme.ProcessRequest(const Request: ICefRequest;
  var MimeType: ustring; var ResponseLength: Integer): Boolean;
begin
  Lock;
  try
    Output('<html><head><meta http-equiv="Content-type" content="text/html; charset=utf-8"/></head><body>');
    Output('<b>hello€</b');
    Output('</body></html>');
    FResponse.Seek(0, soFromBeginning);
    MimeType := 'text/html';
    ResponseLength := FResponse.Size;
    Result := True;
  finally
    Unlock;
  end;
end;


function TScheme.ReadResponse(DataOut: Pointer; BytesToRead: Integer;
  var BytesRead: Integer): Boolean;
begin
  BytesRead := FResponse.Read(DataOut^, BytesToRead);
  Result := True;
end;

procedure TScheme.Output(const str: ustring);
var
  u: UTF8String;
begin
{$IFDEF UNICODE}
  u := UTF8String(str);
{$ELSE}
  u := UTF8Encode(str);
{$ENDIF}
  FResponse.Write(PAnsiChar(u)^, Length(u));
end;

var
  Msg      : TMsg;
  wndClass : TWndClass;

begin
  CefLoadLib('');
  Assert(CefRegisterScheme('client', '', TScheme));
  //navigateto := 'client://static/pouet.html';
  try
    wndClass.style          := CS_HREDRAW or CS_VREDRAW;
    wndClass.lpfnWndProc    := @CefWndProc;
    wndClass.cbClsExtra     := 0;
    wndClass.cbWndExtra     := 0;
    wndClass.hInstance      := hInstance;
    wndClass.hIcon          := LoadIcon(0, IDI_APPLICATION);
    wndClass.hCursor        := LoadCursor(0, IDC_ARROW);
    wndClass.hbrBackground  := 0;
    wndClass.lpszMenuName   := nil;
    wndClass.lpszClassName  := 'chromium';

    RegisterClass(wndClass);

    Window := CreateWindow(
      'chromium',             // window class name
      'Chromium browser',     // window caption
      WS_OVERLAPPEDWINDOW or WS_CLIPCHILDREN,    // window style
      Integer(CW_USEDEFAULT), // initial x position
      Integer(CW_USEDEFAULT), // initial y position
      Integer(CW_USEDEFAULT), // initial x size
      Integer(CW_USEDEFAULT), // initial y size
      0,                      // parent window handle
      0,                      // window menu handle
      hInstance,              // program instance handle
      nil);                   // creation parameters

    ShowWindow(Window, SW_SHOW);
    UpdateWindow(Window);

    while(GetMessageW(msg, 0, 0, 0)) do
    begin
      TranslateMessage(msg);
      DispatchMessageW(msg);
    end;
  finally
    handl := nil;
  end;
end.
