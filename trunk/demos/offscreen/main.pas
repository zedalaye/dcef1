unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cefvcl, ceflib, cefgui, GR32_Image, AppEvnts;

type
  TMainform = class(TForm)
    PaintBox: TPaintBox32;
    chrmosr: TChromiumOSR;
    AppEvents: TApplicationEvents;
    procedure chrmosrPaint(Sender: TObject; const browser: ICefBrowser;
      kind: TCefPaintElementType; dirtyRectsCount: Cardinal;
      const dirtyRects: PCefRectArray; const buffer: Pointer);
    procedure PaintBoxResize(Sender: TObject);
    procedure PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure AppEventsMessage(var Msg: tagMSG; var Handled: Boolean);
    procedure chrmosrCursorChange(Sender: TObject; const browser: ICefBrowser;
      cursor: HICON);
  end;

var
  Mainform: TMainform;

implementation

{$R *.dfm}

procedure TMainform.AppEventsMessage(var Msg: tagMSG; var Handled: Boolean);
var
  info: TCefKeyInfo;
  typ: TCefKeyType;
begin
  case Msg.message of
    WM_CHAR:
      begin
        typ := KT_CHAR;
        info.sysChar := False;
        info.imeChar := False;
      end;
    WM_KEYDOWN:
      begin
        typ := KT_KEYDOWN;
        info.sysChar := False;
        info.imeChar := False;
      end;
    WM_KEYUP:
      begin
        typ := KT_KEYUP;
        info.sysChar := False;
        info.imeChar := False;
      end;

    WM_SYSCHAR:
      begin
        typ := KT_CHAR;
        info.sysChar := True;
        info.imeChar := False;
      end;
    WM_SYSKEYDOWN:
      begin
        typ := KT_KEYDOWN;
        info.sysChar := True;
        info.imeChar := False;
      end;
    WM_SYSKEYUP:
      begin
        typ := KT_KEYUP;
        info.sysChar := True;
        info.imeChar := False;
      end;

    WM_IME_CHAR:
      begin
        typ := KT_CHAR;
        info.sysChar := False;
        info.imeChar := True;
      end;
    WM_IME_KEYDOWN:
      begin
        typ := KT_KEYDOWN;
        info.sysChar := False;
        info.imeChar := True;
      end;
    WM_IME_KEYUP:
      begin
        typ := KT_KEYUP;
        info.sysChar := False;
        info.imeChar := True;
      end;

    WM_MOUSEWHEEL:
      begin
        with TWMMouseWheel(Pointer(@Msg.message)^) do
          chrmosr.Browser.SendMouseWheelEvent(XPos, YPos, WheelDelta, 0);
        Exit;
      end
  else
    Exit;
  end;
  info.key := Msg.wParam;
  chrmosr.Browser.SendKeyEvent(typ, info, Msg.lParam);
end;

procedure TMainform.chrmosrCursorChange(Sender: TObject;
  const browser: ICefBrowser; cursor: HICON);
begin
  SetCursor(cursor)
end;

procedure TMainform.chrmosrPaint(Sender: TObject; const browser: ICefBrowser;
  kind: TCefPaintElementType; dirtyRectsCount: Cardinal;
    const dirtyRects: PCefRectArray; const buffer: Pointer);
var
  src, dst: PByte;
  offset, i, j, w: Integer;
  vw, vh: Integer;
begin
  chrmosr.Browser.GetSize(PET_VIEW, vw, vh);
  with PaintBox.Buffer do
    if (vw = Width) and (vh = Height) then
    begin
      PaintBox.Canvas.Lock;
      Lock;
      try
//        Move(buffer^, Bits^, vw * vh * 4);
//        PaintBox.Invalidate;
        for j := 0 to dirtyRectsCount - 1 do
        begin
          w := Width * 4;
          offset := ((dirtyRects[j].y * Width) + dirtyRects[j].x) * 4;
          src := @PByte(buffer)[offset];
          dst := @PByte(Bits)[offset];
          offset := dirtyRects[j].width * 4;
          for i := 0 to dirtyRects[j].height - 1 do
          begin
            Move(src^, dst^, offset);
            Inc(dst, w);
            Inc(src, w);
          end;
          PaintBox.Flush(Rect(dirtyRects[j].x, dirtyRects[j].y,
            dirtyRects[j].x + dirtyRects[j].width,  dirtyRects[j].y + dirtyRects[j].height));
        end;
      finally
        Unlock;
        PaintBox.Canvas.Unlock;
      end;
    end;
end;

procedure TMainform.PaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    mbLeft: chrmosr.Browser.SendMouseClickEvent(X, Y, MBT_LEFT, False, 1);
    mbRight: chrmosr.Browser.SendMouseClickEvent(X, Y, MBT_RIGHT, False, 1);
    mbMiddle: chrmosr.Browser.SendMouseClickEvent(X, Y, MBT_MIDDLE, False, 1);
  end;
end;

procedure TMainform.PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  chrmosr.Browser.SendMouseMoveEvent(X, Y, not PaintBox.MouseInControl);
end;

procedure TMainform.PaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    mbLeft: chrmosr.Browser.SendMouseClickEvent(X, Y, MBT_LEFT, True, 1);
    mbRight: chrmosr.Browser.SendMouseClickEvent(X, Y, MBT_RIGHT, True, 1);
    mbMiddle: chrmosr.Browser.SendMouseClickEvent(X, Y, MBT_MIDDLE, True, 1);
  end;
end;

procedure TMainform.PaintBoxResize(Sender: TObject);
begin
  PaintBox.Buffer.SetSize(PaintBox.Width, PaintBox.Height);
  chrmosr.browser.SetSize(PET_VIEW, PaintBox.Width, PaintBox.Height);
  chrmosr.Browser.SendFocusEvent(True);
  Application.ProcessMessages;
end;

initialization
  CefCache := 'cache';

end.
