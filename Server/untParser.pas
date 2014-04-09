unit untParser;

interface
uses
  Windows,
  Winsock;

procedure ParsePacket(mSocket:Integer; mBuff:PWideChar; dwLen:Integer; bCMD:Byte);

implementation

procedure ParsePacket(mSocket:Integer; mBuff:PWideChar; dwLen:Integer; bCMD:Byte);
begin

end;
end.
