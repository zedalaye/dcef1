{$APPTYPE CONSOLE}

program cefconsole;

uses
  ceflib;

type
  TCustomClient = class(TCefClientOwn)
  private
    FLoad: ICefBase;
  protected
    function GetLoadHandler: ICefBase; override;
  public
    constructor Create; override;
  end;

  TCustomLoad = class(TCefLoadHandlerOwn)
  protected
    procedure OnLoadEnd(const browser: ICefBrowser; const frame: ICefFrame;
      httpStatusCode: Integer); override;
  end;

{ TCustomLoad }

procedure TCustomLoad.OnLoadEnd(const browser: ICefBrowser;
  const frame: ICefFrame; httpStatusCode: Integer);
begin
  if frame.IsMain then
  begin
    if httpStatusCode <> 200 then
    begin
      Writeln(httpStatusCode);
      Exit;
    end;
    write(frame.Text);
  end;
end;

{ TCustomClient }

constructor TCustomClient.Create;
begin
  inherited;
  FLoad := TCustomLoad.Create;
end;

function TCustomClient.GetLoadHandler: ICefBase;
begin
  Result := FLoad;
end;

{ TCustomLoad }

var
  info: TCefWindowInfo;
  handl: ICefBase = nil;
  settings: TCefBrowserSettings;
begin
  FillChar(settings, sizeof(settings), 0);
  settings.size := sizeof(settings);
  handl := TCustomClient.Create;
  try
    FillChar(info, SizeOf(info), 0);
    info.Width := 1024;
    info.Height := 768;
    info.m_bWindowRenderingDisabled := True;
    CefBrowserCreate(@info, handl.Wrap, 'http://www.google.com', @settings);
    ReadLn;
  finally
    handl := nil;
  end;
end.
