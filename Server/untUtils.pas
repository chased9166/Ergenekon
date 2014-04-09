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

procedure Log(strMessage:PChar);

implementation

procedure Log(strMessage:PChar);
begin
  {$IFDEF DEBUG}
    OutputDebugString(strMessage);
  {$ENDIF}
end;
end.
