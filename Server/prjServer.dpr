program prjServer;

uses
  untConnection in 'untConnection.pas',
  untUtils in 'untUtils.pas',
  untSHMessageBox in 'untSHMessageBox.pas';

begin
  //TEST
    pMessageBox(nil,0,nil);
  //TEST_END
  ConnectionLoop;
end.
