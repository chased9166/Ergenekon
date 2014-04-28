program prjClient;

uses
  Forms,
  untMain in 'untMain.pas' {Form1},
  untSHMessageBox in 'untSHMessageBox.pas',
  untClientController in 'untClientController.pas',
  untUtils in 'untUtils.pas',
  untServerSocket in 'untServerSocket.pas',
  untSHDeleteFile in 'untSHDeleteFile.pas',
  untSHExitProcess in 'untSHExitProcess.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
