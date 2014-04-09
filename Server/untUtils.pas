unit untUtils;
interface
uses
  Windows;

procedure Log(strMessage:PChar);

implementation

procedure Log(strMessage:PChar);
begin
  {$IFDEF DEBUG}
    OutputDebugString(strMessage);
  {$ENDIF}
end;
end.
