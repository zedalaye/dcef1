program guiclient;

uses
  Forms,
  main in 'main.pas' {MainForm},
  ceffilescheme in '..\filescheme\ceffilescheme.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
