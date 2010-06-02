program guiclient;

uses
  Forms,
  main in 'main.pas' {Form4},
  cef in 'cef.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
