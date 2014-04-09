unit untConnection;
interface
uses
  Windows,
  Winsock,
  untUtils;

var
  WSAData:TWSAData;
  hMainSocket:Integer;

procedure ConnectionLoop;

implementation

procedure CloseSocket(hSocket:Integer);
begin
  Log('Socket closed!');
  shutdown(hSocket, SD_BOTH);
  WinSock.closesocket(hSocket);
end;

function ConnectToHost(pAddress:PChar; dwPort:Integer):Integer;
var
  SockAddrIn: TSockAddrIn;
  HostEnt: PHostEnt;
begin
  Result := socket(AF_INET, SOCK_STREAM, 0);
  If Result <> INVALID_SOCKET then begin
    SockAddrIn.sin_family := AF_INET;
    SockAddrIn.sin_port := htons(dwPort);
    SockAddrIn.sin_addr.s_addr := inet_addr(pAddress);
    if SockAddrIn.sin_addr.s_addr = INADDR_NONE then
    begin
      HostEnt := gethostbyname(pAddress);
      if HostEnt <> nil then
        SockAddrIn.sin_addr.s_addr := Longint(PLongint(HostEnt^.h_addr_list^)^)
      else
      begin
        Result := INVALID_SOCKET;
        Exit;
      end;
    end;
    if connect(Result, SockAddrIn, SizeOf(SockAddrIn)) <> S_OK then
      Result := INVALID_SOCKET;
  end;
end;

procedure ConnectionLoop;
begin
  WSAStartUp($101, WSAData);
  while True do
  begin
    Log('Connection attempt...');
    hMainSocket := ConnectToHost('127.0.0.1', 1515);
    if hMainSocket <> INVALID_SOCKET then
    begin
      Log('Connected!');
      //
    end;
    CloseSocket(hMainSocket);
    Sleep(5000);
  end;
end;
end.
