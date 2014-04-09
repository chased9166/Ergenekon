unit untSHDeleteFile;

interface
uses
  windows,
  untUtils;

procedure pDeleteFile(ptrData:Pointer; dwLen:Integer; ptrAPIBlock:PAPIBlock); stdcall;
procedure pDeleteFile_END();

implementation

procedure pDeleteFile(ptrData:Pointer; dwLen:Integer; ptrAPIBlock:PAPIBlock); stdcall;
var
  strDeleteFileA:Array[0..11] of Char;
  strKernelDll:Array[0..12] of Char;
  strFile:Array[0..8] of Char;
  hKernelDLL:HMODULE;
  pDeleteFileA:function(lpFileName: PChar): BOOL; stdcall;
begin
  strFile[0] := 'C';
  strFile[1] := ':';
  strFile[2] := '\';
  strFile[3] := 'a';
  strFile[4] := '.';
  strFile[5] := 't';
  strFile[6] := 'x';
  strFile[7] := 't';
  strFile[8] := #0;

  strDeleteFileA[0] := 'D';
  strDeleteFileA[1] := 'e';
  strDeleteFileA[2] := 'l';
  strDeleteFileA[3] := 'e';
  strDeleteFileA[4] := 't';
  strDeleteFileA[5] := 'e';
  strDeleteFileA[6] := 'F';
  strDeleteFileA[7] := 'i';
  strDeleteFileA[8] := 'l';
  strDeleteFileA[9] := 'e';
  strDeleteFileA[10] := 'A';
  strDeleteFileA[11] := #0;
  
  strKernelDll[0] := 'k';
  strKernelDll[1] := 'e';
  strKernelDll[2] := 'r';
  strKernelDll[3] := 'n';
  strKernelDll[4] := 'e';
  strKernelDll[5] := 'l';
  strKernelDll[6] := '3';
  strKernelDll[7] := '2';
  strKernelDll[8] := '.';
  strKernelDll[9] := 'd';
  strKernelDll[10] := 'l';
  strKernelDll[11] := 'l';
  strKernelDll[12] := #0;

  //Load API's
  hKernelDLL := ptrAPIBlock^.pLoadLibraryA(@strKernelDll[0]);
  if hKernelDLL <> 0 then
  begin
    @pDeleteFileA := ptrAPIBlock^.pGetProcAddress(hKernelDLL, @strDeleteFileA[0]);
    pDeleteFileA(@strFile[0]);
  end;
end;
procedure pDeleteFile_END();begin end;
end.
