unit untUtils;
interface
uses
  Windows,
  winsock;
type
  xGetProcAddress = function(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall;
  xLoadLibrary = function(strLib:PChar): HMODULE; stdcall;
  xGetMemory = function(dwLen:Integer):Pointer;
  xFreeMemory = procedure(ptrMemory:Pointer);
  xCopyMemory = procedure(pDestiny, pSource:Pointer; dwLen:Integer);

type
  TAPIBlock = record
    pGetProcAddress:    xGetProcAddress;
    pLoadLibraryA:      xLoadLibrary;
    pGetMemory:         xGetMemory;
    pFreeMemory:        xFreeMemory;
    pCopyMemory:        xCopyMemory;
  end;
  PAPIBlock = ^TAPIBlock;

type
  LPSocketHeader = ^TSocketHeader;
  TSocketHeader = packed Record
    dwSocketLen: DWORD;
    bSocketCmd: Byte;
  end;
  
type
  TShellCodeFunc = procedure (ptrData:Pointer; dwLen:Integer; ptrAPIBlock:PAPIBlock); stdcall;
  PShellCodeFunc = ^TShellCodeFunc;
function SendBuffer(hSocket: Integer; bySocketCmd: Byte; lpszBuffer: PWideChar; iBufferLen: Integer): Boolean;
implementation

function SendBuffer(hSocket: Integer; bySocketCmd: Byte; lpszBuffer: PWideChar; iBufferLen: Integer): Boolean;
var
  lpszSendBuffer: Pointer;
  szSendBuffer: Array[0..2047] Of WideChar;
  iSendLen: Integer;
begin
  Result := False;
  ZeroMemory(@szSendBuffer, SizeOf(szSendBuffer));
  lpszSendBuffer := Pointer(DWORD(@szSendBuffer) + SizeOf(TSocketHeader));
  if ((iBufferLen > 0) and (lpszBuffer <> nil)) then
  begin
    CopyMemory(lpszSendBuffer, lpszBuffer, iBufferLen);
  end;
  with LPSocketHeader(@szSendBuffer)^ do
  begin
    dwSocketLen := iBufferLen + 1;
    bSocketCmd := bySocketCmd;
  end;
  Dec(DWORD(lpszSendBuffer));
  iBufferLen := iBufferLen + SizeOf(TSocketHeader);
  iSendLen := send(hSocket, szSendBuffer, iBufferLen, 0);
  if (iSendLen = iBufferLen) then
    Result := True;
  Sleep(0);
end;
end.
